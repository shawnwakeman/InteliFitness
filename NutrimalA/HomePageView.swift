//
//  HomePageView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/20/23.
//

import SwiftUI

struct HomePageView: View {
    @State private var displayingWorkoutTHing = false
    @StateObject var homePageViewModel = HomePageViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @State private var asdh = true
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                        ZStack {
                            P1View(asdh: $asdh)
                                .offset(x: asdh ? 0 : -geometry.size.width)
                            P2View(asdh: $asdh, viewModel: homePageViewModel)
                                .offset(x: asdh ? geometry.size.width : 0)
                        }
                        .animation(.easeInOut(duration: 0.3))

                    }

         
//
            WorkoutLogView(homePageVeiwModel: homePageViewModel)
                .position(x: getScreenBounds().width/2, y: homePageViewModel.workoutLogModuleStatus ? getScreenBounds().height * 0.6 : getScreenBounds().height * 1.49)
                .ignoresSafeArea()
        }
    }
}


struct P1View: View {

    @Binding var asdh: Bool
    var body: some View {
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
                            VStack(alignment: .leading) {
                                TextHelvetica(content: "Up Next", size: 28)
                                    .foregroundColor(Color("GrayFontOne"))
                                TextHelvetica(content: "Lower Body", size: 43)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .bold()
                            }
                            Spacer()
                        }
                   

                    }
                    .padding(.all)
                    
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
                   
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                            .foregroundColor(Color("MainGray"))
                        VStack(alignment: .leading) {
                            Spacer()
                            TextHelvetica(content: "My", size: 20)
                                .padding(.leading, -10)
                                .foregroundColor(Color("WhiteFontOne"))
                            TextHelvetica(content: "Exercizes", size: 20)
              
    
                                .padding(.leading, -10)
                                .padding(.bottom, 5)
                                .foregroundColor(Color("WhiteFontOne"))
                        }
                     
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
           
            Rectangle()
                .frame(height: getScreenBounds().height * 0.07)
                .foregroundColor(.clear)
            
        } .padding(.all)
            .background(Color("DBblack"))
         
    }
}


struct P2View: View {
  
    @Binding var asdh: Bool
    @ObservedObject var viewModel: HomePageViewModel
    var body: some View {
        MyExercisesPage(viewModel: viewModel, asdh: $asdh)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
