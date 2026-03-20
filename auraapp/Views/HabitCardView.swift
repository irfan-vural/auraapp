import SwiftUI

struct HabitCardView: View {
    let habit: Habit
    
    // Şimdilik test için State kullanıyoruz,
    // ileride bunu Firebase'deki tarihe göre (Bugün yapılmış mı?) hesaplayacağız.
    @State private var isCompleted: Bool = false
    
    // Kullanıcının o an ekrana basılı tutup tutmadığını anlıyoruz (Animasyon için)
    @State private var isPressing: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // --- 1. İKON ---
            Image(systemName: habit.icon)
                .font(.title2)
                .foregroundColor(isCompleted ? .white : .gray)
                .frame(width: 50, height: 50)
                .background(isCompleted ? Color.white.opacity(0.2) : Color(.systemGray5))
                .clipShape(Circle())
            
            // --- 2. BAŞLIK ---
            Text(habit.title)
                .font(.headline)
                .foregroundColor(isCompleted ? .white : .primary)
                // Yapıldıysa üstünü çizme efekti (İsteğe bağlı, Aura'nın sadeliğine uyar)
                .strikethrough(isCompleted, color: .white.opacity(0.5))
            
            Spacer()
            
            // --- 3. STREAK (ALEV) BÖLÜMÜ ---
            if habit.currentStreak > 0 || isCompleted {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(isCompleted ? .white : .orange)
                    
                    // Eğer bugün tamamlandıysa streak'i +1 göster, yoksa olanı göster
                    Text("\(isCompleted ? habit.currentStreak + 1 : habit.currentStreak)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(isCompleted ? .white : .orange)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isCompleted ? Color.white.opacity(0.2) : Color.orange.opacity(0.15))
                .cornerRadius(10)
            }
        }
        .padding()
        // KARTIN ARKA PLANI: Tamamlandıysa canlı renk (test için mavi), değilse soluk gri
        .background(isCompleted ? Color.blue : Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        // Basılı tutarken kart hafifçe küçülür (Sihirli dokunuş!)
        .scaleEffect(isPressing ? 0.95 : 1.0)
        .shadow(color: isCompleted ? Color.blue.opacity(0.3) : Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        
        // --- UZUN BASMA (LONG PRESS) ETKİLEŞİMİ ---
        .onLongPressGesture(minimumDuration: 0.8, maximumDistance: 50) {
            // 0.8 saniye dolduğunda çalışacak kod (Görevi Tamamlama)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isCompleted.toggle() // Durumu değiştir
                
                // Telefonu hafifçe titret (Haptic Feedback) - Sadece gerçek cihazda çalışır
                let impact = UIImpactFeedbackGenerator(style: .rigid)
                impact.impactOccurred()
            }
        } onPressingChanged: { pressing in
            // Kullanıcı parmağını bastırdığında veya çektiğinde anında çalışır
            withAnimation(.easeInOut(duration: 0.2)) {
                self.isPressing = pressing
            }
        }
    }
}

// Tasarımı Xcode'da görmek için Sahte Veri (Mock Data)
#Preview {
    VStack(spacing: 20) {
        // Tamamlanmamış hali
        HabitCardView(habit: Habit(id: "1", title: "Read 10 Pages", createdAt: Date().timeIntervalSince1970, icon: "book.fill", colorHex: "#3498db", currentStreak: 5, longestStreak: 12, isReminderEnabled: false, frequency: []))
        
        // Tamamlanmış gibi görmek için basılı tut!
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
