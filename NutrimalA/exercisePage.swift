//
//  exercisePage.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/28/23.
//

import SwiftUI

enum Page: Int {
    case page1 = 0
    case page2
    case page3
    case page4
}


struct ExercisePage: View {
    @State private var selectedPage: Page = .page1
    @ObservedObject var viewModel: HomePageViewModel
    @Binding var showingExrcisePage: Bool

    private var customBinding: Binding<Page> {
        Binding<Page>(
            get: { selectedPage },
            set: { selectedPage = $0 }
        )
    }

    var body: some View {
        let offset = viewModel.ongoingWorkout ? 0 : 0.13
        if let exercise = viewModel.homePageModel.currentExervice {
            VStack {
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            showingExrcisePage = false
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
                    
                    Spacer()
                    TextHelvetica(content: exercise.exerciseName, size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                    Button {
                       
                    }
                    label: {
                        TextHelvetica(content: "Edit", size: 18)
                            .foregroundColor(Color("LinkBlue"))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                CustomSegmentedPicker(selection: customBinding, labels: ["About", "History", "Data", "Records"])
                    .padding()

                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))

                switch selectedPage {
                case .page1:
                    Page1View(exercise: exercise)
                case .page2:
                    Page2View(exercise: exercise)
                case .page3:
                    Page3View()
                case .page4:
                    Page4View()
                }

                Spacer()
              
            }
            .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * (0.7 + offset))
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
            .offset(y: getScreenBounds().height * (offset/5))
        }
    }
}

struct CustomSegmentedPicker: View {
    @Binding var selection: Page
    var labels: [String]
    private let slidingBarHeight: CGFloat = 2

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<labels.count) { index in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            selection = Page(rawValue: index)!
                        }
                    }) {
                        TextHelvetica(content: labels[index], size: 15)
                       
                            .padding(.vertical, 5)
                            
                            .frame(maxWidth: .infinity)
                            .foregroundColor(selection == Page(rawValue: index) ? Color("LinkBlue") : Color("WhiteFontOne"))
                    }
                }
            }
            .background(Color("MainGray"))

            // Sliding bar
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: slidingBarHeight / 2)
                    .frame(width: geometry.size.width / CGFloat(labels.count), height: slidingBarHeight)
                    .foregroundColor(.blue)
                    .offset(x: (geometry.size.width / CGFloat(labels.count)) * CGFloat(selection.rawValue))
                    .animation(.easeInOut, value: selection)
            }
            .frame(height: slidingBarHeight)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}








struct Page1View: View {
    var exercise: HomePageModel.Exersise
    var body: some View {
        HStack {
            TextHelvetica(content: "Instructions", size: 25)
                .foregroundColor(Color("WhiteFontOne"))
            Spacer()
        }
        .padding(.horizontal)
        
        VStack(alignment: .leading) {
            ForEach(exercise.instructions.indices, id: \.self) { index in
                TextHelvetica( content: "\(index + 1). \(exercise.instructions[index])", size: 15)
                    .foregroundColor(Color("GrayFontOne"))
                    
            }
            .padding(.all, 10)
     
       
        }
       
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .frame(width: getScreenBounds().width * 0.89)
    }
}

struct Page2View: View {
    var exercise: HomePageModel.Exersise
    var body: some View {
     
        ScrollView {

            
            LazyVStack {
                
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.06)
                    .foregroundColor(.clear)
                
            
                
                ForEach(exercise.exerciseHistory.reversed()) { workout in
                 
                        
                        
                        
                        
                        
                        VStack(spacing: 0) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    TextHelvetica(content: "Tuesday Feb 12" , size: 27)
                                        .foregroundColor(Color("WhiteFontOne"))
                                    
                                }
                                Spacer()
                                
                                ZStack{
                                    
                                    Image("meatBalls")
                                        .resizable()
                                        .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)
                                    
                                    

                                  
                                                              

                                }
                                .offset(y: 3)
                                
                            }
                          
                            .padding(.all, 12)
                            .background(Color("MainGray"))
                            
                            Rectangle()
                                .frame(height: getScreenBounds().height * 0.006)
                                .foregroundColor(Color("MainGray"))
                            
                            HStack {
                                TextHelvetica(content: "1000 lbs", size: 16)
                                    .foregroundColor(Color("GrayFontOne"))
                                Spacer()
                                TextHelvetica(content: "1000 sets", size: 16)
                                    .foregroundColor(Color("GrayFontOne"))
                                Spacer()
                                TextHelvetica(content: "14 reps", size: 16)
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
                                    TextHelvetica(content: "Sets", size: 24)
                                        .foregroundColor(Color("WhiteFontOne"))
                                   
                                    Spacer()
                                    
                                    TextHelvetica(content: "1 RM", size: 20)
                                        .foregroundColor(Color("WhiteFontOne"))
                                }
                                .padding(.top, 15)
                                .padding(.bottom, -20)
                                .padding(.horizontal, 20)
                                
                                
                                    VStack(alignment: .leading) {
                                        
                                        Rectangle()
                                            .frame(height: 10)
                                            .foregroundColor(.clear)
                                        ForEach(workout.setRows) { row in
                                            VStack {
                                                
                                                HStack(spacing: 0){
                                                    TextHelvetica(content: "\(row.setIndex) ", size: 19)
                                                        .foregroundColor(Color("LinkBlue"))
                                                    TextHelvetica(content: "- \(row.weight.clean) lbs x \(row.reps)", size: 19)
                                              
                                                        .foregroundColor(Color("GrayFontOne"))
                                                    if row.repMetric != 0 {
                                                        TextHelvetica(content: " @ \(row.repMetric.clean)", size: 19)
                                                            .foregroundColor(Color("GrayFontOne"))
                                                    }
                                                    Spacer()
                                                    TextHelvetica(content: "120", size: 19)
                                              
                                                        .foregroundColor(Color("GrayFontOne"))
                                                    
                                                }.padding(.horizontal)
                                           
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
                
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.2)
                    .foregroundColor(.clear)
            }
        }
        
    }
}

struct Page3View: View {
    var body: some View {
        Text("Page 3 Content")
    }
}

struct Page4View: View {
    var body: some View {
        Text("Page 4 Content")
    }
}
