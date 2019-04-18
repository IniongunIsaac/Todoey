//
//  Data.swift
//  Todoey
//
//  Created by Isaac Iniongun on 15/04/2019.
//  Copyright © 2019 Isaac Iniongun. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    //@objc dynamic: allows Realm to monitor changes for class properties at runtime
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
