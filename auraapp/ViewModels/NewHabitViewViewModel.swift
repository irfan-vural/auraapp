//
//  NewItemViewViewModel.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Observation

@Observable
class NewHabitViewViewModel {
    var title = ""
    var selectedIcon = "dumbbell.fill" // Varsayılan ikon
    var selectedColorHex = "#FF9500" // Varsayılan renk (Turuncu)
    
    var showAlert = false
    var alertMessage = ""
    
    // Kullanıcının seçebileceği ikonlar listesi
    let icons = [
        "dumbbell.fill", "figure.run", "figure.indoor.soccer", // Fitness & Spor
        "book.fill", "laptopcomputer", "brain.head.profile", // Çalışma & Odak
        "drop.fill", "moon.fill", "flame.fill", "heart.fill" // Sağlık & Genel
    ]
    
    // Kullanıcının seçebileceği Aura renk paleti
    let colors = [
        "#FF9500", // Turuncu
        "#FF2D55", // Pembe
        "#AF52DE", // Mor
        "#007AFF", // Mavi
        "#34C759", // Yeşil
        "#FFCC00"  // Sarı
    ]
    
    init() {}
    
    func save(completion: @escaping (Bool) -> Void) {
        guard canSave else {
            completion(false)
            return
        }
        
        // 1. Kullanıcıyı bul
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // 2. Yeni alışkanlık modelini oluştur (İleride eklenecek özellikleri şimdilik varsayılan yapıyoruz)
        let newId = UUID().uuidString
        let newHabit = Habit(
            id: newId,
            title: title,
            createdAt: Date().timeIntervalSince1970,
            icon: selectedIcon,
            colorHex: selectedColorHex,
            currentStreak: 0,
            longestStreak: 0,
            lastCompletedDate: nil,
            isReminderEnabled: false,
            reminderTime: nil,
            frequency: [1,2,3,4,5,6,7] // Her gün
        )
        
        // 3. Veritabanına kaydet
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("habits")
            .document(newId)
            .setData(newHabit.asDictionary()) { error in
                if let error = error {
                    print("Error saving habit: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true) // Başarılı!
                }
            }
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter a habit name."
            showAlert = true
            return false
        }
        return true
    }
}
