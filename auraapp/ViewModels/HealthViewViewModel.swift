import Foundation
import HealthKit
import Observation
// Grafikte göstereceğimiz her bir günün veri modeli
struct DailyStep: Identifiable {
    let id = UUID()
    let date: Date
    let count: Double
}
@Observable
class HealthViewViewModel {
    var stepCount: Double = 0.0
    var distance: Double = 0.0 // Metre cinsinden
    var calories: Double = 0.0 // Kcal cinsinden
    var errorMessage = ""
    var weeklySteps: [DailyStep] = []
    // Günlük adım hedefi (Şimdilik sabit, ileride ayarlardan çekebiliriz)
    let stepGoal: Double = 10000.0
    
    private let healthStore = HKHealthStore()
    
    // İlerleyiş yüzdesi (0.0 - 1.0 arası)
    var stepProgress: Double {
        return min(stepCount / stepGoal, 1.0)
    }
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "HealthKit is not available on this device."
            return
        }
        
        // Okumak istediğimiz veri tiplerini genişletiyoruz
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
              let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        
        let typesToRead: Set = [stepType, distanceType, caloriesType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] success, error in
            if success {
                self?.fetchAllData()
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Permission denied."
                }
            }
        }
    }
    
    private func fetchAllData() {
        fetchTodaySteps()
        fetchTodayDistance()
        fetchTodayCalories()
        fetchWeeklySteps()
    }
    private func fetchWeeklySteps() {
            guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
            
            let calendar = Calendar.current
            let today = Date()
            
            // Bugünden 6 gün geriye gidiyoruz (Toplam 7 gün)
            guard let endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: today)),
                  let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: today)) else { return }
            
            // Veriyi "Günlük" (1 Day) periyotlarla böl diyoruz
            var interval = DateComponents()
            interval.day = 1
            
            let query = HKStatisticsCollectionQuery(
                quantityType: stepType,
                quantitySamplePredicate: nil,
                options: .cumulativeSum,
                anchorDate: startDate,
                intervalComponents: interval
            )
            
            query.initialResultsHandler = { [weak self] query, results, error in
                guard let results = results else { return }
                var tempSteps: [DailyStep] = []
                
                // Sonuçları tek tek dönüp bizim DailyStep objelerine çeviriyoruz
                results.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                    let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
                    tempSteps.append(DailyStep(date: statistics.startDate, count: count))
                }
                
                DispatchQueue.main.async {
                    self?.weeklySteps = tempSteps
                }
            }
            
            healthStore.execute(query)
        }
    
    private func fetchTodaySteps() {
        fetchData(for: .stepCount) { self.stepCount = $0 }
    }
    
    private func fetchTodayDistance() {
        fetchData(for: .distanceWalkingRunning) { self.distance = $0 }
    }
    
    private func fetchTodayCalories() {
        fetchData(for: .activeEnergyBurned) { self.calories = $0 }
    }
    
    // Genel veri çekme fonksiyonu (Tekrarı önler kanka)
    private func fetchData(for identifier: HKQuantityTypeIdentifier, completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { return }
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else { return }
            DispatchQueue.main.async {
                // Adım için count, mesafe için meter, kalori için kilocalorie birimini kullanıyoruz
                if identifier == .stepCount {
                    completion(sum.doubleValue(for: HKUnit.count()))
                } else if identifier == .distanceWalkingRunning {
                    completion(sum.doubleValue(for: HKUnit.meter()))
                } else {
                    completion(sum.doubleValue(for: HKUnit.kilocalorie()))
                }
            }
        }
        healthStore.execute(query)
    }
}
