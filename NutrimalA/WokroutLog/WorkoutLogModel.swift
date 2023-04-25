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
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "TimerCompletedPopUP"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "ReorderSets")
    ]
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
    init() {
        
    }
    mutating func setRowCompletionStatus(exersiseID: UUID, RowID: Int, state: Bool) {
        if let index = exersiseModules.firstIndex(where: { $0.id == exersiseID }) {
            exersiseModules[index].setRows[RowID].setCompleted = state
        }
      
    }
    struct PopUpData: Identifiable {
        var RPEpopUpState = false
        var popUpRowIndex: Int
        var popUpExersiseModuleIndex: Int
        var id: String
    }
    
    struct ExersiseLogModule: Identifiable, Codable {
        var exersiseName: String
        var setRows: [ExersiseSetRow]
        var isRemoved: Bool = false
        let id: UUID
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
    
    
    

    struct ExersiseSetRow: Identifiable, Codable {
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
      
        exersiseModules.append(ExersiseLogModule(exersiseName: exerciseName, setRows: [addEmptySetHelper(lastRowID: 0)], id: UUID(), ExersiseID: exerciseID, ExersiseEquipment: ExersiseEquipment))
    }
    
    mutating func toggleCompletedSet(ExersiseModuleID: UUID, RowID: Int) {
        if let index = exersiseModules.firstIndex(where: { $0.id == ExersiseModuleID }) {
            exersiseModules[index].setRows[RowID].setCompleted.toggle()
        }

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
    
    mutating func setWorkoutTime(time: Int) {
        workoutTime.timeElapsed = time
    }
    mutating func restAddToTime(step: Int) {
  
        restTime.timeElapsed += step
     



        
    }
    
    func saveExersiseModules() {
        let defaults = UserDefaults.standard

        do {
            let encodedData = try JSONEncoder().encode(exersiseModules)
            defaults.set(encodedData, forKey: "exersiseModules")
            let time = try JSONEncoder().encode(Date())
            defaults.set(time, forKey: "workoutTime")
            
            let elapsedTime = try JSONEncoder().encode(workoutTime.timeElapsed)
            defaults.set(elapsedTime, forKey: "elapsedTime")
            
  
            defaults.set(elapsedTime, forKey: "elapsedRestTime")
            
            
            let restTime = try JSONEncoder().encode(Date())
            defaults.set(restTime, forKey: "restTime")

        } catch {
            print("Failed to encode exersiseModules: \(error.localizedDescription)")
        }
    }

    mutating func loadExersiseModules() {
        let defaults = UserDefaults.standard

        if let savedData = defaults.object(forKey: "exersiseModules") as? Data {
            do {
                exersiseModules = try JSONDecoder().decode([ExersiseLogModule].self, from: savedData)
                
            } catch {
                print("Failed to decode exersiseModules: \(error.localizedDescription)")
            }
        }
        
        if let savedData = defaults.object(forKey: "workoutTime") as? Data {
            if let elapsedTime = defaults.object(forKey: "elapsedTime") as? Data {
                do {
                    let oldTime = try JSONDecoder().decode(Date.self, from: savedData)
                    let timeDifference = Date().timeIntervalSince(oldTime)
                    let elaptime = try JSONDecoder().decode(Int.self, from: elapsedTime)
                    workoutTime.timeElapsed = Int(timeDifference) + elaptime
           
                    print("loaded data")
                    
                } catch {
                    print("Failed to decode workoutTime : \(error.localizedDescription)")
                }
            }

        }
        
        if let savedData = defaults.object(forKey: "restTime") as? Data {
    
            do {
                let oldTime = try JSONDecoder().decode(Date.self, from: savedData)
                let timeDifference = Date().timeIntervalSince(oldTime)

                restTime.timeElapsed -= Int(timeDifference)
                
                print("loaded data")
                
            } catch {
                print("Failed to decode rest time: \(error.localizedDescription)")
            }
         
        }
    }

    
    
    mutating func setRemoved(exersiseID: Int) {
        // Stop views from accessing data by updating their state
        
        exersiseModules[exersiseID].isRemoved = true
       
    }
    
    mutating func clearExerciseModules() {
        exersiseModules = []
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
    
    mutating func reorderExercises(from source: IndexSet, to destination: Int) {
            exersiseModules.move(fromOffsets: source, toOffset: destination)
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
}
