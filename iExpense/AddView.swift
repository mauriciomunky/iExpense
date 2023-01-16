//
//  AddView.swift
//  iExpense
//
//  Created by Maurício Costa on 16/01/23.
//

import SwiftUI



struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @ObservedObject var business: Expenses
    @ObservedObject var personal: Expenses
    @Environment(\.dismiss) var dismiss
    
    let types = ["Business", "Personal"]
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.automatic)
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currencyCode ?? "BRL"))
                    .keyboardType(.decimalPad)
            }.navigationTitle("Add new expense")
                .toolbar { Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    if (item.type == "Personal") { personal.items.append(item)} else {business.items.append(item)}
                    dismiss()
        }
        }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(business: Expenses(), personal: Expenses())
    }
}
