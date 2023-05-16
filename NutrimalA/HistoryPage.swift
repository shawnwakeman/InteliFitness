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
    var body: some View {
        GeometryReader { proxy in
            
            let topEdge = proxy.safeAreaInsets.top
            Home(viewModel: viewModel, topEdge: topEdge)
                .navigationBarTitle("back")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct Home: View {
    @ObservedObject var viewModel: HomePageViewModel
    var topEdge: CGFloat
    
    let maxHeight = UIScreen.main.bounds.height / 3
    @Environment(\.presentationMode) var presentationMode
    @State var offset: CGFloat = 0
    
    @State private var search: String = ""
    @State private var showTitle = true
    @State private var rectanglePosition: CGFloat = .zero
    @State private var showingExpandedExercise: Bool = false
    @State private var showingHistoryMenu: Bool = false
    @State private var selectedWorkout: HomePageModel.Workout?
    private let scrollId = "scrollId"

    var body: some View {
        ZStack {
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    GeometryReader { proxy in
                        TopBar(topEdge: topEdge, name: "History", offset: $offset, maxHeight: maxHeight)
                            
                                .frame(maxWidth: .infinity)
                                .frame(height: getHeaderHeight(), alignment: .bottom)
                               
                                .overlay(
                                    GeometryReader { geoProxy in
                                        CustomCornerBorder(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius(), lineWidth: borderWeight)
                                            .stroke(Color("BorderGray"), lineWidth: borderWeight)
                                            .clipShape(CustomCornerBorder(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius(), lineWidth: 0))
                                            .frame(height: geoProxy.size.height + 100) // Increase the height by adding an arbitrary value, e.g., 10
                                            .offset(y: -100)
                                            .opacity((-1 * topBarTitleOpacityForBorder()))// Move the overlay up by the same value
                                    }
                                )
                                
                                
                        
                                

                        
                            .background(Color("MainGray"), in: CustomCorner(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius()))
                            .shadow(color: Color.black.opacity(topBarTitleOpacity() * 0.7), radius: 10, x: 0, y: 0)
                        
                    }
                    .frame(height: maxHeight)
                    .offset(y: -offset)
                    .zIndex(1)
        
                  




                


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
                                    HapticManager.instance.impact(style: .rigid)

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
                                                        HapticManager.instance.impact(style: .rigid)
                                                        viewModel.deleteExerciseHistory(workoutID: workout.id)
                                                        viewModel.saveExersiseHistory()
                                                        withAnimation(.spring()) {
                                                            showingHistoryMenu.toggle()
                                                            
                                                        }
                                                        
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
                        
                        .zIndex(0)
                    
                       
                


                      



                    
                    
             
                   
                    
                }
                
                .modifier(OffsetModifier(modifierID: "SCROLL", offset: $offset))
            }
            .background(Color("DBblack"))
            .coordinateSpace(name: "SCROLL")
            
            VStack {
                HStack(spacing: 15) {
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        HapticManager.instance.impact(style: .rigid)
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.body.bold())
                                .foregroundColor(Color("LinkBlue"))
                            TextHelvetica(content: "back", size: 17)
                                .foregroundColor(Color("LinkBlue"))
                            Spacer()
                        }
                        .frame(width: 100)
                    }
                    Spacer()
                    TextHelvetica(content: "History", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                        .bold()
                        .opacity(topBarTitleOpacity())
                    Spacer()
                    Button {
                        HapticManager.instance.impact(style: .rigid)
                    } label: {
                        HStack {
                            Spacer()
                            TextHelvetica(content: "calander", size: 17)
                                .foregroundColor(Color("LinkBlue"))
                                
                        }.frame(width: 100)
                       
                    }
                    
                }
                    .padding(.horizontal)
                    .frame(height: 60)
                    .padding(.top, topEdge)
                
                Spacer()
            }
           
           
      
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .edgesIgnoringSafeArea(.all)
                    .opacity(showingExpandedExercise ? 1 : 0)

              
                if let workoutToUse = selectedWorkout {
                    let offset = viewModel.ongoingWorkout ? 0 : 0.07
                    ExpandedHistory(workout: workoutToUse, showingExpandedExercise: $showingExpandedExercise)
                        .position(x: getScreenBounds().width/2, y: showingExpandedExercise ? getScreenBounds().height * (0.47 + offset) : getScreenBounds().height * 1.5)
                }
                
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.black)
                    .opacity(showingHistoryMenu ? 0.4 : 0)
                
                let offset = viewModel.ongoingWorkout ? 0 : 0.12
                historyMenu(showingHistoryMenu: $showingHistoryMenu)
                    .shadow(radius: 10)

                    .position(x: getScreenBounds().width/2, y: showingHistoryMenu ? getScreenBounds().height * (0.52 + offset) : getScreenBounds().height * 1.5)
                

            }
        }
        .background(Color("DBblack"))
       
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
                            HapticManager.instance.impact(style: .rigid)

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
                    .padding(7)
                    .background(Color("DDB"))
                    
                    .cornerRadius(10)
                    .padding(.all, 15)


                }

            }

            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))

            .padding(.vertical)
            .padding(.horizontal, 12)
            .frame(maxHeight: getScreenBounds().height * 0.8)
        }
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        
        return topHeight > (80 + topEdge) ? topHeight : (80 + topEdge)
    }
    
    func getCornerRadius() -> CGFloat {
        let progess = -offset / (maxHeight - (80 + topEdge))
        let value = 1 - progess
        let radius = value * 25
        
        return offset < 5 ? radius : 25
    }
    
    func topBarTitleOpacity() -> CGFloat {
        
        let progress = -(offset + 60) / (maxHeight - (80 + topEdge))
        

        
        return progress
    }
    
    func topBarTitleOpacityForBorder() -> CGFloat {
        
        let progress = -(offset + 150) / (maxHeight - (80 + topEdge))
        

        
        return progress
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
       Text("view ho")
    }
}


