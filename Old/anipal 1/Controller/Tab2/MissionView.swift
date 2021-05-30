//
//  MissionView.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/12.
//

import UIKit

class MissionView: UIViewController {

    @IBOutlet var okBtn: UIButton!
    @IBOutlet var innerView: UIView!
    @IBOutlet var accessoryImage: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var missionTitle: UITextView!
    @IBOutlet var itemName: UILabel!
    
    var accessoryInfo: AccessoryDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okBtn.layer.cornerRadius = 5
        innerView.layer.cornerRadius = 20
        accessoryImage.layer.borderWidth = 2
        accessoryImage.layer.borderColor = UIColor.lightGray.cgColor
        accessoryImage.image = accessoryInfo?.img
        itemName.text = accessoryInfo?.name.localized
        missionTitle.text = accessoryInfo?.missionTitle.localized
        textView.text = accessoryInfo?.missionContent.localized
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickOkBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
