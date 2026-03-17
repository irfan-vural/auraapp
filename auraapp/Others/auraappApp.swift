//
//  auraappApp.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//
import FirebaseCore
import SwiftUI


@main
struct auraappApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("appLanguage") private var appLanguage = "en"
    init(){
        FirebaseApp.configure()
        checkAndSetInitialLanguage()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environment(\.locale, .init(identifier: appLanguage))
        }
    }
    
    private mutating func checkAndSetInitialLanguage() {
            // Kullanıcı daha önce bir dil seçimi yapmış mı kontrol ediyoruz
            // (Eğer UserDefaults'ta bu anahtar yoksa, uygulama ilk kez açılıyor demektir)
            if UserDefaults.standard.string(forKey: "appLanguage") == nil {
                
                // Cihazın mevcut dil kodunu alıyoruz (Örn: "tr", "en", "fr", "de")
                let deviceLanguage = Locale.current.language.languageCode?.identifier ?? "en"
                
                // Eğer cihaz dili Türkçe ("tr") ise uygulamayı Türkçe yap
                if deviceLanguage == "tr" {
                    appLanguage = "tr"
                    UserDefaults.standard.set("tr", forKey: "appLanguage")
                } else {
                    // Türkçe değilse (Fransızca, İspanyolca vs. her şey için) İngilizce yap
                    appLanguage = "en"
                    UserDefaults.standard.set("en", forKey: "appLanguage")
                }
            }
        }
}
