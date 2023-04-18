//
//  WelcomeView.swift
//  DermDetect
//
//  Created by Aadi Anand on 4/6/23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var photo = UIImage()
    @State private var showDisclaimer = false
    @State private var showInfoAlert = false
    @State private var showPhotoPicker = false
    @State private var showSourceDialog = false
    @State private var showResults = false
    @State private var photoSource = UIImagePickerController.SourceType.camera
    
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
                showDisclaimer.toggle()
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showInfoAlert.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                }

            }
        }
        //Important info about building and running this app
        .alert("Important Info!", isPresented: $showInfoAlert, actions: {
            Button("Continue", role: .cancel) { showInfoAlert.toggle() }
        }, message: {
            Text("Please build and run this app on Swift Playgrounds on an iPad with iPadOS 16")
        })
        
        //Important disclaimer to let users know the app is a prototype and is not meant to be used as a substitute for a consultation with a doctor
        .alert("Disclaimer!", isPresented: $showDisclaimer, actions: {
            Button("Continue", role: .cancel) {
                showDisclaimer.toggle()
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
