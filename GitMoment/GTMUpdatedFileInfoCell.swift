//
//  GTMUpdatedFileInfoCell.swift
//  GitMoment
//
//  Created by liying on 05/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMUpdatedFileInfoCell: GTMTableViewCell {

    var fileNameLabel = UILabel(fontSize: 15, textColor: UIColor(hex:"#212121"), backgroundColor: UIColor.clear)
    var statusLabel = UILabel(fontSize: 12, textColor: UIColor(hex:"#212121"), backgroundColor: UIColor.clear)
    var additionsLabel = UILabel(fontSize: 12, textColor: UIColor(hex:"#4caf50"), backgroundColor: UIColor.clear)
    var deletionsLabel = UILabel(fontSize: 12, textColor: UIColor(hex:"#ff5252"), backgroundColor: UIColor.clear)
    var previousFilenameLabel = UILabel(fontSize: 12, textColor: UIColor(hex:"#212121"), backgroundColor: UIColor.clear)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setupUI() {
        super.setupUI()
        self.contentView.addSubview(self.statusLabel)
        self.contentView.addSubview(self.additionsLabel)
        self.contentView.addSubview(self.deletionsLabel)
        self.contentView.addSubview(self.fileNameLabel)
        self.contentView.addSubview(self.previousFilenameLabel)
        
        self.statusLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(6)
        }
        
        self.additionsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.statusLabel.snp.right).offset(10)
            make.centerY.equalTo(self.statusLabel)
        }
        
        self.previousFilenameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.statusLabel.snp.right).offset(10)
            make.centerY.equalTo(self.statusLabel)
        }
        
        self.deletionsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.additionsLabel.snp.right).offset(15)
            make.centerY.equalTo(self.additionsLabel)
        }
        
        self.fileNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.statusLabel.snp.bottom).offset(3)
        }
    }
    
    func updateUIWith(fileInfo: GTMUpdatedFileInfo) {
        switch fileInfo.status! {
        case .added:
            self.statusLabel.text = "added"
        case .removed:
            self.statusLabel.text = "removed"
        case .modified:
            self.statusLabel.text = "moidified"
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
        case .renamed:
            self.statusLabel.text = "renamed"
            self.previousFilenameLabel.text = "from \(fileInfo.previousFilename!)"
        }
        self.fileNameLabel.text = fileInfo.filename
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
