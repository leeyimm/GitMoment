//
//  GTMFileInfoCell.swift
//  GitMoment
//
//  Created by liying on 31/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMFileInfoCell: GTMTableViewCell {

    var iconImageView = UIImageView()
    var nameLabel = UILabel(fontSize: 24)
    var fileInfo : GTMFileInfo!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func setupUI() {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(nameLabel)
        
        self.iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(30)
        }
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp.right).offset(10)
            make.centerY.equalTo(self.contentView)
        }
    }
    
    func updateWithFile(info :GTMFileInfo) {
        self.fileInfo = info
        self.nameLabel.text = info.name
        switch info.fileType {
        case .file:
            self.iconImageView.image = UIImage(octiconsID: .fileText, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 30, height: 30))
        case .dir:
            self.iconImageView.image = UIImage(octiconsID: .fileDirectory, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 30, height: 30))
        case .symlink:
            self.iconImageView.image = UIImage(octiconsID: .fileSymlinkFile, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 30, height: 30))
        case .submodule:
            self.iconImageView.image = UIImage(octiconsID: .fileSubmodule, iconColor: UIColor(hex: "#4183C4"), size: CGSize(width: 30, height: 30))
        default:
            break
        }
    }
    

}
