//
//  WorkoutSetRowViewForCreator.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/5/23.
//

import SwiftUI
import Combine
struct WorkoutSetRowViewForCreator: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var rowObject: WorkoutLogModel.ExersiseSetRow
    var moduleID: Int
    var moduleUUID: UUID
    var previous: String
    @State private var lbsTextField: String = ""
    @State private var familyName: String = ""
    @State private var RPEpopUpDisplayed = false

    
    var body: some View{

      
        HStack(spacing: 0){

            
            setIndexView(moduleID: moduleID, moduleUUID: moduleUUID, rowObject: rowObject, viewModel: viewModel)
            
            previousSetView(previous: previous)
            
            lbsTextFieldView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
            
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
  
            
            HStack{

                repTextFieldView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
                if let module = viewModel.exersiseModules[safe: moduleID] {
                    if module.displayingRPE == true {
                        repMetricView(rowObject: rowObject, viewModel: viewModel, moduleID: moduleID)
                    }
                   
                }
            
                
                
            }
            .frame(width: getScreenBounds().width * 0.2)
          

            .background(Color("DDB"))

            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))

            
                
            
            checkBoxView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
            
        }
        .frame(height: getScreenBounds().height * 0.045)
        
    }
    
    
    
    // MARK: - SubStructs(s)
    struct setIndexView: View {
        var moduleID: Int
        var moduleUUID: UUID
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var body: some View {
           
            if rowObject.setType == "N" {
                TextHelvetica(content: String(rowObject.setIndex), size: 20)
                           .padding()
                           .frame(width: getScreenBounds().width * 0.137, height: getScreenBounds().height * 0.03)
                           .foregroundColor(Color("LinkBlue"))
                           .background(.clear)
                           .onTapGesture {
                               viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: UUID())
                             
                               withAnimation(.spring()) {
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                   HapticManager.instance.impact(style: .rigid)
                                   viewModel.setPopUpState(state: true, popUpId: "SetMenuPopUp")
                                   
                     
                               }
                              
                           }
            } else {
                TextHelvetica(content: rowObject.setType, size: 20)
                           .padding()
                           .frame(width: getScreenBounds().width * 0.137, height: getScreenBounds().height * 0.03)
                           .foregroundColor(getTextColor(string: rowObject.setType))
                           .background(.clear)
                           .onTapGesture {
                               viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: UUID())
                               withAnimation(.spring()) {
                                   
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                   HapticManager.instance.impact(style: .rigid)
                                   viewModel.setPopUpState(state: true, popUpId: "SetMenuPopUp")
                                   viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: moduleUUID) // need to change later
                               }
                              
                           }
            }
                   Divider()
                       .frame(width: borderWeight)
                       .overlay(Color("BorderGray"))
        }
    }
    
    struct previousSetView: View {
        var previous: String
        
        var body: some View {
            Group {
                if previous == "0" {
                    Capsule()
                        .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.005)
                        .foregroundColor(Color("GrayFontOne"))
                }
                else
                {
                    TextHelvetica(content: previous, size: 17)
                                    .foregroundColor(Color("GrayFontOne"))
                                    .background(.clear)
                }
            }
            .padding(.horizontal, 1)
            .frame(width: getScreenBounds().width * 0.31, height: getScreenBounds().height * 0.03)


            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
        }
    }
    
    struct lbsTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var lbsTextField: String = ""
        
        
        var body: some View {
            
            TextField("", text: $lbsTextField, prompt: Text(rowObject.weightPlaceholder).foregroundColor(Color("GrayFontTwo")))
                .keyboardType(.decimalPad)
                .autocorrectionDisabled(true)
                .font(.custom("SpaceGrotesk-Medium", size: 20))
                .foregroundColor(Color("GrayFontTwo"))
                .onTapGesture {
                    lbsTextField = lbsTextField
                }

                .frame(width: getScreenBounds().width * 0.18, height: getScreenBounds().height * 0.045)
                .background(.clear)
                .multilineTextAlignment(.center)
                .background(Color("DDB"))
                .onReceive(Just(lbsTextField)) { newValue in
                    var filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered.filter({$0 == "."}).count > 1 {
                        let firstDecimalPointIndex = filtered.firstIndex(of: ".")!
                        filtered = filtered.prefix(upTo: firstDecimalPointIndex) + filtered.suffix(from: filtered.index(after: firstDecimalPointIndex)).filter({$0 != "."})
                    } else if filtered.contains(".") {
                        let parts = filtered.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
                        filtered = String(parts[0].prefix(3)) + "." + String(parts[1].prefix(2))
                    } else {
                        filtered = String(filtered.prefix(3))
                    }
                    
                    if let number = Float(filtered), number > 999.99 {
                        filtered = "999.99"
                    }
                    
                    // Prevent users from entering a lone period
                    if filtered == "." {
                        filtered = ""
                    }
                    
                    lbsTextField = filtered
                }

                .onTapGesture {
                    lbsTextField = lbsTextField
                }


                .onChange(of: lbsTextField) { newValue in
                    viewModel.setWeightValuePlaceHolder(exersiseModuleID: moduleID, RowID: rowObject.id, value: lbsTextField)
                    viewModel.setLastModule(index: moduleID)
                    viewModel.setLastRow(index: rowObject.id)
                }
                .onAppear {
                    if rowObject.weight != 0 {
                        lbsTextField = String(rowObject.weight.clean)
                    }
                    
                }
            
            
        }
    }
    
    struct repTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var repsTextField: String = ""
        

        var body: some View {
            TextField("", text: $repsTextField, prompt: Text(rowObject.repsPlaceholder).foregroundColor(Color("GrayFontTwo")))
                    .keyboardType(.numberPad)
                    .autocorrectionDisabled(true)
                    .font(.custom("SpaceGrotesk-Medium", size: 20))
                    .foregroundColor(Color("GrayFontTwo"))
                    .onTapGesture {
                        repsTextField = repsTextField
                    }

                    .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.045)
                    .background(.clear)
                    .multilineTextAlignment(.center)
                    .background(Color("DDB"))
                    .onReceive(
                        Just(repsTextField)) { newValue in
                        var filtered = newValue.filter { "0123456789".contains($0) }

                        if filtered.count > 2 {
                            // If the filtered string contains more than two digits, limit it to the first two.
                            filtered = String(filtered.prefix(2))
                        }
                        repsTextField = filtered
          
                    }
                       
           
                    .onChange(of: repsTextField) { newValue in
                        viewModel.setRepValuePlaceHolder(exersiseModuleID: moduleID, RowID: rowObject.id, value: repsTextField)
                        viewModel.setLastModule(index: moduleID)
                        viewModel.setLastRow(index: rowObject.id)
                    }
                    .onAppear {
                        if rowObject.reps != 0 {
                            repsTextField = String(rowObject.reps)
                        }
         
                    }
            
            
        }
    }
    
    struct repMetricView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var moduleID: Int
        var body: some View {
            if rowObject.rpeTarget != 0 {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE", exerciseUUID: UUID()) // wront UUID
                                viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)
                   

                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
            
                    TextHelvetica(content: String(rowObject.rpeTarget.clean), size: 13)
                            .foregroundColor(Color("GrayFontOne"))
                   
                   
                       
                    
                }
                
                .padding(.leading, -8)
                .padding(.trailing, 5)
                
            } else {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE", exerciseUUID: UUID()) // wront UUID
                                 viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)
                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
                    TextHelvetica(content: "", size: 13)
                        .foregroundColor(Color.white)
                    
                }
                .onTapGesture {
                    
                    
                    
                }
                .padding(.leading, -8)
                .padding(.trailing, 5)
            }
        }
    }

        
    struct checkBoxView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        var body: some View {
            ZStack {

                Image(systemName: "checkmark")
                    .resizable()
                    .padding(9.0)
                    .bold()
                    .foregroundColor(rowObject.setCompleted ? Color(.systemGreen) : Color("GrayFontOne"))
                    .aspectRatio(40/37, contentMode: .fit)
                    .scaleEffect(rowObject.setCompleted ? 0.9 : 0.7)
              

                ZStack{
                    
                    Rectangle().foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.01))
                    
                    
                }
                .onTapGesture {
                    print(rowObject)
                    if rowObject.reps != 0 && rowObject.weight != 0 {
                        withAnimation(.spring()) {
                            viewModel.toggleCompletedSet(ExersiseModuleID: moduleID, RowID: rowObject.id)
                        }
                            
                            
                            viewModel.setPrevouslyChecked(exersiseModuleID: moduleID, RowID: rowObject.id, state: true)
                            
                            
                            
                       
                        HapticManager.instance.impact(style: .heavy)
                    }
                    else {
                        HapticManager.instance.notification(type: .error)
                    }

                    
                    
                }
                .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.045)
            }


            
            
        }
    }
}


