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
    
    let favorites: [String] = ["🍿Movie".localized, "✈️Travel".localized, "🎤Sing".localized]
    
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
        cell.favBtn.setTitle(favorites[indexPath.item], for: .normal)
        cell.favBtn.layer.cornerRadius = 5
        cell.favBtn.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        return cell
    }
    
}
