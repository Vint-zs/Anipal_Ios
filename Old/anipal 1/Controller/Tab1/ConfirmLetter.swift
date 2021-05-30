//
//  ConfirmLetter.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/28.
//

import UIKit
import SwiftyJSON

protocol modalDelegate: class {
    func pushNavigation()
    func refresh()
}

class ConfirmLetter: UIViewController {
    var delegate: modalDelegate?
    var randomId: String! = ""
    
    @IBOutlet var languageLbl: UILabel!
    @IBOutlet var favLbl: UILabel!
    @IBOutlet var senderLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var innerView: UIView!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        innerView.layer.cornerRadius = 20
        if let randomId = randomId {
            reloadData(id: randomId)
        }
        replyButton.setTitle("reply".localized, for: .normal)
        deleteButton.setTitle("delete".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    // MARK: - 닫기버튼 클릭시
    @IBAction func clickCancel(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: {
        })
    }
    // MARK: - 답장버튼 클릭시
    @IBAction func clickReply(_ sender: UIButton) {
        // self.dismiss(animated: true)
        
        let sub = UIStoryboard(name: "LetterListTab", bundle: nil)
        guard let replyVC = sub.instantiateViewController(identifier: "ReplyPage") as? ReplyPage else { return }
        
        replyVC.modalPresentationStyle = .fullScreen
        
        replyVC.receiverID = self.randomId
        replyVC.postURL = "/letters/random/" + self.randomId
        
        self.present(replyVC, animated: true, completion: nil)
    }
    // MARK: - 삭제버튼 클릭시
    @IBAction func clickDelete(_ sender: UIButton) {
        if let randomId = randomId {
            if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
                put(url: "/letters/random/" + randomId, token: session.value) { (data, response, error) in
                    guard let _ = data, error == nil else {
                        print("error=\(String(describing: error))")
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse {
                        if httpStatus.statusCode == 200 {
                            DispatchQueue.main.async {
                                print("delete success")
                                self.dismiss(animated: true) {
                                    self.delegate?.refresh()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                print("delete err code: \(httpStatus.statusCode)")
                                self.delegate?.refresh()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 데이터 수신 및 표출
    func reloadData(id: String) {
        // Authorization 쿠키 확인 & 데이터 로딩
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/letters/random/\(id)", token: session.value, completionHandler: { [self] data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        let json = JSON(data)
                        let content = json["content"].stringValue
                        var date = json["send_time"].stringValue
                        date = dateConvert(date: date)
                        let sender = json["sender"]["name"].stringValue
                        let favorite = json["sender"]["favorites"].arrayValue.map {$0.stringValue}
                        let languages = json["sender"]["languages"].arrayObject as? [[String: Any]]
                        
                        var fav: [String] = []
                        for favor in favorite {
                            fav.append(favor.localized)
                        }
                        
                        var lang: [String] = []
                        for row in languages ?? [] {
                            if let name = row["name"] as? String, let level = row["level"] as? Int {
                                var lev = ""
                                if level == 1 {
                                    lev = "Beginner"
                                } else if level == 2 {
                                    lev = "Intermediate"
                                } else {
                                    lev = "Advanced"
                                }
                                lang.append("\(name.localized):\(lev.localized)")
                            }
                        }

                        // 뷰생성
                        DispatchQueue.main.async {
                            textView.text = content
                            senderLbl.text = sender
                            dateLbl.text = date
                            favLbl.text = fav.joined(separator: " ")
                            languageLbl.text = lang.joined(separator: ", ")
                        }
                } else if httpStatus.statusCode == 400 {
                    print("error: \(httpStatus.statusCode)")
                } else {
                    print("error: \(httpStatus.statusCode)")
                }
            }
            })
        }
    }
    
    // MARK: - 날짜 형식 변환
    func dateConvert(date: String) -> String {
        let stringFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let formatter = DateFormatter()
        formatter.dateFormat = stringFormat
        // formatter.locale = Locale(identifier: "ko") 추후 국가별 문구 설정시 사용하기위해 주석처리
        guard let tempDate = formatter.date(from: date) else {
            return ""
        }
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: tempDate)

    }
    
}
