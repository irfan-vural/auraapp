import Foundation
import HealthKit
import Observation

@Observable
class HealthViewViewModel {
    var stepCount: Double = 0.0
    var errorMessage = ""
    
    // Apple'ın sağlık deposuna erişim anahtarımız
    private let healthStore = HKHealthStore()
    
    // 1. Kullanıcıdan izin isteme fonksiyonu
    func requestAuthorization() {
        // Cihaz HealthKit destekliyor mu? (iPad'lerde falan desteklenmeyebilir)
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "HealthKit is not available on this device."
            return
        }
        
        // Sadece "Adım Sayısı" verisini okumak istediğimizi belirtiyoruz
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let typesToRead: Set = [stepType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] success, error in
            if success {
                // İzin verildiyse bugünün adımlarını çek
                self?.fetchTodaySteps()
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Permission denied."
                }
            }
        }
    }
    
    // 2. Bugünün adım sayısını hesaplama fonksiyonu
    private func fetchTodaySteps() {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        // Sadece bugünün başlangıcından şu ana kadar olan adımları istiyoruz
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            
            guard let result = result, let sum = result.sumQuantity() else { return }
            
            DispatchQueue.main.async {
                // Sonucu Double (küsuratlı sayı) olarak değişkene aktarıyoruz
                self.stepCount = sum.doubleValue(for: HKUnit.count())
            }
        }
        
        healthStore.execute(query)
    }
}
