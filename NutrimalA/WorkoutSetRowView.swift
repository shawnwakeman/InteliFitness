//
//  WorkoutSetRowView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/7/23.
//

import SwiftUI

struct WorkoutSetRowView: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    var rowObject: WorkoutLogModel.ExersiseSetRow
    var moduleID: Int
    @State private var lbsTextField: String = ""
    @State private var familyName: String = ""
    @State private var RPEpopUpDisplayed = false

    
    var body: some View{

        
        HStack(spacing: 0){

            
            setIndexView(rowObject: rowObject)
            
            previousSetView(rowObject: rowObject)
            
            lbsTextFieldView(rowObject: rowObject)
            
            DividerView(isHorizontal: false)
            
            HStack{

                repTextFieldView(rowObject: rowObject)
                repMetricView(rowObject: rowObject, viewModel: viewModel, moduleID: moduleID)
                
            }
            .frame(width: 80, height: 40)
            .background(Color("DDB"))
            

            DividerView(isHorizontal: false)
            
            checkBoxView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
            
        }
    }
    
    
    
    // MARK: - SubStructs(s)
    struct setIndexView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        
        var body: some View {
            TextHelvetica(content: String(rowObject.setIndex), size: 21)
                       .padding()
                       .frame(width: 55, height: 40)
                       .foregroundColor(Color("LinkBlue"))
                       .background(.clear)
                   Divider()
                       .frame(width: borderWeight)
                       .overlay(Color("BorderGray"))
        }
    }
    
    struct previousSetView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        
        var body: some View {
            if rowObject.previousSet == "0" {
                Capsule()
                    .padding(.horizontal, 50.0)
                    .padding(.vertical, 18)
                    .frame(width: 145, height: 40)
                    .foregroundColor(Color("GrayFontOne"))
            }
            else
            {
                TextHelvetica(content: rowObject.previousSet, size: 21)
                                .frame(width: 145, height: 40)
                                .foregroundColor(Color("GrayFontOne"))
                                .background(.clear)
            }

            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
        }
    }
    
    struct lbsTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow

        @State private var lbsTextField: String = ""
        var body: some View {
            TextField("", text: $lbsTextField, prompt: Text(rowObject.weightPlaceholder).foregroundColor(Color("GrayFontTwo")))
                .keyboardType(.decimalPad)
                .autocorrectionDisabled(true)
                .font(.custom("SpaceGrotesk-Medium", size: 21))
                .foregroundColor(Color("WhiteFontOne"))
                .frame(width: 70, height: 40)
                .background(.clear)
                .multilineTextAlignment(.center)
                .background(Color("DDB"))

                
            
            
        }
    }
    
    struct repTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow

        @State private var repsTextField: String = ""
        var body: some View {
            TextField("", text: $repsTextField, prompt: Text(rowObject.repsPlaceholder).foregroundColor(Color("GrayFontTwo")))
                    .keyboardType(.numberPad)
                    .autocorrectionDisabled(true)
                    .font(.custom("SpaceGrotesk-Medium", size: 21))
                    .foregroundColor(Color("WhiteFontOne"))
                    .frame(minWidth: 40, minHeight: 40)
                    .background(.clear)
                    .multilineTextAlignment(.center)
                    .background(Color("DDB"))


            
            
        }
    }
    
    struct repMetricView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var moduleID: Int
        var body: some View {
            if let row = rowObject.repMetric {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: 30)
                        
                        Capsule()
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                            .padding(.vertical, 9.0)
                        
                        
                            .frame(width: 30)
                    }
                    
                    TextHelvetica(content: String(row.clean), size: 13)
                        .foregroundColor(Color.white)
                    
                }
                .onTapGesture {
                    viewModel.setPopUpState(state: true)
                    viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id)
                }
                .padding(.leading, -8)
                .padding(.trailing, 5)
                
            } else {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: 30)
                        
                        Capsule()
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                            .padding(.vertical, 9.0)
                        
                        
                            .frame(width: 30)
                    }
                    
                    TextHelvetica(content: "", size: 13)
                        .foregroundColor(Color.white)
                    
                }
                .onTapGesture {
                    
                    viewModel.setPopUpState(state: true)
                    viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id)
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

                
                Image("checkMark")
                    .resizable()
                    .padding(9.0)
                    .opacity(rowObject.setCompleted ? 100.0: 0.0)
                    .aspectRatio(40/37, contentMode: .fit)
                
                ZStack{
                    
                    Rectangle().foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.01))
                    
                    
                }
                .onTapGesture {
                    viewModel.toggleCompletedSet(ExersiseModuleID: moduleID, RowID: rowObject.id)
                    HapticManager.instance.impact(style: .heavy)
                    
                }
                .frame(width: 40, height: 40)
            }


            
            
        }
    }
}




