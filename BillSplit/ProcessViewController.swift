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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            
        }
    }
}
