//
//  FavoriteViewController.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/05.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favLabelTitle: UILabel!
    
    override func viewDidLoad() {
        favLabelTitle.text = "Choose your favorites.".localized
        super.viewDidLoad()
    }
}
