import Foundation

// --- 1. ALIŞKANLIK TİPLERİ ---
// Kullanıcının ne tarz bir hedef koyduğunu belirler
enum HabitType: String, Codable {
    case classic = "classic" // Sadece Yaptım/Yapmadım (Örn: Ağırlık Antrenmanı, Halısaha)
    case counter = "counter" // Sayaçlı/Süreli hedefler (Örn: 5 dk meditasyon, 3 litre su)
}

// --- 2. ALT GÖREVLER (CHECKLIST) ---
// Görseldeki "Have a running session" gibi tik atılabilir alt adımlar
struct ChecklistItem: Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var isCompleted: Bool
    
    // Firestore'a kaydetmek için sözlük çevirici
    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "isCompleted": isCompleted
        ]
    }
}

// --- 3. ANA ALIŞKANLIK MODELİ ---
struct Habit: Codable, Identifiable {
    let id: String
    let title: String
    let createdAt: TimeInterval
    
    // Görsel Özellikler
    let icon: String
    let colorHex: String
    
    // YENİ: Kompleks Hedef Alanları (Görsellerden İlhamla)
    var type: HabitType
    var goalTargetValue: Double // Hedef miktar (Örn: 3)
    var goalUnit: String // Birim (Örn: "min", "litre", "sayfa")
    var todayProgress: Double // Bugün ne kadarı yapıldı? (Örn: 1.5)
    
    // YENİ: Alt Görevler ve Tekrar
    var checklist: [ChecklistItem] // İç içe liste
    var repeatCycle: String // "Daily", "Weekly"
    
    // Streak ve Oyunlaştırma
    var currentStreak: Int
    var longestStreak: Int
    var lastCompletedDate: TimeInterval?
    
    // Bildirim ve Detaylar
    var isReminderEnabled: Bool
    var reminderTime: String?
    var frequency: [Int] // 1: Pazar, 2: Pazartesi ...
    
    // Firestore'a gönderirken kolaylık sağlaması için
    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "createdAt": createdAt,
            "icon": icon,
            "colorHex": colorHex,
            
            // Yeni alanların Firestore eşleşmesi
            "type": type.rawValue,
            "goalTargetValue": goalTargetValue,
            "goalUnit": goalUnit,
            "todayProgress": todayProgress,
            "checklist": checklist.map { $0.asDictionary() }, // Diziyi JSON'a çevirir
            "repeatCycle": repeatCycle,
            
            "currentStreak": currentStreak,
            "longestStreak": longestStreak,
            "lastCompletedDate": lastCompletedDate ?? 0,
            "isReminderEnabled": isReminderEnabled,
            "reminderTime": reminderTime ?? "",
            "frequency": frequency
        ]
    }
}
