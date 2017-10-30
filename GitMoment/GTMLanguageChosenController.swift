//
//  GTMLanguageChosenController.swift
//  GitMoment
//
//  Created by liying on 16/09/2017.
//  Copyright © 2017 liying. All rights reserved.
//

import UIKit


class GTMLanguageChosenController: UIViewController {
    
    let languageCellIdentifier = "languageCell"
    
    var tableView : UITableView = UITableView()
    
    var chosenLanguage : String
    var chosenLanguageIndexPath : IndexPath?
    var languageIndexList : [String] = [String]()
    var languages : [[String]]  = [[String]]()
    
    init(chosenLanguage: String?) {
        self.chosenLanguage = chosenLanguage ?? "all languages"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Languages"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: languageCellIdentifier)
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        GTMAPIManager.sharedInstance.fetchLanguagesList { (languageList) in
            self.processLanguageList(languageList: languageList)
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }
    
    func processLanguageList(languageList: [String]) {
        var previousIndex : String = String(languageList[0].characters.first!)
        self.languageIndexList.append(previousIndex)
        var languageSection : [String] = [String]()
        for language in languageList {
            let index : String  = String(language.characters.first!)
            if index == previousIndex {
                languageSection.append(language)
            } else {
                self.languages.append(languageSection)
                languageSection.removeAll()
                languageSection.append(language)
                self.languageIndexList.append(index)
                previousIndex = index
            }
        }
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

extension GTMLanguageChosenController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.languages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languages[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: languageCellIdentifier, for: indexPath)
        let language = self.languages[indexPath.section][indexPath.row]
        cell.textLabel?.text = language
        if chosenLanguage == language.lowercased() {
            cell.accessoryType = .checkmark
            self.chosenLanguageIndexPath = indexPath
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
}

extension GTMLanguageChosenController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.languageIndexList
    }
    
    private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.languageIndexList[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        self.chosenLanguage = self.languages[indexPath.section][indexPath.row].lowercased()
        if let previousChosenLanguageIndexPath = self.chosenLanguageIndexPath {
            let previousSelectedCell = tableView.cellForRow(at: previousChosenLanguageIndexPath)
            previousSelectedCell?.accessoryType = .none
            self.chosenLanguageIndexPath = indexPath
        }
        //set chosen language
        if self.chosenLanguage == "all languages" {
            UserDefaults.standard.setValue(nil, forKey: GTMConstantValue.userChosenLanguageKey)
        } else {
            UserDefaults.standard.setValue(self.chosenLanguage, forKey: GTMConstantValue.userChosenLanguageKey)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
}
