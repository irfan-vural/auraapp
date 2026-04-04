import SwiftUI

struct NewHabitView: View {
    @State var viewModel = NewHabitViewViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // --- ÜST: ADIM GÖSTERGESİ (1-2-3-4) ---
                    StepIndicatorView(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)
                        .padding(.top, 20)
                    
                    // --- ORTA: DİNAMİK İÇERİK ---
                    ScrollView {
                        VStack(spacing: 24) {
                            switch viewModel.currentStep {
                            case 1: stepOneView // İsim, İkon, Renk
                            case 2: stepTwoView // Hedef (Goal)
                            case 3: stepThreeView // Checklist
                            case 4: stepFourView // Tekrar ve Bildirim
                            default: EmptyView()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100) // Butonun altında kalmasın diye
                    }
                }
                
                // --- ALT: İLERİ / KAYDET BUTONU ---
                VStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            if viewModel.currentStep < viewModel.totalSteps {
                                viewModel.nextStep()
                            } else {
                                viewModel.save { success in
                                    if success { dismiss() }
                                }
                            }
                        }
                    }) {
                        Text(viewModel.currentStep == viewModel.totalSteps ? "Save Habit" : "Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black) // Görseldeki gibi siyah şık buton
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle(viewModel.currentStep == 1 ? String(localized: "New Habit"): viewModel.title.isEmpty ? String(localized: "Details") : viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.currentStep > 1 {
                        Button(action: {
                            withAnimation(.spring()) { viewModel.previousStep() }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primary)
                        }
                    } else {
                        Button("Cancel") { dismiss() }
                    }
                }
            }
            .alert("Oops!", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
    
    // MARK: - ADIM GÖRÜNÜMLERİ (Sub-Views)
    
    // --- ADIM 1: TEMEL BİLGİLER ---
    private var stepOneView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What do you want to build?").font(.title2.bold())
            
            TextField("e.g. Read a book, Running...", text: $viewModel.title)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(14)
            
            Text("Icon").font(.headline).padding(.top, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.icons, id: \.self) { icon in
                        Image(systemName: icon)
                            .font(.title2)
                            .frame(width: 55, height: 55)
                            .foregroundColor(viewModel.selectedIcon == icon ? .white : .primary)
                            .background(viewModel.selectedIcon == icon ? Color(hex: viewModel.selectedColorHex) : Color(.systemGray5))
                            .clipShape(Circle())
                            .onTapGesture { withAnimation { viewModel.selectedIcon = icon } }
                    }
                }
            }
            
            Text("Color").font(.headline).padding(.top, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.colors, id: \.self) { hex in
                        Circle()
                            .fill(Color(hex: hex))
                            .frame(width: 45, height: 45)
                            .overlay(Circle().stroke(Color.primary, lineWidth: viewModel.selectedColorHex == hex ? 3 : 0))
                            .padding(2)
                            .onTapGesture { withAnimation { viewModel.selectedColorHex = hex } }
                    }
                }
            }
        }
    }
    
    // --- ADIM 2: HEDEF (GÖRSELDEKİ GİBİ) ---
    private var stepTwoView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Goal").font(.title2.bold())
            
            VStack(spacing: 0) {
                Toggle("Set a goal", isOn: $viewModel.isGoalEnabled)
                    .padding()
                
                if viewModel.isGoalEnabled {
                    Divider()
                    HStack {
                        TextField("Value", value: $viewModel.targetValue, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 60)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        Picker("Unit", selection: $viewModel.selectedUnit) {
                            ForEach(viewModel.units, id: \.self) { unit in
                                Text(unit).tag(unit)
                            }
                        }
                        .tint(.primary)
                        Spacer()
                    }
                    .padding()
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
        }
    }
    
    // --- ADIM 3: CHECKLIST ---
    private var stepThreeView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Checklist (Optional)").font(.title2.bold())
            Text("Break your habit into smaller steps.").font(.subheadline).foregroundColor(.gray)
            
            VStack(spacing: 12) {
                ForEach(viewModel.checklist) { item in
                    HStack {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                        Text(item.title)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                }
                
                HStack {
                    TextField("Add new step...", text: $viewModel.newChecklistItemTitle)
                    Button(action: viewModel.addChecklistItem) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: viewModel.selectedColorHex))
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
            }
        }
    }
    
    // --- ADIM 4: TEKRAR VE BİLDİRİM ---
    private var stepFourView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Repeat & Reminder").font(.title2.bold())
            
            // Tekrar Kartı
            VStack(spacing: 0) {
                Toggle("Set a cycle for your plan", isOn: $viewModel.isCycleEnabled)
                    .padding()
                if viewModel.isCycleEnabled {
                    Divider()
                    Picker("Cycle", selection: $viewModel.repeatCycle) {
                        Text("Daily").tag("Daily")
                        Text("Weekly").tag("Weekly")
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
            
            // Bildirim Kartı
            VStack(spacing: 0) {
                Toggle("Reminder", isOn: $viewModel.isReminderEnabled)
                    .padding()
                if viewModel.isReminderEnabled {
                    Divider()
                    DatePicker("Time", selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
                        .padding()
                }
                Text("We will send you a notification!")
                        .font(.footnote) // Bilgi metni olduğu için bir tık küçük ve şık durur
                        .opacity(0.8)
                        // İŞTE SİHİRLİ SATIR: Genişliği full yapıp yazıyı sola yaslıyor
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal) // Üstteki Toggle ile aynı dikey hizaya sokar
                        .padding(.bottom, 15)             }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
        }
    }
}

// MARK: - GÖRSELDEKİ O TATLI İLERLEME ÇUBUĞU
struct StepIndicatorView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                ZStack {
                    Circle()
                        .fill(step <= currentStep ? Color.black : Color(.systemGray5))
                        .frame(width: 35, height: 35)
                    
                    Text("\(step)")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(step <= currentStep ? .white : .gray)
                }
                
                if step < totalSteps {
                    // Adımları bağlayan küçük noktalar
                    HStack(spacing: 4) {
                        ForEach(0..<3) { _ in
                            Circle()
                                .fill(step < currentStep ? Color.black : Color(.systemGray4))
                                .frame(width: 4, height: 4)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewHabitView()
}
