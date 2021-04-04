//
//  userInfo.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/04.
//

import Foundation

struct User {
    let userName: String
    let userGender: String
    let userAge: UInt
    let userBirthday: String
    let userEmail: String
    let userProvider: String
    let userConcept: String
    let userFavorites: [String]
    let userLanguages: [String]
    
    init(name: String, gender: String, age: UInt, birthday: String, email: String, provider: String, concept: String, favorites: [String], languages: [String]) {
        userName = name
        userGender = gender
        userAge = age
        userBirthday = birthday
        userEmail = email
        userProvider = provider
        userConcept = concept
        userFavorites = favorites
        userLanguages = languages
    }
}

// Dummy data
let users: [User] = [
    User(name: "bird", gender: "female", age: 18, birthday: "2021-04-04", email: "abc123@gmail.com", provider: "google", concept: "언어", favorites: ["여행"], languages: ["한국어", "영어"]),
    User(name: "monkey", gender: "male", age: 43, birthday: "2020-03-23", email: "asdfqwer@gmail.com", provider: "facebook", concept: "우정", favorites: ["영화", "요리"], languages: ["한국어"])
]
