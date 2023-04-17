//
// DermDetectModel.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML

// <= v5: REPLACE input_1 with resnet50_input


/// Model Prediction Input Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class DermDetectModelInput : MLFeatureProvider {

    /// input_1 as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
    var input_1: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["input_1"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input_1") {
            return MLFeatureValue(pixelBuffer: input_1)
        }
        return nil
    }
    
    init(input_1: CVPixelBuffer) {
        self.input_1 = input_1
    }

    convenience init(input_1With input_1: CGImage) throws {
        self.init(input_1: try MLFeatureValue(cgImage: input_1, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
    }

    convenience init(input_1At input_1: URL) throws {
        self.init(input_1: try MLFeatureValue(imageAt: input_1, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
    }

    func setInput_1(with input_1: CGImage) throws  {
        self.input_1 = try MLFeatureValue(cgImage: input_1, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }

    func setInput_1(with input_1: URL) throws  {
        self.input_1 = try MLFeatureValue(imageAt: input_1, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }

}


/// Model Prediction Output Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class DermDetectModelOutput : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// Identity as dictionary of strings to doubles
    var Identity: [String : Double] {
        return self.provider.featureValue(for: "Identity")!.dictionaryValue as! [String : Double]
    }

    /// classLabel as string value
    var classLabel: String {
        return self.provider.featureValue(for: "classLabel")!.stringValue
    }

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(Identity: [String : Double], classLabel: String) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["Identity" : MLFeatureValue(dictionary: Identity as [AnyHashable : NSNumber]), "classLabel" : MLFeatureValue(string: classLabel)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class DermDetectModel {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let path = Bundle.main.url(forResource: "DermDetectModel", withExtension: "mlmodelc")!
        return path
    }

    /**
        Construct DermDetectModel instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of DermDetectModel.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `DermDetectModel.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct DermDetectModel instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct DermDetectModel instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct DermDetectModel instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<DermDetectModel, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct DermDetectModel instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> DermDetectModel {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct DermDetectModel instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<DermDetectModel, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(DermDetectModel(model: model)))
            }
        }
    }

    /**
        Construct DermDetectModel instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> DermDetectModel {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return DermDetectModel(model: model)
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as DermDetectModelInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as DermDetectModelOutput
    */
    func prediction(input: DermDetectModelInput) throws -> DermDetectModelOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as DermDetectModelInput
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as DermDetectModelOutput
    */
    func prediction(input: DermDetectModelInput, options: MLPredictionOptions) throws -> DermDetectModelOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return DermDetectModelOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - input_1 as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as DermDetectModelOutput
    */
    func prediction(input_1: CVPixelBuffer) throws -> DermDetectModelOutput {
        let input_ = DermDetectModelInput(input_1: input_1)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [DermDetectModelInput]
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [DermDetectModelOutput]
    */
    func predictions(inputs: [DermDetectModelInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [DermDetectModelOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [DermDetectModelOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  DermDetectModelOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
