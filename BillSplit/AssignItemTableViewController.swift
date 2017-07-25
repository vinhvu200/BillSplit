//
//  AssignItemTableViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/10/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit

class AssignItemTableViewController: UITableViewController {

    // Allows the Controller to know who is selected
    var currentPerson: Person? = nil
    // Array of the every Person (these people need to be added)
    var people: [Person?] = []
    // Array of all the items
    var items: [Item] = []
    
    @IBOutlet weak var currentPersonLabel: UILabel!
    @IBOutlet weak var addPersonImage: UIImageView!
    @IBOutlet weak var showPeopleImage: UIImageView!
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var optionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // AddPersonImage can be clicked in order to allow users add people
        // to divide the bill
        let addPersonGesture = UITapGestureRecognizer(target: self, action: #selector(addPersonImageTapped(_:)))
        addPersonImage.addGestureRecognizer(addPersonGesture)
        
        // Show all the people who are paying this bill
        let showPeopleGesture = UITapGestureRecognizer(target: self, action: #selector(showPeopleImageTapped(_:)))
        showPeopleImage.addGestureRecognizer(showPeopleGesture)
        
        // This is used to dismiss the keyboard in case it is up
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        optionView.addGestureRecognizer(tap)
    }
    
    /*
        -Purpose: Dimiss keyboard if it is up
    */
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        
        // Add a border to just the bottom of the optionView
        // in order to separate it from the tableview underneath
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: optionView.frame.height, width: optionView.frame.width, height: 1.5)
        optionView.layer.addSublayer(border)
    }
    
    /*
        Purpose: calculates everyone in people array owes
        -Tax and tip is dependent on user input
        -Adds two additional items for each Person: Tax, and Tip
    */
    private func calculate() {
        
        // Variables to calculate individual/total tax/tip
        // for each Person
        var tax: Float = 0
        var tip: Float = 0
        var totalTax: Float = 0
        var totalTip: Float = 0
        
        // Goes through each item and divide it by the amount
        // of people what selected the item
        for item in items {
            item.price = item.price / Float(item.people.count)
        }
        
        // Loop through people array
        for person in people {
            
            // Loops through all the items of a Person
            for item in (person?.items)! {
                
                // Tax and Tip is determined by what user entered in the taxTextField
                tax += item.price * Float(taxTextField.text!)! / 100
                tip += item.price * Float(tipTextField.text!)! / 100
                
                // Add those to totalTax and totalTip to be added to
                // the Person later as an Item
                totalTax += tax
                totalTip += tip
                
                // Updates how much the person owes
                person?.owe += item.price + tax + tip
                
                // Reset tax and tip
                tax = 0
                tip = 0
            }
            
            // Add Tax and tip Item to Person
            let taxItem = Item(name: "Tax", price: totalTax)
            let tipItem = Item(name: "Tip", price: totalTip)
            person?.addItem(item: taxItem)
            person?.addItem(item: tipItem)
            
            // Reset totalTax and totalTip for the next Person
            totalTax = 0
            totalTip = 0
        }
    }

    // MARK: Tap Gesture Recognizer
    /*
        -Purpose: Brings up an alert for User to add additional Person (placed in people array)
    */
    func addPersonImageTapped(_ sender: UITapGestureRecognizer) {
        
        // Makes sure to dismiss keyboard if it is up
        view.endEditing(true)
        
        // Create the alert controller.
        let alert = UIAlertController(title: "Enter Name", message: nil, preferredStyle: .alert)
        
        // Add text field
        alert.addTextField(configurationHandler: nil)
        
        // Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            // Force unwrapping because we know it exists.
            let textField = alert?.textFields![0]
            
            // Make sure the textField isn't empty
            if !(textField?.text?.isEmpty)! {
                
                // Takes the name and capitalize the first letter
                var name = (textField?.text)!
                let first = String(name.characters.prefix(1)).capitalized
                let other = String(name.characters.dropFirst())
                
                // Create the Person object
                let person = Person(name: first+other)
                
                // Place the Person into people array
                self.people.append(person)
                
                // Update this view's currentPerson
                self.currentPerson = person
                
                // Updates the currentPersonLabel and reload data
                self.currentPersonLabel.text = "User : \(person.name)"
                self.tableView.reloadData()
            }
        }))
        
        // Add cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    /*
        -Purpose: handle tap gesture for when showPeopleImage is tapped
        -Instantiates the PopUpVC and uses delegate for that to pass back
        the user that is selected from the tableview to update the currentPerson
        variable
        -All these people are those who will be paying the bill
    */
    func showPeopleImageTapped(_ sender: UITapGestureRecognizer) {
        
        // Dismiss keyboard if it is up
        view.endEditing(true)
        
        // instantiates the PopUpVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUp") as! PopUpViewController
        
        // Passes people array over to view
        popUpVC.people = people as! [Person]
        
        // Set delegate in order to get the Person user selected
        // from the table view
        popUpVC.delegate = self
        
        // Set up style and present
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true, completion: nil)
    }
    
    /*
        -Purpose: handle tap gesture of the peopleImage
        -Instantiates the PopUpVC to see Person who are paying 
        for a specific item
    */
    func peopleImageTapped(_ sender: UITapGestureRecognizer) {
        
        // Dismiss keyboard if it is up
        view.endEditing(true)
        
        // Identifies where the image was tapped to reference it later
        // Because of reusuable dequeuing
        let tapLocation = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        
        // Instantiate the PopUpVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popUpVC = storyboard.instantiateViewController(withIdentifier: "popUp") as! PopUpViewController
        
        // Pass over the item's list of people
        popUpVC.people = items[(indexPath?.row)!].people
        
        // Set up style and present
        popUpVC.modalPresentationStyle = .overCurrentContext
        popUpVC.modalTransitionStyle = .crossDissolve
        self.present(popUpVC, animated: true, completion: nil)
        
    }

    // MARK: - Table view data source
    // Declare number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    // Declare number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    // Customize the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue reusable cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignCell", for: indexPath) as! ItemTableViewCell

        // Set background color to light gray
        cell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.10)
        
        // nameLabel of cell is set in accordance with item array
        // makes sure that it is to two decimal places
        cell.name[0].text = items[indexPath.row].name
        let twoDecimalPlaces = String(format: "%.2f", items[indexPath.row].price)
        cell.price[0].setTitle("$\(twoDecimalPlaces)", for: .normal)
        
        // people image are attached so user can see which Person(or people) 
        // is responsible for paying for the item
        let peopleGesture = UITapGestureRecognizer(target: self, action: #selector(peopleImageTapped(_:)))
        cell.people.addGestureRecognizer(peopleGesture)
        
        // Check the people array of this item and see if any of the Person listed
        // matches the currentPerson of this view.
        // If there is a match, cell's appearance will be changed to show that
        var foundPerson = false
        for person in items[indexPath.row].people {
            
            if person === currentPerson {
                
                cell.name[0].textColor = UIColor(red: 0.0, green: 139.0/255.0, blue: 139.0/255.0, alpha: 1.0)
                cell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.40)
                cell.name[0].font = UIFont.boldSystemFont(ofSize: 18.0)
                foundPerson = true
            }
        }
        
        // If the currentPerson does not own this item then it will stay plainwhite
        if foundPerson == false {
            cell.backgroundColor = UIColor.white
            cell.name[0].font = UIFont.systemFont(ofSize: 17.0)
            cell.name[0].textColor = UIColor.black
        }

        // Return cell
        return cell
    }
    
    // Handles action when row is selected
    // WHITE background: currentPerson does not have responsibility for this item
    // GRAY background: currentPerson has responsibility to pay for this item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Dismiss keyboard if it is up
        view.endEditing(true)
        
        // Find the cell
        let cell = tableView.cellForRow(at: indexPath)
        
        // Change the view of the cell between regular white and
        // gray background (and more)
        if currentPerson != nil {
            
            // If the background is white, and clicked on...
            // The item is added to Person.items to signify that
            // the person is responsible for it
            if cell?.backgroundColor == UIColor.white {
                
                currentPerson?.addItem(item: items[indexPath.row])
                items[indexPath.row].addPerson(person: currentPerson!)
                tableView.reloadData()
            }
            // If the background is gray, and clicked on...
            // The item is removed from Person.items to signify that
            // the person does not hold responsibility for it
            else {
                
                currentPerson?.removeItem(item: items[indexPath.row])
                items[indexPath.row].removePerson(person: currentPerson!)
                tableView.reloadData()
            }
        }
    }
    
    /*
        -Purpose: Handles action when the Done UIBarButtonItem is tapped
        -Checks whether the tipTextField and taxTextField was inputted correctly
        -If checks are passed, then segue will be performed
        -Otherwise, there will be a red border around the textField to signify
        that it is incorrectly inputted (or was not input at all)
    */
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        // flag1 checks for taxTextField
        // flag2 checks for tipTextField
        var flag1 = false
        var flag2 = false
        
        // If tax is inputted correctly, flag1 will turn true
        if let tax = Float(taxTextField.text!) {
            
            if tax >= 0.0 && tax <= 100.0 {
                flag1 = true
            }
        }
        
        // If tip is inputted correctly, flag2 will turn true
        if let tip = Float(tipTextField.text!) {
            
            if tip >= 0.0 && tip <= 100.0 {
                flag2 = true
            }
        }
        
        // If both tax and tips are inputted correctly, perform segue
        if flag1 && flag2 {
            performSegue(withIdentifier: "assignPeopleSegue", sender: nil)
        }
        
        // If either flags are inputted incorrectly, change to a red border
        // to signify incorrectness
        if !flag1 {
            taxTextField.layer.cornerRadius = 5
            taxTextField.layer.borderWidth = 1.5
            taxTextField.layer.borderColor = UIColor.red.cgColor
        }
        if !flag2 {
            tipTextField.layer.cornerRadius = 5
            tipTextField.layer.borderWidth = 1.5
            tipTextField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    // Mark : Segue
    /*
        -Purpose: calculates the Bill for everyone in people array
        and pass that data onto the AssignPeopleVC
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Checks for correct segue
        if segue.identifier == "assignPeopleSegue" {
            
            if let assignPeopleVC = segue.destination as? AssignPeopleTableViewController {
                // calculate everyone's bill
                calculate()
                // Pass information over to AssignPeopleTVC
                assignPeopleVC.people = people
            }
        }
    }
}

extension AssignItemTableViewController: PopUpViewControllerDelegate {

    /*
        -Purpose: Get the user selected when tableview of people is shown
        -Updates the currentPerson variable of this view
    */
    func getSelectedUser(person: Person) {
        
        // If person is passed back update currentPerson
        currentPerson = person
        if let user = currentPerson?.name {
            currentPersonLabel.text = "User: \(user)"
        }
        tableView.reloadData()
    }
}
