import SwiftUI

struct EditBio: View {
    @EnvironmentObject var model: AuthViewModel
    @Environment(\.presentationMode) var mode
    
    @ObservedObject var viewModel: ProfileViewModel
    
    @Binding var bioText: String
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { mode.wrappedValue.dismiss() }, label: {
                    Text("İptal")
                }).buttonStyle(AppButtonStyle2())

                
                Spacer()
                
                Button(action: {
                    viewModel.saveUserBio(bioText)
                    mode.wrappedValue.dismiss()
                }, label: {
                    Text("Kabul").bold()
                }).buttonStyle(AppButtonStyle())

            }.padding()
            
            TextArea(text: $bioText, placeholder: "Bilgi Ekleyin...")
                .frame(width: 370, height: 200)
                .padding()
                .background(Color("arkaplan"))
            
            Spacer()
            
            GeometryReader { geometry in
              ZStack {
                AnimatedWave(width: geometry.size.width,
                             heightStartingPoint: geometry.size.height / 2 + 150, heightEndingPoint: geometry.size.height)
                  .foregroundColor(Color("arkaplan"))
                
                AnimatedWave(width: geometry.size.width * 1.2,
                             heightStartingPoint: geometry.size.height / 2 + 150, heightEndingPoint: geometry.size.height,
                             waveAmplitude: 150,
                             animationDuration: 12)
                  .foregroundColor(Color("kucukmor"))
                
                AnimatedWave(width: geometry.size.width * 2,
                             heightStartingPoint: geometry.size.height / 2 + 150, heightEndingPoint: geometry.size.height,
                             waveAmplitude: 200,
                             animationDuration: 10)
                  .foregroundColor(Color("kahve"))
              }
            }
            .ignoresSafeArea(.all)
          }
    }
}


