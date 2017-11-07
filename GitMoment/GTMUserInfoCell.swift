//
//  GTMInfoCell.swift
//  GitMoment
//
//  Created by liying on 24/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

enum GTMInfoCellType {
    case company
    case location
    case email
    case link
    case starred
    case wacthing
    case events
    case notification
    case repos
    
    case owner
    case readme
    case code
    case contributer
    case issue
    case pr
}

class GTMInfoCell: GTMTableViewCell {

    let iconSize = CGSize(width: 20, height: 20)
    var type : GTMInfoCellType!
    var iconImageView = UIImageView()
    var titleLabel = UILabel(fontSize: 18)
    var subLabel = UILabel(fontSize: 16)
    var arrowIcon = UIImageView(image: UIImage(octiconsID: .chevronRight, iconColor: UIColor(hex:"#bdbdbd"), size: CGSize(width: 15, height: 15)))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        self.setupUI()
//        // Configure the view for the selected state
//    }
    
     override func setupUI() {
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(subLabel)
        self.addSubview(arrowIcon)
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(15)
            make.size.equalTo(iconSize)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(iconImageView.snp.right).offset(13)
            make.right.equalTo(self).offset(-10)
        }
        
        arrowIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-13)
        }
        
        subLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(arrowIcon.snp.left).offset(-10)
        }
        
        self.arrowIcon.isHidden = true
    }
    
    func setCellType(type: GTMInfoCellType, title: String?, subTitle: String? = nil) {
        self.type = type
        switch type {
        case .company:
            iconImageView.image = UIImage(octiconsID: .organization, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = title ?? "Not set"
        case .email:
            iconImageView.image = UIImage(octiconsID: .mail, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = title ?? "Not set"
        case .location:
            iconImageView.image = UIImage(octiconsID: .location, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = title ?? "Not set"
        case .link:
            iconImageView.image = UIImage(octiconsID: .link, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = title ?? "Not set"
        case .starred:
            iconImageView.image = UIImage(octiconsID: .star, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Starred Repos"
            arrowIcon.isHidden = false
        case .wacthing:
            iconImageView.image = UIImage(octiconsID: .eye, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Watching Repos"
            arrowIcon.isHidden = false
        case .events:
            iconImageView.image = UIImage(octiconsID: .rss, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Events"
            arrowIcon.isHidden = false
        case .notification:
            iconImageView.image = UIImage(octiconsID: .megaphone, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Notifications"
        case .repos:
            iconImageView.image = UIImage(octiconsID: .repo, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Repos"
            subLabel.text = subTitle ?? ""
            arrowIcon.isHidden = false
            
        case .owner:
            iconImageView.image = UIImage(octiconsID: .person, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Owner"
            subLabel.text = subTitle ?? ""
            arrowIcon.isHidden = false
        case .readme:
            iconImageView.image = UIImage(octiconsID: .book, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Readme"
            arrowIcon.isHidden = false
        case .code:
            iconImageView.image = UIImage(octiconsID: .fileCode, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Source Code"
            arrowIcon.isHidden = false
        case .contributer:
            iconImageView.image = UIImage(octiconsID: .organization, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Contributors"
            arrowIcon.isHidden = false
        case .issue:
            iconImageView.image = UIImage(octiconsID: .issueOpened, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Issues"
            arrowIcon.isHidden = false
        case .pr:
            iconImageView.image = UIImage(octiconsID: .gitPullRequest, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            titleLabel.text = "Pull Requests"
            arrowIcon.isHidden = false
        }
    }

}
