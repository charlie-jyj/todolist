//
//  todolistApp.swift
//  todolist
//
//  Created by 정유진 on 6/10/24.
//

import SwiftUI
import SwiftData

@main
struct todolistApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
//            ContentView()
//            RootView()
            AddressTestView()
        }
//        .modelContainer(sharedModelContainer)
    }
}
