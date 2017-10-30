//
//  GTMUserReposListController.swift
//  GitMoment
//
//  Created by liying on 24/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import Alamofire

enum GTMUserReposType {
    case userRepos
    case starredRepos
    case watchingRepos
    case forkedRepos
}

class GTMUserReposListController: UIViewController {
    
    var repoCellIdentifier = "repoCell"
    var tableView = UITableView()
    var username : String?
    var language : String?
    var type : GTMUserReposType!
    var repoOwnerName : String!
    var repoName : String!
    
    var repos : [GTMRepository] = []
    
    init(type: GTMUserReposType, username: String?, language: String?) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        self.language = language
        self.type = type
    }
    
    init(type: GTMUserReposType, ownername: String, reponame: String) {
        super.init(nibName: nil, bundle: nil)
        self.repoOwnerName = ownername
        self.repoName = reponame
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationItem.title = self.username ?? "Repos"
        
        self.tableView.register(GTMRepoCell.self, forCellReuseIdentifier: repoCellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchUserRepos(pageNo: 1)
    }
    
    func fetchUserRepos(pageNo: Int) {
        switch self.type! {
        case .forkedRepos:
            GTMAPIManager.sharedInstance.fetchRepoForks(ownername: self.repoOwnerName, reponame: self.repoName) { (result) in
                self.processResult(result: result)
            }
        default:
            if let lang = language, let user = username {
                let qString = "language:\(lang) user:\(user)"
                GTMAPIManager.sharedInstance.searchRepos(searchString: qString, sort: "stars") { (result) in
                    self.processResult(result: result)
                }
            } else {
                GTMAPIManager.sharedInstance.fetchUserRepos(type: self.type, username: username) { (result) in
                   self.processResult(result: result)
                }
            }
        }
        
    }
    
    func processResult(result: Result<[GTMRepository]>) {
        guard result.error == nil else {
            return
        }
        if let repos = result.value {
            self.repos = repos
            self.tableView.reloadData()
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

extension GTMUserReposListController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: repoCellIdentifier, for: indexPath) as! GTMRepoCell
        let repo = self.repos[indexPath.row]
        cell.updateUIWithRepo(repo: repo)
        return cell
    }
}

extension GTMUserReposListController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let repo = self.repos[indexPath.row]
        return repo.heightForCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = self.repos[indexPath.row]
        let repoDetailController = GTMRepoDetailViewController(repo: repo)
        self.navigationController?.pushViewController(repoDetailController, animated: true)
    }
}
