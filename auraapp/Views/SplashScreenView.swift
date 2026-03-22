// SplashScreenView.swift
import SwiftUI

struct SplashScreenView: View {
    // Animasyonların başlaması için State değişkenleri
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.5
    
    var body: some View {
        ZStack {
            // --- 1. ARKA PLAN GRADYANI (Assets'teki görsel) ---
            Image("AuraGradientBackground")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
            
            // --- 2. LOGO VE METİN BÖLÜMÜ ---
            VStack(spacing: 15) {
                // Parıldayan ve Büyüyen Logo (SF Symbol veya Assets'teki görsel)
                Image("aura-logo") // Eğer ikon SF Symbol ise Image(systemName: "number") kullanabilirsin
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    // Logoya o parıltı hissini veren ZStack
                    .overlay(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 140, height: 140)
                            .blur(radius: 10)
                    )
                    // Animasyon modifiyerleri
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                VStack(spacing: 4) {
                    Text("AURA")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Your Daily Focus")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .opacity(isActive ? 1.0 : 0.0) // Metinler sonradan belirsin
            }
        }
        .onAppear {
            // Sayfa ekrana geldiği an animasyon zincirini başlat
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                self.logoScale = 1.0
                self.logoOpacity = 1.0
            }
            
            withAnimation(.easeIn(duration: 0.5).delay(0.6)) {
                self.isActive = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
