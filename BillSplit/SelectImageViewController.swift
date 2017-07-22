//
//  SelectImageViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 6/5/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit
import TesseractOCR

class SelectImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var items: [Item] = []
    
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
    
    // MARK: Private Functions
    
    private func performImageRecognition(image: UIImage) {
        
        if let tesseract = G8Tesseract(language: "eng") {
            
            tesseract.pageSegmentationMode = .auto
            tesseract.maximumRecognitionTime = 60.0
            tesseract.image = image.g8_blackAndWhite()
            tesseract.recognize()
            processText(recognizedText: tesseract.recognizedText)
        }
    }
    
    // Split the processed text into lines and store
    // them into an array
    // Afterward, remove all the ones that requires
    private func processText(recognizedText: String){
        
        var allLines: [String] = []
        
        // Remove all element first before filling it up
        // allLines.removeAll()
        
        // Place processed text into new String
        //var text:String! = processedTextView.text
        var text:String! = recognizedText
        
        // Declare range to find \n
        var range:Range<String.Index>?
        
        // range attempts to find \n
        range = text.range(of: "\n")
        
        // Run loop while range is still able to find \n
        while range != nil {
            
            // Get index from beginning of text to \n
            let index = text.startIndex ..< (range?.lowerBound)!
            
            // Create the line of string with index
            let line = text[index]
            
            // Append the line
            allLines.append(line)
            
            // Get index for after the the \n to the end
            let index2 = text.index(after: (range?.lowerBound)!) ..< text.endIndex
            
            // Update the text with the index
            text = text[index2]
            
            // Attempts to find \n
            range = text.range(of: "\n")
        }
        
        // Remove all whitespace form allLines array
        allLines = allLines.filter{ !$0.trimmingCharacters(in: .whitespaces).isEmpty}
        
        for line in allLines {
            let item = Item(name: line, price: 0)
            items.append(item)
        }
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
        
        //let image = photoImageView.image
        if photoImageView.image != #imageLiteral(resourceName: "defaultPhoto") {
            
            performImageRecognition(image: photoImageView.image!)
            performSegue(withIdentifier: "priceSegue", sender: nil)
        }
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "priceSegue" {
            
            if let priceVC = segue.destination as? PriceTableViewController {
                
                priceVC.items = items
                priceVC.passedImage = photoImageView.image
                //priceVC.processedImageView.image = photoImageView.image
                //processVC.passedImage = sender as? UIImage
            }
        }
    }
}
