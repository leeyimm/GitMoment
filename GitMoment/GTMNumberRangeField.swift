//
//  GTMNumberRangeField.swift
//  GitMoment
//
//  Created by liying on 15/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMNumberRangeField: UIView {
    
    var lowerField = UITextField()
    var upperField = UITextField()
    var dotLabel = UILabel(fontSize: 13, textColor: UIColor.lightGray, backgroundColor: UIColor.clear)
    
    var rangeString : String? { get {
        let lower = lowerField.text ?? ""
        let upper = upperField.text ?? ""
        if !lower.isEmpty, !upper.isEmpty {
            return lower + ".." + upper
        } else {
            if !lower.isEmpty {
                return ">" + lower
            }
            if !upper.isEmpty {
                return "<" + upper
            }
            return nil
        }        
        }
    }
    init() {
        super.init(frame: CGRect.zero)
        configure(textField: lowerField)
        configure(textField: upperField)

        dotLabel.text = ".."
        dotLabel.sizeToFit()
        addSubview(lowerField)
        addSubview(upperField)
        addSubview(dotLabel)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        lowerField.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.width.equalTo(self).dividedBy(2).offset(-10)
            make.centerY.equalTo(self)
            make.left.equalTo(self)
        }
        upperField.snp.makeConstraints { (make) in
            make.height.equalTo(self)
            make.width.equalTo(lowerField)
            make.centerY.equalTo(self)
            make.right.equalTo(self)
        }
        dotLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
    }
    
    
    func configure(textField: UITextField) {
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
