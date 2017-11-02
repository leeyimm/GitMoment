//
//  GTMLocationSettingController.swift
//  GitMoment
//
//  Created by liying on 24/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

protocol GTMLocationChosenDelegate : class {
    var chosenLocation: GTMConstantValue.GTMLocationType {get set}
}

class GTMLocationSettingController: UIViewController {
    
    var segmentControl = UISegmentedControl(items: GTMConstantValue.locations)
    var textField = UITextField()
    var cancelButton = UIButton(title: "Cancel", fontSize: 16, textColor: UIColor.red)
    var okButton = UIButton(title: "OK", fontSize: 16)
    weak var locationDelegate : GTMLocationChosenDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.layer.cornerRadius = 8.0
        self.view.layer.masksToBounds = true
        
        self.segmentControl.addTarget(self, action: #selector(segmentControlValueChange), for: .valueChanged)
        self.segmentControl.selectedSegmentIndex = 0
        self.textField.isHidden = true
        
        self.textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        self.view.addSubview(self.segmentControl)
        
        self.view.addSubview(self.textField)
        self.textField.delegate = self
        self.textField.layer.borderColor = UIColor(hex: "#CCCCCC").cgColor
        self.textField.layer.cornerRadius = 2.0
        self.textField.layer.borderWidth = 1.0
        self.textField.autocapitalizationType = .none
        self.textField.autocorrectionType = .no
        self.textField.font = UIFont.systemFont(ofSize: 20)
        
        self.cancelButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.okButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.cancelButton.setBorder(width: 1.0, color: UIColor(hex: "#CCCCCC"), cornerRadius: 2.0)
        self.okButton.setBorder(width: 1.0, color: UIColor(hex: "#CCCCCC"), cornerRadius: 2.0)
        self.okButton.setTitleColor(UIColor(hex: "#CCCCCC"), for: .disabled)
        
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.okButton)
        
        self.segmentControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.textField.snp.top).offset(-25)
        }
        self.textField.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(self.segmentControl)
        }
        
        self.cancelButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.segmentControl).dividedBy(2).offset(-5)
            make.left.equalTo(self.segmentControl)
            make.top.equalTo(self.textField.snp.bottom).offset(20)
        }
        
        self.okButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.cancelButton)
            make.right.equalTo(self.segmentControl)
            make.top.equalTo(self.cancelButton)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.textField.resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    
    override var preferredContentSize: CGSize { get {
        return CGSize(width: UIScreen.main.bounds.size.width - 60, height: (UIScreen.main.bounds.size.height) / 3)
        }
        set(newSize) {
            super.preferredContentSize = newSize
        }
    }
    
    @objc func segmentControlValueChange(sender : UISegmentedControl) {
        self.textField.resignFirstResponder()
        self.textField.text = nil
        switch sender.selectedSegmentIndex {
        case 0:
            self.textField.text = nil
            self.textField.isHidden = true
        case 1:
            self.textField.isHidden = false
            self.textField.placeholder = "country name"
            self.okButton.isEnabled = false
        case 2:
            self.textField.isHidden = false
            self.textField.placeholder = "city name"
            self.okButton.isEnabled = false
        default:
            break
        }
    }
    
    @objc func textFieldChanged(textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            self.okButton.isEnabled = true
        } else {
            self.okButton.isEnabled = false
        }
    }
    
    @objc func buttonAction(button : UIButton) {
        if button == self.okButton {
            switch self.segmentControl.selectedSegmentIndex {
            case 0:
                self.locationDelegate?.chosenLocation = .GTMLocationWorld
            case 1:
                let country = self.textField.text!
                self.locationDelegate?.chosenLocation = .GTMLocationCountry(country)
            case 2:
                let city = self.textField.text!
                self.locationDelegate?.chosenLocation = .GTMLocationCountry(city)
            default:
                break
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GTMLocationSettingController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
}
