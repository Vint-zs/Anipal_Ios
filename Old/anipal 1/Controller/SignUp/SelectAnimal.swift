//
//  SelectAnimal.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/04/05.
//

import UIKit
import SwiftyJSON

protocol sendBackDelegate {
    func dataReceived(data: Animal)
}

class SelectAnimal: UIViewController {
    
    var select = 0
    var delegate: sendBackDelegate?
    @IBOutlet var collectionView: UICollectionView!
    let animalSelectCellId = "AnimalSelectCell"
    
    var animals: [Animal] = []
    var images: [UIImage] = []
    var animalImgs: [UIImage] = []
    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Do any additional setup after loading the view.
        
        // 셀등록
        let nibCell = UINib(nibName: "AnimalCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: animalSelectCellId)
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/own/animals", token: session.value, completionHandler: { [self] data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        print("data: \(JSON(data))")
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
                            let comingAnimal = [
                                "animal_url": json["coming_animal"]["animal_url"].stringValue,
                                "bar": json["coming_animal"]["bar"].stringValue,
                                "background": json["coming_animal"]["background"].stringValue
                            ]
                            
                            let animal = Animal(animal: json["animal"]["localized"].stringValue, animalURLs: animalURLs, isUsed: json["is_used"].boolValue, delayTime: json["delay_time"].stringValue, comingAnimal: comingAnimal, animalImg: loadAnimals(urls: animalURLs))
                            animals.append(animal)
                            print("animal: \(animal)")
                        }
                        
                        // 화면 reload
                        DispatchQueue.main.async {
                            collectionView.reloadData()
                        }
                    } else if httpStatus.statusCode == 400 {
                        print("error: \(httpStatus.statusCode)")
                    } else {
                        print("error: \(httpStatus.statusCode)")
                    }
                }
            })
        }
    }
    
    func loadAnimals(urls: [String: String]) -> UIImage {
        // 이미지 합성
        images = []
        for (_, url) in urls {
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
}

extension SelectAnimal: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: animalSelectCellId, for: indexPath) as? AnimalCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.img.image = animals[indexPath.row].animalImg
        cell.name.text = animals[indexPath.row].animal
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
        return cell
    }
    
    // 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.dataReceived(data: animals[indexPath.row])
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    // 섹션의 여백
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 25
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    // 셀 행의 최소간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    // 셀의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 190)
    }
    
}
