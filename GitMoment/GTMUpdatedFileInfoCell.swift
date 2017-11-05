//
//  GTMUpdatedFileInfoCell.swift
//  GitMoment
//
//  Created by liying on 05/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMUpdatedFileInfoCell: GTMTableViewCell {
    var additionsLabel = UILabel(fontSize: 12, textColor: UIColor(hex:"#4caf50"), backgroundColor: UIColor.clear)
    var deletionsLabel = UILabel(fontSize: 12, textColor: UIColor(hex:"#ff5252"), backgroundColor: UIColor.clear)
    var fileNameLabel = UILabel(fontSize: 15, textColor: UIColor(hex:"#212121"), backgroundColor: UIColor.clear)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setupUI() {
        super.setupUI()
        self.contentView.addSubview(self.additionsLabel)
        self.contentView.addSubview(self.deletionsLabel)
        self.contentView.addSubview(self.fileNameLabel)
        
        self.additionsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(6)
        }
        
        self.deletionsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.additionsLabel.snp.right).offset(15)
            make.centerY.equalTo(self.additionsLabel)
        }
        
        self.fileNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.additionsLabel.snp.bottom).offset(3)
        }
    }
    
    func updateUIWith(fileInfo: GTMUpdatedFileInfo) {
        if fileInfo.additions != 0 {
            self.additionsLabel.text = "+\(fileInfo.additions!)"
        }
        if fileInfo.deletions != 0 {
            self.deletionsLabel.text = "-\(fileInfo.deletions!)"
            if self.additionsLabel.text == nil {
                self.deletionsLabel.snp.updateConstraints({ (make) in
                    make.left.equalTo(self.additionsLabel.snp.right).offset(0)
                })
            }
        }
        self.fileNameLabel.text = fileInfo.filename
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
