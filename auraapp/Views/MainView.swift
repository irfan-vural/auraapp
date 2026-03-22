// MainView.swift
import SwiftUI

struct MainView: View {
    // MainViewViewModel hala duruyor, giriş durumunu takip ediyor
    @State var viewModel = MainViewViewModel()
    
    // Splash Screen'in aktif olup olmadığını takip eden State
    @State private var isShowSplashScreen = true

    var body: some View {
        ZStack {
            // --- 1. ANA UYGULAMA MANTIĞI ---
            if viewModel.showMainApp {
                MainTabView(mainVM: viewModel)
            } else {
                LoginView(mainVM: viewModel)
            }
            
            // --- 2. SPLASH SCREEN (KATMAN OLARAK ÜSTTE) ---
            if isShowSplashScreen {
                SplashScreenView()
                    .transition(.opacity) // Kapanırken tatlı bir fade out efekti
                    .zIndex(1) // Her zaman en üstte kalmasını sağlar
            }
        }
        .onAppear {
            // Uygulama açıldığında Firebase zaten MainViewViewModel'da dinlemeye başlar.
            // Biz sadece 1.5 saniye bekleyip Splash'i söküyoruz.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    self.isShowSplashScreen = false
                }
            }
        }
    }
}
