//
//  ARDiseaseView.swift
//  DermDetect
//
//  Created by Aadi Anand on 4/8/23.
//

import SwiftUI
import RealityKit

struct ARDiseaseView: View {
    @State public var ARModelType: DiseaseModels
    @State private var show3DModelOptions = false
    @State private var ARDiseaseViewContainer = ARViewContainer()
    
    var body: some View {
        ARDiseaseViewContainer
            .toolbar {
                //Allows the user to choose multiple AR models to view
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Choose AR Model") { show3DModelOptions.toggle() }
                        .confirmationDialog("Choose an AR Model of a Disease", isPresented: $show3DModelOptions) {
                            Button("Normal Skin") { ARModelType = .normal }
                            Button("Eczema") { ARModelType = .eczema }
                            Button("Melonoma/Mole") { ARModelType = .melanoma }
                            Button("Psoriasis") { ARModelType = .psoriasis }
                            Button("Warts") { ARModelType = .warts }
                        }
                }
                
                //Resets anchor point of AR model
                ToolbarItem(placement: .primaryAction) {
                    Button { ARDiseaseViewContainer.createModel(ARModelType) } label: { Image(systemName: "arrow.clockwise.circle") }
                }
            }
            .onAppear { ARDiseaseViewContainer.createModel(ARModelType) }
            .onChange(of: ARModelType, perform: ARDiseaseViewContainer.createModel(_:))
            .navigationTitle(ARModelType.rawValue.capitalized)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ARDiseaseView_Previews: PreviewProvider {
    static var previews: some View {
        ARDiseaseView(ARModelType: DiseaseModels.melanoma)
    }
}
