//
//  ContentView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI

import AVFoundation
let borderWeight: CGFloat = 1.7



struct WorkoutLogView: View {
    static let borderWeight: CGFloat = 1.7
    @ObservedObject var homePageVeiwModel: HomePageViewModel
    @StateObject var workoutLogViewModel = WorkoutLogViewModel()
    @State private var progressValue: Float = 0.5
    @State private var blocked = false
    @State private var exersiseNotes: String = ""
    @State private var newModuleOpacity = false

    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        
        ZStack {
            ScrollView(.vertical){
                VStack(spacing: 0) {
                    HStack {
                        TextHelvetica(content: "Lower Body", size: 42)
                            .foregroundColor(Color("WhiteFontOne"))
                            .bold()
                        Spacer()
                    }

 
                    
                    

                    TextField("", text: $exersiseNotes, prompt: Text("Notes").foregroundColor(Color("GrayFontTwo")), axis: .vertical)
                        .lineLimit(1...5)
                        .font(.custom("SpaceGrotesk-Medium", size: 19))
                        .foregroundColor(Color("GrayFontTwo"))


                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.1)

                        .foregroundColor(.clear)


                    }
                    .frame(width: getScreenBounds().width * 0.95)
                    .padding(.top, 150)
                    .padding(.bottom)

                    
                
    
    
                

        

                Spacer()
          
                VStack(spacing: 85){
                    if workoutLogViewModel.exersiseModules.count > 0 {
                        
                        ForEach(workoutLogViewModel.exersiseModules){ workoutModule in

                            if workoutModule.isRemoved == false {
                                ExersiseLogModule(workoutLogViewModel: workoutLogViewModel, blocked: $blocked, parentModuleID: workoutModule.id)

                            }
                        }
                    }
                    
                    FullWidthButton(viewModel: workoutLogViewModel).padding(.top, -90.0)

                    .padding(.bottom, 250)

         
                   
                    
                    
                    
                    
                }
                
        
            }
            
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                if workoutLogViewModel.lastRowUsed != 100 {
//                    let workoutModule = workoutLogViewModel.exersiseModules[workoutLogViewModel.lastModuleUsed]
//                    let reps = workoutModule.setRows[workoutLogViewModel.lastRowUsed].reps
//                    let weight = workoutModule.setRows[workoutLogViewModel.lastRowUsed].weight//
      
//                    if reps != 0 && weight != 0 {
//                        
//                        HapticManager.instance.impact(style: .heavy)
//                        
//                        withAnimation(.spring()) {
//                            workoutLogViewModel.toggleCompletedSet(ExersiseModuleID: workoutModule.id, RowID: workoutModule.setRows[workoutLogViewModel.lastRowUsed].id, customValue: true)
//                        }
//                       
//                        if workoutLogViewModel.exersiseModules[workoutLogViewModel.lastModuleUsed].setRows[workoutLogViewModel.lastRowUsed].prevouslyChecked == false {
//                            
//                            workoutLogViewModel.restAddToTime(step: 1, time: workoutLogViewModel.restTime.timePreset)
//                            scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(workoutLogViewModel.restTime.timePreset))
//                        }
//                        workoutLogViewModel.setPrevouslyChecked(exersiseModuleID: workoutLogViewModel.lastModuleUsed, RowID: workoutLogViewModel.lastRowUsed, state: true)
//                        workoutLogViewModel.setLastRow(index: 100)
//                        workoutLogViewModel.setLastModule(index: 100)
//                        
//                        
//                        
//                  }
//                }
            }
          
            


     
            let popUps = workoutLogViewModel.workoutLogModel.popUps
            let displayStats  = popUps[0].RPEpopUpState || popUps[1].RPEpopUpState || popUps[2].RPEpopUpState || popUps[4].RPEpopUpState || popUps[5].RPEpopUpState || popUps[7].RPEpopUpState
            

            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.black)
                .opacity(displayStats ? 0.65 : 0)
            Group {

                TimerCompletedPopUp(viewModel: workoutLogViewModel)
                    .scaleEffect(workoutLogViewModel.getPopUp(popUpId: "TimerCompletedPopUP").RPEpopUpState ? 1 : 0)
                    .allowsHitTesting(workoutLogViewModel.getPopUp(popUpId: "TimerCompletedPopUP").RPEpopUpState)
                PopupView(viewModel: workoutLogViewModel)
                    .shadow(radius: 10)
                    .position(x: UIScreen.main.bounds.width/2, y: workoutLogViewModel.getPopUp(popUpId: "popUpRPE").RPEpopUpState ? UIScreen.main.bounds.height * 0.72 : UIScreen.main.bounds.height * 1.5)



                DotsMenuView(viewModel: workoutLogViewModel)
                    .shadow(radius: 10)

                    .position(x: getScreenBounds().width/2, y: workoutLogViewModel.getPopUp(popUpId: "popUpDotsMenu").RPEpopUpState ? getScreenBounds().height * 0.52 : getScreenBounds().height * 1.5)



                DataMetricsPopUp(viewModel: workoutLogViewModel)
                    .position(x: getScreenBounds().width/2, y: workoutLogViewModel.getPopUp(popUpId: "popUpDataMetrics").RPEpopUpState ? getScreenBounds().height * 0.7 : getScreenBounds().height * 1.3)

            }
            
          


            


            
            restTimeSet(viewModel: workoutLogViewModel)
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height * 0.3)
                .opacity(workoutLogViewModel.getPopUp(popUpId: "SetTimeSubMenu").RPEpopUpState ? 100 : 0)
            
            
            
            
            


            
            weightUnitSet(viewModel: workoutLogViewModel)
                .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height * 0.3)
                .opacity(workoutLogViewModel.getPopUp(popUpId: "SetUnitSubMenu").RPEpopUpState ? 100 : 0)
            
            
            Group {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .edgesIgnoringSafeArea(.all)
                    .opacity(workoutLogViewModel.workoutLogModel.popUps[3].RPEpopUpState ? 1 : 0)
                
                
                DropDownMenuView(viewModel: workoutLogViewModel, homePageViewModel: homePageVeiwModel)
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height * 0.24)
                    .onTapGesture {
                        
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                      
                        withAnimation(.spring()) {
                            if homePageVeiwModel.workoutLogModuleStatus == true {
                                homePageVeiwModel.setWorkoutLogModuleStatus(state: false)
                            }
                            else {
                                homePageVeiwModel.setWorkoutLogModuleStatus(state: true)
                            }
                            
                            
                        }
                    }


            }
          
            Group {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .edgesIgnoringSafeArea(.all)
                    .opacity(workoutLogViewModel.workoutLogModel.popUps[6].RPEpopUpState ? 1 : 0)
                    .offset(y: getScreenBounds().height * -0.07)
                AddExersisesPopUp(viewModel: workoutLogViewModel)
                    .position(x: getScreenBounds().width/2, y: workoutLogViewModel.getPopUp(popUpId: "ExersisesPopUp").RPEpopUpState ? getScreenBounds().height * 0.42 : getScreenBounds().height * 2) // shout be two
            }
         
          
        }
        .ignoresSafeArea(.keyboard)
       
        .onTapGesture {
          
 
            withAnimation(.spring()) {
                workoutLogViewModel.setPopUpState(state: false, popUpId: "popUpRPE")
                workoutLogViewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                workoutLogViewModel.setPopUpState(state: false, popUpId: "popUpDataMetrics")
                workoutLogViewModel.setPopUpState(state: false, popUpId: "DropDownMenu")
                workoutLogViewModel.setPopUpState(state: false, popUpId: "TimerCompletedPopUP")
            }

            withAnimation(.spring(response: 0))
            {
                for key in workoutLogViewModel.popUpStates.keys {
                    workoutLogViewModel.popUpStates[key] = false
                }
               
            }

            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .background(
            LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 15/255, green: 18/255, blue: 23/255),
                Color(red: 15/255, green: 18/255, blue: 29/255)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
  
                workoutLogViewModel.loadExersiseModules()
                homePageVeiwModel.loadHistory()

            case .inactive:
                print("App is inactive")
            case .background:
        
                workoutLogViewModel.saveExersiseModules()
             
                homePageVeiwModel.saveExersiseHistory()
        
            @unknown default:
                fatalError("Unknown scene phase")
            }
        }
        .onAppear(perform: requestNotificationPermission)
    }
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
                return
            }

            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    

}
    
struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}

    
//    init() {
//        for famliyName in UIFont.familyNames {
//            print(famliyName)
//            for fontName in UIFont.fontNames(forFamilyName: famliyName){
//                print(fontName)
//            }
//
//        }
//    }
    


//struct SoundTester: View{
//    var body: some View{
//        Button("1") {HapticManager.instance.notification(type: .success)}
//        Button("2") {HapticManager.instance.notification(type: .warning)}
//        Button("3") {HapticManager.instance.notification(type: .error)}
//        Button("4") {HapticManager.instance.impact(style: .heavy)}
//        Button("5") {HapticManager.instance.impact(style: .light)}
//        Button("6") {HapticManager.instance.impact(style: .medium)}
//        Button("7") {HapticManager.instance.impact(style: .rigid)}
//        Button("8") {HapticManager.instance.impact(style: .soft)}
//    }
//
//}

struct ElapsedTime : View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var step: Int
    var fontSize: CGFloat
    var body: some View{
        ZStack{
        

            let hours = viewModel.workoutTime.timeElapsed / 3600
            let minutes = (viewModel.workoutTime.timeElapsed / 60) - (hours * 60)
            let seconds = viewModel.workoutTime.timeElapsed % 60

            if viewModel.workoutTime.timeElapsed > 0 {
                if hours < 1 {
                    TextHelvetica(content: "\(minutes):\(String(format: "%02d", seconds))", size: fontSize)
                    
                }
                else{
                    TextHelvetica(content: "\(String(hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))", size: fontSize)
                  
                }
                        
            } else {
                TextHelvetica(content: "0:00", size: fontSize)
            }
           
           
            
        }
        
        .onReceive(viewModel.workoutTime.time) { (_) in
            
            if viewModel.workoutTime.timeRunning{
             
    
                
                viewModel.addToTime(step: step)
                    
     
            }
                    
               

        }
        

            
    }
    
}

