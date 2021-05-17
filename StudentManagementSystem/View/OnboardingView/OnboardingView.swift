

import SwiftUI

struct OnboardingView: View {
    
  //var hehe = ["ÇğçşıİŞüÖö"]
  
  var onboardingData: [OnboardingItem] = [
    OnboardingItem(imageName: "1", title: "Doğal ürün üreticisiyim", description: "O zaman öncelikle kayıt sayfasında `üretici` bölmesini seç ve üretim yaptığın `şehri` belirt. Peynir, süt, reçel, yoğurt, kefir, salça, turşu, zeytin, bal, zeytinyağı gibi ürünlerin yaninda, ev yemekleri üreticilerinin ürünleri de uygulama kapsamına dahildir."),
    OnboardingItem(imageName: "2", title: "Kendimi nasıl gösteririm?", description: "Profil sayfanı detaylı olarak doldur ve yaptığın harika urunleri resimlerle paylaş. Unutma, güzel resimler çekmek işin sadece gösteriş kısmı. Yaptıklarının kalitesi ve prensipli çalışma ilkelerin tüketicilerden alacağın puanı belileyecek"),
    OnboardingItem(imageName: "3", title: "Doğal beslenmeliyim!", description: "Kendin ve ailen için en sağlıklı yolu seçtin! Kar etmeyi iş etiğinin önüne koyan dev işletmelerin sunduğu tehlikeli paketli gıdalardan sakınmak herkes için bir seçenek olmalı. İşte bu seçenek artık parmaklarının ucunda."),
    OnboardingItem(imageName: "4", title: "Üreticilere nasıl ulaşırım?", description: "Kayıt sayfasında `tüketici` bölmesini seç ve yaşadiğin `şehri` belirt. Uygulamaya girince keşfet bölmesinden isim veya şehir bazlı arama yapabilirsin. Üreticileri takip etmeye başladıkça uygulamanın ana ekranı leziz ürünlerle dolacak!")
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
                          Text("HAYDİ BAŞLAYALIM!")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(Color("kucukmor"))
                            .background(LinearGradient(gradient: Gradient(colors: [Color("arkaplan"), Color("kahve")]), startPoint: .leading, endPoint: .trailing))
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
  @State private var isAnimating: Bool = false

  
  var body: some View {
    GeometryReader { proxy -> AnyView in
        let minX = proxy.frame(in: .global).minX
        let width = UIScreen.main.bounds.width
        let progress = -minX / (width*2)
        var scale = progress > 0 ? 1 - progress : 1 + progress
        scale = scale < 0.7 ? 0.7 : scale
        
      return AnyView(
        VStack {
          Image(onboardingItem.imageName)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: 400)

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
        }.scaleEffect(scale)
      )
    }
  }
}

