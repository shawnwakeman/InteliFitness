//
//  WorkoutLogViewModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/29/23.
//

import SwiftUI

import PolynomialRegressionSwift
class HomePageViewModel: ObservableObject {
    
    private static func createHomePageModel() -> HomePageModel {
        HomePageModel()
    }
    
    @Published var showingExercises: Bool = false
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
    
    var myWorkouts: [HomePageModel.Workout] {
        return homePageModel.myExercises
    }
    
    
    var exersises: Array<HomePageModel.Exersise> {
        return homePageModel.exercises
    }

    func setWorkoutLogModuleStatus(state: Bool) {
        homePageModel.setWorkoutLogModuleStatus(state: state)
    }
    
    func saveOngoingWorkoutStatus(status: Bool) {
        homePageModel.saveOngoingWorkoutStatus(status: status)
    }
    
    func loadOngoingWorkoutStatus() {
        homePageModel.loadOngoingWorkoutStatus()
        
    }
    
//    func toggleReplacingExercise(status: Bool) {
//        replacingExercise.toggle()
//    }
    
    
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
    
    func loadMyExercises() {
        homePageModel.loadMyExercises()

    }
    
    func saveMyWorkouts() {
        homePageModel.saveMyWorkouts()
    }
    
    func addToMyWorkouts(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        homePageModel.addToMyExercises(workoutName: workoutName, exersiseModules: exersiseModules)
    }
//    func addToexercise

    // MARK: - Schedule
    
    @Published private(set) var schedule: Schedule = Schedule()
    
    func addWorkout(to date: Date, workout: ScheduleWorkout, recurringOption: Schedule.RecurringOption) {
        schedule.addWorkout(to: date, workout: workout, recurringOption: recurringOption)
    }
    
    func removeRecurringWorkouts(workoutID: Int, recurringID: Int) {
        schedule.removeRecurringWorkouts(workoutID: workoutID, recurringID: recurringID)
    }
    
    func removeWorkout(from date: Date, workoutID: Int) {
        schedule.removeWorkout(from: date, workoutID: workoutID)
    }
    
    func getWorkouts(for date: Date) -> [ScheduleWorkout]? {
        return schedule.getWorkouts(for: date)
    }
    
    func addToWorkoutQueue(workout: HomePageModel.Workout) {
        schedule.addToWorkoutQueue(workout: workout)
    }
    
    func clearWorkoutQueue() {
        schedule.clearWorkoutQueue()
    }
    
    func saveSchedule() {
    
        schedule.saveSchedule()
    }

    
    func loadSchedule() {
        schedule.loadSchedule()
    }
    
