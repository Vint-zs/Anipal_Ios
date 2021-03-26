//
//  LetterListViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/11.
//

import UIKit

class LetterListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension LetterListViewController:UITableViewDelegate, UITableViewDataSource {
    
    //cell 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //cell 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return letters.count
    }
    
    //cell 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! LetterListTableViewCell
        cell.user_name.text = letters[indexPath.row].from
        cell.user_img.image = letters[indexPath.row].img
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let writingVC = self.storyboard?.instantiateViewController(identifier: "letterDetail")as? LetterDetailViewController else{
            return
        }
        
        writingVC.name_from_var = letters[indexPath.row].from
        writingVC.content_var = letters[indexPath.row].content
       
        
        
        self.navigationController?.pushViewController(writingVC, animated: true)
    }
    
}
