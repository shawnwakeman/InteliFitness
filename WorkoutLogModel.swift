import Foundation
import SwiftUI


struct WorkoutLogModel {

    

    
    private(set) var exersiseModules: [ExersiseLogModule] = []
 

    var replacingExercises = ReplacingExercises()
    var workoutTime: WorkoutTime = WorkoutTime()
    var restTime : WorkoutTime = WorkoutTime(timeElapsed: 0, timePreset: 120)
    var popUps = [
                PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "popUpRPE"),
                PopUpData(popUpRowIndex: 0, popUpExersiseModuleIndex: 0, popUPUUID: UUID(), id: "popUpDotsMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "popUpDataMetrics"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "DropDownMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "SetTimeSubMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "SetUnitSubMenu"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "ExersisesPopUp"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "TimerCompletedPopUP"),
                  PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "ReorderSets"),
                PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "TitlePagePopUp"),
                PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "SetMenuPopUp"),
                PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "TimerPopUp"),
                PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "PausePopUp"),
                PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "CancelPopUp"),
                PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, popUPUUID: UUID(), id: "FinishPopUp")
    ]
//    var popUpRPE = PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100)
    
   
    var lastRowChangedID: Int = 100
    var lastModuleChangedID: Int = 100
    var hidingPopUps = false
    
    struct ReplacingExercises {
        var replacing: Bool = false
        var indexToReplace: Int?
    }
    
    mutating func setLastModule(index: Int) {
        lastModuleChangedID = index
    }
    
    mutating func setLastRow(index: Int) {
        lastRowChangedID = index
    }
 
    mutating func setRowCompletionStatus(exersiseID: Int, RowID: Int, state: Bool) {
        exersiseModules[exersiseID].setRows[RowID].setCompleted = state
    }
    struct PopUpData: Identifiable, Equatable {
        var RPEpopUpState = false
        var popUpRowIndex: Int
        var popUpExersiseModuleIndex: Int
        var popUPUUID: UUID
        var id: String
    }
    
    enum moduleType: Int, Codable {
        case weightReps = 0
        case reps = 1
        case weightedReps = 2
        case assistedReps = 3
        case duration = 4
        case cardio = 5
    }
    
    struct ExersiseLogModule: Identifiable, Codable, Equatable {
        var exersiseName: String
        var setRows: [ExersiseSetRow]
        var id: UUID
        var displayingRPE: Bool = false
        var displayingNotes: Bool = false
        var ExersiseID: Int
        var ExersiseCatagory: String = ""
        var ExersiseEquipment: String
        var restTime: Int
        var isLast: Bool = false
        var DateCompleted: Date?
        var moduleType: moduleType
        var notes: String = ""
        var oldWorkoutId: UUID = UUID()

    }
    
    struct Exersise: Identifiable, Codable {
        var exerciseName: String
        var exerciseCategory: [String]
        var exerciseEquipment: String
        let id: Int
        var selected: Bool = false
        var restTime: Int
    }
    
    
    
    
    struct ExersiseSetRow: Identifiable, Codable, Equatable {
        var setIndex: Int
        var previousSet: String = "0"
        var weight: Float = 0
        var reps: Int = 0
        var weightPlaceholder: String = ""
        var repsPlaceholder: String = ""
        var setCompleted: Bool = false
        var rowSelected: Bool = false
        var repMetric: Float = 0
        var rpeTarget: Float = 0
        var prevouslyChecked: Bool = false
        var setType: String = "N"
        var id: Int
        
        
    }

    
