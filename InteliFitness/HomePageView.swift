//
//  HomePageView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/20/23.
//

import SwiftUI
import ActivityKit

enum PageToLoad {
    case history
    case myExercises
}

struct LeftRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: true)
        
        return path
    }
}




struct HomePageView: View {
    @State private var displayingWorkoutTHing = false
    @StateObject var homePageViewModel = HomePageViewModel()
    @StateObject var workoutLogViewModel = WorkoutLogViewModel()
    @StateObject private var viewModel = AppTimer()
    @State private var showPurchaseModal = false
    @Environment(\.presentationMode) private var presentationMode
    @State private var isNavigationBarHidden = true
    @State private var loadedPage: PageToLoad = .myExercises
    

    var body: some View {
        ZStack {
           
            
            NavigationStack {
           
                ZStack {
                    
                    if homePageViewModel.workoutLogModuleStatus == false {
                        P1View(loadedPage: $loadedPage, isNavigationBarHidden: $isNavigationBarHidden, showPurchaseModal: $showPurchaseModal, workoutLogViewModel: workoutLogViewModel, homePageViewModel: homePageViewModel, viewModel: viewModel)
                    }
                   
                   
                          
                    
                        
                        
                    VStack {
                        
                    }
              
                    
                    let offset = homePageViewModel.ongoingWorkout ? 0: 0.5
                    PurchaseView(onPurchaseCompleted: {
                        withAnimation {
                            showPurchaseModal = false
                        }
                    })
                    .position(x: getScreenBounds().width/2, y: showPurchaseModal ? getScreenBounds().height * 0.47 : getScreenBounds().height * (1.49 + offset))
                       
                    
                                
                    
                }
              

                
            }
            let offset = homePageViewModel.ongoingWorkout ? 0: 0.5
            WorkoutLogView(homePageVeiwModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel)
                .position(x: getScreenBounds().width/2, y: homePageViewModel.workoutLogModuleStatus ? getScreenBounds().height * 0.6 : getScreenBounds().height * (1.49 + offset))
                .ignoresSafeArea()

           
       
         
                


              

           
               
           
            

        }


       

    }
    
   
    
}
struct PurchaseView: View {
    let onPurchaseCompleted: () -> Void
    @State private var selectedType: Int = 2
    var body: some View {
        VStack {
            
            VStack(alignment: .center) {
                HStack {
                    TextHelvetica(content: "restore", size: 18)
                        .bold()
                        .foregroundColor(Color("LinkBlue"))
                    Spacer()
                    Button {
                        onPurchaseCompleted()
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
                                .foregroundColor(Color("LinkBlue"))
                        }
                        
                            
                    }.frame(width: 50, height: 30)
                }
                .padding()
                TextHelvetica(content: "Continue Your InteliFitness Experience.", size: 30)
                    .foregroundColor(Color("LinkBlue"))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                TextHelvetica(content: "Your 7-day free trial has ended. Choose a plan and continue to benefit from unlimited tracking and fitness insights.", size: 18)
                    .foregroundColor(Color("GrayFontOne"))
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.bottom, 60)
                
                HStack {
                    Button {
                        selectedType = 1
                    } label: {
                        VStack {
                            TextHelvetica(content: "Monthly", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                                .bold()
                                .padding(.vertical, 3)
                            TextHelvetica(content: "2.99", size: 28)
                                .foregroundColor(Color("LinkBlue"))
                                .bold()
                                .padding(.vertical, 5)
                            TextHelvetica(content: "Billed monthly", size: 13)
                                .foregroundColor(Color("GrayFontOne"))
                                .bold()
                                .padding(.vertical, 5)
                        }
                        .padding(10)
                        .background(Color("DBblack"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedType == 1 ? Color("LinkBlue") : Color("BorderGray"), lineWidth: borderWeight + 0.5))
                        .padding(5)
                    }
                    
                    Button {
                        selectedType = 2
                    } label: {
                        VStack {
                            TextHelvetica(content: "Yearly", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                                .bold()
                                .padding(.vertical, 3)
                            TextHelvetica(content: "24.99", size: 28)
                                .foregroundColor(Color("LinkBlue"))
                                .bold()
                                .padding(.vertical, 5)
                            TextHelvetica(content: "Billed annually", size: 13)
                                .foregroundColor(Color("GrayFontOne"))
                                .bold()
                                .padding(.vertical, 5)
                        }
                        .padding(10)
                        .background(Color("DBblack"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedType == 2 ? Color("LinkBlue") : Color("BorderGray"), lineWidth: borderWeight + 0.5))
                        .padding(5)
                    }
                    
                    Button {
                        selectedType = 3
                    } label: {
                        VStack {
                            TextHelvetica(content: "Lifetime", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                                .bold()
                                .padding(.vertical, 3)
                            TextHelvetica(content: "59.99", size: 28)
                                .foregroundColor(Color("LinkBlue"))
                                .bold()
                                .padding(.vertical, 5)
                            TextHelvetica(content: "Billed once", size: 13)
                                .foregroundColor(Color("GrayFontOne"))
                                .bold()
                                .padding(.horizontal,11)
                                .padding(.vertical, 5)
                        }
                        .padding(10)
                        .background(Color("DBblack"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selectedType == 3 ? Color("LinkBlue") : Color("BorderGray"), lineWidth: borderWeight + 0.5))
                        .padding(5)
                    }
                    
                    
                    
                    
                   
                   
                   
                    
                }
                .padding(.bottom, 10)
                
                Button {
                    onPurchaseCompleted()
                } label: {
                    if selectedType == 0 || selectedType == 2 {
                        HStack {
                            Spacer()
                            TextHelvetica(content: "Subscribe Annual plan", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                                .bold()
                            Spacer()
                        }
                        .padding(15)
                         .background(Color("DBblack"))
                         .cornerRadius(10)
                         .overlay(
                             RoundedRectangle(cornerRadius: 10)
                                 .stroke(Color("LinkBlue"), lineWidth: borderWeight))
                         .padding(10)
                    } else if selectedType == 1 {
                        HStack {
                            Spacer()
                            TextHelvetica(content: "Subscribe to Monthly plan", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                                .bold()
                            Spacer()
                        }
                        .padding(15)
                         .background(Color("DBblack"))
                         .cornerRadius(10)
                         .overlay(
                             RoundedRectangle(cornerRadius: 10)
                                 .stroke(Color("LinkBlue"), lineWidth: borderWeight))
                         .padding(10)
                    } else if selectedType == 3 {
                        HStack {
                            Spacer()
                            TextHelvetica(content: "Subscribe to Lifetime plan", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                                .bold()
                            Spacer()
                        }
                        .padding(15)
                         .background(Color("DBblack"))
                         .cornerRadius(10)
                         .overlay(
                             RoundedRectangle(cornerRadius: 10)
                                 .stroke(Color("LinkBlue"), lineWidth: borderWeight))
                         .padding(10)
                    }
                  
                }
                .padding(.bottom, 50)
                
                TextHelvetica(content: "Cancel your subscription at any time.", size: 12)
                    .foregroundColor(Color("GrayFontOne"))
                    .bold()
                    
                
            }
//            Spacer()
//            Button("Purchase") {
//                // Handle purchase
//                onPurchaseCompleted()
//            }
            Spacer()
        }
      
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color("MainGray"))
    }
}




struct P1View: View {
    @Binding var loadedPage: PageToLoad
    @Binding var isNavigationBarHidden: Bool
    @Binding var showPurchaseModal: Bool
    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel
    @ObservedObject var homePageViewModel : HomePageViewModel
    @ObservedObject var viewModel : AppTimer
    @State private var selectedDestination: AnyView? = nil
    @AppStorage("userName") var savedName: String = ""

    
    var body: some View {
        ZStack {
            VStack(spacing: -3) {
                HStack(spacing: 0) {
                    Spacer()
                    HStack {
                        
                        if viewModel.timeRemaining > 0 {
                            let hours = viewModel.timeRemaining / 3600
                            let minutes = (viewModel.timeRemaining / 60) - (hours * 60)
                            let seconds = viewModel.timeRemaining % 60

                        
                            if hours < 1 {
                                TextHelvetica(content: "\(minutes):\(String(format: "%02d", seconds))", size: 18)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                            else{
                                TextHelvetica(content: "\(String(hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))", size: 18)
                                    .foregroundColor(Color("LinkBlue"))
                                    .fontWeight(.bold)
                            }

                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color("LinkBlue"))
                                .bold()
                        }
                    
                        
                        
                   
                  
                          
                            
                    }
                    .opacity(viewModel.timeRemaining < 0 ? 0: 100)
                    .padding(7)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showPurchaseModal.toggle()
                        }
                        
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                           
                            .strokeBorder(Color("LinkBlue").opacity(viewModel.timeRemaining < 0 ? 0: 100), lineWidth: borderWeight + 0.1))
                  
                     
                  
                }
               
                
                HStack {
                    TextHelvetica(content: "Welcome Back", size: 28)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                }
                HStack {
                    TextHelvetica(content: savedName, size: 40)
                        .foregroundColor(Color("WhiteFontOne"))
                        .bold()
                    Spacer()
                }
               
                VStack(spacing: 12) {
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.00)
                        .foregroundColor(.clear)
                    ZStack {
                        let curColor = Color("LinkBlue")
                              
                        let curGradient = LinearGradient(
                                    gradient: Gradient (
                                        colors: [
                                            
                                            curColor.opacity(0.5),
                                            curColor.opacity(0.2),
                                            curColor.opacity(0.05),
                                        ]
                                    ),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                        RoundedRectangle(cornerRadius: 13)
                            .fill(
                                curGradient
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight + 0.5)
                            )
                          
                        
                        VStack {
// del
                            Spacer()
                            HStack {
                                if let workout = homePageViewModel.upcomingWorkout() {
                                    VStack(alignment: .leading) {
                                        TextHelvetica(content: "Up Next", size: 28)
                                            .foregroundColor(Color("GrayFontOne"))
                                        
                                        TextHelvetica(content: workout.name, size: 43)
                                            .foregroundColor(Color("WhiteFontOne"))
                                            .bold()
                                    }
                                } else {
                                    VStack(alignment: .leading) {
                                        TextHelvetica(content: "Up Next", size: 28)
                                            .foregroundColor(Color("GrayFontOne"))
                                        
                                        TextHelvetica(content: "New Workout", size: 43)
                                            .foregroundColor(Color("WhiteFontOne"))
                                            .bold()
                                    }
                                }
                                
                                Spacer()
                            }
                       

                        }
                        
                        .padding(.all)
                        
                    }
                   
                    .onTapGesture {
                        HapticManager.instance.impact(style: .rigid)
                        if let workout = homePageViewModel.upcomingWorkout() {
                            let formattedData = HomePageModel.Workout(id: UUID(), WorkoutName: workout.name, exercises: workout.exercises, category: "not Important", competionDate: Date())
                            self.selectedDestination = AnyView(workoutLauncher(viewModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden, workout: formattedData, isForAddingToSchedule: false))
                            workoutLogViewModel.workoutName = formattedData.WorkoutName
                        
                        } else {
                            let formattedData = HomePageModel.Workout(id: UUID(), WorkoutName: "Workout Name", exercises: [], category: "not Important", competionDate: Date())
                            homePageViewModel.setOngoingState(state: false)
                            workoutLogViewModel.loadWorkout(workout: formattedData)
                            workoutLogViewModel.workoutName = formattedData.WorkoutName
                            withAnimation(.spring()) {
                                
                                homePageViewModel.setOngoingState(state: true)
                                homePageViewModel.setWorkoutLogModuleStatus(state: true)
                       
                            }
                           
                        }
                       
                      
                    }
                   
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundColor(Color("MainGray").opacity(0.4))
                            .frame(height: getScreenBounds().height * 0.08)
                         
                        HStack(spacing: -0) {
                            ZStack {
                             
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .cornerRadius(13, corners: [.topLeft, .bottomLeft])
                                    .foregroundColor(Color("MainGray"))
                                    
                                
                                    
                            }
                            .frame(width: getScreenBounds().width * 0.23)
                      
                            Divider()
                            
                                .frame(width: borderWeight)
                                .overlay(Color("BorderGray"))
                            TextHelvetica(content: "Schedule", size: 27)
                                .padding(.horizontal, 15)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                            Spacer()
                          
                        }.frame(height: getScreenBounds().height * 0.08)
                    }
                    
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                   
                    .onTapGesture {
                        HapticManager.instance.impact(style: .rigid)
             
                        self.selectedDestination = AnyView(WeeklyScheduleView(schedule: homePageViewModel, viewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden))
                      
                    }
                   
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundColor(Color("MainGray").opacity(0.4))
                            .frame(height: getScreenBounds().height * 0.08)
                         
                        HStack(spacing: 0) {
                            
                            ZStack {
                             
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .cornerRadius(13, corners: [.topLeft, .bottomLeft])
                                    .foregroundColor(Color("MainGray"))
                                    
                                
                            }
                            .frame(width: getScreenBounds().width * 0.23)
                     
                            Divider()
                            
                                .frame(width: borderWeight)
                                .overlay(Color("BorderGray"))
                            TextHelvetica(content: "My Workouts", size: 27)
                                .foregroundColor(Color("WhiteFontOne"))
                                .padding(.horizontal, 15)
                            
                            Spacer()
                          
                        }.frame(height: getScreenBounds().height * 0.08)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                    .onTapGesture {
                        HapticManager.instance.impact(style: .rigid)
                        self.selectedDestination = AnyView(MyWorkoutsPage(viewModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden, isForAddingToSchedule: false))

                        
                    }
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 13)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            VStack(alignment: .leading) {
                                Spacer()
                                TextHelvetica(content: "History", size: 20)
                  
                                    .padding(.vertical, 5)
                                    .padding(.leading, -30)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }
             
                        }
                        .onTapGesture {
                            HapticManager.instance.impact(style: .rigid)
                            self.selectedDestination = AnyView(HistoryPage(viewModel: homePageViewModel, isNavigationBarHidden: $isNavigationBarHidden))
                        }
                        ZStack {

                            RoundedRectangle(cornerRadius: 13)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))

