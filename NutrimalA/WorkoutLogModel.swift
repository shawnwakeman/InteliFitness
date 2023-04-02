import Foundation

struct WorkoutLogModel {
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
        var repMetric: Int
        let id: Int
    }
    
    struct WorkoutTime {
        var timeRunning: Bool = true
        var timeElapsed: Int = 0
        var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    private(set) var exersiseModules: [ExersiseLogModule] = []
    var workoutTime: WorkoutTime = WorkoutTime()
    
    init() {
        exersiseModules.append(ExersiseLogModule(exersiseName: "Back Squat", setRows: [ExersiseSetRow(setIndex: 1, previousSet: "0", weight: 0, reps: 0, weightPlaceholder: "", repsPlaceholder: "99", setCompleted: false, rowSelected: false, repMetric: 7, id: 0)], id: 0))
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
    
    private func addEmptySetHelper(lastRowID: Int) -> ExersiseSetRow {
        return ExersiseSetRow(setIndex: (lastRowID + 1), previousSet: "0", weight: 0, reps: 0, weightPlaceholder: "", repsPlaceholder: "", setCompleted: false, rowSelected: false, repMetric: 2, id: (lastRowID))
    }
}
