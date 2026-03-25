//
//  ProfileView.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//
import SwiftUI

struct ProfileView: View {
    @State var viewModel = ProfileViewViewModel()
    @State private var showingLogoutConfirmation = false
    // Uygulama içi ayarları cihazda tutmak için (Dark Mode vb.)
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("appLanguage") private var appLanguage = "en" // Varsayılan İngilizce ("en")
    @State private var selectedLanguage = "English"
    let languages = ["English", "Türkçe"]
    
    private var userInitials: String {
        guard let firstChar = viewModel.userName.first else { return "A" }
        return String(firstChar).uppercased()
    }
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 12) {
                        // Profil Avatarı
                        Text(userInitials)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue.gradient) // Çok şık bir gradyan mavi
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.userName)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(viewModel.userEmail)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // --- 2. İSTATİSTİK PANOSU (STATS BOARD) ---
                Section(header: Text("Your Aura Stats")) {
                    HStack(spacing: 0) {
                        // Küçültülmüş İstatistik Elemanları
                        CompactStatItem(icon: "list.bullet.clipboard.fill", color: .green, title: "Habits", value: "\(viewModel.totalHabits)")
                        
                        // Daha ince ve kısa Divider
                        Rectangle()
                            .fill(Color(.systemGray4))
                            .frame(width: 1, height: 30)
                            .padding(.horizontal, 10)
                        
                        CompactStatItem(icon: "flame.fill", color: .orange, title: "Streak", value: "\(viewModel.longestStreak)")
                    }
                    .padding(.vertical, 4) // Dikey boşluk azaltıldı
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    
                }
                Section(header: Text("System Settings")) {
                    // Tema Değiştirici
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                    
                    // Dil Seçici
                    Picker(selection: $appLanguage, label: Label("Language", systemImage: "globe")) {
                        Text("English").tag("en")
                        Text("Türkçe").tag("tr")
                    }
                }
                
                
                // --- 3. APP STORE VE DESTEK LİNKLERİ ---
                Section(header: Text("Support & Feedback")) {
                    // Uygulamayı Değerlendir (Daha sonra Apple'ın StoreKit'ine bağlayacağız)
                    Button(action: { /* Rate App action */ }) {
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Text("Rate Aura").foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray).font(.caption)
                        }
                    }
                    
                    // Bize Ulaşın (Mail açtıracağız)
                    Button(action: { /* Contact action */ }) {
                        HStack {
                            Image(systemName: "envelope.fill").foregroundColor(.blue)
                            Text("Contact Support").foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray).font(.caption)
                        }
                    }
                    
                    // Gizlilik Politikası (Linke gidecek)
                    Button(action: { /* Privacy Policy action */ }) {
                        HStack {
                            Image(systemName: "lock.shield.fill").foregroundColor(.green)
                            Text("Privacy Policy").foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray).font(.caption)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        // Direkt çıkış yapmak yerine uyarı penceresini tetikliyoruz
                        showingLogoutConfirmation = true
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
                // Seksiyonun hemen bittiği yere (veya butonun altına) bu modifiyeri ekliyoruz:
                .confirmationDialog("Are you sure you want to sign out?", isPresented: $showingLogoutConfirmation, titleVisibility: .visible) {
                    
                    // Yıkıcı (Destructive) buton: Rengi otomatik kırmızı olur ve asıl çıkış işlemini yapar
                    Button("Sign Out", role: .destructive) {
                        viewModel.logOut()
                    }
                    
                    // İptal butonu: Menüyü kapatır
                    Button("Cancel", role: .cancel) { }
                }
                // --- 5. UYGULAMA VERSİYONU (SİLİK YAZI) ---
                VStack {
                    Text("Aura: Daily Routine & Focus")
                        .fontWeight(.semibold)
                    Text(appVersion)
                }
                .font(.footnote)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear) // Arka planı şeffaf yapar, Form'a yapışmaz
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchProfileData() // Sayfa açılınca verileri getir
            }
        }
    }
    
    
    
    struct CompactStatItem: View {
        let icon: String
        let color: Color
        let title: String
        let value: String
        
        var body: some View {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.footnote) // İkon küçültüldü
                    .foregroundColor(color)
                
                Text(value)
                    .font(.headline) // Sayı emphasized ama küçültüldü
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.footnote) // Yazı küçültüldü
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .center) // HStack içinde eşit alan
        }
    }
}
#Preview {
    ProfileView()
}
