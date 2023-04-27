//
//  TimerPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/27/23.
//

import SwiftUI

struct TimerPopUp: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var search: String = ""


    
    var body: some View {
        
        ZStack {
   
            VStack(spacing: 0) {
                HStack {


                    TextHelvetica(content: "Exersise Metrics", size: 27)
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
                TimerFullSize(viewModel: viewModel)
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
       

       
    }
    
    
    
    
    
    
    struct ExerciseGroup: View {
        @ObservedObject var viewModel: WorkoutLogViewModel
        var letter: String
        var borderColor = Color("LinkBlue")
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                
                if viewModel.checkLetter(letter: letter){
                    TextHelvetica(content: letter, size: 25)
                        .padding(.horizontal)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        ForEach(viewModel.exersises.filter { workoutModule in
                            if let firstLetter = workoutModule.exerciseName.first {
                                return firstLetter.uppercased() == letter
                            } else {
                                return false
                            }
                        }) { workoutModule in
                            ExersiseRow(viewModel: viewModel, exersiseName: workoutModule.exerciseName, exersiseCatagory: workoutModule.exerciseCategory[0], exerciseEquipment: workoutModule.exerciseEquipment, exersiseID: workoutModule.id)
                           
                            Divider()
                                .frame(height: borderWeight)
                                .overlay(Color("BorderGray"))
                        }
                    
                        
                    }
                    .background(Color("DBblack"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.03)
                        .foregroundColor(.clear)
                    
                }
            }
        }
    }
    struct ExersiseRow: View {
        @ObservedObject var viewModel: WorkoutLogViewModel
        var exersiseName: String
        var exersiseCatagory: String
        var exerciseEquipment: String
        var exersiseID: Int

        var body: some View {
            HStack {
                Button {

                    if viewModel.exersises[exersiseID].selected == false {
                        viewModel.addToExersiseQueue(ExersiseID: exersiseID)
                    } else {
                        viewModel.removeExersiseFromQueue(ExersiseID: exersiseID)
                    }

                    viewModel.setSelectionState(ExersiseID: exersiseID)
                
                }
            label: {
                //                    Image("dataIcon")
                //                        .resizable()
                //                        .frame(width: getScreenBounds().width * 0.15, height: getScreenBounds().height * 0.05)
                VStack(alignment: .leading) {
                    HStack(spacing: 5) {
                        TextHelvetica(content: exersiseName, size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        if exerciseEquipment != "" {
                            TextHelvetica(content: "(" + exerciseEquipment + ")", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                        }
        
                        
                    }
                   
                    TextHelvetica(content: exersiseCatagory, size: 18)
                        .foregroundColor(Color("GrayFontTwo"))
                }
                
                Spacer()
                Button {}
            label: {
                ZStack {
                    if viewModel.exersises[exersiseID].selected == false {
                        RoundedRectangle(cornerRadius: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                       
                                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
                          
                       
                            .foregroundColor(Color("MainGray"))
                        TextHelvetica(content: "?", size: 23)
                            .bold()
                            .foregroundColor(Color("LinkBlue"))
                    } else {
                        
                          Image("checkMark")
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 17, height: 17)
                              
                    }
                  
                  
                    
                }
            }
            .frame(width: getScreenBounds().width * 0.12, height: getScreenBounds().height * 0.04)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            }
            .background(viewModel.exersises[exersiseID].selected ? Color("LinkBlue").opacity(0.3) : Color("LinkBlue").opacity(0))
            
        }
        
    }
    struct Header: View {
        @State private var search: String = ""
        var body: some View {
            VStack {
                
                
                HStack {
                    TextHelvetica(content: "Add Exersises", size: 42)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    
                    Button {}
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            
                            Image(systemName: "plus")
                                .resizable()
                                .bold()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 17)
                                .foregroundColor(Color("LinkBlue"))

                            
                        }
                    }.frame(width: 40, height: 40)
                        
                    
                    
                }
                .frame(width: getScreenBounds().width * 0.94)
                .padding(.bottom, -8)
                
                ZStack {
                    TextField("", text: $search, prompt: Text("Search").foregroundColor(Color("GrayFontTwo")))
                    // not right font also probably wrong on other things.
                        .keyboardType(.decimalPad)
                        .padding(.leading)
                        .multilineTextAlignment(.leading)
                        .autocorrectionDisabled(true)
                        .font(.custom("SpaceGrotesk-Medium", size: 20))
                        .foregroundColor(Color("WhiteFontOne"))
                        .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
                        .background(.clear)
                        .background(Color("DDB"))
                }
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                
                
                HStack {
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("MainGray"))
                            .frame( height: getScreenBounds().height * 0.045)
                            .background(.clear)
                            .background(Color("DDB"))
                        
                        TextHelvetica(content: "Any Body Part", size: 16)
                    }
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("MainGray"))
                            .frame( height: getScreenBounds().height * 0.045)
                            .background(.clear)
                            .background(Color("DDB"))
                        
                        TextHelvetica(content: "Any Category", size: 16)
                    }
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                }
                .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
                
            }.frame(height: getScreenBounds().height * 0.31)
            
        }
    }
    
    struct ExersiseBodyPartButton: View {
        
        @State var isMenuOpen = false
        
        var body: some View {
            ZStack {
                
                Row()
                .displayOnMenuOpen(isMenuOpen, offset: 150)
                
                
                Row()
                .displayOnMenuOpen(isMenuOpen, offset: 100)
                   
                
                Row()
                .frame( height: getScreenBounds().height * 0.045)
                .displayOnMenuOpen(isMenuOpen, offset: 45)

                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(Color("MainGray"))

                        .background(Color("DDB"))
                    Button {
                        isMenuOpen.toggle()
                    }
                    label : {
                        RoundedRectangle(cornerRadius: 6)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                   
                    }
                   
                    
                    TextHelvetica(content: "Any Body Part", size: 16)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .frame( height: getScreenBounds().height * 0.045)
               
            }
        }
        
        
        struct Row: View {
            var body: some View {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(Color("MainGray"))

                        .background(Color("DDB"))
                    Button {
                     
                    }
                    label : {
                        RoundedRectangle(cornerRadius: 6)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                   
                    }
                   
                    
                    TextHelvetica(content: "Any Body Part", size: 16)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .frame( height: getScreenBounds().height * 0.045)
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
                            .trim(from: 0, to: CGFloat(viewModel.restTime.timeElapsed) / CGFloat(viewModel.restTime.timePreset))
                            .stroke(Color("LinkBlue"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
             
                        .rotationEffect(.init(degrees: -90))
                        
                        if viewModel.restTime.timeElapsed < 1 {
                            VStack(spacing: 20) {
                                TextHelvetica(content: "1:00", size: 19)
                                    .onTapGesture {
                                        viewModel.restAddToTime(step: 1, time: 60)
                                        scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(60))
                                    }
                                TextHelvetica(content: "2:00", size: 19)
                                    .onTapGesture {
                                        viewModel.restAddToTime(step: 1, time: 120)
                                        scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(120))
                                    }
                                TextHelvetica(content: "3:00", size: 19)
                                    .onTapGesture {
                                        viewModel.restAddToTime(step: 1, time: 180)
                                        scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(180))
                                    }
                                TextHelvetica(content: "5:00", size: 19)
                                    .onTapGesture {
                                        viewModel.restAddToTime(step: 1, time: 300)
                                        scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(300))
                                    }
                            }
                            .foregroundColor(Color("WhiteFontOne"))
                        } else {
                            VStack{
                               

                                let hours = viewModel.restTime.timeElapsed / 3600
                                let minutes = (viewModel.restTime.timeElapsed / 60) - (hours * 60)
                                let seconds = viewModel.restTime.timeElapsed % 60

                                if viewModel.restTime.timeElapsed > 0 {
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
                       
                        
                    }
                    
                    Rectangle().frame(height: getScreenBounds().height * 0.02).foregroundColor(Color("MainGray"))

                    
                    if viewModel.restTime.timeElapsed < 1 {
                       
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
                    
                    
                      
                    } else {
                        HStack {
                            Button {
                                viewModel.editRestTime(time: viewModel.restTime.timeElapsed + 10)
                                viewModel.setTimePreset(time: viewModel.restTime.timePreset + 10)
                                scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(viewModel.restTime.timeElapsed))
                                if viewModel.restTime.timeElapsed < 0 {
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
                                    viewModel.editRestTime(time: viewModel.restTime.timeElapsed - 10)
                                    viewModel.setTimePreset(time: viewModel.restTime.timePreset - 10)
                                    scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(viewModel.restTime.timeElapsed))
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
                                        viewModel.editRestTime(time: 0)
                                        withAnimation(.spring()) {
                                            viewModel.setPopUpState(state: false, popUpId: "TimerPopUp")
                                        }
                                        
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

