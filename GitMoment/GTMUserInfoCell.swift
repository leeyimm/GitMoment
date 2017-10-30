//
//  GTMUserInfoCell.swift
//  GitMoment
//
//  Created by liying on 24/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

enum GTMUserInfoCellType {
    case company
    case location
    case email
    case link
    case starred
    case wacthing
    case events
    case notification
    case repos
}

class GTMUserInfoCell: GTMTableViewCell {

    var type : GTMUserInfoCellType!
    var iconImageView = UIImageView()
    var label = UILabel(fontSize: 24)
    var iconSize = CGSize(width: 25, height: 25)
    
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
        self.addSubview(label)
        
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(15)
            make.size.equalTo(iconSize)
        }
        
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(iconImageView.snp.right).offset(13)
            make.right.equalTo(self).offset(-10)
        }
    }
    
    func setCellType(type: GTMUserInfoCellType, user: GTMGithubUser) {
        self.type = type
        switch type {
        case .company:
            iconImageView.image = UIImage(octiconsID: .organization, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            label.text = user.company ?? "Not set"
        case .email:
            iconImageView.image = UIImage(octiconsID: .mail, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            label.text = user.email ?? "Not set"
        case .location:
            iconImageView.image = UIImage(octiconsID: .location, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            label.text = user.location ?? "Not set"
        case .link:
            iconImageView.image = UIImage(octiconsID: .link, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            label.text = user.htmlUrl ?? "Not set"
        case .starred:
            iconImageView.image = UIImage(octiconsID: .star, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            label.text = "Starred Repos"
        case .wacthing:
            iconImageView.image = UIImage(octiconsID: .eye, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            label.text = "Watching Repos"
        case .events:
            iconImageView.image = UIImage(octiconsID: .rss, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            label.text = "Events"
        case .notification:
            iconImageView.image = UIImage(octiconsID: .megaphone, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            label.text = "Notifications"
        case .repos:
            iconImageView.image = UIImage(octiconsID: .repo, iconColor: UIColor(hex: "#4183C4"), size: iconSize)
            label.text = "Repos"
        }
    }

}
