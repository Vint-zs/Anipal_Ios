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
    
    let mailboxImg = UIImage(named: "mailbox")
    let newMailImg = UIImage(named: "mailbox2")
    let arvlAmlImg = UIImage(named: "penguin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Penpal".localized
        
        dropDown.anchorView = menuBtn
        dropDown.dataSource = ["Newest".localized, "Frequency".localized]
        
        initCollectionView()
        setupFlowLayout()
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
        //flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth - 40, height: 216)
        letterListCollectionView.collectionViewLayout = flowLayout
    }
    
    // 정렬 메뉴
    @IBAction func sortBtn(_ sender: UIBarButtonItem) {
        // 정렬 선택
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("selected item: \(item)")
            print("index: \(index)")
        }
        
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionBackgroundColor = UIColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
        dropDown.show()
    }
}

extension LetterListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item > 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LetterListCell", for: indexPath) as? LetterListCell else {
                fatalError("Can't dequeue LetterListCell")
            }
            cell.arrivalAnimal.image = arvlAmlImg
            cell.mailbox.image = mailboxImg
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
