//
//  GTMRepoInfoView.swift
//  GitMoment
//
//  Created by liying on 28/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import WebKit

class GTMRepoDescriptionView : UIView {
    var descriptionLabel = UILabel(fontSize: 15, textColor: UIColor.black, backgroundColor: UIColor.white)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(descriptionLabel)
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.bottom.equalTo(-15)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GTMRepoTopicsView : UIView {
    var topics = [String]()
    var topicLabels = [UILabel]()
    func setTopics(topics: [String]) {
        self.topics = topics
        self.topicLabels.removeAll()
        for topic in topics {
            let topicLabel = UILabel(fontSize: 12, textColor: UIColor.white, backgroundColor: UIColor(hex: "#03a9f4"))
            topicLabel.text = topic
            self.addSubview(topicLabel)
            
            topicLabel.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                if self.topicLabels.count == 0 { //firstLabel
                    make.left.equalTo(20)
                } else {
                    make.left.equalTo(self.topicLabels.last!.snp.right).offset(25)
                }
            })
            self.topicLabels.append(topicLabel)
        }
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        if self.topicLabels.count == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 0)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 60)
        }
    }
}

class GTMRepoInfoView: UIView {
    
    var repo: GTMRepository!
    
    var descriptionView = GTMRepoDescriptionView()
    var topicsView = GTMRepoTopicsView()
    var languagesView = GTMRepoTopicsView()
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
        
        descriptionView.descriptionLabel.text = repo.description ?? "No description"
        self.addSubview(descriptionView)
        descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-8)
        }
        
        self.addSubview(topicsView)
        topicsView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(descriptionView.snp.bottom).offset(10)
        }
        
        self.addSubview(languagesView)
        languagesView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(topicsView.snp.bottom).offset(10)
        }
        
        updatedLabel.text = "Updated at " + repo.updatedAt!
        self.addSubview(updatedLabel)
        updatedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(languagesView.snp.bottom).offset(10)
        }
        
        createdLabel.text = "Created at " + repo.createdAt!
        self.addSubview(createdLabel)
        createdLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
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
