//
//  GTMFileContentViewController.swift
//  GitMoment
//
//  Created by liying on 31/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMFileContentViewController: GTMBaseViewController {
    
    var filePath : String!
    var webView = UIWebView()
    var branch : String!
    
    init(filePath: String, branch: String) {
        super.init(nibName: nil, bundle: nil)
        self.filePath = filePath
        self.branch = branch
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.addSubview(self.webView)
        
        self.webView.snp.makeConstraints { (make) in
            make.size.equalTo(self.contentView)
            make.center.equalTo(self.contentView)
        }
        
        self.fetchFile()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchFile() {
        GTMAPIManager.sharedInstance.fetchFileContent(path: filePath, branch: branch) { (result) in
            guard result.error == nil else {
                return
            }
            
            let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
            let templateHTMLPath = Bundle.main.path(forResource: "fileTemplate", ofType: "html")
            let templateString  = try? String(contentsOfFile: templateHTMLPath!, encoding: String.Encoding.utf8)
            let fileHTML = result.value!
            if let template = templateString {
                let htmlString = template.replacingOccurrences(of: "file_content", with: fileHTML)
                self.webView.loadHTMLString(htmlString, baseURL: baseURL)
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
