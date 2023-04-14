//
//  WorkoutSelectionsSheetView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/10/23.
//

import SwiftUI

struct DropDownMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var isToggled = false
    @State private var exersiseNotes: String = ""
    var body: some View {
        // Add a blur effect to the background
   
        VStack(spacing: borderWeight) {
            
            ZStack {
                
                Rectangle()
                    .foregroundColor(Color("DBblack"))
                
                VStack {
                    Button {
                
                    }
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            TextHelvetica(content: "Settings", size: 17)
                                .foregroundColor(Color("WhiteFontOne"))
                        }
                        .frame(width: getScreenBounds().width * 0.92, height: getScreenBounds().height * 0.05)
                      
                    }

                    HStack {
                        
                        Button {
                        
                            }
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                            
                                    .foregroundColor(Color("MainRed"))
                                TextHelvetica(content: "Cancel", size: 16)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }
                        }
                            
                            
                        Button {
                        
                            }
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                    .foregroundColor(Color("MainGray"))
                                
                                TextHelvetica(content: "Pause", size: 16)
                                
                            }
                        }
                            
                            
                        Button {
                        
                            }
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(Color("LinkBlue"))
                                TextHelvetica(content: "Finish", size: 16)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }
                        }
                    }
                    .frame(width: getScreenBounds().width * 0.92, height: getScreenBounds().height * 0.05)                        .frame(width: getScreenBounds().width * 0.92, height: getScreenBounds().height * 0.05)
                
                    