struct WorkoutTimer : View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var step: Int
    var fontSize: CGFloat
    var body: some View{
        ZStack{
        

            let hours = viewModel.restTime.timeElapsed / 3600
            let minutes = (viewModel.restTime.timeElapsed / 60) - (hours * 60)
            let seconds = viewModel.restTime.timeElapsed % 60

            if viewModel.restTime.timeElapsed > 0 {
                if hours < 1 {
                    TextHelvetica(content: "\(minutes):\(String(format: "%02d", seconds))", size: fontSize)
                    
                }
                else{
                    TextHelvetica(content: "\(String(hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))", size: fontSize)
                  
                }
                        
            }
           
           
            
        }
        
        .onReceive(viewModel.workoutTime.time) { (_) in
            
            if viewModel.restTime.timeRunning{
             
    

                viewModel.restAddToTime(step: step)
 
            }

        }
        .onChange(of: viewModel.restTime.timeElapsed) { timeElapsed in

            if timeElapsed == 0 {
                withAnimation(.spring()) {
                    viewModel.setPopUpState(state: true, popUpId: "TimerCompletedPopUP")
                }
                HapticManager.instance.notification(type: .success)
            
            }
        }
            
    }
}

struct ExersiseLogModule: View {
    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel
    @Binding var blocked: Bool
    var parentModuleID: Int
    var body: some View {
        VStack(spacing: -2){
            LogModuleHeader(viewModel: workoutLogViewModel, blocked: $blocked, parentModuleID: parentModuleID)
            if workoutLogViewModel.exersiseModules[parentModuleID].displayingNotes {
                
                NotesModule(viewModel: workoutLogViewModel, parentModuleID: parentModuleID)
            }
            CoreLogModule(viewModel: workoutLogViewModel, ModuleID: parentModuleID)
        }

    }
}
struct DropDownHeaderView: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var body: some View {
        ZStack{
            
            
            
           
            ZStack{
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(Color("MainGray"))
                    .padding(.vertical, -4.0)
                    .padding(.horizontal, -1)
                    .frame(height: 40)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                    .padding(.vertical, -4.0)
                    .padding(.horizontal, -1)
                    .frame(height: 40)
            }

            
            Rectangle()
            
                .size(width:430, height: 1000)
                .offset(y:-950)
                .foregroundColor(Color("MainGray"))
            

                

            


            HStack(alignment: .top){
                Spacer()
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
                    
                        TextHelvetica(content: "1:23", size: 20)
                            .foregroundColor(Color("WhiteFontOne"))
                    }
                    
                    
                }
                .padding(.bottom)
                .frame(maxWidth: 110, maxHeight: 55)
                