struct WorkoutSetRowViewForCreatorRepsOnly: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    var rowObject: WorkoutLogModel.ExersiseSetRow
    var moduleID: Int
    var moduleUUID: UUID
    var previous: String
    @State private var lbsTextField: String = ""
    @State private var familyName: String = ""
    @State private var RPEpopUpDisplayed = false

    
    var body: some View{

      
        HStack(spacing: 0){

            
            setIndexView(moduleID: moduleID, moduleUUID: moduleUUID, rowObject: rowObject, viewModel: viewModel)
            
            previousSetView(previous: previous)
            
            
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
                .zIndex(1)
            
            HStack{

                repTextFieldView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
                if let module = viewModel.exersiseModules[safe: moduleID] {
                    if module.displayingRPE == true {
                        HStack {
                            Spacer()
                            repMetricView(rowObject: rowObject, viewModel: viewModel, moduleID: moduleID)
                        }
                
                    }
                   
                }
            
                
                
            }
            .frame(width: getScreenBounds().width * 0.38)
          

            .background(Color("DDB"))

            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
                .zIndex(1)

            
                
            
            checkBoxView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
            
        }
        .frame(width: getScreenBounds().width * 0.94)
        .frame(height: getScreenBounds().height * 0.046)
        
    }
    
    
    
    // MARK: - SubStructs(s)
    struct setIndexView: View {
        var moduleID: Int
        var moduleUUID: UUID
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var body: some View {
           
            if rowObject.setType == "N" {
                TextHelvetica(content: String(rowObject.setIndex), size: 20)
                           .padding()
                           .frame(width: getScreenBounds().width * 0.137, height: getScreenBounds().height * 0.03)
                           .foregroundColor(Color("LinkBlue"))
                           .background(.clear)
                           .onTapGesture {
                               viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: UUID())
                             
                               withAnimation(.spring()) {
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                   HapticManager.instance.impact(style: .rigid)
                                   viewModel.setPopUpState(state: true, popUpId: "SetMenuPopUp")
                                   
                     
                               }
                              
                           }
            } else {
                TextHelvetica(content: rowObject.setType, size: 20)
                           .padding()
                           .frame(width: getScreenBounds().width * 0.137, height: getScreenBounds().height * 0.03)
                           .foregroundColor(getTextColor(string: rowObject.setType))
                           .background(.clear)
                           .onTapGesture {
                               viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: UUID())
                               withAnimation(.spring()) {
                                   
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                   HapticManager.instance.impact(style: .rigid)
                                   viewModel.setPopUpState(state: true, popUpId: "SetMenuPopUp")
                                   viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: moduleUUID) // need to change later
                               }
                              
                           }
            }
                   Divider()
                       .frame(width: borderWeight)
                       .overlay(Color("BorderGray"))
        }
    }
    
    struct previousSetView: View {
        var previous: String
        
        var body: some View {
            Group {
                if previous == "0" {
                    Capsule()
                        .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.005)
                        .foregroundColor(Color("GrayFontOne"))
                }
                else
                {
                    TextHelvetica(content: previous, size: 17)
                                    .foregroundColor(Color("GrayFontOne"))
                                    .background(.clear)
                }
            }
            .padding(.horizontal, 1)
            .frame(width: getScreenBounds().width * 0.31, height: getScreenBounds().height * 0.03)


            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
        }
    }
    
    struct lbsTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var lbsTextField: String = ""
        
        
        var body: some View {
            
            TextField("", text: $lbsTextField, prompt: Text(rowObject.weightPlaceholder).foregroundColor(Color("GrayFontTwo")))
                .keyboardType(.decimalPad)
                .autocorrectionDisabled(true)
                .font(.custom("SpaceGrotesk-Medium", size: 20))
                .foregroundColor(Color("GrayFontTwo"))
                .onTapGesture {
                    lbsTextField = lbsTextField
                }

                .frame(width: getScreenBounds().width * 0.28, height: getScreenBounds().height * 0.045)
                .background(.clear)
                .multilineTextAlignment(.center)
                .background(Color("DDB"))
                .onReceive(Just(lbsTextField)) { newValue in
                    var filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered.filter({$0 == "."}).count > 1 {
                        let firstDecimalPointIndex = filtered.firstIndex(of: ".")!
                        filtered = filtered.prefix(upTo: firstDecimalPointIndex) + filtered.suffix(from: filtered.index(after: firstDecimalPointIndex)).filter({$0 != "."})
                    } else if filtered.contains(".") {
                        let parts = filtered.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
                        filtered = String(parts[0].prefix(3)) + "." + String(parts[1].prefix(2))
                    } else {
                        filtered = String(filtered.prefix(3))
                    }
                    
                    if let number = Float(filtered), number > 999.99 {
                        filtered = "999.99"
                    }
                    
                    // Prevent users from entering a lone period
                    if filtered == "." {
                        filtered = ""
                    }
                    
                    lbsTextField = filtered
                }

                .onTapGesture {
                    lbsTextField = lbsTextField
                }


                .onChange(of: lbsTextField) { newValue in
                    viewModel.setWeightValuePlaceHolder(exersiseModuleID: moduleID, RowID: rowObject.id, value: lbsTextField)
                    viewModel.setLastModule(index: moduleID)
                    viewModel.setLastRow(index: rowObject.id)
                }
                .onAppear {
                    if rowObject.weight != 0 {
                        lbsTextField = String(rowObject.weight.clean)
                    }
                    
                }
            
            
        }
    }
    
    struct repTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var repsTextField: String = ""
        

        var body: some View {
            TextField("", text: $repsTextField, prompt: Text(rowObject.repsPlaceholder).foregroundColor(Color("GrayFontTwo")))
                    .keyboardType(.numberPad)
                    .autocorrectionDisabled(true)
                    .font(.custom("SpaceGrotesk-Medium", size: 20))
                    .foregroundColor(Color("GrayFontTwo"))
                    .onTapGesture {
                        repsTextField = repsTextField
                    }

                    .frame(width: getScreenBounds().width * 0.3, height: getScreenBounds().height * 0.045)
                    .background(.clear)
                    .multilineTextAlignment(.center)
                    .background(Color("DDB"))
                    .onReceive(
                        Just(repsTextField)) { newValue in
                        var filtered = newValue.filter { "0123456789".contains($0) }

                        if filtered.count > 2 {
                            // If the filtered string contains more than two digits, limit it to the first two.
                            filtered = String(filtered.prefix(2))
                        }
                        repsTextField = filtered
          
                    }
                       
           
                    .onChange(of: repsTextField) { newValue in
                        viewModel.setRepValuePlaceHolder(exersiseModuleID: moduleID, RowID: rowObject.id, value: repsTextField)
                        viewModel.setLastModule(index: moduleID)
                        viewModel.setLastRow(index: rowObject.id)
                    }
                    .onAppear {
                        if rowObject.reps != 0 {
                            repsTextField = String(rowObject.reps)
                        }
         
                    }
            
            
        }
    }
    
    struct repMetricView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var moduleID: Int
        var body: some View {
            if rowObject.rpeTarget != 0 {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE", exerciseUUID: UUID()) // wront UUID
                                viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)
                   

                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
            
                    TextHelvetica(content: String(rowObject.rpeTarget.clean), size: 13)
                            .foregroundColor(Color("GrayFontOne"))
                   
                   
                       
                    
                }
                
                .padding(.leading, -8)
                .padding(.trailing, 5)
                
            } else {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE", exerciseUUID: UUID()) // wront UUID
                                 viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)
                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
                    TextHelvetica(content: "", size: 13)
                        .foregroundColor(Color.white)
                    
                }
                .onTapGesture {
                    
                    
                    
                }
                .padding(.leading, -8)
                .padding(.trailing, 5)
            }
        }
    }

        
    struct checkBoxView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        var body: some View {
            ZStack {

                Image(systemName: "checkmark")
                    .resizable()
                    .padding(9.0)
                    .bold()
                    .foregroundColor(rowObject.setCompleted ? Color(.systemGreen) : Color("GrayFontOne"))
                    .aspectRatio(40/37, contentMode: .fit)
                    .scaleEffect(rowObject.setCompleted ? 0.9 : 0.7)
              

                ZStack{
                    
                    Rectangle().foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.01))
                    
                    
                }
                .onTapGesture {
                    print(rowObject)
                    if rowObject.reps != 0 && rowObject.weight != 0 {
                        withAnimation(.spring()) {
                            viewModel.toggleCompletedSet(ExersiseModuleID: moduleID, RowID: rowObject.id)
                        }
                            
                         
                            viewModel.setPrevouslyChecked(exersiseModuleID: moduleID, RowID: rowObject.id, state: true)
                            
                            
                            
                       
                        HapticManager.instance.impact(style: .heavy)
                    }
                    else {
                        HapticManager.instance.notification(type: .error)
                    }

                    
                    
                }
                .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.045)
            }


            
            
        }
    }
}

