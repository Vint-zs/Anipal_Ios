//
//  LetterListViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/11.
//

import UIKit

class LetterListViewController: UICollectionViewController {
    
    @IBOutlet var letterListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Penpal".localized
        initCollectionView()
    }
    
    private func initCollectionView() {
        let nib = UINib(nibName: "LetterListCell", bundle: nil)
        letterListCollectionView.register(nib, forCellWithReuseIdentifier: "LetterListCell")
        letterListCollectionView.dataSource = self
    }

}

extension LetterListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterListCell", for: indexPath) as? LetterListCell else {
            fatalError("Can't dequeue LetterListCell")
        }
        cell.senderName.text = "Nickname"
        cell.arrivalDate.text = "dd/mm/yyyy"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell selected")
    }
}

// extension LetterListViewController: UITableViewDelegate, UITableViewDataSource {
//
//    // cell 높이
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    // cell 수
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return letters.count
//    }
//
//    // cell 내용
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! LetterListTableViewCell
//        cell.userName.text = letters[indexPath.row].fromLetter
//        cell.userImg.image = letters[indexPath.row].imgInit
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        guard let writingVC = self.storyboard?.instantiateViewController(identifier: "letterDetail")as? LetterDetailViewController else {
//            return
//        }
//
//        writingVC.nameFromVar = letters[indexPath.row].fromLetter
//        writingVC.contentVar = letters[indexPath.row].contentInit
//
//        self.navigationController?.pushViewController(writingVC, animated: true)
//    }
//
//}
