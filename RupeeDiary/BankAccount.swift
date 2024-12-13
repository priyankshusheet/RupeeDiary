//
//  BankAccount.swift
//  RupeeDiary
//
//  Created by Priyankshu Sheet on 26/07/24.
//

import SwiftUI

struct BankAccount: Identifiable, Codable {
    var id = UUID()
    let name: String
    let balance: Double
    var transactions: [Transaction]
}

struct Transaction: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let amount: Double
    let description: String
}

@Observable
class BankAccounts: ObservableObject {
    var accounts = [BankAccount]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(accounts) {
                UserDefaults.standard.set(encoded, forKey: "BankAccounts")
            }
        }
    }
    init() {
        if let savedAccounts = UserDefaults.standard.data(forKey: "BankAccounts"){
            if let decodedAccounts = try? JSONDecoder().decode([BankAccount].self, from: savedAccounts) {
                accounts = decodedAccounts
                return
            }
        }
        accounts = []
    }
}

struct BankAccountView: View {
    @StateObject private var bankAccounts = BankAccounts()
    @State private var showingAddAccount = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (bankAccounts.accounts) { account in
                    VStack(alignment: .leading) {
                        Text(account.name)
                            .font(.headline)
                        
                        Text("Balance: \(account.balance, format: .currency(code: "INR"))")
                            .font(.subheadline)
                        
                        ForEach(account.transactions) { transaction in
                            HStack {
                                Text(transaction.date, style: .date)
                                Spacer()
                                Text(transaction.description)
                                Spacer()
                                Text(transaction.amount, format: .currency(code: "INR"))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bank Accounts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddAccount = true
                    }) {
                        Label("Add Account", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAccount) {
                AddBankAccountView(bankAccounts: bankAccounts)
            }
        }
    }
}

struct AddBankAccountView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var balance = 0.0
    
    @ObservedObject var bankAccounts: BankAccounts
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account Details").font(.headline)) {
                    TextField("Account Name", text: $name)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    TextField("Initial Balance", value: $balance, format: .currency(code: "INR"))
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add Bank Account")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let account = BankAccount(name: name, balance: balance, transactions: [])
                        bankAccounts.accounts.append(account)
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    BankAccountView()
}
