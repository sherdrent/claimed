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
        Superwall.configure(apiKey: "pk_rM88maB661KDuyt01yktL")
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingFlow()
        }
    }
}
