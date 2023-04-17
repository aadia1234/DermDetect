//
//  Model.swift
//  DermDetect
//
//  Created by Aadi Anand on 4/4/23.
//

import CoreML
import Vision

struct DiseasePrediction: Hashable {
    public let name: String
    public let confidence: Double
}

class Model {
    private static var predictions = [String:Double]()
    
    //Gets predictions of diseases and confidence levels based on an input image
    static func detect(_ image: CGImage) -> [DiseasePrediction] {
        let model = try! DermDetectModel(configuration: MLModelConfiguration())
        let visionModel = try! VNCoreMLModel(for: model.model)
        let handler = VNImageRequestHandler(cgImage: image)
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: coreMLHandler)
        let requests: [VNRequest] = [classificationRequest]
        
        do {
            try handler.perform(requests)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let sorted = predictions.sorted{$1.value < $0.value}.map{DiseasePrediction(name: $0, confidence: $1)}
        return sorted
    }
    
    //CoreMLHandler - completion handler to be run when classification has been completed
    private static var coreMLHandler: VNRequestCompletionHandler = { output, error in
        let results = output.results as! [VNClassificationObservation]
        
        for prediction in results {
            let disease: String = prediction.identifier
            let confidence: Double = Double(prediction.confidence.magnitude)
            predictions[disease] = confidence
        }
    }
}
