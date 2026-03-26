import SwiftUI

// --- 1. VERİ MODELİ ---
// Her bir sayfanın ne göstereceğini tutan yapı
struct OnboardingItem: Identifiable {
    let id = UUID()
    let image: String // SF Symbol adı
    let title: String
    let description: String
    let color: Color
}

struct OnboardingView: View {
    // SİHİRLİ ŞALTER: Bu true olduğunda ekran bir daha asla görünmez
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    // TabView'da hangi sayfada olduğumuzu takip etmek için
    @State private var currentPage = 0
    
    // O bahsettiğimiz 3 harika sayfanın içerikleri
    private let pages: [OnboardingItem] = [
        OnboardingItem(
            image: "sparkles",
            title: "Build Your Aura.",
            description: "Not just an ordinary to-do list. Manage your physical goals, coding sessions, and mental focus from a single hub.",
            color: .blue
        ),
        OnboardingItem(
            image: "flame.fill",
            title: "Keep the Streak Alive.",
            description: "Track your progress, don't break the chain, and get 1% better every day.",
            color: .orange
        ),
        OnboardingItem(
            image: "bell.and.waveform.fill",
            title: "Stay in the Zone.",
            description: "Allow Health access to track your steps automatically, and enable notifications so you never miss a goal.",
            color: .green
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack {
                // --- SAĞ ÜSTTEKİ ATLA (SKIP) BUTONU ---
                HStack {
                    Spacer()
                    Button(action: {
                        finishOnboarding()
                    }) {
                        Text("Skip")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    // Sadece son sayfada değilse Skip butonunu göster
                    .opacity(currentPage == pages.count - 1 ? 0 : 1)
                }
                
                // --- KAYDIRMALI SAYFALAR (TABVIEW) ---
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(item: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always)) // O alttaki 3 noktayı koyar
                .indexViewStyle(.page(backgroundDisplayMode: .always)) // Noktaların arka planı
                
                // --- ALT KISIM: İLERİ / BAŞLA BUTONU ---
                Button(action: {
                    withAnimation(.spring()) {
                        if currentPage < pages.count - 1 {
                            currentPage += 1 // Sonraki sayfaya geç
                        } else {
                            finishOnboarding() // Son sayfadaysa uygulamaya gir
                        }
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Let's Start" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(pages[currentPage].color.gradient) // Sayfaya göre buton rengi değişir
                        .cornerRadius(16)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    // Geçişi tamamlayan fonksiyon
    private func finishOnboarding() {
        withAnimation(.easeOut(duration: 0.3)) {
            hasSeenOnboarding = true
        }
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}

// --- HER BİR SAYFANIN İÇ TASARIMI ---
struct OnboardingPageView: View {
    let item: OnboardingItem
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Havalı İkon
            Image(systemName: item.image)
                .font(.system(size: 80))
                .foregroundColor(item.color)
                .frame(width: 150, height: 150)
                .background(item.color.opacity(0.1))
                .clipShape(Circle())
            
            // Başlık
            Text(item.title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
            
            // Alt Metin
            Text(item.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            Spacer() // Butona yer bırakmak için ekstra spacer
        }
    }
}

#Preview {
    OnboardingView()
}
