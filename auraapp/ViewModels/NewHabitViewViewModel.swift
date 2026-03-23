import Foundation
import FirebaseAuth
import FirebaseFirestore
import Observation
import SwiftUI

@Observable
class NewHabitViewViewModel {
    // --- AKIŞ KONTROLÜ ---
    var currentStep = 1
    let totalSteps = 4
    var showAlert = false
    var alertMessage = ""
    
    // --- ADIM 1: TEMEL BİLGİLER ---
    var title = ""
    var selectedIcon = "figure.run"
    var selectedColorHex = "#007AFF"
    
    // --- ADIM 2: HEDEF (GOAL) ---
    var isGoalEnabled = false // Görseldeki "Set a goal" toggle'ı
    var habitType: HabitType = .classic
    var targetValue: Double = 15.0
    var selectedUnit = "min"
    let units = ["min", "times", "pages", "liters", "hours"]
    
    // --- ADIM 3: ALT GÖREVLER (CHECKLIST) ---
    var checklist: [ChecklistItem] = []
    var newChecklistItemTitle = ""
    
    // --- ADIM 4: TEKRAR VE BİLDİRİM ---
    var isCycleEnabled = true
    var repeatCycle = "Daily"
    var isReminderEnabled = false
    var reminderTime = Date()
    
    // Sabit Seçenekler
    let icons = ["figure.run", "dumbbell.fill", "book.fill", "laptopcomputer", "drop.fill", "moon.fill", "brain.head.profile"]
    let colors = ["#FF9500", "#FF2D55", "#AF52DE", "#007AFF", "#34C759", "#FFCC00"]
    
    init() {}
    
    // Adım İlerletme Mantığı
    func nextStep() {
        if currentStep == 1 && title.trimmingCharacters(in: .whitespaces).isEmpty {
            alertMessage = "Lütfen alışkanlığına bir isim ver."
            showAlert = true
            return
        }
        
        if currentStep < totalSteps {
            currentStep += 1
        }
    }
    
    func previousStep() {
        if currentStep > 1 {
            currentStep -= 1
        }
    }
    
    // Checklist'e eleman ekleme
    func addChecklistItem() {
        guard !newChecklistItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let item = ChecklistItem(title: newChecklistItemTitle, isCompleted: false)
        checklist.append(item)
        newChecklistItemTitle = "" // Input'u temizle
    }
    
    // Kaydetme İşlemi (Firebase)
    func save(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let newId = UUID().uuidString
        
        // Eğer hedef açılmadıysa klasik tip sayılır
        let finalType: HabitType = isGoalEnabled ? .counter : .classic
        let finalTarget = isGoalEnabled ? targetValue : 1.0
        let finalUnit = isGoalEnabled ? selectedUnit : ""
        
        let newHabit = Habit(
            id: newId,
            title: title,
            createdAt: Date().timeIntervalSince1970,
            icon: selectedIcon,
            colorHex: selectedColorHex,
            type: finalType,
            goalTargetValue: finalTarget,
            goalUnit: finalUnit,
            todayProgress: 0.0,
            checklist: checklist,
            repeatCycle: isCycleEnabled ? repeatCycle : "None",
            currentStreak: 0,
            longestStreak: 0,
            lastCompletedDate: nil,
            isReminderEnabled: isReminderEnabled,
            reminderTime: isReminderEnabled ? reminderTime.formatted(date: .omitted, time: .shortened) : nil,
            frequency: [1,2,3,4,5,6,7]
        )
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("habits").document(newId)
            .setData(newHabit.asDictionary()) { error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                } else {
                    if self.isReminderEnabled {
                                            // Eğer hatırlatıcı açıksa, kullanıcının seçtiği saate alarm kur!
                                            NotificationManager.shared.scheduleNotification(
                                                for: newId,
                                                title: self.title,
                                                time: self.reminderTime
                                            )
                                        }
                    completion(true)
                }
            }
    }
}
