//
//  WorkoutLogViewModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/29/23.
//

import SwiftUI


class WorkoutLogViewModel: ObservableObject {
    
    @Published var workoutName: String = ""
    @Published var workoutNotes: String = ""
    private static func createWorkoutLogModel() -> WorkoutLogModel{
        WorkoutLogModel()
    }
    
    @Published var testChange: Bool = false
    
    @Published var workoutLogModel = WorkoutLogModel()
    
    @Published var displayingExerciseView: Bool = false
    
    @Published var displayingExerciseViewForCreator: Bool = false
    
    @Published var displayingExerciseViewOnWorkout : Bool = false
    
    func resetWorkoutModel() {
        testChange.toggle()
        workoutLogModel = WorkoutLogModel()
    }
    
    func loadWorkout(workout: HomePageModel.Workout) {
        workoutLogModel.loadWorkout(workout: workout)
    }
    

    @Published var popUpStates = ["3DotsPopUp": false, "DataMetricsPopUp": false, "key3": true]
    
    @Published var exerciseNames: [ExeciseNameStruct] = []
    
  
    func relocate(from source: IndexSet, to destination: Int) {
        workoutLogModel.reorderExercises(from: source, to: destination)
    }
    
    var filteredExerciseModules: [WorkoutLogModel.ExersiseLogModule] {
        exersiseModules.filter { !$0.isLast }
    }
    
