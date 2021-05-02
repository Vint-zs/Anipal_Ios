//
//  replyPage.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/01.
//

import UIKit

protocol replyHiddenDelegate {
    func replyButtonDelegate(data: Bool)
}

class ReplyPage: UIViewController, sendBackDelegate {
    
    // 임시 데이터
    let initAnimals: [Animal] = [
        Animal(nameInit: "bird", image: #imageLiteral(resourceName: "bird")),
        Animal(nameInit: "monkey2", image: #imageLiteral(resourceName: "monkey2")),
        Animal(nameInit: "panda", image: #imageLiteral(resourceName: "panda"))
    ]
    let postAnimal = ["animal_url": "1", "head_url": "2", "top_url": "3", "pants_url": "4", "shoes_url": "5", "gloves_url": "6"]
    let comingAnimal = ["animal_url": "1", "color": "2"]
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var animalBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    var delegate: replyHiddenDelegate?
    
    var receiverID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderSetting()
        
        // 동물 선택 버튼
        animalBtn.backgroundColor = .white
        animalBtn.layer.cornerRadius = animalBtn.frame.height/2
        animalBtn.layer.borderWidth = 0.3
        animalBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        // 저장&전송 버튼
        saveBtn.setTitle("Send".localized, for: .normal)
        setBtnUI(btn: saveBtn)
        sendBtn.setTitle("Reply".localized, for: .normal)
        setBtnUI(btn: sendBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func dataReceived(data: Int) {
        print(data)
        animalBtn.setImage(initAnimals[data].img, for: .normal)
    }
    
    @IBAction func selectAnimalBtn(_ sender: UIButton) {
        let sub = UIStoryboard(name: "SignUp", bundle: nil)
        guard let nextVC = sub.instantiateViewController(identifier: "selectAnimalVC") as? SelectAnimal else {
            return
        }
        nextVC.delegate = self
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func sendDataBtn(_ sender: UIButton) {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            let url = "/letters"
            let body: NSMutableDictionary = NSMutableDictionary()
            body.setValue(textView.text, forKey: "content")
            body.setValue(receiverID, forKey: "receiver")
            body.setValue(postAnimal, forKey: "post_animal")
            body.setValue(comingAnimal, forKey: "coming_animal")
            body.setValue("1h 1m 1s", forKey: "delay_time")
            
            try? post(url: url, token: session.value, body: body, completionHandler: { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                print(String(data: data, encoding: .utf8)!)
            })
        }
        
        delegate?.replyButtonDelegate(data: false)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 편지내용
extension ReplyPage: UITextViewDelegate {

    // placeholder
    func placeholderSetting() {
        textView.delegate = self
        textView.text = "Enter the content"
        textView.textColor = UIColor.lightGray
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
    // 버튼 ui
    func setBtnUI(btn: UIButton) {
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

