//
//  GTMBaseViewController.swift
//  GitMoment
//
//  Created by liying on 29/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import MBProgressHUD
import Toast_Swift

enum GTMErrorViewType {
    case networkError
    case nocontent
}

class GTMErrorView : UIView {
    var errorImageView : UIImageView!
    var errorLabel = UILabel(fontSize: 14)
    var refreshButton : UIButton!
    var type: GTMErrorViewType!
    
    init(type: GTMErrorViewType) {
        super.init(frame: CGRect.zero)
        self.type = type
        self.refreshButton = UIButton(type: .system)
        self.refreshButton.setTitle("refresh", for: .normal)
        switch type {
        case .networkError:
            self.errorImageView = UIImageView(image: UIImage(named: "no_network_icon"))
            self.errorLabel.text = "Oops, got network error"
        case .nocontent:
            self.errorImageView = UIImageView(image: UIImage(named: "nothing"))
            self.errorLabel.text = "No Content"
            self.refreshButton.isHidden = true
        }
        
        //self.refreshButton.backgroundColor = UIColor(hex: "#cccccc")
        self.addSubview(self.errorImageView)
        self.addSubview(self.errorLabel)
        self.addSubview(refreshButton)
        
        self.errorImageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.centerX.equalTo(self)
        }
        self.errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.errorImageView.snp.bottom).offset(15)
            make.centerX.equalTo(self)
        }
        self.refreshButton.setBorder(width: 1, color: UIColor(hex: "#cccccc"), cornerRadius: 4.0)
        self.refreshButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.errorLabel.snp.bottom).offset(15)
            make.centerX.equalTo(self)
            make.height.equalTo(45)
            make.width.equalTo(75)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GTMBaseViewController: UIViewController {
    
    var contentView = UIView()
    var backgroundView = UIView()
    var errorView : GTMErrorView?
    var progressHUD : MBProgressHUD?
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.backgroundView)
        self.backgroundView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.backgroundView.backgroundColor = UIColor(hex: "#f5f5f5")
        self.backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refreshAction() {
        
    }
    
    func showNetworkErrorViewWith(title: String) {
        self.backgroundView.isHidden = false
        if let errorView = self.errorView {
            errorView.removeFromSuperview()
        }
        self.errorView = GTMErrorView(type: .networkError)
        self.backgroundView.addSubview(self.errorView!)
        self.errorView!.refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
        self.errorView!.snp.makeConstraints { (make) in
            make.center.equalTo(self.backgroundView)
            make.width.equalTo(self.backgroundView)
        }
    }
    
    func showNocontentViewWith(title: String) {
        self.backgroundView.isHidden = false
        if let errorView = self.errorView {
            errorView.removeFromSuperview()
        }
        self.errorView = GTMErrorView(type: .nocontent)
        self.backgroundView.addSubview(self.errorView!)
        self.errorView!.snp.makeConstraints { (make) in
            make.center.equalTo(self.backgroundView)
        }
    }
    
    func showLoadingIndicator(toView: UIView) {
        if let progressHUD = self.progressHUD {
            progressHUD.hide(animated: false)
        }
        self.progressHUD = MBProgressHUD.showAdded(to: toView, animated: true)
    }
    
    func dismissLoadingIndicator() {
        self.progressHUD?.hide(animated: true)
    }
    
    func showToast(text: String) {
        self.view.makeToast(text, duration: 1.0, position: .center)
    }
    
    func processError(error: GTMAPIManagerError) {
        switch error {
        case .network:
            self.showNetworkErrorViewWith(title: "Network Error")
        default:
            break
        }
        self.showToast(text: error.descripiton)
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
