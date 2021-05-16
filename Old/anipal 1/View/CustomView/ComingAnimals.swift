//
//  ComingAnimals.swift
//  anipal 1
//
//  Created by 이예주 on 2021/05/17.
//

import UIKit

class ComingAnimals: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let data = ["Cat", "Dog", "Rabbit", "Turtle", "Penguin"]
    
}

extension ComingAnimals: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ComingAnimalCell", for: indexPath) as? ComingAnimalCell else {
            fatalError("Can't dequeue CommingAnimalCell")
        }
        cell.tempLabel.text = data[indexPath.row]
        
        return cell
    }
}
