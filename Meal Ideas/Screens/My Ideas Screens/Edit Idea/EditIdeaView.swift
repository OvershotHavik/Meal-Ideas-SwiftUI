//
//  EditIdeaView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

enum FormTextField{ // will need changed to match this form
    case mealName
}


struct EditIdeaView: View {
    @StateObject var vm: EditIdeaVM
    
    @Environment(\.dismiss) var dismiss
    @StateObject var mealPhotoLoader = ImageLoaderFromData()
    @StateObject var mealInstructionsLoader = ImageLoaderFromData()
    
    @FocusState private var focusedTextField: FormTextField?
    
    var body: some View {
        ZStack {
            Form{
                Section(header: Text(SectionHeaders.mealInfo.rawValue)) {
                    MealNameTextField(vm: vm)
                    
                    MealPhotoButtonView(vm: vm)
                        .foregroundColor(.blue)
                        .modifier(MealPhotoActionSheet(vm: vm))
                    if mealPhotoLoader.isLoading{
                        loadingView()
                            .frame(width: 100)
                    }
                    if vm.mealPhoto != UIImage(){
                        MealPhotoView(vm: vm)
                    }
                }
                
                Section(header: Text(SectionHeaders.category.rawValue)){
                    CategorySelectView(vm: vm)
                        .foregroundColor(.blue)
                    if !vm.categories.isEmpty{
                        BadgesHStack(title: "Categories",
                                     items: vm.categories,
                                     topColor: .blue,
                                     bottomColor: .blue)
                    }
                }
                
                
                
                Section(header: Text(SectionHeaders.ingredients.rawValue)){
                    IngredientSelectView(vm: vm)
                        .foregroundColor(.blue)
                    IngredientHStack(vm: vm)
                }
                
                Section(header: Text(SectionHeaders.sides.rawValue)){
                    SidesButtonView(vm: vm)
                        .foregroundColor(.blue)
                    if !vm.sides.isEmpty{
                        BadgesHStack(title: "Possible Sides",
                                     items: vm.sides,
                                     topColor: .green,
                                     bottomColor: .green)
                    }
                }
                
                
                Section(header: Text(SectionHeaders.prep.rawValue)){
                    PrepTimePickerView(vm: vm)
                }
                
                
                Section(header: Text(SectionHeaders.instructions.rawValue)){
                    MealInstructionsButtonView(vm: vm)
                        .foregroundColor(.blue)
                        .modifier(MealInstructionsActionSheet(vm: vm))
                    if mealInstructionsLoader.isLoading{
                        loadingView()
                            .frame(width: 100)
                    }
                    if vm.instructionsPhoto != UIImage(){
                        InstructionPhotoView(vm: vm)
                    }
                    Text("And/Or type in below:")
                    TextEditor(text: $vm.recipe)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray3)))
                        .frame(height: 150)
                }
                Section(header: Text(SectionHeaders.source.rawValue)){
                    TextField("Website", text: $vm.source)
                        .textFieldStyle(CustomRoundedCornerTextField())
                }
                
                
                // MARK: - Save Button
                SaveButtonView(vm: vm)
//                    .listRowBackground(Color.green)
                
