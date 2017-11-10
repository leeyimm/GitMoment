//
//  GTMInterestedUserListController.swift
//  GitMoment
//
//  Created by liying on 24/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import Alamofire

enum GTMRepoInterestedUserType {
    case starred
    case watching
    case follower
    case following
    case contributors
}


class GTMInterestedUserListController: GTMRefreshableListViewController{
    
    var interestedUserCellIdentifier = "interestedUserCell"
    var interestedType : GTMRepoInterestedUserType!
    var username : String?
    var repoOwnerName : String!
    var repoName: String!
    
    var users : [GTMGithubUser] = []
    
    init(type: GTMRepoInterestedUserType, username: String?) {
        super.init(pageEnabled: true)
        self.interestedType = type
        self.username = username
    }
    
    init(type: GTMRepoInterestedUserType, ownername: String, reponame: String) {
        super.init(pageEnabled: true)
        self.interestedType = type
        self.repoOwnerName = ownername
        self.repoName = reponame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        switch self.interestedType! {
        case .follower:
            self.navigationItem.title = "Followers"
        case .following:
            self.navigationItem.title = "Following"
        case .starred:
            self.navigationItem.title = "Stargazers"
        case .watching:
            self.navigationItem.title = "Watchers"
        case .contributors:
            self.navigationItem.title = "Contributors"
        }
        
        self.tableView.register(GTMFollowUserCell.self, forCellReuseIdentifier: interestedUserCellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.tableView.mj_header.refreshingBlock = {
            [weak self] in
            self?.fetchInterestedUsers(pageNo: 1)
        }
        
        self.tableView.mj_footer.refreshingBlock = {
            [weak self] in
            self?.fetchInterestedUsers(pageNo: (self?.page)! + 1)
        }
        
        self.fetchInterestedUsers(pageNo: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func fetchInterestedUsers(pageNo: Int) {
        self.showLoadingIndicator(toView: tableView)
        switch self.interestedType! {
        case .following, .follower:
            GTMAPIManager.sharedInstance.fetchFollowUsers(type: self.interestedType, username: username, page: pageNo) { (result) in
                self.processResult(result: result)
            }
        case .starred, .watching, .contributors:
            GTMAPIManager.sharedInstance.fetchRepoInterestedUsers(type: self.interestedType, ownername: repoOwnerName, reponame: repoName, page: pageNo) { (result) in
                self.processResult(result: result)
            }
        }
    }
    
    func processResult(result: Result<([GTMGithubUser], Int)>) {
        self.dismissLoadingIndicator()
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        guard result.error == nil else {
            let error  = result.error! as! GTMAPIManagerError
            self.processError(error: error)
            return
        }
        
        self.processData(list: &self.users, fetchedList: result.value!.0, page: result.value!.1, expectedPageCount: GTMConstantValue.githubPerpageCount)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension GTMInterestedUserListController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: interestedUserCellIdentifier, for: indexPath) as! GTMFollowUserCell
        let user = self.users[indexPath.row]
        cell.updateUIWithUser(user: user)
        if self.username == nil {
            switch self.interestedType! {
            case .follower:
                cell.setButtonType(type: .follow)
            case .following:
                cell.setButtonType(type: .unfollow)
            default:
                break
            }
        }
        return cell
    }
}

extension GTMInterestedUserListController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        let userDetailViewController = GTMUserDetailViewController(username: user.login!)
        self.navigationController?.pushViewController(userDetailViewController, animated: true)
    }
}
