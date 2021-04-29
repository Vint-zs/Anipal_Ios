//
//  ConfirmLetter.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/28.
//

import UIKit
import SwiftyJSON

protocol modalDelegate {
    func pushNavigation()
}

class ConfirmLetter: UIViewController {

    var delegate: modalDelegate?
    var randomId: String! = ""
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        innerView.layer.cornerRadius = 20
        replyButton.setTitle("reply".localized, for: .normal)
        deleteButton.setTitle("delete".localized, for: .normal)
        print("randomID " + randomId!)
        
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func clickReply(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.pushNavigation()
        }
    }
    
    @IBAction func clickDelete(_ sender: UIButton) {
        
        if let randomId = randomId {
            if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
                post(url: "/letters/random/" + randomId, token: session.value) { (data, response, error) in
                    guard let data = data, error == nil else {
                        print("error=\(String(describing: error))")
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse {
                        if httpStatus.statusCode == 200 {
                            print("랜덤편지 삭제 성공")
                        }
                        else {
                            print("편지삭제에러: \(httpStatus.statusCode)")
                        }
                    }
            
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