                if vm.meal != nil{
                    //Only show and add space if the meal was passed in
//                    Spacer(minLength: 5)
                    DeleteButtonView(vm: vm, showingDeleteAlert: $vm.showingDeleteAlert)
//                        .listRowBackground(Color.red)
                }
                if vm.meal != nil{
                    Section(header: Text(SectionHeaders.modified.rawValue)){
                        if let safeModified = vm.meal?.modified{
                            Text("Last Modified on: \(vm.convertDate(date:safeModified))")
                        }
                        if let safeCreated = vm.meal?.created{
                            Text("Created on: \(vm.convertDate(date: safeCreated))")
                        }
                    }
                }
                
            }
            
            if vm.isLoading{
                loadingView()
            }
        }

        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button {
            vm.showingBackAlert = true
        } label: {
            HStack{
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .font(.body)
        }
        )
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                Text(vm.meal?.mealName ?? "Create a Meal")
            })
            ToolbarItemGroup(placement: .keyboard) {
                HStack{
                    Spacer()
                    Button("Done"){hideKeyboard()}
                    .foregroundColor(.primary)
                }
            }
        }
        .task{
            if vm.mealName.isEmpty{
                focusedTextField = .mealName
            }
            // TODO:  Change the background to the background gradient?
            //            UITableView.appearance().backgroundColor = .clear
            if let safeData = vm.meal?.mealPhoto{
                mealPhotoLoader.loadFromData(mealPhotoData: safeData)
            }else {
                mealPhotoLoader.isLoading = false
            }
            
            if let safeData = vm.meal?.instructionsPhoto{
                mealInstructionsLoader.loadFromData(mealPhotoData: safeData)
            } else {
                mealInstructionsLoader.isLoading = false
            }
            
            
        }
        .onChange(of: mealPhotoLoader.image, perform: { NewItem in
            vm.mealPhoto = mealPhotoLoader.image
        })
        .onChange(of: mealInstructionsLoader.image, perform: { NewItem in
            vm.instructionsPhoto = mealInstructionsLoader.image
        })
        
        // MARK: - Save alert
        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(Text("OK"), action: {
                if alertItem.title == AlertContext.nameInUse.title ||
                    alertItem.title == AlertContext.blankMealName.title ||
                    alertItem.title == AlertContext.invalidSourceURL.title{
                    //do nothing since user needs to change the meal name to save
                } else {
                    //if all is good then pop view back to the list
                    popView()
                }
            }))
        }
        // MARK: - Alert when back is pressed
        .alert("Any unsaved information will be lost", isPresented: $vm.showingBackAlert){
            Button("Save Changes", action: vm.saveMeal)
            Button("Discard changes and go back", role: .destructive, action: popView)
            //cancel is added automatically and stops the back process
        }
        
        // MARK: - Delete Alert
        .alert("Delete Meal", isPresented: $vm.showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteMeal)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete \(vm.meal?.mealName ?? vm.mealName)?")
        }
        
        // MARK: - Image Picker sheet
        .sheet(isPresented: $vm.isShowPhotoLibrary){
            if let safeSelection = vm.imagePickerSelection{
                //These are set by the action sheet when the user taps a button to select the photo
                switch safeSelection{
                case .mealPhoto:
                    ImagePicker(selectedImage: $vm.mealPhoto,
                                isLoading: $vm.isLoading,
                                sourceType: vm.imageSource)
                case .instructions:
                    ImagePicker(selectedImage: $vm.instructionsPhoto,
                                isLoading: $vm.isLoading,
                                sourceType: vm.imageSource)
                }
            }
        }
        
    }
    // MARK: - Delete meal from VM and dismiss the view
    func deleteMeal(){
        vm.deleteMeal()
        dismiss()
    }
    // MARK: - popView to go back after saved
    func popView(){
        dismiss()
    }
}
// MARK: - Preview

struct CreateIdeaView_Previews: PreviewProvider {
    static var previews: some View {
        EditIdeaView(vm: EditIdeaVM(meal: nil))
    }
}

// MARK: - Meal Name Text FIeld
struct MealNameTextField: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        TextField(vm.meal?.mealName ?? "Meal Name*", text: $vm.mealName)
            .textFieldStyle(CustomRoundedCornerTextField())
            .overlay{
                Rectangle().frame(height: 2).padding(.top, 35)
                    .foregroundColor(vm.mealName == "" ? Color.red : Color.clear)
            }
            .font(.title)
