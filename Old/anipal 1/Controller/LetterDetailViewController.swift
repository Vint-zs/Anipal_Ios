//
//  LetterDetailViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit

class LetterDetailViewController: UIViewController {

    @IBOutlet weak var name_from: UILabel!
    @IBOutlet weak var textview_content: UITextView!
    
    var name_from_var:String?
    var content_var:String?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name_from.text = name_from_var
        textview_content.text = content_var
 
    }
    
    
    @IBAction func wrtieBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "WritingPage")as? WritingPage else{
            return
        }
        
        // name_to nil처리 수정필요 guard let?
        nextVC.name_var = "RE: " + name_from_var!
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
