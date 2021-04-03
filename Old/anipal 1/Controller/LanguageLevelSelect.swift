//
//  LanguageLevelSelect.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/04.
//

import UIKit

class LanguageLevelSelect: UIViewController {

    let levelList = ["초급", "중급", "고급"]
    @IBOutlet var levelTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        levelTable.delegate = self
        levelTable.dataSource = self
    }

}

extension LanguageLevelSelect: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "levelSelectCell", for: indexPath) as? LevelSelectTableViewCell else {
            return UITableViewCell()
        }
        cell.levelButton.layer.cornerRadius = 5
        cell.levelButton.setTitle(levelList[indexPath.row], for: .normal)
        return cell
    }
}
