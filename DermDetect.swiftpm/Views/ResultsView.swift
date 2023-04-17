//
//  CardView.swift
//  DermDetect
//
//  Created by Aadi Anand on 4/6/23.
//

import SwiftUI

struct ResultsView: View {
    @State public var image: UIImage
    @State private var diseases: [DiseasePrediction] = []
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding(.all, 10)
                .border(.ultraThinMaterial, width: 10.0)
            
            Spacer()
            
            // Display disease predictions/results
            VStack {
                ForEach(diseases, id: \.self) { disease in
                    HStack {
                        Text("\(disease.name == "Melanoma:Mole" ? disease.name.replacingOccurrences(of: ":", with: "/") : disease.name): \(String(format: "%.2f%%", disease.confidence * 100))")
                            .font(.title3)
                            .foregroundColor(getColor(disease.confidence))
                    }
                    .padding(.bottom, 30)
                }
            }
            .padding(.top, 15)
            
            
            Spacer()
        }
        .onAppear { diseases = Model.detect(image.cgImage!) }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                NavigationLink("View AR Model") {
                    ARDiseaseView(ARModelType: DiseaseModels.getModel(diseases.first?.name ?? "Normal"))
                }
            }
        }
    }
    
    
    //Returns a color based on the given confidence value (from a disease prediction)
    func getColor(_ confidence: Double) -> Color {
        if confidence < 0.4 {
            return .green
        } else if confidence < 0.8 {
            return .yellow
        } else {
            return .red
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ResultsView(image: UIImage(systemName: "exclamationmark.triangle.fill")!)
        }
    }
}
