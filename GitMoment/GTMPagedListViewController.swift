//
//  GTMPagedListViewController.swift
//  GitMoment
//
//  Created by liying on 30/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import MJRefresh

class GTMPagedListViewController: GTMBaseViewController {
    
    var tableView : UITableView = UITableView()
    var page : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.tableView)
        
        let refreshHeader = MJRefreshNormalHeader()
        refreshHeader.lastUpdatedTimeLabel.isHidden = true
        self.tableView.mj_header = refreshHeader
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processData<T>(list : inout [T], fetchedResult: ([T], Int), expectedPageCount: Int) {
        let fetchedList = fetchedResult.0
        let currentPage = fetchedResult.1
        self.page = currentPage
        if currentPage == 1 {
            if fetchedList.count == 0 {
                self.showNocontentViewWith(title: "No items")
            } else {
                list = fetchedList
                if fetchedList.count < expectedPageCount {
                    self.tableView.mj_footer.removeFromSuperview()
                }
            }
        } else {
            if fetchedList.count < expectedPageCount {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            list.append(contentsOf: fetchedList)
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
