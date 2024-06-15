//
//  RootViewModel.swift
//  todolist
//
//  Created by 정유진 on 6/15/24.
//

import Foundation

class RootViewModel: ObservableObject {
    @Published var count: Int
    
    init() {
        count = 5
    }
    
    
    func addOne() {
        count += 1
    }
}