                Divider().frame(width: 120)
                    .opacity(0)
                
                
                
                
                
                
                
                VStack(alignment: .center) {
                    ProgressBar().frame(height: 20)
                    Spacer()
                }
                .padding([.top, .leading, .bottom])
                .padding(.trailing, 4)
                .offset(y:-5)
                .frame(maxWidth: 150)
                
            }
            .padding(.all, 21.0)
            WorkoutTimer(viewModel: viewModel, step: 1, fontSize: 20)
                .padding(.bottom, 17.0)
                .foregroundColor(Color("GrayFontOne"))

        }.offset(x:0, y: -19)
    }
}

struct ProgressBar: View {

    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {

                    
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .foregroundColor(Color("DBblack"))
                    .cornerRadius(45.0)
                    
                
                Rectangle().frame(width: min(CGFloat(0.5)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .cornerRadius(45)
                
                Capsule()
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
            }
        }
    }
}

struct FullWidthButton: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var isPresented = true
    var body: some View{
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color("BlueOverlay"))
                    .padding(.vertical)
                    .padding(.horizontal, 10)
                    .aspectRatio(7/1, contentMode: .fill)
            }
                
            Button {
                withAnimation(.spring()) {
                    viewModel.setPopUpState(state: true, popUpId: "ExersisesPopUp")
                }
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            label: {
                ZStack{
                    ZStack{
                        

                        
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)

                            .padding(.vertical)
                            .padding(.horizontal, 10)
                            .aspectRatio(7/1, contentMode: .fill)
                        
                    }


                    TextHelvetica(content: "Add Exersise", size: 20)
                        .foregroundColor(Color(.white))
                }
            }
            
        }
        



    }
    
}





struct addSetButton: View {
    var parentModuleID: Int
    @ObservedObject var viewModel: WorkoutLogViewModel
    var body: some View{
        Button {
            HapticManager.instance.impact(style: .rigid)
            viewModel.addEmptySet(moduleID: parentModuleID)
        }
        
        label: {
            ZStack{
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color("ClearBlueBorder"))
                

                TextHelvetica(content: "add set", size: 20)
                    .foregroundColor(Color(.white))
            }

            
            
        }
        .frame(width: getScreenBounds().width * 0.24, height: getScreenBounds().height * 0.03)
    }
}








struct LogModuleHeader: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    @Binding var blocked: Bool
    var parentModuleID: Int
    var body: some View{
      
            
            HStack(alignment: .bottom){
              
                
                    
                    


                Button {print("Button pressed")}
                label: {
                    HStack(alignment: .bottom, spacing: 6) {
                        TextHelvetica(content: viewModel.exersiseModules[parentModuleID].exersiseName, size: 22)
                            .foregroundColor(Color("LinkBlue"))
                            .multilineTextAlignment(.leading)
                        HStack(spacing: 0) {
                            if viewModel.exersiseModules[parentModuleID].ExersiseEquipment != "" {
                                TextHelvetica(content: "(", size: 22)
                                TextHelvetica(content: viewModel.exersiseModules[parentModuleID].ExersiseEquipment, size: 22)
                                    .offset(y: 1.7)
                      
                                TextHelvetica(content: ")", size: 22)
                            }
                            
                        }
                        
                        .foregroundColor(Color("LinkBlue"))

                    }
     
                }

                Spacer()
                
      
                
                ZStack{
                    Image("dataIcon")
                        .resizable()
                        .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)
                    Button(action: {
                        HapticManager.instance.impact(style: .rigid)
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        withAnimation(.spring()) {
                            viewModel.setPopUpState(state: true, popUpId: "popUpDataMetrics")
                            viewModel.setPopUpCurrentRow(exersiseModuleID: parentModuleID, RowID: 0, popUpId: "popUpDataMetrics")
                        }}, label: {
                            RoundedRectangle(cornerRadius: 3)
                                  .stroke(Color("BorderGray"), lineWidth: borderWeight)
                            .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)})
                    
                }

                ZStack{
                    
                    Image("meatBalls")
                        .resizable()
                        .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)
                    
                    

                    Button(action: {
                        withAnimation(.spring()) {
                            HapticManager.instance.impact(style: .rigid)
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            viewModel.setPopUpState(state: true, popUpId: "popUpDotsMenu")
                            viewModel.setPopUpCurrentRow(exersiseModuleID: parentModuleID, RowID: 0, popUpId: "popUpDotsMenu")
                        }}, label: {
                            RoundedRectangle(cornerRadius: 3)
                                  .stroke(Color("BorderGray"), lineWidth: borderWeight)
                            .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)})
                                              

                }
    //


                    
                
            }
            .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/, 12)
            .padding(.bottom, 9)
       
        
    }
}

