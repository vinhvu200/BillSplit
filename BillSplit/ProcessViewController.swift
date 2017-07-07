//
//  ProcessViewController.swift
//  BillSplit
//
//  Created by Vinh Vu on 6/5/17.
//  Copyright © 2017 Vinh Vu. All rights reserved.
//

import UIKit
import TesseractOCR

class ProcessViewController: UIViewController {

    @IBOutlet weak var processImageView: UIImageView!
    var passedImage: UIImage?
    @IBOutlet weak var processedTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        processImageView.image = passedImage
        performImageRecognition(image: processImageView.image!)
    }
    
    func performImageRecognition(image: UIImage) {
        
        if let tesseract = G8Tesseract(language: "eng") {
            
            tesseract.pageSegmentationMode = .auto
            tesseract.maximumRecognitionTime = 60.0
            tesseract.image = image.g8_blackAndWhite()
            tesseract.recognize()
            processedTextView.text = tesseract.recognizedText
            processedTextView.sizeToFit()
            processedTextView.layoutIfNeeded()
            
            // Remake content height constraint because the intrinsic content size of
            // UITextView varies
            let textOrigin_y = processedTextView.frame.origin.y
            let textHeight = processedTextView.frame.size.height
            let nextButtonHeight = nextButton.frame.size.height
            
            let newContentHeight = textOrigin_y + textHeight + nextButtonHeight + 10
            containerViewHeight.constant = newContentHeight
        }
    }
    
    // Split the processed text into lines and store
    // them into an array
    // Afterward, remove all the ones that requires
    @IBAction func nextButtonTapped(_ sender: UIButton) {

        // Place processed text into new String
        var text:String! = processedTextView.text
        
        // Declare range to find \n
        var range:Range<String.Index>?
        
        // Declare allLines array to store each line
        var allLines: [String] = []
        
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
        
        print(allLines)
        
    }
}
