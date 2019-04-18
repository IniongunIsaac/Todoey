//
//  ItemData.swift
//  Todoey
//
//  Created by Isaac Iniongun on 15/04/2019.
//  Copyright © 2019 Isaac Iniongun. All rights reserved.
//

import Foundation
import RealmSwift


class ItemData: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : NSDate = NSDate()
    @objc dynamic var dateUpdated : NSDate = NSDate()
    //Define a belongs-To Relationship to the CategoryData class using the property "items".
    //Property "items" refers to the name of the "hasMany" relationship in the CategoryData class.
    var parentCategory = LinkingObjects(fromType: CategoryData.self, property: "items")
}
