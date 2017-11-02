//
//  GTMIssueListViewController.swift
//  GitMoment
//
//  Created by liying on 01/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMIssueListViewController: GTMRefreshableListViewController {
    let issueCellIdentifier = "issueCell"
    let repo : GTMRepository
    var issues = [GTMIssue]()
    init(repo: GTMRepository) {
        self.repo = repo
        super.init(pageEnabled: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(GTMIssueViewCell.self, forCellReuseIdentifier: issueCellIdentifier)
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
        GTMAPIManager.sharedInstance.fetchRepoIssues(ownername: (self.repo.owner?.login)!, reponame: self.repo.name!, page: page)  { (result) in
            self.dismissLoadingIndicator()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            guard result.error == nil else {
                let error  = result.error! as! GTMAPIManagerError
                self.processError(error: error)
                return
            }
            
            self.processData(list: &self.issues, fetchedResult: result.value!, expectedPageCount: GTMConstantValue.githubPerpageCount)
            
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

extension GTMIssueListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: issueCellIdentifier, for: indexPath) as! GTMIssueViewCell
        let issue = self.issues[indexPath.row]
        cell.updateUIWith(issue: issue)
        return cell
    }
}

extension GTMIssueListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
