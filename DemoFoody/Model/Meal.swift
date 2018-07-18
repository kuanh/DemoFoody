//
//  Meal.swift
//  DemoFoody
//
//  Created by Developer on 7/18/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

class Meal {
    var id: String
    var mealName: String
    var poster: String
    
    init(id: String, mealName: String, poster: String) {
        self.id = id
        self.mealName = mealName
        self.poster = poster
    }
}
