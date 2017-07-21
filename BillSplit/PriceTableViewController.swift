//
//  PriceTableViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/7/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit

class PriceTableViewController: UITableViewController {

    var items: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as! ItemTableViewCell
        
        cell.name[0].tag = indexPath.row
        cell.price[0].tag = indexPath.row
        cell.deleteButton[0].tag = indexPath.row
        
        cell.name[0].text = items[indexPath.row].name
        
        let twoDecimalPlaces = String(format: "%.2f", items[indexPath.row].price)
        cell.price[0].setTitle("$\(twoDecimalPlaces)", for: .normal)
        
        let nameChangeGesture = UITapGestureRecognizer(target: self, action: #selector(nameChange(_:)))
        nameChangeGesture.numberOfTapsRequired = 2
        
        cell.name[0].addGestureRecognizer(nameChangeGesture)
        cell.price[0].addTarget(self, action: #selector(priceButtonTapped), for: .touchUpInside)
        cell.deleteButton[0].addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func priceButtonTapped(sender: UIButton!) {
        
        // Create the alert controller.
        let alert = UIAlertController(title: "Enter Price", message: nil, preferredStyle: .alert)
        
        // Add the text field
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
            //textField.text = ""
        }
        
        // Grab the value from the text field,
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if !(textField?.text?.isEmpty)! {
                
                self.items[sender.tag].price = Float((textField?.text)!)!
                self.tableView.reloadData()
            }
        }))
        
        // Add cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func deleteButtonTapped(sender: UIButton!) {
        
        tableView.reloadData()
        items.remove(at: sender.tag)
        tableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .left)
    }
    
    func nameChange(_ sender: UITapGestureRecognizer) {
        
        // Create the alert controller.
        let alert = UIAlertController(title: "Enter Item Name", message: nil, preferredStyle: .alert)
        
        // Add text field
        alert.addTextField(configurationHandler: nil)
        
        // Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if !(textField?.text?.isEmpty)! {
                self.items[(sender.view?.tag)!].name = (textField?.text)!
                self.tableView.reloadData()
            }
        }))
        
        // Add cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "assignSegue", sender: nil)
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "assignSegue" {
            if let assignVC = segue.destination as? AssignItemTableViewController {
                assignVC.items = items
            }
        }
    }
}
