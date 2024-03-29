//
//  ScheduleMode.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/6/23.
//

import Foundation

struct ScheduleWorkout: Identifiable, Codable {
    var id: Int
    var name: String
    var exercises: [WorkoutLogModel.ExersiseLogModule]
    var recurringID: Int?
    var time: Date
    var HasBeenDone: Bool
}


struct Schedule {
    var workouts = [Date: [ScheduleWorkout]]()
    
    private(set) var workoutQueue: HomePageModel.Workout?

  
    enum ReminderOption: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case none = "None"
        case fiveMinutes = "5 mins"
        case fifteenMinutes = "15 mins"
        case thirtyMinutes = "30 mins"
    }
    enum RecurringOption: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case none, daily, weekly
    }
    
    mutating func addToWorkoutQueue(workout: HomePageModel.Workout) {
        workoutQueue = workout
    }
    mutating func clearWorkoutQueue() {
        workoutQueue = nil
    }

    private func startOfDay(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components) ?? date
    }

    mutating func addWorkout(to date: Date, workout: ScheduleWorkout, recurringOption: RecurringOption) {
        let dateKey = startOfDay(for: date)

        switch recurringOption {
        case .none:
            addWorkout(to: dateKey, workout: workout)
        case .daily:
            for i in 0..<30 {
                if let newDate = Calendar.current.date(byAdding: .day, value: i, to: dateKey) {
                    addWorkout(to: newDate, workout: workout)
                }
            }
        case .weekly:
            for i in 0..<12 {
                if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: i, to: dateKey) {
                    addWorkout(to: newDate, workout: workout)
                }
            }
        }
    }

    mutating func removeRecurringWorkouts(workoutID: Int, recurringID: Int) {
        for (date, workoutList) in workouts {
            let filteredWorkoutList = workoutList.filter { $0.id != workoutID || $0.recurringID != recurringID }
            workouts[date] = filteredWorkoutList
        }
    }

    private mutating func addWorkout(to date: Date, workout: ScheduleWorkout) {
        if var workoutList = workouts[date] {
            workoutList.append(workout)
            workouts[date] = workoutList
        } else {
            workouts[date] = [workout]
        }
    }
    
    mutating func replaceWorkout(with newWorkout: ScheduleWorkout) {
        for (date, workoutList) in workouts {
            if let workoutIndex = workoutList.firstIndex(where: { $0.id == newWorkout.id }) {
                workouts[date]?[workoutIndex] = newWorkout
                break
            }
        }
    }

    mutating func removeWorkout(from date: Date, workoutID: Int) {
        let dateKey = startOfDay(for: date)
        if var workoutList = workouts[dateKey] {
            workoutList.removeAll { $0.id == workoutID }
            workouts[dateKey] = workoutList
        }
    }

    func getWorkouts(for date: Date) -> [ScheduleWorkout]? {
        let dateKey = startOfDay(for: date)
        
        return workouts[dateKey]
    }
    
    
    mutating func saveSchedule() {
        
        
        let defaults = UserDefaults.standard

        // First, filter the workouts dictionary to remove old workouts
        let currentDate = Date()
        
        workouts = workouts.filter { workoutDate, _ in
            // Create a date that is 1 week and 3 days from the workout date
            if let date10DaysLater = Calendar.current.date(byAdding: .day, value: 10, to: workoutDate) {
                // If the current date is before this date (i.e., less than 10 days have passed since the workout), keep the workout
                return currentDate.compare(date10DaysLater) == .orderedAscending
            } else {
                // If we can't calculate the date 10 days later (which should not normally happen), keep the workout
                return true
            }
        }
        
        
        do {
          
            let encodedData = try JSONEncoder().encode(workouts)
            defaults.set(encodedData, forKey: "schedule")
        } catch {
//            print("Failed to encode schedule: \(error.localizedDescription)")
        }
    }
    

    


    
    
    mutating func loadSchedule() {
        let defaults = UserDefaults.standard

        if let savedData = defaults.object(forKey: "schedule") as? Data {
            do {
                workouts = try JSONDecoder().decode([Date: [ScheduleWorkout]].self, from: savedData)
            } catch {
//                print("Failed to decode exersiseModules: \(error.localizedDescription)")
            }
        }
    }
}
