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
            
            Spacer()
        }
      
    }
}


