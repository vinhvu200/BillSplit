//
//  AssignPeopleTableViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/18/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit

class AssignPeopleTableViewController: UITableViewController {

    var people: [Person?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK : Private Functions
    private func getParentIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: Person?
        var selectedIndex = expansionIndex
        
        while (selectedCell == nil && selectedIndex >= 0) {
            
            selectedIndex -= 1
            selectedCell = people[selectedIndex]
        }
        
        return selectedIndex
    }
    
    private func expandCell(tableView: UITableView, index: Int) {
        
        if let items = people[index]?.items {
            
            for i in 1...items.count {
                people.insert(nil, at: index + i)
                tableView.insertRows(at: [IndexPath(row: index + i, section: 0)], with: .top)
            }
        }
    }
    
    private func contractCell(tableView: UITableView, index: Int) {
        
        if let items = people[index]?.items {
            
            for _ in 1...items.count {
                people.remove(at: index+1)
                tableView.deleteRows(at: [IndexPath(row: index+1, section: 0)], with: .top)
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let person = people[indexPath.row] {
            
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultTableViewCell
            defaultCell.personNameLabel.text = person.name
            
            defaultCell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.4)
            
            let roundedNumber = String(format: "%.2f", person.owe)
            defaultCell.personTotalLabel.text = "$\(roundedNumber)"
            
            return defaultCell
        }
        else {
            
            if let person = people[getParentIndex(expansionIndex: indexPath.row)] {
            
                let expansionCell = tableView.dequeueReusableCell(withIdentifier: "ExpansionCell", for: indexPath) as! ExpansionTableViewCell
            
                expansionCell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.15)
                let parentCellIndex = getParentIndex(expansionIndex: indexPath.row)
                let expandIndex = indexPath.row - parentCellIndex - 1
            
                expansionCell.itemNameLabel.text = person.items[expandIndex].name
                
                let roundedNumber = String(format: "%.2f", person.items[expandIndex].price)
                expansionCell.itemPriceLabel.text = "$\(roundedNumber)"
                
                return expansionCell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (people[indexPath.row]) != nil {
            return 60
        }
        else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (people[indexPath.row]) != nil {
            
            if (indexPath.row + 1 >= people.count) {
                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
                
                if(people[indexPath.row+1] != nil) {
                    expandCell(tableView: tableView, index: indexPath.row)
                }
                else {
                    contractCell(tableView: tableView, index: indexPath.row)
                }
            }
        }
    }

}
