//
//  TimerModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/22/23.
//

import SwiftUI

struct TimerModel {
    var workoutTime: WorkoutTime = WorkoutTime()
    var restTime : WorkoutTime = WorkoutTime(timeElapsed: 0, timePreset: 120)
    
    // set time to zero when new workout
    
    struct WorkoutTime {
        var timeRunning: Bool = true
        var timeElapsed: Int = 0
        var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        var backgroundTime: Date = Date()
        var timePreset: Int = 0
        var timeStep = 1

    }
    
    mutating func toggleTime() {
        workoutTime.timeRunning.toggle()
    }
    
    mutating func addToTime(step: Int) {
        workoutTime.timeElapsed += step
    }
    
    mutating func setRestTime(time: Int) {
        restTime.timeElapsed = time
        restTime.timePreset = time
        
    }
    
    mutating func editRestTime(time: Int) {
        restTime.timeElapsed = time
       

    }
    
    mutating func setTimePreset(time: Int) {
        restTime.timePreset = time
       

    }
    

    
    mutating func setWorkoutTime(time: Int) {
        workoutTime.timeElapsed = time
    }
    mutating func restAddToTime(step: Int) {
  
        restTime.timeElapsed += step
     



        
    }
    
    mutating func setTimeStep(step: Int) {
        workoutTime.timeStep = step
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
//            print("Failed to encode time ")
        }

        
    }
    mutating func loadTimers(isInitialViewLoad: Bool) {
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "workoutTime") as? Data {
            if let elapsedTime = defaults.object(forKey: "elapsedTime") as? Data {
                do {
                    
                    let oldTime = try JSONDecoder().decode(Date.self, from: savedData)
                    let timeDifference = Date().timeIntervalSince(oldTime)
                    let elaptime = try JSONDecoder().decode(Int.self, from: elapsedTime)
                    if !isInitialViewLoad {
                        workoutTime.timeElapsed = 0
                    } else {
                        workoutTime.timeElapsed = Int(timeDifference) + elaptime
               
                    }
                    
//                    print("loaded data")
                    
                } catch {
//                    print("Failed to decode workoutTime : \(error.localizedDescription)")
                }
            }

        }
        
        if let savedData = defaults.object(forKey: "restTime") as? Data {
    
            do {
                
                let oldTime = try JSONDecoder().decode(Date.self, from: savedData)
                let timeDifference = Date().timeIntervalSince(oldTime)
                
                

                restTime.timeElapsed -= Int(timeDifference)
                
//                print("loaded data")
                
            } catch {
//                print("Failed to decode rest time: \(error.localizedDescription)")
            }
         
        }
        
    }
    
}


