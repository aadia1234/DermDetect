//
//  ARView.swift
//  DermDetect
//
//  Created by Aadi Anand on 4/6/23.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    @State private var arView = ARView(frame: .zero)
    @State private var coachingOverlay = ARCoachingOverlayView(frame: .zero)
    
    // Setups AR view and coaching view
    func makeUIView(context: Context) -> some ARView {
        arView.automaticallyConfigureSession = true
        coachingOverlay.activatesAutomatically = true
        arView.addSubview(coachingOverlay)
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = arView.session        
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return arView
    }
    
    //Creates AR model of a disease and display it
    public func createModel(_ entityType: DiseaseModels) {
        let anchor = try! DiseaseModels.load(entityType)
        let model = anchor.findEntity(named: "\(entityType.rawValue.lowercased()) model") as! Entity & HasCollision
        
        arView.scene.anchors.removeAll()
        arView.installGestures(.all, for: model)
        arView.scene.addAnchor(anchor)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
