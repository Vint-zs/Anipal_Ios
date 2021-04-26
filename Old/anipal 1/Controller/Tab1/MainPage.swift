//
//  MainPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit
import SwiftyJSON

class MainPage: UIViewController {

    @IBOutlet var writingButton: UIButton!
    
    var receiveAniaml: [RandomAnimal] = []
    var receiveLetter: [RandomLetter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/letters/random", token: session.value) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        if self.receiveAniaml.count != JSON(data).count {
                            for idx in 0..<JSON(data).count {
                                let json = JSON(data)[idx]
                                print(json)
                                let animal: [String: String] = [
                                    "animal_url": json["post_animal"]["animal_url"].stringValue,
                                    "head_url": json["post_animal"]["head_url"].stringValue,
                                    "top_url": json["post_animal"]["top_url"].stringValue,
                                    "pants_url": json["post_animal"]["pants_url"].stringValue,
                                    "shoes_url": json["post_animal"]["shoes_url"].stringValue,
                                    "gloves_url": json["post_animal"]["gloves_url"].stringValue]
                                self.receiveAniaml.append(RandomAnimal(id: json["_id"].stringValue, animal: animal))
                            }
                        }
                    }
                }
            }
        }
        
        // 동물 버튼 생성
        DispatchQueue.main.async { [self] in
            let button1 = makeButton(image: #imageLiteral(resourceName: "penguin"))
            let button2 = makeButton(image: #imageLiteral(resourceName: "penguin"))
            view.addSubview(button1)
            view.addSubview(button2)
            
            locateButton(button: button1, left: 40, bottom: -200)
            locateButton(button: button2, left: 160, bottom: -400)

            button1.addTarget(self, action: #selector(pressed(_ :)), for: .touchUpInside)
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - 편지도착 텍스트 클릭시
    @IBAction func textBtnClick(_ sender: UIButton) {
//        guard let letterListVC = self.storyboard?.instantiateViewController(identifier: "LetterListVC") else {
//            return
//        }
//
//        self.navigationController?.pushViewController(letterListVC, animated: true)
        self.tabBarController?.selectedIndex = 2
    }
    
    // MARK: - 편지작성 버튼 클릭시
    @IBAction func writeButton(_ sender: UIButton) {
        guard let writingVC = self.storyboard?.instantiateViewController(identifier: "WritingPage") else {
            return
        }

        self.navigationController?.pushViewController(writingVC, animated: true)
    }
    // MARK: - 동물 버튼 생성
    func makeButton(image: UIImage? = nil ) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }
    
    // MARK: - 버튼 오토레이아웃 설정
    func locateButton(button: UIButton, left: Int, bottom: Int) {
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(left)).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(bottom)).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 430/356).isActive = true
    }
    
    @objc func pressed(_ sender: UIButton) {
        print("pressed")
    }

}
