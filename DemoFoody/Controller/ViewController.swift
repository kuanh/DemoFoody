//
//  ViewController.swift
//  DemoFoody
//
//  Created by Developer on 7/17/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    var refMeal: DatabaseReference!
    var byUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refMeal = Database.database().reference().child("meal")
        byUser = (Auth.auth().currentUser?.email)!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButton(_ sender: UIButton) {
        let key = refMeal.childByAutoId().key
        let mealFB = ["mealName": name.text! as String,
                      "sender": byUser]
        refMeal.child(key).setValue(mealFB)
    }
    
}