struct NotesModule: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var notes = ""
    var parentModuleID: Int
    var body: some View{
        HStack {

            ZStack {

                    
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                Image(systemName: "note.text")
                    .foregroundColor(Color("LinkBlue"))
                    .imageScale(.large)
                    .bold()
                    .multilineTextAlignment(.leading)
              
                    
                    
            }
            .frame(maxWidth: 40, maxHeight: 40)

            .padding(.leading)

                
                
         
            TextField("", text: $notes, prompt: Text("Enter notes about your workout here. Your notes will be be displayed every time you do this exercise.").foregroundColor(Color("GrayFontTwo")), axis: .vertical)
                .lineLimit(3...5)
                .padding(.all, 5)
                .font(.custom("SpaceGrotesk-Medium", size: 16))
                .foregroundColor(Color("WhiteFontOne"))

                


            
        }
        .background(Color("DDB"))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color("BorderGray"), lineWidth: borderWeight)
        )
        .padding(.top, -10)
        .padding(.bottom,3)
        .padding(.all,12)
    }
}
struct CoreLogModule: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var ModuleID: Int
    var body: some View{
      
        ZStack{
            
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color("BorderGray"), lineWidth: borderWeight)
                .background(Color.clear)
                .zIndex(1)
            
            
            
            
            VStack(alignment: .leading, spacing: 0){
                Header(viewModel: viewModel, parentModuleID: ModuleID)
                ContentGrid(viewModel: viewModel, ModuleID: ModuleID)
                
            }
            
        }
        .frame(width: getScreenBounds().width * 0.9)
    }
}

struct TextHelvetica: View{
    var content: String
    var size: CGFloat
    var body: some View
    {
        Text(content).font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (size * 0.0025)))
    }
}

