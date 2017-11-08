//
//  GTMFollowButton.swift
//  GitMoment
//
//  Created by liying on 07/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMFollowButton: UIButton {
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var followingType : GTMFollowingType
    private var followType : GTMFollowType!
    var type : GTMFollowType {
        set(newValue) {
            self.followType = newValue
            switch newValue {
            case .follow:
                switch followingType {
                case .following:
                    self.setTitle("follow", for: .normal)
                case .starring:
                    self.setTitle("star", for: .normal)
                case .watching:
                    self.setTitle("watch", for: .normal)
                }
            case .unfollow:
                switch followingType {
                case .following:
                    self.setTitle("unfollow", for: .normal)
                case .starring:
                    self.setTitle("unstar", for: .normal)
                case .watching:
                    self.setTitle("unwatch", for: .normal)
                }
            }
        }
        get {
            return self.followType
        }
        
    }
    
    init(followingType: GTMFollowingType) {
        self.followingType = followingType
        super.init(frame: CGRect.zero)
        self.setTitleColor(UIColor(hex: "#42a5f5"), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.setBorder(width: 1, color: UIColor(hex: "#42a5f5"), cornerRadius: 2)
        self.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(self).offset(-4)
        }
        activityIndicator.isHidden = true
    }
    
    
    func startLoading() {
        activityIndicator.isHidden = false
        self.isEnabled = false
        self.activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        self.activityIndicator.stopAnimating()
        self.isEnabled = true
        self.activityIndicator.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
