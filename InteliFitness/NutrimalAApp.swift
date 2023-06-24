//
//  NutrimalAApp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI
import ActivityKit


@main
struct NutrimalAApp: App {
    @AppStorage("hasOnboarded") var hasOnboarded = false
    var body: some Scene {
        WindowGroup {
            HomePageView()
                .fullScreenCover(isPresented: .constant(!hasOnboarded)) {
                    OnboardingView(hasOnboarded: $hasOnboarded)
                }
        }
    }
}
