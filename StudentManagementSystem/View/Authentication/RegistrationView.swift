//
//  RegistrationView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/27/20.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var role = ""
    @State private var password = ""
    @State private var city = ""
    @State var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary

    @State private var selectedImage: UIImage?
    @State private var image: Image?
    @State var imagePickerPresented = false
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var makeAble = false
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                    } else {
                        Button(action: {
                                imagePickerPresented.toggle()
                                sourceType = UIImagePickerController.SourceType.photoLibrary }, label: {
                            Image("pic")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .foregroundColor(.white)
                        }).sheet(isPresented: $imagePickerPresented, onDismiss: loadImage, content: {
                            ImagePicker(image: $selectedImage, sourceType: $sourceType)
                        })
                    }
                }
                
                VStack(spacing: 20) {
                    CustomTextField(text: $email, placeholder: Text("Email"), imageName: "envelope")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    CustomTextField(text: $username, placeholder: Text("Username"), imageName: "person.crop.circle.fill")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        
                    CustomTextField(text: $city, placeholder: Text("City"), imageName: "building.2.crop.circle.fill")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
            

                    CustomSecureField(text: $password, placeholder: Text("Password"))
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Section(header:
                                Text("Choose your status")
                                .foregroundColor(Color.orange)
                                .fontWeight(.bold)
                    ) {
                        Picker("Status", selection: $role) {
                            Text("seller")
                                .tag("seller")
                            Text("buyer")
                                .tag("buyer")
                        }.pickerStyle(SegmentedPickerStyle())
                        .accentColor(.orange)
                    }.padding(.bottom, 20)
                }

                
                Button(action: {
                    viewModel.resgister(withEmail: email, password: password, image: selectedImage, username: username, role: role, city: city)
                }, label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 50)
                        .background(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                        .clipShape(Capsule())
                        .padding()
                }).disabled(email != "" && password != "" && username != "" && role != "" && city != "" && image != nil ? false : true)
                
                

                
                Spacer()
                
                Button(action: { mode.wrappedValue.dismiss() }, label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                        
                        Text("Sign In")
                            .font(.system(size: 14, weight: .semibold))
                    }.foregroundColor(.white)
                })
            }
        }.navigationBarHidden(true)
        .onAppear{
            UISegmentedControl.appearance().selectedSegmentTintColor = .orange
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        }
//        .onAppear{
//            UserDefaults.standard.set(false, forKey: "didLaunchBefore")
//        }
    }
}

extension RegistrationView {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        image = Image(uiImage: selectedImage)
    }
}

//struct RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationView()
//    }
//}
