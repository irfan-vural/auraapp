import Foundation
import FirebaseFirestore
import FirebaseAuth
import Observation

@Observable
class HabitDetailViewViewModel {
    var habit: Habit
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    // --- CHECKLIST GÜNCELLEME ---
    func toggleChecklistItem(id: String) {
        if let index = habit.checklist.firstIndex(where: { $0.id == id }) {
            habit.checklist[index].isCompleted.toggle()
            saveChanges() // Checklist değiştiğinde anında kaydet
        }
    }
    
    // --- SAYAÇ/SLIDER GÜNCELLEME ---
    func updateProgress(to newValue: Double) {
        habit.todayProgress = min(max(newValue, 0), habit.goalTargetValue)
        
        // Eğer hedef tamamlama noktasına ulaştıysa streak'i güncelle
        if habit.todayProgress >= habit.goalTargetValue {
            completeHabit()
        } else if habit.todayProgress < habit.goalTargetValue && isCompletedToday {
            undoCompletion()
        }
    }
    
    // Hedef artırma/azaltma butonları (+ ve - için)
    func adjustProgress(by value: Double) {
        updateProgress(to: habit.todayProgress + value)
        saveChanges()
    }
    
    // --- FIREBASE KAYIT İŞLEMLERİ ---
    func saveChanges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).collection("habits").document(habit.id)
            .updateData(habit.asDictionary()) { error in
                if let error = error {
                    print("Güncelleme hatası: \(error.localizedDescription)")
                }
            }
    }
    
    func deleteHabit(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).collection("habits").document(habit.id)
            .delete { error in
                completion(error == nil)
            }
    }
    
    // --- STREAK VE DURUM KONTROLLERİ ---
    var isCompletedToday: Bool {
        guard let lastDate = habit.lastCompletedDate else { return false }
        return Calendar.current.isDateInToday(Date(timeIntervalSince1970: lastDate))
    }
    
    private func completeHabit() {
        if !isCompletedToday {
            habit.currentStreak += 1
            habit.lastCompletedDate = Date().timeIntervalSince1970
            if habit.currentStreak > habit.longestStreak {
                habit.longestStreak = habit.currentStreak
            }
        }
    }
    
    private func undoCompletion() {
        if isCompletedToday {
            habit.currentStreak = max(0, habit.currentStreak - 1)
            habit.lastCompletedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())?.timeIntervalSince1970
        }
    }
}   
