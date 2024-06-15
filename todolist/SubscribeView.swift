//
//  SubscribeView.swift
//  todolist
//
//  Created by 정유진 on 6/15/24.
//

import SwiftUI
import Combine

class TestCount: ObservableObject {
    @Published var count: Int = 0
//    var newCount = CurrentValueSubject<Int, Never>(0)
}

struct SubscribeView: View {
    @StateObject var viewModel: RootViewModel = RootViewModel()
    @ObservedObject var publishedCount: TestCount
    @Binding var bindingInt: Int
//    @State var count: Int
    
    var body: some View {
//        Button(action: {
//            viewModel.addOne()
//        }) {
//            Text("count +1")
//        }
        
//        Text(String(viewModel.count))
        Button("Test Increase") {
            publishedCount.count += 1
            
        }
//        .onReceive(publishedCount.$count) { value in
//            print(value)
//        }
        
//        Button("Test current value increase") {
//            publishedCount.newCount.value = publishedCount.newCount.value + 1
//        }
        
        Button("binding Increase") {
            bindingInt += 1
        }
        
        Text(String(publishedCount.count))
//        Text(String(publishedCount.newCount.value))
        
    }
}

#Preview {
    SubscribeView(publishedCount: TestCount(), bindingInt: .constant(0))
}
