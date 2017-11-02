//
//  GTMSelectionSegmentView.swift
//  GitMoment
//
//  Created by liying on 15/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMSelectionSegmentView: UIView {
    
    var buttonArray : [UIButton] = []
    let allowMultiSelect : Bool
    var selectedString : String? { get {
        var selected : [String] = []
        for button in buttonArray {
            if button.isSelected {
                selected.append(button.title(for: .normal)!)
            }
        }
        if selected.isEmpty {
            return nil
        } else {
            return selected.joined(separator: ",")
        }
        }
    }
        
    init(options: [String], fontSize: CGFloat, allowMultiSelection: Bool) {
        allowMultiSelect = allowMultiSelection
        super.init(frame: CGRect.zero)
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.masksToBounds = true
        for option in options {
            let button = UIButton(type: .custom)
            button.setTitle(option, for: .normal)
            button.setTitle(option, for: .selected)
            
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            buttonArray.append(button)
            button.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
            addSubview(button)
            
        }
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        for button in buttonArray {
            let index = buttonArray.index(of: button)!
            let count = buttonArray.count
            button.snp.makeConstraints({ (make) in
                make.height.equalTo(self)
                make.centerY.equalTo(self)
                make.width.equalTo(self).dividedBy(count)
                if index == 0 {
                    make.left.equalTo(self)
                } else {
                    make.left.equalTo((buttonArray[index-1] as UIButton).snp.right)
                }
            })
            
            if index < count - 1 {
                let separateLine = UIView()
                separateLine.backgroundColor = UIColor.blue
                self.addSubview(separateLine)
                separateLine.snp.makeConstraints({ (make) in
                    make.width.equalTo(1)
                    make.height.top.bottom.equalTo(self)
                    make.right.equalTo(button)
                })
            }
        }
        
    }
    
    @objc func buttonAction(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = UIColor.clear
        } else {
            if !allowMultiSelect {
                for button in buttonArray {
                    button.isSelected = false
                    button.backgroundColor = UIColor.clear
                }
                sender.isSelected = true
                sender.backgroundColor = UIColor.blue
            }
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
