//
//  ProfileView.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//
import SwiftUI

struct ProfileView: View {
    @State var viewModel = ProfileViewViewModel()
    
    // Uygulama içi ayarları cihazda tutmak için (Dark Mode vb.)
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var selectedLanguage = "English"
    let languages = ["English", "Türkçe"]

    var body: some View {
        NavigationStack {
            List {
                // --- 1. KULLANICI BİLGİLERİ ---
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.userName)
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Text(viewModel.userEmail)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // --- 2. SİSTEM AYARLARI ---
                Section(header: Text("System Settings")) {
                    // Tema Değiştirici
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    
                    // Dil Seçici
                    Picker(selection: $selectedLanguage, label: Label("Language", systemImage: "globe")) {
                        ForEach(languages, id: \.self) { lang in
                            Text(lang).tag(lang)
                        }
                    }
                }
                
                // --- 3. DESTEK VE GERİ BİLDİRİM ---
                Section(header: Text("About & Support")) {
                    Button(action: {
                        // TODO: App Store linkine (requestReview) yönlendirilecek
                        print("App Store'a yönlendiriliyor...")
                    }) {
                        Label("Rate the App", systemImage: "star.fill")
                            .foregroundColor(.primary)
                    }
                }
                // --- 4. ÇIKIŞ YAP ---
                Section {
                    Button(action: {
                        viewModel.logOut()
                    }) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                // Ekran yüklendiği an veritabanından kullanıcı verisini çek
                viewModel.fetchUser()
            }
        }
    }
}

#Preview {
    ProfileView()
}
