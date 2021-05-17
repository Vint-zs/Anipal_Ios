//
//  ComingAnimals.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/17.
//

import UIKit

class ComingAnimals: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var tableView: ComingAnimalTableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.loadComingAnimals()
    }
}
