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
