//
//  ContentView.swift
//  auraapp
//
//  Created by İrfan Vural on 12.03.2026.
//

import SwiftUI

struct MainView: View {
    @State var viewModel = MainViewViewModel()

        var body: some View {
            if viewModel.showMainApp {
               
                TodoListView()
            } else {
                LoginView(mainVM: viewModel)
            }
    }
}

#Preview {
    MainView()
}
