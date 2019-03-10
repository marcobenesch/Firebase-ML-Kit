//
//  ViewController.swift
//  Firebase ML Kit
//
//  Created by Marco Benesch on 10.03.19.
//  Copyright © 2019 Marco Benesch. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // MARK: - Variables and Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classifierLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupImagePicker()
    
    }
    
    // MARK: - Functions
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
    }

    
    @IBAction func takePhotoButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Label images with Firebase/MLVision
    func labelImage(image: VisionImage) {
        let labeler = Vision.vision().onDeviceImageLabeler()
        
        labeler.process(image) { (labels, error) in
            guard error == nil, let labels = labels else { return }
            
            for label in labels {
                print("\(label.text) - \(String(describing: label.entityID)) - \(String(describing: label.confidence))")
            }
            let label = labels[0].text
            let confidence = labels[0].confidence
            
            self.classifierLabel.text = "Label: \(label)"
            self.confidenceLabel.text = "Confidence: \(confidence)"
        }
    }
}


// MARK: - Extensions

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let takenPhoto = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = takenPhoto
            let visionImage = VisionImage(image: takenPhoto)
            labelImage(image: visionImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

