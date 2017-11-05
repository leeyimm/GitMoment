//
//  GTMIssueSectionModel.swift
//  GitMoment
//
//  Created by liying on 03/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import DTCoreText
import MMMarkdown
import SwiftSoup
import Kingfisher

protocol GTMSectionModel  {
    func cellForRow(at: IndexPath, tableView: UITableView) -> UITableViewCell
    func numberOfRow() -> Int
    func heightForRow(at: Int) -> CGFloat
    var attributedContentCell: DTAttributedTextCell! { get set}
    func nextViewController(forRow: Int) -> UIViewController?
}

class GTMBaseSectionModel:NSObject, GTMSectionModel {
    var attributedContentCellHeight : CGFloat = 0
    var attributedContentCell: DTAttributedTextCell!
    var htmlDocument : Document!
    let updateHtmlDocumentQueue = DispatchQueue(label: "com.leeyimm.updateHtmlDocumentQueue")

    func numberOfRow() -> Int {
        return 0
    }
    func cellForRow(at: IndexPath, tableView: UITableView) -> UITableViewCell {
        return UITableViewCell()
    }
    func heightForRow(at: Int) -> CGFloat {
        return 0
    }
    
    func htmlString(fromBody: String?) -> String? {
        if self.htmlDocument != nil {
            return try? self.htmlDocument.html()
        }
        do {
            let bodyString = fromBody ?? "## *No content*"
            let htmlString = try MMMarkdown.htmlString(withMarkdown: bodyString, extensions: [.gitHubFlavored])
            
            self.htmlDocument = try SwiftSoup.parse(htmlString)
            let pngs = try self.htmlDocument.select("img")
            for image in pngs {
                try image.attr("width", "300")
                try image.attr("height", "30")
                let imageUrl = try image.attr("src")
                let url = URL(string: imageUrl)
                switch KingfisherManager.shared.cache.imageCachedType(forKey: (url?.cacheKey)!)  {
                case .none:
                    KingfisherManager.shared.downloader.downloadImage(with: URL(string: imageUrl)! , retrieveImageTask: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, url, date) in
                        guard error == nil else {
                            return
                        }
                        KingfisherManager.shared.cache.store(image!, original: date, forKey: (url?.cacheKey)!)
                        self.updateHtmlDocumentQueue.sync { [unowned self] in
                            self.updateAttributeForImage(downloadedImageURL: url!, image: image!)
                        }
                    })
                case .memory:
                    let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: (url?.cacheKey)!)
                    guard image != nil else {
                        break
                    }
                    self.updateHtmlDocumentQueue.sync { [unowned self] in
                        self.updateAttributeForImage(downloadedImageURL: url!, image: image!)
                    }
                case .disk:
                    let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: (url?.cacheKey)!)
                    guard image != nil else {
                        break
                    }
                    self.updateHtmlDocumentQueue.sync { [unowned self] in
                        self.updateAttributeForImage(downloadedImageURL: url!, image: image!)
                    }
                }

            }
            return try? self.htmlDocument.html()
        } catch {
            print("process html error")
            return nil
        }
    }
    
    func updateAttributeForImage(downloadedImageURL: URL, image: UIImage) {
        var adjustedSize = CGSize(width: UIScreen.main.bounds.width - 10, height: 0)
        adjustedSize.height = image.size.height * adjustedSize.width / image.size.width
        do {
            let images = try self.htmlDocument.select("img")
            for image in images {
                let imageUrl = try image.attr("src")
                if  imageUrl == downloadedImageURL.absoluteString {
                    try image.attr("width", "\(Int(adjustedSize.width))")
                    try image.attr("height", "\(Int(adjustedSize.height))")
                }
            }
        } catch {
            print("process html error")
        }
    }
    
    func nextViewController(forRow: Int) -> UIViewController? {
        return nil
    }
}

extension GTMBaseSectionModel : DTAttributedTextContentViewDelegate {
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
        if attachment is DTImageTextAttachment {
            let url = attachment.contentURL
            switch KingfisherManager.shared.cache.imageCachedType(forKey: (url?.cacheKey)!) {
            case .none:
                let button = UIButton(type: .system)
                button.frame = frame
                button.setTitle("View Image", for: .normal)
                return button
            default:
                let imageView = AnimatedImageView(frame: frame)
                imageView.kf.setImage(with: url!)
                return imageView
            }
        }
        return UIView()
    }
}

