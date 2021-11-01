//
//  SettingTab.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/08.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import SwiftyJSON

class SettingTab: UIViewController, sendBackDelegate {

    let settings: [String] = ["Language".localized, "Favorite".localized, "Block List".localized]
    
    @IBOutlet weak var favAnimalBtn: UIButton!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var blockBtn: UIButton!
    
    var selectedAnimal: Int = 0
    var animals: [AnimalPost] = []  // 서버 POST용
    var serverAnimals: [Animal] = [] // next page 데이터 전송용
    var images: [UIImage] = []
    var blockUsers: [String] = []
    var blockUserInfo: [User] = []
    var languageList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    @IBAction func clickLanguage(_ sender: UIButton) {
        guard let langSetVC = self.storyboard?.instantiateViewController(identifier: "LanguageSettingVC") as? LanguageSettingVC else { return }
            langSetVC.modalTransitionStyle = .coverVertical
            langSetVC.modalPresentationStyle = .fullScreen
            self.present(langSetVC, animated: true, completion: nil)
    }
    
    @IBAction func clickFav(_ sender: UIButton) {
        guard let favSetVC = self.storyboard?.instantiateViewController(identifier: "FavoriteSettingVC") as? FavoriteSettingVC else { return }
            favSetVC.modalTransitionStyle = .coverVertical
            favSetVC.modalPresentationStyle = .fullScreen
            self.present(favSetVC, animated: true, completion: nil)
    }
    
    @IBAction func clickBlocked(_ sender: UIButton) {
        guard let blockSetVC = self.storyboard?.instantiateViewController(identifier: "BlockSettingVC") as? BlockSettingVC else { return }
            blockSetVC.modalTransitionStyle = .coverVertical
            blockSetVC.modalPresentationStyle = .fullScreen
            blockSetVC.blockedUsers = self.blockUserInfo
            self.present(blockSetVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAnimal()
        loadBlockUsers()
        favAnimalBtn.setImage(ad?.thumbnail, for: .normal)
    }
    
    func setUI() {
        // 동물 선택 버튼
        favAnimalBtn.backgroundColor = .white
        favAnimalBtn.layer.borderColor = UIColor.lightGray.cgColor
        favAnimalBtn.imageView?.contentMode = .scaleAspectFit
        favAnimalBtn.layer.masksToBounds = true
        favAnimalBtn.imageView?.clipsToBounds = true
        favAnimalBtn.layer.cornerRadius = favAnimalBtn.frame.size.width/2
        
        // 유저 이름
        nameLabel.text = ad?.name
        
        // 버튼 제목
        languageBtn.setTitle("Language".localized, for: .normal)
        favBtn.setTitle("Favorite".localized, for: .normal)
        blockBtn.setTitle("BlockList".localized, for: .normal)
        
        // 로그아웃 버튼
        logoutBtn.layer.cornerRadius = 10
        logoutBtn.setTitle("Logout".localized, for: .normal)
        logoutBtn.layer.shadowColor = UIColor.lightGray.cgColor
        logoutBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        logoutBtn.layer.shadowOpacity = 1.0
        logoutBtn.layer.shadowRadius = 3
        logoutBtn.layer.masksToBounds = false
        
    }
    
    func dataReceived(data: Int) {
        selectedAnimal = data
        ad?.thumbnail = singletonAnimal.animal![data].combinedImage!
        favAnimalBtn.setImage(ad?.thumbnail, for: .normal)
        
        // 변경된 대표 동물 이미지 서버 전송
            let body: NSMutableDictionary = NSMutableDictionary()
            body.setValue(animals[data].animalURLs, forKey: "favorite_animal")

            let putURL = "/users/" + (ad?.id)!

            put(url: putURL, token: cookie, body: body, completionHandler: { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        var json = JSON(data)
                        if json["mission"].dictionary != nil {
                            json = json["mission"]   
                            var detail: AccessoryDetail?
                            if let url = URL(string: json["img_url"].stringValue) {
                                if let imgData = try? Data(contentsOf: url) {
                                    if let image = UIImage(data: imgData) {
                                        detail = AccessoryDetail(name: json["name"].stringValue, price: json["price"].intValue, imgUrl: json["img_url"].stringValue, img: image, missionContent: json["mission"].stringValue, category: json["category"].stringValue)
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async {
                                let storyboard = UIStoryboard(name: "Tab2", bundle: nil)
                                guard let missionVC = storyboard.instantiateViewController(identifier: "mission") as? MissionView else {return}
                                missionVC.accessoryInfo = detail
                                missionVC.okBtnTitle = "Get"
                                missionVC.modalPresentationStyle = .overCurrentContext
                                self.present(missionVC, animated: true, completion: nil)
                            }
                            
                        }
            
                    } else {
                        print("error: \(httpStatus.statusCode)")
                    }
                }
            })
        
    }
    
    // 대표 동물 변경
    @IBAction func editAnimal(_ sender: UIButton) {
        let sub = UIStoryboard(name: "SignUp", bundle: nil)
        guard let nextVC = sub.instantiateViewController(identifier: "selectAnimalVC") as? SelectAnimal else {
            return
        }
        
        nextVC.delegate = self
        nextVC.serverAnimals = self.serverAnimals
        nextVC.serverAnimals2 = singletonAnimal.animal ?? []
        nextVC.isThumbnail = true
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func clickLogoutBtn(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        LoginManager.init().logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        ad?.favorites = []
        ad?.languages = []
        ad?.favAnimal = ""
    }
    
    func loadAnimal() {
        animals = []  // 서버 POST용
        serverAnimals = [] // next page 데이터 전송용
        images = []
        
            get(url: "/own/animals", token: cookie, completionHandler: { [self] data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            let animalURLs: [String: String] = [
                                "animal_url": json["animal_url"].stringValue,
                                "head_url": json["head_url"].stringValue,
                                "top_url": json["top_url"].stringValue,
                                "pants_url": json["pants_url"].stringValue,
                                "shoes_url": json["shoes_url"].stringValue,
                                "gloves_url": json["gloves_url"].stringValue
                            ]
                            let animalImg = loadAnimals(urls: animalURLs)
                            let comingAnimal = [
                                "animal_url": json["coming_animal"]["animal_url"].stringValue,
                                "bar": json["coming_animal"]["bar"].stringValue,
                                "background": json["coming_animal"]["background"].stringValue
                            ]
                            let animal = AnimalPost(animal: json["animal"]["localized"].stringValue, animalURLs: animalURLs, isUsed: json["is_used"].boolValue, delayTime: json["delay_time"].stringValue, comingAnimal: comingAnimal, animalImg: animalImg, ownAnimalId: json["_id"].stringValue)
                            animals.append(animal)
                            serverAnimals.append(Animal(nameInit: json["animal"]["localized"].stringValue, image: animalImg))
                        }
                    } else if httpStatus.statusCode == 400 {
                        print("error: \(httpStatus.statusCode)")
                    } else {
                        print("error: \(httpStatus.statusCode)")
                    }
                }
            })
        
    }
    
