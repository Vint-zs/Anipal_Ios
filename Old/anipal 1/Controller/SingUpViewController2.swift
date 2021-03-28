//
//  SingUpViewController2.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit

class SingUpViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        
        guard let loginVC = self.storyboard?.instantiateViewController(identifier: "GoogleLogin") else {
            return
        }
        
        navigationController?.pushViewController(loginVC, animated: true)
//        loginVC.modalTransitionStyle = .coverVertical
//        loginVC.modalPresentationStyle = .fullScreen
//        self.present(loginVC, animated: true)
        
    }
    
}
