//
//  ContentView.swift
//  Curversion2
//
//  Created by Glorio on 13/05/22.
//  https://api.exchangerate.host/convert?from=\(itemSelected)&to\(itemSelected2)&amount=\(amount)

import SwiftUI

struct ContentView: View {
    @State private var amount : String = ""
    @State private var itemSelected = 150
    @State private var itemSelected2 = 63
    @State var symbolsList = [String]()
    @State var convResult: String = ""
    @State var convRate: String = ""
    @State var isSuccess: Bool = false
    @State private var hasTimeElapsed = false
    
    
    func convert() {
        getConversionResult(url: "https://api.exchangerate.host/convert?from=\(symbolsList[itemSelected])&to=\(symbolsList[itemSelected2])&amount=\(amount)") { conversion in
            convResult = String(format: "%.2f", conversion.result)
            convRate = String(format: "%.2f", conversion.info.rate)
        }
    }
    
    func getAllSymbols() {
        getSymbols(url: "https://api.exchangerate.host/symbols") { symbols in
            symbolsList.removeAll()
            for symbols in symbols.symbols {
                symbolsList.append("\(symbols.value.code)")
            }
            symbolsList.sort()
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Convert a currency").font(.subheadline)) {
                    
                    TextField("Enter an amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .onAppear() {getAllSymbols()}
                    
                    Picker(selection: $itemSelected, label: Text("From")) {
                        ForEach(0 ..< symbolsList.count, id: \.self) {index in
                            Text(self.symbolsList[index]).tag(index).font(.body)
                        }
                    }

                    Picker(selection: $itemSelected2, label: Text("To")) {
                        ForEach(0 ..< symbolsList.count, id: \.self) {index in
                            Text(self.symbolsList[index]).tag(index).font(.body)
                        }
                    }
                }
                
                Button() {
                    convert()
                    isSuccess = true
                } label: {
                    Text("Convert").font(.body)
                }
                
                if isSuccess {
                    Section(header: Text("Conversion").font(.subheadline)) {
                        Text("Rates: \(convRate)").font(.body)
                        Text("Result: \(convResult)").font(.body)
                    }
                }
            }
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            .navigationTitle("Currversion /")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
