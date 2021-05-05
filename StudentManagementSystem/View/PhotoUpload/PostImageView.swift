

import SwiftUI

struct PostImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var captionText: String = ""
    @Binding var selectedImage: UIImage?
    @Binding var postImage: Image?
    
    @Binding var tabIndex: Int
    @ObservedObject var viewModel = UploadPostViewModel()
    
    
    
    // Alert
    @State var showAlert: Bool = false
    @State var postUploadedSuccessfully: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                })
                .accentColor(.primary)
                
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                if let image = postImage{
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200, alignment: .center)
                        .cornerRadius(12)
                        .clipped()
                }
                
                
                TextField("Add your caption here..", text: $captionText)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.white : Color.purple)
                    .cornerRadius(12)
                    .font(.headline)
                    .padding(.horizontal)
                    .autocapitalization(.sentences)
                
                Button(action: {
                    //postPicture()
                    if let image = selectedImage{
                        viewModel.uploadPost(caption: captionText, image: image){_ in
                            captionText = ""
                            postImage = nil
                            tabIndex = 0
                            postUploadedSuccessfully = true
                            showAlert.toggle()
                        }
                    }
                }, label: {
                    Text("Post Picture!".uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == . light ? Color.purple : Color.orange)
                        .cornerRadius(12)
                        .padding(.horizontal)
                })
                .accentColor(colorScheme == .light ? Color.orange : Color.purple)
                
            })
            .alert(isPresented: $showAlert) { () -> Alert in
                getAlert()
            }
            
        })

    }
    
    // MARK: FUNCTIONS
    
//    func postPicture() {
//        print("POST PICTURE TO DATABASE HERE")
//
//        guard let userID = currentUserID, let displayName = currentUserDisplayName else {
//            print("Error getting userID or displayname while posting image")
//            return
//        }
//
//        DataService.instance.uploadPost(image: imageSelected, caption: captionText, displayName: displayName, userID: userID) { (success) in
//            self.postUploadedSuccessfully = success
//            self.showAlert.toggle()
//        }
//    }
    
    func getAlert() -> Alert {
        
        if postUploadedSuccessfully {
            
            return Alert(title: Text("Successfully uploaded post! 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
            
        } else {
            return Alert(title: Text("Error uploading post 😭"))
        }
        
    }
    
}