//                    HStack {
//
//
//
//
//
//
//
//
//                        TextField("", text: $exersiseNotes, prompt: Text("Enter notes about your workout here. Your notes will be be displayed every time you do this exercise.").foregroundColor(Color("GrayFontTwo")), axis: .vertical)
//                            .lineLimit(3...5)
//                            .padding(.all, 5)
//                            .font(.custom("SpaceGrotesk-Medium", size: 16))
//                            .foregroundColor(Color("WhiteFontOne"))
//
//
//
//
//
//                    }
//                    .background(Color("DDB"))
//                    .cornerRadius(6)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 6)
//                            .stroke(Color("BorderGray"), lineWidth: borderWeight)
//                    )
//                        .aspectRatio(7/1, contentMode: .fit)
//                        .padding([.leading, .trailing])
//                        .padding(.bottom, 5)
                    HStack {
                        TimerFullSize(viewModel: viewModel)
                            .background(Color("DDB"))
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                            )
                        
                        VStack {
                          
                            HStack {
                                
                                TextHelvetica(content: "Exersise Metrics", size: 19)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .padding([.leading,.top], 10)
                                
                                Spacer()
                            }
                            Divider()
                            
                                .frame(height: borderWeight)
                                .overlay(Color("BorderGray"))
                                .offset(y: -8)
                            VStack(spacing: 4.5) {
                                DisplayRow(metric: "Total Volume", value: "1203 lbs")
                                DisplayRow(metric: "Total Reps", value: "120")
                                DisplayRow(metric: "Weight/Set", value: "142.2 lbs")
                                DisplayRow(metric: "Reps/Set", value: "12.2")
                                DisplayRow(metric: "PR Sets", value: "3/8")
                                    .padding(.bottom, 2)
                            }
                            .frame(height: getScreenBounds().height * 0.157)

                        }
                        .background(Color("DBblack"))
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("BorderGray"), lineWidth: borderWeight)
                        )

             
                            
                          
                           
                            
                
                    }
                    .frame(width: getScreenBounds().width * 0.92, height: getScreenBounds().height * 0.23)
            
                }
                
            }

               
            ZStack {
                let RPEstate = viewModel.getPopUp(popUpId: "DropDownMenu").RPEpopUpState
                Rectangle()
                    .foregroundColor(Color("MainGray"))
                .aspectRatio(3.3, contentMode: .fit)
                
                HStack {
                    ZStack{
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color("DBblack"))
                            
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                            
                        }
                      
                        
                        
                        
                        HStack{
                            Image(systemName: "clock")
                                .foregroundColor(Color("LinkBlue"))
                                .imageScale(.large)
                                .bold()
                            WorkoutTimer(viewModel: viewModel, step: -1, fontSize: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                        }
                        
                        
                        
                    }
                    .frame(width: getScreenBounds().width * 0.25,height: getScreenBounds().height * 0.05)
                    .offset(y: RPEstate ? getScreenBounds().height * 0 : getScreenBounds().height * 0.03)
                    .aspectRatio(2.5, contentMode: .fit)
                    .padding(.leading, 25)
                   
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(.clear)
                        .padding(.horizontal, 50)
                    
                    ProgressBar()
                        .aspectRatio(5, contentMode: .fit)
                        .padding(.trailing,25)
                        .offset(y: RPEstate ? getScreenBounds().height * 0 : getScreenBounds().height * 0.03)
                 
                }
                ElapsedTime(viewModel: viewModel, step: 1, fontSize: 20)
   
                    .foregroundColor(Color("GrayFontOne"))
                    .padding(.horizontal, 50)
                    .offset(y: RPEstate ? getScreenBounds().height * 0 : getScreenBounds().height * 0.03)
            }
            
            
        }
            


        .frame(height: getScreenBounds().height * 0.52)

        .background(Color("BorderGray"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
        .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 5)
        .position(x: UIScreen.main.bounds.width/2, y:200)
//        .position(x: UIScreen.main.bounds.width/2, y:-80)
        
            
        


            
    }
    
    struct DisplayRow: View {
        var metric: String
        var value: String
        var body: some View {
            HStack{
               
                TextHelvetica(content: metric, size: 15)
                    .foregroundColor(Color("WhiteFontOne"))
                
                Spacer()
                
                TextHelvetica(content: value, size: 14)
                    .foregroundColor(Color("WhiteFontOne"))
            }
            .padding(.horizontal, 5)

            
            Divider()
            
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
        }
    }
}

 
struct TimerFullSize : View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State var start = true
    @State var to : CGFloat = 0
    @State var count = 0
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View{
        
        ZStack{
            
            Color.black.opacity(0.0)
            
            VStack{
                
                ZStack{
               
                    Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.black.opacity(0.5), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                  
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(viewModel.restTime.timeElapsed) / 120)
                        .stroke(Color("LinkBlue"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
         
                    .rotationEffect(.init(degrees: -90))
                    
                    
                    VStack{
                       

                        let hours = viewModel.restTime.timeElapsed / 3600
                        let minutes = (viewModel.restTime.timeElapsed / 60) - (hours * 60)
                        let seconds = viewModel.restTime.timeElapsed % 60

                        if viewModel.restTime.timeElapsed > 0 {
                            if hours < 1 {
                                TextHelvetica(content: "\(minutes):\(String(format: "%02d", seconds))", size: 25)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                            else{
                                TextHelvetica(content: "\(String(hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))", size: 25)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                                    
                        } else {
                            TextHelvetica(content: "0:00", size: 25)
                                .foregroundColor(Color("WhiteFontOne"))
                                .fontWeight(.bold)
                        }
                        

                        let hours1 = viewModel.restTime.timePreset / 3600
                        let minutes2 = (viewModel.restTime.timePreset / 60) - (hours * 60)
                        let seconds3 = viewModel.restTime.timePreset % 60
                        if viewModel.restTime.timePreset > 0 {
                            if hours < 1 {
                                TextHelvetica(content: "\(minutes2):\(String(format: "%02d", seconds3))", size: 25)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                            else{
                                TextHelvetica(content: "\(String(hours1)):\(String(format: "%02d", minutes2)):\(String(format: "%02d", seconds3))", size: 25)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                                    
                        } else {
                            TextHelvetica(content: "0:00", size: 25)
                                .foregroundColor(Color("WhiteFontOne"))
                                .fontWeight(.bold)
                        }
                    }
                    
                }
                


                
  
                Button {
            
                }
                label: {
                    ZStack{
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color("BlueOverlay"))

                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)

              
                             
                            
                        }


                        TextHelvetica(content: "Set Rest Time", size: 16)
                            .padding(.all, 7)
                            .foregroundColor(Color(.white))
                    }
                    .aspectRatio(8/1, contentMode: .fit)
                  
                }

     
            }.padding(.all)
            
        }
        .frame(height: getScreenBounds().height * 0.225)
        .background(Color("MainGray"))
    }
    
}
