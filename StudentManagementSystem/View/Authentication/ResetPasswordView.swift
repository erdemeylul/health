
import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var mode
    @Binding private var email: String
    
    init(email: Binding<String>) {
        self._email = email
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Image("bg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 100)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                                    
                VStack(spacing: 20) {
                    CustomTextField(text: $email, placeholder: Text("E-Posta"), imageName: "envelope")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                }
                                    
                Button(action: {
                    viewModel.resetPassword(withEmail: email)
                    
                }, label: {
                    Text("Şifreyi sıfırla")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 50)
                        .background(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                        .clipShape(Capsule())
                        .padding()
                })
                
                
                Spacer()
                
                Button(action: { mode.wrappedValue.dismiss() }, label: {
                    HStack {
                        Text("Hesabıniz var mı?")
                            .font(.system(size: 14))
                        
                        Text("Giriş Yap")
                            .font(.system(size: 14, weight: .semibold))
                    }.foregroundColor(.white)
                })
            }
            .padding(.top, -44)
        }.blur(radius: viewModel.show ? 5 : 0)
        
        Text("E-posta alanını doğru doldurun")
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
            .opacity(viewModel.show ? 1 : 0)
            .animation(.easeInOut)
            .onTapGesture {
                viewModel.show = false
            }

        .onReceive(viewModel.$didSendResetPasswordLink, perform: { _ in
            self.mode.wrappedValue.dismiss()
        })
    }
}
