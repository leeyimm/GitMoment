//
//  GTMRepoInfoView.swift
//  GitMoment
//
//  Created by liying on 28/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import WebKit

class GTMRepoInfoView: UIView {
    
    var repo: GTMRepository!
    
    var descriptionLabel = UILabel(fontSize: 15, textColor: UIColor.black, backgroundColor: UIColor.white)
    var languageLabel = UILabel(fontSize: 16, textColor: UIColor.black, backgroundColor: UIColor.white)
    var updatedLabel = UILabel(fontSize: 16, textColor: UIColor.black, backgroundColor: UIColor.white)
    var createdLabel = UILabel(fontSize: 16, textColor: UIColor.black, backgroundColor: UIColor.white)
    
    init(repo: GTMRepository) {
        super.init(frame: CGRect.zero)
        self.repo = repo
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.backgroundColor = UIColor.white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = repo.description
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-8)
        }
        
        languageLabel.text = "Language: " + (repo.language ?? "Not set")
        self.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(descriptionLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
        }
        
        updatedLabel.text = "Updated at " + repo.updatedAt!
        self.addSubview(updatedLabel)
        updatedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(descriptionLabel)
            make.top.equalTo(languageLabel.snp.bottom).offset(10)
        }
        
        createdLabel.text = "Created at " + repo.createdAt!
        self.addSubview(createdLabel)
        createdLabel.snp.makeConstraints { (make) in
            make.left.equalTo(descriptionLabel)
            make.top.equalTo(updatedLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self).offset(-8)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class GTMRepoReadMeView : UIView {
    var readmeIcon = UIImageView(image: UIImage(octiconsID: .book, iconColor: UIColor.black, size: CGSize(width: 20, height: 20)))
    var readmeLabel = UILabel(boldFontSize: 14)
    
    var webView = UIWebView()
    var viewReadMeButton = UIButton(title: "View all of README.md", boldFontSize: 14)
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(self.readmeIcon)
        self.readmeIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.height.width.equalTo(20)
        }
        
        self.readmeLabel.text = "README.md"
        self.addSubview(self.readmeLabel)
        self.readmeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(readmeIcon)
            make.left.equalTo(readmeIcon.snp.right).offset(10)
        }
        
        self.webView.isUserInteractionEnabled = false
        self.webView.scrollView.isScrollEnabled = false
        self.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(self.readmeIcon.snp.bottom).offset(10)
            make.height.equalTo(300)
        }
        
        self.addSubview(self.viewReadMeButton)
        self.viewReadMeButton.snp.makeConstraints { (make) in
            make.right.left.equalTo(self.webView)
            make.top.equalTo(self.webView.snp.bottom)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
}
