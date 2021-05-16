//
//  AnimalDetail.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/12.
//

import UIKit

class AnimalDetail: UIViewController {

    @IBOutlet var innerView: UIView!
    @IBOutlet var okBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius = 5
        innerView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    @IBAction func clickOkBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
