//
//  SelectImageViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 6/5/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit

class SelectImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var processButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidLayoutSubviews() {
        
        processButton.layer.cornerRadius = 5
        processButton.layer.borderWidth = 1
        processButton.layer.borderColor = UIColor(red: 0.0, green: 139.0/255.0, blue: 139.0/255.0, alpha: 1.0).cgColor
        //processButton.layer.borderColor = UIColor.darkGray.cgColor
        processButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    // MARK: Action
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
    
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func processImageTapped(_ sender: UIButton) {
        
        let image = photoImageView.image
        if image != #imageLiteral(resourceName: "defaultPhoto") {
            performSegue(withIdentifier: "processSegue", sender: image)
        }
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "processSegue" {
            
            if let processVC = segue.destination as? ProcessViewController {
                
                processVC.passedImage = sender as? UIImage
            }
        }
    }
}
