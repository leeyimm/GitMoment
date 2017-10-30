//
//  GTMThreeButtonView.swift
//  GitMoment
//
//  Created by liying on 28/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

protocol GTMThreeButtonViewDelegate : class {
    func leftButtonTapped()
    func middleButtonTapped()
    func rightButtonTapped()
}

class GTMHeaderButton : UIButton {
    var upperLabel = UILabel()
    var lowerLabel = UILabel()
    
    init(lowerLabelString: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        
        self.addSubview(upperLabel)
        self.addSubview(lowerLabel)
        lowerLabel.text = lowerLabelString
        upperLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-10)
        }
        
        lowerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GTMThreeButtonView: UIView {
    
    var leftButton : GTMHeaderButton!
    var middleButton : GTMHeaderButton!
    var rightButton : GTMHeaderButton!
    
    weak var delegate : GTMThreeButtonViewDelegate?

    init(leftTitle: String, middleTitle: String, rightTitle: String) {
        super.init(frame: CGRect.zero)
        
        leftButton = GTMHeaderButton(lowerLabelString: leftTitle)
        middleButton = GTMHeaderButton(lowerLabelString: middleTitle)
        rightButton = GTMHeaderButton(lowerLabelString: rightTitle)
        
        self.addSubview(leftButton)
        self.addSubview(middleButton)
        self.addSubview(rightButton)
        
        leftButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        middleButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        
        middleButton.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(self).dividedBy(3)
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(middleButton.snp.left)
            make.size.equalTo(middleButton)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(middleButton.snp.right)
            make.size.equalTo(middleButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonTapped(sender: UIButton) {
        switch sender {
        case self.leftButton:
            self.delegate?.leftButtonTapped()
        case self.middleButton:
            self.delegate?.middleButtonTapped()
        case self.rightButton:
            self.delegate?.rightButtonTapped()
        default:
            break
        }
    }
    
    func updateButtonsUpperTitle(left: String, middle: String, right: String) {
        self.leftButton.upperLabel.text = left
        self.middleButton.upperLabel.text = middle
        self.rightButton.upperLabel.text = right
        if left == "0" {
            self.leftButton.isEnabled = false
        }
        if middle == "0" {
            self.middleButton.isEnabled = false
        }
        if right == "0" {
            self.rightButton.isEnabled = false
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
