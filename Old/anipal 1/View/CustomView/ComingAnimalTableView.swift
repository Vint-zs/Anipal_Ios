//
//  ComingAnimalTableView.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/17.
//

import UIKit
import SwiftyJSON

class ComingAnimalTableView: UIView, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var comingAnimals: [ComingAnimal] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.comminInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.comminInit()
        loadComingAnimals()
    }
    
    // View 초기화
    private func comminInit() {
        let bundle = Bundle.init(for: self.classForCoder)
        guard let view = bundle.loadNibNamed("ComingAnimalTableView", owner: self, options: nil)?.first as? UIView else {
            fatalError("Can't load ComingAnimalTableView")
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        initTableView()
    }
    
    // Cell 초기화
    private func initTableView() {
        let nib = UINib(nibName: "ComingAnimalCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ComingAnimalCell")
        tableView.dataSource = self
    }
    
    // 서버 데이터
    func loadComingAnimals() {
        if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
            get(url: "/letters/coming", token: session.value, completionHandler: { [self] data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse {
                    if httpStatus.statusCode == 200 {
                        comingAnimals = []
                        for idx in 0..<JSON(data).count {
                            let json = JSON(data)[idx]["coming_animal"]
                            let animalURL = json["animal_url"].stringValue
                            let bar = json["bar"].stringValue
                            let background = json["background"].stringValue
                            
                            let comingAnimal = ComingAnimal(animalURL: animalURL, bar: bar, background: background)
                            comingAnimals.append(comingAnimal)
                        }
                        print("comingAnimal: \(comingAnimals)")
                        
                        // 화면 reload
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("error: \(httpStatus.statusCode)")
                    }
                }
            })
        }
    }
}

extension ComingAnimalTableView {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comingAnimals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ComingAnimalCell", for: indexPath) as? ComingAnimalCell else {
            fatalError("Can't dequeue CommingAnimalCell")
        }
        let cellURL = URL(string: comingAnimals[indexPath.row].animalURL)
        let data = try? Data(contentsOf: cellURL!)
        cell.animalImg.image = UIImage(data: data!)
        cell.animalImg.contentMode = .scaleAspectFill
        
        return cell
    }
}
