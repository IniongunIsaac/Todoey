//
//  CategoryData.swift
//  Todoey
//
//  Created by Isaac Iniongun on 15/04/2019.
//  Copyright © 2019 Isaac Iniongun. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryData: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    //Define a has-Many Relationship to the ItemData class
    let items = List<ItemData>()
}