//            .focused($focusedTextField, equals: .mealName)
            .onSubmit {
                vm.checkNameAlreadyInUse()
            }
    }
}
// MARK: - Meal Photo Button View
struct MealPhotoButtonView: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        Button {
            vm.isMPActionSheetPresented.toggle()
            print("isMPActionSheetPresented state: \(vm.isMPActionSheetPresented)")
        } label: {
            Text("Select a photo for your meal")
        }
    }
}
// MARK: - Meal Photo View
struct MealPhotoView: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        HStack{
            Image(uiImage: vm.mealPhoto)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Button {
                vm.mealPhoto = UIImage()
            } label: {
                Text("Remove Photo")
            }
            .buttonStyle(.bordered)
            .accentColor(.red)
        }
        
    }
}
// MARK: - Category Select View
struct CategorySelectView: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        NavigationLink(destination: MultiChoiceListView(vm: MultiChoiceListVM(PList: .categories,
                                                                              editIdeaVM: vm,
                                                                              listType: .category),
                                                        title: .multiCategory)) {
            Text("Select Categories")
        }
    }
}
// MARK: - Ingredient Select View
struct IngredientSelectView: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        
        NavigationLink(destination: MultiIngredientListView(vm: MultiIngredientListVM(editVM: vm,
                                                                                      listType: .ingredient))) {
            Text("Select Ingredients")
        }
    }
}
// MARK: - Ingredient HStack
struct IngredientHStack: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        ForEach($vm.userIngredients) {$ing in
            HStack{
                Text(ing.name)
                Spacer()
                TextField("Measurement", text: $ing.measurement)
                    .textFieldStyle(CustomRoundedCornerTextField())
                    .frame(width: 150)
            }
        }
        .onDelete(perform: vm.deleteIngredient)
    }
}
// MARK: - Sides Button View
struct SidesButtonView: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        NavigationLink(destination: MultiChoiceListView(vm: MultiChoiceListVM(PList: .sides,
                                                                              editIdeaVM: vm,
                                                                              listType: .side),
                                                        title: .multiSides)) {
            Text("Select Possible Sides")
        }
    }
}

// MARK: - Meal Instructions Button View
struct MealInstructionsButtonView: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        Button {
            vm.isMIActionSheetPresented.toggle()
            print("vm.isMIActionSheetPresented state: \(vm.isMIActionSheetPresented)")
        } label: {
            Text("Select a Photo")
        }
    }
}
// MARK: - Instruction Photo View
struct InstructionPhotoView: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        HStack{
            Image(uiImage: vm.instructionsPhoto)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
            Button {
                vm.instructionsPhoto = UIImage()
            } label: {
                Text("Remove Photo")
            }
            .buttonStyle(.bordered)
            .accentColor(.red)
        }
    }
}

// MARK: - Save Button
struct SaveButtonView: View{
    var vm: EditIdeaVM
    var body: some View{
        Button {
            vm.saveMeal()
        } label: {
            Text("Save Meal")
                .padding()
                .foregroundColor(.green)
        }
    }
}

// MARK: - Delete Button
struct DeleteButtonView: View{
    var vm: EditIdeaVM
    @Binding var showingDeleteAlert: Bool
    var body: some View{
        Button {
            showingDeleteAlert = true
            
        } label: {
            Text("Delete Meal")
                .padding()
                .foregroundColor(.red)
        }
    }
}
// MARK: - Meal Photo Action Sheet
struct MealPhotoActionSheet: ViewModifier{
    @StateObject var vm: EditIdeaVM
    func body(content: Content) -> some View {
        content
            .actionSheet(isPresented: $vm.isMPActionSheetPresented, content: {
                var buttons = [ActionSheet.Button]()
                let cameraRoll = ActionSheet.Button.default(Text("Camera Roll")) {
                    print("bring up camera roll")
                    vm.imagePickerSelection = .mealPhoto
                    vm.imageSource = .photoLibrary
                    vm.isShowPhotoLibrary.toggle()
                    vm.isLoading = true
                }
                buttons.append(cameraRoll)
                
                let camera = ActionSheet.Button.default(Text("Take Picture")) {
                    print("bring up camera to take photo")
                    vm.imagePickerSelection = .mealPhoto
                    vm.imageSource = .camera
                    vm.isShowPhotoLibrary.toggle()
                    vm.isLoading = true
                }
                buttons.append(camera)
                if vm.mealPhoto != UIImage(){
                    // TODO:  make sure this actually works once photo data is saved
                    let remove = ActionSheet.Button.destructive(Text("Remove Photo")){
                        //remove photo from meal
                        vm.mealPhoto = UIImage()
                    }
                    buttons.append(remove)
                }
                buttons.append(.cancel())
                return ActionSheet(title: Text("Select where you want to get the photo from"), message: nil, buttons: buttons)
            })
    }
    
}

