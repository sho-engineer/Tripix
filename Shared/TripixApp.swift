//
//  TripixApp.swift
//  Shared
//
//  Created by 石井　翔 on 2024/10/27.
//

import SwiftUI

@main
struct TripixApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
