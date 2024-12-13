//
//  BudgetManager.swift
//  RupeeDiary
//
//  Created by Priyankshu Sheet on 25/07/24.
//

import SwiftUI

struct Budget: Identifiable, Codable {
    var id = UUID()
    let name: String
    let amount: Double
    var expenses: [ExpenseItem]
}

@Observable
class Budgets: ObservableObject {
    var items = [Budget]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Budgets")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Budgets") {
            if let decodedItems = try? JSONDecoder().decode([Budget].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct BudgetManagerView: View {
    @StateObject private var budgets = Budgets()
    @State private var showingAddBudget = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(budgets.items) { budget in
                    VStack(alignment: .leading) {
                        Text(budget.name)
                            .font(.headline)
                        
                        Text("Amount: \(budget.amount, format: .currency(code: "INR"))")
                            .font(.subheadline)
                        
                        ForEach(budget.expenses) { expense in
                            HStack {
                                Text(expense.name)
                                Spacer()
                                Text(expense.amount, format: .currency(code: "INR"))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Budgets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddBudget = true
                    }) {
                        Label("Add Budget", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView(budgets: budgets)
            }
        }
    }
}

struct AddBudgetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var amount = 0.0
    
    @ObservedObject var budgets: Budgets
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Budget Details").font(.headline)) {
                    TextField("Budget Name", text: $name)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    TextField("Amount", value: $amount, format: .currency(code: "INR"))
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add Budget")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let budget = Budget(name: name, amount: amount, expenses: [])
                        budgets.items.append(budget)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    BudgetManagerView()
}
