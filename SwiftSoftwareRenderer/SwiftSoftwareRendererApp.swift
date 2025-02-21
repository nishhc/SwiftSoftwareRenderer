//
//  SwiftSoftwareRendererApp.swift
//  SwiftSoftwareRenderer
//
//  Created by Nishchai Chawla on 2/20/25.
//

import SwiftUI

@main
struct SwiftSoftwareRendererApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
