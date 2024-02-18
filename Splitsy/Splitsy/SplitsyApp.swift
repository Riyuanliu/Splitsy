//
//  SplitsyApp.swift
//  Splitsy
//
//  Created by Manny Reyes on 2/16/24.
//

import SwiftUI

@main
struct SplitsyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(userData: UserData.shared)
        }
    }
}
