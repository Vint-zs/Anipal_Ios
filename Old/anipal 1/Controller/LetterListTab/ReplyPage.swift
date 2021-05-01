//
//  replyPage.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/01.
//

import UIKit

class ReplyPage: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var animalBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderSetting()
        
        // 동물 선택 버튼
        animalBtn.backgroundColor = .white
        animalBtn.layer.cornerRadius = animalBtn.frame.height/2
        animalBtn.layer.borderWidth = 0.3
        animalBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        // 저장&전송 버튼
        setBtnUI(btn: saveBtn)
        setBtnUI(btn: sendBtn)
        
        // 네비게이션 바 색상
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.95, green: 0.973, blue: 1, alpha: 1)
        // 네비게이션 버튼 색상
        navigationController?.navigationBar.tintColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        // 네이베이션바 선 없애기
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - 편지내용 Place Holder 작업
extension ReplyPage: UITextViewDelegate {

    func placeholderSetting() {
        textView.delegate = self
        textView.text = "Enter the content"
        textView.textColor = UIColor.lightGray
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
    func setBtnUI(btn: UIButton) {
        //btn.setTitle("Reply".localized, for: .normal)
        btn.layer.shadowColor = UIColor.lightGray.cgColor
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 3
        btn.layer.masksToBounds = false
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {

            textView.text = "Enter the content"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }

        return false
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

