//
//  BillTracker.swift
//  RupeeDiary
//
//  Created by Priyankshu Sheet on 25/07/24.
//

import SwiftUI

struct Bill: Identifiable, Codable {
    var id = UUID()
    let name: String
    let dueDate: Date
    let amount: Double
    let isPaid: Bool
}

@Observable
class Bills: ObservableObject {
    var items = [Bill]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Bills")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Bills") {
            if let decodedItems = try? JSONDecoder().decode([Bill].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct BillTrackerView: View {
    @StateObject private var bills = Bills()
    @State private var showingAddBill = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(bills.items) { bill in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(bill.name)
                                .font(.headline)
                            
                            Text(bill.dueDate, style: .date)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        Text(bill.amount, format: .currency(code: "INR"))
                            .font(.subheadline)
                        
                        if bill.isPaid {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Bills")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddBill = true
                    }) {
                        Label("Add Bill", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBill) {
                AddBillView(bills: bills)
            }
        }
    }
}

struct AddBillView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var dueDate = Date()
    @State private var amount = 0.0
    @State private var isPaid = false
    
    @ObservedObject var bills: Bills
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Bill Details").font(.headline)) {
                    TextField("Bill Name", text: $name)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    TextField("Amount", value: $amount, format: .currency(code: "INR"))
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    Toggle("Paid", isOn: $isPaid)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add Bill")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let bill = Bill(name: name, dueDate: dueDate, amount: amount, isPaid: isPaid)
                        bills.items.append(bill)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    BillTrackerView()
}
