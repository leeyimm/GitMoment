//
//  GTMNavigationBarSwitchControl.swift
//  GitMoment
//
//  Created by liying on 27/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

protocol GTMNavigateBarSwitchControlDelegate : class {
    func rightSelected()
    func leftSelected()
}

class GTMNavigationBarSwitchControl: UIView {

    weak var delegate: GTMNavigateBarSwitchControlDelegate?
    var backgroundView: UIView!
    var leftButton: UIButton!
    var rightButton: UIButton!
    
    init(frame: CGRect, leftTitle: String, rightTitle: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5).cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 10.0
        
        self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.width / 2, height: self.height))
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.layer.cornerRadius = 10.0
        self.addSubview(self.backgroundView)
        
        self.leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.width / 2, height: self.height))
        self.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        self.leftButton.setTitle(leftTitle, for: .normal)
        self.leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.leftButton.setTitleColor(UIColor(hex: "#239BE7"), for: .normal)
        self.addSubview(leftButton)
        
        self.rightButton = UIButton(frame: CGRect(x: self.width / 2, y: 0, width: self.width / 2, height: self.height))
        self.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        self.rightButton.setTitle(rightTitle, for: .normal)
        self.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.rightButton.setTitleColor(UIColor.white, for: .normal)
        self.addSubview(rightButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func leftButtonTapped() {
        self.delegate?.leftSelected()
    }
    
    func rightButtonTapped() {
        self.delegate?.rightSelected()
    }
    
    func slideBackgroundView(percentage: CGFloat) {
        let offsetX = percentage * self.width / 2;
        self.backgroundView.frame = CGRect(x: offsetX, y: self.backgroundView.frame.origin.y, width: self.backgroundView.width, height: self.backgroundView.height);
        var red, green, blue : CGFloat
        red = (0xFF - (0xFF-0x23) * percentage) / 255.0;
        green = (0xFF - (0xFF-0x9B) * percentage) / 255.0;
        blue = (0xFF - (0xFF-0xE7) * percentage) / 255.0;
        self.rightButton.setTitleColor(UIColor(red: red, green: green, blue: blue, alpha: 1.0), for: .normal)
        
        red = (0xFF - (0xFF-0x23) * (1 - percentage)) / 255.0;
        green = (0xFF - (0xFF-0x9B) * (1 - percentage)) / 255.0;
        blue = (0xFF - (0xFF-0xE7) * (1 - percentage)) / 255.0;
        self.leftButton.setTitleColor(UIColor(red: red, green: green, blue: blue, alpha: 1.0), for: .normal)
    }

}
