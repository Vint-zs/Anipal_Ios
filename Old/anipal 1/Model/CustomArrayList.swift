//
//  VArray.swift
//  anipal 1
//
//  Created by Antoine on 2021/12/10.
//
class ArrayList<S> {
    var list: [S] = []
    init() {}
    init(l:[S]) {
        list = l
    }
    
    func getList() -> Array<S>{
        return list
    }
    
    func append(data: S) {
        list.append(data)
    }
    
    func get(index: Int) -> S?{
        if list.count > index {
            return list[index]
        } else{
            return nil
        }
    }
    
    func insert(data: S, index: Int){
        list.insert(data, at: index)
    }
    
}
