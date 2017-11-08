//
//  GTMUserDetailViewController.swift
//  GitMoment
//
//  Created by liying on 25/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMUserDetailViewController: UIViewController {
    
    var contentView = UIScrollView()
    var userHeaderView : GTMUserHeaderView!
    var userInfoTableView = UITableView()
    var userInfoCellHeight = 45.0
    var languageReposCellHeight = 86.0
    var userInfoCellIdentifier = "userInfoCell"
    var userLanguageReposCellIdentifier = "languageReposCell"
    var user : GTMGithubUser?
    var userRankingInfo : GTMUserRankingInfo?
    var username : String!
    var followButton : GTMFollowButton!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        self.userHeaderView = GTMUserHeaderView(delegate: self)
        self.followButton = self.userHeaderView.followButton
        self.followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .top
        self.navigationItem.title = "Profile"
        
        self.view.addSubview(contentView)
        contentView.backgroundColor = UIColor(hex: "#f5f5f5")
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.userInfoTableView.register(GTMInfoCell.self, forCellReuseIdentifier: userInfoCellIdentifier)
        self.userInfoTableView.register(GTMLanguageReposCell.self, forCellReuseIdentifier: userLanguageReposCellIdentifier)
        self.userInfoTableView.dataSource = self
        self.userInfoTableView.delegate = self
        self.contentView.addSubview(userHeaderView)
        self.contentView.addSubview(userInfoTableView)
        
        userHeaderView.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(self.contentView)
            //make.height.equalTo(userHeaderView.intrinsicContentSize.height)
        }
        
        userInfoTableView.snp.makeConstraints { (make) in
            make.top.equalTo(userHeaderView.snp.bottom)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(userHeaderView)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.height.equalTo(8 * userInfoCellHeight + 15 * 2)
        }
        
    }
    
    override func updateViewConstraints() {
        var height = 7 * userInfoCellHeight + 15 * 3
        if let user = self.user, user.isOrganization {
            height = 5 * userInfoCellHeight + 15 * 2
        }
        if let rankingInfo = self.userRankingInfo, let languageRepos = rankingInfo.languageRepos  {
            let count = languageRepos.count < 10 ? languageRepos.count : 10
            height += Double(count) * languageReposCellHeight
        }
        
        userInfoTableView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GTMAPIManager.sharedInstance.fetchUserInfo(username: self.username) { (result) in
            guard result.error == nil else {
                return
            }
            if let user = result.value {
                self.user = user
                self.userHeaderView.setUserInfo(user: user)
                self.view.setNeedsUpdateConstraints()
                self.userInfoTableView.reloadData()
            }
            if !(self.user?.isOrganization)! {
                self.fetchFollowingStatus()
            }
        }
        
        GTMAPIManager.sharedInstance.fetchUserReposRanking(username: self.username) { (result) in
            guard result.error == nil else {
                return
            }
            if let userRankingInfo = result.value {
                self.userRankingInfo = userRankingInfo
                self.view.setNeedsUpdateConstraints()
                self.userInfoTableView.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func fetchFollowingStatus() {
        GTMAPIManager.sharedInstance.checkFollowing(type: .following, username: (self.user?.login!)!, reponame: nil, completionHandler: { (result) in
            if let status = result {
                if status {
                    self.followButton.type = .unfollow
                } else {
                    self.followButton.type = .follow
                }
                self.followButton.isHidden = false
            }
        })
    }
    
    @objc func followButtonTapped() {
        self.followButton.startLoading()
        GTMAPIManager.sharedInstance.performFollowing(followingType: self.followButton.followingType, type: self.followButton.type, username: (self.user?.login!)!, reponame: nil, completionHandler: { (result) in
            self.followButton.stopLoading()
            if result != nil {
                switch self.followButton.type {
                case .follow:
                    self.followButton.type = .unfollow
                case .unfollow:
                    self.followButton.type = .follow
                }
                self.followButton.isHidden = false
            }
        })
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

extension GTMUserDetailViewController : GTMThreeButtonViewDelegate {
    func leftButtonTapped() {
        let followersListController = GTMInterestedUserListController(type: .follower, username: self.username)
        self.navigationController?.pushViewController(followersListController, animated: true)
    }
    func middleButtonTapped() {
        let reposListController = GTMUserReposListController(type: .userRepos, username: self.username, language: nil)
        self.navigationController?.pushViewController(reposListController, animated: true)
    }
    func rightButtonTapped() {
        let followingsListController = GTMInterestedUserListController(type: .following, username: self.username)
        self.navigationController?.pushViewController(followingsListController, animated: true)
    }
}

extension GTMUserDetailViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let user = self.user, user.isOrganization {
                return 5
            }
            return 4
        case 1:
            if let user = self.user, user.isOrganization {
                return 0
            }
            return 3
        case 2:
            let count = (self.userRankingInfo?.languageRepos?.count) ?? 0
            return count > 10 ? 10 : count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: userLanguageReposCellIdentifier, for: indexPath) as! GTMLanguageReposCell
            if let rankingInfo = self.userRankingInfo, let languageRepos = rankingInfo.languageRepos {
                let languageRepo = languageRepos[indexPath.row]
                cell.updateCell(reposInfo: languageRepo, userInfo: rankingInfo)
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: userInfoCellIdentifier, for: indexPath) as! GTMInfoCell
        if let user = self.user {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                if user.isOrganization {
                    cell.setCellType(type: .repos, title: nil, subTitle:"\(user.publicRepos!)")
                } else {
                    cell.setCellType(type: .company, title: user.company)
                }
                cell.setSeparatedLine(type: .upper, indent: 0)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (0, 1):
                cell.setCellType(type: .location, title: user.location)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (0, 2):
                cell.setCellType(type: .email, title: user.email)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (0, 3):
                cell.setCellType(type: .link, title: user.blog)
                cell.setSeparatedLine(type: .lower, indent: 15)
            case (0, 4):
                cell.setCellType(type: .events, title: nil)
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

extension GTMUserDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return CGFloat(languageReposCellHeight)
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor(hex: "#f5f5f5")
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let user = self.user, user.isOrganization, section == 1 {
            return 0
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is GTMLanguageReposCell {
            let language = self.userRankingInfo?.languageRepos?[indexPath.row].language
            let username = self.user?.login
            let reposListController = GTMUserReposListController(type: .userRepos, username: username, language: language)
            self.navigationController?.pushViewController(reposListController, animated: true)
        }
        if cell is GTMInfoCell {
            var reposListController : GTMUserReposListController?
            switch (cell as! GTMInfoCell).type! {
            case .repos:
                reposListController = GTMUserReposListController(type: .userRepos, username: username, language: nil)
            case .starred:
                reposListController = GTMUserReposListController(type: .starredRepos, username: username, language: nil)
            case .wacthing:
                reposListController = GTMUserReposListController(type: .watchingRepos, username: username, language: nil)
            default:
                break
            }
            if let nextViewController = reposListController {
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
    }
}

