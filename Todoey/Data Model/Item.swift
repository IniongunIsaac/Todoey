//
//  Item.swift
//  Todoey
//
//  Created by Isaac Iniongun on 12/04/2019.
//  Copyright © 2019 Isaac Iniongun. All rights reserved.
//

import Foundation

//Data class Item extends Codable. For a class to be Codable i.e Encodable and Decodable, all its properties must have standard data types.
//An class that extends Codable i.e Encodable and Decodable protocols cannot have properties with custom data types.
class Item: Codable {
    var title: String = ""
    var done: Bool = false
    
    init() {}
    
    convenience init(title: String){
        self.init()
        self.title = title
    }
}
