import SwiftUI
import Charts
struct HealthView: View {
    @State var viewModel = HealthViewViewModel()
    @AppStorage("dailyStepGoal") private var dailyStepGoal: Double = 10000.0
        @State private var showingGoalAlert = false
        @State private var newGoalString = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                                            Text("This Week")
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            
                                            if viewModel.weeklySteps.isEmpty {
                                                // Veri gelene kadar veya veri yoksa şık bir yüklenme/boşluk tasarımı
                                                ProgressView()
                                                    .frame(maxWidth: .infinity, minHeight: 150)
                                            } else {
                                                // APPLE'IN MUAZZAM GRAFİK MOTORU
                                                Chart(viewModel.weeklySteps) { stepData in
                                                    BarMark(
                                                        x: .value("Day", stepData.date, unit: .day),
                                                        y: .value("Steps", stepData.count)
                                                    )
                                                  
                                                    .foregroundStyle(Color.orange.gradient)
                                                    // Sütun köşelerini hafif yumuşatıyoruz
                                                    .cornerRadius(6)
                                                }
                                                .frame(height: 180) // Grafiğin yüksekliği
                                                .chartXAxis {
                                                   
                                                    AxisMarks(values: .stride(by: .day)) { value in
                                                        AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                                                    }
                                                }
                                            }
                                        }
                                        .padding()
                                        .background(Color(.secondarySystemGroupedBackground))
                                        .cornerRadius(20)
                                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    // --- 1. ANA AKTİVİTE ÖZET KARTI (Dairesel Bar & Adım) ---
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Steps Today")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Text("\(Int(viewModel.stepCount))")
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                
                                Text("Goal: \(Int(viewModel.stepGoal)) steps")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            // Profesyonel İlerleme Halkası (Sihirli Kısım!)
                            ZStack {
                                Circle() // Arka plan halkası
                                    .stroke(lineWidth: 15)
                                    .foregroundColor(Color(.systemGray5))
                                
                                Circle() // İlerleme halkası
                                    .trim(from: 0.0, to: viewModel.stepProgress)
                                    .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(.orange)
                                    .rotationEffect(Angle(degrees: -90)) // Tepeden başlasın
                                    .animation(.easeOut(duration: 1.0), value: viewModel.stepProgress) // Tatlı bir animasyon
                                
                                Text("\(Int(viewModel.stepProgress * 100))%")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            .frame(width: 90, height: 90)
                        }
                        .padding()
                    }
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // --- 2. DİĞER METRİKLER (Mesafe & Kalori) ---
                    HStack(spacing: 16) {
                        // Mesafe Kartı
                        HealthStatCard(
                            icon: "figure.walk",
                            value: String(format: "%.1f", viewModel.distance / 1000.0), // KM'ye çevir
                            unit: "KM",
                            color: .blue
                        )
                        
                        // Kalori Kartı
                        HealthStatCard(
                            icon: "flame.fill",
                            value: "\(Int(viewModel.calories))",
                            unit: "Kcal",
                            color: .red
                        )
                    }
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Activity")
            .background(Color(.systemGroupedBackground)) // iOS Ayarlar gibi gri arka plan
            .onAppear {
                viewModel.requestAuthorization()
            }
        }
    }
}

// --- YARDIMCI BİLEŞEN: KÜÇÜK STAT KARTI ---
struct HealthStatCard: View {
    var icon: String
    var value: String
    var unit: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .padding()
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    HealthView()
}
