//
//  claimed4App.swift
//  claimed4
//
//  Created by SHERELY Drent on 9/27/25.
//

import SwiftUI
import SuperwallKit

@main
struct claimed4App: App {
    
    init() {
        // Read API key from Info.plist to avoid hardcoding secrets
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "SUPERWALL_API_KEY") as? String,
           !apiKey.isEmpty {
            Superwall.configure(apiKey: apiKey)
        } else {
            #if DEBUG
            print("SUPERWALL_API_KEY missing. Superwall not configured.")
            #endif
        }
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingFlow()
        }
    }
}
