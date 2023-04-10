import Foundation

struct WorkoutLogModel {
    
    private(set) var exersiseModules: [ExersiseLogModule] = []
    var workoutTime: WorkoutTime = WorkoutTime()
    var popUps = [PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "popUpRPE"), PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "popUpDotsMenu"),
        PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "popUpDataMetrics"),
        PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100, id: "DropDownMenu")]
//    var popUpRPE = PopUpData(popUpRowIndex: 100, popUpExersiseModuleIndex: 100)
    var hidingPopUps = false
    
    
    struct PopUpData: Identifiable {
        var RPEpopUpState = false
        var popUpRowIndex: Int
        var popUpExersiseModuleIndex: Int
        var id: String
    }
    
    struct ExersiseLogModule: Identifiable {
        var exersiseName: String
        var setRows: [ExersiseSetRow]
        var id: Int
    }
    
    struct ExersiseSetRow: Identifiable {
        var setIndex: Int
        var previousSet: String
        var weight: Float
        var reps: Int
        var weightPlaceholder: String
        var repsPlaceholder: String
        var setCompleted: Bool
        var rowSelected: Bool
        var repMetric: Float
        let id: Int
    }
    
    struct WorkoutTime {
        var timeRunning: Bool = true
        var timeElapsed: Int = 0
        var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        var backgroundTime: Date = Date()
    }
    
    struct PopUpStates {
        var DotsPopUpMenu = false
    }
    

    init() {
        exersiseModules.append(ExersiseLogModule(exersiseName: "Back Squat", setRows: [ExersiseSetRow(setIndex: 1, previousSet: "0", weight: 0, reps: 0, weightPlaceholder: "", repsPlaceholder: "99", setCompleted: false, rowSelected: false, repMetric: 7, id: 0), ExersiseSetRow(setIndex: 2, previousSet: "0", weight: 0, reps: 0, weightPlaceholder: "", repsPlaceholder: "99", setCompleted: false, rowSelected: false, repMetric: 07, id: 1)], id: 0))
    }
    
    mutating func addEmptySet(moduleID: Int) {
        let lastRowIndex = exersiseModules[moduleID].setRows.count
        exersiseModules[moduleID].setRows.append(addEmptySetHelper(lastRowID: lastRowIndex))
    }
    
    mutating func addEmptyWorkoutModule() {
        let index = exersiseModules.count
        exersiseModules.append(ExersiseLogModule(exersiseName: "Back Squat", setRows: [], id: index))
    }
    
    mutating func toggleCompletedSet(ExersiseModuleID: Int, RowID: Int) {
        exersiseModules[ExersiseModuleID].setRows[RowID].setCompleted.toggle()
    }
    
    mutating func toggleTime() {
        workoutTime.timeRunning.toggle()
    }
    
    mutating func addToTime() {
        workoutTime.timeElapsed += 1


        
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

    
    private func addEmptySetHelper(lastRowID: Int) -> ExersiseSetRow {
        return ExersiseSetRow(setIndex: (lastRowID + 1), previousSet: "0", weight: 0, reps: 0, weightPlaceholder: "", repsPlaceholder: "", setCompleted: false, rowSelected: false, repMetric: 0, id: (lastRowID))
    }
}
