//
//  animal3.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

struct AnimalPost {
    let animalID: String
    let animal: String
    let animalURLs: [String: String]
    let isUsed: Bool
    let delayTime: String
    let comingAnimal: [String: String]
    let animalImg: UIImage
    
    init(animalID: String,animal: String, animalURLs: [String: String], isUsed: Bool, delayTime: String, comingAnimal: [String: String], animalImg: UIImage) {
        self.animalID = animalID
        self.animal = animal
        self.animalURLs = animalURLs
        self.isUsed = isUsed
        self.delayTime = delayTime
        self.comingAnimal = comingAnimal
        self.animalImg = animalImg
    }
}

struct Animal {
    let name: String
    let img: UIImage
    let url: String
    
    init(nameInit: String, image: UIImage, imageUrl: String) {
        name = nameInit
        img = image
        url = imageUrl
    }
    
    // 테스트이미지용 임시 생성자. 모든코드 서버이미지로 전환작업 완료후 아래쪽 테스트데이터 삭제시 삭제예정
    init(nameInit: String, image: UIImage) {
        name = nameInit
        img = image
        url = ""
    }
}

let animals: [Animal] = [
    Animal(nameInit: "bird", image: #imageLiteral(resourceName: "bird")),
    Animal(nameInit: "monkey2", image: #imageLiteral(resourceName: "monkey2")),
    Animal(nameInit: "panda", image: #imageLiteral(resourceName: "panda")),
    Animal(nameInit: "elephant", image: #imageLiteral(resourceName: "elephant")),
    Animal(nameInit: "dog", image: #imageLiteral(resourceName: "dog")),
    Animal(nameInit: "horse", image: #imageLiteral(resourceName: "donkey")),
    Animal(nameInit: "lion", image: #imageLiteral(resourceName: "lion")),
    Animal(nameInit: "chicken", image: #imageLiteral(resourceName: "chicken")),
    Animal(nameInit: "fox", image: #imageLiteral(resourceName: "fox")),
    Animal(nameInit: "penguin", image: #imageLiteral(resourceName: "ourPengiun")),
    Animal(nameInit: "black", image: #imageLiteral(resourceName: "black")),
    Animal(nameInit: "monkey", image: #imageLiteral(resourceName: "monkey")),
    Animal(nameInit: "zebra", image: #imageLiteral(resourceName: "zebra")),
    Animal(nameInit: "pig", image: #imageLiteral(resourceName: "pig")),
    Animal(nameInit: "pyobeom", image: #imageLiteral(resourceName: "pyobeom")),
    Animal(nameInit: "tiger", image: #imageLiteral(resourceName: "tiger"))
]
