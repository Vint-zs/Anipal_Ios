//
//  LetterDetailViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit
import SwiftyJSON

class LetterDetailViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderCountry: UILabel!
    @IBOutlet weak var senderFav: UILabel!
    @IBOutlet weak var senderAnimal: UIImageView!
    @IBOutlet weak var letterCtrl: UIPageControl!
    
    let content = ["a", "b", "c", "d", "e"]
    
    var nameFromVar: String?
    var contentVar: String?
    var mailBoxID: String?
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
        
        getLetters()
        
        // 편지 내용
        textViewContent.layer.cornerRadius = 10
        textViewContent.text = content[letterCtrl.currentPage]
        textViewContent.isEditable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            let url = "/mailboxes/show/" + mailBoxID!
            print("url: \(url)")
            print("token: \(session.value)")
            get(url: url, token: session.value, completionHandler:  {
                data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        print("data: \(JSON(data))")
                    } else if httpStatus.statusCode == 400 {
                        print("error: \(httpStatus.statusCode)")
                    } else {
                        print("error: \(httpStatus.statusCode)")
                    }
                }
            })
        }
    }
    
    @IBAction func writeBtn(_ sender: UIButton) {
        
        let sub = UIStoryboard(name: "Tab1", bundle: nil)
        guard let nextVC = sub.instantiateViewController(identifier: "WritingPage")as? WritingPage else {
            return
        }

        // name_to nil처리 수정필요 guard let?
        nextVC.nameVar = "RE: \(String(describing: nameFromVar))"

        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    func getLetters() {
        // 페이지 컨트롤 UI
        letterCtrl.hidesForSinglePage = true
        letterCtrl.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        letterCtrl.pageIndicatorTintColor = UIColor(red: 0.946, green: 0.946, blue: 0.946, alpha: 1)
        letterCtrl.currentPageIndicatorTintColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        
        // 편지 본문 로딩
        letterCtrl.numberOfPages = content.count
        letterCtrl.currentPage = letterCtrl.numberOfPages - 1
    }
    
    // 편지 넘기기
    @IBAction func letterSlide(_ sender: UIPageControl) {
        textViewContent.text = content[letterCtrl.currentPage]
    }
    
    @IBAction func letterMenu(_ sender: Any) {
        let alertcontroller = UIAlertController(title: "Menu".localized, message: nil, preferredStyle: .actionSheet)
        let deleteBtn = UIAlertAction(title: "Delete".localized, style: .default)
        let blockBtn = UIAlertAction(title: "Block".localized, style: .default)
        let cancelBtn = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alertcontroller.addAction(deleteBtn)
        alertcontroller.addAction(blockBtn)
        alertcontroller.addAction(cancelBtn)
        present(alertcontroller, animated: true, completion: nil)
    }
}
