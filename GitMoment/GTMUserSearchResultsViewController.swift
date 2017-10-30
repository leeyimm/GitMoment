//
//  GTMUserSearchResultsViewController.swift
//  GitMoment
//
//  Created by liying on 20/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMUserSearchResultsViewController: UIViewController {
    
    let tableViewCellIdentifier = "userCell"
    var contentView = UIView()
    
    var tableView : UITableView = UITableView()
    
    var users = [GTMUser]()
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
        self.tableView.register(GTMUserRankingCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchSearchUserResult(searchString: self.searchString, sort: self.sort, pageNo: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchSearchUserResult(searchString: String, sort: String?, pageNo: Int) {
        GTMAPIManager.sharedInstance.searchUsers(searchString: searchString, sort: sort) { (result) in
            guard result.error == nil else {
                return
            }
            if let users = result.value {
                self.users = users
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