struct PopupView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var isToggled = false
    @State private var selectedRPE = 0.0

    var body: some View {
        // Add a blur effect to the background
        
        VStack {
            HStack {
                
                Button {HapticManager.instance.impact(style: .rigid)}
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
                }.frame(width: 60, height: 40)
              
                
                
                Spacer()
                TextHelvetica(content: "RPE", size: 25)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                
                
                
                Button {
                    let popUp = viewModel.getPopUp(popUpId: "popUpRPE")
    
                    withAnimation(.spring()) {
                        viewModel.setPopUpState(state: false, popUpId: "popUpRPE")
                    }
                    if selectedRPE != 0 {
                       
                        viewModel.setRepMetric(exersiseModuleID: popUp.popUpExersiseModuleIndex, RowID: popUp.popUpRowIndex, RPE: Float(selectedRPE))
                        
                    } else {
                   
                        viewModel.setRepMetric(exersiseModuleID: popUp.popUpExersiseModuleIndex, RowID: popUp.popUpRowIndex, RPE: 0)
                    }
                    HapticManager.instance.impact(style: .rigid)

                    if viewModel.lastRowUsed != 100 {
                        let workoutModule = viewModel.exersiseModules[viewModel.lastModuleUsed]
                        let reps = workoutModule.setRows[viewModel.lastRowUsed].reps
                        let weight = workoutModule.setRows[viewModel.lastRowUsed].weight//
                        let RPE = workoutModule.setRows[viewModel.lastRowUsed].repMetric
                        if reps != 0 && weight != 0 && RPE != 0 {
                            
               
                            
                            
                            viewModel.toggleCompletedSet(ExersiseModuleID: workoutModule.id, RowID: workoutModule.setRows[viewModel.lastRowUsed].id, customValue: true)

                            
                        }
                        
                        if viewModel.exersiseModules[viewModel.lastModuleUsed].setRows[viewModel.lastRowUsed].prevouslyChecked == false {
                          
                            viewModel.restAddToTime(step: 1, time: viewModel.restTime.timePreset)
                            scheduleNotification(title: "Rest time is up", body: "insert next exersise", interval: TimeInterval(viewModel.restTime.timePreset))
                        }
                        viewModel.setPrevouslyChecked(exersiseModuleID: viewModel.lastModuleUsed, RowID: viewModel.lastRowUsed, state: true)
                        viewModel.setLastRow(index: 100)
                        viewModel.setLastModule(index: 100)
                        
                      
                    }
                    
                }
                
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
                            .foregroundColor(Color("MainGray"))
                        if selectedRPE == 0 {
                            Image(systemName: "xmark")
                                .resizable()
                                .bold()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 17)
                                .foregroundColor(Color("LinkBlue"))
                                
                        } else {
                            Image("checkMark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 17)
                                  
                        }
                        

                    }
                    .offset(x: -10)
                    .frame(width: 60, height: 40)
                    
                        
                }.frame(maxWidth: 50)
                

                
            }
            .padding(.top, -8)
            
            .padding(.horizontal)
            .padding(.vertical, 10)
            HStack {
                switch selectedRPE {
                case 0 :
                  
                    TextHelvetica(content: "RPE is a way to measure the difficulty of a set. Tap a number to select an RPE value", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                case 6:
                    TextHelvetica(content: "You could do 4 more reps before failure.", size: 16)
                        .offset(y: -10)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                case 6.5:
                  
                    TextHelvetica(content: "You could do 3-4 more reps before reaching failure.", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
    

                case 7:
                    TextHelvetica(content: "You could comfortably preform 3 more reps before failure.", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                case 7.5:
                    TextHelvetica(content: "You could preform 2-3 more reps before reaching failure.", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                case 8:
                    TextHelvetica(content: "You could comfortably preform 2 more reps before failure.", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                case 8.5:
                    TextHelvetica(content: "You could preform 1-2 more reps before reaching failure.", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                case 9:
                    TextHelvetica(content: "You could comfortably preform 1 more rep before reaching failure.", size: 16)
               
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
             
                    
                case 9.5:
                    TextHelvetica(content: "You could possibly do one more rep before reaching failure", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                case 10:
                    TextHelvetica(content: "Maximun effort. No more reps possible.", size: 16)

                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 13)
                default:

                    TextHelvetica(content: "could not find rpe", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                    
                }
            }
            .padding(.horizontal, 10)
            .offset(y: 10)

            Rectangle()
                .frame(height: getScreenBounds().height * 0.02)
                .foregroundColor(.clear)
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    
                    
                    ForEach(13..<21) { index in
                        let displayRPE = Float(index) / 2
                        Button(action: {
                     
                            HapticManager.instance.impact(style: .rigid)
                     
                            if Float(selectedRPE) == displayRPE { selectedRPE = 0}
                            else { selectedRPE = Double(displayRPE) }}) {
                                
                                if Float(selectedRPE) == displayRPE {
                                    TextHelvetica(content: String(displayRPE.clean), size: 18)
                                    
                                        .frame(width: getScreenBounds().width * 0.11, height: getScreenBounds().height * 0.07)
                                        .background(Color("WhiteFontOne"))
                                        .border(Color("BorderGray"), width: borderWeight - 0.5)
                                    
                                } else {
                                TextHelvetica(content: String(displayRPE.clean), size: 18)
                                
                                        .frame(width: getScreenBounds().width * 0.11, height: getScreenBounds().height * 0.07)
                                    .background(Color("MainGray"))
                                    .border(Color("BorderGray"), width: borderWeight - 0.5)
                                
                                }
                        }

                    }
                
                }
                
                
                .background(Color("DDB"))
            
                
                
                Divider()
                    
                    .frame(height: borderWeight-0.8)
         
                    .overlay(Color("BorderGray"))


                HStack {
                    HStack {
                        TextHelvetica(content: "Target", size: 19)
                                .foregroundColor(Color("GrayFontOne"))
                            Divider()
                            .frame(width: borderWeight, height: 20)
                            .overlay(Color("BorderGray"))
 
                            TextHelvetica(content: "10.5", size: 18)
                                .foregroundColor(Color("GrayFontOne"))
                              
        
                    }
                    .padding(.trailing, 5)
                    .padding(.all, 10)
                   
                    Divider()
                        
                        .frame(width: borderWeight, height: 51)
             
                        .overlay(Color("BorderGray"))
                        .offset(x: 7)
                    
                    HStack(spacing: 0) {
                        TextHelvetica(content: "Show RPE", size: 18)
                            .foregroundColor(Color("GrayFontOne"))
                            .padding(.trailing, 9)
                        Divider()
                        .frame(width: borderWeight, height: 20)
                            .overlay(Color("BorderGray"))
                        
                        Toggle("", isOn: $isToggled)
                            .frame(maxWidth: 52)
                            .toggleStyle(SwitchToggleStyle(tint: Color("LinkBlue")))
                     
                        
                    }
                    .offset(x: 2)
                    .padding(.leading, 10)
                    .padding(.vertical, 10)

                }
                
            }
     
            .frame(width: getScreenBounds().width * 0.88, height: getScreenBounds().height * 0.12)
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))


            
        }
        .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.33)

        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))



            
    }
}




struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct ContentGrid: View {
    @ObservedObject var viewModel: WorkoutLogViewModel

    var ModuleID: Int
    var body: some View{
        
        let module = viewModel.exersiseModules[ModuleID]
        
        ForEach(module.setRows){
            row in
            WorkoutSetRowView(viewModel: viewModel, rowObject: row, moduleID: ModuleID)

              
      
            if (row.id != module.setRows.indices.last){
                Divider()
                    
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
            }
            

                



        }
        
    }
}



struct Header: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var parentModuleID: Int
    var body: some View{
        ZStack{
            Rectangle()
                .cornerRadius(4, corners: [.topLeft, .topRight])
                .foregroundColor(Color("MainGray"))
                .aspectRatio(7.3/1, contentMode: .fill)
            VStack{
                HStack{
                    Spacer()
                    TextHelvetica(content: "Set", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x: 2)
                    Spacer()
              
                    TextHelvetica(content: "Previous", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    
                    TextHelvetica(content: "Lbs", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x:5)
                    Spacer()

                    TextHelvetica(content: "Reps", size: 20)
                        .padding(.trailing)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x:7)
                    Button {
                        HapticManager.instance.impact(style: .rigid)
              
                        viewModel.addEmptySet(moduleID: parentModuleID)
              
 
                    }
                    
                    label: {
                        Image(systemName: "plus.app.fill")
                            .scaleEffect(1.8)
                            .foregroundColor(Color("LinkBlue"))
                            .offset(x: 8)

                        
                        
                    }

                }.offset(x: -20,y: 2)
                
                
         
            }

        }
        Divider()
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))
            
    }
}




struct DividerView: View {
    var isHorizontal: Bool
    var dividerColor = "BorderGray"
    var body: some View {
        if isHorizontal {
            Divider()
                .frame(height: borderWeight)
                .overlay(Color("dividerColor"))
        } else {
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("dividerColor"))
        }
    }
}



extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}



extension View{
   func getScreenBounds() -> CGRect{
   return UIScreen.main.bounds
   }
}

func scheduleNotification(title: String, body: String, interval: TimeInterval) {
    let notificationCenter = UNUserNotificationCenter.current()
    
    notificationCenter.removeAllPendingNotificationRequests()
    // Create the content of the notification
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.defaultRingtone // should add custom sound later

    // Create a trigger for the notification
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)

    // Create a request with a unique identifier
    let requestIdentifier = UUID().uuidString
    let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)

    // Add the request to the notification center
    notificationCenter.add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error)")
        } else {
            print("Notification scheduled with identifier: \(requestIdentifier)")
        }
    }
}
