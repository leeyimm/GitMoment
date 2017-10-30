//
//  GTMLoginViewController.swift
//  GitMoment
//
//  Created by liying on 21/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import SafariServices

class GTMLoginViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var safariViewController: SFSafariViewController?
    
    var usernameIcon = UIImageView(image: UIImage(octiconsID: .person, backgroundColor: UIColor.clear, iconColor: UIColor.lightGray, iconScale: 1, size: CGSize(width: 20, height: 20)))
    var usernameTextField = UITextField()
    var passwordIcon = UIImageView(image: UIImage(octiconsID: .lock, backgroundColor: UIColor.clear, iconColor: UIColor.lightGray, iconScale: 1, size: CGSize(width: 20, height: 20)))
    var passwordTextField = UITextField()
    var loginButton = UIButton(title: "Login", fontSize: 13, textColor: UIColor.white, backgroundColor: UIColor(hex: "#42a5f5"))
    
    var OAuthLoginButton = UIButton(title: "Auth2.0 Login", fontSize: 13, textColor: UIColor(hex: "#42a5f5"), backgroundColor: UIColor(hex: "#e0e0e0"))
    
    var completionCallBack : (() -> Void)?
    
    init(completionHandler: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        completionCallBack = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "#e0e0e0")
        
        self.view.addSubview(usernameIcon)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordIcon)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        self.view.addSubview(OAuthLoginButton)
        self.OAuthLoginButton.addTarget(self, action: #selector(oauthLoginButtonTapped), for: .touchUpInside)
        
        self.usernameIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(-20)
            make.left.equalTo(30)
            make.width.height.equalTo(20)
        }
        
        self.usernameTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.usernameIcon)
            make.left.equalTo(self.usernameIcon.snp.right).offset(10)
            make.right.equalTo(self.view).offset(-20)
        }
        
        self.passwordIcon.snp.makeConstraints { (make) in
            make.top.equalTo(self.usernameIcon.snp.bottom).offset(15)
            make.left.equalTo(self.usernameIcon)
            make.width.height.equalTo(20)
        }
        
        self.passwordTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.passwordIcon)
            make.left.equalTo(self.passwordIcon.snp.right).offset(10)
            make.right.equalTo(self.view).offset(-20)
        }
        
        self.loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        
        self.OAuthLoginButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-60)
        }

        self.addKeyboardDismissGesture()
        
        GTMAPIManager.sharedInstance.OAuthTokenCompletionHandler = { error in
            guard error == nil else {
                print(error!)
                if let safariViewController = self.safariViewController {
                    safariViewController.dismiss(animated: false) {}
                }
                return
            }
            
            self.dismiss(animated: false, completion: self.completionCallBack)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonTapped() {
        
    }
    
    func oauthLoginButtonTapped() {
        guard let authURL = GTMAPIManager.sharedInstance.URLToStartOAuth2Login() else {
            let error = GTMAPIManagerError.authCouldNot(reason:
                "Could not obtain an OAuth token")
            GTMAPIManager.sharedInstance.OAuthTokenCompletionHandler?(error)
            return
        }
        self.safariViewController = SFSafariViewController(url: authURL)
        self.safariViewController?.delegate = self
        guard let webViewController = self.safariViewController else {
            return
        }
        self.present(webViewController, animated: true, completion: nil)
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        // Detect not being able to load the OAuth URL
        if (!didLoadSuccessfully) {
            controller.dismiss(animated: true, completion: nil)
            GTMAPIManager.sharedInstance.isAPIOnline { isOnline in
                if !isOnline {
                    print("error: api offline")
                    let innerError = NSError(domain: NSURLErrorDomain,
                                             code: NSURLErrorNotConnectedToInternet,
                                             userInfo: [NSLocalizedDescriptionKey:
                                                "No Internet Connection or GitHub is Offline",
                                                        NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                    let error = GTMAPIManagerError.network(error: innerError)
                    GTMAPIManager.sharedInstance.OAuthTokenCompletionHandler?(error)
                }
            }
        }
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
