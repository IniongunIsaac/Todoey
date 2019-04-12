//
//  Item.swift
//  Todoey
//
//  Created by Isaac Iniongun on 12/04/2019.
//  Copyright © 2019 Isaac Iniongun. All rights reserved.
//

import Foundation


class Item{
    var title: String = ""
    var done: Bool = false
    
    init() {}
    
    convenience init(title: String){
        self.init()
        self.title = title
    }
}