    private func startOfDay(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components) ?? date
    }
    
    func upcomingWorkout() -> ScheduleWorkout? {
        let currentDate = Date()
        let startOfDayCurrentDate = startOfDay(for: currentDate)
        let sortedWorkouts = schedule.workouts.sorted(by: { $0.key < $1.key })
    
        for (date, workoutArray) in sortedWorkouts {
            if date > startOfDayCurrentDate {
                for workout in workoutArray {
                    if workout.HasBeenDone == false {
                        return workout
                    }
                }
                
               
            } else if date == startOfDayCurrentDate {
                for workout in workoutArray {
                    if workout.time >= currentDate {
                  
                        if workout.HasBeenDone == false {
                            return workout
                        }
                    }
                    
                }
        
            }
        }

        // If no upcoming workouts are found, check for a workout within an hour
        let oneHourLater = currentDate.addingTimeInterval(3600)
        let startOfDayOneHourLater = startOfDay(for: oneHourLater)
        if let workoutArray2 = sortedWorkouts.first(where: { $0.key == startOfDayCurrentDate })?.value {
            print(workoutArray2)
            for workout in workoutArray2 {
                if workout.time <= oneHourLater {
              
                    if workout.HasBeenDone == false {
                        return workout
                    }
                }
                
            }
        }
           
        
        


     
        return nil
    }
    
    func upcomingWorkoutAndRemove() -> ScheduleWorkout? {
        let currentDate = Date()
        let startOfDayCurrentDate = startOfDay(for: currentDate)
        let sortedWorkouts = schedule.workouts.sorted(by: { $0.key < $1.key })
        
        for (date, workoutArray) in sortedWorkouts {
            if date > startOfDayCurrentDate {
                for (index, workout) in workoutArray.enumerated() {
                    if workout.HasBeenDone == false {
                        schedule.workouts[date]?[index].HasBeenDone = true
                        return workout
                    }
                }
                
               
            } else if date == startOfDayCurrentDate {
                for (index, workout) in workoutArray.enumerated() {
                    if workout.time >= currentDate {
                  
                        if workout.HasBeenDone == false {
                            schedule.workouts[date]?[index].HasBeenDone = true
                            return workout
                        }                    }
                    
                }
        
            }
        }


        // If no upcoming workouts are found, check for a workout within an hour
        let oneHourLater = currentDate.addingTimeInterval(3600)
        let startOfDayOneHourLater = startOfDay(for: oneHourLater)
       
        
        if let workoutArray = sortedWorkouts.first(where: { $0.key == startOfDayCurrentDate })?.value {
          
            for (index, workout) in workoutArray.enumerated() {
                if workout.time <= oneHourLater {
              
                    if workout.HasBeenDone == false {
                        schedule.workouts[startOfDayOneHourLater]?[index].HasBeenDone = true
                        return workout
                    }
                }
                
            }
        }

        return nil
    }
   
    @Published private(set) var chartData: exerciseChartDataModel = exerciseChartDataModel()
    
    func setExerciseChartData(volume: [Double], heaviestWeight: [Double], Projected1RM: [Double], BestSetVolume: [Double], TotalReps: [Double], WeightPerRep: [Double], WorkoutFrequency: [Double], exercise: HomePageModel.Exersise) {
        if !volume.isEmpty {
            let preparedVolume = prepareData(viewCounts: volume, exercise: exercise)
            let preparedHeaviestWeight = prepareData(viewCounts: heaviestWeight, exercise: exercise)
            let preparedProjected1RM = prepareData(viewCounts: Projected1RM, exercise: exercise)
            let preparderBestSetVolume = prepareData(viewCounts: BestSetVolume, exercise: exercise)
            let preparedTotalReps = prepareData(viewCounts: TotalReps, exercise: exercise)
            let preparedWeightPerRep = prepareData(viewCounts: WeightPerRep, exercise: exercise)
            let preparedFrequency = prepareData(viewCounts: WorkoutFrequency, exercise: exercise)
            chartData.setData(volume: preparedVolume, heaviestWeight: preparedHeaviestWeight, Projected1RM: preparedProjected1RM, bestSetVolume: preparderBestSetVolume, TotalReps: preparedTotalReps, WeightPerRep: preparedWeightPerRep, LastMonthFreq: preparedFrequency)
        }
       
    }
    
    func clearData() {
        chartData.clearData()
    }
    
    func prepareData(viewCounts: [Double], exercise: HomePageModel.Exersise) -> [SiteView] {


        var startDate = (exercise.exerciseHistory.first?.DateCompleted)!
        var endDate = (exercise.exerciseHistory.last?.DateCompleted)!
       
        startDate = startDate.updateDay(value: 0)
        endDate = endDate.updateDay(value: 1)
        
        
        return generateSiteViews(startDate: startDate, endDate: endDate, viewCounts: viewCounts)
        
    }

    func GetBestFitLine(data: [SiteView], exercise: HomePageModel.Exersise) -> [SiteView] {
        
//
        var startDate = (exercise.exerciseHistory.first?.DateCompleted)!
        var endDate = (exercise.exerciseHistory.last?.DateCompleted)!
       
        startDate = startDate.updateDay(value: 0)
        endDate = endDate.updateDay(value: 1)
        
        
        let cgPoints = convertToCGPoints(data: data)
        
        let regression = PolynomialRegression.regression(withPoints: cgPoints, degree: 1)

        let extrapolatedXValues: [CGFloat] = []

        let bestFitLine = calculateBestFitLine(points: cgPoints, coefficients: getCoefficients(regression: regression), extrapolatedXValues: extrapolatedXValues)

        let lineOfBestFitData: [Double] = getYValues(from: bestFitLine)

        return generateSiteViews(startDate: startDate, endDate: endDate, viewCounts: lineOfBestFitData)
        
    }
    func calculateOneRepMax(weight: Double, reps: Int) -> Double {
        return weight * (1 + 0.0333 * Double(reps))
    }
    
    func getVolumeData(exerciseHistory: [WorkoutLogModel.ExersiseLogModule]) -> [Double]? {
        var volumeByDate: [Date: Double] = [:]

        for exercise in exerciseHistory {
            if let exerciseDateFinished = exercise.DateCompleted {
                let calendar = Calendar.current
                let exerciseDate = calendar.startOfDay(for: exerciseDateFinished) // Set the time component to 00:00:00

                var totalVolumeForDate = volumeByDate[exerciseDate] ?? 0.0
                for row in exercise.setRows {
                    let volumeForSet = row.weight * Float(row.reps)
                    totalVolumeForDate += Double(volumeForSet)
                }
                volumeByDate[exerciseDate] = totalVolumeForDate
            }
        }

        let volumeArray = Array(volumeByDate.values)
        print(volumeArray)
        if volumeArray.count > 1 { // needs to be one in the future
            return volumeArray
        }
        
        return nil

    }
    
    
    // Has NOT been tested
    func getHeaviestWeightPerDay(exerciseHistory: [WorkoutLogModel.ExersiseLogModule]) -> [Double]? {
        var heaviestWeightData: [Date: Double] = [:]

        for exercise in exerciseHistory {
            guard let exerciseDate = exercise.DateCompleted else { continue }
            let calendar = Calendar.current
            let exerciseDay = calendar.startOfDay(for: exerciseDate)

            var biggestWeight: Float = 0
            for set in exercise.setRows {
                if set.weight > biggestWeight {
                    biggestWeight = set.weight
                }
            }

            if let existingWeight = heaviestWeightData[exerciseDay] {
                heaviestWeightData[exerciseDay] = max(existingWeight, Double(biggestWeight))
            } else {
                heaviestWeightData[exerciseDay] = Double(biggestWeight)
            }
        }

        let heaviestWeightArray = Array(heaviestWeightData.values)

        if !heaviestWeightArray.isEmpty {
            return heaviestWeightArray
        }
        return nil

        
    }
    
    func getProjected1RM(exerciseHistory: [WorkoutLogModel.ExersiseLogModule]) -> [Double]? {
        var heaviestSetData: [Date: (weight: Double, reps: Int)] = [:]

        for exercise in exerciseHistory {
            guard let exerciseDate = exercise.DateCompleted else { continue }
            let calendar = Calendar.current
            let exerciseDay = calendar.startOfDay(for: exerciseDate)

            var biggestWeight: Float = 0
            var repsForBiggestWeight: Int = 0
            for set in exercise.setRows {
                if set.weight > biggestWeight {
                    biggestWeight = set.weight
                    repsForBiggestWeight = set.reps
                }
            }

            if let existingSet = heaviestSetData[exerciseDay] {
                if Double(biggestWeight) > existingSet.weight {
                    heaviestSetData[exerciseDay] = (weight: Double(biggestWeight), reps: repsForBiggestWeight)
                }
            } else {
                heaviestSetData[exerciseDay] = (weight: Double(biggestWeight), reps: repsForBiggestWeight)
            }
        }

        let projected1RMArray = heaviestSetData.values.map { set in
            return set.weight * (1 + 0.0333 * Double(set.reps))
        }

        if !projected1RMArray.isEmpty {
            return projected1RMArray
        }

        return nil
        

    }
    
    func getBestVolumeSet(exerciseHistory: [WorkoutLogModel.ExersiseLogModule]) -> [Double]? {
        var bestVolumeSetData: [Date: Double] = [:]

        for exercise in exerciseHistory {
            guard let exerciseDate = exercise.DateCompleted else { continue }
            let calendar = Calendar.current
            let exerciseDay = calendar.startOfDay(for: exerciseDate)

            var maxVolume: Double = 0
            for set in exercise.setRows {
                let volumeForSet = Double(set.weight) * Double(set.reps)
                if volumeForSet > maxVolume {
                    maxVolume = volumeForSet
                }
            }

            if let existingVolume = bestVolumeSetData[exerciseDay] {
                bestVolumeSetData[exerciseDay] = max(existingVolume, maxVolume)
            } else {
                bestVolumeSetData[exerciseDay] = maxVolume
            }
        }

        let bestVolumeSetArray = Array(bestVolumeSetData.values)

        if !bestVolumeSetArray.isEmpty {
            return bestVolumeSetArray
        }
        return nil

        
       
    }
    
    func getTotalReps(exerciseHistory: [WorkoutLogModel.ExersiseLogModule]) -> [Double]? {
        var totalRepsData: [Date: Double] = [:]

        for exercise in exerciseHistory {
            guard let exerciseDate = exercise.DateCompleted else { continue }
            let calendar = Calendar.current
            let exerciseDay = calendar.startOfDay(for: exerciseDate)

            var totalRepsForDate = totalRepsData[exerciseDay] ?? 0.0
            for row in exercise.setRows {
                totalRepsForDate += Double(row.reps)
            }
            totalRepsData[exerciseDay] = totalRepsForDate
        }

        let totalRepsArray = Array(totalRepsData.values)

        if !totalRepsArray.isEmpty {
            return totalRepsArray
        }
        return nil
        
      
    }


    func getWeightPerRep(exerciseHistory: [WorkoutLogModel.ExersiseLogModule]) -> [Double]? {
        var weightPerRepData: [Date: Double] = [:]

        for exercise in exerciseHistory {
            guard let exerciseDate = exercise.DateCompleted else { continue }
            let calendar = Calendar.current
            let exerciseDay = calendar.startOfDay(for: exerciseDate)

            var totalWeightForDate = weightPerRepData[exerciseDay] ?? 0.0
            var totalRepsForDate = 0.0
            for row in exercise.setRows {
                totalWeightForDate += Double(row.weight) * Double(row.reps)
                totalRepsForDate += Double(row.reps)
            }

            let weightPerRepForDate = totalWeightForDate / totalRepsForDate
            weightPerRepData[exerciseDay] = weightPerRepForDate
        }

        let weightPerRepArray = Array(weightPerRepData.values)

        if !weightPerRepArray.isEmpty {
            return weightPerRepArray
        }


        return nil
       
    }
    
    func getWorkoutFrequency(exerciseHistory: [WorkoutLogModel.ExersiseLogModule]) -> [Double] {
//        let calendar = Calendar.current
//        let currentDate = Date()
//        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
//        let startOfMonth = calendar.startOfDay(for: oneMonthAgo)
//
//        var workoutFrequency: [Date: Int] = [:]
//
//        for exercise in exerciseHistory {
//            guard let exerciseDate = exercise.DateCompleted else { continue }
//            if exerciseDate >= startOfMonth {
//                let exerciseDay = calendar.startOfDay(for: exerciseDate)
//                workoutFrequency[exerciseDay] = (workoutFrequency[exerciseDay] ?? 0) + 1
//            }
//        }
//
//        var dailyWorkoutFrequency: [Int] = []
//        var currentDateIterator = startOfMonth
//        while currentDateIterator <= currentDate {
//            let dayWorkouts = workoutFrequency[currentDateIterator] ?? 0
//            dailyWorkoutFrequency.append(dayWorkouts)
//            currentDateIterator = calendar.date(byAdding: .day, value: 1, to: currentDateIterator) ?? currentDate
//        }
//
//        return dailyWorkoutFrequency
        
        let testValues: [Double] = [500, 550]
        return testValues
    }


   



  
    
//    struct ScheduleWorkout: Identifiable {
//        var id: Int
//        var name: String
//        var exercises: [String]
//        var duration: Int
//        var recurringID: Int?
//    }
//
//    struct Workout: Identifiable, Codable {
//        let id: UUID
//        let WorkoutName: String
//        var notes: String = ""
//        var exercises: [WorkoutLogModel.ExersiseLogModule]
//        var category: String
//    }
    
}
