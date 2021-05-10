//
//  MyAnimalPage.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/09.
//

import UIKit
import SwiftyJSON

class MyAnimalPage: UIViewController {

    @IBOutlet var animalCollectionView: UICollectionView!
    let cellId = "MyAnimalPageCollectionViewCell"
   // let cellId = "AnimalSelectCell"

    var myAnimalList: [MyAnimal] = []
    var imageUrls: [[String]] = []
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animalCollectionView.delegate = self
        animalCollectionView.dataSource = self
    
        // 셀 등록
        let nibCell = UINib(nibName: "MyAnimalPageCollectionViewCell", bundle: nil)
       // let nibCell = UINib(nibName: "AnimalCollectionViewCell", bundle: nil)
        animalCollectionView.register(nibCell, forCellWithReuseIdentifier: cellId )
        animalCollectionView.reloadData()
        
        refreshData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 네이베이션바 선 없애기
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
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
    
    func refreshData() {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/own/animals", token: session.value) { [self] (data, response, error) in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            let animal: [String: String] = [
                                "animal_url": json["animal_url"].stringValue,
                                "head_url": json["head_url"].stringValue,
                                "top_url": json["top_url"].stringValue,
                                "pants_url": json["pants_url"].stringValue,
                                "shoes_url": json["shoes_url"].stringValue,
                                "gloves_url": json["gloves_url"].stringValue]
                            self.myAnimalList.append(MyAnimal(id:json["_id"].stringValue,time: json["delay_time"].stringValue ,name: json["animal"].stringValue, animal: animal))
                        }
                        
                        // 이미지url 저장배열 생성 및 동물사진url 첫번쨰로 위치
                        if imageUrls.count != myAnimalList.count {
                            // imageUrls = []
                            for i in 0..<myAnimalList.count {
                                let sortedUrl = myAnimalList[i].animal.sorted(by: <)
                                var temp: [String] = []
                                
                                for row in sortedUrl {
                                    temp.append(row.value)
                                }
                                imageUrls.append(temp)
                                temp = []
                            }
                        }
                        // url -> 이미지로 변환 후 합성 및 저장
                        for i in 0..<imageUrls.count {
                            var ingredImage: [UIImage] = []
                            for url in imageUrls[i] {
                                if let imageURL = URL(string: url) {
                                    if let imageData = try? Data(contentsOf: imageURL) {
                                        if let img = UIImage(data: imageData) {
                                            ingredImage.append(img)
                                        }
                                    }
                                }
                            }
                            images.append(compositeImage(images: ingredImage))
                            ingredImage = []
                        }
                        
                        print(myAnimalList)
                        
                        // 뷰 생성
                        DispatchQueue.main.async {
                            animalCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }

}

extension MyAnimalPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = animalCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MyAnimalPageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .white
        cell.animalName.text = myAnimalList[indexPath.row].name.localized
        cell.animalImage.image = images[indexPath.row]
        return cell
    }
    
    // 섹션의 여백
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 25
        return UIEdgeInsets(top: 10, left: inset, bottom: inset, right: inset)
    }
    
    // 셀 행의 최소간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    // 셀의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 230)
    }
    
}
