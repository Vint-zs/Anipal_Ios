//
//  NewLetterViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/03/02.
//

import UIKit

class NewLetterViewController: UIViewController {

    
    @IBOutlet var name_from: UILabel!
    @IBOutlet var content_label: UILabel!
    
    var name_from_var:String?
    var content_var:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content_label.sizeToFit()
        name_from.text = name_from_var
        content_label.text = content_var
        // Do any additional setup after loading the view.
    }
    
    //MARK: -  네비게이션바 숨기기
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = false
//    }
    
    //MARK: - 버리기 버튼 클릭시
    @IBAction func clickDismiss(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    //MARK: - 답장 버튼 클릭시
    @IBAction func clickReply(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "WritingPage") as? WritingPage else {
            return
        }
//
//        guard let prevVC = self.presentingViewController else {
//            return
//        }
        
        nextVC.name_var = "RE: " + name_from_var!
        
//        self.presentingViewController?.dismiss(animated: true) {
//            prevVC.navigationController?.pushViewController(nextVC, animated: true)
//        }

        self.navigationController?.pushViewController(nextVC, animated: true)
        //nextVC.modalPresentationStyle = .fullScreen
        //self.present(nextVC, animated: true)
    }
    
    
}
