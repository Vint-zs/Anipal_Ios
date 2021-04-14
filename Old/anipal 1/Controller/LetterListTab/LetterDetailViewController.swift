//
//  LetterDetailViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit

class LetterDetailViewController: UIViewController {

//    @IBOutlet weak var nameFrom: UILabel!
    @IBOutlet weak var textviewContent: UITextView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    var nameFromVar: String?
    var contentVar: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Letter".localized
        self.navigationItem.rightBarButtonItem = menuBtn
        

//        nameFrom.text = nameFromVar
        textviewContent.text = contentVar
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
