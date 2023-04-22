//
//  WorkoutLogViewModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/29/23.
//

import SwiftUI


class WorkoutLogViewModel: ObservableObject {
    
    private static func createWorkoutLogModel() -> WorkoutLogModel{
        WorkoutLogModel()
    }
    
    @Published var workoutLogModel = createWorkoutLogModel()
    

    @Published var popUpStates = ["3DotsPopUp": false, "DataMetricsPopUp": false, "key3": true]
    
    var exersiseModules: Array<WorkoutLogModel.ExersiseLogModule> {
        return workoutLogModel.exersiseModules
    }
    
    var exersiseQueue: Array<WorkoutLogModel.Exersise> {
        return workoutLogModel.exerciseQueue
    }
    
//    func itemExists(withId id: Int) -> Bool {
//        return exersiseQueue.contains { $0.id == id }
//    }
//    

    var exersises: Array<WorkoutLogModel.Exersise> {
        return workoutLogModel.exercises
    }
    
    var workoutTime: WorkoutLogModel.WorkoutTime {
        return workoutLogModel.workoutTime
    
    }
    
    var restTime: WorkoutLogModel.WorkoutTime {
        return workoutLogModel.restTime
    
    }
    var lastModuleUsed: Int {
        return workoutLogModel.lastModuleChangedID
    
    }
    var lastRowUsed: Int {
        return workoutLogModel.lastRowChangedID
    
    }
    
    func setLastModule(index: Int) {

        workoutLogModel.setLastModule(index: index)
    }
    
    func setLastRow(index: Int) {
        workoutLogModel.setLastRow(index: index)
    }

    
    func getPopUp(popUpId: String) -> WorkoutLogModel.PopUpData {
        
        if let popUpIndex = workoutLogModel.popUps.firstIndex(where: {$0.id == popUpId}) {
            return workoutLogModel.popUps[popUpIndex]
        }
        else {
            print("did not find pop up")
            return workoutLogModel.popUps[0] // needs to be fixed
        }

    }
    

    
    
    
    // MARK: - Intent(s)
    
    func addEmptySet(moduleID: Int){
        workoutLogModel.addEmptySet(moduleID: moduleID)
    }
    
    func addEmptyWorkoutModule(exerciseName: String, exerciseID: Int, ExersiseEquipment: String) {
        workoutLogModel.addEmptyWorkoutModule(exerciseName: exerciseName, exerciseID: exerciseID, ExersiseEquipment: ExersiseEquipment)
    }
    
    func setRemoved(exersiseID: Int) {
        workoutLogModel.setRemoved(exersiseID: exersiseID)
    }
    func setExersiseModuleRPEDisplayStatus(exersiseID: Int, state: Bool) {
        workoutLogModel.setExersiseModuleRPEDisplayStatus(exersiseID: exersiseID, state: state)
    }
    
    func toggleExersiseModuleNotesDisplayStatus(exersiseID: Int) {
        workoutLogModel.toggleExersiseModuleNotesDisplayStatus(exersiseID: exersiseID)
    }
    func removeExersiseModule(exersiseID: Int) {
        workoutLogModel.removeExersiseModule(exersiseID: exersiseID)
    }
    
    func setTimePreset(time: Int) {
        workoutLogModel.setTimePreset(time: time)
    }
    func toggleCompletedSet(ExersiseModuleID: Int, RowID: Int, customValue: Bool? = nil) {
        if let customValue = customValue {
            // Use the custom value if it was provided
            workoutLogModel.setRowCompletionStatus(exersiseID: ExersiseModuleID, RowID: RowID, state: customValue)
        } else {
            // Toggle the current display status if no custom value was provided
            workoutLogModel.toggleCompletedSet(ExersiseModuleID: ExersiseModuleID, RowID: RowID)
        }
        
    }
    
    func restAddToTime(step: Int, time: Int? = nil) {
        if let time = time {
            
            workoutLogModel.setRestTime(time: time)
            
        } else {
            // Toggle the current display status if no custom value was provided
            workoutLogModel.restAddToTime(step: step)
        }
        
    }
    
    func toggleTime(){
        workoutLogModel.toggleTime()
    }
    func addToTime(step: Int){
        workoutLogModel.addToTime(step: step)
    }
    func setSelectionState(ExersiseID: Int) {
        workoutLogModel.setSelectionState(ExersiseID: ExersiseID)
    }
    

    
    func setPopUpState(state: Bool, popUpId: String) {
        workoutLogModel.setPopUpState(state: state, popUpId: popUpId)
    }
    func setPrevouslyChecked(exersiseModuleID : Int, RowID: Int, state: Bool) {
        workoutLogModel.setPrevouslyChecked(exersiseModuleID: exersiseModuleID, RowID: RowID, state: state)
    }
    func setPopUpCurrentRow(exersiseModuleID : Int, RowID: Int, popUpId: String) {
        workoutLogModel.setPopUpCurrentRow(exersiseModuleID: exersiseModuleID, RowID: RowID, popUpId: popUpId)
    }
    func setRepMetric(exersiseModuleID : Int, RowID: Int, RPE: Float) {
        workoutLogModel.setRepMetric(exersiseModuleID: exersiseModuleID, RowID: RowID, RPE: RPE)
    }
    func setRepValue(exersiseModuleID : Int, RowID: Int, value: Int) {
        workoutLogModel.setRepValue(exersiseModuleID: exersiseModuleID, RowID: RowID, value: value)
    }
    func setWeightValue(exersiseModuleID : Int, RowID: Int, value: Float) {
        workoutLogModel.setWeightValue(exersiseModuleID: exersiseModuleID, RowID: RowID, value: value)
    }
    
    func addToExersiseQueue(ExersiseID: Int) {
        workoutLogModel.addToExersiseQueue(exersiseID: ExersiseID)
    }
    
    func removeExersiseFromQueue(ExersiseID: Int) {
        workoutLogModel.removeExersiseFromQueue(exersiseID: ExersiseID)
    }
    
    func clearToExersiseQueue() {
        workoutLogModel.clearToExersiseQueue()
    }
    
    func checkLetter(letter: String) -> Bool {
        return workoutLogModel.checkLetter(letter: letter)
    }
        
    func addExercisesFromQueue() {
        exersiseQueue.forEach { exercise in
            addEmptyWorkoutModule(exerciseName: exercise.exerciseName, exerciseID: exercise.id, ExersiseEquipment: exercise.exerciseEquipment)
        }
        clearToExersiseQueue()
    }
    
    func saveExersiseModules() {
        workoutLogModel.saveExersiseModules()
    }
    func loadExersiseModules() {
        workoutLogModel.loadExersiseModules()
    }
    

    

}
