import SwiftUI

struct WeeklyScheduleView: View {
    @ObservedObject var schedule: HomePageViewModel
    @ObservedObject var viewModel: WorkoutLogViewModel
    @Binding var isNavigationBarHidden: Bool
    
  
    var isForAddingWorkout = false

    var body: some View {
        GeometryReader { proxy in
            
            let topEdge = proxy.safeAreaInsets.top
          
            MainWokroutView(schedule: schedule, viewModel: viewModel, isNavigationBarHidden: $isNavigationBarHidden, topEdge: topEdge, isForAddingWorkout: isForAddingWorkout)
                

                .navigationBarTitle(" ")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}



// Workout View
struct WorkoutView: View {
    @Binding var workout: ScheduleWorkout
    var HasBeenDone: Bool
    @Binding var showingScheduleView: Bool
    @Binding var currentWorkout: ScheduleWorkout
    var workouts: [ScheduleWorkout]
    var index: Int
    var day: Date
    @Binding var selectedWorkoutID: Int?
    @Binding var selectedDay: Date?
    @Binding var selectedRecurringID: Int?
    @ObservedObject var schedule: HomePageViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                TextHelvetica(content: workout.name, size: 15)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
            
                Button {
                    withAnimation(.spring()) {
                        showingScheduleView.toggle()
                    }
                    currentWorkout = workout
                    HapticManager.instance.impact(style: .rigid)
                    
                    if let recurringID = workouts[index].recurringID {
                        selectedWorkoutID = workouts[index].id
                        selectedRecurringID = recurringID
                        selectedDay = day
                        
                        
                    } else {
                        selectedDay = day
                        selectedWorkoutID = workouts[index].id
                     
//
                           
                    }
                         
              
                    
                } label: {
                    HStack(spacing: 4) {
                        Circle()
                        Circle()
                        Circle()
                        
                    }
                    .scaleEffect(0.76)
                    .foregroundColor(Color("BorderGray"))
                    .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)
                   
                }
                    

              
            }.padding(.all, 10)
           
                .frame(height: getScreenBounds().height * 0.05)
                .background(Color("MainGray"))
       
            
            
            Divider()
                                
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))
            
           
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.000)
                let exerciseNames = workout.exercises.map { $0.exersiseName }.joined(separator: ", ")
                
                TextHelvetica(content: exerciseNames.isEmpty ? "Empty Workout" : exerciseNames, size: 12)
                    .foregroundColor(Color("GrayFontOne"))
                    .multilineTextAlignment(.leading)
              
                Spacer()
                
                
            }
       
            .padding(.horizontal, 10)
            
            Spacer()
            
     

        }
        .frame(width: getScreenBounds().width * 0.443, height: getScreenBounds().height * 0.15)
        .background(Color("DBblack")) // Use a different color when `HasBeenDone` is true
        .cornerRadius(10)
        .overlay(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                
                RoundedRectangle(cornerRadius: 10)
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.black)
                    .opacity(HasBeenDone ? 0.4 : 0)
            })
            
        .padding(.vertical)
        .padding(.horizontal, 2)
      

    }
    
    private func deleteExercise(at offsets: IndexSet) {
        workout.exercises.remove(atOffsets: offsets)
    }
}

struct MainWokroutView: View {
    @ObservedObject var schedule: HomePageViewModel
    @ObservedObject var viewModel: WorkoutLogViewModel
    @Binding var isNavigationBarHidden: Bool
//    @Binding var selectedDestination: AnyView

    var topEdge: CGFloat
    var isForAddingWorkout = false
    let maxHeight = UIScreen.main.bounds.height / 4.5
    @Environment(\.presentationMode) var presentationMode
    @State var offset: CGFloat = 0
        
    @State private var showingAddWorkout = false
    @State private var showDeleteAlert = false
    @State private var selectedWorkoutID: Int?
    @State private var selectedRecurringID: Int?
    @State private var selectedDay: Date?
    @State private var currentWeek: String = ""
    
    @State private var showingScheduleView: Bool = false
    
    @State private var selectedWorkout: ScheduleWorkout = ScheduleWorkout(id: 10201, name: "Asd", exercises: [], time: Date(), HasBeenDone: false)
    
    

    private var weeksWithWorkouts: Set<Int> {
        var weeksWithWorkouts = Set<Int>()
        
        for (weekIndex, week) in weeks.enumerated() {
            for day in week {
                if let workouts = schedule.getWorkouts(for: day), !workouts.isEmpty {
                    weeksWithWorkouts.insert(weekIndex)
                    break
                }
            }
        }
        
        return weeksWithWorkouts
    }

