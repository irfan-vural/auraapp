//
//  TodoListViewViewModel.swift
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
    var selectedHabit: Habit? = nil

    private let db = Firestore.firestore()
    
    init() {}
    
    
    // SİHİRLİ SÜZGEÇ: Gün dönümlerini ve kırılan serileri kontrol eder
        private func checkAndResetDailyGoals(habits: [Habit]) {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            let calendar = Calendar.current
            
            for habit in habits {
                // Sadece günlük (Daily) görevleri denetle
                guard habit.repeatCycle == "Daily" else { continue }
                
                var updates: [String: Any] = [:]
                // Eğer daha hiç yapılmamışsa, çok eski bir tarih varsay
                let lastDate = habit.lastCompletedDate.map { Date(timeIntervalSince1970: $0) } ?? Date.distantPast
                // KURAL 1: Eğer son yapılma tarihi "Bugün" değilse, bugünün ilerlemesini (progress) sıfırla
                if !calendar.isDateInToday(lastDate) && habit.todayProgress > 0 {
                    updates["todayProgress"] = 0
                }
                
                // KURAL 2: Eğer "Bugün" de yapılmadı, "Dün" de yapılmadıysa seri BOZULMUŞTUR!
                if !calendar.isDateInToday(lastDate) && !calendar.isDateInYesterday(lastDate) && habit.currentStreak > 0 {
                    updates["currentStreak"] = 0
                }
                
                // Eğer yapılacak bir güncelleme varsa Firebase'e yaz
                if !updates.isEmpty {
                    db.collection("users").document(userId).collection("habits").document(habit.id)
                        .updateData(updates)
                }
            }
        }
    // Firebase'i anlık dinleyen sihirli fonksiyon
    func fetchHabits() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Kullanıcının alt koleksiyonundaki habits dosyasına gidiyoruz
        db.collection("users").document(userId).collection("habits")
            .order(by: "createdAt", descending: false) // Eskiden yeniye sırala
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else { return }
                let fetchedHabits = documents.compactMap { try? $0.data(as: Habit.self) }
                self?.checkAndResetDailyGoals(habits: fetchedHabits)
                                
                DispatchQueue.main.async {
                self?.habits = fetchedHabits
                }
                
                // Gelen karmaşık JSON verisini bizim o zengin Habit modeline dönüştürüyoruz
                self?.habits = documents.compactMap { doc in
                    let data = doc.data()
                    
                    // --- 1. TİP DÖNÜŞÜMÜ (Enum Güvenliği) ---
                    let typeRaw = data["type"] as? String ?? HabitType.classic.rawValue
                    let habitType = HabitType(rawValue: typeRaw) ?? .classic
                    
                    // --- 2. ALT GÖREVLER DÖNÜŞÜMÜ (Array of Dictionary -> Array of Struct) ---
                    var checklistItems: [ChecklistItem] = []
                    if let checklistData = data["checklist"] as? [[String: Any]] {
                        checklistItems = checklistData.compactMap { itemData in
                            return ChecklistItem(
                                id: itemData["id"] as? String ?? UUID().uuidString,
                                title: itemData["title"] as? String ?? "",
                                isCompleted: itemData["isCompleted"] as? Bool ?? false
                            )
                        }
                    }
                    
                    return Habit(
                        id: data["id"] as? String ?? "",
                        title: data["title"] as? String ?? "",
                        createdAt: data["createdAt"] as? TimeInterval ?? 0,
                        icon: data["icon"] as? String ?? "star.fill",
                        colorHex: data["colorHex"] as? String ?? "#3498db",
                        
                        // --- YENİ EKLENEN KOMPLEKS ALANLAR ---
                        type: habitType,
                        goalTargetValue: data["goalTargetValue"] as? Double ?? 1.0,
                        goalUnit: data["goalUnit"] as? String ?? "",
                        todayProgress: data["todayProgress"] as? Double ?? 0.0,
                        checklist: checklistItems,
                        repeatCycle: data["repeatCycle"] as? String ?? "Daily",
                        // ------------------------------------
                        
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
