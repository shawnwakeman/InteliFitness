//
//  ContentView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI


let borderWeight: CGFloat = 1.7



struct WorkoutLogView: View {
    static let borderWeight: CGFloat = 1.7
    @StateObject var workoutLogViewModel = WorkoutLogViewModel()
    @State private var progressValue: Float = 0.5
    @State private var blocked = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        
        ZStack {
            ScrollView(.vertical){
                
                
                DropDownHeaderView(viewModel: workoutLogViewModel)
                
                
                
                VStack(spacing: 20){
                    if workoutLogViewModel.exersiseModules.count > 0 {
                        
                        ForEach(workoutLogViewModel.exersiseModules){
                            workoutModule in
                            ExersiseLogModule(workoutLogViewModel: workoutLogViewModel, blocked: $blocked, parentModuleID: workoutModule.id)
                        }
                    }
                    
                    FullWidthButton().padding(.top, -40.0).onTapGesture {
                        HapticManager.instance.impact(style: .rigid)
                        workoutLogViewModel.addEmptyWorkoutModule()
                        
                    }
                    
                    
                    
                    
                }
                
                
            }
            
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
                .opacity(workoutLogViewModel.workoutLogModel.popUps[0].RPEpopUpState ? 1 : 0) // need optim
         

            PopupView(viewModel: workoutLogViewModel)
                .shadow(radius: 10)
                .position(x: UIScreen.main.bounds.width/2, y: workoutLogViewModel.getPopUp(popUpId: "popUpRPE").RPEpopUpState ? UIScreen.main.bounds.height - 230 : UIScreen.main.bounds.height + 100)
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
                .opacity(workoutLogViewModel.workoutLogModel.popUps[1].RPEpopUpState ? 1 : 0) // need optim

            DotsMenuView(viewModel: workoutLogViewModel)
                .shadow(radius: 10)
                .position(x: UIScreen.main.bounds.width/2, y: workoutLogViewModel.getPopUp(popUpId: "popUpDotsMenu").RPEpopUpState ? UIScreen.main.bounds.height - 245 : UIScreen.main.bounds.height + 150)

            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
                .opacity(workoutLogViewModel.workoutLogModel.popUps[2].RPEpopUpState ? 1 : 0)
           
            DataMetricsPopUp(viewModel: workoutLogViewModel)
                .position(x: UIScreen.main.bounds.width/2, y: workoutLogViewModel.getPopUp(popUpId: "popUpDataMetrics").RPEpopUpState ? UIScreen.main.bounds.height - 245 : UIScreen.main.bounds.height + 150)
            
//            if workoutLogViewModel.getPopUp(popUpId: "dropDownMenu").RPEpopUpState == false {
//                DropDownMenu(viewModel: workoutLogViewModel)
//            }


        }
        .onTapGesture {
            withAnimation(.spring()) {
                workoutLogViewModel.setPopUpState(state: false, popUpId: "popUpRPE")
                workoutLogViewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
                workoutLogViewModel.setPopUpState(state: false, popUpId: "popUpDataMetrics")
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
                workoutLogViewModel.updateTimeToCurrent()
            case .inactive:
                print("App is inactive")
            case .background:
                workoutLogViewModel.saveBackgroundTime()
            @unknown default:
                fatalError("Unknown scene phase")
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

struct WorkoutTimer : View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var fontSize: CGFloat
    var body: some View{
        ZStack{
        

            let hours = viewModel.workoutTime.timeElapsed / 3600
            let minutes = (viewModel.workoutTime.timeElapsed / 60) - (hours * 60)
            let seconds = viewModel.workoutTime.timeElapsed % 60


            if hours < 1 {
                TextHelvetica(content: "\(minutes):\(String(format: "%02d", seconds))", size: fontSize)
                
            }
            else{
                TextHelvetica(content: "\(String(hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))", size: fontSize)
              
            }
                    
           
            
        }
        
        .onReceive(viewModel.workoutTime.time) { (_) in
            
            if viewModel.workoutTime.timeRunning{
             
    
                
                viewModel.addToTime()
                    
     
            }
                    
               

        }
            
    }
}

struct ExersiseLogModule: View {
    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel
    @Binding var blocked: Bool
    var parentModuleID: Int
    var body: some View {
        VStack(spacing: -20){
            LogModuleHeader(viewModel: workoutLogViewModel, blocked: $blocked, parentModuleID: parentModuleID)
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
            
//                )
                

            


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
            WorkoutTimer(viewModel: viewModel, fontSize: 20)
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
    var body: some View{
        ZStack{
            ZStack{
                
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color("BlueOverlay"))
                    .padding(.all)
                    .aspectRatio(7/1, contentMode: .fill)
                
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color("BlueOverlayBorder"), lineWidth: borderWeight)

                    .padding(.all)
                    .aspectRatio(7/1, contentMode: .fill)
                
            }


            TextHelvetica(content: "add exersise", size: 20)
                .foregroundColor(Color(.white))
        }.padding(.top,-2)
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

            
            
        }.frame(maxWidth: 100, maxHeight: 28)
    }
}








struct LogModuleHeader: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    @Binding var blocked: Bool
    var parentModuleID: Int
    var body: some View{
        
        HStack{
            
            Button {print("Button pressed")}
            label: {
                TextHelvetica(content: viewModel.exersiseModules[parentModuleID].exersiseName, size: 28)
                    .foregroundColor(Color("LinkBlue"))
            }

            Spacer()
            
            addSetButton(parentModuleID: parentModuleID, viewModel: viewModel)
            
            ZStack{
                Image("dataIcon")
                    .resizable()
                    .frame(width: 39.4, height: 28)
                Button(action: {
                    HapticManager.instance.impact(style: .rigid)
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    withAnimation(.spring()) {
                        viewModel.setPopUpState(state: true, popUpId: "popUpDataMetrics")
                        viewModel.setPopUpCurrentRow(exersiseModuleID: parentModuleID, RowID: 0, popUpId: "popUpDataMetrics")
                    }}, label: {
                        RoundedRectangle(cornerRadius: 3)
                              .stroke(Color("BorderGray"), lineWidth: borderWeight)
                              .frame(width: 39.4, height: 28)})
                
            }

            ZStack{
                
                Image("meatBalls")
                    .resizable()
                    .frame(width: 39.4, height: 28)
                
                

                Button(action: {
                    withAnimation(.spring()) {
                        HapticManager.instance.impact(style: .rigid)
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        viewModel.setPopUpState(state: true, popUpId: "popUpDotsMenu")
                        viewModel.setPopUpCurrentRow(exersiseModuleID: parentModuleID, RowID: 0, popUpId: "popUpDotsMenu")
                    }}, label: {
                        RoundedRectangle(cornerRadius: 3)
                              .stroke(Color("BorderGray"), lineWidth: borderWeight)
                              .frame(width: 39.4, height: 28)})
                                          

            }
//    


                
            
        }
        .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
        .padding(.bottom, 9)
        
    }
}

