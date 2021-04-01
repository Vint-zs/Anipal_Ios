//
//  SettingPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/08.
//

import UIKit
import GoogleSignIn

class SettingPage: UIViewController {
    
    let settings: [String] = ["User info".localized, "Language".localized, "Concept".localized, "Favorite".localized]

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var settingTableView: UITableView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.setTitle("Logout".localized, for: .normal)
        
        self.settingTableView.tableFooterView = UIView(frame: .zero)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: self.performSegue(withIdentifier: "DefaultInfoVC", sender: nil)
        case 1: self.performSegue(withIdentifier: "LanguageSettingVC", sender: nil)
        case 2: self.performSegue(withIdentifier: "ConceptSettingVC", sender: nil)
        case 3: self.performSegue(withIdentifier: "FavoriteSettingVC", sender: nil)
        default:
            return
        }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
