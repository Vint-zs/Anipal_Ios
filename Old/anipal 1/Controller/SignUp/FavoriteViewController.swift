//
//  FavoriteViewController.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/05.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var favLabelTitle: UILabel!
    
    override func viewDidLoad() {
        favLabelTitle.text = "Choose your favorites.".localized
        favLabelTitle.textColor = UIColor(red: 0.392, green: 0.392, blue: 0.392, alpha: 1)
        super.viewDidLoad()
    }
    
    @IBAction func nextPageButton(_ sender: UIButton) {
        //postData(url: "https://anipal.tk/auth/register", token: ad?.token)
    }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//func postData(url: String, token: String) {
//    // 1. 전송할 값 준비
//    let param = ["name": ad?.name, "gender": ad?.gender,"age": ?? ,"birthday":ad?.birthday,"email":ad?.email,"provider":ad?.provider,"favorites": ad?.favorties
//                 ,"languages" : ] // JSON 객체로 변환할 딕셔너리 준비
//
//    let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])
//
//    // 2. URL 객체 정의
//    let url = URL(string: url);
//
//    // 3. URLRequest 객체 정의 및 요청 내용 담기
//    var request = URLRequest(url: url!)
//    request.httpMethod = "POST"
//    request.httpBody = paramData
//
//    // 4. HTTP 메시지에 포함될 헤더 설정
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "accept")
//    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//    //request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
//
//    // 5. URLSession 객체를 통해 전송 및 응답값 처리 로직 작성
//    let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
//
//        guard let data = data, error == nil else {                                                 // check for fundamental networking error
//            print("error=\(error)")
//            return
//            }
//
//        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//            print("statusCode should be 200, but is \(httpStatus.statusCode)")
//            print("response = \(response)")
//        }
//
//        let responseString = String(data: data, encoding: .utf8)
//        print("responseString = \(responseString)")
//}
//    // 6. POST 전송
//    task.resume()
//}