    let weeks: [[Date]]

    init(schedule: HomePageViewModel, viewModel: WorkoutLogViewModel, isNavigationBarHidden: Binding<Bool>, topEdge: CGFloat, isForAddingWorkout: Bool) {
        self.schedule = schedule
        self.viewModel = viewModel
        self._isNavigationBarHidden = isNavigationBarHidden
        self.topEdge = topEdge
        self.isForAddingWorkout = isForAddingWorkout
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        self.weeks = (0..<4).map { weekOffset in
            (0..<7).compactMap { dayOffset in
                calendar.date(byAdding: .day, value: dayOffset + weekOffset * 7, to: startOfWeek)
            }
        }
        
  
    }

    func workoutsSection(for day: Date) -> some View {
        Section(header: Text(" ")) {
            if var workouts = schedule.getWorkouts(for: day) { // Change this line
                
                ForEach(workouts.indices, id: \.self) { index in
                    HStack {
                        
 
                        WorkoutView(workout: Binding<ScheduleWorkout>(get: {
                            workouts[index]
                        }, set: { newValue in
                            workouts[index] = newValue
                        }), HasBeenDone: workouts[index].HasBeenDone, showingScheduleView: $showingScheduleView, currentWorkout: $selectedWorkout, workouts: workouts, index: index, day: day, selectedWorkoutID: $selectedWorkoutID, selectedDay: $selectedDay, selectedRecurringID: $selectedRecurringID, schedule: schedule)
                    
                        Spacer()
                        
                            
                        
       
                                
                              
                           
                    }
                    .padding(.horizontal, 10)
                }
            } else {
                TextHelvetica(content: "No Workouts", size: 18)
                    .foregroundColor(Color("GrayFontOne"))
              
            }
        }
    }
    
