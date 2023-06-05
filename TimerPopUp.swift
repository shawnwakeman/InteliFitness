//
//  TimerPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/27/23.
//

import SwiftUI

struct TimerPopUp: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    @ObservedObject var timeViewModel: TimeViewModel
    @State private var search: String = ""
    @State private var showingAlert: Bool = false

    func RPEexplain() -> Alert {
        Alert(title: Text("Auto Rest Timer"),
              message: Text("Do you want to delete all recurring instances of this workout or just this one?"))
              
             
    }
    var body: some View {
        
        ZStack {
   
            VStack(spacing: 0) {
                HStack {
                    
                    Button {
                        HapticManager.instance.impact(style: .rigid)
                        showingAlert.toggle()
                    }
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            TextHelvetica(content: "?", size: 23)
                                .bold()
                                .foregroundColor(Color("LinkBlue"))
                        
                        }
                        
                            
                    }.frame(width: 50, height: 30)
                    Spacer()

                    TextHelvetica(content: "Rest Timer", size: 27)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                    
                    Button {
                        HapticManager.instance.impact(style: .rigid)
                        withAnimation(.spring()) {
                            viewModel.setPopUpState(state: false, popUpId: "TimerPopUp")
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
                                .foregroundColor(Color("LinkBlue"))
                        }
                        
                            
                    }.frame(width: 50, height: 30)
                    
                }
                .padding(.horizontal)
                .frame(width: getScreenBounds().width * 1, height: getScreenBounds().height * 0.1)
                .background(Color("MainGray"))
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                Rectangle().frame(height: getScreenBounds().height * 0.05).foregroundColor(Color("MainGray"))
                TimerFullSize(viewModel: viewModel, timeViewModel: timeViewModel)
                    .frame(height: getScreenBounds().height * 0.5)
                
                Spacer()
                
                
              
            }
            .frame(height: getScreenBounds().height * 0.65)
            .background(Color("DBblack"))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
            
//            HStack {
//                ExersiseBodyPartButton()
//                ExersiseBodyPartButton()
//            }
//            .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
     
        }
        .alert(isPresented: $showingAlert, content: RPEexplain)
       

       
    }
    
    
    
    
    
    

