//
//  LetterListViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/11.
//

import UIKit
import DropDown

class LetterListViewController: UICollectionViewController {
    
    @IBOutlet var letterListCollectionView: UICollectionView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Penpal".localized
        dropDown.anchorView = menuBtn
        dropDown.dataSource = ["Newest".localized, "Frequency".localized]
        
        initCollectionView()
    }
    
    private func initCollectionView() {
        let listNib = UINib(nibName: "LetterListCell", bundle: nil)
        let writeNib = UINib(nibName: "WriteNewLetter", bundle: nil)
        letterListCollectionView.register(listNib, forCellWithReuseIdentifier: "LetterListCell")
        letterListCollectionView.register(writeNib, forCellWithReuseIdentifier: "WriteNewLetter")
        letterListCollectionView.dataSource = self
    }
    
    // 정렬 메뉴
    @IBAction func sortBtn(_ sender: UIBarButtonItem) {
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionBackgroundColor = UIColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
        dropDown.show()
    }
}

extension LetterListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item > 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterListCell", for: indexPath) as? LetterListCell else {
                fatalError("Can't dequeue LetterListCell")
            }
            cell.senderName.text = users[indexPath.row].name
            cell.senderName.sizeToFit()
            cell.arrivalDate.text = users[indexPath.row].birthday
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

            letterDetailVC.nameFromVar = letters[indexPath.row - 1].fromLetter
            letterDetailVC.contentVar = letters[indexPath.row - 1].contentInit

            self.navigationController?.pushViewController(letterDetailVC, animated: true)
        }
    }
}
