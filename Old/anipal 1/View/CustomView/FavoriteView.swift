//
//  FavoriteView.swift
//  anipal 1
//
//  Created by 이예주 on 2021/04/03.
//

import  UIKit

protocol FavoriteViewDelegate {
    func eventFavoriteView()
}

@IBDesignable
class FavoriteView: UIView, UICollectionViewDataSource {
    public var delegate: FavoriteViewDelegate?
    
    let favorites = [
        ["text": "🍿Movie".localized, "data": "영화"],
        ["text": "✈️Travel".localized, "data": "여행"],
        ["text": "🎤Sing".localized, "data": "노래"],
        ["text": "💪Fitness".localized, "data": "피트니스"],
        ["text": "🎨Design".localized, "data": "디자인"],
        ["text": "🍳Cook".localized, "data": "요리"],
        ["text": "🕺Dance".localized, "data": "춤"],
        ["text": "📚Book".localized, "data": "독서"],
        ["text": "💅Beauty".localized, "data": "미용"],
        ["text": "🛍Shopping".localized, "data": "쇼핑"],
        ["text": "🎮Game".localized, "data": "게임"],
        ["text": "💻IT".localized, "data": "IT"],
        ["text": "🏛Architecture".localized, "data": "건축"],
        ["text": "💰Economy".localized, "data": "경제"]
    ]
    
    @IBOutlet var favView: UIView!
    @IBOutlet weak var favCell: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    // View 초기화
    private func commonInit() {
        let bundle = Bundle.init(for: self.classForCoder)
        guard let view = bundle.loadNibNamed("FavoriteView", owner: self, options: nil)?.first as? UIView else {
            fatalError("Can't load FavoriteView")
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        initCollectionView()
    }
    
    // Cell 초기화
    private func initCollectionView() {
        let nib = UINib(nibName: "FavoriteCell", bundle: nil)
        favCell.register(nib, forCellWithReuseIdentifier: "FavCell")
        favCell.dataSource = self
    }

}

extension FavoriteView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as? FavoriteCell else {
            fatalError("Can't dequeue FavCell")
        }
        cell.favBtn.setTitle(favorites[indexPath.row]["text"], for: .normal)
        cell.favBtn.layer.cornerRadius = 5
        cell.favBtn.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(favBtnClick), for: .touchUpInside)
        
        return cell
    }
    
    @objc func favBtnClick(sender: UIButton) {
        if sender.layer.backgroundColor == CGColor(red: 1, green: 1, blue: 1, alpha: 1) {
            sender.layer.backgroundColor = CGColor(red: 0.682, green: 0.753, blue: 0.961, alpha: 1)
        } else {
            sender.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
    }
    
}
