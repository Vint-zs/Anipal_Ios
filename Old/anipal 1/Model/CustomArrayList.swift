//
//  VArray.swift
//  anipal 1
//
//  Created by Antoine on 2021/12/10.
//
extension Array {
    
    func get(index: Int) -> Element?{
        if self.count > index {
            return self[index]
        } else{
            return nil
        }
    }
}
