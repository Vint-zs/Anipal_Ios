//
//  LetterListViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/11.
//

import UIKit

class LetterListViewController: UICollectionViewController {
    
    @IBOutlet var letterListCollectionView: UICollectionView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    let newMailImg = UIImage(named: "letterBox1")
    let mailboxImg = UIImage(named: "letterBox2")
    let arvlAmlImg = UIImage(named: "penguin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Penpal".localized
        
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
        let alertcontroller = UIAlertController(title: "Sorting".localized, message: nil, preferredStyle: .actionSheet)
        let newestBtn = UIAlertAction(title: "Newest".localized, style: .default)
        let frequencyBtn = UIAlertAction(title: "Frequency".localized, style: .default)
        let cancelBtn = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alertcontroller.addAction(newestBtn)
        alertcontroller.addAction(frequencyBtn)
        alertcontroller.addAction(cancelBtn)
        present(alertcontroller, animated: true, completion: nil)
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