    var replacingExercise: WorkoutLogModel.ReplacingExercises {
        workoutLogModel.replacingExercises
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


    func setExerciseModules(exericiesModules: [WorkoutLogModel.ExersiseLogModule], name: String) {
        workoutName = name

        workoutLogModel.setExerciseModules(exericiesModules: exericiesModules)
    }
    
//    var workoutTime: WorkoutLogModel.WorkoutTime {
//        return workoutLogModel.workoutTime
//
//    }
    
//    var restTime: WorkoutLogModel.WorkoutTime {
//        return workoutLogModel.restTime
//
//    }
    var lastModuleUsed: Int {
        return workoutLogModel.lastModuleChangedID
    
    }
    var lastRowUsed: Int {
        return workoutLogModel.lastRowChangedID
    
    }
    
    func setLastModule(index: Int) {
        print(index)
        workoutLogModel.setLastModule(index: index)
    }
    
    func setLastRow(index: Int) {
        print(index)
        workoutLogModel.setLastRow(index: index)
    }
    

    
    func getPopUp(popUpId: String) -> WorkoutLogModel.PopUpData {
        
        if let popUpIndex = workoutLogModel.popUps.firstIndex(where: {$0.id == popUpId}) {
            return workoutLogModel.popUps[popUpIndex]
        }
        else {
            print("did not find pop up\(popUpId)")
            return workoutLogModel.popUps[0] // needs to be fixed
        }

    }
    

    

    
  
    
    // MARK: - Intent(s)
    
//    func setTimeStep(step: Int) {
//        workoutLogModel.setTimeStep(step: step)
//    }
//
    func setExerciseModule(index: Int, exerciseModule: WorkoutLogModel.ExersiseLogModule) {
        workoutLogModel.setExerciseModule(index: index, exerciseModule: exerciseModule)
    }
    
    func addEmptySet(moduleID: Int){
        workoutLogModel.addEmptySet(moduleID: moduleID)
    }
    
    func addEmptyWorkoutModule(exerciseName: String, exerciseID: Int, ExersiseEquipment: String, restTime: Int, moduleType: WorkoutLogModel.moduleType) {
        workoutLogModel.addEmptyWorkoutModule(exerciseName: exerciseName, exerciseID: exerciseID, ExersiseEquipment: ExersiseEquipment, restTime: restTime, moduleType: moduleType)
       
        
       
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
    
//    func setWorkoutTime(time: Int) {
//        workoutLogModel.setWorkoutTime(time: time)
//    }
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
    
//    func restAddToTime(step: Int, time: Int? = nil) {
//        if let time = time {
//
//            workoutLogModel.setRestTime(time: time)
//
//        } else {
//            // Toggle the current display status if no custom value was provided
//            workoutLogModel.restAddToTime(step: step)
//        }
//
//    }
//    func setTimePreset(time: Int) {
//        workoutLogModel.setTimePreset(time: time)
//    }
//
    func setTimeInWorkout(time: Int, ModuleID: Int) {
        workoutLogModel.setTimeInWorkout(time: time, exerciseID: ModuleID)
    }
    
    
//    func toggleTime(){
//        workoutLogModel.toggleTime()
//    }
//    func addToTime(step: Int){
//        workoutLogModel.addToTime(step: step)
//    }
//
//
    func deleteSet(moduleID: Int, rowID: Int, moduleUUID: UUID) {
        workoutLogModel.deleteSet(moduleID: moduleID, rowID: rowID, moduleUUID: moduleUUID)
    }
//    func editRestTime(time: Int) {
//        workoutLogModel.editRestTime(time: time)
//    }
    
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
    func setRepMetricPlaceHolder(exersiseModuleID : Int, RowID: Int, value: Float) {
        workoutLogModel.setRepMetricPlaceHolder(exersiseModuleID: exersiseModuleID, RowID: RowID, value: value)
    }
    
    func setRepValuePlaceHolder(exersiseModuleID : Int, RowID: Int, value: String) {
        workoutLogModel.setRepValuePlaceHolder(exersiseModuleID: exersiseModuleID, RowID: RowID, value: value)
    }
    func setWeightValue(exersiseModuleID : Int, RowID: Int, value: Float) {
        workoutLogModel.setWeightValue(exersiseModuleID: exersiseModuleID, RowID: RowID, value: value)
    }
    
    func setWeightValuePlaceHolder(exersiseModuleID : Int, RowID: Int, value: String) {
        workoutLogModel.setWeightValuePlaceHolder(exersiseModuleID: exersiseModuleID, RowID: RowID, value: value)
    }
    


    func toggleReplacingExercise(state: Bool, index: Int) {
        workoutLogModel.toggleReplacingExercise(state: state, index: index)
 
    }

        
    
    func addExercisesFromQueue(exercises: [HomePageModel.Exersise]) {
        exercises.forEach { exercise in
            print(exercise.moduleType)
            addEmptyWorkoutModule(exerciseName: exercise.exerciseName, exerciseID: exercise.id, ExersiseEquipment: exercise.exerciseEquipment, restTime: exercise.restTime, moduleType: exercise.moduleType)
        }

    }
    
    func saveExersiseModules() {
        workoutLogModel.saveExersiseModules()
    }
    func loadExersiseModules() {
        workoutLogModel.loadExersiseModules()
    }
    
//    func saveTimers() {
//        workoutLogModel.saveTimers()
//    }
//
//    func loadTimers() {
//        workoutLogModel.loadTimers()
//    }
    
    func setSetType(moduleId: Int, rowId: Int, setType: String) {

        workoutLogModel.setSetType(moduleId: moduleId, rowId: rowId, setType: setType)
    }
    
    func getPreviousSetString(for row: WorkoutLogModel.ExersiseSetRow, in exercise: HomePageModel.Exersise) -> String {

        guard let mostRecent = exercise.exerciseHistory.last else {
            return "0"
        }
     
        if row.id < mostRecent.setRows.count {
            let prevRow = mostRecent.setRows[row.id]
            if mostRecent.moduleType == WorkoutLogModel.moduleType.weightedReps {
                if prevRow.weight != 0 {
                    return "+\(prevRow.weight.clean) x \(prevRow.reps) @ \(prevRow.repMetric.clean)"
                } else {
                    if prevRow.repMetric != 0 {
                        return "\(prevRow.reps) reps @ \(prevRow.repMetric.clean)"
                    } else {
                        return "\(prevRow.reps) reps"
                    }
                    
                }
            } else if (mostRecent.moduleType == WorkoutLogModel.moduleType.assistedReps) {
                if prevRow.weight != 0 {
                    if prevRow.repMetric != 0 {
                        return "-\(prevRow.weight.clean) x \(prevRow.reps) @ \(prevRow.repMetric.clean)"
                    } else {
                        return "-\(prevRow.weight.clean) x \(prevRow.reps)"
                    }
             
                    
               
                } else {
                    if prevRow.repMetric != 0 {
                        return "\(prevRow.reps) reps @ \(prevRow.repMetric.clean)"
                    } else {
                        return "\(prevRow.reps) reps"
                    }
                    
                }
            } else if (mostRecent.moduleType == WorkoutLogModel.moduleType.cardio) {
                return "\(prevRow.weight.clean) mi in \(formatTime(minutesSeconds: prevRow.reps))"

                
            } else if (mostRecent.moduleType == WorkoutLogModel.moduleType.duration) {
                print(prevRow.reps)
                return "\(formatTime(minutesSeconds: prevRow.reps))"
                
     
           
            } else if (mostRecent.moduleType == WorkoutLogModel.moduleType.reps) {
                
                if prevRow.repMetric != 0 {
                    return "\(prevRow.reps) reps @ \(prevRow.repMetric.clean)"
                } else {
                    return "\(prevRow.reps) reps"
                }
                    
                
            } else {
                if prevRow.repMetric != 0 {
                    return "\(prevRow.weight.clean) x \(prevRow.reps) @ \(prevRow.repMetric.clean)"
                } else {
                    return "\(prevRow.weight.clean) x \(prevRow.reps)"
                }
            }
           
        }
        
        return "0"
    }
    
    func SetPlaceHolders(for row: WorkoutLogModel.ExersiseSetRow, in exercise: HomePageModel.Exersise, moduleId: Int) {
        guard let mostRecent = exercise.exerciseHistory.last else {
            return
        }
   
    

       
 
        if row.id < mostRecent.setRows.count {
            let rowData = mostRecent.setRows[row.id]
            setSetType(moduleId: moduleId, rowId: row.id, setType: rowData.setType)
            if exersiseModules[moduleId].setRows[row.id].weightPlaceholder == "" {
                workoutLogModel.setWeightValuePlaceHolder(exersiseModuleID: moduleId , RowID: row.id, value: rowData.weight.clean)
            }
            if exersiseModules[moduleId].setRows[row.id].repsPlaceholder == "" {
                workoutLogModel.setRepValuePlaceHolder(exersiseModuleID: moduleId, RowID:  row.id, value: String(rowData.reps))
            }
            
            if row.repsPlaceholder == "" {
                workoutLogModel.setRepMetricPlaceHolder(exersiseModuleID: moduleId , RowID: row.id, value: Float(rowData.repMetric))
            }

          
           
        } else if (row.id - 1) >= 0 {
            let module = exersiseModules[moduleId]
            print("2")
            let oldRow = module.setRows[row.id - 1]
            if oldRow.reps != 0 {
                workoutLogModel.setRepValuePlaceHolder(exersiseModuleID: moduleId, RowID:  row.id, value: String(oldRow.reps))
            }
            if oldRow.weight != 0 {
                workoutLogModel.setWeightValuePlaceHolder(exersiseModuleID: moduleId, RowID: row.id, value: oldRow.weight.clean)
            }
        }
    }
}


extension WorkoutLogViewModel {
    func exerciseModule(at index: Int) -> WorkoutLogModel.ExersiseLogModule? {
        if index >= 0 && index < exersiseModules.count {
            return exersiseModules[index]
        } else {
            return nil
        }
    }
}
