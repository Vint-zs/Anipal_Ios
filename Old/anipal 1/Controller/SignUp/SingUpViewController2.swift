//
//  SingUpViewController2.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit

class SingUpViewController2: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var languageTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
//    let searchController = UISearchController(searchResultsController: nil)
    
    let languageList = ["English", "한국어", "日本語", "中文", "Italiano","프랑스어","포르투갈어"]
    var myLanguageList: [String:Int] = ["한국어":1,"프랑스어":3]

    override func viewDidLoad() {
        super.viewDidLoad()
        languageTableView.delegate = self
        languageTableView.dataSource = self
//        titleLabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
        titleLabel.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "search Keyword"
//        navigationItem.searchController = searchController

    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "conceptSelectVC") else {
            return
        }
        ad?.languages = myLanguageList
        print(ad?.languages)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
extension SingUpViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as? LanguageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.languageName.text = languageList[indexPath.row]
        cell.languageName.textColor = UIColor.init(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        cell.languageLevel.textColor = UIColor.init(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        // cell.languageLevel.text = String(level)
        // cell.languageName.font = UIFont(name: "Helvetica-Bold", size: 18)
        
        cell.checkBox.layer.borderWidth = 1
        cell.checkBox.layer.borderColor = UIColor.init(red: 0.392, green: 0.392, blue: 0.392, alpha: 1).cgColor
        cell.checkBox.layer.cornerRadius = 5
        cell.checkBox.clipsToBounds = true
        cell.checkBox.backgroundColor = .white
        
        if myLanguageList.keys.contains(languageList[indexPath.row]) {
            cell.checkBox.image = #imageLiteral(resourceName: "checkBox")
            let level = myLanguageList[languageList[indexPath.row]]!
            if level == 1 {
                cell.languageLevel.text = "Beginner".localized
            } else if level == 2 {
                cell.languageLevel.text = "Intermediate".localized
            } else {
                cell.languageLevel.text = "Advanced".localized
            }
            
        } else {
            cell.checkBox.image = #imageLiteral(resourceName: "emptyCheckBox")
            cell.languageLevel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if myLanguageList.keys.contains(languageList[indexPath.row]) {
            myLanguageList.removeValue(forKey: languageList[indexPath.row])
            print(myLanguageList)
            self.languageTableView.reloadData()
        } else {
            
            let alertcontroller = UIAlertController(title: "Level".localized, message: nil, preferredStyle: .actionSheet)
            let basicBtn = UIAlertAction(title: "Beginner".localized, style: .default) { (_) in
                self.myLanguageList[self.languageList[indexPath.row]] = 1
                self.languageTableView.reloadData()
            }
            let mediumBtn = UIAlertAction(title: "Intermediate".localized, style: .default) { (_) in
                self.myLanguageList[self.languageList[indexPath.row]] = 2
                self.languageTableView.reloadData()
            }
            let intermediateBtn = UIAlertAction(title: "Advanced".localized, style: .default) { (_) in
                self.myLanguageList[self.languageList[indexPath.row]] = 3
                self.languageTableView.reloadData()
            }
            
            let cancelBtn = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            alertcontroller.addAction(basicBtn)
            alertcontroller.addAction(mediumBtn)
            alertcontroller.addAction(intermediateBtn)
            alertcontroller.addAction(cancelBtn)
            present(alertcontroller, animated: true, completion: nil)
        }
    }
}

extension SingUpViewController2: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
      }
}
