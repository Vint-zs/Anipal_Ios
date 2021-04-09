//
//  LetterListMenu.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/10.
//

import UIKit

class LetterListMenu: UITableViewController {
    
    let sorting = ["Newest".localized, "Frequency".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LetterListMenu {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorting.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LetterListMenuCell", for: indexPath)
        
        cell.textLabel?.text = sorting[indexPath.row]
        
        return cell
    }
}
