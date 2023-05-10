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

                .navigationBarTitle("back")
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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                TextHelvetica(content: workout.name, size: 17)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                ZStack{
                    
                    Image("meatBalls")
                        .resizable()
                        .frame(width: getScreenBounds().width * 0.09, height: getScreenBounds().height * 0.03)

                }
            }.padding(.all, 10)
                
                .background(Color("MainGray"))
       
            
            
            Divider()
                                
            .frame(height: borderWeight)
            .overlay(Color("BorderGray"))
            VStack(alignment: .leading) {
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.000)
                TextHelvetica(content: "back squat(barbell), bench press(barbell), etc.", size: 12)
                    .foregroundColor(Color("GrayFontOne"))
                    .multilineTextAlignment(.leading)
              
                Spacer()
                
                HStack{
                    TextHelvetica(content: "12 sets", size: 15)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                    Image(systemName: "clock")
                        .foregroundColor(Color("LinkBlue"))
                        .imageScale(.medium)
                        .bold()
                    TextHelvetica(content: "1:30", size: 15)
                        .foregroundColor(Color("GrayFontOne"))
                     
                }
            }.padding(.horizontal, 10)
               
            
            Spacer()

        }
        .frame(width: getScreenBounds().width * 0.443, height: getScreenBounds().height * 0.15)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
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
                        }))
                        Spacer()
                        
                            
                       
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .frame(width: 50)
                            .onTapGesture {
                                print("Asd")
                                if let recurringID = workouts[index].recurringID {
                                    selectedWorkoutID = workouts[index].id
                                    selectedRecurringID = recurringID
                                    selectedDay = day
                                    showDeleteAlert = true
                                } else {
                                    schedule.removeWorkout(from: day, workoutID: workouts[index].id)
                                }
                            }
                                
                              
                           
                    }
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
        Alert(title: Text("Delete Workout"),
              message: Text("Do you want to delete all recurring instances of this workout or just this one?"),
              primaryButton: .destructive(Text("All")) {
                if let workoutID = selectedWorkoutID, let recurringID = selectedRecurringID {
                    schedule.removeRecurringWorkouts(workoutID: workoutID, recurringID: recurringID)
                }
              },
              secondaryButton: .default(Text("Just this one")) {
                if let workoutID = selectedWorkoutID, let day = selectedDay {
                    schedule.removeWorkout(from: day, workoutID: workoutID)
                }
              })
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
            GeometryReader { g in
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 15) {
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
            
                      




                    


                        List {
                            ForEach(weeks.indices.filter { weeksWithWorkoutsSet.contains($0) || isCurrentWeek(weeks[$0]) }, id: \.self) { weekIndex in
                                let week = weeks[weekIndex]
                         
                                Section(header: (weeksWithWorkoutsSet.contains(weekIndex) || isCurrentWeek(week)) ? Text("Week of \(dateFormatter.string(from: week.first!))").font(.custom("SpaceGrotesk-Medium", size: getScreenBounds().width * (14 * 0.0025))).foregroundColor(Color("GrayFontOne")) : nil) {
                                    
                                    ForEach(week, id: \.self) { day in
                                        VStack(alignment: .leading) {
                                            TextHelvetica(content: dateFormatter.string(from: day), size: 18)
                                  
                                                .font(.headline)
                                                .padding(.top)
                                                .foregroundColor(isCurrentDay(day) ? Color("LinkBlue"): Color("WhiteFontOne"))
                                            if let workouts = schedule.getWorkouts(for: day), !workouts.isEmpty {
                                                workoutsSection(for: day)
                                            } else if isCurrentWeek(week) {
                                                TextHelvetica(content: "No Workouts", size: 18)
                                                    .foregroundColor(Color("GrayFontOne"))
                                            }
                                        }
                                        .listRowBackground(Color("DBblack"))
                                        .listStyle(GroupedListStyle())
                                      
                                    }
                                }
                              
                            }
                        }
                        .frame(width: g.size.width - 1, height: g.size.height - 50, alignment: .center)
                        .scrollContentBackground(.hidden)
                        .background(Color("MainGray").edgesIgnoringSafeArea(.all))
                        .listStyle(GroupedListStyle())
                        .navigationTitle("Workout Schedule")
                        .zIndex(0)
                        
                        
                    }
                    
                    .modifier(OffsetModifier(modifierID: "SScroll", offset: $offset))
                    
                 
                }
                .background(Color("MainGray"))
                .coordinateSpace(name: "SScroll")
                
                
                
            }

            .alert(isPresented: $showDeleteAlert, content: deleteWorkoutAlert)
      
            VStack {
                HStack() {
                    Button {
                        
                      
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

                    Spacer() // This spacer will push the text and buttons apart

                    Button {
                        withAnimation(.spring()) {
                            showingAddWorkout.toggle()
                        }
                        
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
                .padding(.horizontal)
                Spacer()
            }
           
           
      
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .edgesIgnoringSafeArea(.all)
                    .opacity(showingAddWorkout ? 1 : 0)

                AddWorkoutView( schedule: schedule, viewModel: viewModel, isNavigationBarHidden: $isNavigationBarHidden, showingAddWorkout: $showingAddWorkout)
                    .position(x: getScreenBounds().width/2, y: showingAddWorkout ? getScreenBounds().height * 0.5 : getScreenBounds().height * 1.3)

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
                            WorkoutModule(title: workout.WorkoutName , description: "cum")
                            
                        } else {
                            HStack {
                                NavigationLink(destination: MyWorkoutsPage(viewModel: schedule, workoutLogViewModel: viewModel, isNavigationBarHidden: $isNavigationBarHidden, isForAddingToSchedule: true)) {
                                    ZStack{
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(Color("BlueOverlay"))
                                        
                                        
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)
                                        
                                        
                                        
                                        
                                        
                                        
                                        TextHelvetica(content: "Generate Workout", size: 17)
                                            .foregroundColor(Color("WhiteFontOne"))
                                            .multilineTextAlignment(.center)
                                            .bold()
                                            .padding()
                                    }
                                }
                                
                      
                                Button {
                                    
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
              
                Section(header: TextHelvetica(content: "Recurring", size: 14)
                    .foregroundColor(Color("WhiteFontOne"))) {
                    Picker("Recurring", selection: $recurringOption) {
                        ForEach(Schedule.RecurringOption.allCases) { option in
                            Text(option.rawValue.capitalized).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: TextHelvetica(content: "Reminder", size: 14)
                    .foregroundColor(Color("WhiteFontOne"))) {
                    Picker("Reminder", selection: $reminderOption) {
                        ForEach(Schedule.ReminderOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }.scrollContentBackground(.hidden)
           



        }
        .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.67)
        .background(Color("DBblack")) // Add this line to set the background color to red
            .edgesIgnoringSafeArea(.bottom)
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
        let workout = ScheduleWorkout(id: Int.random(in: 1..<Int.max), name: workoutName, exercises: exercises, recurringID: recurringID)
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

        schedule.addWorkout(to: dateTime, workout: workout, recurringOption: recurringOption)


    }

}
