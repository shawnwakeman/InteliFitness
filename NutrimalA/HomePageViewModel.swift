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
    @Published var newViewModel = WorkoutLogViewModel()
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

    var myWorkoutsRecent: [HomePageModel.Workout] {
        return homePageModel.myExercisesRecent
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
    
    
    func addToHistory(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule], workoutTime: Int, workoutNotes: String) {
        homePageModel.addToHistory(workoutName: workoutName, exersiseModules: exersiseModules, workoutTime: workoutTime, workoutNotes: workoutNotes)
     
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
    
    func setNotes(notes: String, moduleID: Int) {
        homePageModel.setNotes(notes: notes, moduleID: moduleID)
    }
    
    func setOngoingState(state: Bool) {
        homePageModel.setOngoingWorkoutState(state: state)
    }
    
    func deleteExerciseHistory(workoutID: UUID) {
        homePageModel.deleteFromHistory(workoutID: workoutID)

    }
    func deleteMyWorkoutRecent(workoutID: UUID) {
        homePageModel.deleteMyWorkoutRecent(workoutID: workoutID)

    }
    
    func resetID(exerciseID: UUID) {
        homePageModel.resetID(workoutID: exerciseID)
    }

    func deleteMyWorkouts(workoutID: UUID) {
        homePageModel.deleteMyWorkouts(workoutID: workoutID)

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
    func addToMyWorkoutsRecent(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        homePageModel.addToMyExercisesRecent(workoutName: workoutName, exersiseModules: exersiseModules)
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
    
    func setExerciseName(exerciseID: Int, newName: String) {
        homePageModel.setExerciseName(exerciseID: exerciseID, newName: newName)
    }
    
    func deleteExercise(exerciseID: Int) {
        homePageModel.deleteExercise(exerciseID: exerciseID)
    }
    
    func saveSchedule() {
    
        schedule.saveSchedule()
    }
    
    func replaceWorkout(workout: ScheduleWorkout) {
        schedule.replaceWorkout(with: workout)
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
        
        // Check workouts for the current day
        if let workoutArray = sortedWorkouts.first(where: { $0.key == startOfDayCurrentDate })?.value {
            for workout in workoutArray {
                if workout.time >= currentDate && workout.HasBeenDone == false {
                    return workout
                }
            }
        }

        // If no upcoming workouts are found, check for a workout within an hour
        let oneHourLater = currentDate.addingTimeInterval(3600)
        if let workoutArray2 = sortedWorkouts.first(where: { $0.key == startOfDayCurrentDate })?.value {
            for workout in workoutArray2 {
                if workout.time <= oneHourLater && workout.HasBeenDone == false {
                    return workout
                }
            }
        }

        return nil
    }

    func upcomingWorkoutAndRemove() -> ScheduleWorkout? {
        let currentDate = Date()
        let startOfDayCurrentDate = startOfDay(for: currentDate)
        let sortedWorkouts = schedule.workouts.sorted(by: { $0.key < $1.key })
            
        // Check workouts for the current day
        if let workoutArray = sortedWorkouts.first(where: { $0.key == startOfDayCurrentDate })?.value {
            for (index, workout) in workoutArray.enumerated() {
                if workout.time >= currentDate && workout.HasBeenDone == false {
                    schedule.workouts[startOfDayCurrentDate]?[index].HasBeenDone = true
                    return workout
                }
            }
        }

        // If no upcoming workouts are found, check for a workout within an hour
        let oneHourLater = currentDate.addingTimeInterval(3600)
        if let workoutArray2 = sortedWorkouts.first(where: { $0.key == startOfDayCurrentDate })?.value {
            for (index, workout) in workoutArray2.enumerated() {
                if workout.time <= oneHourLater && workout.HasBeenDone == false {
                    schedule.workouts[startOfDayCurrentDate]?[index].HasBeenDone = true
                    return workout
                }
            }
        }

        return nil
    }

   
    @Published private(set) var chartData: exerciseChartDataModel = exerciseChartDataModel()
    
    func setExerciseChartData(volume: [Double], heaviestWeight: [Double], Projected1RM: [Double], BestSetVolume: [Double], TotalReps: [Double], WeightPerRep: [Double], exercise: HomePageModel.Exersise) {
        if !volume.isEmpty {
            let preparedVolume = prepareData(viewCounts: volume, exercise: exercise)
            let preparedHeaviestWeight = prepareData(viewCounts: heaviestWeight, exercise: exercise)
            let preparedProjected1RM = prepareData(viewCounts: Projected1RM, exercise: exercise)
            let preparderBestSetVolume = prepareData(viewCounts: BestSetVolume, exercise: exercise)
            let preparedTotalReps = prepareData(viewCounts: TotalReps, exercise: exercise)
            let preparedWeightPerRep = prepareData(viewCounts: WeightPerRep, exercise: exercise)

            chartData.setData(volume: preparedVolume, heaviestWeight: preparedHeaviestWeight, Projected1RM: preparedProjected1RM, bestSetVolume: preparderBestSetVolume, TotalReps: preparedTotalReps, WeightPerRep: preparedWeightPerRep)
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

        // Sort the dictionary by date
        let sortedVolumeByDate = volumeByDate.sorted { $0.key < $1.key }
        
        // Get the volume values from the sorted array of tuples
        let sortedVolumeArray = sortedVolumeByDate.map { $0.value }

        if sortedVolumeArray.count > 1 { // needs to be one in the future
            return sortedVolumeArray
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

        // Sort the dictionary by date
        let sortedHeaviestWeightData = heaviestWeightData.sorted { $0.key < $1.key }
        
        // Get the weight values from the sorted array of tuples
        let sortedHeaviestWeightArray = sortedHeaviestWeightData.map { $0.value }

        if !sortedHeaviestWeightArray.isEmpty {
            return sortedHeaviestWeightArray
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

        // Sort the dictionary by date
        let sortedHeaviestSetData = heaviestSetData.sorted { $0.key < $1.key }
        
        // Get the 1RM values from the sorted array of tuples
        let sortedProjected1RMArray = sortedHeaviestSetData.map { set in
            return set.value.weight * (1 + 0.0333 * Double(set.value.reps))
        }

        if !sortedProjected1RMArray.isEmpty {
            return sortedProjected1RMArray
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

        // Sort the dictionary by date
        let sortedBestVolumeSetData = bestVolumeSetData.sorted { $0.key < $1.key }
        
        // Get the volume values from the sorted array of tuples
        let sortedBestVolumeSetArray = sortedBestVolumeSetData.map { $0.value }

        if !sortedBestVolumeSetArray.isEmpty {
            return sortedBestVolumeSetArray
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

        // Sort the dictionary by date
        let sortedTotalRepsData = totalRepsData.sorted { $0.key < $1.key }
        
        // Get the reps values from the sorted array of tuples
        let sortedTotalRepsArray = sortedTotalRepsData.map { $0.value }

        if !sortedTotalRepsArray.isEmpty {
            return sortedTotalRepsArray
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

        // Sort the dictionary by date
        let sortedWeightPerRepData = weightPerRepData.sorted { $0.key < $1.key }
        
        // Get the weight per rep values from the sorted array of tuples
        let sortedWeightPerRepArray = sortedWeightPerRepData.map { $0.value }

        if !sortedWeightPerRepArray.isEmpty {
            return sortedWeightPerRepArray
        }

        return nil
    }

    
    func getWorkoutFrequency(exerciseHistory: [WorkoutLogModel.ExersiseLogModule]) -> [Int] {
        
        let calendar = Calendar.current
        let today = Date()
        let totalDaysInCurrentMonth = calendar.range(of: .day, in: .month, for: today)!.count
        
        var monthlyWorkoutFrequencyData = Array(repeating: 0, count: totalDaysInCurrentMonth)
        
        for workout in exerciseHistory {
            if let workoutDate = workout.DateCompleted {
                if calendar.isDate(workoutDate, equalTo: today, toGranularity: .month) {
                    let dayOfMonth = calendar.component(.day, from: workoutDate)
                    monthlyWorkoutFrequencyData[dayOfMonth - 1] += 1
                }
            }
            
            
        }

        
  
        return monthlyWorkoutFrequencyData
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
    
    func returnWorkoutMetrics(workout: HomePageModel.Workout) -> [Int] {
        var volume = 0
        var setCount = 0
        for exersise in workout.exercises {
            for workoutSet in exersise.setRows {
                volume += Int(workoutSet.weight) * workoutSet.reps
                setCount += 1
                
            }
        }
        let nums = [volume, setCount]
        return nums
    }
    
    func returnWorkoutMetrics(workout: WorkoutLogModel.ExersiseLogModule) -> [Int] {
        var volume = 0
        var setCount = 0
        for workoutSet in workout.setRows {
            
            volume += Int(workoutSet.weight) * workoutSet.reps
            setCount += workoutSet.reps
                
            
        }
        let nums = [volume, setCount]
        return nums
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd"
        return dateFormatter.string(from: date)
    }
    
    func formatDate2(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd, 'at' h:mm a"
        return dateFormatter.string(from: date)
    }

    
    struct ExerciseStats {
        let exerciseCount: Int
        let totalVolume: Float
        let totalReps: Int
        let totalSets: Int
        var topExercises: [(Int, Int)] // (exerciseId, frequency)
        var totalWorkouts: Int
        var totalWorkoutTime: Int
        var timeBetweenFirstAndLast: TimeInterval?
        var groupedSets: [String: Float]
        var lastThirtyDaysFrequency: [Int]// Will be nil if there are fewer than 2 workouts
    }

    func calculateStats() -> ExerciseStats {
        var exerciseCount = 0
        var totalVolume: Float = 0
        var totalReps = 0
        var totalSets = 0
        var totalWorkouts = 0
        var totalWorkoutTime = 0
        var timeBetweenFirstAndLast: TimeInterval? = nil
        var groupedSets: [String: Float] = [:]

        // Ensure there are at least 2 workouts to calculate time between
        if history.count >= 2 {
            let sortedHistory = history.sorted { $0.competionDate < $1.competionDate }
            timeBetweenFirstAndLast = sortedHistory.last!.competionDate.timeIntervalSince(sortedHistory.first!.competionDate)
        }

        // Calculate the total stats for all workouts
        for workout in history {
            totalWorkouts += 1
            totalWorkoutTime += workout.workoutTime
            for exercise in workout.exercises {
                exerciseCount += 1
                for setRow in exercise.setRows {
                    totalVolume += setRow.weight * Float(setRow.reps)
                    totalReps += setRow.reps
                    totalSets += 1
                }
            }
        }

        let calendar = Calendar.current
        let today = Date()
        let totalDaysInCurrentMonth = calendar.range(of: .day, in: .month, for: today)!.count
        
        var monthlyWorkoutFrequencyData = Array(repeating: 0, count: totalDaysInCurrentMonth)
        
        for workout in history {
            let workoutDate = workout.competionDate
            if calendar.isDate(workoutDate, equalTo: today, toGranularity: .month) {
                let dayOfMonth = calendar.component(.day, from: workoutDate)
                monthlyWorkoutFrequencyData[dayOfMonth - 1] += 1
            }
        }

        // Calculate the grouped sets
        let categorySets = calculateCategorySets(for: exersises)
        groupedSets = groupCategorySets(categorySets)

        let topExercises = getTopExercises()

        return ExerciseStats(exerciseCount: exerciseCount, totalVolume: totalVolume, totalReps: totalReps, totalSets: totalSets, topExercises: topExercises, totalWorkouts: totalWorkouts, totalWorkoutTime: totalWorkoutTime, timeBetweenFirstAndLast: timeBetweenFirstAndLast, groupedSets: groupedSets, lastThirtyDaysFrequency: monthlyWorkoutFrequencyData)
    }

    
    func getTopExercises() -> [(Int, Int)] {
        var exerciseFrequency: [Int: Int] = [:]  // dictionary to hold exercise ID and its frequency
        
        for workout in history {
            for exercise in workout.exercises {
                exerciseFrequency[exercise.ExersiseID, default: 0] += 1
            }
        }
        
        // sort the dictionary and convert to array of tuples
        let sortedExercises = exerciseFrequency.sorted { $0.value > $1.value }
        
        return sortedExercises
    }
    
    func calculateCategoryVolumes(for exercises: [HomePageModel.Exersise]) -> [String: Float] {
        var categoryVolumes: [String: Float] = [:]  // Dictionary to hold category names and their total volumes

        for exercise in exercises {
            // Calculate the volume for each exercise in the exerciseHistory
            let exerciseTotalVolume = exercise.exerciseHistory.reduce(0.0) { total, exerciseLogModule in
                let exerciseVolume = exerciseLogModule.setRows.reduce(0.0) { setTotal, setRow in
                    setTotal + (setRow.weight * Float(setRow.reps))
                }
                return total + Double(exerciseVolume)
            }

            // Add the exercise's volume to the total volume for each of its categories
            for category in exercise.exerciseCategory {
                categoryVolumes[category, default: 0.0] += Float(exerciseTotalVolume)
            }
        }

        return categoryVolumes
    }

    
    func calculateCategorySets(for exercises: [HomePageModel.Exersise]) -> [String: Int] {
        var categorySets: [String: Int] = [:]  // Dictionary to hold category names and their total sets

        for exercise in exercises {
            // Count the sets for each exercise in the exerciseHistory
            let exerciseTotalSets = exercise.exerciseHistory.reduce(0) { total, exerciseLogModule in
                return total + exerciseLogModule.setRows.count
            }

            // Add the exercise's sets to the total sets for each of its categories
            for category in exercise.exerciseCategory {
                categorySets[category, default: 0] += exerciseTotalSets
            }
        }

        return categorySets
    }
    
    func groupCategorySets(_ categorySets: [String: Int]) -> [String: Float] {
        var groupedSets: [String: Int] = [:]

        for (category, setCount) in categorySets {
            switch category {
            case "Upper Back", "Lower Back":
                groupedSets["Back", default: 0] += setCount
            case "Biceps", "Triceps":
                groupedSets["Arms", default: 0] += setCount
            case "Glutes", "Quadriceps", "Hamstrings":
                groupedSets["Legs", default: 0] += setCount
            case "Abs":
                groupedSets["Abs", default: 0] += setCount
            case "Other", "Cardio":
                break // exclude these categories
            default:
                // For all other categories, just copy the sets over without grouping
                groupedSets[category] = setCount
            }
        }

        // Get the maximum number of sets across all categories
        guard let maxSets = groupedSets.values.max() else {
            return [:]
        }

        // Calculate the percentage of sets for each group, relative to the max sets
        var setPercentages: [String: Float] = [:]
        for (category, setCount) in groupedSets {
            setPercentages[category] = (Float(setCount) / Float(maxSets)) * 10
        }

        return setPercentages
    }
    
    func getExerciseByID(by id: Int) -> HomePageModel.Exersise? {
        return exersises.first(where: { $0.id == id })
    }
    
}
