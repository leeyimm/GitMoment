//
//  GTMIssueViewCell.swift
//  GitMoment
//
//  Created by liying on 01/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMIssueViewCell: GTMTableViewCell {
    
    var numberLabel : UILabel = UILabel(boldFontSize: 15, textColor: UIColor(hex: "#0d47a1"), backgroundColor: UIColor.clear)
    var issueIcon = UIImageView()
    var titleLabel : UILabel = UILabel(fontSize: 14)
    var creatorIcon : UIImageView = UIImageView(image: UIImage(octiconsID: .person, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 10, height: 10)))
    var creatorLabel : UILabel = UILabel(fontSize: 10)
    var pencilIcon : UIImageView = UIImageView(image: UIImage(octiconsID: .pencil, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 10, height: 10)))
    var createdLabel : UILabel = UILabel(fontSize: 10)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setupUI() {
        self.contentView.addSubview(self.numberLabel)
        self.contentView.addSubview(self.issueIcon)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.creatorIcon)
        self.contentView.addSubview(self.creatorLabel)
        self.contentView.addSubview(self.pencilIcon)
        self.contentView.addSubview(self.createdLabel)
        
        self.numberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
        }
        self.issueIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.numberLabel)
            make.top.equalTo(self.numberLabel.snp.bottom).offset(10)
            make.width.height.equalTo(15)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.equalTo(self.numberLabel)
            make.right.equalTo(-10)
        }
        
        self.creatorIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.width.height.equalTo(10)
        }
        
        self.creatorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.creatorIcon.snp.right).offset(10)
            make.centerY.equalTo(self.creatorIcon)
        }
        
        self.pencilIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView).offset(30)
            make.centerY.equalTo(self.creatorIcon)
        }
        
        self.createdLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.pencilIcon)
            make.left.equalTo(self.pencilIcon.snp.right).offset(10)
        }
    }
    
    func updateUIWith(issue: GTMIssue) {
        self.numberLabel.text = "\(issue.number!)"
        self.titleLabel.text = issue.title
        self.creatorLabel.text = issue.user?.login
        self.createdLabel.text = issue.createdAt!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
