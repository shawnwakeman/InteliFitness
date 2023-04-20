import Foundation
import SwiftUI
struct WorkoutLogModel {
    private(set) var exercises: [Exersise] = Bundle.main.decode("Exercises.json")
    
    private(set) var exerciseQueue: [Exersise] = []
    
    
    
    private(set) var exersiseModules: [ExersiseLogModule] = []
    var workoutTime: WorkoutTime = WorkoutTime()
    var restTime : WorkoutTime = WorkoutTime(timeElapsed: 0, timePreset: 120)
    var popUps = [PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "popUpRPE"), PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "popUpDotsMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "popUpDataMetrics"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "DropDownMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "SetTimeSubMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "SetUnitSubMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "ExersisesPopUp"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "TimerCompletedPopUP")]
//    var popUpRPE = PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100)
    
   
    var lastRowChangedID: Int = 100
    var lastModuleChangedID: Int = 100
    var hidingPopUps = false
    
    mutating func setLastModule(index: Int) {
        lastModuleChangedID = index
    }
    
    mutating func setLastRow(index: Int) {
        lastRowChangedID = index
    }
//    init() {
//   
//    }
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
        let id: Int
        var displayingRPE: Bool = true
        var displayingNotes: Bool = false
        var ExersiseID: Int
        var ExersiseCatagory: String = ""
        var ExersiseEquipment: String

    }
    
    struct Exersise: Identifiable, Decodable {
        var exerciseName: String
        var exerciseCategory: [String]
        var exerciseEquipment: String
        let id: Int
        var selected: Bool = false
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

    
   
    

    func checkLetter(letter: String) -> Bool {
        for exercise in exercises {
            if let firstLetter = exercise.exerciseName.first {
                if String(firstLetter).uppercased() == letter.uppercased() {
                    return true
                }
            }
        }
        return false
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
    

   
    
    mutating func addEmptySet(moduleID: Int) {
        let lastRowIndex = exersiseModules[moduleID].setRows.count

            
        exersiseModules[moduleID].setRows.append(addEmptySetHelper(lastRowID: lastRowIndex))


    }
    
    mutating func setPrevouslyChecked(exersiseModuleID : Int, RowID: Int, state: Bool) {
        exersiseModules[exersiseModuleID].setRows[RowID].prevouslyChecked  = state
    }
    
    mutating func addEmptyWorkoutModule(exerciseName: String, exerciseID: Int, ExersiseEquipment: String) {
        let index = exersiseModules.count
        exersiseModules.append(ExersiseLogModule(exersiseName: exerciseName, setRows: [addEmptySetHelper(lastRowID: 0)], id: index, ExersiseID: exerciseID, ExersiseEquipment: ExersiseEquipment))
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
    mutating func setSelectionState(ExersiseID: Int) {
        exercises[ExersiseID].selected.toggle()
    }

    mutating func setRestTime(time: Int) {
        restTime.timeElapsed = time


        
    }
    
    mutating func setTimePreset(time: Int) {
        restTime.timePreset = time
    }
    mutating func restAddToTime(step: Int) {
  
        restTime.timeElapsed += step
     



        
    }
    mutating func setRemoved(exersiseID: Int) {
        // Stop views from accessing data by updating their state
        
        exersiseModules[exersiseID].isRemoved = true
       
    }
    
    
    mutating func addToExersiseQueue(exersiseID: Int) {
        exerciseQueue.append(exercises[exersiseID])
    }
    
    mutating func removeExersiseFromQueue(exersiseID: Int) {
        if let index = exerciseQueue.firstIndex(where: { $0.id == exersiseID }) {
            exerciseQueue.remove(at: index)
            print("Removed item")
        } else {
            print("No matching item found")
        }

    }
    
    mutating func clearToExersiseQueue() {
        exerciseQueue = []
        for index in exercises.indices {
 
   
            exercises[index].selected = false
        }
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
        restTime.backgroundTime = Date()
    }
    mutating func updateTimeToCurrent() {


        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        let currentDate = Date()
        let otherDate = workoutTime.backgroundTime // Creates a date one hour after the current date
        let otherDate2 = restTime.backgroundTime


        let timeDifference = currentDate.timeIntervalSince(otherDate)
        let timeDifference2 = currentDate.timeIntervalSince(otherDate2)
        workoutTime.timeElapsed += Int(timeDifference)
        restTime.timeElapsed -= Int(timeDifference2)

        
    }

}
