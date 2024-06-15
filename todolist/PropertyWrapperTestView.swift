//
//  PropertyWrapperTestView.swift
//  todolist
//
//  Created by 정유진 on 6/15/24.
//

import SwiftUI

@propertyWrapper 
struct Document {
    @State private var value = ""
    private let url: URL
    
    init(_ filename: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        url = paths[0].appendingPathComponent(filename)

        let initialText = (try? String(contentsOf: url)) ?? ""
        _value = State(wrappedValue: initialText)
    }
    
    var wrappedValue: String {
        get {
            value
        }
        nonmutating set {
            do {
                try newValue.write(to: url, atomically: true, encoding: .utf8)
                value = newValue
            } catch {
                print("Failed to write output")
            }
        }
    }
}

struct PropertyWrapperTestView: View {
    @Document("test.txt") var document
    
    var body: some View {
        NavigationView {
            VStack {
                Text(document)

                Button("Change document") {
                    document = String(Int.random(in: 1...1000))
                }
            }
            .navigationTitle("SimpleText")
        }
    }
}

#Preview {
    PropertyWrapperTestView()
}
