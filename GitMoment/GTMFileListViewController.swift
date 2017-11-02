//
//  GTMFileListViewController.swift
//  GitMoment
//
//  Created by liying on 31/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMFileListViewController: GTMRefreshableListViewController {
    
    var filePath : String!
    var branch : String!
    let fileInfoCellIdentifier = "fileInfoCell"
    var files = [GTMFileInfo]()
    
    init(filePath: String, branch: String) {
        super.init(pageEnabled: false)
        self.filePath = filePath
        self.branch = branch
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(GTMFileInfoCell.self, forCellReuseIdentifier: fileInfoCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        // Do any additional setup after loading the view.
        self.fetchContents() 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchContents() {
        GTMAPIManager.sharedInstance.fetchContents(path: filePath, branch: branch) { (result) in
            guard result.error == nil else {
                return
            }
            
            self.files = result.value!
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

extension GTMFileListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: fileInfoCellIdentifier, for: indexPath) as! GTMFileInfoCell
        let file = self.files[indexPath.row]
        cell.updateWithFile(info: file)
        return cell
    }
}

extension GTMFileListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = self.files[indexPath.row]
        var nextViewController : UIViewController?
        switch file.type {
        case .file:
            nextViewController = GTMFileContentViewController(filePath: self.filePath + "/" + file.name!, branch: self.branch)
        case .dir:
            nextViewController = GTMFileListViewController(filePath: self.filePath + "/" + file.name!, branch: self.branch)
        default:
            break
        }
        if nextViewController != nil {
            self.navigationController?.pushViewController(nextViewController!, animated: true)
        }
    }
}
