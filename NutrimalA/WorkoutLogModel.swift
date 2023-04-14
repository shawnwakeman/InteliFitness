import Foundation
import SwiftUI
struct WorkoutLogModel {
    
    private(set) var exersiseModules: [ExersiseLogModule] = []
    var workoutTime: WorkoutTime = WorkoutTime()
    var restTime : WorkoutTime = WorkoutTime(timeElapsed: 0, timePreset: 120)
    var popUps = [PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "popUpRPE"), PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "popUpDotsMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "popUpDataMetrics"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "DropDownMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "SetTimeSubMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "SetUnitSubMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "ExersisesPopUp")]
//    var popUpRPE = PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100)
    
    
    var lastRowChangedID: Int = 0
    var lastModuleChangedID: Int = 0
    var hidingPopUps = false
    
    mutating func setLastModule(index: Int) {
        lastModuleChangedID = index
    }
    
    mutating func setLastRow(index: Int) {
        lastRowChangedID = index
    }
    
    mutating func setRowCompletionStatus(exersiseID: Int, RowID: Int, state: Bool) {
        exersiseModules[exersiseID].setRows[RowID].setCompleted = state
    }
    struct PopUpData: Identifiable {
        var RPEpopUpState = false
        var popUpRowIndex: Int
        var popUpExersiseModuleIndex: Int
        var id: String
    }
    
    struct ExersiseLogModule: Identifiable {
        var exersiseName: String
        var setRows: [ExersiseSetRow]
        var isRemoved: Bool = false
        var id: Int
        var displayingRPE: Bool = true
        var displayingNotes: Bool = false
    }
    
    struct ExersiseSetRow: Identifiable {
        var setIndex: Int
        var previousSet: String = "0"
        var weight: Float = 0
        var reps: Int = 0
        var weightPlaceholder: String = ""
        var repsPlaceholder: String = ""
        var setCompleted: Bool = false
        var rowSelected: Bool = false
        var repMetric: Float = 0
        var prevouslyChecked: Bool = false
        let id: Int
        
    }
    
    private func addEmptySetHelper(lastRowID: Int) -> ExersiseSetRow {
        return ExersiseSetRow(setIndex: (lastRowID + 1), id: (lastRowID))
    }
    
    struct WorkoutTime {
        var timeRunning: Bool = true
        var timeElapsed: Int = 0
        var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        var backgroundTime: Date = Date()
        var timePreset: Int = 0
    }
    
    struct PopUpStates {
        var DotsPopUpMenu = false
    }
    

    init() {
        addEmptyWorkoutModule()
    }
    
    mutating func addEmptySet(moduleID: Int) {
        let lastRowIndex = exersiseModules[moduleID].setRows.count

            
        exersiseModules[moduleID].setRows.append(addEmptySetHelper(lastRowID: lastRowIndex))


    }
    
    mutating func setPrevouslyChecked(exersiseModuleID : Int, RowID: Int, state: Bool) {
        exersiseModules[exersiseModuleID].setRows[RowID].prevouslyChecked  = state
    }
    
    mutating func addEmptyWorkoutModule() {
        let index = exersiseModules.count
        exersiseModules.append(ExersiseLogModule(exersiseName: "Back Squat", setRows: [addEmptySetHelper(lastRowID: 0)], id: index))
    }
    
    mutating func toggleCompletedSet(ExersiseModuleID: Int, RowID: Int) {
        exersiseModules[ExersiseModuleID].setRows[RowID].setCompleted.toggle()
    }
    
    mutating func toggleTime() {
        workoutTime.timeRunning.toggle()
    }
    mutating func setRepValue(exersiseModuleID : Int, RowID: Int, value: Int) {
        exersiseModules[exersiseModuleID].setRows[RowID].reps = value
    }
    mutating func setWeightValue(exersiseModuleID : Int, RowID: Int, value: Float) {
        exersiseModules[exersiseModuleID].setRows[RowID].weight = value
    }
    mutating func addToTime(step: Int) {
        workoutTime.timeElapsed += step


        
    }
    mutating func setRestTime(time: Int) {
        restTime.timeElapsed = time


        
    }
    mutating func restAddToTime(step: Int) {
        restTime.timeElapsed += step


        
    }
    mutating func setRemoved(exersiseID: Int) {
        // Stop views from accessing data by updating their state
        
        exersiseModules[exersiseID].isRemoved = true
       
    }
    
    mutating func removeExersiseModule(exersiseID: Int) {
        // Stop views from accessing data by updating their state
        
        exersiseModules.remove(at: exersiseID)
       
    }
    mutating func setExersiseModuleRPEDisplayStatus(exersiseID: Int, state: Bool) {
        exersiseModules[exersiseID].displayingRPE = state
    }
    mutating func toggleExersiseModuleNotesDisplayStatus(exersiseID: Int) {
        exersiseModules[exersiseID].displayingNotes.toggle()
    }
    mutating func hidPopUps(toggle: Bool) {
        hidingPopUps = toggle
    }
    
    mutating func setPopUpState(state: Bool, popUpId: String) {
        if let popUpIndex = popUps.firstIndex(where: {$0.id == popUpId}) {
            popUps[popUpIndex].RPEpopUpState = state

        }
    }
    mutating func setRepMetric (exersiseModuleID: Int, RowID: Int, RPE: Float) {
        exersiseModules[exersiseModuleID].setRows[RowID].repMetric = RPE
    }
    
    mutating func setPopUpCurrentRow(exersiseModuleID: Int, RowID: Int, popUpId: String) {
        if let popUpIndex = popUps.firstIndex(where: {$0.id == popUpId}) {
            popUps[popUpIndex].popUpExersiseModuleIndex = exersiseModuleID
            popUps[popUpIndex].popUpRowIndex = RowID
        }

    }
    
    mutating func saveBackgroundTime() {
        
        workoutTime.backgroundTime = Date()
        
    }
    mutating func updateTimeToCurrent() {


        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        let currentDate = Date()
        let otherDate = workoutTime.backgroundTime // Creates a date one hour after the current date

//        let currentDateString = dateFormatter.string(from: currentDate)
//        let otherDateString = dateFormatter.string(from: otherDate)
//
//        print("Current date and time: \(currentDateString)")
//        print("Other date and time: \(otherDateString)")

        let timeDifference = currentDate.timeIntervalSince(otherDate)
        workoutTime.timeElapsed += Int(timeDifference)
//        print("The time difference between the current date and the other date is \(timeDifference) seconds.")
        
    }

    

}
