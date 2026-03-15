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