                            VStack(alignment: .leading) {
                                Spacer()

                                TextHelvetica(content: "Exercises", size: 20)
                  
        
                                    .padding(.leading, -10)
                                    .padding(.bottom, 5)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }

                         
                        }
                        .onTapGesture {
                            HapticManager.instance.impact(style: .rigid)
                            self.selectedDestination = AnyView(MyExercisesPage(viewModel: homePageViewModel, isNavigationBarHidden: $isNavigationBarHidden))
                        }
                       
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 13)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            VStack(alignment: .leading) {
                                Spacer()
                                TextHelvetica(content: "Profile", size: 20)
                  
                                    .padding(.vertical, 5)
                                    .padding(.leading, -40)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }
                        }
                        
                        .onTapGesture {
                            HapticManager.instance.impact(style: .rigid)
                            let data = homePageViewModel.calculateStats()
                            let asd = homePageViewModel.calculateCategoryVolumes(for: homePageViewModel.exersises)
                            let _ = print(asd)
                            self.selectedDestination = AnyView(Profile(viewModel: homePageViewModel, isNavigationBarHidden: $isNavigationBarHidden, profileData: data))
                        }
                    }
                    .frame(height: getScreenBounds().width/3.4)
                    .padding(.bottom, 14)
                }

                if homePageViewModel.ongoingWorkout {
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.0725)
                        .foregroundColor(.clear)
                }
             
                
            } .padding(.all)
                .background(Color("DBblack"))
        }

        
        .background(
            NavigationLink(
                "",
                destination: selectedDestination ?? AnyView(EmptyView()),
                isActive: Binding(get: { selectedDestination != nil }, set: { if !$0 { selectedDestination = nil } })
            )
            .opacity(0)
        )
        .navigationBarTitle(" ")
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear {
            self.isNavigationBarHidden = true
        }
   
         
    }
}


