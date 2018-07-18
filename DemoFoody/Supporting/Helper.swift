//
//  Helper.swift
//  DemoFoody
//
//  Created by Developer on 7/18/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit


class Helper {
    func showAlert(title: String, message: String, on controller: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        controller.present(alert, animated: true, completion: nil)
    }
}
