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

    var history: [HomePageModel.Workout] {
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
    
    func addToHistory(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        homePageModel.addToHistory(workoutName: workoutName, exersiseModules: exersiseModules)
     
    }
    
    func saveExersiseHistory() {
        homePageModel.saveExersiseHistory()

    }
    
    func deleteExerciseHistory(workoutID: UUID) {
        homePageModel.deleteFromHistory(workoutID: workoutID)

    }
    func setCurrentExercise(exercise: HomePageModel.Exersise) {
        homePageModel.setCurrentExercise(execise: exercise)
    }
    
    func loadHistory() {
        homePageModel.loadHistory()

    }
    
    func saveExercisesToUserDefaults(_ exercises: [HomePageModel.Exersise]) {
        homePageModel.saveExercisesToUserDefaults(exercises)
    }
//    func addToexercise


    
}
