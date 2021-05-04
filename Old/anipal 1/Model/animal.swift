//
//  animal3.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/06.
//

import UIKit

struct Animal {
    let animal: String
    let animalURLs: [String: String]
    let isUsed: Bool
    let delayTime: String
    let comingAnimal: [String: String]
    let animalImg: UIImage
    
    init(animal: String, animalURLs: [String: String], isUsed: Bool, delayTime: String, comingAnimal: [String: String], animalImg: UIImage) {
        self.animal = animal
        self.animalURLs = animalURLs
        self.isUsed = isUsed
        self.delayTime = delayTime
        self.comingAnimal = comingAnimal
        self.animalImg = animalImg
    }
}

struct AnimalTemp {
    let name: String
    let img: UIImage
    
    init(nameInit: String, image: UIImage) {
        self.name = nameInit
        self.img = image
    }
}

let animals: [AnimalTemp] = [
    AnimalTemp(nameInit: "bird", image: #imageLiteral(resourceName: "bird")),
    AnimalTemp(nameInit: "monkey2", image: #imageLiteral(resourceName: "monkey2")),
    AnimalTemp(nameInit: "panda", image: #imageLiteral(resourceName: "panda")),
    AnimalTemp(nameInit: "elephant", image: #imageLiteral(resourceName: "elephant")),
    AnimalTemp(nameInit: "dog", image: #imageLiteral(resourceName: "dog")),
    AnimalTemp(nameInit: "horse", image: #imageLiteral(resourceName: "donkey")),
    AnimalTemp(nameInit: "lion", image: #imageLiteral(resourceName: "lion")),
    AnimalTemp(nameInit: "chicken", image: #imageLiteral(resourceName: "chicken")),
    AnimalTemp(nameInit: "fox", image: #imageLiteral(resourceName: "fox")),
    AnimalTemp(nameInit: "penguin", image: #imageLiteral(resourceName: "penguin")),
    AnimalTemp(nameInit: "black", image: #imageLiteral(resourceName: "black")),
    AnimalTemp(nameInit: "monkey", image: #imageLiteral(resourceName: "monkey")),
    AnimalTemp(nameInit: "zebra", image: #imageLiteral(resourceName: "zebra")),
    AnimalTemp(nameInit: "pig", image: #imageLiteral(resourceName: "pig")),
    AnimalTemp(nameInit: "pyobeom", image: #imageLiteral(resourceName: "pyobeom")),
    AnimalTemp(nameInit: "tiger", image: #imageLiteral(resourceName: "tiger"))
]
