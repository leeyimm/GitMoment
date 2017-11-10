//
//  GTMFilePatchViewController.swift
//  GitMoment
//
//  Created by liying on 05/11/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit

class GTMFilePatchViewController: UIViewController {

    let fileInfo : GTMUpdatedFileInfo
    let scrollView = UIScrollView()
    let diffLabel = UILabel()
    init(fileInfo: GTMUpdatedFileInfo) {
        self.fileInfo = fileInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.size.equalTo(self.view)
            make.center.equalTo(self.view)
        }
        
        self.scrollView.addSubview(self.diffLabel)
        self.diffLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(15)
            make.right.equalTo(-10)
        }
        self.diffLabel.numberOfLines = 0
        self.diffLabel.attributedText = self.patchContent(patchString: fileInfo.patch!)
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
    
    func patchContent(patchString: String) -> NSAttributedString {
        let lines = patchString.components(separatedBy: CharacterSet.newlines)
        
        let attributedString = NSMutableAttributedString()
        
        for line in lines {
            var attributes = [
                NSAttributedStringKey.font: UIFont(name: "Courier", size: 16)!,
                NSAttributedStringKey.foregroundColor: UIColor(hex: "#24292e")
            ]
            if line.hasPrefix("+") {
                attributes[NSAttributedStringKey.backgroundColor] = UIColor(hex: "#e6ffed")
            } else if line.hasPrefix("-") {
                attributes[NSAttributedStringKey.backgroundColor] = UIColor(hex: "#ffeef0")
            }
            
            let newlinedLine = line != lines.last ? line + "\n" : line
            attributedString.append(NSAttributedString(string: newlinedLine, attributes: attributes))
        }
        
        return attributedString
    }

}
