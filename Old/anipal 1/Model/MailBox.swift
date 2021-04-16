//
//  MailBox.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/16.
//

import Foundation

struct MailBox {
    var mailBoxID: String
    var isOpened: Bool
    var partner: [String: Any]
    var thumbnail: [String: String]
    var arrivalDate: String
    var letterCount: Int
    
    init(mailBoxID: String, isOpened: Bool, partner: [String: Any], thumbnail: [String: String], arrivalDate: String, letterCount: Int) {
        self.mailBoxID = mailBoxID
        self.isOpened = isOpened
        self.partner = partner
        self.thumbnail = thumbnail
        self.arrivalDate = arrivalDate
        self.letterCount = letterCount
    }
}
