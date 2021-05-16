//
//  AnimalCustom.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/05/11.
//

import UIKit
import SwiftyJSON

class AnimalCustom: UIViewController {

    var testHead: [UIImage] = [#imageLiteral(resourceName: "head1"),  #imageLiteral(resourceName: "head2"), #imageLiteral(resourceName: "head4"), #imageLiteral(resourceName: "head3")]
    var testTop: [UIImage] = [#imageLiteral(resourceName: "top3"), #imageLiteral(resourceName: "top1"), #imageLiteral(resourceName: "top2")]
    var testBottom: [UIImage] = [#imageLiteral(resourceName: "bottoms4"), #imageLiteral(resourceName: "bottoms2"), #imageLiteral(resourceName: "bottoms1"),#imageLiteral(resourceName: "bottoms3")]
    var testLeft: [UIImage] = []
    var testShoes: [UIImage] = []
    
    var serverHead: [Accessory] = []
    var serverData: [[Accessory]] = []
    
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
        // loadAccessory()
        acceCollectionView.delegate = self
        acceCollectionView.dataSource = self
        
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
    
    @IBAction func clickSaveBtn(_ sender: UIButton) {
        guard let missionVC = self.storyboard?.instantiateViewController(identifier: "mission") as? MissionView else {return}
        missionVC.modalPresentationStyle = .overCurrentContext
        self.present(missionVC, animated: true, completion: nil)
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
    
//    func loadAccessory() {
//        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
//            get(url: "/accessories/all/head", token: session.value) { [self] (data, response, error) in
//                guard let data = data, error == nil else {
//                    print("error=\(String(describing: error))")
//                    return
//                }
//                if let httpStatus = response as? HTTPURLResponse {
//                    if httpStatus.statusCode == 200 {
//                        for idx in 0..<JSON(data).count {
//                            let json = JSON(data)[idx]
//                            if let imageURL = URL(string: json["img_url"].stringValue) {
//                                if let imageData = try? Data(contentsOf: imageURL) {
//                                    if let img = UIImage(data: imageData) {
//                                        self.serverHead.append(Accessory(accessoryId: json["accessory_id"].stringValue, imgUrl: json["img_url"].stringValue, isOwn: json["is_own"].boolValue, img: img))
//                                    }
//                                }
//                            }
//                        }
//                        serverData.append(serverHead)
//                        // 뷰 생성
//                        DispatchQueue.main.async {
//                            acceCollectionView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func getData() {
        data = [testHead, testTop, testBottom, testLeft, testShoes]
        acceCollectionView.reloadData()
    }
    
    func getAccessory() {
        
    }
    
}

extension AnimalCustom: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return data[p].count
        return serverData[p].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? AccessoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        cell.accessoryImage.image = data[p][indexPath.row]
        cell.accessoryImage.image = serverData[p][indexPath.row].img

        cell.layer.cornerRadius = 10
        return cell
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
