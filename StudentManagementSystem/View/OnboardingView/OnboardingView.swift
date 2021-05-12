

import SwiftUI

struct OnboardingView: View {
  
  var onboardingData: [OnboardingItem] = [
    OnboardingItem(imageName: "1", title: "Dogal urun ureticisiyim", description: "O zaman oncelikle kayit sayfasinda `uretici` bolmesini sec ve uretim yaptigin `sehri` belirt. Peynir, sut, recel, yogurt, kefir, salca, tursu, zeytin, zeytinyagi gibi urunlerin yaninda, ev yemekleri ureticilerinin urunleri de uygulama kapsamina dahildir."),
    OnboardingItem(imageName: "2", title: "Kendimi nasil gosteririm?", description: "Profil sayfani detayli olarak doldur ve yaptigin harika urunleri resimlerle paylas. Unutma, guzel resimler cekmek isin sadece gosteris kismi. Yaptiklarinin kalitesi ve prensipli calisma ilkelerin tuketicilerden alacagin puani belileyecek"),
    OnboardingItem(imageName: "3", title: "Dogal beslenmeliyim!", description: "Kendin ve ailen icin en saglikli yolu sectin! Kar etmeyi is etiginin onun ekoyan dev isletmelerin sundugu tehlikeli paketli gidalardan sakinmak herkes icin bir secenek olmali. Iste bu secenek artik parmaklarinizin ucunda."),
    OnboardingItem(imageName: "4", title: "Ureticilere nasil ulasirim?", description: "Kayit sayfasinda `tuketici` bolmesini sec ve yasadigin `sehri` belirt. Uygulamaya girince kesfet bolmesinden isim veya sehir bazli arama yapabilirsin. Ureticileri takip etmeye basladikca uygulamanin ana ekrani leziz urunlerle dolacak!")
  ]
  
  var body: some View {
    NavigationView {
        VStack {
          TabView {
            ForEach(0 ..< onboardingData.count) { index in
              let element = onboardingData[index]
              OnboardingCard(onboardingItem: element)
                if index == onboardingData.count - 1{
                    NavigationLink(
                      destination: RegistrationView(),
                      label: {
                          Text("GET STARTED")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .padding(20)
                      })
                }
            }
          }
          .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
          .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
          

          
        }
    }.onAppear{
        UserDefaults.standard.set(true, forKey: "didLaunchBefore")
    }
  }
}



fileprivate struct OnboardingCard: View {
  let onboardingItem: OnboardingItem
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Image(onboardingItem.imageName)
          .resizable()
          .frame(height: geometry.size.height / 1.7)
          .frame(maxWidth: .infinity)
        Text(onboardingItem.title)
          .font(.title)
          .foregroundColor(.primary)
          .bold()
          .padding()
        Text(onboardingItem.description)
          .multilineTextAlignment(.center)
          .font(.body)
          .foregroundColor(.primary)
          .padding(.horizontal, 15)
      }
    }
  }
}

