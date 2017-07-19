//
//  AssignItemTableViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/10/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit

class AssignItemTableViewController: UITableViewController {

    var selectedIndexPathRow: Int?
    var currentPerson: Person? = nil
    var people: [Person?] = []
    var items: [Item] = []
    
    @IBOutlet weak var currentPersonLabel: UILabel!
    @IBOutlet weak var addPersonImage: UIImageView!
    @IBOutlet weak var showPeopleImage: UIImageView!
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var tipTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addPersonGesture = UITapGestureRecognizer(target: self, action: #selector(addPersonImageTapped(_:)))
        addPersonImage.addGestureRecognizer(addPersonGesture)
        
        let showPeopleGesture = UITapGestureRecognizer(target: self, action: #selector(showPeopleImageTapped(_:)))
        showPeopleImage.addGestureRecognizer(showPeopleGesture)
    }
    
    private func calculate() {
        
        var tax: Float
        var tip: Float
        
        for item in items {
            item.price = item.price / Float(item.people.count)
        }
        
        for person in people {
            
            tax = 0
            tip = 0
            for item in (person?.items)! {
                
                tax += item.price * Float(taxTextField.text!)! / 100
                tip += item.price * Float(tipTextField.text!)! / 100
                person?.owe += item.price + tax + tip
            }
            let taxItem = Item(name: "tax", price: tax)
            let tipItem = Item(name: "tip", price: tip)
            person?.addItem(item: taxItem)
            person?.addItem(item: tipItem)
            
            tax = 0
            tip = 0
        }
    }

    // MARK: Tap Gesture Recognizer
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
                self.currentPerson = person
                self.currentPersonLabel.text = person.name
                self.tableView.reloadData()
            }
        }))
        
        // Add cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func showPeopleImageTapped(_ sender: UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUp") as! PopUpViewController
        popUpVC.people = people as! [Person]
        popUpVC.delegate = self
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true, completion: nil)
    }
    
    func peopleImageTapped(_ sender: UITapGestureRecognizer) {
        
        let tapLocation = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUp") as! PopUpViewController
        popUpVC.people = items[(indexPath?.row)!].people
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true, completion: nil)
        
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

        cell.people.tag = indexPath.row
        
        cell.name[0].text = items[indexPath.row].name
        cell.price[0].setTitle("$\(items[indexPath.row].price)", for: .normal)
        
        let peopleGesture = UITapGestureRecognizer(target: self, action: #selector(peopleImageTapped(_:)))
        
        cell.people.addGestureRecognizer(peopleGesture)
        
        var foundPerson = false
        for person in items[indexPath.row].people {
            
            if person === currentPerson {
                cell.backgroundColor = UIColor.yellow
                foundPerson = true
            }
        }
        if foundPerson == false {
            cell.backgroundColor = UIColor.white
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if currentPerson != nil {
            
            if cell?.backgroundColor == UIColor.white {
                
                currentPerson?.addItem(item: items[indexPath.row])
                items[indexPath.row].addPerson(person: currentPerson!)
                tableView.reloadData()
            }
            else {
                
                currentPerson?.removeItem(item: items[indexPath.row])
                items[indexPath.row].removePerson(person: currentPerson!)
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "assignPeopleSegue", sender: nil)
    }
    
    // Mark : Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "assignPeopleSegue" {
            calculate()
            if let assignPeopleVC = segue.destination as? AssignPeopleTableViewController {
                assignPeopleVC.people = people
            }
        }
    }
}

extension AssignItemTableViewController: PopUpViewControllerDelegate {
    
    func getSelectedUser(person: Person) {
        
        currentPerson = person
        currentPersonLabel.text = currentPerson?.name
        tableView.reloadData()
    }
}
