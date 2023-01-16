//
//  ContentView.swift
//  iExpense
//
//  Created by Maurício Costa on 15/01/23.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var showingAddExpense = false
    @StateObject var business = Expenses()
    @StateObject var personal = Expenses()
    func removeBusiness(at offsets: IndexSet) {
        business.items.remove(atOffsets: offsets)
    }
    func removePersonal(at offsets: IndexSet) {
        personal.items.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if (personal.items.count > 0){
                        Text("Personal expenses").font(.title2)}
                    ForEach(personal.items) {
                        item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            if (item.amount > 10 && item.amount < 100) {Text(item.amount, format: .currency(code: (Locale.current.currencyCode ?? "BRL"))).foregroundColor(Color.yellow)} else if (item.amount > 100) {Text(item.amount, format: .currency(code: (Locale.current.currencyCode ?? "BRL"))).foregroundColor(Color.red)} else {Text(item.amount, format: .currency(code: (Locale.current.currencyCode ?? "BRL"))).foregroundColor(Color.green)}
                        }}.onDelete(perform: removePersonal)
                        Spacer()
                        if (business.items.count > 0){
                            Text("Business expenses").font(.title2)}
                        ForEach(business.items) {
                            item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                Spacer()
                                if (item.amount > 10 && item.amount < 100) {Text(item.amount, format: .currency(code: (Locale.current.currencyCode ?? "BRL"))).foregroundColor(Color.yellow)} else if (item.amount > 100) {Text(item.amount, format: .currency(code: (Locale.current.currencyCode ?? "BRL"))).foregroundColor(Color.red)} else {Text(item.amount, format: .currency(code: (Locale.current.currencyCode ?? "BRL"))).foregroundColor(Color.green)}
                                }
                    }.onDelete(perform: removeBusiness)
                }.sheet(isPresented: $showingAddExpense) {
                    AddView(business: Expenses(), personal: Expenses())
                }
                .navigationTitle("iExpense")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