    // MARK: - 이미지 합성
    func loadAnimals(urls: [String: String]) -> UIImage {
        let order = urls.sorted(by: <)
        images = []
        for (_, url) in order {
            setImage(from: url)
        }
        return compositeImage(images: images)
    }
    
    func compositeImage(images: [UIImage]) -> UIImage {
        var compositeImage: UIImage!
        if images.count > 0 {
            let size: CGSize = CGSize(width: images[0].size.width, height: images[0].size.height)
            UIGraphicsBeginImageContext(size)
            for image in images {
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                image.draw(in: rect)
            }
            compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return compositeImage
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        let image = UIImage(data: imageData)
        self.images.append(image!)
    }
    
    func loadBlockUsers() {
        blockUsers = ad?.blockUsers ?? []
        blockUserInfo = []
        var blockURL: String
        for id in 0..<blockUsers.count {
            
                blockURL = "/users/" + blockUsers[id]
                get(url: blockURL, token: cookie, completionHandler: { [self] data, response, error in
                    guard let data = data, error == nil else {
                        print("error=\(String(describing: error))")
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse {
                        if httpStatus.statusCode == 200 {
                            let json = JSON(data)
                            languageList = []
                            let favorites = json["favorites"].arrayValue.map { $0.stringValue }
                            let languages = json["languages"].arrayObject as? [[String: Any]]
                            for row in languages ?? [] {
                                if let name = row["name"] as? String {
                                    languageList.append(name)
                                }
                            }
                            let animalURLs: [String: String] = [
                                "animal_url": json["favorite_animal"]["animal_url"].stringValue,
                                "head_url": json["favorite_animal"]["head_url"].stringValue,
                                "top_url": json["favorite_animal"]["top_url"].stringValue,
                                "pants_url": json["favorite_animal"]["pants_url"].stringValue,
                                "shoes_url": json["favorite_animal"]["shoes_url"].stringValue,
                                "gloves_url": json["favorite_animal"]["gloves_url"].stringValue
                            ]
                            let animalImg = loadAnimals(urls: animalURLs)
                            let userInfo = User(name: json["name"].stringValue, gender: json["gender"].stringValue, age: json["age"].uIntValue, birthday: json["birthday"].stringValue, email: json["email"].stringValue, favorites: favorites, languages: languageList, thumbnail: animalImg)
                            blockUserInfo.append(userInfo)
                        } else if httpStatus.statusCode == 400 {
                            print("error: \(httpStatus.statusCode)")
                        } else {
                            print("error: \(httpStatus.statusCode)")
                        }
                    }
                })
            
        }
    }
}