//struct P2View: View {
//
//    @Binding var asdh: Bool
//    @ObservedObject var viewModel: HomePageViewModel
//    var pageToSave: PageToLoad
//    var body: some View {
//
//        switch pageToSave {
//            case .history:
//                HistoryPage(viewModel: viewModel, asdh: $asdh)
//                // Load the history page
//            case .myExercises:
//
//                MyExercisesPage(viewModel: viewModel, asdh: $asdh)
//                // Load the my exercises page
//        }
//    }
//}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
            .previewDevice("iPhone 13 mini")
        HomePageView()
            .previewDevice("iPad Pro (11-inch)")
    }
}


struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var hasOnboarded: Bool
    
    var body: some View {
        
        let curColor = Color("LinkBlue")
              
        let curGradient = LinearGradient(
                    gradient: Gradient (
                        colors: [
                            
                            curColor.opacity(0.5),
                            curColor.opacity(0.2),
                            curColor.opacity(0.05),
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
        TabView {
            OnboardingViewPage1(image: "1.circle", title: "Welcome", description: "To help you stick to your workouts and optimize rest periods, make sure you have notifications enabled.", description2: "Thank you for installing InteliFitness! Please start by telling us your first name below.")
                               

            OnboardingViewPage2(image: "2.circle", title: "Your Personalized Fitness Tracker!", description: "InteliFitness is designed to help you keep track of your workouts, offering rich insights into your performance data. InteliFitness' goal is to empower you with information that will help you improve, one workout at a time.")
            VStack {
                OnboardingViewPage3(image: "3.circle", title: "Plan, Track, Improve!", description: "To get the most out of InteliFitness, use the schedule to plan out your perfect workout, the tracker to make the most of your workout, improving every time, and the charts to see your progress.")
                Button(action: {
                    dismiss()
                    hasOnboarded = true
                }) {
                    Text("Start your 7 Day Free Trial")
                        .bold()
                        .frame(width: 280, height: 45)
                        .background(Color("LinkBlue"))
                        .foregroundColor(Color("WhiteFontOne"))
                        .cornerRadius(10)
                }
                .padding(.top, 50)
            }
        }
        .background(curGradient)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardingViewPage1: View {
    var image: String
    var title: String
    var description: String
    var description2: String = ""
    @State private var name: String = ""
    @AppStorage("userName") var savedName: String = ""

    var body: some View {
        VStack {
            Image("onboarder1")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.bottom, 50)
            
           
           

            TextHelvetica(content: title, size: 25)
                .bold()
                .foregroundColor(Color("WhiteFontOne"))
                .multilineTextAlignment(.center)
            
            TextHelvetica(content: description2, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
  
            
            if title == "Welcome" {
                TextField("Enter your name", text: $name, onCommit: {
                    savedName = name
                })
                .font(.subheadline)
                .padding(.horizontal, 50)
                .padding(.top, 20)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            TextHelvetica(content: description, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
        }
        .ignoresSafeArea(.keyboard)
    }
}


struct OnboardingViewPage2: View {
    var image: String
    var title: String
    var description: String
    var description2: String = ""
  

    var body: some View {
        VStack {

            let data = [
                DataPoint(intelligence: 10, funny: 4, empathy: 7, veracity: 3, selflessness: 1, authenticity: 8, color: Color("LinkBlue"))
            ]
           
        

            RadarChartView(width: getScreenBounds().width * 0.67, MainColor: Color("WhiteFontOne"), SubtleColor: Color.init(white: 0.6), quantity_incrementalDividers: 0, dimensions: dimensions, data: data)
                .padding(.all)
                    .background(Color("MainGray"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("BorderGray"), lineWidth: borderWeight))
                    .padding()
           

            TextHelvetica(content: title, size: 25)
                .bold()
                .foregroundColor(Color("WhiteFontOne"))
                .multilineTextAlignment(.center)
            
            TextHelvetica(content: description2, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
  
            


            TextHelvetica(content: description, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
        }
    }
}


struct OnboardingViewPage3: View {
    var image: String
    var title: String
    var description: String
    var description2: String = ""


    var body: some View {
        VStack {

   
          

            TextHelvetica(content: title, size: 25)
                .bold()
                .foregroundColor(Color("WhiteFontOne"))
                .multilineTextAlignment(.center)
            
            TextHelvetica(content: description2, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
  
            


            TextHelvetica(content: description, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
        }
    }
}
