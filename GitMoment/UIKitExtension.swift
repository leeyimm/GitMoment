//
//  UILableExtension.swift
//  GitMoment
//
//  Created by liying on 24/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

extension UIView {
    var height : CGFloat {
        get {
            return self.frame.height
        }
    }
    var width : CGFloat {
        get {
            return self.frame.width
        }
    }
}

extension UILabel {
    convenience init(fontSize: CGFloat, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        self.init()
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    convenience init(boldFontSize: CGFloat, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        self.init()
        self.font = UIFont.boldSystemFont(ofSize: boldFontSize)
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    convenience init(italicFontSize: CGFloat, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        self.init()
        self.font = UIFont.italicSystemFont(ofSize: italicFontSize)
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}

extension UIButton {
    convenience init(title: String, fontSize: CGFloat, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
    }
    
    convenience init(title: String, boldFontSize: CGFloat, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: boldFontSize)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
    }
    
    func setBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIViewController {
    public func addKeyboardDismissGesture() {
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(dismissKeyboardGesture)
    }
    
   @objc public func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    public func makeSeparateLine() -> UIView {
        let separateLine = UIView()
        separateLine.backgroundColor = UIColor(hex: "#666666")
        return separateLine
    }
}
