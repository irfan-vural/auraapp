import SwiftUI

struct TodoListView: View {
    @State var viewModel = TodoListViewViewModel()
    // Bugünün tarihini şık bir şekilde formatlamak için
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, EEEE" // Örn: "20 March, Friday"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Arka plan rengini profil sayfasıyla uyumlu gri ton yapıyoruz
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // --- HEADER: TARİH VE BAŞLIK ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text(formattedDate)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .fontWeight(.semibold)
                                .textCase(.uppercase)
                            
                            Text("Your Habits")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // --- LİSTE VEYA BOŞ DURUM ---
                        if viewModel.habits.isEmpty {
                            // Görev yoksa ekranda görünecek tasarım
                            VStack(spacing: 16) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 60))
                                    .foregroundColor(.orange.opacity(0.5))
                                
                                Text("No habits yet.")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                
                                Text("Tap the + button to start building your Aura.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 80)
                            
                        } else {
                            // Görevler varsa kartları alt alta diz (LazyVStack performansı artırır)
                            LazyVStack(spacing: 16) {

                                ForEach(viewModel.habits) { habit in
                                    HabitCardView(habit: habit)
                                        .padding(.horizontal, 20)
                                        .onTapGesture {
                                            // Karta tıklanınca detayı aç
                                            viewModel.selectedHabit = habit
                                        }
                                }
                            }.sheet(item: $viewModel.selectedHabit) { selected in
                                HabitDetailView(viewModel: HabitDetailViewViewModel(habit: selected))
                                    .presentationDetents([.large]) // iOS'a özel tam ekrana yakın çok şık açılış
                            }
                        }
                    }
                    // TabView'ın altında kalmasın diye alt boşluk
                    .padding(.bottom, 30)
                }
            }
            // --- ÜST BAR VE EKLE BUTONU ---
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.isShowingAddHabitView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.blue) // İleride Aura'nın ana tema rengini verebiliriz
                    }
                }
            }
            // --- YENİ EKLE EKRANI AÇILIŞI (SHEET) ---
            .sheet(isPresented: $viewModel.isShowingAddHabitView) {
                NewHabitView()
            }
            .onAppear {
                // Sayfa ekrana geldiği an Firebase'den verileri çekmeye başla
                viewModel.fetchHabits()
            }
        }
    }
}

#Preview {
    TodoListView()
}
