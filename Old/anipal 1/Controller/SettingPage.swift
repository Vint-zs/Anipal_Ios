//
//  SettingPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/08.
//

import UIKit
import GoogleSignIn

class SettingPage: UIViewController {
    
    let settings: [String] = ["정보 수정", "언어", "컨셉", "관심사"]

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var settingTableView: UITableView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickLogoutBtn(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
    }
}

extension SettingPage: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingPageTableViewCell", for: indexPath) as? SettingPageTableViewCell else { return UITableViewCell() }
        cell.settingLabel.text = settings[indexPath.row]
        
        return cell
    }
    
}
