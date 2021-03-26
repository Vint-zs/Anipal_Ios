//
//  SignUpViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/11.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    
//    @IBAction func backBtn(_ sender: UIButton) {
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
//    }
//
//    @IBAction func nextBtn(_ sender: UIButton) {
//
//        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "signupVC2") else {
//            return
//        }
//
//        nextVC.modalTransitionStyle = .coverVertical
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true)
//
//    }
    
    @IBAction func nextBarBtn(_ sender: UIBarButtonItem) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "signupVC2") else {
            return
        }

        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    

}
