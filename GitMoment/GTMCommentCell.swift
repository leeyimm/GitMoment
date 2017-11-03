//
//  GTMCommentCell.swift
//  GitMoment
//
//  Created by liying on 02/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import WebKit
import MarkdownView

class GTMIssueHeaderCell : GTMTableViewCell {
    var stateLabel = UILabel(fontSize: 13)
    var titleLabel = UILabel(boldFontSize: 14, textColor: UIColor.black, backgroundColor: UIColor.clear)
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func setupUI() {
        self.contentView.addSubview(self.stateLabel)
        self.contentView.addSubview(self.titleLabel)
        
        self.stateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(15)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.stateLabel.snp.bottom).offset(10)
            make.left.equalTo(self.stateLabel)
            make.bottom.equalTo(self.contentView).offset(-8)
        }
    }
    
    func updateUIWith(issue: GTMIssue) {
        self.stateLabel.text = issue.state.rawValue
        self.titleLabel.text = issue.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GTMCommentAuthorCell: GTMTableViewCell {

    var authorIcon = UIImageView()
    var authorNameLabel = UILabel(fontSize: 12, textColor: UIColor.black, backgroundColor: UIColor.clear)
    var createdTimeLabel = UILabel(fontSize: 11, textColor: UIColor.black, backgroundColor: UIColor.clear)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        self.contentView.addSubview(self.authorIcon)
        self.contentView.addSubview(self.authorNameLabel)
        self.contentView.addSubview(self.createdTimeLabel)
        
        self.authorIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(25)
            make.centerY.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-8)
        }
        
        self.authorNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(self.authorIcon.snp.right).offset(10)
        }
        
        self.createdTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.authorNameLabel.snp.bottom).offset(5)
            make.left.equalTo(self.authorNameLabel)
        }
    }
    
    func updateUIWith(author: GTMUser, createTime: String) {
        self.authorIcon.kf.setImage(with: URL(string: author.avatarUrl!))
        self.authorNameLabel.text = author.login
        self.createdTimeLabel.text = createTime
    }

}

public typealias HTMLFinishLoadClosure = () -> ()

class GTMHTMLContentCell : GTMTableViewCell {
    var markdownView : MarkdownView!
    var finishLoading : Bool
    var didFinishLoadAction: HTMLFinishLoadClosure?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.finishLoading = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.markdownView = MarkdownView()
        self.contentView.addSubview(self.markdownView)
        self.markdownView.isScrollEnabled = false
        self.markdownView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
            make.height.equalTo(0)
            make.bottom.equalTo(self.contentView)
        }
        self.markdownView.onRendered = { [weak self] (height) in
            if let weak = self {
                weak.finishLoading = true
                print("onRendered height: \(height)")
                var webFrame = weak.markdownView.frame
                webFrame.size.height = height
                weak.markdownView.snp.updateConstraints ({ (make) in
                    make.height.equalTo(height)
                })
                weak.contentView.setNeedsUpdateConstraints()
                if weak.didFinishLoadAction != nil {
                    weak.didFinishLoadAction!()
                    weak.didFinishLoadAction = nil
                }
//                weak.markdownView.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
//                    if let h = height as? String{
//                        print("height is \(h)")
//                    }
//                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadContent(original: String?) {
        self.markdownView.load(markdown: original)
    }
}
