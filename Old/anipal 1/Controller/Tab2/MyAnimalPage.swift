//
//  MyAnimalPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/09.
//

import UIKit
import SwiftyJSON

class MyAnimalPage: UIViewController, reloadData {
    func reloadData() {
        refreshData()
    }

    @IBOutlet var animalCollectionView: UICollectionView!
    let cellId = "MyAnimalPageCollectionViewCell"

    var myAnimalList: [MyAnimal] = []
    var imageUrls: [[String]] = []
    var images: [UIImage] = []
    var order: [String: Int] = ["head": 1, "top": 2, "pants": 3, "shoes": 4, "gloves": 5 ]
    var needReload: Bool = false
    
    var serverHead: [Accessory] = []
    var serverData: [Int: [Accessory]] = [:]
    var num = 0
    var baseAnimalImage: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Animal".localized
        animalCollectionView.delegate = self
        animalCollectionView.dataSource = self
        // 셀 등록
        let nibCell = UINib(nibName: "MyAnimalPageCollectionViewCell", bundle: nil)
        animalCollectionView.register(nibCell, forCellWithReuseIdentifier: cellId )
        animalCollectionView.reloadData()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAccessories()
        animalCollectionView.reloadData()
        myAnimalList = singletonAnimal.animal ?? []
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        animalCollectionView.reloadData()
    }

    // MARK: - 이미지 합성
    func compositeImage(images: [UIImage]) -> UIImage {
        var compositeImage: UIImage?
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
        return compositeImage ?? #imageLiteral(resourceName: "emptyCheckBox")
    }
    
    // 초기화
    func reset() {
        myAnimalList = []
        imageUrls = []
        images = []
    }
    
    func refreshData() {
        self.animalCollectionView.reloadData()
    }
    
    // 모든 악세서리 로드
    func loadAccessories() {
        loadAccessory(category: "head")
        loadAccessory(category: "top")
        loadAccessory(category: "pants")
        loadAccessory(category: "shoes")
        loadAccessory(category: "gloves")
    }
    
    // 악세서리 로드 함수
    func loadAccessory(category: String) {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/accessories/all/\(category)", token: session.value) { [self] (data, response, error) in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        var temp: [Accessory] = []
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            if let imageURL = URL(string: json["img_url"].stringValue) {
                                if let imageData = try? Data(contentsOf: imageURL) {
                                    if let img = UIImage(data: imageData) {
                                        temp.append(Accessory(accessoryId: json["accessory_id"].stringValue, imgUrl: json["img_url"].stringValue, isOwn: json["is_own"].boolValue, img: img))
                                    }
                                }
                            }
                        }
                        // 부위별 순서 기록
                        guard let num = order[category] else {return}
                        serverData[num] = temp
                        temp = []
                    }
                }
            }
        }
    }
}
extension MyAnimalPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myAnimalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = animalCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyAnimalPageCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
        cell.animalName.text = singletonAnimal.animal?[indexPath.row].name.localized
        cell.delayTime.text = singletonAnimal.animal?[indexPath.row].time
        cell.animalImage.image = singletonAnimal.animal?[indexPath.row].image
        
        return cell
    }
    
    // 셀 클릭시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let customVC = self.storyboard?.instantiateViewController(identifier: "customVC") as? AnimalCustom else {return}
        customVC.animalIndex = indexPath.row
        customVC.serverData = [singletonAccessory.accessory["head"]!, singletonAccessory.accessory["top"]!, singletonAccessory.accessory["pants"]!, singletonAccessory.accessory["shoes"]!, singletonAccessory.accessory["gloves"]!]
        customVC.myCharacterUrls = [singletonAnimal.animal![indexPath.row].animalUrl["animal_url"]!, singletonAnimal.animal![indexPath.row].animalUrl["head_url"]!, singletonAnimal.animal![indexPath.row].animalUrl["top_url"]!, singletonAnimal.animal![indexPath.row].animalUrl["pants_url"]!, singletonAnimal.animal![indexPath.row].animalUrl["shoes_url"]!, singletonAnimal.animal![indexPath.row].animalUrl["gloves_url"]!]
        customVC.animalId = singletonAnimal.animal?[indexPath.row].id
        customVC.delegate = self
        customVC.baseImage = singletonAnimal.animal![indexPath.row].image
        customVC.delayTime = singletonAnimal.animal?[indexPath.row].time ?? ""
        customVC.animalName = singletonAnimal.animal?[indexPath.row].name ?? ""
        self.navigationController?.pushViewController(customVC, animated: true)
    }
    
    // 섹션의 여백
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 25
        return UIEdgeInsets(top: 10, left: inset * xConstant, bottom: inset * yConstant, right: inset * xConstant)
    }
    
    // 셀 행의 최소간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    // 셀의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSpacing: CGFloat = 25
        let inset: CGFloat = 25
        let width = (collectionView.bounds.width - itemSpacing - inset * xConstant * 2) / 2
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
    
}
