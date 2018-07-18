//
//  TableViewController.swift
//  DemoFoody
//
//  Created by Developer on 7/17/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class TableViewController: UITableViewController, UIAlertViewDelegate {
    
    var mealList: [Meal] = []
    var sender: String = ""
    var refMeal: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        refMeal = Database.database().reference().child("meal")
        sender = (Auth.auth().currentUser?.email)!
        loadData()
    }
    
    func loadData() {
        refMeal.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.mealList.removeAll()
                
                for meals in snapshot.children.allObjects as! [DataSnapshot] {
                    let mealObject = meals.value as? [String: AnyObject]
                    let id = mealObject?["mealId"]
                    let mealName = mealObject?["mealName"]
                    let poster = mealObject?["sender"] as! String
                    
                    let meal = Meal(id: (id as? String)!, mealName: (mealName as? String)!, poster: poster)
                    self.mealList.append(meal)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            let meal = alertView.textField(at: 0)!.text!
            
            //add new meal
            let key = refMeal.childByAutoId().key
            let mealFB = ["mealId":key,
                          "mealName": meal,
                          "sender": sender] as [String : Any]
            refMeal.child(key).setValue(mealFB)
            tableView.reloadData()
        }
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertView(title: "Enter new meal", message: nil, delegate: self, cancelButtonTitle: "Cancel")
        alert.addButton(withTitle: "Done")
        alert.alertViewStyle = .plainTextInput
        alert.show()
    }

    // MARK: - Table view data source

    @IBAction func logAccountAction(_ sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn")
                self.present(vc, animated: true, completion: nil)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mealList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = mealList[indexPath.row].mealName
        cell.detailTextLabel?.text = mealList[indexPath.row].poster

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupRef = refMeal.child(mealList[indexPath.row].id)
            groupRef.removeValue()
            mealList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = mealList[indexPath.row]
        
        if sender == meal.poster {
            let alertController = UIAlertController(title: meal.mealName, message: "Give new values to update", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
                let id = meal.id
                
                let name = alertController.textFields?[0].text
                
                self.updateMeal(id: id, name: name!, poster: meal.poster)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alertController.addTextField(configurationHandler: { (textField) in
                textField.text = meal.mealName
            })
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            let alert = Helper()
            alert.showAlert(title: "ERROR", message: "You are not poster", on: self)
        }
    }
    
    func updateMeal(id: String,name: String, poster: String) {
            let meal = ["mealId": id, "mealName":name, "sender": poster]
            refMeal.child(id).setValue(meal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
