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
    
    var exersiseQueue: Array<HomePageModel.Exersise> {
        return homePageModel.exerciseQueue
    }
    
    var ongoingWorkout: Bool {
        return homePageModel.ongoingWorkout
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
    

    
    func addToHistory(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        homePageModel.addToHistory(workoutName: workoutName, exersiseModules: exersiseModules)
     
    }
    func clearToExersiseQueue() {
        homePageModel.clearToExersiseQueue()
    }
    
    func addToExersiseQueue(ExersiseID: Int) {
        homePageModel.addToExersiseQueue(exersiseID: ExersiseID)
    }
    
    func removeExersiseFromQueue(ExersiseID: Int) {
        homePageModel.removeExersiseFromQueue(exersiseID: ExersiseID)
    }
    
    func setSelectionState(ExersiseID: Int) {
        homePageModel.setSelectionState(ExersiseID: ExersiseID)
    }
    func saveExersiseHistory() {
        homePageModel.saveExersiseHistory()
        

    }
    
    func setOngoingState(state: Bool) {
        homePageModel.setOngoingWorkoutState(state: state)
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
