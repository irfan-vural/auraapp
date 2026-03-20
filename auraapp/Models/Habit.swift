//
//  Habit.swift
//  auraapp
//
//  Created by İrfan Vural on 20.03.2026.
//
import Foundation

struct Habit: Codable, Identifiable {
    let id: String
    let title: String
    let createdAt: TimeInterval
    
    // Görsel Özellikler
    let icon: String // SF Symbol adı (örn: "book.fill")
    let colorHex: String // Renk kodu (örn: "#FF9500")
    
    // Streak ve Oyunlaştırma
    var currentStreak: Int
    var longestStreak: Int
    var lastCompletedDate: TimeInterval? // Hiç yapılmadıysa nil olabilir
    
    // Bildirim ve Detaylar
    var isReminderEnabled: Bool
    var reminderTime: String?
    var frequency: [Int] // 1: Pazar, 2: Pazartesi ... 7: Cumartesi
    
    // Firestore'a gönderirken kolaylık sağlaması için
    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "createdAt": createdAt,
            "icon": icon,
            "colorHex": colorHex,
            "currentStreak": currentStreak,
            "longestStreak": longestStreak,
            "lastCompletedDate": lastCompletedDate ?? 0,
            "isReminderEnabled": isReminderEnabled,
            "reminderTime": reminderTime ?? "",
            "frequency": frequency
        ]
    }
}
