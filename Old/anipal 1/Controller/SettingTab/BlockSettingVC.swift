//
//  BlockSettingVC.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/31.
//

import UIKit

class BlockSettingVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var blockTableView: UITableView!
    
    var blockedUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockTableView.delegate = self
        blockTableView.dataSource = self
        titleLabel.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        titleLabel.text = "Block List".localized
        finishBtn.setTitle("Complete".localized, for: .normal)
        
        print("blockedUsers: \(blockedUsers)")
    }
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishBlock(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BlockSettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockSettingViewCell", for: indexPath) as! BlockSettingViewCell
        
        // 대표동물 이미지
        cell.thumbImg.backgroundColor = .white
        cell.thumbImg.layer.cornerRadius = cell.thumbImg.frame.height/2
        cell.thumbImg.image = blockedUsers[indexPath.row].thumbnail
        
        cell.userName.text = blockedUsers[indexPath.row].name
        
        return cell
    }
}
