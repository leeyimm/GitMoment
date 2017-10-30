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
    
    var userInfo : GTMGithubUser?
    var backgroundAvatarImageView = UIImageView()
    var frontAvatarImageView = UIImageView()
    var usernameLabel = UILabel()
    var threeButtonView : GTMThreeButtonView!

    

    init(delegate: GTMThreeButtonViewDelegate) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.addSubview(backgroundAvatarImageView)
        self.addSubview(frontAvatarImageView)
        self.addSubview(usernameLabel)
        
        self.threeButtonView = GTMThreeButtonView(leftTitle: "followers", middleTitle: "repositories", rightTitle: "following")
        self.threeButtonView.delegate = delegate
        self.addSubview(self.threeButtonView)
        
        backgroundAvatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(UIScreen.main.bounds.width)
            make.centerX.top.equalTo(self)
        }
        
        frontAvatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-15)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.frontAvatarImageView.snp.bottom).offset(8)
        }
        
        threeButtonView.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.centerX.equalTo(self)
            make.top.equalTo(backgroundAvatarImageView.snp.bottom)
            make.height.equalTo(60)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUserInfo(user: GTMGithubUser) {
        self.userInfo = user
        if let user = self.userInfo {
            self.usernameLabel.text = user.name
            self.backgroundAvatarImageView.kf.setImage(with: URL(string: user.avatarUrl!))
            self.frontAvatarImageView.kf.setImage(with: URL(string: user.avatarUrl!))
            self.threeButtonView.updateButtonsUpperTitle(left: "\(user.followers ?? 0)", middle: "\(user.publicRepos ?? 0)", right: "\(user.following ?? 0)")
            self.invalidateIntrinsicContentSize()
        }
        self.setNeedsUpdateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        if (self.userInfo?.isOrganization ?? false) {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width + 60)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
