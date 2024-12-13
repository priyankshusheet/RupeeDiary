//
//  AddView.swift
//  RupeeDiary
//
//  Created by Priyankshu Sheet on 25/07/24.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var date = Date()
    
    let types = ["Personal", "Business"]
    
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
                    }
                }
            }
        }
    }
}

#Preview {
    AddView()
}
