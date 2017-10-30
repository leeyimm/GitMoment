//
//  GTMRepoSearchResultsViewController.swift
//  GitMoment
//
//  Created by liying on 20/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMRepoSearchResultsViewController: UIViewController {
    
    let tableViewCellIdentifier = "repoCell"
    var contentView = UIView()
    
    var tableView : UITableView = UITableView()
    
    var repos = [GTMRepository]()
    var searchString : String!
    var sort : String?
    var pageNo = 0
    
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
        
        self.edgesForExtendedLayout = []
        
        self.view.addSubview(self.tableView)
        
        self.view.addSubview(self.tableView)
        self.tableView.register(GTMRepoCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.snp.makeConstraints { (make) in
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
        self.fetchRepoSearchResults(searchString: self.searchString, sort: self.sort, pageNo: 1)
    }
    
    func fetchRepoSearchResults(searchString: String, sort: String?, pageNo: Int) {
        GTMAPIManager.sharedInstance.searchRepos(searchString: searchString, sort: sort) { (result) in
            guard result.error == nil else {
                return
            }
            if let repos = result.value {
                self.repos = repos
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
extension GTMRepoSearchResultsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! GTMRepoCell
        let repo = self.repos[indexPath.row]
        cell.titleLabel.text = repo.name
        cell.descritionLabel.text = repo.description
        cell.ownerLabel.text = repo.owner?.login
        return cell
    }
}

extension GTMRepoSearchResultsViewController : UITableViewDelegate {
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

