//
//  StartPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/08.
//

import UIKit
// logoutBtn.layer.cornerRadius = 10

class StartPage: UIViewController {

    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 10
        signupBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
// MARK: - 회원가입버튼
    @IBAction func clickSignupBtn(_ sender: UIButton) {
        
        guard let signupVC = self.storyboard?.instantiateViewController(identifier: "SignUpVC1") else {
            return
        }

        // signupVC.modalTransitionStyle = .coverVertical
        // signupVC.modalPresentationStyle = .fullScreen
        // self.present(signupVC, animated: true)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
// MARK: - 로그인버튼
    
    @IBAction func clickLoginBtn(_ sender: UIButton) {
        
        guard let loginVC = self.storyboard?.instantiateViewController(identifier: "GoogleLogin") else {
            return
        }
        
        // loginVC.modalTransitionStyle = .coverVertical
        // loginVC.modalPresentationStyle = .fullScreen
        // self.present(loginVC, animated: true)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
