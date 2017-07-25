//
//  AssignPeopleTableViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/18/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

/*************************************************
 
    IMPORTANT: Item cells are represented as nil
    in the people array !!
 
 **************************************************/

import UIKit

class AssignPeopleTableViewController: UITableViewController {

    var people: [Person?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK : Private Functions
    
    /*
        -Purpose: gets the parent index by going up rows of cell until
        a cell is not nil
        -Return that index
    */
    private func getParentIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: Person?
        var selectedIndex = expansionIndex
        
        while (selectedCell == nil && selectedIndex >= 0) {
            
            selectedIndex -= 1
            selectedCell = people[selectedIndex]
        }
        
        return selectedIndex
    }
    
    /*
        -Purpose: expand cell by having the tableview insert rows after 
        an the index passed in
        -These data represents the all the items for the users
        -people array inserts a nil at its location to for the item
        which will be defined in cellForRowAt
    */
    private func expandCell(tableView: UITableView, index: Int) {
        
        // Gets all the items of that person
        if let items = people[index]?.items {
            
            // Insert it in subsequent rows of the index passed in
            for i in 1...items.count {
                
                // people array inserts a nil for each item
                people.insert(nil, at: index + i)
                // tableview will insert a row at those indices as well
                tableView.insertRows(at: [IndexPath(row: index + i, section: 0)], with: .top)
            }
        }
    }
    
    /*
        -Purpose: contract cells by having tableview delete rows after
        a certain index
        -These data represents all the items for the user being collapsed on
        -people array will remove the item
    */
    private func contractCell(tableView: UITableView, index: Int) {
        
        // Gets all the tiems of the person of index passed in
        if let items = people[index]?.items {
            
            // Delete the subsequent rows of the index passed in
            for _ in 1...items.count {
                
                // people array remove object at the index
                people.remove(at: index+1)
                // tableview follows through and delete the matching row
                tableView.deleteRows(at: [IndexPath(row: index+1, section: 0)], with: .top)
            }
        }
    }

    // MARK: - Table view data source
    // Declare number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    // Declare number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return people.count
    }

    // Customize cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // For cells that are actually defined, this condition will take care of the customization
        // These cells are for each (actual) person in people array
        if let person = people[indexPath.row] {
            
            // dequeue reusable
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultTableViewCell
            
            // set personNameLabel
            defaultCell.personNameLabel.text = person.name
            
            // set background color
            defaultCell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.4)
            
            // Round the number for personTotalLabel to two decimal places
            let roundedNumber = String(format: "%.2f", person.owe)
            defaultCell.personTotalLabel.text = "$\(roundedNumber)"
            
            // return cell
            return defaultCell
        }
        // This option handles the nil objects inside of people array
        // These nil objects actually represents items of a person when it is expanded
        else {
            
            if let person = people[getParentIndex(expansionIndex: indexPath.row)] {
            
                // dequeue reusable cell
                let expansionCell = tableView.dequeueReusableCell(withIdentifier: "ExpansionCell", for: indexPath) as! ExpansionTableViewCell
            
                // set background color
                expansionCell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.15)
                
                // Find the parent cell, which is the cell that actually exists (aka a Person object to represent that cell)
                let parentCellIndex = getParentIndex(expansionIndex: indexPath.row)
                
                // expandIndex will then be calculated to identify each of the Person's item
                let expandIndex = indexPath.row - parentCellIndex - 1
            
                // Set the itemNameLabel
                expansionCell.itemNameLabel.text = person.items[expandIndex].name
                
                // Bold the itemNameLabel if it is tax or tip
                if expansionCell.itemNameLabel.text == "Tax" ||
                    expansionCell.itemNameLabel.text == "Tip" {
                    
                    expansionCell.itemNameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                }
                // Regular font if itemNameLabel is not Tax or Tip
                else {
                    expansionCell.itemNameLabel.font = UIFont.systemFont(ofSize: 17.0)
                }
                
                // Round the itemPriceLabel to two digits
                let roundedNumber = String(format: "%.2f", person.items[expandIndex].price)
                expansionCell.itemPriceLabel.text = "$\(roundedNumber)"
                
                // return cell
                return expansionCell
            }
        }
        
        return UITableViewCell()
    }
    
    // Determines height for Person cell and item cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (people[indexPath.row]) != nil {
            return 60
        }
        else {
            return 40
        }
    }
    
    // when row is selected, determine whether to expand or contract
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (people[indexPath.row]) != nil {
            
            // Handles edge case for very last row being selected
            if (indexPath.row + 1 >= people.count) {
                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
             
                // expand cell if the people object exists
                // item objects are represented as nil in people array
                if(people[indexPath.row+1] != nil) {
                    expandCell(tableView: tableView, index: indexPath.row)
                }
                // contract cell otherwise
                else {
                    contractCell(tableView: tableView, index: indexPath.row)
                }
            }
        }
    }
}
