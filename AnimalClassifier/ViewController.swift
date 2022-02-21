//
//  ViewController.swift
//  AnimalClassifier
//
//  Created by Zahra Sadeghipoor on 2/21/22.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    private var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
    }

    @IBAction func camButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Failed to get image from camera")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = image
        
        guard let ciimage = CIImage(image: image) else {
            fatalError("Failed to convert to ciimage")
        }
        
        detectAnimal(ciimage)
    }
    
    func detectAnimal(_ image: CIImage) {
        do {
            let model = try VNCoreMLModel(for:AnimalClassifier().model)
            let request = VNCoreMLRequest(model: model) { request, error in
                let results = request.results as! [VNClassificationObservation]
                let animalType = results.first?.identifier
                self.navigationItem.title = animalType
            }
            let handler = VNImageRequestHandler(ciImage:image)
            do {
                try handler.perform([request])
            } catch {
                fatalError("Failed to peform request")
            }
        } catch {
            fatalError("Failed to load ML model")
        }
    }
    
}

