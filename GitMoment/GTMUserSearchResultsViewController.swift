//
//  GTMUserSearchResultsViewController.swift
//  GitMoment
//
//  Created by liying on 20/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import MJRefresh

class GTMUserSearchResultsViewController: GTMPagedListViewController {
    
    let tableViewCellIdentifier = "userCell"
    
    var users = [GTMUser]()
    var searchString : String!
    var sort : String?
    
    init(searchString: String, sort: String?) {
        super.init(nibName: nil, bundle: nil)
        self.searchString = searchString
        self.sort = sort
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(GTMUserRankingCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.tableView.mj_header.refreshingBlock = {
            [weak self] in
            self?.fetchSearchUserResult(pageNo: 1)
        }
        
        self.tableView.mj_footer.refreshingBlock = {
            [weak self] in
            self?.fetchSearchUserResult(pageNo: (self?.page)! + 1)
        }

        self.fetchSearchUserResult(pageNo: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchSearchUserResult(pageNo: Int) {
        self.showLoadingIndicator(toView: tableView)
        GTMAPIManager.sharedInstance.searchUsers(searchString: self.searchString, sort: self.sort, page: pageNo) { (result) in
            self.dismissLoadingIndicator()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            guard result.error == nil else {
                let error  = result.error! as! GTMAPIManagerError
                self.processError(error: error)
                return
            }
            
            self.processData(list: &self.users, fetchedResult: result.value!, expectedPageCount: GTMConstantValue.githubPerpageCount)
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

extension GTMUserSearchResultsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! GTMUserRankingCell
        let user = self.users[indexPath.row]
        cell.nameLabel.text = user.login
        return cell
    }
}

extension GTMUserSearchResultsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        let userDetailViewController = GTMUserDetailViewController(username: user.login!)
        self.navigationController?.pushViewController(userDetailViewController, animated: true)
    }
}