struct historyMenu: View {
    @Binding var showingHistoryMenu: Bool
    var body: some View {
        // Add a blur effect to the background
        VStack{


            Spacer()
            VStack {
                

                HStack {

                    
                    
                    TextHelvetica(content: "History Options", size: 27)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    Button {
                        HapticManager.instance.impact(style: .rigid)
                        withAnimation(.spring()) {
                                showingHistoryMenu.toggle()
                        }

                    }
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            Image(systemName: "xmark")
                                .bold()
                        }
                        
                            
                    }.frame(width: 50, height: 30)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                VStack {
                   

                        
                    Group {

                                        
  
                    Button {
                      
                      
                       
                    }
                    label: {
                        HStack{
                            
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(Color("LinkBlue"))
                                .imageScale(.large)
                                .bold()
                                .multilineTextAlignment(.leading)
                            
                            TextHelvetica(content: "Replace exersise", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                            Spacer()

                                
                      
                          
                                  
                           
                           
                            Image("sidwaysArrow")
                                .resizable()
                            
                                .aspectRatio(24/48, contentMode: .fit)
                                .frame(maxHeight: 22)
                        }
                        .padding(.horizontal)
                        .frame(maxHeight: 22)
                    }
                    
                    Divider()
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    
                    
//                    Button {
//                        withAnimation(.spring()) {
//                            viewModel.setPopUpState(state: true, popUpId: "SetUnitSubMenu")
//                        }
//
//                        withAnimation(.linear(duration: 0.9)){
//
//                            viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
//                        }
//
//                    }
//                    label: {
//                        HStack{
//
//                            Image(systemName: "scalemass")
//                                .foregroundColor(Color("LinkBlue"))
//                                .imageScale(.large)
//                                .bold()
//                                .multilineTextAlignment(.leading)
//
//                            TextHelvetica(content: "Add Warm Up Sets", size: 18)
//                                .foregroundColor(Color("WhiteFontOne"))
//
//                            Spacer()
//                            TextHelvetica(content: "", size: 17)
//                                .foregroundColor(Color("GrayFontOne"))
//                            Image("sidwaysArrow")
//                                .resizable()
//
//                                .aspectRatio(24/48, contentMode: .fit)
//                                .frame(maxHeight: 22)
//                        }
//                        .padding(.horizontal)
//                        .frame(maxHeight: 22)
//                    }
            
                        Button {
                            
                         
                            
                

                        }
                        label: {
                            HStack{
                                
                                Image(systemName: "clock")
                                    .foregroundColor(Color("LinkBlue"))
                                    .imageScale(.large)
                                    .bold()
                                    .multilineTextAlignment(.leading)
                                
                                TextHelvetica(content: "Set auto rest time", size: 18)
                                    .foregroundColor(Color("WhiteFontOne"))
                                
                                Spacer()

                                
                           
                              
                            }
                            .padding(.horizontal)
                            .frame(maxHeight: 22)
                        }
                     
                        
                        Divider()
                            .frame(height: borderWeight)
                            .overlay(Color("BorderGray"))
                    }
                 
                    Button {
                       

                    }
                    label: {
                        HStack{
                            
                            Image(systemName: "scalemass")
                                .foregroundColor(Color("LinkBlue"))
                                .imageScale(.large)
                                .bold()
                                .multilineTextAlignment(.leading)
                            
                            TextHelvetica(content: "Weight Unit", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                            Spacer()
                            TextHelvetica(content: "Lbs", size: 17)
                                .foregroundColor(Color("GrayFontOne"))
                            Image("sidwaysArrow")
                                .resizable()
                            
                                .aspectRatio(24/48, contentMode: .fit)
                                .frame(maxHeight: 22)
                        }
                        .padding(.horizontal)
                        .frame(maxHeight: 22)
                        
                        
                    }
                    Divider()
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    
                    HStack{
                       
                        TextHelvetica(content: "RPE", size: 20)
                            .foregroundColor(Color("LinkBlue"))
                    
                        TextHelvetica(content: "Enable/Disable RPE", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                      
                        Spacer()
                        
                         
                                
                   
                        
                
                        Image("sidwaysArrow")
                            .resizable()
                        
                            .aspectRatio(24/48, contentMode: .fit)
                            .frame(maxHeight: 22)
                        
                    
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color("LinkBlue")))
                    }
                   
                    .padding(.horizontal)
                    .frame(maxHeight: 22)

                    
                    Divider()
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    
                    HStack{
                        
                        Image(systemName: "note.text")
                            .foregroundColor(Color("LinkBlue"))
                            .imageScale(.large)
                            .bold()
                            .multilineTextAlignment(.leading)
                        
                        TextHelvetica(content: "Display Exersise Notes", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()
                        
                        
                              
                    
                      
                        Image("sidwaysArrow")
                            .resizable()
                        
                            .aspectRatio(24/48, contentMode: .fit)
                            .frame(maxHeight: 22)
                        
                        
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color("LinkBlue")))
                        
                        
                    }
                   
                    .padding(.horizontal)
                    .frame(maxHeight: 22)

                    .onTapGesture {
                        // Call your function here
                     
                    }
                    
                    
                    
                    
                    Divider()
                    
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    


                }
                Button {
  
                   
              
                }
                label: {
                    HStack{
                        
                        Image(systemName: "xmark")
                            .foregroundColor(Color("MainRed"))
                            .imageScale(.large)
                            .bold()
                    
                        TextHelvetica(content: "Remove Exersise", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()

                        
                    }
                    .offset(y: -5)
                    .padding(.horizontal)
                    .frame(maxHeight: 30)
                    
                }
             
               
                
            }
            .frame(width: getScreenBounds().width * 0.95)
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
            .padding()

            
        }
     

        .frame(height: getScreenBounds().height * 0.7)
        


            
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
