//
//  TodoListViewVİewModel.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Observation

@Observable
class TodoListViewViewModel {
    var habits: [Habit] = [] // Ekranda listelenecek alışkanlıklar dizisi
    var isShowingAddHabitView = false // Yeni ekle sayfasını açıp kapatan şalter
    
    private let db = Firestore.firestore()
    
    init() {}
    
    // Firebase'i anlık dinleyen sihirli fonksiyon
    func fetchHabits() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Kullanıcının alt koleksiyonundaki habits dosyasına gidiyoruz
        db.collection("users").document(userId).collection("habits")
            .order(by: "createdAt", descending: false) // Eskiden yeniye sırala
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else { return }
                
                // Gelen karmaşık JSON verisini bizim o şık Habit modeline dönüştürüyoruz
                self?.habits = documents.compactMap { doc in
                    let data = doc.data()
                    return Habit(
                        id: data["id"] as? String ?? "",
                        title: data["title"] as? String ?? "",
                        createdAt: data["createdAt"] as? TimeInterval ?? 0,
                        icon: data["icon"] as? String ?? "star.fill",
                        colorHex: data["colorHex"] as? String ?? "#3498db",
                        currentStreak: data["currentStreak"] as? Int ?? 0,
                        longestStreak: data["longestStreak"] as? Int ?? 0,
                        lastCompletedDate: data["lastCompletedDate"] as? TimeInterval,
                        isReminderEnabled: data["isReminderEnabled"] as? Bool ?? false,
                        reminderTime: data["reminderTime"] as? String,
                        frequency: data["frequency"] as? [Int] ?? []
                    )
                }
            }
    }
}
