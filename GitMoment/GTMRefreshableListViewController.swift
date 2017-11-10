//
//  GTMRefreshableListViewController.swift
//  GitMoment
//
//  Created by liying on 30/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import MJRefresh

class GTMRefreshableListViewController: GTMBaseViewController {
    
    var tableView : UITableView = UITableView()
    var page : Int!
    
    init(pageEnabled: Bool) {
        super.init(nibName: nil, bundle: nil)
        let refreshHeader = MJRefreshNormalHeader()
        refreshHeader.lastUpdatedTimeLabel.isHidden = true
        self.tableView.mj_header = refreshHeader
        if pageEnabled {
            self.tableView.mj_footer = MJRefreshAutoNormalFooter()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.contentView.addSubview(self.tableView)
        if #available(iOS 11, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processData<T>(list : inout [T], fetchedList: [T], page: Int, expectedPageCount: Int) {
        self.page = page
        if page == 1 {
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
