//
//  PhotoUploadView.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 5.05.2021.
//

import SwiftUI
import UIKit

struct PhotoUploadView: View {
    @State private var selectedImage: UIImage?
    @State var postImage: Image?
    @State var captionText = ""
    @Binding var tabIndex: Int
    @ObservedObject var viewModel = UploadPostViewModel()
    
    
    
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
        
    
    @State var showPostImageView: Bool = false
        
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            VStack {
                
                Button(action: {
                    sourceType = UIImagePickerController.SourceType.camera
                    showImagePicker.toggle()
                }, label: {
                    Text("RESİM ÇEK".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("krem"))
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color("arkaplan"))
                
                Button(action: {
                    sourceType = UIImagePickerController.SourceType.photoLibrary
                    showImagePicker.toggle()
                }, label: {
                    Text("RESİM AKTAR".uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("arkaplan"))
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color("krem"))

            }
            .sheet(isPresented: $showImagePicker, onDismiss:segueToPostImageView, content: {
                ImagePicker(image: $selectedImage, sourceType: $sourceType)
                    .preferredColorScheme(colorScheme)
                    .accentColor(colorScheme == .light ? Color.purple : Color.orange)
            })
            
            Image("group")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 12)
                .fullScreenCover(isPresented: $showPostImageView, content: {
                    PostImageView(selectedImage: $selectedImage, postImage: $postImage, tabIndex: $tabIndex)
                        .preferredColorScheme(colorScheme)
                })
                
        }
        .edgesIgnoringSafeArea(.top)

    }
    
    // MARK: FUNCTIONS
    
    func segueToPostImageView() {
        if selectedImage != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                loadImage()
                showPostImageView.toggle()
            }
        }
    }
    
    
}

extension PhotoUploadView {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        postImage = Image(uiImage: selectedImage)
    }
}








