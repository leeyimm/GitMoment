//
//  GTMFollowUserCell.swift
//  GitMoment
//
//  Created by liying on 24/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

enum GTMFollowType {
    case follow
    case unfollow
}

class GTMFollowUserCell: GTMTableViewCell {
    
    var avatarImageView = UIImageView()
    var nameLabel = UILabel(fontSize: 24)
    var followButton = UIButton(type: .system)
    

    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.setupUI()
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setupUI() {
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(followButton)
        
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.width.equalTo(45)
            make.left.equalTo(10)
        }
        
        followButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.equalTo(60)
            make.height.equalTo(44)
            make.right.equalTo(self.snp.right).offset(-15)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.right.equalTo(followButton.snp.left).offset(-8)
        }
        
    }
    
    func updateUIWithUser(user: GTMGithubUser) {
        self.nameLabel.text = user.login ?? ""
        if let urlString = user.avatarUrl {
            self.avatarImageView.kf.setImage(with: URL(string: urlString))
        }
    }
    
    func setButtonType(type: GTMFollowType) {
        switch type {
        case .follow:
            self.followButton.setTitle("Follow", for: .normal)
            self.followButton.backgroundColor = UIColor(hex: "66bb66")
        default:
            self.followButton.setTitle("Unfollow", for: .normal)
            self.followButton.backgroundColor = UIColor(hex: "a5d6a7")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
