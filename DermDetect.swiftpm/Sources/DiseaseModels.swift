//
// DiseaseModels.swift
// GENERATED CONTENT. DO NOT EDIT.
//

import Foundation
import RealityKit
import Combine

@available(iOS 13.0, macOS 10.15, *)
public enum DiseaseModels: String {
    case normal = "normal skin", eczema = "eczema", melanoma = "melanoma/mole", psoriasis = "psoriasis", warts = "warts"
    
    public static func getModel(_ name: String) -> DiseaseModels {
        let ARModelType: DiseaseModels
        
        switch name {
        case "Eczema":
            ARModelType = DiseaseModels.eczema
        
        case "Melanoma:Mole":
            ARModelType = DiseaseModels.melanoma
            
        case "Psoriasis":
            ARModelType = DiseaseModels.psoriasis
        
        case "Warts":
            ARModelType = DiseaseModels.warts
            
        default:
            ARModelType = DiseaseModels.normal
        }
        
        return ARModelType
        
    }

    public enum LoadRealityFileError: Error {
        case fileNotFound(String)
    }

    private static var streams = [Combine.AnyCancellable]()
    
    public static func load(_ diseaseType: DiseaseModels) throws -> AnchorEntity {
        guard let realityFileURL = Bundle.main.url(forResource: "DiseaseModels", withExtension: "reality") else {
            throw DiseaseModels.LoadRealityFileError.fileNotFound("DiseaseModels.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent(diseaseType.rawValue.capitalized, isDirectory: false)
        let anchorEntity = try Entity.loadAnchor(contentsOf: realityFileSceneURL)
        return create(diseaseType, from: anchorEntity)
    }

    public static func loadAsync(_ diseaseType: DiseaseModels, completion: @escaping (Swift.Result<Entity, Swift.Error>) -> Void) {
        guard let realityFileURL = Bundle.main.url(forResource: "DiseaseModels", withExtension: "reality") else {
            completion(.failure(DiseaseModels.LoadRealityFileError.fileNotFound("DiseaseModels.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent(diseaseType.rawValue.capitalized, isDirectory: false)
        let loadRequest = Entity.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(create(diseaseType, from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func create(_ diseaseType: DiseaseModels, from anchorEntity: AnchorEntity) -> AnchorEntity {
        let model = AnchorEntity()
        model.anchoring = anchorEntity.anchoring
        model.addChild(anchorEntity)
        return model
    }
}
