//
//  ContentView.swift
//  RupeeDiary
//
//  Created by Priyankshu Sheet on 25/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExpenseListView()
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet")
                }
            
            AddView()
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }
            
            BankAccountView()
                .tabItem {
                    Label("Account", systemImage: "banknote")
                }
            
            BudgetManagerView()
                .tabItem {
                    Label("Budgets", systemImage: "chart.pie")
                }
        }
    }
}

#Preview {
    ContentView()
}
