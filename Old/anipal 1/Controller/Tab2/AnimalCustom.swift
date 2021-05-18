//
//  AnimalCustom.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/11.
//

import UIKit
import SwiftyJSON

protocol reloadData {
    func reloadData()
}

class AnimalCustom: UIViewController {
    var delegate: reloadData?
    var serverHead: [Accessory] = []
    var serverData: [[Accessory]] = []
    var myCharacterUrls: [String]! = []
    var myCharacterImage: UIImage?
    var accessoryDetail: AccessoryDetail?
    var animalId: String?
    
    var data: [[UIImage]] = []
    let cellId = "accessory"
    
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var segment: UISegmentedControl!
    
   // @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var animalImage: UIImageView!
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var acceCollectionView: UICollectionView!
    var p: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        acceCollectionView.delegate = self
        acceCollectionView.dataSource = self
        makeImage()
        
        // 셀 등록
        let nibCell = UINib(nibName: "AccessoryCollectionViewCell", bundle: nil)
       // let nibCell = UINib(nibName: "AnimalCollectionViewCell", bundle: nil)
        acceCollectionView.register(nibCell, forCellWithReuseIdentifier: cellId )
        acceCollectionView.reloadData()
        p=0
        
    }
    @IBAction func clickDetailBtn(_ sender: UIButton) {
        guard let detailVC = self.storyboard?.instantiateViewController(identifier: "AnimalDetail") as? AnimalDetail else {return}
        self.present(detailVC, animated: true, completion: nil)
        
    }
    
    // 저장버튼 클릭시
    @IBAction func clickSaveBtn(_ sender: UIButton) {
        delegate?.reloadData() // put 함수안에 맨 마지막순서에
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            let body: NSMutableDictionary = NSMutableDictionary()
            body.setValue(myCharacterUrls[1], forKey: "head_url")
            body.setValue(myCharacterUrls[2], forKey: "top_url")
            body.setValue(myCharacterUrls[3], forKey: "pants_url")
            body.setValue(myCharacterUrls[4], forKey: "shoes_url")
            body.setValue(myCharacterUrls[5], forKey: "gloves_url")
            
            guard let id = animalId else {return}
            try? put2(url: "/own/animals/\(id)", token: session.value, body: body, completionHandler: { [self] data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }

                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                print(String(data: data, encoding: .utf8)!)
        
            })
        }

    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        p = sender.selectedSegmentIndex
        acceCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func layout() {
        animalImage.layer.cornerRadius = 5
        detailButton.layer.cornerRadius = 5
        saveBtn.layer.cornerRadius = 5
    }
    
    // 이미지 생성
    func makeImage() {
        // url -> 이미지로 변환 후 합성 및 저장
        for i in 0..<myCharacterUrls.count {
            var ingredImage: [UIImage] = []
            for url in myCharacterUrls {
                if let imageURL = URL(string: url) {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        if let img = UIImage(data: imageData) {
                            ingredImage.append(img)
                        }
                    }
                }
            }
            myCharacterImage = compositeImage(images: ingredImage)
            ingredImage = []
            animalImage.image = myCharacterImage
        }
    }
    
    // 이미지 합성
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
}

extension AnimalCustom: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serverData[p].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AccessoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.accessoryImage.image = serverData[p][indexPath.row].img
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 액세서리 보유시
        if serverData[p][indexPath.row].isOwn == true {
            myCharacterUrls[p+1] = serverData[p][indexPath.row].imgUrl
            makeImage()
        }
        // 액세서리 미보유시
        else {
            var detail: AccessoryDetail?
            if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
                get(url: "/accessories/\(serverData[p][indexPath.row].accessoryId)", token: session.value) { [self] (data, response, error) in
                    guard let data = data, error == nil else {
                        print("error=\(String(describing: error))")
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse {
                        if httpStatus.statusCode == 200 {
                            let json = JSON(data)
                            print(json)
                            detail = AccessoryDetail(name: json["name"].stringValue, price: json["price"].intValue, imgUrl: json["img_url"].stringValue, img: serverData[p][indexPath.row].img, missionTitle: json["mission"]["title"].stringValue, missionContent: json["mission"]["content"].stringValue, category: json["category"].stringValue)
                        }
                        // 뷰 생성
                        DispatchQueue.main.async {
                            guard let missionVC = self.storyboard?.instantiateViewController(identifier: "mission") as? MissionView else {return}
                            missionVC.accessoryInfo = detail
                            missionVC.modalPresentationStyle = .overCurrentContext
                            self.present(missionVC, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    // 섹션의 여백
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 15
        return UIEdgeInsets(top: 10, left: inset, bottom: inset, right: inset)
    }
    
    // 셀 행의 최소간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 셀의 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 130)
    }
}
