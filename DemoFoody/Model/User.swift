//
//  User.swift
//  DemoFoody
//
//  Created by Developer on 7/17/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

class User {
    var userName: String
    
    init?(user: String) {
        guard user.isEmpty else { return nil }
        if user.isEmpty {
            return nil
        }
        self.userName = user
    }
}
