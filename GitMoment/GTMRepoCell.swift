//
//  GTMRepoCell.swift
//  GitMoment
//
//  Created by liying on 15/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import OcticonsSwift
import SnapKit

class GTMRepoCell: GTMTableViewCell {
    static let height : CGFloat = 90
    
    var titleLabel : UILabel = UILabel(boldFontSize: 18, textColor: UIColor(hex: "#0d47a1"), backgroundColor: UIColor.clear)
    var descritionLabel : UILabel = UILabel(fontSize: 14)
    var ownerLabel : UILabel = UILabel(fontSize: 12)
    var ownerIcon : UIImageView = UIImageView(image: UIImage(octiconsID: .person, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 15, height: 15)))
    var starLabel : UILabel = UILabel(fontSize: 12)
    var starIcon : UIImageView = UIImageView(image: UIImage(octiconsID: .star, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 15, height: 15)))
    var forkLabel : UILabel = UILabel(fontSize: 12)
    var forkIcon : UIImageView = UIImageView(image: UIImage(octiconsID: .repoForked, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 15, height: 15)))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupUI() {
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descritionLabel)
        self.contentView.addSubview(self.ownerLabel)
        self.contentView.addSubview(self.ownerIcon)
        self.contentView.addSubview(self.starLabel)
        self.contentView.addSubview(self.starIcon)
        self.contentView.addSubview(self.forkLabel)
        self.contentView.addSubview(self.forkIcon)
        
        self.descritionLabel.numberOfLines = 2
        
        self.descritionLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView).offset(2)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.descritionLabel.snp.top).offset(-8)
            make.left.equalTo(self.contentView).offset(10)
        }
        
        self.ownerIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.descritionLabel.snp.bottom).offset(8)
        }
        
        self.ownerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.ownerIcon.snp.right).offset(5)
            make.centerY.equalTo(self.ownerIcon)
        }
        
        self.starIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.ownerIcon)
            make.centerX.equalTo(self.contentView.snp.centerX).offset(65)
        }
        
        self.starLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.starIcon)
            make.right.equalTo(self.starIcon.snp.left).offset(-4)
        }
        
        self.forkIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView.snp.right).offset(-8)
            make.centerY.equalTo(self.starIcon)
        }
        
        self.forkLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.forkIcon)
            make.right.equalTo(self.forkIcon.snp.left).offset(-4)
        }
    }
    
    func updateUIWithRepo(repo: GTMRepository) {
        self.titleLabel.text = repo.name
        self.descritionLabel.text = repo.description
        self.ownerLabel.text = repo.owner?.login
        self.starLabel.text = "\(repo.stargazersCount ?? 0)"
        self.forkLabel.text = "\(repo.forksCount ?? 0)"
    }

}
