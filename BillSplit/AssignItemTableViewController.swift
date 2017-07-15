//
//  AssignItemTableViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/10/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit

class AssignItemTableViewController: UITableViewController {

    var currentPerson: Person? = nil
    var people: [Person] = []
    var items: [Item] = []
    
    @IBOutlet weak var currentPersonLabel: UILabel!
    @IBOutlet weak var addPersonImage: UIImageView!
    @IBOutlet weak var showPeopleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addPersonGesture = UITapGestureRecognizer(target: self, action: #selector(addPersonImageTapped(_:)))
        addPersonImage.addGestureRecognizer(addPersonGesture)
        
        let showPeopleGesture = UITapGestureRecognizer(target: self, action: #selector(showPeopleImageTapped(_:)))
        showPeopleImage.addGestureRecognizer(showPeopleGesture)
    }

    func addPersonImageTapped(_ sender: UITapGestureRecognizer) {
        
        // Create the alert controller.
        let alert = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
        
        // Add text field
        alert.addTextField(configurationHandler: nil)
        
        // Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            // Force unwrapping because we know it exists.
            let textField = alert?.textFields![0]
            
            if !(textField?.text?.isEmpty)! {
                
                let person = Person(name: (textField?.text)!)
                self.people.append(person)
            }
        }))
        
        // Add cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func showPeopleImageTapped(_ sender: UITapGestureRecognizer) {
        
        // let PopUpVC = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        
        /*
        let myAlert = storyboard.instantiateViewControllerWithIdentifier("alert")
        myAlert.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(myAlert, animated: true, completion: nil)
        */
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUp = storyboard.instantiateViewController(withIdentifier: "popUp")
        popUp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        popUp.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(popUp, animated: true, completion: nil)
        
        /*
        let alert = UIAlertController(title: "People", message: nil, preferredStyle: .alert)
        
        for person in people {
            
            let alertAction = UIAlertAction(title: person.name, style: .default, handler: { (UIAlertAction) in
            
                self.currentPersonLabel.text = person.name
                self.currentPerson = person
            })
            
            alertAction.setValue(UIColor.darkText, forKey: "titleTextColor")
            
            alert.addAction(alertAction)
            //alert.addAction(UIAlertAction(title: person.name, style: .default))
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true, completion: nil)
        */
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignCell", for: indexPath) as! ItemTableViewCell

        cell.name[0].text = items[indexPath.row].name
        cell.price[0].setTitle("$\(items[indexPath.row].price)", for: .normal)
        
        let peopleGesture = UITapGestureRecognizer(target: self, action: #selector(peopleImageTapped(_:)))
        cell.people.addGestureRecognizer(peopleGesture)

        return cell
    }
    
    func peopleImageTapped(_ sender: UITapGestureRecognizer) {
        
        print("hello world 3")
    }
    
    // MARK: Action
    
    
    
}