// MARK: - Meal Instructions Action Sheet
struct MealInstructionsActionSheet: ViewModifier{
    @StateObject var vm: EditIdeaVM
    func body(content: Content) -> some View {
        content
            .actionSheet(isPresented: $vm.isMIActionSheetPresented, content: {
                var buttons = [ActionSheet.Button]()
                let cameraRoll = ActionSheet.Button.default(Text("Camera Roll")) {
                    print("bring up camera roll")
                    vm.isShowPhotoLibrary.toggle()
                    vm.imagePickerSelection = .instructions
                    vm.imageSource = .photoLibrary
                    vm.isLoading = true
                }
                buttons.append(cameraRoll)
                
                let camera = ActionSheet.Button.default(Text("Take Picture")) {
                    print("bring up camera to take photo")
                    vm.isShowPhotoLibrary.toggle()
                    vm.imageSource = .camera
                    vm.imagePickerSelection = .instructions
                    vm.isLoading = true
                }
                buttons.append(camera)
                if vm.instructionsPhoto != UIImage(){
                    // TODO:  make sure this actually works once photo data is saved
                    let remove = ActionSheet.Button.destructive(Text("Remove Photo")){
                        //remove photo from meal
                        vm.instructionsPhoto = UIImage()
                    }
                    buttons.append(remove)
                }
                buttons.append(.cancel())
                return ActionSheet(title: Text("Select where you want to get the photo from"), message: nil, buttons: buttons)
            })
    }
}
struct PrepTimePickerView: View{
    @StateObject var vm: EditIdeaVM
    var body: some View{
        HStack {
            GeometryReader { geometry in
                HStack(spacing: 0){
                    
                    // TODO:  Disable keyboard when selecting picker
                    BasePicker(selecting: $vm.hourSelection, data: vm.hours, label: "h")
                        .frame(width: geometry.size.width/3, height: geometry.size.height, alignment: .center)
                    
                    BasePicker(selecting: $vm.minuteSelection, data: vm.minutes, label: "m")
                        .frame(width: geometry.size.width/3, height: geometry.size.height, alignment: .center)
                    
                    BasePicker(selecting: $vm.secondSelection, data: vm.seconds, label: "s")
                        .frame(width: geometry.size.width/3, height: geometry.size.height, alignment: .center)
                }
                
            }
            .frame(height: 75)
        }
    }
}


/*
 //This "works" but due to an ios 15 bug the pickers aren't picking up correctly
 
 // MARK: - Prep Time Picker View
 struct PrepTimePickerView: View{
 @StateObject var vm: EditIdeaVM
 var body: some View{
 GeometryReader { geometry in
 HStack(spacing: 10){
 Picker(selection: $vm.hourSelection, label: Text("Hours")){
 ForEach(0 ..< vm.hours.count) { index in
 Text("\(vm.hours[index]) h").tag(index)
 }
 }
 .pickerStyle(.wheel)
 .frame(width: geometry.size.width/3, height: geometry.size.height, alignment: .center)
 .compositingGroup()
 .clipped(antialiased: false)
 
 
 Picker(selection: $vm.minuteSelection, label: Text("Minutes")){
 ForEach(0 ..< vm.minutes.count) { index in
 Text("\(vm.minutes[index]) m").tag(index)
 }
 }
 .pickerStyle(.wheel)
 .frame(width: geometry.size.width/3, height: geometry.size.height, alignment: .center)
 .compositingGroup()
 .clipped(antialiased: false)
 
 
 Picker(selection: $vm.secondSelection, label: Text("Seconds")){
 ForEach(0 ..< vm.seconds.count) { index in
 Text("\(vm.seconds[index]) s").tag(index)
 }
 }
 .pickerStyle(.wheel)
 .frame(width: geometry.size.width/3, height: geometry.size.height, alignment: .center)
 .compositingGroup()
 .clipped(antialiased: false)
 
 }
 }
 
 }
 }
 */

