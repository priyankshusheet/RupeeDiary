//
//  ExpenseListView.swift
//  RupeeDiary
//
//  Created by Priyankshu Sheet on 25/07/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let date: Date
}

@Observable
class Expenses: ObservableObject {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Expenses")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Expenses") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ExpenseListView: View {
    @StateObject private var expenses = Expenses()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.name)
                                .font(.headline)
                            
                            Text(expense.type)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Text(expense.amount, format: .currency(code: "INR"))
                    }
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddExpense = true
                    }) {
                        Label("Add Expense", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(expenses: expenses)
            }
        }
    }
}

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var date = Date()
    
    let types = ["Personal", "Business"]
    
    @ObservedObject var expenses: Expenses
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Expense Details").font(.headline)) {
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    
                    TextField("Amount", value: $amount, format: .currency(code: "INR"))
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add New Expense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let expense = ExpenseItem(name: name, type: type, amount: amount, date: date)
                        expenses.items.append(expense)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ExpenseListView()
}
