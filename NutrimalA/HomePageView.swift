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
           


            
                P1View(loadedPage: $loadedPage, isNavigationBarHidden: $isNavigationBarHidden, workoutLogViewModel: workoutLogViewModel, homePageViewModel: homePageViewModel)
                   
                            
                
            }
          

            let offset = homePageViewModel.ongoingWorkout ? 0: 0.5
      
                WorkoutLogView(homePageVeiwModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel)
                    .position(x: getScreenBounds().width/2, y: homePageViewModel.workoutLogModuleStatus ? getScreenBounds().height * 0.6 : getScreenBounds().height * (1.49 + offset))
                               .ignoresSafeArea()
                              
           
       
         
                


              

           
               
           
            

        }

       

    }
    
   
    
}


// MARK: - Functions
func startDeliveryPizza() {
    
    let pizzaDeliveryAttributes = PizzaDeliveryAttributes(numberOfPizzas: 1, totalAmount:"$99")

    let initialContentState = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: "TIM 👨🏻‍🍳", estimatedDeliveryTime: Date()...Date().addingTimeInterval(15))
                                              
    do {
        let deliveryActivity = try Activity<PizzaDeliveryAttributes>.request(
            attributes: pizzaDeliveryAttributes,
            contentState: initialContentState,
            pushType: nil)
        print("Requested a pizza delivery Live Activity \(deliveryActivity.id)")
    } catch (let error) {
        print("Error requesting pizza delivery Live Activity \(error.localizedDescription)")
    }
}
func updateDeliveryPizza() {
    Task {
        let updatedDeliveryStatus = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: "TIM 👨🏻‍🍳", estimatedDeliveryTime: Date()...Date().addingTimeInterval(60 * 60))
        
        for activity in Activity<PizzaDeliveryAttributes>.activities{
            await activity.update(using: updatedDeliveryStatus)
        }
    }
}
func stopDeliveryPizza() {
    Task {
        for activity in Activity<PizzaDeliveryAttributes>.activities{
            await activity.end(dismissalPolicy: .immediate)
        }
    }
}
func showAllDeliveries() {
    Task {
        for activity in Activity<PizzaDeliveryAttributes>.activities {
            print("Pizza delivery details: \(activity.id) -> \(activity.attributes)")
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
                        .foregroundColor(Color("WhiteFontOne"))
                     
                  
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
                        RoundedRectangle(cornerRadius: 13)
                         
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight))
                            .foregroundColor(Color("MainGray"))
                        
                        VStack {
                            HStack(alignment: .top) {
                                ZStack{
                                    
                                    Image("meatBalls")
                                        .resizable()
                                        .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)
                                    
                                    

                                    Button(action: {
                                        
                                    }, label: {
                                            RoundedRectangle(cornerRadius: 3)
                                                  .stroke(Color("BorderGray"), lineWidth: borderWeight)
                                            .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)})
                                                              

                                }
                                Spacer()
                                VStack {
                                    ZStack{
                                        HStack {
                                            Image(systemName: "clock")
                                                .resizable()
                                                .frame(width: getScreenBounds().width * 0.06, height: getScreenBounds().height * 0.027)
                                                .foregroundColor(Color(.systemOrange))
                                                    
                                            TextHelvetica(content: "1:20", size: 20)
                                                .foregroundColor(Color(.systemOrange))
                                        }
                                        
                                        
                                        

                                        Button(action: {}, label: {
                                                RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color(.systemOrange), lineWidth: borderWeight)
                                                .frame(width: getScreenBounds().width * 0.21, height: getScreenBounds().height * 0.04)})
                                                                  

                                    }
                                    ZStack{
                                        
                                        TextHelvetica(content: "13 sets", size: 20)
                                            .foregroundColor(Color(.systemGreen))
                                        

                                        Button(action: {}, label: {
                                                RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color(.systemGreen), lineWidth: borderWeight)
                                                .frame(width: getScreenBounds().width * 0.21, height: getScreenBounds().height * 0.04)})
                                                                  

                                    }
                                }
                            }

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
                                        
                                        TextHelvetica(content: "Start New Workout", size: 43)
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
                            let formattedData = HomePageModel.Workout(id: UUID(), WorkoutName: workout.name, exercises: workout.exercises, category: "not Important")
                            self.selectedDestination = AnyView(workoutLauncher(viewModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden, workout: formattedData, isForAddingToSchedule: false))
                        } else {
                            let formattedData = HomePageModel.Workout(id: UUID(), WorkoutName: "New Workout", exercises: [], category: "not Important")
                            self.selectedDestination = AnyView(workoutLauncher(viewModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden, workout: formattedData, isForAddingToSchedule: false))
                        }
                       
                      
                    }
                   
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundColor(Color("MainGray"))
                            .frame(height: getScreenBounds().height * 0.08)
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                        HStack {
                            Image(systemName: "calendar")
                                .resizable()
                                .foregroundColor(Color("LinkBlue"))
                                .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().width * 0.1)
                                .padding(.horizontal)
                            
                                .padding(.leading, 10)
                     
                            Divider()
                            
                                .frame(width: borderWeight)
                                .overlay(Color("BorderGray"))
                            TextHelvetica(content: "Schedule", size: 27)
                                .padding(.horizontal, 8)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                            Spacer()
                          
                        }.frame(height: getScreenBounds().height * 0.08)
                    }
                    .onTapGesture {
                        HapticManager.instance.impact(style: .rigid)
             
                        self.selectedDestination = AnyView(WeeklyScheduleView(schedule: homePageViewModel, viewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden))
                      
                    }
                   
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundColor(Color("MainGray"))
                            .frame(height: getScreenBounds().height * 0.08)
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                        HStack {
                            Image(systemName: "dumbbell")
                                .resizable()
                                .foregroundColor(Color("LinkBlue"))
                                .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().width * 0.07)
                                .padding(.horizontal)
                            
                                .padding(.leading, 10)
                     
                            Divider()
                            
                                .frame(width: borderWeight)
                                .overlay(Color("BorderGray"))
                            TextHelvetica(content: "My Workouts", size: 27)
                                .foregroundColor(Color("WhiteFontOne"))
                                .padding(.horizontal, 8)
                            
                            Spacer()
                          
                        }.frame(height: getScreenBounds().height * 0.08)
                    }
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
                                TextHelvetica(content: "Stats", size: 20)
                  
                                    .padding(.vertical, 5)
                                    .padding(.leading, -48)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }
                        }
                    }
                    .frame(height: getScreenBounds().width/3.4)
                    .padding(.bottom, 14)
                }
                if homePageViewModel.ongoingWorkout {
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.07)
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
        .navigationBarTitle("back")
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
