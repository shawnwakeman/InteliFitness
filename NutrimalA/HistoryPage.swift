//
//  HistoryPage.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/22/23.
//
//  MyExercisesPage.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/20/23.
//

import Foundation
//
//  AddExersisesPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/13/23.
//

import SwiftUI



struct HistoryPage: View {

    @ObservedObject var viewModel: HomePageViewModel
    @Binding var asdh: Bool
    @State private var search: String = ""
    @State private var showTitle = true
    private let scrollId = "scrollId"
    
    init(viewModel: HomePageViewModel, asdh: Binding<Bool>) {
        
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 20)!]
        
        self.viewModel = viewModel
        self._asdh = asdh
        
       
    }
    var body: some View {
        NavigationStack {
          
            ZStack {
                Text("").navigationBarTitle(Text("Dashboard").font(.subheadline), displayMode: .automatic)                .navigationBarItems(
                    leading: Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 0)) {
                                  asdh.toggle()
                              }
                      }) {
                        Image(systemName: "arrow.left")
                    },
                    trailing: NavigationLink(destination: CalendarView()) {
                        Text("Calendar")
                          
                          
                           
                            
                    }
            )
                Color("DBblack").ignoresSafeArea()
      
       
                   
                    
                ScrollView {
           
                    
                    LazyVStack {
                        
                        ForEach(viewModel.history) { workout in
                         
                                
                                
                                
                                
                                
                                VStack {
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading) {
                                            TextHelvetica(content: workout.WorkoutName, size: 25)
                                                .foregroundColor(Color("WhiteFontOne"))
                                            TextHelvetica(content: "Tuesdat Feb 12", size: 10)
                                        }
                                        Spacer()
                                        
                                        ZStack{
                                            
                                            Image("meatBalls")
                                                .resizable()
                                                .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)
                                            
                                            

                                            Button(action: {
                                                viewModel.deleteExerciseHistory(workoutID: workout.id)
                                            }, label: {
                                                    RoundedRectangle(cornerRadius: 3)
                                                          .stroke(Color("BorderGray"), lineWidth: borderWeight)
                                                    .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)})
                                                                      

                                        }
                                        
                                    }
                                    .background(.red)
                                    Divider()
                                        
                                        .frame(height: borderWeight)
                                        .overlay(Color("BorderGray"))
                                    HStack {
                                        TextHelvetica(content: "1 h 30 m", size: 12)
                                        TextHelvetica(content: "1000 lbs", size: 12)
                                        TextHelvetica(content: "14 sets", size: 12)
                                        TextHelvetica(content: "5 PRs", size: 12)
                                                      
                                    }
                                    Divider()
                                        
                                        .frame(height: borderWeight)
                                        .overlay(Color("BorderGray"))
                                    
                                    VStack {
                                        HStack {
                                            TextHelvetica(content: "Exercise", size: 20)
                                            TextHelvetica(content: "Best Set", size: 20)
                                        }
                                        
                                        HStack {
                                            VStack {
                                                ForEach(workout.exercises) {exercise in
                                                    if exercise.isRemoved == false {
                                                        Text("\(exercise.setRows.count) x \(exercise.exersiseName)")
                                                            .padding(.trailing)
                                                    }
                                                }
                                            }
                                            VStack {
                                                ForEach(workout.exercises) {exercise in
                                                    if exercise.isRemoved == false {
                                                        let rows = exercise.setRows
                                                        let bestRow = calculateBestSet(rows: rows)
                                                        HStack {
                                                            Text("\(bestRow!.reps) x \(bestRow!.weight.clean)")
                                                            
                                                            if bestRow!.repMetric != 0 {
                                                                Text("@ \(bestRow!.repMetric.clean)")
                                                            }
                                                            Spacer()
                                                        }
                                                       
                                                    }
                                                }
                                            }
                                          
                                        }
                                        .cornerRadius(2)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 2)
                                                .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight))
                                       
                                    }
                                  
                                }
                               
                                .background(Color("BorderGray"))
                                .cornerRadius(2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight))

                                .padding(.vertical)
                                .padding(.horizontal, 18)
                                            
                  
                        }
                    }
                }
               


               
                       

          
                .toolbarBackground( Color("MainGray"), for: .navigationBar)
           // Use inline mode for the title

            }
        }


    }
    
    func calculateBestSet(rows: [WorkoutLogModel.ExersiseSetRow]) -> WorkoutLogModel.ExersiseSetRow? {
            var mostDifficultSet: WorkoutLogModel.ExersiseSetRow?
            var highestDifficulty: Float = 0
            
            for row in rows {
                var nonZeroValues: Int = 0
                var totalValue: Float = 0
                
                if row.repMetric != 0 {
                    totalValue += row.repMetric
                    nonZeroValues += 1
                }
                
                if row.weight != 0 {
                    totalValue += row.weight
                    nonZeroValues += 1
                }
                
                if row.reps != 0 {
                    totalValue += Float(row.reps)
                    nonZeroValues += 1
                }
                
                if nonZeroValues == 0 {
                    continue
                }
                
                let averageValue: Float = totalValue / Float(nonZeroValues)
                
                if averageValue > highestDifficulty {
                    highestDifficulty = averageValue
                    mostDifficultSet = row
                }
            }
            
            return mostDifficultSet
    }
}

struct CalendarView: View {
    var body: some View {
        VStack {
            Text("Calendar View")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .navigationBarTitle("Calendar", displayMode: .inline)
    }
}

struct History: View {
    
    var body: some View {
       Text("ASD")
    }
}