    private func isCurrentDay(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day)
    }

    func deleteWorkoutAlert() -> Alert {
      

        if let recurringID = selectedRecurringID {
            return Alert(
                title: Text("Delete Workout"),
                message: Text("Do you want to delete all recurring instances of this workout or just this one? (deleting just one will not affect remiders for other repeating workouts"),
                primaryButton: .destructive(Text("All")) {
                    if let workoutID = selectedWorkoutID {
                        print(workoutID)
                        schedule.removeRecurringWorkouts(workoutID: workoutID, recurringID: recurringID)
                    }
                },
                secondaryButton: .default(Text("Just this one")) {
                    print(recurringID)
                    if let workoutID = selectedWorkoutID, let day = selectedDay {
                        schedule.removeWorkout(from: day, workoutID: workoutID)
                        
                    }
                }
            )
        } else {
            return Alert(
                title: Text("Delete Workout"),
                message: Text("Do you want to delete this workout?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let workoutID = selectedWorkoutID, let day = selectedDay {
                        schedule.removeWorkout(from: day, workoutID: workoutID)
                        cancelNotificationForRemidner(id: workoutID)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d"
        return formatter
    }()

    func isCurrentWeek(_ week: [Date]) -> Bool {
        let currentWeekStartDate = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return week.first == currentWeekStartDate
    }
    
    private func updateCurrentWeek() {
        let currentWeekIndex = Int((offset + maxHeight) / CGFloat(weeks.count))
        if currentWeekIndex >= 0 && currentWeekIndex < weeks.count {
            let week = weeks[currentWeekIndex]
            let weekString = "Week of \(dateFormatter.string(from: week.first!))"
            if currentWeek != weekString {
                currentWeek = weekString
            }
        }
    }

    var body: some View {
        let weeksWithWorkoutsSet = weeksWithWorkouts
        ZStack {
     
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack(spacing: 15) {
                    VStack {
                        GeometryReader { proxy in
                            TopBar(topEdge: topEdge, name: "Schedule", offset: $offset, maxHeight: maxHeight)
                                .offset(y: 45)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: getHeaderHeight(), alignment: .bottom)
                                   
                                    
                                    
                                    
                            
                                    

                                
                                    .background(Color("MainGray").opacity(topBarTitleOpacity()), in: CustomCorner(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius()))
                                .shadow(color: Color.black.opacity(topBarTitleOpacity() * 0.7), radius: 10, x: 0, y: 0)
                            
                        }
                        .frame(height: maxHeight)
                        .offset(y: -offset)
                        .zIndex(1)
                    }
                   
        
                  




                


                        
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(weeks.indices.filter { weeksWithWorkoutsSet.contains($0) || isCurrentWeek(weeks[$0]) }, id: \.self) { weekIndex in
                                let week = weeks[weekIndex]
                                
                                if weeksWithWorkoutsSet.contains(weekIndex) || isCurrentWeek(week) {
                                    ZStack {
                                       
                                        HStack {
                                            Text("Week of \(dateFormatter.string(from: week.first!))")
                                                .font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (14 * 0.0025)))
                                                .foregroundColor(Color("GrayFontOne"))
                                                .padding(.top)
                                                .padding(.horizontal)
                                                .padding(.bottom, 5)
                                            Spacer()
                                        }
                                        .background(Rectangle().frame(width: getScreenBounds().width).scaleEffect(1.2).foregroundColor(Color("MainGray")))
                                      
                                    }
                                   
                                        
                                      
                                   
                                  
                                }
                                
                                ForEach(week, id: \.self) { day in
                                    VStack(alignment: .leading, spacing: 5) {
                                        VStack(alignment: .leading, spacing: 5) {
                                            TextHelvetica(content: dateFormatter.string(from: day), size: 18)
                                                .font(.headline)
                                                .foregroundColor(isCurrentDay(day) ? Color("LinkBlue"): Color("WhiteFontOne"))
                                                .padding(.horizontal, 10)
                                            if let workouts = schedule.getWorkouts(for: day), !workouts.isEmpty {
                                                workoutsSection(for: day)
                                            } else if isCurrentWeek(week) {
                                                TextHelvetica(content: "No Workouts", size: 18)
                                                    .foregroundColor(Color("GrayFontOne"))
                                                    .padding(.horizontal, 10)
                                            }
                                        }
                                        .padding(.vertical)
                                       
                                        
                                
                                        Divider()
                                     
                                            .frame(width: getScreenBounds().width , alignment: .trailing)
                                      
                                     
                                          
                                   
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                        .padding(.horizontal)
                        .background(Color("DBblack").edgesIgnoringSafeArea(.all))
                        .navigationTitle("Workout Schedule")
                        .padding(.bottom, 200)
                        .zIndex(0)
                   
              

                    
                    
                }
                
                .modifier(OffsetModifier(modifierID: "SScroll", offset: $offset))
                
             
            }
            .background(Color("MainGray"))
            .coordinateSpace(name: "SScroll")
                
                
                
        

            .alert(isPresented: $showDeleteAlert, content: deleteWorkoutAlert)
      
            VStack {
                HStack() {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        HapticManager.instance.impact(style: .rigid)
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.body.bold())
                                .foregroundColor(Color("LinkBlue"))
                            TextHelvetica(content: "back", size: 17)
                                .foregroundColor(Color("LinkBlue"))
                            Spacer()
                        }
                        .frame(width: 80)
                    }

                    Spacer() // This spacer will push the text and buttons apart

                    TextHelvetica(content: "Schedule", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                        .bold()
                        .opacity(topBarTitleOpacity())
                        .offset(x: getScreenBounds().width * -0.010)
                    Spacer() // This spacer will push the text and buttons apart

                    Button {
                        withAnimation(.spring()) {
                            showingAddWorkout.toggle()
                        }
                        HapticManager.instance.impact(style: .rigid)
                        
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "plus")
                                .font(.body.bold())
                                .imageScale(.large)
                                .foregroundColor(Color("LinkBlue"))
             
                        }
                       
                        
                        .frame(width: 80)
                    }
                }
            
                .frame(height: 60)
                .padding(.top, topEdge)
                .padding(.bottom, 20)
                .padding(.horizontal)
                .background(Color("MainGray").shadow(color: Color.black.opacity(topBarTitleOpacity() * 0.1), radius: 10, x: 0, y: 0))
                
                Spacer()
            }
     
           
           
      
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .edgesIgnoringSafeArea(.all)
                    .opacity(showingAddWorkout ? 1 : 0)

                AddWorkoutView( schedule: schedule, viewModel: viewModel, isNavigationBarHidden: $isNavigationBarHidden, showingAddWorkout: $showingAddWorkout)
                    .position(x: getScreenBounds().width/2, y: showingAddWorkout ? getScreenBounds().height * 0.5 : getScreenBounds().height * 1.5)
                
                let offset = schedule.ongoingWorkout ? 0 : 0.12
                
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(.black)
                    .opacity(showingScheduleView ? 0.4 : 0)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showingScheduleView = false
                           
                            
                            
                        }
                    }
                scheduleMenu(viewModel: schedule, showingScheduleView: $showingScheduleView, showingAlert: $showDeleteAlert, currentWorkout: $selectedWorkout, isNavigationBarHidden: $isNavigationBarHidden)
                    .shadow(radius: 10)

                    .position(x: getScreenBounds().width/2, y: showingScheduleView ? getScreenBounds().height * (0.49 + offset) : getScreenBounds().height * 1.5)

            }

            
        }
        .onAppear {
            if self.isForAddingWorkout {
                print("did the deed")
                showingAddWorkout = true
            }
        }
        
 
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        
        return topHeight > (80 + topEdge) ? topHeight : (80 + topEdge)
    }
    
    func getCornerRadius() -> CGFloat {
        let progess = -offset / (maxHeight - (80 + topEdge))
        let value = 1 - progess
        let radius = value * 25
        
        return offset < 5 ? radius : 25
    }
    
    func topBarTitleOpacity() -> CGFloat {
        
        let progress = -(offset + 60) / (maxHeight - (80 + topEdge))
        

        
        return progress
    }
    
    func topBarTitleOpacityForBorder() -> CGFloat {
        
        let progress = -(offset + 150) / (maxHeight - (80 + topEdge))
        

        
        return progress
    }



    
    func hasWorkouts(in week: [Date]) -> Bool {
        let isCurrentWeek = Calendar.current.isDate(week.first!, equalTo: Date(), toGranularity: .weekOfYear)
        return isCurrentWeek || week.contains { date in schedule.getWorkouts(for: date) != nil }
    }
}


