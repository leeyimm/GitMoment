//
//  GTMTableViewCell.swift
//  GitMoment
//
//  Created by liying on 25/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

enum GTMTableCellSeparateLineType {
    case upper
    case lower
}

class GTMTableViewCell: UITableViewCell {
    
    var upperSeparateLine = UIView()
    var lowerSeparateLine = UIView()
    var baseTitleLabel = UILabel(fontSize: 13, textColor: UIColor.blue, backgroundColor: UIColor.clear)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.setupSeparateLine()
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.contentView.addSubview(self.baseTitleLabel)
        self.baseTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(15)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSeparateLine() {
        upperSeparateLine.backgroundColor = UIColor(hex: "#dddddd")
        lowerSeparateLine.backgroundColor = UIColor(hex: "#dddddd")
        self.addSubview(upperSeparateLine)
        self.addSubview(lowerSeparateLine)
        upperSeparateLine.isHidden = true
        lowerSeparateLine.isHidden = true
    }
    
    func setSeparatedLine(type: GTMTableCellSeparateLineType, indent: CGFloat)
    {
        switch type {
        case .upper:
            upperSeparateLine.snp.updateConstraints({ (make) in
                make.height.equalTo(1)
                make.left.equalTo(self).offset(indent)
                make.right.equalTo(self)
                make.top.equalTo(self)
            })
            upperSeparateLine.isHidden = false
        case .lower:
            lowerSeparateLine.snp.updateConstraints({ (make) in
                make.height.equalTo(1)
                make.left.equalTo(self).offset(indent)
                make.right.equalTo(self)
                make.bottom.equalTo(self)
            })
            lowerSeparateLine.isHidden = false
        }
    }

}
