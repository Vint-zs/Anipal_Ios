//
//  LetterListCell.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/08.
//

import UIKit

@IBDesignable
class LetterListCell: UICollectionViewCell {
    
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var arrivalDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
