//
//  PopUpViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 7/15/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