struct WorkoutSetRowViewForCreatorDuration: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    var rowObject: WorkoutLogModel.ExersiseSetRow
    var moduleID: Int
    var moduleUUID: UUID
    var previous: String
    @State private var lbsTextField: String = ""
    @State private var familyName: String = ""
    @State private var RPEpopUpDisplayed = false

    
    var body: some View{

      
        HStack(spacing: 0){

            
            setIndexView(moduleID: moduleID, moduleUUID: moduleUUID, rowObject: rowObject, viewModel: viewModel)
            
            previousSetView(previous: previous)
            
            
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
  
            
            HStack{

                repTextFieldView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
//                if let module = viewModel.exersiseModules[safe: moduleID] {
//                    if module.displayingRPE == true {
//                        repMetricView(rowObject: rowObject, viewModel: viewModel, moduleID: moduleID)
//                    }
//                   
//                }
            
                
                
            }
            .frame(width: getScreenBounds().width * 0.38)
          

            .background(Color("DDB"))

            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))

            
                
            
            checkBoxView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
            
        }
        .frame(height: getScreenBounds().height * 0.045)
        
    }
    
    
    
    // MARK: - SubStructs(s)
    struct setIndexView: View {
        var moduleID: Int
        var moduleUUID: UUID
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var body: some View {
           
            if rowObject.setType == "N" {
                TextHelvetica(content: String(rowObject.setIndex), size: 20)
                           .padding()
                           .frame(width: getScreenBounds().width * 0.137, height: getScreenBounds().height * 0.03)
                           .foregroundColor(Color("LinkBlue"))
                           .background(.clear)
                           .onTapGesture {
                               viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: UUID())
                             
                               withAnimation(.spring()) {
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                   HapticManager.instance.impact(style: .rigid)
                                   viewModel.setPopUpState(state: true, popUpId: "SetMenuPopUp")
                                   
                     
                               }
                              
                           }
            } else {
                TextHelvetica(content: rowObject.setType, size: 20)
                           .padding()
                           .frame(width: getScreenBounds().width * 0.137, height: getScreenBounds().height * 0.03)
                           .foregroundColor(getTextColor(string: rowObject.setType))
                           .background(.clear)
                           .onTapGesture {
                               viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: UUID())
                               withAnimation(.spring()) {
                                   
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                   HapticManager.instance.impact(style: .rigid)
                                   viewModel.setPopUpState(state: true, popUpId: "SetMenuPopUp")
                                   viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: moduleUUID) // need to change later
                               }
                              
                           }
            }
                   Divider()
                       .frame(width: borderWeight)
                       .overlay(Color("BorderGray"))
        }
    }
    
    struct previousSetView: View {
        var previous: String
        
        var body: some View {
            Group {
                if previous == "0" {
                    Capsule()
                        .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.005)
                        .foregroundColor(Color("GrayFontOne"))
                }
                else
                {
                    TextHelvetica(content: previous, size: 17)
                                    .foregroundColor(Color("GrayFontOne"))
                                    .background(.clear)
                }
            }
            .padding(.horizontal, 1)
            .frame(width: getScreenBounds().width * 0.31, height: getScreenBounds().height * 0.03)


            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
        }
    }
    
    struct lbsTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var lbsTextField: String = ""
        
        
        var body: some View {
            
            TextField("", text: $lbsTextField, prompt: Text(rowObject.weightPlaceholder).foregroundColor(Color("GrayFontTwo")))
                .keyboardType(.decimalPad)
                .autocorrectionDisabled(true)
                .font(.custom("SpaceGrotesk-Medium", size: 20))
                .foregroundColor(Color("GrayFontTwo"))
                .onTapGesture {
                    lbsTextField = lbsTextField
                }

                .frame(width: getScreenBounds().width * 0.18, height: getScreenBounds().height * 0.045)
                .background(.clear)
                .multilineTextAlignment(.center)
                .background(Color("DDB"))
                .onReceive(Just(lbsTextField)) { newValue in
                    var filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered.filter({$0 == "."}).count > 1 {
                        let firstDecimalPointIndex = filtered.firstIndex(of: ".")!
                        filtered = filtered.prefix(upTo: firstDecimalPointIndex) + filtered.suffix(from: filtered.index(after: firstDecimalPointIndex)).filter({$0 != "."})
                    } else if filtered.contains(".") {
                        let parts = filtered.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
                        filtered = String(parts[0].prefix(3)) + "." + String(parts[1].prefix(2))
                    } else {
                        filtered = String(filtered.prefix(3))
                    }
                    
                    if let number = Float(filtered), number > 999.99 {
                        filtered = "999.99"
                    }
                    
                    // Prevent users from entering a lone period
                    if filtered == "." {
                        filtered = ""
                    }
                    
                    lbsTextField = filtered
                }

                .onTapGesture {
                    lbsTextField = lbsTextField
                }


                .onChange(of: lbsTextField) { newValue in
                    viewModel.setWeightValuePlaceHolder(exersiseModuleID: moduleID, RowID: rowObject.id, value: lbsTextField)
                    viewModel.setLastModule(index: moduleID)
                    viewModel.setLastRow(index: rowObject.id)
                }
                .onAppear {
                    if rowObject.weight != 0 {
                        lbsTextField = String(rowObject.weight.clean)
                    }
                    
                }
            
            
        }
    }
    
    struct repTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var repsTextField: String = ""
        
        var formattedTime: String {
            let count = repsTextField.count
            var formatted = repsTextField
            if count < 4 {
                formatted = String(repeating: "0", count: 4 - count) + repsTextField
            }
            let min = formatted.prefix(2)
            let sec = formatted.suffix(2)
            return "\(min):\(sec)"
        }

        var body: some View {
            ZStack {
                if formattedTime != "00:00" {
                    Text(formattedTime)
                        .font(.custom("SpaceGrotesk-Medium", size: 20))
                        .foregroundColor(Color("WhiteFontOne"))
                        .frame(width: getScreenBounds().width * 0.14, height: getScreenBounds().height * 0.045)
                     
                } else {
                    Text(formattedTime)
                        .font(.custom("SpaceGrotesk-Medium", size: 20))
                        .foregroundColor(Color("GrayFontOne"))
                        .frame(width: getScreenBounds().width * 0.14, height: getScreenBounds().height * 0.045)
                        
                }
              
                TextField("", text: $repsTextField)
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled(true)
                        .font(.custom("SpaceGrotesk-Medium", size: 20))
                        .foregroundColor(.clear)
                        .frame(width: getScreenBounds().width * 0.14, height: getScreenBounds().height * 0.045)
                        .onTapGesture {
                            repsTextField = repsTextField
                        }

                       
                        .background(.clear)
                        .multilineTextAlignment(.trailing)
               
                        .onChange(of: repsTextField) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered.count > 4 {
                                repsTextField = String(filtered.prefix(4))
                            } else {
                                repsTextField = filtered
                            }
                        }
                
                        .onAppear {
                            if rowObject.reps != 0 {
                                repsTextField = String(rowObject.reps)
                            }
             
                        }
                    
                  
            }
           
           

                       
           
                   
     
            
            
        }
    }
    
    struct repMetricView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var moduleID: Int
        var body: some View {
            if rowObject.rpeTarget != 0 {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE", exerciseUUID: UUID()) // wront UUID
                                viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)
                   

                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
            
                    TextHelvetica(content: String(rowObject.rpeTarget.clean), size: 13)
                            .foregroundColor(Color("GrayFontOne"))
                   
                   
                       
                    
                }
                
                .padding(.leading, -8)
                .padding(.trailing, 5)
                
            } else {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE", exerciseUUID: UUID()) // wront UUID
                                 viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)
                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
                    TextHelvetica(content: "", size: 13)
                        .foregroundColor(Color.white)
                    
                }
                .onTapGesture {
                    
                    
                    
                }
                .padding(.leading, -8)
                .padding(.trailing, 5)
            }
        }
    }

        
    struct checkBoxView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        var body: some View {
            ZStack {

                Image(systemName: "checkmark")
                    .resizable()
                    .padding(9.0)
                    .bold()
                    .foregroundColor(rowObject.setCompleted ? Color(.systemGreen) : Color("GrayFontOne"))
                    .aspectRatio(40/37, contentMode: .fit)
                    .scaleEffect(rowObject.setCompleted ? 0.9 : 0.7)
              

                ZStack{
                    
                    Rectangle().foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.01))
                    
                    
                }
                .onTapGesture {
                    print(rowObject)
                    if rowObject.reps != 0 && rowObject.weight != 0 {
                        withAnimation(.spring()) {
                            viewModel.toggleCompletedSet(ExersiseModuleID: moduleID, RowID: rowObject.id)
                        }
                            
                         
                            viewModel.setPrevouslyChecked(exersiseModuleID: moduleID, RowID: rowObject.id, state: true)
                            
                            
                            
                       
                        HapticManager.instance.impact(style: .heavy)
                    }
                    else {
                        HapticManager.instance.notification(type: .error)
                    }

                    
                    
                }
                .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.045)
            }


            
            
        }
    }
}

