//
//  WelcomeView.swift
//  DermDetect
//
//  Created by Aadi Anand on 4/6/23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var photo = UIImage()
    @State private var showAlert = false
    @State private var showPhotoPicker = false
    @State private var showSourceDialog = false
    @State private var photoSource = UIImagePickerController.SourceType.camera
    @State private var showResults = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(uiImage: UIImage(named: "AppIcon")!)
                .resizable()
                .imageScale(.medium)
                .foregroundColor(.accentColor)
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .padding(.bottom, 80)
            
            Button("Scan Your Skin!") {
                showAlert.toggle()
            }
            .font(.title)
            
            //Allows the user to pick whether to choose an image from a library or to take one themselves
            .confirmationDialog("Select a source", isPresented: $showSourceDialog, titleVisibility: .visible) {
                Button("Pick from Photo Library") { photoSource = .photoLibrary; showPhotoPicker.toggle() }
                Button("Take a Photo") { photoSource = .camera; showPhotoPicker.toggle() }
            } message: {
                Text("Please choose a clear image of your skin")
            }
            
            Spacer()
        }
        .navigationTitle("Welcome to DermDetect!")
        .onChange(of: photo, perform: { _ in showResults.toggle()})
        .navigationDestination(isPresented: $showResults, destination: { ResultsView(image: photo) })
        .fullScreenCover(isPresented: $showPhotoPicker) { ImagePicker(selectedImage: $photo, sourceType: photoSource).edgesIgnoringSafeArea(.all) }
        //Important disclaimer to let users know the app is a prototype and is not meant to be used as a substitute for a consultation with a doctor
        .alert("Disclaimer!", isPresented: $showAlert, actions: {
            Button("Continue", role: .cancel) {
                showAlert.toggle()
                showSourceDialog.toggle()
            }
        }, message: {
            Text("Please be aware the predicted results may not be completely accurate – Consult with a doctor to get more information about your skin lesion/issue. For best results, make sure your skin lesion is clearly visible and there are no distractions/objects in the background of your photo.")
        })
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
