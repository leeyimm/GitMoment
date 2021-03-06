//
//  GTMIssueListViewController.swift
//  GitMoment
//
//  Created by liying on 01/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

enum GTMIssueType {
    case issue
    case pull_request
}

class GTMIssueListViewController: GTMRefreshableListViewController {
    let issueCellIdentifier = "issueCell"
    let repo : GTMRepository
    var issues = [GTMIssueBase]()
    var type : GTMIssueType
    init(repo: GTMRepository, type: GTMIssueType) {
        self.repo = repo
        self.type = type
        super.init(pageEnabled: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(GTMIssueSummaryCell.self, forCellReuseIdentifier: issueCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.tableView.mj_header.refreshingBlock = {
            [weak self] in
            self?.fetchRepoIssues(page: 1)
        }
        
        self.tableView.mj_footer.refreshingBlock = {
            [weak self] in
            self?.fetchRepoIssues(page: (self?.page)! + 1)
        }
        
        
        self.fetchRepoIssues(page: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func fetchRepoIssues(page: Int) {
        self.showLoadingIndicator(toView: tableView)
        switch self.type {
        case .issue:
            GTMAPIManager.sharedInstance.fetchRepoIssues(ownername: (self.repo.owner?.login)!, reponame: self.repo.name!, page: page)  { (result) in
                self.dismissLoadingIndicator()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                guard result.error == nil else {
                    let error  = result.error! as! GTMAPIManagerError
                    self.processError(error: error)
                    return
                }
                
                self.processData(list: &self.issues, fetchedList: result.value!.0, page: result.value!.1, expectedPageCount: GTMConstantValue.githubPerpageCount)
                
                self.tableView.reloadData()
                
            }
        case .pull_request:
            GTMAPIManager.sharedInstance.fetchRepoPullRequests(ownername: (self.repo.owner?.login)!, reponame: self.repo.name!, page: page)  { (result) in
                self.dismissLoadingIndicator()
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                guard result.error == nil else {
                    let error  = result.error! as! GTMAPIManagerError
                    self.processError(error: error)
                    return
                }
                
                self.processData(list: &self.issues, fetchedList: result.value!.0, page: result.value!.1, expectedPageCount: GTMConstantValue.githubPerpageCount)
                
                self.tableView.reloadData()
                
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

extension GTMIssueListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: issueCellIdentifier, for: indexPath) as! GTMIssueSummaryCell
        let issue = self.issues[indexPath.row]
        cell.updateUIWith(issue: issue)
        return cell
    }
}

extension GTMIssueListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue = self.issues[indexPath.row]

        let issueDetailController = GTMIssueDetailViewController(repo: self.repo, issue: issue)
        self.navigationController?.pushViewController(issueDetailController, animated: true)

    }
}
