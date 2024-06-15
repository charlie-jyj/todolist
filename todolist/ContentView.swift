//
//  ContentView.swift
//  todolist
//
//  Created by 정유진 on 6/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]

    @State var stateCount: Int
    let plainString: String
    
    init() {
        self.stateCount = 0
        plainString = "test"
    }
    
    var body: some View {
        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            NavigationLink(destination: RootView()) {
//                Text("Go to RootView")
//            }
            
            
            
            SubscribeView(publishedCount: TestCount(), bindingInt: $stateCount)
                .onChange(of: stateCount) { value in
                    print("state value is changed to : \(value)")
                    getMemoryAddress()
                    
                    let testString = Date().description
                    getMemoryAddress(from: testString)
                    
                    var testString2 = Date().description
                    getMemoryAddressVar(from: testString2)
                }
            
        }
       
    }
    
    private func getMemoryAddress(from: String) {
        let result = withUnsafePointer(to: from) { pointer in
            return pointer
        }

        print("result for let \(from): \(result)")
    }
    
    private func getMemoryAddressVar(from: String) {
        let result = withUnsafePointer(to: from) { pointer in
            return pointer
        }

        print("result for var \(from): \(result)")
    }
    
    private func getMemoryAddress() {
        let result = withUnsafePointer(to: $stateCount) { pointer in
            return pointer
        }

        print("result: \(result)")
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
//                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
}
