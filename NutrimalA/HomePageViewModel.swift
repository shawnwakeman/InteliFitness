//
//  WorkoutLogViewModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/29/23.
//

import SwiftUI


class HomePageViewModel: ObservableObject {
    
    private static func createHomePageModel() -> HomePageModel {
        HomePageModel()
    }
    
    
    @Published var homePageModel = createHomePageModel()
    
    var workoutLogModuleStatus: Bool{
        return homePageModel.displayingWorkoutLogView
    }
    
    var history: [[WorkoutLogModel.ExersiseLogModule]] {
        return homePageModel.history
    }
    
    
    var exersises: Array<HomePageModel.Exersise> {
        return homePageModel.exercises
    }

    func setWorkoutLogModuleStatus(state: Bool) {
        homePageModel.setWorkoutLogModuleStatus(state: state)
    }
    
    func checkLetter(letter: String) -> Bool {
        return homePageModel.checkLetter(letter: letter)
    }
    
    func addToHistory(exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        homePageModel.addToHistory(exersiseModules: exersiseModules)
     
    }
    
    func saveExersiseHistory() {
        homePageModel.saveExersiseHistory()

    }
    
    func loadHistory() {
        homePageModel.loadHistory()

    }


    
}
