//
//  PopUpViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/15/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit

/* 
    -Purpose: Set up protocol to get the person selected 
    from this view
 */
protocol PopUpViewControllerDelegate {
    func getSelectedUser(person: Person)
}

class PopUpViewController: UIViewController {

    var delegate: PopUpViewControllerDelegate? = nil
    var people: [Person] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the tableview delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Adds the tapGesture to the background in order to 
        // dismiss this View if clicked outside of tableview
        let backgroundViewGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(_:)))
        
        // Screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        // Background View
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundView.addGestureRecognizer(backgroundViewGesture)
        
        // Add the backgroundView and move it to background
        self.view.addSubview(backgroundView)
        self.view.sendSubview(toBack: backgroundView)
    }

    /*
        -Purpose: Dismiss this view if the background (outside of tableview)
        is tapped
    */
    func backgroundViewTapped(_ sender: UITapGestureRecognizer!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PopUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Declare number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // Declare number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return people.count
    }

    // Customize cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeue reusuable
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpCell", for: indexPath) as! PeopleTableViewCell
        
        // Set nameLabel of cell in accordance to people array
        cell.name.text = people[indexPath.row].name
        
        // return cell
        return cell
    }
    
    // Handles action when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // passes the selected user back if tapped
        self.delegate?.getSelectedUser(person: people[indexPath.row])
        // remove this view
        self.dismiss(animated: true, completion: nil)
    }
}
