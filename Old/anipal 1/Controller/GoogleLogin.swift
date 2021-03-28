//
//  ViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/03.
//

import UIKit
import GoogleSignIn

class GoogleLogin: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
//    @IBAction func backBtn(_ sender: UIButton) {
//        //self.dismiss(animated: true, completion: nil)
//    }
    
}

extension GoogleLogin: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        guard let email = user.profile.email, email != "" else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
        
//        guard let homeVC = self.storyboard?.instantiateViewController(identifier: "TabBarController") else {
//            return
//        }
//
//        homeVC.modalTransitionStyle = .coverVertical
//        homeVC.modalPresentationStyle = .fullScreen
//        //self.navigationController?.pushViewController(homeVC, animated: true)
//
//        self.present(homeVC, animated: true)
        
//        print("User email: \(user.profile.email ?? "No email")")
//        print("User idToken: \(user.authentication.idToken ?? "No token")")
//        print("User fullName: \(user.profile.name ?? "No token")")
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
}
