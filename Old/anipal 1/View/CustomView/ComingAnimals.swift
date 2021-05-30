//
//  ComingAnimals.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/17.
//

import UIKit

class ComingAnimals: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var handleImg: UIImageView!
    @IBOutlet weak var tableView: ComingAnimalTableView!
    
    var row = 0
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.loadComingAnimals()
    }
}
