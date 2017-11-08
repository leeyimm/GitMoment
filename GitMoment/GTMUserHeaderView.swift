//
//  GTMUserHeaderView.swift
//  GitMoment
//
//  Created by liying on 22/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import Kingfisher



class GTMUserHeaderView: UIView {
    
    let heightScale : CGFloat = 0.36
    var upperBackgroundView = UIView()
    var avatarImageView = UIImageView()
    var usernameLabel = UILabel(boldFontSize: 22, textColor: UIColor.black, backgroundColor: UIColor.clear)
    var loginLabel = UILabel()
    var createdLabel = UILabel(fontSize: 13)
    var updatedLabel = UILabel(fontSize: 13)
    var typeLabel = UILabel(fontSize: 13)
    var followButton = GTMFollowButton(followingType: .following)
    var threeButtonView : GTMThreeButtonView!

    

    init(delegate: GTMThreeButtonViewDelegate) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor(hex: "f5f5f5")
        self.upperBackgroundView.backgroundColor = UIColor.white
        self.addSubview(self.upperBackgroundView)
        self.upperBackgroundView.addSubview(avatarImageView)
        self.upperBackgroundView.addSubview(usernameLabel)
        self.upperBackgroundView.addSubview(loginLabel)
        self.upperBackgroundView.addSubview(createdLabel)
        self.upperBackgroundView.addSubview(updatedLabel)
        self.upperBackgroundView.addSubview(typeLabel)
        self.upperBackgroundView.addSubview(followButton)
        self.followButton.isHidden = true
        
        
        self.threeButtonView = GTMThreeButtonView(leftTitle: "followers", middleTitle: "repositories", rightTitle: "following")
        self.threeButtonView.delegate = delegate
        self.addSubview(self.threeButtonView)
        
        upperBackgroundView.snp.makeConstraints { (make) in
            make.height.equalTo(UIScreen.main.bounds.width * heightScale + 16)
            make.top.width.centerX.equalTo(self)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(UIScreen.main.bounds.width * heightScale)
            make.left.equalTo(upperBackgroundView).offset(8)
            make.centerY.equalTo(upperBackgroundView)
        }
        
        createdLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10)
            make.centerY.equalTo(upperBackgroundView).offset(4)
        }
        
        loginLabel.snp.makeConstraints { (make) in
            make.left.equalTo(createdLabel)
            make.bottom.equalTo(createdLabel.snp.top).offset(-6)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(createdLabel)
            make.bottom.equalTo(loginLabel.snp.top).offset(-7)
        }
        
        updatedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(createdLabel)
            make.top.equalTo(createdLabel.snp.bottom).offset(6)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(createdLabel)
            make.top.equalTo(updatedLabel.snp.bottom).offset(10)
        }
        
        followButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(typeLabel)
            make.left.equalTo(typeLabel.snp.right).offset(8)
            make.width.equalTo(55)
        }
        
        threeButtonView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(60)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUserInfo(user: GTMGithubUser) {
        self.usernameLabel.text = user.name
        self.avatarImageView.kf.setImage(with: URL(string: user.avatarUrl!))
        self.loginLabel.text = user.login
        self.createdLabel.text = "created: \(user.createdAt!)"
        self.updatedLabel.text = "updated: \(user.updatedAt!)"
        self.typeLabel.text = "type: \(user.type!)"
        self.threeButtonView.updateButtonsUpperTitle(left: "\(user.followers ?? 0)", middle: "\(user.publicRepos ?? 0)", right: "\(user.following ?? 0)")
        self.threeButtonView.isHidden = user.isOrganization
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        if (self.threeButtonView.isHidden) {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * heightScale + 16)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * heightScale + 61  + 16)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
