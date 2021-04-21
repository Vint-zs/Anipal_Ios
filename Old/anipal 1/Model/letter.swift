//
//  letters.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/14.
//

import UIKit

struct Letter {
    let senderID: String
    let name: String
    let country: String
    let favorites: [String]
    let animal: [String]
    let receiverID: String
    let content: String
    let arrivalDate: String
    let sendDate: String
 
    init(senderID: String, name: String, country: String, favorites: [String], animal: [String], receiverID: String, content: String, arrivalDate: String, sendDate: String) {
        self.senderID = senderID
        self.name = name
        self.country = country
        self.favorites = favorites
        self.animal = animal
        self.receiverID = receiverID
        self.content = content
        self.arrivalDate = arrivalDate
        self.sendDate = sendDate
    }
    
}

let letters: [Letter] = [
    Letter(senderID: "123", name: "JB", country: "korea", favorites: [""], animal: [""], receiverID: "joon", content: "유리야 보고싶다 ㅜㅜ \n", arrivalDate: "2021-01-01", sendDate: "2021-01-01") ,
    
    Letter(senderID: "123", name: "young", country: "korea", favorites: [""], animal: [""], receiverID: "joon", content: "*사미라 공략법* \n사미라가 마지막으로 맞힌 공격과 다른 기본 공격 또는 스킬로 적 챔피언에게 피해를 입히면 콤보를 1회 쌓습니다. 각 콤보마다 E부터 S까지 총 6단계의 스타일 등급이 올라갑니다. 등급마다 3.5%의 이동 속도를 얻습니다. 사미라가 근접 공격 사거리 내에 있는 적에게 기본 공격을 가하면 2~19 (+0.75 추가AD)의 마법 피해를 입힙니다. 피해량은 대상이 잃은 체력에 비례하여 4~38 (+0.75 추가AD)까지 증가합니다. 사미라가 이동 불가 효과에 영향을 받은 적에게 기본 공격을 가하면 최대 사거리까지 돌진합니다. 해당 적이 공중으로 띄워진 상태라면 사미라도 최소 0.5초간 공중으로 띄웁니다. 사미라의 돌진 사거리는 650~950(1/4/8/12/16레벨에서) 입니다.", arrivalDate: "2021-01-01", sendDate: "2021-01-01"),
    
    Letter(senderID: "123", name: "bini0823", country: "korea", favorites: [""], animal: [""], receiverID: "joon", content: "안녕하세요 ㅋㅋ ", arrivalDate: "2021-01-01", sendDate: "2021-01-01"),
    
    Letter(senderID: "123", name: "윤동주", country: "korea", favorites: [""], animal: [""], receiverID: "joon", content: "계절이 지나가는 하늘에는 가을로 가득 차 있습니다. 나는 아무 걱정도 없이 가을 속의 별들을 다 헤일 듯합니다...\n가슴 속에 하나 둘 새겨지는 별을이제 다 못 헤는 것은 쉬이 아침이 오는 까닭이요, 내일 밤이 남은 까닭이요, 아직 나의 청춘이 다하지 않은 까닭입니다.\n별 하나에 추억과 별 하나에 사랑과 별 하나에 쓸쓸함과 별 하나에 동경과 별 하나에 시와 별 하나에 어머니, 어머니\n 어머님, 나는 별 하나에 아름다운 말 한 마디씩 불러 봅니다. 소학교 때 책상을 같이했던 아이들의 이름과, 패, 경, 옥 이런 이국 소녀들의 이름과, 벌써 아기 어머니 된 계집애들의 이름과, 가난한 이웃 사람들의 이름과, 비둘기, 강아지, 토끼, 노새, 노루, '프랑시스 잠', '라이너 마리아 릴케', 이런 시인의 이름을 불러 봅니다.", arrivalDate: "2021-01-01", sendDate: "2021-01-01")

]

let newLetters: [Letter] = [
    Letter(senderID: "123", name: "Ananasaa", country: "korea", favorites: [""], animal: [""], receiverID: "joon", content: "안녕하세요!\n저는 아야입니다.\n이집트사람 입니다.\nI'm new in learning Korean \nI like to reading,writing\nWhat about you?", arrivalDate: "2021-01-01", sendDate: "2021-01-01"),
    
    Letter(senderID: "123", name: "thiago", country: "korea", favorites: [""], animal: [""], receiverID: "joon", content: "Hey! \nWhat's your favorite city in the world and why?", arrivalDate: "2021-01-01", sendDate: "2021-01-01"),
    
    Letter(senderID: "123", name: "turkkk", country: "korea", favorites: [""], animal: [""], receiverID: "joon", content: "Heeey... Beni duyan var mi?... Ordakimse var mi?....", arrivalDate: "2021-01-02", sendDate: "2021-01-01")

]
