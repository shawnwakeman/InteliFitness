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


    @Binding var isNavigationBarHidden: Bool
    
    @State private var search: String = ""
    @State private var showTitle = true
    @State private var rectanglePosition: CGFloat = .zero
    @State private var showingExpandedExercise: Bool = false
    @State private var selectedWorkout: HomePageModel.Workout?
    private let scrollId = "scrollId"


    
    init(viewModel: HomePageViewModel, isNavigationBarHidden: Binding<Bool>) {
        
        
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().barTintColor = UIColor(Color("MainGray"))
           
        // Set font color for NavigationBarTitle with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont(name: "SpaceGrotesk-Bold", size: 20)!,
            .foregroundColor: UIColor(Color("WhiteFontOne"))
        ]

        // Set font color for NavigationBarTitle with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont(name: "SpaceGrotesk-Bold", size: 40)!,
            .foregroundColor: UIColor(Color("WhiteFontOne")) // Replace UIColor.red with your desired color
        ]
       
        
        self.viewModel = viewModel
  
        self._isNavigationBarHidden = isNavigationBarHidden
 
       
    }
    
    func updateRectanglePosition(proxy: GeometryProxy) {
        let minY = proxy.frame(in: .global).minY
        let pinnedPosition = getScreenBounds().height * 0.3
        
        if minY < pinnedPosition {
            rectanglePosition = minY
        } else {
            rectanglePosition = pinnedPosition
        }
    }
    var body: some View {
        NavigationStack {
          
            ZStack {
                Text("Hello World!")
      

                    .navigationBarTitle(Text("History").font(.subheadline), displayMode: .inline)
                    .navigationBarHidden(false)
                              .navigationBarItems(
                                                  
                                                  trailing: NavigationLink(destination: CalendarView()) {
                                                      Text("Calendar")
                                                        
                                                        
                                                         
                                                          
                                                  }
                                          )
                Color("DBblack").ignoresSafeArea()
      
       
                    
                ScrollView {
        
                    
                    LazyVStack {
                        
                        Rectangle()
                            .frame(height: getScreenBounds().height * 0.06)
                            .foregroundColor(.clear)
                        
                    
                        
                        ForEach(viewModel.history.reversed()) { workout in
                         
                                
                                
                                
                                
                            Button {
                                selectedWorkout = workout
                                withAnimation(.spring()) {
                                    showingExpandedExercise.toggle()
                                    
                                }
                                
                            }
                        label: {
                            
                                    VStack(spacing: 0) {
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading) {
                                                TextHelvetica(content: workout.WorkoutName, size: 27)
                                                    .foregroundColor(Color("WhiteFontOne"))
                                                TextHelvetica(content: "Tuesday Feb 12", size: 17)
                                                    .foregroundColor(Color("GrayFontOne"))
                                            }
                                            Spacer()
                                            
                                            ZStack{
                                                
                                                
                                                
                                                

                                                Button(action: {
                                                    viewModel.deleteExerciseHistory(workoutID: workout.id)
                                                }, label: {
                                                    Image("meatBalls")
                                                        .resizable()
                                                        .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)})
                                                                          

                                            }
                                            .offset(y: 3)
                                            
                                        }
                                      
                                        .padding(.all, 12)
                                        .background(Color("MainGray"))
                                        
                                        Rectangle()
                                            .frame(height: getScreenBounds().height * 0.006)
                                            .foregroundColor(Color("MainGray"))
                                        
                                        HStack {
                                            TextHelvetica(content: "1 h 30 m", size: 16)
                                                .foregroundColor(Color("GrayFontOne"))
                                            Spacer()
                                            TextHelvetica(content: "1000 lbs", size: 16)
                                                .foregroundColor(Color("GrayFontOne"))
                                            Spacer()
                                            TextHelvetica(content: "14 sets", size: 16)
                                                .foregroundColor(Color("GrayFontOne"))
                                            Spacer()
                                            TextHelvetica(content: "5 PRs", size: 16)
                                                .foregroundColor(Color("GrayFontOne"))
                                                          
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 7)
                                        .background(Color("MainGray"))
                                        
                                        Divider()
                                            
                                            .frame(height: borderWeight)
                                            .overlay(Color("BorderGray"))
                                        
                                        VStack {
                                            HStack {
                                                TextHelvetica(content: "Exercise", size: 22)
                                                    .foregroundColor(Color("WhiteFontOne"))
                                                Spacer()
                                                TextHelvetica(content: "Best Set", size: 22)
                                                    .foregroundColor(Color("WhiteFontOne"))
                                                    .offset(x: -10)
                                                Spacer()
                                            }
                                            .padding(.top, 15)
                                            .padding(.bottom, -20)
                                            .padding(.leading, 20)
                                            
                                            
                                                VStack(alignment: .leading) {
                                                    Rectangle()
                                                        .frame(height: getScreenBounds().height * 0.006)
                                                        .foregroundColor(.clear)
                                                    
                                                    ForEach(workout.exercises) {exercise in
                                                      
                                                           
                                        
                                                        
                                                        HStack {
                                                            
                                                            
                                                            HStack {
                                                                TextHelvetica(content: "\(exercise.setRows.count) x \(exercise.exersiseName)", size: 16)
                                                                    .foregroundColor(Color("GrayFontOne"))
                                                                    .lineLimit(1)
                                                                 
                                                                    .padding(.leading, 10)
                                                                Spacer()
                                                            }.frame(width: getScreenBounds().width * 0.4)
                                                           
                                                                    
                                                            let rows = exercise.setRows
                                                            if let bestRow = calculateBestSet(rows: rows) {
                                                                HStack(spacing: 0){
                                                                    TextHelvetica(content: "\(bestRow.weight.clean) lbs x \(bestRow.reps)", size: 16)
                                                              
                                                                        .foregroundColor(Color("GrayFontOne"))
                                                                    if bestRow.repMetric != 0 {
                                                                        TextHelvetica(content: " @ \(bestRow.repMetric.clean)", size: 16)
                                                                            .foregroundColor(Color("GrayFontOne"))
                                                                    }
                                                                }
                                                                Spacer()
                                                            }
                                                            
                                                              
                                                            
                                                        }
                                                        Divider()
                                                            .frame(height: borderWeight)
                                                            .overlay(Color("BorderGray"))

                                                    }
                              
                                                   
                                              
                                                  
                                                }
                                                
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                                                .padding(.vertical, 20)
                                            .padding(.horizontal, 15)
                                            
                                            
                                           
                                        }
                                      
                                    }
                                   
                                    .background(Color("DBblack"))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))

                                    .padding(.vertical)
                                    .padding(.horizontal, 18)
                        }
                                            
                  
                        }
                        
                        Rectangle()
                            .frame(height: getScreenBounds().height * 0.2)
                            .foregroundColor(.clear)
                    }
                }
                
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.28)
                     
                        .foregroundColor(Color("MainGray"))
                        .shadow(radius: 10)
                   
                 
                }.position(x: getScreenBounds().width/2, y: getScreenBounds().height * -0.14)
                    .shadow(radius: 10)
                 


                ZStack {
                    VisualEffectView(effect: UIBlurEffect(style: .dark))
                        .edgesIgnoringSafeArea(.all)
                        .opacity(showingExpandedExercise ? 1 : 0)
                    
                    
                    if let workoutToUse = selectedWorkout {
                        
                        ExpandedHistory(workout: workoutToUse, showingExpandedExercise: $showingExpandedExercise)
                            .position(x: getScreenBounds().width/2, y: showingExpandedExercise ? getScreenBounds().height * 0.4 : getScreenBounds().height * 1.3)
                    }
                    
                }

           // Use inline mode for the title

            }
            .navigationBarTitle("Visible Title 1")
            .onAppear {
                self.isNavigationBarHidden = false
            }
        }


    }
    
    func calculateBestSet(rows: [WorkoutLogModel.ExersiseSetRow]) -> WorkoutLogModel.ExersiseSetRow? {
        var mostDifficultSet: WorkoutLogModel.ExersiseSetRow? = nil
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
    
    struct ExpandedHistory: View {
        var workout: HomePageModel.Workout
        @Binding var showingExpandedExercise: Bool
        var body: some View {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        TextHelvetica(content: workout.WorkoutName, size: 27)
                            .foregroundColor(Color("WhiteFontOne"))
                        TextHelvetica(content: "Tuesday Feb 12", size: 17)
                            .foregroundColor(Color("GrayFontOne"))
                    }
                    Spacer()
                    
                    ZStack{
                        
                        
                        
                        

                        Button(action: {
                            withAnimation(.spring()) {
                                showingExpandedExercise.toggle()
                            }
              
                        }, label: {
                        
                                
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                    .foregroundColor(Color("MainGray"))
                                Image(systemName: "xmark")
                                    .bold()
                            }.frame(width: 50, height: 30)
                        })
                                                  

                    }
                    .offset(y: 3)
                    
                }
              
                .padding(.all, 12)
                .background(Color("MainGray"))
                
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.006)
                    .foregroundColor(Color("MainGray"))
                
                HStack {
                    TextHelvetica(content: "1 h 30 m", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                    TextHelvetica(content: "1000 lbs", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                    TextHelvetica(content: "14 sets", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                    TextHelvetica(content: "5 PRs", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                                  
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 7)
                .background(Color("MainGray"))
                
                Divider()
                    
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                VStack {
                    HStack {
                        TextHelvetica(content: "Exercise", size: 22)
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()
                        TextHelvetica(content: "1RM", size: 20)
                            .foregroundColor(Color("WhiteFontOne"))
                           
            
                    }
                    .padding(.trailing)
                    .padding(.top, 15)
                    .padding(.bottom, -20)
                    .padding(.leading, 20)
                    
                    
                        VStack(alignment: .leading) {
                            Rectangle()
                                .frame(height: getScreenBounds().height * 0.006)
                                .foregroundColor(.clear)
                            ScrollView {
                                ForEach(workout.exercises) {exercise in
                                  
                                       
                                    VStack(spacing: 5) {
                                        HStack {
                                            TextHelvetica(content: exercise.exersiseName, size: 20)
                                                .bold()
                                                .foregroundColor(Color("WhiteFontOne"))
                                            Spacer()
                                        }.padding(.horizontal)
                                          
               

                                        
                                        ForEach(exercise.setRows) { sets in
                                            HStack(spacing: 0) {
                                                Text("\(sets.setIndex) ")
                                                    .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                    .foregroundColor(Color("LinkBlue"))
                                               
                                                Text("\(sets.weight.clean) lbs x \(sets.reps) ")
                                                    .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                    .foregroundColor(Color("GrayFontOne"))
                                                if sets.repMetric != 0 {
                                                    Text(" @ \(sets.repMetric.clean)")
                                                        .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                        .foregroundColor(Color("GrayFontOne"))
                                                }
                                                Spacer()
                                                Text("12")
                                                    .font(.custom("SpaceGrotesk-Medium", size: 18))
                                                    .foregroundColor(Color("GrayFontOne"))
                                                
                                            }
                                           
                                            
                                            
                                        }.padding(.horizontal)
                                    }
                                    
                                    
                                    Divider()
                                        .frame(height: borderWeight)
                                        .overlay(Color("BorderGray"))

                                }
                            }
                     
      
                           
                      
                          
                        }
                        
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                        .padding(.vertical, 20)
                    .padding(.horizontal, 15)
                    
                    HStack {
                        TextHelvetica(content: "Notes", size: 22)
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()
                    }       .padding(.horizontal)
                    ScrollView {
                        TextHelvetica(content: "thUASIHkdjhaslkj sklajh dklasjhklashd ah ahsdjk haslk dhakl hk h haklsh d", size: 20)
                            .foregroundColor(Color("GrayFontOne"))
                        
                    }
                    .frame(maxHeight: getScreenBounds().height * 0.1)
                    .padding(.horizontal)
                  
                   
                }
              
            }
           
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))

            .padding(.vertical)
            .padding(.horizontal, 18)
            .frame(maxHeight: getScreenBounds().height * 0.8)
        }
    }

    
   

}


