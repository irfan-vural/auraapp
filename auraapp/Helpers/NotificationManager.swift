import Foundation
import UserNotifications

class NotificationManager {
    // Sınıfı Singleton (tek kopya) yapıyoruz ki uygulamanın her yerinden kolayca ulaşalım
    static let shared = NotificationManager()
    
    // 1. KULLANICIDAN İZİN İSTEME EKRANI
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Bildirim izni hatası: \(error.localizedDescription)")
            } else if success {
                print("Bildirim izni başarıyla alındı!")
            }
        }
    }
    // NotificationManager.swift içine eklenecek:

    func scheduleDailyMorningNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Günaydın! ✨"
        content.body = "Aura'nı inşa etmeye başla. Bugün harika geçecek!"
        content.sound = .default
        
        // Saat 08:30 ayarı
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 30
        
        // Her gün tekrarlanacak şekilde tetikleyici (trigger) oluştur
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // İstek oluştur (ID sabit olduğu için her seferinde üzerine yazar, kopya oluşturmaz)
        let request = UNNotificationRequest(identifier: "daily_morning_aura", content: content, trigger: trigger)
        
        // iOS'a teslim et
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Sabah bildirimi kurulamadı: \(error.localizedDescription)")
            }
        }
    }
    
    // 2. ALARMI (BİLDİRİMİ) KURMA
    func scheduleNotification(for habitId: String, title: String, time: Date) {
        // Eski bir alarm varsa çifte bildirim gitmesin diye önce onu siliyoruz
        cancelNotification(for: habitId)
        
        let content = UNMutableNotificationContent()
        content.title = "Aura Zamanı!"
        content.body = "\(title) hedefini tamamlama vakti geldi. Seriyi bozma!"
        content.sound = .default // Varsayılan iOS bildirim sesi
        
        // Sadece saat ve dakikayı alıyoruz (Örn: Her gün 21:00)
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        
        // Her gün tekrarlanan bir tetikleyici (trigger) oluşturuyoruz
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Bildirim isteğini paketleyip iOS'a teslim ediyoruz
        let request = UNNotificationRequest(identifier: habitId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim kurulamadı: \(error.localizedDescription)")
            }
        }
    }
    
    // 3. ALARMI İPTAL ETME (Görev silinirse veya Reminder kapatılırsa)
    func cancelNotification(for habitId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habitId])
    }
}
