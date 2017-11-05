//
//  GTMCommentCell.swift
//  GitMoment
//
//  Created by liying on 02/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import WebKit

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
        }
    }
    
    func updateUIWith(issue: GTMIssueBase) {
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
        
        self.setSeparatedLine(type: .upper, indent: 0)
        self.setSeparatedLine(type: .lower, indent: 15)
        self.authorIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(25)
            make.centerY.equalTo(self.contentView)
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

