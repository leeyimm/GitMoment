//
//  GTMAccountViewController.swift
//  GitMoment
//
//  Created by liying on 10/08/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMAccountViewController: UIViewController {
    
    var contentView = UIScrollView()
    var loginButton = UIButton(type: .system)
    var userHeaderView : GTMUserHeaderView!
    var userInfoTableView = UITableView()
    var logoutButton = UIButton(title: "Logout", fontSize: 14, textColor: UIColor.white, backgroundColor: UIColor.red)
    var userInfoCellHeight = 45.0
    var userInfoCellIdentifier = "userInfoCell"
    var user : GTMGithubUser?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.userHeaderView = GTMUserHeaderView(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .top
        self.navigationItem.title = "Profile"
        loginButton.setTitle("Login Github", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
        
        self.view.addSubview(contentView)
        contentView.backgroundColor = UIColor(hex: "#f5f5f5")
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.contentView.isHidden = true
        
        self.userInfoTableView.register(GTMInfoCell.self, forCellReuseIdentifier: userInfoCellIdentifier)
        self.userInfoTableView.dataSource = self
        self.userInfoTableView.delegate = self
        self.userInfoTableView.separatorStyle = .none
        self.contentView.addSubview(userHeaderView)
        self.contentView.addSubview(userInfoTableView)
        self.contentView.addSubview(logoutButton)
        
        userHeaderView.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(self.contentView)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        userInfoTableView.snp.makeConstraints { (make) in
            make.top.equalTo(userHeaderView.snp.bottom)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(userHeaderView)
            make.height.equalTo(8 * userInfoCellHeight + 15 * 2)
        }
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.setBorder(width: 1, color: UIColor.red, cornerRadius: 3)
        logoutButton.snp.makeConstraints { (make) in
            make.top.equalTo(userInfoTableView.snp.bottom).offset(25)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.contentView).offset(-40)
            make.bottom.equalTo(self.contentView).offset(-30)
        }
        
        if GTMAPIManager.sharedInstance.hasOAuthToken() {
            self.loginSuccess()
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonTapped() {
        weak var weakSelf = self
        let loginViewController = GTMLoginViewController() {
            weakSelf?.loginSuccess()
        }
        self.navigationController?.present(loginViewController, animated: true, completion: nil)
    }
    
    func loginSuccess() {
        self.contentView.isHidden = false
        self.loginButton.isHidden = true
        GTMAPIManager.sharedInstance.fetchUserInfo(username: nil) { (result) in
            guard result.error == nil else {
                return
            }
            if let user = result.value {
                self.user = user
                self.userHeaderView.setUserInfo(user: user)
                self.userInfoTableView.reloadData()
            }
        }
    }
    
    func logoutButtonTapped() {
        GTMAPIManager.sharedInstance.OAuthToken = nil
        self.contentView.isHidden = true
        self.loginButton.isHidden = false
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

extension GTMAccountViewController : GTMThreeButtonViewDelegate {
    func leftButtonTapped() {
        let followersListController = GTMInterestedUserListController(type: .follower, username: nil)
        self.navigationController?.pushViewController(followersListController, animated: true)
    }
    func middleButtonTapped() {
        let reposListController = GTMUserReposListController(type: .userRepos, username: nil, language: nil)
        self.navigationController?.pushViewController(reposListController, animated: true)
    }
    func rightButtonTapped() {
        let followingsListController = GTMInterestedUserListController(type: .following, username: nil)
        self.navigationController?.pushViewController(followingsListController, animated: true)
    }
}

extension GTMAccountViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userInfoCellIdentifier, for: indexPath) as! GTMInfoCell
        if let user = self.user {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                cell.setCellType(type: .company, title: user.company)
                cell.setSeparatedLine(type: .upper, indent: 0)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (0, 1):
                cell.setCellType(type: .location, title: user.location)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (0, 2):
                cell.setCellType(type: .email, title: user.email)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (0, 3):
                cell.setCellType(type: .link, title: user.url)
                cell.setSeparatedLine(type: .lower, indent: 0)
                
            case (1, 0):
                cell.setCellType(type: .starred, title: nil)
                cell.setSeparatedLine(type: .upper, indent: 0)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (1, 1):
                cell.setCellType(type: .wacthing, title: nil)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (1, 2):
                cell.setCellType(type: .events, title: nil)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (1, 3):
                cell.setCellType(type: .notification, title: nil)
                cell.setSeparatedLine(type: .lower, indent: 0)
            default:
                break
            }
            if indexPath.section == 0 {
                cell.selectionStyle = .none
            }
        }
        return cell
    }
}

extension GTMAccountViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(hex: "#f5f5f5")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is GTMInfoCell {
            var reposListController : GTMUserReposListController!
            switch (cell as! GTMInfoCell).type! {
            case .repos:
                reposListController = GTMUserReposListController(type: .userRepos, username: nil, language: nil)
            case .starred:
                reposListController = GTMUserReposListController(type: .starredRepos, username: nil, language: nil)
            case .wacthing:
                reposListController = GTMUserReposListController(type: .watchingRepos, username: nil, language: nil)
            default:
                break
            }
            if reposListController != nil {
                self.navigationController?.pushViewController(reposListController, animated: true)
            }
        }
    }
}