//    10001
    struct TimerFullSize : View {
        @ObservedObject var viewModel: WorkoutLogViewModel
        @ObservedObject var timeViewModel: TimeViewModel
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
                            .trim(from: 0, to: CGFloat(timeViewModel.restTime.timeElapsed) / CGFloat(timeViewModel.restTime.timePreset))
                            .stroke(Color("LinkBlue"), style: StrokeStyle(lineWidth: 10, lineCap: .round))

                        .rotationEffect(.init(degrees: -90))

                        if timeViewModel.restTime.timeElapsed < 1 {
                            VStack(spacing: 20) {
                                TextHelvetica(content: "1:00", size: 19)
                                    .onTapGesture {
                                        timeViewModel.restAddToTime(step: 1, time: 60)
                                        scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(60))
                                        HapticManager.instance.impact(style: .rigid)
                                    }
                                TextHelvetica(content: "2:00", size: 19)
                                    .onTapGesture {
                                        HapticManager.instance.impact(style: .rigid)
                                        timeViewModel.restAddToTime(step: 1, time: 120)
                                        scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(120))
                                    }
                                TextHelvetica(content: "3:00", size: 19)
                                    .onTapGesture {
                                        HapticManager.instance.impact(style: .rigid)
                                        timeViewModel.restAddToTime(step: 1, time: 180)
                                        scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(180))
                                    }
                                TextHelvetica(content: "5:00", size: 19)
                                    .onTapGesture {
                                        HapticManager.instance.impact(style: .rigid)
                                        timeViewModel.restAddToTime(step: 1, time: 300)
                                        scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(300))
                                    }
                            }
                            .foregroundColor(Color("WhiteFontOne"))
                        } else {
                            VStack{


                                let hours = timeViewModel.restTime.timeElapsed / 3600
                                let minutes = (timeViewModel.restTime.timeElapsed / 60) - (hours * 60)
                                let seconds = timeViewModel.restTime.timeElapsed % 60

                                if timeViewModel.restTime.timeElapsed > 0 {
                                    if hours < 1 {
                                        TextHelvetica(content: "\(minutes):\(String(format: "%02d", seconds))", size: 40)
                                            .foregroundColor(Color("WhiteFontOne"))
                                            .fontWeight(.bold)
                                    }
                                    else{
                                        TextHelvetica(content: "\(String(hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))", size: 40)
                                            .foregroundColor(Color("WhiteFontOne"))
                                            .fontWeight(.bold)
                                    }

                                } else {
                                    TextHelvetica(content: "0:00", size: 40)
                                        .foregroundColor(Color("WhiteFontOne"))
                                        .fontWeight(.bold)
                                }


                                let hours1 = timeViewModel.restTime.timePreset / 3600
                                let minutes2 = (timeViewModel.restTime.timePreset / 60) - (hours * 60)
                                let seconds3 = timeViewModel.restTime.timePreset % 60
                                if timeViewModel.restTime.timePreset > 0 {
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


                    }

                    Rectangle().frame(height: getScreenBounds().height * 0.02).foregroundColor(Color("MainGray"))


                    if timeViewModel.restTime.timeElapsed < 1 {

                        Button {

                        }
                        label: {
                            ZStack{
                                ZStack{

                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.clear)

                                    




                                }


                                
                            }
                            .aspectRatio(8/1, contentMode: .fit)
                    }



                    } else {
                        HStack {
                            Button {
                                HapticManager.instance.impact(style: .rigid)
                                timeViewModel.editRestTime(time: timeViewModel.restTime.timeElapsed + 10)
                                timeViewModel.setTimePreset(time: timeViewModel.restTime.timePreset + 10)
                                scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(timeViewModel.restTime.timeElapsed + 1))
                                if timeViewModel.restTime.timeElapsed < 0 {
                                    withAnimation(.spring()) {
                                        viewModel.setPopUpState(state: false, popUpId: "TimerPopUp")
                                    }
                                }
                            }
                        label: {
                            ZStack{
                                ZStack{

                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(Color("MainGray"))

                                    RoundedRectangle(cornerRadius: 5)
                                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)




                                }


                                TextHelvetica(content: "+ 10s", size: 16)
                                    .padding(.all, 7)
                                    .foregroundColor(Color(.white))
                            }
                        }
                        .aspectRatio(2.5/1, contentMode: .fit)
                                Button {
                                    HapticManager.instance.impact(style: .rigid)
                                    timeViewModel.editRestTime(time: timeViewModel.restTime.timeElapsed - 10)
                                    timeViewModel.setTimePreset(time: timeViewModel.restTime.timePreset - 10)
                                    if timeViewModel.restTime.timeElapsed - 10 > 0 {
                                        scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(timeViewModel.restTime.timeElapsed))
                                    }

                                }
                            label: {
                                ZStack{
                                    ZStack{

                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(Color("MainGray"))

                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)




                                    }


                                    TextHelvetica(content: "- 10s", size: 16)
                                        .padding(.all, 7)
                                        .foregroundColor(Color(.white))
                                }
                                .aspectRatio(2.5/1, contentMode: .fit)
                            }
                                    Button {
                                        cancelNotifications()
                                        timeViewModel.editRestTime(time: 0)
                                        withAnimation(.spring()) {
                                            viewModel.setPopUpState(state: false, popUpId: "TimerPopUp")
                                        }
                                        HapticManager.instance.impact(style: .rigid)
                                    }
                                    

                                label: {
                                    ZStack{
                                        ZStack{

                                            RoundedRectangle(cornerRadius: 5)
                                                .foregroundColor(Color("BlueOverlay"))

                                            RoundedRectangle(cornerRadius: 5)
                                                .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)




                                        }


                                        TextHelvetica(content: "Skip", size: 16)
                                            .padding(.all, 7)
                                            .foregroundColor(Color(.white))
                                    }
                                    .aspectRatio(2.5/1, contentMode: .fit)
                                }
                        }
                        }



                }.padding(.all)

            }

            .background(Color("MainGray"))
        }

    }
    
    
}

