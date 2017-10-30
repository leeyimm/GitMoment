//
//  GTMUserRankingCell.swift
//  GitMoment
//
//  Created by liying on 24/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import OcticonsSwift
import SnapKit

class GTMUserRankingCell: GTMTableViewCell {
    
    var worldRankingLabel = UILabel(fontSize:12, textColor: UIColor(hex: "#FFFFFF"), backgroundColor: UIColor(hex: "#CCCCCC"))
    var avatarImageView = UIImageView()
    var nameLabel = UILabel(fontSize: 24)
    var starCountLabel = UILabel(fontSize: 14)
    var starIcon : UIImageView = UIImageView(image: UIImage(octiconsID: .star, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 25, height: 25)))
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    override func setupUI() {
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.starCountLabel)
        self.contentView.addSubview(self.starIcon)
        self.contentView.addSubview(self.worldRankingLabel)
        
        self.worldRankingLabel.textAlignment = .center

        self.avatarImageView.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.centerY.equalTo(self.contentView).offset(2)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.avatarImageView)
            make.left.equalTo(self.avatarImageView.snp.right).offset(8)
        }
        
        self.starIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.avatarImageView)
            make.right.equalTo(self.contentView).offset(-10)
        }
        
        self.starCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.starIcon)
            make.right.equalTo(self.starIcon.snp.left).offset(-8)
        }
        
        self.worldRankingLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.size.equalTo(CGSize(width: 36, height: 14))
        }
        
    }

}
