//
//  AssignItemTableViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/10/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit

class AssignItemTableViewController: UITableViewController {

    var items: [Item] = []
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
        
        print("hello world")
    }
    
    func showPeopleImageTapped(_ sender: UITapGestureRecognizer) {
        print("hello world 2")
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
