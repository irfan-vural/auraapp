//
//  ProfileViewViewModel.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Observation

@Observable
class ProfileViewViewModel {
    // Şimdilik sadece isim ve mail tutalım, User modelin varsa direkt onu da kullanabilirsin
    var userName = "Loading..."
    var userEmail = ""
    var longestStreak: Int = 0
        var totalHabits: Int = 0
    init() {}
    
    // Kullanıcı bilgilerini Firestore'dan çeken fonksiyon
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else { return }
            
            DispatchQueue.main.async {
                self?.userName = data["name"] as? String ?? "Unknown User"
                self?.userEmail = data["email"] as? String ?? ""
            }
        }
    }
    // Sayfa açıldığında verileri çeken ana fonksiyon
        func fetchProfileData() {
            guard let user = Auth.auth().currentUser else { return }
            
            self.userEmail = user.email ?? "user@aura.com"
            // Eğer isim yoksa, e-postanın @'ten önceki kısmını isim olarak al (Örn: irfan@gmail -> irfan)
            self.userName = user.displayName ?? String(userEmail.split(separator: "@").first ?? "Aura User").capitalized
            
            fetchUserStats(userId: user.uid)
        }
        
        // Bütün alışkanlıkları tarayıp en yüksek seriyi bulur
        private func fetchUserStats(userId: String) {
            let db = Firestore.firestore()
            db.collection("users").document(userId).collection("habits").getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else { return }
                
                // Toplam alışkanlık sayısı
                self?.totalHabits = documents.count
                
                // En yüksek seriyi (Longest Streak) bulma algoritması
                var maxStreak = 0
                for doc in documents {
                    let streak = doc.data()["longestStreak"] as? Int ?? 0
                    if streak > maxStreak {
                        maxStreak = streak
                    }
                }
                
                DispatchQueue.main.async {
                    self?.longestStreak = maxStreak
                }
            }
        }
    // Çıkış Yapma Fonksiyonu
    func logOut() {
        do {
            try Auth.auth().signOut()
            // DİKKAT: Burada ekranı değiştirmek için ekstra kod yazmana gerek yok!
            // MainViewViewModel'daki o yazdığımız listener "Anahtar silindi" diyecek
            // ve saniyesinde seni Login ekranına fırlatacak. Sihir gibi!
        } catch {
            print("Log out error: \(error.localizedDescription)")
        }
    }
}
