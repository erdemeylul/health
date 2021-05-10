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
                    Text("Cancel")
                })
                
                Spacer()
                
                Button(action: {
                    viewModel.saveUserBio(bioText)
                    mode.wrappedValue.dismiss()
                }, label: {
                    Text("Done").bold()
                })
            }.padding()
            
            TextArea(text: $bioText, placeholder: "Add your bio..")
                .frame(width: 370, height: 200)
                .padding()
                .background(Color.purple.opacity(0.25))
            
            Spacer()
            
            GeometryReader { geometry in
              ZStack {
                AnimatedWave(width: geometry.size.width,
                             heightStartingPoint: geometry.size.height / 2 + 150, heightEndingPoint: geometry.size.height)
                  .foregroundColor(Color.purple.opacity(0.3))
                
                AnimatedWave(width: geometry.size.width * 1.2,
                             heightStartingPoint: geometry.size.height / 2 + 150, heightEndingPoint: geometry.size.height,
                             waveAmplitude: 150,
                             animationDuration: 12)
                  .foregroundColor(Color.pink.opacity(0.4))
                
                AnimatedWave(width: geometry.size.width * 2,
                             heightStartingPoint: geometry.size.height / 2 + 150, heightEndingPoint: geometry.size.height,
                             waveAmplitude: 200,
                             animationDuration: 10)
                  .foregroundColor(Color.blue.opacity(0.4))
              }
            }
            .ignoresSafeArea(.all)
          }
    }
}


