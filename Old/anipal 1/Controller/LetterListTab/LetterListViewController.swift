//
//  LetterListViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/11.
//

import UIKit
import SwiftyJSON

class LetterListViewController: UICollectionViewController {
    
    @IBOutlet var letterListCollectionView: UICollectionView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    var mailboxes: [MailBox] = []
    let dateFormatter = DateFormatter()
    
    // TODO: 임시 데이터
    var unOpenedMail = UIImage(named: "letterBox1.png")
    var openedMail = UIImage(named: "letterBox2.png")
    var arvlAmlImg = UIImage(named: "penguin.png")
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImRtZGtkbWRrZGtka0BnbWFpbC5jb20iLCJpYXQiOjE2MTg1MDUyMTUsImV4cCI6MTYxODU5MTYxNX0.fcq42aKMpEs8NbUbqcCQOVSFjHa_q86w0eDe5vTxXCs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Penpal".localized
        
        // TODO: Date
        // dateFormatter.dateFormat = "YYYY-MM-dd"
        
        initCollectionView()
        setupFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData(url: "https://anipal.tk/mailboxes/my", token: token)
    }
    
    // 콜렉션 뷰 셀 등록
    private func initCollectionView() {
        let listNib = UINib(nibName: "LetterListCell", bundle: nil)
        let writeNib = UINib(nibName: "WriteNewLetter", bundle: nil)
        letterListCollectionView.register(listNib, forCellWithReuseIdentifier: "LetterListCell")
        letterListCollectionView.register(writeNib, forCellWithReuseIdentifier: "WriteNewLetter")
        letterListCollectionView.dataSource = self
    }
    
    // 셀 크기 조정
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth - 40, height: 216)
        letterListCollectionView.collectionViewLayout = flowLayout
    }
    
    // 정렬 메뉴
    @IBAction func sortBtn(_ sender: UIBarButtonItem) {
        let alertcontroller = UIAlertController(title: "Sorting".localized, message: nil, preferredStyle: .actionSheet)
        let newestBtn = UIAlertAction(title: "Newest".localized, style: .default)
        let frequencyBtn = UIAlertAction(title: "Frequency".localized, style: .default)
        let cancelBtn = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alertcontroller.addAction(newestBtn)
        alertcontroller.addAction(frequencyBtn)
        alertcontroller.addAction(cancelBtn)
        present(alertcontroller, animated: true, completion: nil)
    }
    
    func getData(url: String, token: String) {
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { [self] data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode == 200 {
                    print(httpStatus.statusCode)
                    
                    if mailboxes.count != JSON(data).count {
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]
                            let partner: [String: Any] = [
                                "user_id": json["partner"]["user_id"].stringValue,
                                "name": json["partner"]["name"].stringValue,
                                "country": json["partner"]["country"].stringValue,
                                "favorites": json["partner"]["favorites"].arrayValue]
                            let thumbnail = [
                                "animal_url": json["thumbnail_animal"]["animal_url"].stringValue,
                                "head_url": json["thumbnail_animal"]["head_url"].stringValue,
                                "top_url": json["thumbnail_animal"]["top_url"].stringValue,
                                "pants_url": json["thumbnail_animal"]["pants_url"].stringValue,
                                "shoes_url": json["thumbnail_animal"]["shoes_url"].stringValue,
                                "gloves_url": json["thumbnail_animal"]["gloves_url"].stringValue]
                            let mailBox = MailBox(mailBoxID: json["_id"].stringValue, isOpened: json["is_opened"].boolValue, partner: partner, thumbnail: thumbnail, arrivalDate: json["arrive_date"].stringValue, letterCount: json["letters_count"].intValue)
                            mailboxes.append(mailBox)
                        }
                    }
                    
                    // 화면 reload
                    DispatchQueue.main.async {
                        self.letterListCollectionView.reloadData()
                    }
                } else if httpStatus.statusCode == 400 {
                    print("error: \(httpStatus.statusCode)")
                } else {
                    print("error: \(httpStatus.statusCode)")
                }
            }
        }
        task.resume()
    }
}

extension LetterListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mailboxes.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item > 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterListCell", for: indexPath) as? LetterListCell else {
                fatalError("Can't dequeue LetterListCell")
            }
            cell.arrivalAnimal.image = arvlAmlImg
            
            if mailboxes[indexPath.row - 1].isOpened {
                cell.mailbox.image = openedMail
            } else {
                cell.mailbox.image = unOpenedMail
            }
            cell.senderName.text = mailboxes[indexPath.row - 1].partner["name"] as? String
            cell.senderName.sizeToFit()
            cell.arrivalDate.text = mailboxes[indexPath.row - 1].arrivalDate
            cell.arrivalDate.sizeToFit()
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WriteNewLetter", for: indexPath) as? WriteNewLetter else { fatalError("Can't dequeue WriteNewLetter")}
            cell.writeLabel.text = "write"
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            guard let writingVC = self.storyboard?.instantiateViewController(identifier: "WritingPage") as? WritingPage else { return }
            
            writingVC.modalTransitionStyle = .coverVertical
            writingVC.modalPresentationStyle = .pageSheet
            
            self.present(writingVC, animated: true, completion: nil)
        } else {
            guard let letterDetailVC = self.storyboard?.instantiateViewController(identifier: "letterDetail") as? LetterDetailViewController else {
                return
            }

            letterDetailVC.nameFromVar = mailboxes[indexPath.row - 1].partner["name"] as? String
            letterDetailVC.mailBoxID = mailboxes[indexPath.row - 1].mailBoxID

            self.navigationController?.pushViewController(letterDetailVC, animated: true)
        }
    }
}
