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
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {

        var text:String! = processedTextView.text
        
        var test:String.Index = text.startIndex
        
        /*
        while test != text.endIndex {
            
            if let range = text.range(of: "\n") {
                
                let index = text.startIndex ..< range.lowerBound
                print("text : \(text[index])")
                
                let index2 = text.index(after: range.upperBound) ..< text.endIndex
                text = text[index2]
            }
        }
        */
 
        /*
        if let range = text.range(of: "\n") {
            
            let rangeOfString = text.startIndex ..< range.lowerBound
            let line = text.substring(with: rangeOfString)
            print("S : \(line)")
            
            let index2 = text.index(after: range.upperBound) ..< text.endIndex
            
            text = text[index2]
            print("text : \(text)")
            
        }
        */
        
    }
}
