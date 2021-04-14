//
//  LetterDetailViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit

class LetterDetailViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderCountry: UILabel!
    @IBOutlet weak var senderFav: UILabel!
    @IBOutlet weak var senderAnimal: UIImageView!
    
    var nameFromVar: String?
    var contentVar: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션
        self.navigationItem.title = "Letter".localized
        self.navigationItem.rightBarButtonItem = menuBtn
        
        // 보낸 사용자 정보
        topView.layer.backgroundColor = UIColor(red: 0.946, green: 0.946, blue: 0.946, alpha: 1).cgColor
        
        senderName.text = nameFromVar
        senderName.sizeToFit()
        
        senderAnimal.backgroundColor = .white
        senderAnimal.layer.cornerRadius = senderAnimal.frame.height/2
        senderAnimal.layer.borderWidth = 0.3
        senderAnimal.layer.borderColor = UIColor.lightGray.cgColor
        
        // 편지 내용
        textViewContent.layer.cornerRadius = 10
        textViewContent.text = contentVar
    }
    
    @IBAction func writeBtn(_ sender: UIButton) {
        
        let sub = UIStoryboard(name: "Tab1", bundle: nil)
        guard let nextVC = sub.instantiateViewController(identifier: "WritingPage")as? WritingPage else {
            return
        }

        // name_to nil처리 수정필요 guard let?
        nextVC.nameVar = "RE: " + nameFromVar!

        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
