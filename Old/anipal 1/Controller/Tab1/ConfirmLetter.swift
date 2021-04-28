//
//  ConfirmLetter.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/28.
//

import UIKit

class ConfirmLetter: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        innerView.layer.cornerRadius = 20
        replyButton.setTitle("reply".localized, for: .normal)
        deleteButton.setTitle("delete".localized, for: .normal)
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            print("I'm back")
        })
    }
    
    @IBAction func clickReply(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: {
            print("Aa")
        })
        
    }
    
    @IBAction func clickDelete(_ sender: UIButton) {
    }
    
}
//        guard let writingVC = self.storyboard?.instantiateViewController(identifier: "WritingPage") else {
//            return
//        }
//        self.navigationController?.pushViewController(writingVC, animated: true)
