

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
    @State var show = false
    @State var showProgress: Bool = false

    
    init() {
        //this changes the "thumb" that selects between items
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        //and this changes the color for the whole "bar" background
        UISegmentedControl.appearance().backgroundColor = .purple

        //this will change the font size
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .largeTitle)], for: .normal)

        //these lines change the text color for various states
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
    }
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("arkaplan"), Color("krem")]), startPoint: .top, endPoint: .bottom)
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
                                .foregroundColor(.black)
                        }).sheet(isPresented: $imagePickerPresented, onDismiss: loadImage, content: {
                            ImagePicker(image: $selectedImage, sourceType: $sourceType)
                        })
                    }
                }
                
                VStack(spacing: 20) {
                    CustomTextField(text: $email, placeholder: Text("E-Posta"), imageName: "envelope")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    CustomTextField(text: $username, placeholder: Text("Kullan??c?? Ad??"), imageName: "person.crop.circle.fill")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        
                    CustomTextField(text: $city, placeholder: Text("??ehir"), imageName: "building.2.crop.circle.fill")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
            

                    CustomSecureField(text: $password, placeholder: Text("??ifre(En az 6 karakter)"))
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Picker(selection: $role, label:
                            HStack{
                                Text("Rol??n??z?? Se??iniz: ")
                                Text(role)
                            }.font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .padding(.horizontal)
                            .background(Color("kahve"))
                            .cornerRadius(10)
                           ,
                           content: {
                        Text("??retici").tag("??retici")
                        Text("t??ketici").tag("t??ketici")
                           }).pickerStyle(MenuPickerStyle())
                }

                
                Button(action: {
                    viewModel.resgister(withEmail: email, password: password, image: selectedImage, username: username, role: role, city: city)
                    showProgress = true
                    
                }, label: {
                    Text("Kay??t Ol")
                        .font(.headline)
                        .foregroundColor(email != "" && password != "" && username != "" && role != "" && city != "" && image != nil ? .black : .white)
                        .frame(width: 360, height: 50)
                        .background(Color("kahve"))
                        .clipShape(Capsule())
                        .padding()
                }).disabled(email != "" && password != "" && username != "" && role != "" && city != "" && image != nil ? false : true)
                
                if showProgress{
                    ProgressView()
                }
                
                Spacer()
                
                Button(action: { mode.wrappedValue.dismiss() }, label: {
                    HStack {
                        Text("Hesab??niz var m???")
                            .font(.system(size: 14))
                        
                        Text("Giri?? Yap")
                            .font(.system(size: 14, weight: .semibold))
                    }.foregroundColor(.black)
                })
                
                
            }.blur(radius: viewModel.show ? 5 : 0)

            Text("T??m alanlar?? do??ru doldurun")
                .foregroundColor(Color.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15.0)
                .opacity(viewModel.show ? 1 : 0)
                .animation(.easeInOut)
                
            
        }.navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
            viewModel.show = false
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


