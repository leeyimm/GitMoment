//
//  GTMIssueSectionModel.swift
//  GitMoment
//
//  Created by liying on 03/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

protocol GTMSectionModel {
    func cellForRow(at: IndexPath, tableView: UITableView) -> UITableViewCell
    func numberOfRow() -> Int
    func heightForRow(at: Int) -> CGFloat
    var htmlContentHeight: CGFloat { get set}
}

class GTMIssueSectionModel: GTMSectionModel {
    var issue : GTMIssue
    var titleHeight : CGFloat = 0
    var htmlContentHeight : CGFloat = 0
    init(issue: GTMIssue) {
        self.issue = issue
    }
    func numberOfRow() -> Int {
        return 3
    }
    func cellForRow(at: IndexPath, tableView: UITableView) -> UITableViewCell {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.htmlContentCellIdentifier, for: at) as! GTMHTMLContentCell
            cell.sectionModel = self
            if cell.finishLoading == false {
                cell.loadContent(original: self.issue.body)
                cell.didFinishLoadAction = {
                    tableView.reloadData()
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    func heightForRow(at: Int) -> CGFloat {
        switch at {
        case 0:
            return 50
        case 1:
            return 50
        case 2:
            return self.htmlContentHeight
        default:
            return 0
        }
    }
}

class GTMCommentSectionModel: GTMSectionModel {
    var comment : GTMComment
    var htmlContentHeight : CGFloat = 0
    init(comment : GTMComment) {
        self.comment = comment
    }
    func numberOfRow() -> Int {
        return 2
    }
    func cellForRow(at: IndexPath, tableView: UITableView) -> UITableViewCell {
        switch at.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.authorInfoCellIdentifier, for: at) as! GTMCommentAuthorCell
            cell.updateUIWith(author: self.comment.user!, createTime: self.comment.createdAt!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: GTMConstantValue.htmlContentCellIdentifier, for: at) as! GTMHTMLContentCell
            cell.sectionModel = self
            if cell.finishLoading == false {
                cell.loadContent(original: self.comment.body)
                cell.didFinishLoadAction = {
                    tableView.reloadData()
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    func heightForRow(at: Int) -> CGFloat {
        switch at {
        case 0:
            return 50
        case 1:
            return self.htmlContentHeight
        default:
            return 0
        }
    }
}
