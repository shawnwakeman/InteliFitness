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
    @Environment(\.presentationMode) private var presentationMode
    @State private var isNavigationBarHidden = true
    @State private var loadedPage: PageToLoad = .myExercises
    

    var body: some View {
        ZStack {
           
            
            NavigationStack {
           


                if homePageViewModel.workoutLogModuleStatus == false {
                    P1View(loadedPage: $loadedPage, isNavigationBarHidden: $isNavigationBarHidden, workoutLogViewModel: workoutLogViewModel, homePageViewModel: homePageViewModel)
                }
               
                   
                            
                
            }
          

            let offset = homePageViewModel.ongoingWorkout ? 0: 0.5
                  
            WorkoutLogView(homePageVeiwModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel)
                .position(x: getScreenBounds().width/2, y: homePageViewModel.workoutLogModuleStatus ? getScreenBounds().height * 0.6 : getScreenBounds().height * (1.49 + offset))
                .ignoresSafeArea()

           
       
         
                


              

           
               
           
            

        }

       

    }
    
   
    
}




struct P1View: View {
    @Binding var loadedPage: PageToLoad
    @Binding var isNavigationBarHidden: Bool
    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel
    @ObservedObject var homePageViewModel : HomePageViewModel

    @State private var selectedDestination: AnyView? = nil
    

    
    var body: some View {
        ZStack {
            VStack(spacing: -3) {
                HStack {
                    Spacer()
                   Image(systemName: "person.crop.circle")
                        .scaleEffect(2.5)
                        .padding(.all)
                        .foregroundColor(.clear)
                     
                  
                }
                HStack {
                    TextHelvetica(content: "Welcome Back", size: 28)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                }
                HStack {
                    TextHelvetica(content: "Shawn", size: 40)
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
                            let formattedData = HomePageModel.Workout(id: UUID(), WorkoutName: "New Workout", exercises: [], category: "not Important", competionDate: Date())
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
            .previewDevice("iPhone 14")
        HomePageView()
            .previewDevice("iPhone 14 Pro Max")
    }
}


struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var hasOnboarded: Bool

    var body: some View {
        TabView {
            OnboardingViewPage(image: "1.circle", title: "Welcome", description: "This is the first page of our onboarding process.")
            OnboardingViewPage(image: "2.circle", title: "Learn", description: "This is the second page, where you will learn something new.")
            VStack {
                OnboardingViewPage(image: "3.circle", title: "Get Started", description: "This is the final page. You're ready to start using our app.")
                Button(action: {
                    dismiss()
                    hasOnboarded = true
                }) {
                    Text("Get Started")
                        .bold()
                        .frame(width: 280, height: 45)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.top, 50)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardingViewPage: View {
    var image: String
    var title: String
    var description: String

    var body: some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.bottom, 50)

            Text(title)
                .font(.title)
                .fontWeight(.bold)

            Text(description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
        }
    }
}
