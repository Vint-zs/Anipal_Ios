//
//  MainPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

class MainPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 버튼 생성
        let button1 = makeButton(image: #imageLiteral(resourceName: "penguin"))
        let button2 = makeButton(image: #imageLiteral(resourceName: "penguin"))
        view.addSubview(button1)
        view.addSubview(button2)
        
        locateButton(button: button1, left: 40, bottom: -200)
        locateButton(button: button2, left: 160, bottom: -400)
//        button2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
//        button2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        
       // button1.heightAnchor.constraint(equalToConstant: 40).isActive = true

        button1.addTarget(self, action: #selector(pressed(_ :)), for: .touchUpInside)

    }
    
    // MARK: - 네비게이션바 숨김
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
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
    
    // MARK: - 글쓰기버튼 클릭시
    @IBAction func writeButton(_ sender: UIButton) {
        guard let writingVC = self.storyboard?.instantiateViewController(identifier: "WritingPage") else {
            return
        }

        self.navigationController?.pushViewController(writingVC, animated: true)
    }
    //MARK: - 버튼 생성
    func makeButton(image: UIImage? = nil ) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }
    
    //MARK: - 버튼 오토레이아웃 설정
    func locateButton(button: UIButton, left: Int, bottom: Int) {
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(left)).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(bottom)).isActive = true
    }
    
    @objc func pressed(_ sender: UIButton) {
        print("pressed")
    }

}
