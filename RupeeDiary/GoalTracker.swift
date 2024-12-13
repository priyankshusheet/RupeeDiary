//
//  GoalTracker.swift
//  RupeeDiary
//
//  Created by Priyankshu Sheet on 25/07/24.
//

import SwiftUI

struct Goal: Identifiable, Codable {
    var id = UUID()
    let name: String
    let targetAmount: Double
    let currentAmount: Double
    let deadline: Date
}

@Observable
class Goals: ObservableObject {
    var items = [Goal]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Goals")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Goals") {
            if let decodedItems = try? JSONDecoder().decode([Goal].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct GoalTrackerView: View {
    @StateObject private var goals = Goals()
    @State private var showingAddGoal = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(goals.items) { goal in
                    VStack(alignment: .leading) {
                        Text(goal.name)
                            .font(.headline)
                        
                        Text("Target: \(goal.targetAmount, format: .currency(code: "INR"))")
                            .font(.subheadline)
                        
                        ProgressView(value: goal.currentAmount, total: goal.targetAmount)
                            .accentColor(.green)
                        
                        Text(goal.deadline, style: .date)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddGoal = true
                    }) {
                        Label("Add Goal", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goals: goals)
            }
        }
    }
}

struct AddGoalView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var targetAmount = 0.0
    @State private var currentAmount = 0.0
    @State private var deadline = Date()
    
    @ObservedObject var goals: Goals
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details").font(.headline)) {
                    TextField("Goal Name", text: $name)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    TextField("Target Amount", value: $targetAmount, format: .currency(code: "INR"))
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    TextField("Current Amount", value: $currentAmount, format: .currency(code: "INR"))
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add Goal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let goal = Goal(name: name, targetAmount: targetAmount, currentAmount: currentAmount, deadline: deadline)
                        goals.items.append(goal)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    GoalTrackerView()
}
