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
    
    @FocusState private var focusedTextField: FormTextField?



    var body: some View {
        Form{
            Section(header: Text("Meal Information")) {
                TextField(vm.meal?.mealName ?? "Meal Name*", text: $vm.mealName)
                    .overlay{
                        Rectangle()
                            .stroke(vm.mealName == "" ? Color.red : Color.clear)
                    }
                    .font(.title)
                    .focused($focusedTextField, equals: .mealName)
                    .onSubmit {
                        vm.checkNameAlreadyInUse()
                    }
                    
                MealPhotoButtonView(vm: vm)
                    .modifier(MealPhotoActionSheet(vm: vm))
                if vm.mealPhoto != UIImage(){
                    if let safeImage = vm.mealPhoto{
                        HStack{
                            Image(uiImage: safeImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
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
            }
            
            Section(header: Text("Category")){
                CategorySelectView(vm: vm)
                
                ForEach(vm.categories, id: \.self){ cat in
                    Text(cat)
                }
                .onDelete(perform: vm.deleteCat)
            }
            
            Section(header: Text("Ingredients")){
                IngredientSelectView(vm: vm)
                
                ForEach($vm.userIngredients) {$ing in
                    HStack{
                        Text(ing.name)
                        Spacer()
                        TextField("Measurement", text: $ing.measurement)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 150)
                    }
                }
                .onDelete(perform: vm.deleteIngredient)
            }
            
            Section(header: Text("Sides")){
                SidesButtonView(vm: vm)
                ForEach(vm.sides, id: \.self) {side in
                    Text(side)
                }
                .onDelete(perform: vm.deleteSide)
            }
            
            Section(header: Text("Prep Time")){
                PrepTimePickerView(vm: vm)
            }
            
            Section(header: Text("Instructions")){
                MealInstructionsButtonView(vm: vm)
                    .modifier(MealInstructionsActionSheet(vm: vm))
                if vm.instructionsPhoto != UIImage(){
                    if let safeImage = vm.instructionsPhoto{
                        HStack{
                            Image(uiImage: safeImage)
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
                Text("And/Or type in below:")
                TextEditor(text: $vm.recipe)
                    .frame(height: 150)
                // TODO:  Disable the keyboard once done typing, add a done button or something
            }
            
            Section(header: Text("Source")){
                TextField("Website", text: $vm.source)
            }
            if vm.meal != nil{
                Section(header: Text("Modified Dates")){
                    if let safeModified = vm.meal?.modified{
                        Text("Last Modified on: \(vm.convertDate(date:safeModified))")
                    }
                    if let safeCreated = vm.meal?.created{
                        Text("Created on: \(vm.convertDate(date: safeCreated))")
                    }
                }
            }
            
            // MARK: - Save Button
            SaveButtonView(vm: vm)
                .listRowBackground(Color.green)
            
            if vm.meal != nil{
                //Only show and add space if the meal was passed in
                Spacer(minLength: 5)
                DeleteButtonView(vm: vm, showingDeleteAlert: $vm.showingDeleteAlert)
                    .listRowBackground(Color.red)
            }
        }
        .navigationTitle(vm.meal?.mealName ?? "Create a Meal")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack{
                    Spacer()
                    Button("Done"){hideKeyboard()}
                    .foregroundColor(.primary)
                }
            }
        }
        .onAppear{
            if vm.mealName.isEmpty{
                focusedTextField = .mealName
            }
            // TODO:  Change the background to the background gradient?
//            UITableView.appearance().backgroundColor = .clear
        }
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
                                sourceType: vm.imageSource)
                case .instructions:
                    ImagePicker(selectedImage: $vm.instructionsPhoto,
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
// MARK: - Meal Photo Button View
struct MealPhotoButtonView: View{
    @ObservedObject var vm: EditIdeaVM
    var body: some View{
        Button {
            vm.isMPActionSheetPresented.toggle()
            print("isMPActionSheetPresented state: \(vm.isMPActionSheetPresented)")
        } label: {
            Text("Select a photo for your meal")
        }
    }
}

// MARK: - Category Select View
struct CategorySelectView: View{
    @ObservedObject var vm: EditIdeaVM
    var body: some View{
        NavigationLink(destination: MultiChoiceListView(vm: MultiChoiceListVM(PList: .categories, editIdeaVM: vm), title: .multiCategory)) {
            Text("Select Categories")
        }
    }
}
// MARK: - Ingredient Select View
struct IngredientSelectView: View{
    @ObservedObject var vm: EditIdeaVM
    var body: some View{
        
        NavigationLink(destination: MultiIngredientListView(vm: IngredientListVM(editIdeaVM: vm))) {
            Text("Select Ingredients")
        }
    }
}
// MARK: - Sides Button View
struct SidesButtonView: View{
    @ObservedObject var vm: EditIdeaVM
    var body: some View{
        NavigationLink(destination: MultiChoiceListView(vm: MultiChoiceListVM(PList: .sides,
                                                                              editIdeaVM: vm), title: .multiSides)) {
            Text("Select Sides")
        }
    }
}

// MARK: - Meal Instructions Button View
struct MealInstructionsButtonView: View{
    @ObservedObject var vm: EditIdeaVM
    var body: some View{
        Button {
            vm.isMIActionSheetPresented.toggle()
            print("vm.isMIActionSheetPresented state: \(vm.isMIActionSheetPresented)")
        } label: {
            Text("Select a Photo")
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
                .foregroundColor(.white)
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
                .foregroundColor(.white)
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
                }
                buttons.append(cameraRoll)
                
                let camera = ActionSheet.Button.default(Text("Take Picture")) {
                    print("bring up camera to take photo")
                    vm.imagePickerSelection = .mealPhoto
                    vm.imageSource = .camera
                    vm.isShowPhotoLibrary.toggle()
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
                }
                buttons.append(cameraRoll)
                
                let camera = ActionSheet.Button.default(Text("Take Picture")) {
                    print("bring up camera to take photo")
                    vm.isShowPhotoLibrary.toggle()
                    vm.imageSource = .camera
                    vm.imagePickerSelection = .instructions
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

