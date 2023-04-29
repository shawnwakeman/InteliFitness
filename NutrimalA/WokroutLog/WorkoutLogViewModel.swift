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
    
    @Published var workoutLogModel = WorkoutLogModel()
    

    @Published var popUpStates = ["3DotsPopUp": false, "DataMetricsPopUp": false, "key3": true]
    
    @Published var exerciseNames: [ExeciseNameStruct] = []
    
  
    func relocate(from source: IndexSet, to destination: Int) {
        workoutLogModel.reorderExercises(from: source, to: destination)
    }
    
    var filteredExerciseModules: [WorkoutLogModel.ExersiseLogModule] {
        exersiseModules.filter { !$0.isLast }
    }
    struct ExeciseNameStruct: Identifiable {
        var name: String
        var id: Int
        var isRemoved: Bool
    }
    var exersiseModules: Array<WorkoutLogModel.ExersiseLogModule> {
        return workoutLogModel.exersiseModules
    }
    

    
//    func itemExists(withId id: Int) -> Bool {
//        return exersiseQueue.contains { $0.id == id }
//    }
//    


    
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
    
    func clearExerciseModules() {
        workoutLogModel.clearExerciseModules()
    }
    
    func addEmptySet(moduleID: Int){
        workoutLogModel.addEmptySet(moduleID: moduleID)
    }
    
    func addEmptyWorkoutModule(exerciseName: String, exerciseID: Int, ExersiseEquipment: String, restTime: Int) {
        workoutLogModel.addEmptyWorkoutModule(exerciseName: exerciseName, exerciseID: exerciseID, ExersiseEquipment: ExersiseEquipment, restTime: restTime)
       
        
       
    }
    

    func setExersiseModuleRPEDisplayStatus(exersiseID: Int, state: Bool) {
        workoutLogModel.setExersiseModuleRPEDisplayStatus(exersiseID: exersiseID, state: state)
    }
    
    func toggleExersiseModuleNotesDisplayStatus(exersiseID: Int) {
        workoutLogModel.toggleExersiseModuleNotesDisplayStatus(exersiseID: exersiseID)
    }
    func removeExersiseModule(exersiseID: UUID) {
        workoutLogModel.removeExersiseModule(exersiseID: exersiseID)
    }
    
    func setWorkoutTime(time: Int) {
        workoutLogModel.setWorkoutTime(time: time)
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
    
    func getUUIDindex(index : UUID) -> Int {
           if let index = exersiseModules.firstIndex(where: { $0.id == index }) {
               return index
           }
           else {
               print("get UUID index error")
               return 0
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
    func setTimePreset(time: Int) {
        workoutLogModel.setTimePreset(time: time)
    }
    
    func setTimeInWorkout(time: Int, ModuleID: Int) {
        workoutLogModel.setTimeInWorkout(time: time, exerciseID: ModuleID)
    }
    
    
    func toggleTime(){
        workoutLogModel.toggleTime()
    }
    func addToTime(step: Int){
        workoutLogModel.addToTime(step: step)
    }

    
    func deleteSet(moduleID: Int, rowID: Int, moduleUUID: UUID) {
        workoutLogModel.deleteSet(moduleID: moduleID, rowID: rowID, moduleUUID: moduleUUID)
    }
    func editRestTime(time: Int) {
        workoutLogModel.editRestTime(time: time)
    }
    
    func setPopUpState(state: Bool, popUpId: String) {
        workoutLogModel.setPopUpState(state: state, popUpId: popUpId)
    }
    func setPrevouslyChecked(exersiseModuleID : Int, RowID: Int, state: Bool) {
        workoutLogModel.setPrevouslyChecked(exersiseModuleID: exersiseModuleID, RowID: RowID, state: state)
    }
    func setPopUpCurrentRow(exersiseModuleID : Int, RowID: Int, popUpId: String, exerciseUUID: UUID) {
        workoutLogModel.setPopUpCurrentRow(exersiseModuleID: exersiseModuleID, RowID: RowID, popUpId: popUpId, exerciseUUID: exerciseUUID)
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
    


    

        
    
    func addExercisesFromQueue(exercises: [HomePageModel.Exersise]) {
        exercises.forEach { exercise in
            addEmptyWorkoutModule(exerciseName: exercise.exerciseName, exerciseID: exercise.id, ExersiseEquipment: exercise.exerciseEquipment, restTime: exercise.restTime)
        }

    }
    
    func saveExersiseModules() {
        workoutLogModel.saveExersiseModules()
    }
    func loadExersiseModules() {
        workoutLogModel.loadExersiseModules()
    }
    

    

}