struct AddWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var schedule: HomePageViewModel
    @ObservedObject var viewModel: WorkoutLogViewModel
    @Binding var isNavigationBarHidden: Bool
    
    
    @State private var workoutName: String = ""
    @State private var exerciseString: String = ""
    @State private var duration: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date()
    @State private var recurringOption: Schedule.RecurringOption = .none
    @State private var reminderOption: Schedule.ReminderOption = .none
    @Binding var showingAddWorkout: Bool

    var body: some View {
        VStack {
            
            HStack {
                Button {
                    withAnimation(.spring()) {
                        showingAddWorkout.toggle()
                    }
                    HapticManager.instance.impact(style: .rigid)
                    
                    
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
                
                
                Spacer()
                TextHelvetica(content: "Add Workout", size: 20)
                    .foregroundColor(Color("WhiteFontOne"))
                
                
                Spacer()
                Button {
                    if let workout = schedule.schedule.workoutQueue {
                        saveWorkout(exercises: workout.exercises , workoutName: workout.WorkoutName)
                    }
                   
                    withAnimation(.spring()) {
                        showingAddWorkout.toggle()
                    }
                    schedule.clearWorkoutQueue()
                    HapticManager.instance.impact(style: .rigid)
                }
                label: {
                    TextHelvetica(content: "Save", size: 18)
                        .foregroundColor(Color("LinkBlue"))
                }
               
                
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            Form {
                

                Section(header: TextHelvetica(content: "Select Workout", size: 14)
                    .foregroundColor(Color("WhiteFontOne"))) {
                        if let workout = schedule.schedule.workoutQueue {
                            WorkoutModule(title: workout.WorkoutName , description: "asd")
                            
                        } else {
                            HStack {
//                                Button {
//
//                                } label: {
//                                    ZStack{
//
//                                        RoundedRectangle(cornerRadius: 5)
//                                            .foregroundColor(Color("BlueOverlay"))
//
//
//
//                                        RoundedRectangle(cornerRadius: 5)
//                                            .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)
//
//
//
//
//
//
//                                        TextHelvetica(content: "Generate Workout", size: 17)
//                                            .foregroundColor(Color("WhiteFontOne"))
//                                            .multilineTextAlignment(.center)
//                                            .bold()
//                                            .padding()
//                                    }
//                                }
                                
                                
                      
                                Button {
                                    schedule.showingExercises = true
                                    HapticManager.instance.impact(style: .rigid)
                                } label: {
                                 
                                    ZStack{
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(Color("BlueOverlay"))
                                        
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        TextHelvetica(content: "Add Workout", size: 17)
                                            .bold()
                                            .foregroundColor(Color("WhiteFontOne"))
                                    }
                                    .background(NavigationLink(destination: MyWorkoutsPage(viewModel: schedule, workoutLogViewModel: viewModel, isNavigationBarHidden: $isNavigationBarHidden, isForAddingToSchedule: false)) {
                                        EmptyView()
                                })
                                    
                                    
                                }
                               
                         
                            }
                            .frame(height: getScreenBounds().height * 0.12)
                       
                          
                        }
                    
                   
                }
                    
                
                Section(header: TextHelvetica(content: "Date & Time", size: 14)
                    .foregroundColor(Color("WhiteFontOne"))) {
                    HStack {
                        DatePicker("          ", selection: $selectedDate, displayedComponents: [.date])
                            .labelsHidden()
                        DatePicker("Time", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                            .labelsHidden()
                    }
                    .font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (15 * 0.0025)))
                   
                }
                
                Section(header: TextHelvetica(content: "Reminder", size: 14)
                            .foregroundColor(Color("WhiteFontOne"))) {
                    Picker("Reminder", selection: $reminderOption) {
                        ForEach(Schedule.ReminderOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
       // disable the Picker when recurringOption is default
                }
              
                Section(header: TextHelvetica(content: "Recurring", size: 14)
                            .foregroundColor(Color("WhiteFontOne"))) {
                    Picker("Recurring", selection: $recurringOption) {
                        ForEach(Schedule.RecurringOption.allCases) { option in
                            Text(option.rawValue.capitalized).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
//                    .disabled(reminderOption != .none)
                }
                
                
            }.scrollContentBackground(.hidden)
           



        }
        .sheet(isPresented: $schedule.showingExercises) {
            MyWorkoutsPage(viewModel: schedule, workoutLogViewModel: viewModel, isNavigationBarHidden: $isNavigationBarHidden, isForAddingToSchedule: true)
        }
        .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.67)
       
        .background(Color("DBblack")) // Add this line to set the background color to red
            .edgesIgnoringSafeArea(.bottom)
        .cornerRadius(7)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
    }
    
    //            .toolbar {
    //                ToolbarItem(placement: .navigationBarLeading) {
    //                    Button("Cancel") {
    //                        presentationMode.wrappedValue.dismiss()
    //                    }
    //                }
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    Button("Save") {
    //                        saveWorkout()
    //                    }
    //                    .disabled(workoutName.isEmpty || exerciseString.isEmpty || duration.isEmpty)
    //                }
    //            }

    private func saveWorkout(exercises: [WorkoutLogModel.ExersiseLogModule], workoutName: String) {
        

        let recurringID = (recurringOption == .none) ? nil : Int.random(in: 1..<Int.max)

        // Combine the selected date and time
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)

        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute

        let dateTime = calendar.date(from: combinedComponents) ?? Date()
        let id = Int.random(in: 1..<Int.max)
        let workout = ScheduleWorkout(id: id , name: workoutName, exercises: exercises, recurringID: recurringID, time: dateTime, HasBeenDone: false)
        schedule.addWorkout(to: dateTime, workout: workout, recurringOption: recurringOption)

        switch reminderOption {
        case .none:
            print("Nothing to schedule")

        case .fiveMinutes:
            switch recurringOption {
            case .none:
                scheduleNotificationForReminder(id: id, title: "5 Minute Warning", body: "This is your 5 minute warning!", date: dateTime, offset: 5, recurringOption: .none)
            case .daily:
                scheduleNotificationForReminder(id: id, title: "5 Minute Warning", body: "This is your 5 minute warning!", date: dateTime, offset: 5, recurringOption: .daily)
            case .weekly:
                scheduleNotificationForReminder(id: id, title: "5 Minute Warning", body: "This is your 5 minute warning!", date: dateTime, offset: 5, recurringOption: .weekly)
            }
                
        case .fifteenMinutes:
            switch recurringOption {
            case .none:
                scheduleNotificationForReminder(id: id, title: "15 Minute Warning", body: "This is your 15 minute warning!", date: dateTime, offset: 15, recurringOption: .none)
            case .daily:
                scheduleNotificationForReminder(id: id, title: "15 Minute Warning", body: "This is your 15 minute warning!", date: dateTime, offset: 15, recurringOption: .daily)
            case .weekly:
                scheduleNotificationForReminder(id: id, title: "15 Minute Warning", body: "This is your 15 minute warning!", date: dateTime, offset: 15, recurringOption: .weekly)
            }
                
        case .thirtyMinutes:
            switch recurringOption {
            case .none:
                scheduleNotificationForReminder(id: id, title: "30 Minute Warning", body: "This is your 30 minute warning!", date: dateTime, offset: 30, recurringOption: .none)
            case .daily:
                scheduleNotificationForReminder(id: id, title: "30 Minute Warning", body: "This is your 30 minute warning!", date: dateTime, offset: 30, recurringOption: .daily)
            case .weekly:
                scheduleNotificationForReminder(id: id, title: "30 Minute Warning", body: "This is your 30 minute warning!", date: dateTime, offset: 30, recurringOption: .weekly)
            }
        }
   


    }

}
struct scheduleMenu: View {
    @ObservedObject var viewModel: HomePageViewModel
    @Binding var showingScheduleView: Bool
    @Binding var showingAlert: Bool
    @Binding var currentWorkout: ScheduleWorkout
    @Binding var isNavigationBarHidden : Bool
    @State private var isLinkActive = false
    var body: some View {
        // Add a blur effect to the background
        VStack{


            Spacer()
            VStack {
                

                HStack {

                    
                    
                    TextHelvetica(content: "Workout Options", size: 27)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    Button {
                        HapticManager.instance.impact(style: .rigid)
                        
                        withAnimation(.spring()) {
                            showingScheduleView.toggle()
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
                .padding(.vertical, 10)
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                VStack {
                   

                        
                  

                                        
  
                  
                    
//                    Button {
//                        withAnimation(.spring()) {
//                            viewModel.setPopUpState(state: true, popUpId: "SetUnitSubMenu")
//                        }
//
//                        withAnimation(.linear(duration: 0.9)){
//
//                            viewModel.setPopUpState(state: false, popUpId: "popUpDotsMenu")
//                        }
//
//                    }
//                    label: {
//                        HStack{
//
//                            Image(systemName: "scalemass")
//                                .foregroundColor(Color("LinkBlue"))
//                                .imageScale(.large)
//                                .bold()
//                                .multilineTextAlignment(.leading)
//
//                            TextHelvetica(content: "Add Warm Up Sets", size: 18)
//                                .foregroundColor(Color("WhiteFontOne"))
//
//                            Spacer()
//                            TextHelvetica(content: "", size: 17)
//                                .foregroundColor(Color("GrayFontOne"))
//                            Image("sidwaysArrow")
//                                .resizable()
//
//                                .aspectRatio(24/48, contentMode: .fit)
//                                .frame(maxHeight: 22)
//                        }
//                        .padding(.horizontal)
//                        .frame(maxHeight: 22)
//                    }
                    
                    
                    
                    HStack{
                            Image(systemName: "pencil")
                                .foregroundColor(Color("LinkBlue"))
                                .imageScale(.large)
                                .bold()
                                .multilineTextAlignment(.leading)

                            TextHelvetica(content: "Edit workout", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                          
                            Spacer()
                        
                            TextHelvetica(content: "", size: 18)
                                .foregroundColor(Color("LinkBlue"))
                        }
                    .background(.red.opacity(0.0001))
                        .padding(.horizontal)
                        .frame(maxHeight: 22)
                    
                        .background(
                            NavigationLink(destination: createWorkout(homePageVeiwModel: viewModel, workoutLogViewModel: viewModel.newViewModel, isNavigationBarHidden: $isNavigationBarHidden, currentWorkout: currentWorkout), isActive: $isLinkActive) {
                                EmptyView()
                            }
                        )
                        .onTapGesture {
                            showingScheduleView.toggle()
                            print(currentWorkout)
                            viewModel.newViewModel.setExerciseModules(exericiesModules: currentWorkout.exercises, name: currentWorkout.name)
                            isLinkActive = true
                            HapticManager.instance.impact(style: .rigid)
                        }
                
                    

                    
                    
                    
                    
                    
                    Divider()
                    
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
                    


                }
                Button {
  
                    showingScheduleView = false
                    HapticManager.instance.impact(style: .rigid)
                    showingAlert.toggle()
                  
              
                }
                label: {
                    HStack{
                        
                        Image(systemName: "xmark")
                            .foregroundColor(Color("MainRed"))
                            .imageScale(.large)
                            .bold()
                        
                    
                        TextHelvetica(content: "Remove workout ", size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        Spacer()

                        
                    }
                    .offset(y: -5)
                    .padding(.horizontal)
                    .frame(maxHeight: 30)
                    
                }
             
               
                
            }
            .frame(width: getScreenBounds().width * 0.95)
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
            .padding()

            
        }
     

        .frame(height: getScreenBounds().height * 0.7)
        


            
    }
}
