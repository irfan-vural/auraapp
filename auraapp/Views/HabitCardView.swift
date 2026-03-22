import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HabitCardView: View {
    let habit: Habit
    
    // Kullanıcının o an basılı tutup tutmadığını anlıyoruz
    @State private var isPressing: Bool = false
    
    // 1. SİHİRLİ DOKUNUŞ: Artık yerel bir değişken değil, direkt Firebase'deki tarihi okuyoruz!
    var isCompleted: Bool {
        guard let lastDate = habit.lastCompletedDate else { return false }
        let date = Date(timeIntervalSince1970: lastDate)
        return Calendar.current.isDateInToday(date)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // --- İKON ---
            Image(systemName: habit.icon)
                .font(.title2)
                .foregroundColor(isCompleted ? .white : .gray)
                .frame(width: 50, height: 50)
                .background(isCompleted ? Color.white.opacity(0.2) : Color(.systemGray5))
                .clipShape(Circle())
            
            // --- BAŞLIK ---
            Text(habit.title)
                .font(.headline)
                .foregroundColor(isCompleted ? .white : .primary)
                .strikethrough(isCompleted, color: .white.opacity(0.5))
            
            Spacer()
            
            // --- STREAK (ALEV) BÖLÜMÜ ---
            if habit.currentStreak > 0 || isCompleted {
                HStack(spacing: 4) {
                    // 2. ALEV RENGİ DÜZELTİLDİ: Arka plan ne olursa olsun ateş renginde kalacak!
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    
                    Text("\(habit.currentStreak)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(isCompleted ? .white : .orange)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                // Tamamlandıysa yarı saydam beyaz, değilse hafif turuncu bir hap görünümü
                .background(isCompleted ? Color.white.opacity(0.25) : Color.orange.opacity(0.15))
                .cornerRadius(10)
            }
        }
        .padding()
        // 3. ARKA PLAN RENGİ: Tamamlandığında kullanıcının seçtiği Hex rengini kullanıyoruz!
        .background(isCompleted ? Color(hex: habit.colorHex) : Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .scaleEffect(isPressing ? 0.95 : 1.0)
        .shadow(color: isCompleted ? Color(hex: habit.colorHex).opacity(0.3) : Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        
        // --- UZUN BASMA (LONG PRESS) ---
        .onLongPressGesture(minimumDuration: 0.8, maximumDistance: 50) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                // Sadece görseli değil, veritabanını da güncelliyoruz
                toggleHabitState()
                
                let impact = UIImpactFeedbackGenerator(style: .rigid)
                impact.impactOccurred()
            }
        } onPressingChanged: { pressing in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.isPressing = pressing
            }
        }
    }
    
    // --- 4. FIREBASE GÜNCELLEME MOTORU ---
    private func toggleHabitState() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let habitRef = db.collection("users").document(userId).collection("habits").document(habit.id)
        
        var newStreak = habit.currentStreak
        var newDate: TimeInterval? = habit.lastCompletedDate
        var newLongest = habit.longestStreak
        
        if isCompleted {
            // YANLIŞLIKLA BASTIYSA GERİ ALMA (UNDO):
            newStreak = max(0, newStreak - 1)
            // Streak tamamen kopmasın diye tarihi düne çekiyoruz
            newDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())?.timeIntervalSince1970
        } else {
            // GÖREVİ TAMAMLAMA:
            newStreak += 1
            newDate = Date().timeIntervalSince1970
            
            if newStreak > newLongest {
                newLongest = newStreak
            }
        }
        
        // Firestore'a yeni verileri fırlatıyoruz
        habitRef.updateData([
            "currentStreak": newStreak,
            "lastCompletedDate": newDate as Any,
            "longestStreak": newLongest
        ]) { error in
            if let error = error {
                print("Streak güncellenirken hata oluştu: \(error.localizedDescription)")
            }
        }
    }
}
