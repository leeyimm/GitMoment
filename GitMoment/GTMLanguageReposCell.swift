//
//  GTMLanguageReposCell.swift
//  GitMoment
//
//  Created by liying on 25/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMLanguageReposCell: GTMTableViewCell {
    
    var reposRankingInfo : GTMLanguageReposRankingInfo!
    var userInfo : GTMUserRankingInfo!

    var languageLabel = UILabel()
    var starIcon = UIImageView(image: UIImage(octiconsID: .star, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 20, height: 20)))
    var repoIcon = UIImageView(image: UIImage(octiconsID: .repo, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 20, height: 20)))
    var starCountLabel = UILabel()
    var repoCountLabel = UILabel()
    
    var worldLabel = UILabel(fontSize: 14, textColor: UIColor(hex: "3f51b5"), backgroundColor: UIColor.clear)
    var worldRankingLabel = UILabel(fontSize: 15, textColor: UIColor(hex: "3f51b5"), backgroundColor: UIColor.clear)
    
    var countryLabel = UILabel(fontSize: 14, textColor: UIColor(hex: "3f51b5"), backgroundColor: UIColor.clear)
    var countryRankingLabel = UILabel(fontSize: 15, textColor: UIColor(hex: "3f51b5"), backgroundColor: UIColor.clear)
    
    override func setupUI() {
        self.addSubview(languageLabel)
        self.addSubview(starIcon)
        self.addSubview(repoIcon)
        self.addSubview(starCountLabel)
        self.addSubview(repoCountLabel)
        
        self.addSubview(worldLabel)
        self.addSubview(worldRankingLabel)
        
        self.addSubview(countryLabel)
        self.addSubview(countryRankingLabel)
        
        languageLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
        }
        
        starIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(languageLabel)
        }
        
        starCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(starIcon.snp.left).offset(-6)
            make.centerY.equalTo(starIcon)
        }
        
        repoIcon.snp.makeConstraints { (make) in
            make.right.equalTo(starIcon.snp.left).offset(-90)
            make.centerY.equalTo(starIcon)
        }
        
        repoCountLabel.snp.makeConstraints { (make) in
            make.right.equalTo(repoIcon.snp.left).offset(-6)
            make.centerY.equalTo(repoIcon)
        }
        
        countryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(languageLabel)
            make.top.equalTo(languageLabel.snp.bottom).offset(10)
        }
        
        countryRankingLabel.snp.makeConstraints { (make) in
            make.right.equalTo(starIcon)
            make.centerY.equalTo(countryLabel)
        }
        
        worldLabel.snp.makeConstraints { (make) in
            make.left.equalTo(languageLabel)
            make.top.equalTo(countryLabel.snp.bottom).offset(10)
        }
        
        worldRankingLabel.snp.makeConstraints { (make) in
            make.right.equalTo(starIcon)
            make.centerY.equalTo(worldLabel)
        }
        
    }
    
    func updateCell(reposInfo: GTMLanguageReposRankingInfo, userInfo: GTMUserRankingInfo) {
        self.reposRankingInfo = reposInfo
        self.userInfo = userInfo
        self.languageLabel.text = reposInfo.language ?? ""
        self.starCountLabel.text = "\(reposInfo.starsCount ?? 0)"
        self.repoCountLabel.text = "\(reposInfo.reposCount ?? 0)"
        self.worldLabel.text = "world"
        self.worldRankingLabel.text = "\(reposInfo.worldRank ?? 0)" + "/\(reposInfo.worldCount ?? 0)"
        self.countryRankingLabel.text = "\(reposInfo.countryRank ?? 0)" + "/\(reposInfo.countryCount ?? 0)"
        self.countryLabel.text = userInfo.country ?? ""
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