struct CoreLogModule: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var ModuleID: Int
    var body: some View{
        ZStack(){
            
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color("BorderGray"), lineWidth: borderWeight)
                .background(Color.clear)
                .zIndex(1)
            
            
            
            
            VStack(alignment: .leading, spacing: 0){
                Header()
                ContentGrid(viewModel: viewModel, ModuleID: ModuleID)
                
            }
            
        }
        .padding(.all)
    }
}

struct TextHelvetica: View{
    var content: String
    var size: CGFloat
    var body: some View
    {
        Text(content).font(.custom("SpaceGrotesk-Medium", size: size))
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
                    HapticManager.instance.impact(style: .rigid)
                    withAnimation(.spring()) {
                        viewModel.setPopUpState(state: false, popUpId: "popUpRPE")
                    }
                    if selectedRPE != 0 {
                        let popUp = viewModel.getPopUp(popUpId: "popUpRPE")
                        viewModel.setRepMetric(exersiseModuleID: popUp.popUpExersiseModuleIndex, RowID: popUp.popUpRowIndex, RPE: Float(selectedRPE))
                        
                    } else {
                        let popUp = viewModel.getPopUp(popUpId: "popUpRPE")
                        viewModel.setRepMetric(exersiseModuleID: popUp.popUpExersiseModuleIndex, RowID: popUp.popUpRowIndex, RPE: 0)
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
            
            .position(x: 185, y: 25)
            .padding(.horizontal)
            .padding(.vertical, 10)
            HStack {
                switch selectedRPE {
                case 0 :
                    VStack {
                        TextHelvetica(content: "RPE is a way to measure the difficulty of a set.", size: 16)
                            .foregroundColor(Color("GrayFontOne"))
                        TextHelvetica(content: "Tap a number to select an RPE value", size: 16)
                            .foregroundColor(Color("GrayFontOne"))
                        
                    }
                    .multilineTextAlignment(.center)
                    
                case 6:
                    TextHelvetica(content: "You could do 4 more reps before failure.", size: 16)
                        .offset(y: -10)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                case 6.5:
                    VStack {
                        TextHelvetica(content: "You could do 3-4 more reps", size: 16)
                            .foregroundColor(Color("GrayFontOne"))
                        TextHelvetica(content: "before reaching failure.", size: 16)
                            .foregroundColor(Color("GrayFontOne"))
                    }
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
                    TextHelvetica(content: "You could comfortably preform 1 more rep", size: 16)
                        .offset(y: -10)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                    
                case 9.5:
                    TextHelvetica(content: "You could possibly do one more rep before reaching failure", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                case 10:
                    TextHelvetica(content: "Maximun effort. No more reps possible.", size: 16)
                        .offset(y: -10)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                default:

                    TextHelvetica(content: "could not find rpe", size: 16)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                    
                }
            }
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
                                    
                                        .frame(width: 46, height: 55)
                                        .background(Color("WhiteFontOne"))
                                        .border(Color("BorderGray"), width: borderWeight - 0.5)
                                    
                                } else {
                                TextHelvetica(content: String(displayRPE.clean), size: 18)
                                
                                    .frame(width: 46, height: 55)
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
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                     
                        
                    }
                    .offset(x: 10)
                    .padding(.leading, 10)
                    .padding(.vertical, 10)

                }
                
            }
         
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
            .padding(.all)

            
        }
        .frame(maxWidth: 400, maxHeight: 270)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding()


            
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
    var body: some View{
        ZStack{
            Rectangle()
                .cornerRadius(4, corners: [.topLeft, .topRight])
                .foregroundColor(Color("MainGray"))
                .aspectRatio(7.3/1, contentMode: .fill)
            VStack{
                HStack{
                    Spacer()
                    TextHelvetica(content: "Set", size: 24)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x: -2)
                    Spacer()
              
                    TextHelvetica(content: "Previous", size: 24)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    
                    TextHelvetica(content: "Lbs", size: 24)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x:5)
                    Spacer()

                    TextHelvetica(content: "Reps", size: 24)
                        .padding(.trailing)
                        .foregroundColor(Color("WhiteFontOne"))
                
                    Spacer()
                }.offset(x: -13,y: 0)
                
                
         
            }

        }
        Rectangle()
            .frame(height: borderWeight)
            .foregroundColor(Color("BorderGray"))
            
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






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let workoutLogViewModel = WorkoutLogViewModel()
        WorkoutLogView(workoutLogViewModel: workoutLogViewModel)
    }
}