class GTMIssueSectionModel: GTMBaseSectionModel {
    
    var issue: GTMIssue
    init(issue: GTMIssue) {
        self.issue = issue
        super.init()
    }
    
    override func heightForRow(at: Int) -> CGFloat {
        switch at {
        case 0:
            return 50
        case 1:
            return 50
        case 2:
            return self.attributedContentCellHeight
        default:
            return 0
        }
    }
    override func numberOfRow() -> Int {
        return 3
    }
    
    override func cellForRow(at: IndexPath, tableView: UITableView) -> UITableViewCell {
        switch at.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.issueHeaderCellIdentifier, for: at) as! GTMIssueHeaderCell
            cell.updateUIWith(issue: self.issue)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.authorInfoCellIdentifier, for: at) as! GTMCommentAuthorCell
            cell.updateUIWith(author: self.issue.user!, createTime: self.issue.createdAt!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.attributedContentCellIdentifier, for: at) as! DTAttributedTextCell
            self.attributedContentCell = cell
            cell.selectionStyle = .none
            cell.attributedTextContextView.shouldDrawImages = true
            cell.attributedTextContextView.delegate = self
            if let html = self.htmlString(fromBody: self.issue.body) {
                cell.setHTMLString(html)
                self.attributedContentCellHeight = self.attributedContentCell.requiredRowHeight(in: tableView)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

class GTMPullRequestSectionModel: GTMBaseSectionModel {
    
    var pullRequest: GTMPullRequest
    init(pullRequest: GTMPullRequest) {
        self.pullRequest = pullRequest
        super.init()
    }
    
    override func heightForRow(at: Int) -> CGFloat {
        switch at {
        case 0:
            return 50
        case 1:
            return 50
        case 2:
            return 40
        case 3:
            return self.attributedContentCellHeight
        default:
            return 0
        }
    }
    override func numberOfRow() -> Int {
        return 4
    }
    
    override func cellForRow(at: IndexPath, tableView: UITableView) -> UITableViewCell {
        switch at.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.issueHeaderCellIdentifier, for: at) as! GTMIssueHeaderCell
            cell.updateUIWith(issue: self.pullRequest)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.authorInfoCellIdentifier, for: at) as! GTMCommentAuthorCell
            cell.updateUIWith(author: self.pullRequest.user!, createTime: self.pullRequest.createdAt!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.baseCellIdentifier, for: at) as! GTMTableViewCell
            cell.baseTitleLabel.text = "check updated files"
            cell.setSeparatedLine(type: .upper, indent: 15)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.attributedContentCellIdentifier, for: at) as! DTAttributedTextCell
            self.attributedContentCell = cell
            cell.selectionStyle = .none
            cell.attributedTextContextView.shouldDrawImages = true
            cell.attributedTextContextView.delegate = self
            if let html = self.htmlString(fromBody: self.pullRequest.body) {
                cell.setHTMLString(html)
                self.attributedContentCellHeight = self.attributedContentCell.requiredRowHeight(in: tableView)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func nextViewController(forRow: Int) -> UIViewController? {
        if forRow == 2 {
            return UIViewController()
        } else {
            return nil
        }
    }
}


class GTMCommentSectionModel: GTMBaseSectionModel {
    var comment : GTMComment
    init(comment : GTMComment) {
        self.comment = comment
    }
    override func numberOfRow() -> Int {
        return 2
    }
    override func cellForRow(at: IndexPath, tableView: UITableView) -> UITableViewCell {
        switch at.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.authorInfoCellIdentifier, for: at) as! GTMCommentAuthorCell
            cell.updateUIWith(author: self.comment.user!, createTime: self.comment.createdAt!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.attributedContentCellIdentifier, for: at) as! DTAttributedTextCell
            self.attributedContentCell = cell
            cell.selectionStyle = .none
            cell.attributedTextContextView.shouldDrawImages = true
            cell.attributedTextContextView.delegate = self
            if let html = self.htmlString(fromBody: self.comment.body) {
                cell.setHTMLString(html)
                self.attributedContentCellHeight = self.attributedContentCell.requiredRowHeight(in: tableView)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    override func heightForRow(at: Int) -> CGFloat {
        switch at {
        case 0:
            return 50
        case 1:
            return self.attributedContentCellHeight
        default:
            return 0
        }
    }
}




