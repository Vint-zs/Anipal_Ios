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
class FavoriteView: UIView {
    
    public var delegate: FavoriteViewDelegate?
    
    @IBOutlet weak var favoriteTitle: UILabel!
    @IBOutlet weak var movieFav: UILabel!
    @IBOutlet weak var tripFav: UILabel!
    @IBOutlet weak var singFav: UILabel!
    
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
        let view = bundle.loadNibNamed("FavoriteView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        favoriteTitle.text = "Choose you favorites.".localized
        
        movieFav.text = "🍿Movie".localized
        movieFav.layer.cornerRadius = 5
        
        tripFav.text = "✈️Travel".localized
        tripFav.layer.cornerRadius = 5
        
        singFav.text = "🎤Sing".localized
        singFav.layer.cornerRadius = 5
    }

}
