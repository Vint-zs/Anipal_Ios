//
//  DefaultInfoVC.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/01.
//

import UIKit

class FavoriteSettingVC: UIViewController {
    
    @IBOutlet weak var favLabelTitle: UILabel!
    @IBOutlet var favCollectionView: FavoriteView!
    @IBOutlet weak var finishBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favLabelTitle.text = "Choose your favorites.".localized
        favLabelTitle.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        finishBtn.setTitle("Complete".localized, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ad?.favorites = favCollectionView.userFav
    }
    
    @IBAction func cancelFav(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishFav(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
