

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State var show =  false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                
                VStack {
                    Text("Burada Logo olcak")
                        .frame(width: 220, height: 100)
                        .foregroundColor(.white)
                                        
                    VStack(spacing: 20) {
                        CustomTextField(text: $email, placeholder: Text("E-Posta"), imageName: "envelope")
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        CustomSecureField(text: $password, placeholder: Text("Şifre"))
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                                        
                    HStack {
                        Spacer()
                        
                        NavigationLink(
                            destination: ResetPasswordView(email: $email),
                            label: {
                                Text("Şifrenizi mi unuttunuz?")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.top)
                                    .padding(.trailing, 28)
                            })
                    }
                                        
                    Button(action: {
                        viewModel.login(withEmail: email, password: password)
                        if viewModel.userSession == nil{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                show = true
                            }
                        }
                    }, label: {
                        Text("Giriş Yap")
                            .font(.headline)
                            .foregroundColor(email != "" && password != "" ? .white : .gray)
                            .frame(width: 360, height: 50)
                            .background(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                            .clipShape(Capsule())
                            .padding()
                    }).disabled(email != "" && password != "" ? false : true)
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: RegistrationView().navigationBarHidden(true),
                        label: {
                            HStack {
                                Text("Hesabıniz yok mu?")
                                    .font(.system(size: 14))
                                
                                Text("Kayıt Ol")
                                    .font(.system(size: 14, weight: .semibold))
                            }.foregroundColor(.white)
                        }).padding(.bottom, 16)
                }
                .padding(.top, -44)
                .blur(radius: show ? 5 : 0)
                
                
                Text("Tüm alanları doğru dolrudun")
                    .foregroundColor(Color.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(15.0)
                    .opacity(show ? 1 : 0)
                    .animation(.easeInOut)
                    .onTapGesture {
                        show = false
                    }
            }
        }
//        .onAppear{
//            UserDefaults.standard.set(false, forKey: "didLaunchBefore")
//        }
    }
}