//    func encodeExercises(_ exercises: [Exersise]) -> Data? {
//        let encoder = JSONEncoder()
//        do {
//            let data = try encoder.encode(exercises)
//            return data
//        } catch {
//            print("Error encoding exercises: \(error)")
//            return nil
//        }
//    }
//    func saveExercises(_ data: Data) {
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileURL = documentsURL.appendingPathComponent("Exercises.json")
//
//        do {
//            try data.write(to: fileURL, options: .atomic)
//        } catch {
//            print("Error saving exercises: \(error)")
//        }
//    }

    
    
    private func addEmptySetHelper(lastRowID: Int) -> ExersiseSetRow {
        return ExersiseSetRow(setIndex: (lastRowID + 1), id: (lastRowID))
    }
    
    struct WorkoutTime {
        var timeRunning: Bool = true
        var timeElapsed: Int = 0
        var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        var backgroundTime: Date = Date()
        var timePreset: Int = 0
        var timeStep = 1

    }
    
    struct PopUpStates {
        var DotsPopUpMenu = false
    }
    

   
    
    mutating func addEmptySet(moduleID: Int) {
        let lastRowIndex = exersiseModules[moduleID].setRows.count

            
        exersiseModules[moduleID].setRows.append(addEmptySetHelper(lastRowID: lastRowIndex))


    }
    
    mutating func loadWorkout(workout: HomePageModel.Workout) {
        workoutTime.timeElapsed = 0
        
        exersiseModules = workout.exercises
   
        
        
    }
    
    mutating func setPrevouslyChecked(exersiseModuleID : Int, RowID: Int, state: Bool) {
        exersiseModules[exersiseModuleID].setRows[RowID].prevouslyChecked  = state
    }
    
    mutating func addEmptyWorkoutModule(exerciseName: String, exerciseID: Int, ExersiseEquipment: String, restTime: Int, moduleType: moduleType) {

        exersiseModules.append(ExersiseLogModule(exersiseName: exerciseName, setRows: [addEmptySetHelper(lastRowID: 0)], id: UUID(), ExersiseID: exerciseID, ExersiseEquipment: ExersiseEquipment, restTime: restTime, moduleType: moduleType))
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
    
    mutating func setRepValuePlaceHolder(exersiseModuleID : Int, RowID: Int, value: String) {
        exersiseModules[exersiseModuleID].setRows[RowID].repsPlaceholder = value
    }
    
    mutating func setRepMetricPlaceHolder(exersiseModuleID : Int, RowID: Int, value: Float) {
        exersiseModules[exersiseModuleID].setRows[RowID].rpeTarget = value
    }
    
    mutating func setWeightValue(exersiseModuleID : Int, RowID: Int, value: Float) {
        
        exersiseModules[exersiseModuleID].setRows[RowID].weight = value
    }
    
    mutating func setExerciseModules(exericiesModules: [WorkoutLogModel.ExersiseLogModule]) {
        self.exersiseModules = exericiesModules
    }
    
    mutating func setWeightValuePlaceHolder(exersiseModuleID : Int, RowID: Int, value: String) {
        
        exersiseModules[exersiseModuleID].setRows[RowID].weightPlaceholder = value
    }
    mutating func addToTime(step: Int) {
        workoutTime.timeElapsed += step


        
    }
    
    mutating func setSetType(moduleId: Int, rowId: Int, setType: String) {
 
        exersiseModules[moduleId].setRows[rowId].setType = setType
    }


    mutating func setRestTime(time: Int) {
        restTime.timeElapsed = time
        restTime.timePreset = time


        
    }
    
    mutating func toggleReplacingExercise(state: Bool, index: Int) {
        replacingExercises.indexToReplace = index
        replacingExercises.replacing = state
    }
    
    mutating func editRestTime(time: Int) {
        restTime.timeElapsed = time
       

    }
    
    
    mutating func setTimePreset(time: Int) {
        restTime.timePreset = time
       

    }
    
    mutating func setTimeInWorkout(time: Int, exerciseID: Int) {
    

        exersiseModules[exerciseID].restTime = time
    }
    

    mutating func restAddToTime(step: Int) {
  
        restTime.timeElapsed += step
     



        
    }
    
    mutating func setTimeStep(step: Int) {
        workoutTime.timeStep = step
    }
    // dont save the shitters that have is last attached
    func saveExersiseModules() {
        let defaults = UserDefaults.standard

        do {
            let filterExerciseModules =  exersiseModules.filter { !$0.isLast }
            let encodedData = try JSONEncoder().encode(filterExerciseModules)
            defaults.set(encodedData, forKey: "exersiseModules")
        

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

    }

    
    mutating func saveTimers() {
        let defaults = UserDefaults.standard
        do {
            let time = try JSONEncoder().encode(Date())
            defaults.set(time, forKey: "workoutTime")
            
            let elapsedTime = try JSONEncoder().encode(workoutTime.timeElapsed)
            defaults.set(elapsedTime, forKey: "elapsedTime")
            

            defaults.set(elapsedTime, forKey: "elapsedRestTime")
            
            
            let restTime = try JSONEncoder().encode(Date())
            defaults.set(restTime, forKey: "restTime")
        } catch {
            print("Failed to encode time ")
        }

        
    }
    
    mutating func loadTimers() {
        
        let defaults = UserDefaults.standard
        
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


    

    
    mutating func setExerciseModule(index: Int, exerciseModule: WorkoutLogModel.ExersiseLogModule) {
        exersiseModules[index] = exerciseModule
    }

    

    

    
    mutating func deleteSet(moduleID: Int, rowID: Int, moduleUUID: UUID) {
        var currentSetRows = exersiseModules[moduleID].setRows
        if currentSetRows.count == 1 {
          
            removeExersiseModule(exersiseID: moduleUUID)
        } else {
            currentSetRows.remove(at: rowID)
            for (index, _) in currentSetRows.enumerated() {
                currentSetRows[index].id = index
                currentSetRows[index].setIndex = index + 1
            }
            exersiseModules[moduleID].setRows = currentSetRows
        }
        
    }
    
    
    mutating func removeExersiseModule(exersiseID: UUID) {
        // Stop views from accessing data by updating their state
     
        print("Removing exersise module with ID: \(exersiseID)")
        
        print("Current exersiseModules:")
        for (index, module) in exersiseModules.enumerated() {
            print("Index: \(index), ID: \(module.id), Name: \(module.exersiseName)")
        }
        
        if let index = exersiseModules.firstIndex(where: { $0.id == exersiseID }) {
            if exersiseModules[index] == exersiseModules.last {
                
                exersiseModules[index].isLast = true
            } else {
                exersiseModules.remove(at: index)
            }
          
        } else {
            print("Exersise module with ID: \(exersiseID) not found")
        }
        

        
        print("Updated exersiseModules:")
        for (index, module) in exersiseModules.enumerated() {
            print("Index: \(index), ID: \(module.id), Name: \(module.exersiseName) isLAst \(module.isLast)")
        }
      

    }

    
    mutating func reorderExercises(from source: IndexSet, to destination: Int) {
        exersiseModules.move(fromOffsets: source, toOffset: destination)
    }
    
    mutating func setExersiseModuleRPEDisplayStatus(exersiseID: Int, state: Bool) {
        exersiseModules[exersiseID].displayingRPE.toggle()
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
    

    
    mutating func setPopUpCurrentRow(exersiseModuleID: Int, RowID: Int, popUpId: String, exerciseUUID: UUID) {
        if let popUpIndex = popUps.firstIndex(where: {$0.id == popUpId}) {
            popUps[popUpIndex].popUpExersiseModuleIndex = exersiseModuleID
            popUps[popUpIndex].popUpRowIndex = RowID
            popUps[popUpIndex].popUPUUID = exerciseUUID
        }

    }
}