struct WorkoutSetRowViewForCreatorCardio: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    var rowObject: WorkoutLogModel.ExersiseSetRow
    var moduleID: Int
    var moduleUUID: UUID
    var previous: String
    @State private var lbsTextField: String = ""
    @State private var familyName: String = ""
    @State private var RPEpopUpDisplayed = false

    
    var body: some View{

      
        HStack(spacing: 0){

            
            setIndexView(moduleID: moduleID, moduleUUID: moduleUUID, rowObject: rowObject, viewModel: viewModel)
            
           
            
            
            previousSetView(previous: previous)
            
            lbsTextFieldView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
            
            
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
  
            
            HStack{

                repTextFieldView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
//                if let module = viewModel.exersiseModules[safe: moduleID] {
//                    if module.displayingRPE == true {
//                        repMetricView(rowObject: rowObject, viewModel: viewModel, moduleID: moduleID)
//                    }
//                   
//                }
            
                
                
            }
            .frame(width: getScreenBounds().width * 0.2)
          

            .background(Color("DDB"))

            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))

            
                
            
            checkBoxView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
            
        }
        .frame(height: getScreenBounds().height * 0.045)
        
    }
    
    
    
    // MARK: - SubStructs(s)
    struct setIndexView: View {
        var moduleID: Int
        var moduleUUID: UUID
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var body: some View {
           
            if rowObject.setType == "N" {
                TextHelvetica(content: String(rowObject.setIndex), size: 20)
                           .padding()
                           .frame(width: getScreenBounds().width * 0.137, height: getScreenBounds().height * 0.03)
                           .foregroundColor(Color("LinkBlue"))
                           .background(.clear)
                           .onTapGesture {
                               viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: UUID())
                             
                               withAnimation(.spring()) {
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                   HapticManager.instance.impact(style: .rigid)
                                   viewModel.setPopUpState(state: true, popUpId: "SetMenuPopUp")
                                   
                     
                               }
                              
                           }
            } else {
                TextHelvetica(content: rowObject.setType, size: 20)
                           .padding()
                           .frame(width: getScreenBounds().width * 0.137, height: getScreenBounds().height * 0.03)
                           .foregroundColor(getTextColor(string: rowObject.setType))
                           .background(.clear)
                           .onTapGesture {
                               viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: UUID())
                               withAnimation(.spring()) {
                                   
                                   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                   HapticManager.instance.impact(style: .rigid)
                                   viewModel.setPopUpState(state: true, popUpId: "SetMenuPopUp")
                                   viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "SetMenuPopUp", exerciseUUID: moduleUUID) // need to change later
                               }
                              
                           }
            }
                   Divider()
                       .frame(width: borderWeight)
                       .overlay(Color("BorderGray"))
        }
    }
    
    struct previousSetView: View {
        var previous: String
        
        var body: some View {
            Group {
                if previous == "0" {
                    Capsule()
                        .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.005)
                        .foregroundColor(Color("GrayFontOne"))
                }
                else
                {
                    TextHelvetica(content: previous, size: 17)
                                    .foregroundColor(Color("GrayFontOne"))
                                    .background(.clear)
                }
            }
            .padding(.horizontal, 1)
            .frame(width: getScreenBounds().width * 0.31, height: getScreenBounds().height * 0.03)


            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
        }
    }
    
    struct lbsTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var lbsTextField: String = ""
        
        
        var body: some View {
            
            TextField("", text: $lbsTextField, prompt: Text(rowObject.weightPlaceholder).foregroundColor(Color("GrayFontTwo")))
                .keyboardType(.decimalPad)
                .autocorrectionDisabled(true)
                .font(.custom("SpaceGrotesk-Medium", size: 20))
                .foregroundColor(Color("GrayFontTwo"))
                .onTapGesture {
                    lbsTextField = lbsTextField
                }

                .frame(width: getScreenBounds().width * 0.18, height: getScreenBounds().height * 0.045)
                .background(.clear)
                .multilineTextAlignment(.center)
                .background(Color("DDB"))
                .onReceive(Just(lbsTextField)) { newValue in
                    var filtered = newValue.filter { "0123456789.".contains($0) }
                    
                    if filtered.filter({$0 == "."}).count > 1 {
                        let firstDecimalPointIndex = filtered.firstIndex(of: ".")!
                        filtered = filtered.prefix(upTo: firstDecimalPointIndex) + filtered.suffix(from: filtered.index(after: firstDecimalPointIndex)).filter({$0 != "."})
                    } else if filtered.contains(".") {
                        let parts = filtered.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
                        filtered = String(parts[0].prefix(3)) + "." + String(parts[1].prefix(2))
                    } else {
                        filtered = String(filtered.prefix(3))
                    }

                    if let number = Float(filtered), number > 999.99 {
                        filtered = "999.99"
                    }

                    // If users enter a lone period, prefix it with 0
                    if filtered == "." {
                        filtered = "0."
                    }

                    lbsTextField = filtered
                }

                .onTapGesture {
                    lbsTextField = lbsTextField
                }


                .onChange(of: lbsTextField) { newValue in
                    viewModel.setWeightValuePlaceHolder(exersiseModuleID: moduleID, RowID: rowObject.id, value: lbsTextField)
                    viewModel.setLastModule(index: moduleID)
                    viewModel.setLastRow(index: rowObject.id)
                }
                .onAppear {
                    if rowObject.weight != 0 {
                        lbsTextField = String(rowObject.weight.clean)
                    }
                    
                }
            
            
        }
    }
    
    struct repTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var repsTextField: String = ""
        
        var formattedTime: String {
            let count = repsTextField.count
            var formatted = repsTextField
            if count < 4 {
                formatted = String(repeating: "0", count: 4 - count) + repsTextField
            }
            let min = formatted.prefix(2)
            let sec = formatted.suffix(2)
            return "\(min):\(sec)"
        }

        var body: some View {
            ZStack {
                if formattedTime != "00:00" {
                    Text(formattedTime)
                        .font(.custom("SpaceGrotesk-Medium", size: 20))
                        .foregroundColor(Color("WhiteFontOne"))
                        .frame(width: getScreenBounds().width * 0.14, height: getScreenBounds().height * 0.045)
                     
                } else {
                    Text(formattedTime)
                        .font(.custom("SpaceGrotesk-Medium", size: 20))
                        .foregroundColor(Color("GrayFontOne"))
                        .frame(width: getScreenBounds().width * 0.14, height: getScreenBounds().height * 0.045)
                        
                }
              
                TextField("", text: $repsTextField)
                        .keyboardType(.numberPad)
                        .autocorrectionDisabled(true)
                        .font(.custom("SpaceGrotesk-Medium", size: 20))
                        .foregroundColor(.clear)
                        .frame(width: getScreenBounds().width * 0.14, height: getScreenBounds().height * 0.045)
                        .onTapGesture {
                            repsTextField = repsTextField
                        }

                       
                        .background(.clear)
                        .multilineTextAlignment(.trailing)
               
                        .onChange(of: repsTextField) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered.count > 4 {
                                repsTextField = String(filtered.prefix(4))
                            } else {
                                repsTextField = filtered
                            }
                        }
                
                        .onAppear {
                            if rowObject.reps != 0 {
                                repsTextField = String(rowObject.reps)
                            }
             
                        }
                    
                  
            }
           
           

                       
           
                   
     
            
            
        }
    }
    
    struct repMetricView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var moduleID: Int
        var body: some View {
            if rowObject.rpeTarget != 0 {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE", exerciseUUID: UUID()) // wront UUID
                                viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)
                   

                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
            
                    TextHelvetica(content: String(rowObject.rpeTarget.clean), size: 13)
                            .foregroundColor(Color("GrayFontOne"))
                   
                   
                       
                    
                }
                
                .padding(.leading, -8)
                .padding(.trailing, 5)
                
            } else {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE", exerciseUUID: UUID()) // wront UUID
                                 viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)
                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
                    TextHelvetica(content: "", size: 13)
                        .foregroundColor(Color.white)
                    
                }
                .onTapGesture {
                    
                    
                    
                }
                .padding(.leading, -8)
                .padding(.trailing, 5)
            }
        }
    }

        
    struct checkBoxView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        var body: some View {
            ZStack {

                Image(systemName: "checkmark")
                    .resizable()
                    .padding(9.0)
                    .bold()
                    .foregroundColor(rowObject.setCompleted ? Color(.systemGreen) : Color("GrayFontOne"))
                    .aspectRatio(40/37, contentMode: .fit)
                    .scaleEffect(rowObject.setCompleted ? 0.9 : 0.7)
              

                ZStack{
                    
                    Rectangle().foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.01))
                    
                    
                }
                .onTapGesture {
                    print(rowObject)
                    if rowObject.reps != 0 && rowObject.weight != 0 {
                        withAnimation(.spring()) {
                            viewModel.toggleCompletedSet(ExersiseModuleID: moduleID, RowID: rowObject.id)
                        }
                            
                         
                            viewModel.setPrevouslyChecked(exersiseModuleID: moduleID, RowID: rowObject.id, state: true)
                            
                            
                            
                       
                        HapticManager.instance.impact(style: .heavy)
                    }
                    else {
                        HapticManager.instance.notification(type: .error)
                    }

                    
                    
                }
                .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.045)
            }


            
            
        }
    }
}
