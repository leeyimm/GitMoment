//
//  GTMFileContentViewController.swift
//  GitMoment
//
//  Created by liying on 31/10/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit
import SwiftSoup

class GTMFileContentViewController: GTMBaseViewController {
    
    var filePath : String!
    var webView = UIWebView()
    
    init(filePath: String) {
        super.init(nibName: nil, bundle: nil)
        self.filePath = filePath
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
        GTMAPIManager.sharedInstance.fetchFileContent(path: filePath) { (result) in
            guard result.error == nil else {
                return
            }
            var fileContentHtml : String!
            let fileHTML = result.value!
            do {
                let doc: Document = try SwiftSoup.parse(fileHTML)
                let file: Element = try doc.select("div.file").first()!
                fileContentHtml = try? file.html()
            } catch {
                fileContentHtml = "No conent"
            }
            let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)

            let templateHTMLPath = Bundle.main.path(forResource: "fileTemplate", ofType: "html")
            let templateString  = try? String(contentsOfFile: templateHTMLPath!, encoding: String.Encoding.utf8)
            if let template = templateString {
                let htmlString = template.replacingOccurrences(of: "file_content", with: fileContentHtml)
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
