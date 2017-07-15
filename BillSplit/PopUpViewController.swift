//
//  PopUpViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/15/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit


protocol PopUpViewControllerDelegate {
    func getSelectedUser(person: Person)
}

class PopUpViewController: UIViewController {

    var delegate: PopUpViewControllerDelegate? = nil
    var people: [Person] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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

    func backgroundViewTapped(_ sender: UITapGestureRecognizer!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PopUpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return people.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpCell", for: indexPath) as! PeopleTableViewCell
        
        cell.name.text = people[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.getSelectedUser(person: people[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
