//
//  GTMIssueDetailViewController.swift
//  GitMoment
//
//  Created by liying on 02/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMIssueDetailViewController: GTMRefreshableListViewController {

    let issueHeaderCellIdentifier = "issueHeaderCell"
    let authorInfoCellIdentifier = "authorCell"
    let htmlContentCellIdentifier = "htmlContentCell"
    
    let issue : GTMIssue
    init(issue : GTMIssue) {
        self.issue = issue
        super.init(pageEnabled: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(GTMIssueHeaderCell.self, forCellReuseIdentifier: issueHeaderCellIdentifier)
        self.tableView.register(GTMCommentAuthorCell.self, forCellReuseIdentifier: authorInfoCellIdentifier)
        self.tableView.register(GTMHTMLContentCell.self, forCellReuseIdentifier: htmlContentCellIdentifier)
        self.tableView.dataSource = self
        //self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        // Do any additional setup after loading the view.
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

extension GTMIssueDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: issueHeaderCellIdentifier, for: indexPath) as! GTMIssueHeaderCell
            cell.updateUIWith(issue: self.issue)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: authorInfoCellIdentifier, for: indexPath) as! GTMCommentAuthorCell
            cell.updateUIWith(author: self.issue.user!, createTime: self.issue.createdAt!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: htmlContentCellIdentifier, for: indexPath) as! GTMHTMLContentCell
            if cell.finishLoading == false {
                cell.loadContent(original: self.issue.body)
                cell.didFinishLoadAction = { [weak self] in
                    self?.tableView.reloadData()
                }
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

