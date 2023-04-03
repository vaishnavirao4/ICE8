

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "bird.jpg")
        
        let imagePath = Bundle.main.path(forResource: "bird" , ofType: "jpg")
        let imageURL = NSURL.fileURL(withPath: imagePath!)
        
        
        let modelFile = MobileNetV2()
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler: findResults)
        try! handler.perform([request])
    }

    
    func findResults(request: VNRequest, error: Error?) {
        guard let results = request.results as?
                [VNClassificationObservation] else {
            return
        }
        var bestGuess = ""
        var bestConfidence: VNConfidence = 0
        for classification in results {
            if (classification.confidence > bestConfidence) {
                bestConfidence = classification.confidence
                bestGuess = classification.identifier
            }
        }
        labelDescription.text = "Image is: \(bestGuess) with confidence \(bestConfidence) out of 1"
    }

}

