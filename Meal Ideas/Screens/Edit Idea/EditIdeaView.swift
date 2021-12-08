//
//  EditIdeaView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct EditIdeaView: View {
    @StateObject var vm: EditIdeaVM
    
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
//    @State var activeSheet: ActiveSheet?

    
    enum FormTextField{ // will need changed to match this form
        case firstName, lastName, email
    }
    

    
    var body: some View {
        Form{
            Section(header: Text("Meal Information")) {
                MealPhotoButtonView(vm: vm)
                    .modifier(MealPhotoActionSheet(vm: vm))
                if vm.mealPhoto != nil{
                    if let safeImage = vm.mealPhoto{
                        Image(uiImage: safeImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }
                }

                TextField(vm.meal?.mealName ?? "Meal Name", text: $vm.mealName)
            }
            
            Section(header: Text("Category")){
                CategorySelectView()
                
                ForEach(vm.categories, id: \.self){ cat in
                    Text(cat)
                }
                .onDelete(perform: vm.deleteCat)
            }
            
            Section(header: Text("Ingredients")){
                IngredientSelectView()
                
                ForEach($vm.userIngredients) {$ing in
                    HStack{
                        Text(ing.name)
                        Spacer()
                        TextField("Measurement", text: $ing.measurement)
                            .background(.green)
                            .frame(width: 100)
                    }
                }
                .onDelete(perform: vm.deleteIngredient)
            }
            
            
            Section(header: Text("Sides")){
                SidesButtonView()
                ForEach(vm.sides, id: \.self) {side in
                    Text(side)
                }
                .onDelete(perform: vm.deleteSide)
            }
            
            Section(header: Text("Instructions")){
                MealInstructionsButtonView(vm: vm)
                    .modifier(MealInstructionsActionSheet(vm: vm))
                if vm.instructionsPhoto != nil{
                    if let safeImage = vm.instructionsPhoto{
                        Image(uiImage: safeImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    }
                }
                Text("And/Or type in below:")
                TextEditor(text: $vm.recipe)
                    .frame(height: 150)
            }
            
            Section(header: Text("Source")){
                TextField("Website", text: $vm.source)
            }
            SaveButtonView(vm: vm)
                .listRowBackground(Color.green)
                
            if vm.meal != nil{
                //Only show and add space if the meal was passed in
                Spacer(minLength: 5)
                DeleteButtonView(vm: vm, showingDeleteAlert: $showingDeleteAlert)
//                    .frame(width: 450)
                    .listRowBackground(Color.red)
            }
            
        }
        .navigationTitle(vm.meal?.mealName ?? "Create a Meal")
        
//        .modifier(IdeaActionSheet(vm: vm))
//        .modifier(MealInstructionsActionSheet(vm: vm))
//        .modifier(MealPhotoActionSheet(vm: vm))
        
        
        /*
        .actionSheet(isPresented: $vm.isMPActionSheetPresented, content: {
            var buttons = [ActionSheet.Button]()
            let cameraRoll = ActionSheet.Button.default(Text("Camera Roll")) {
                //bring up the photo picker
            }
            buttons.append(cameraRoll)
            
            let camera = ActionSheet.Button.default(Text("Take Picture")) {
                //bring up the camera view
            }
            buttons.append(camera)
            if vm.mealPhoto != nil{
                // TODO:  make sure this actually works once photo data is saved
                let remove = ActionSheet.Button.destructive(Text("Remove Photo")){
                    //remove photo from meal
                    vm.mealPhoto = nil
                }
                buttons.append(remove)
            }
            buttons.append(.cancel())
            return ActionSheet(title: Text("Select where you want to get the photo from"), message: nil, buttons: buttons)
        })
        */
        
        // MARK: - Save alert
        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(Text("OK"), action: popView))
            
        }
        // MARK: - Delete Alert
        .alert("Delete Meal", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteMeal)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete \(vm.meal?.mealName ?? vm.mealName)?")
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
            //bring up action sheet to select where to get photo
//            vm.activeSheet = .mealPhoto
            vm.isMPActionSheetPresented.toggle()
            print("isMPActionSheetPresented state: \(vm.isMPActionSheetPresented)")
        } label: {
            Text("Select a photo for your meal")
        }
    }
}

// MARK: - Category Select View
struct CategorySelectView: View{
    
    var body: some View{
            Button {
                //bring up category selector
            } label: {
                Text("Select Category(s)")
            }
    }
}
// MARK: - Ingredient Select View
struct IngredientSelectView: View{
    @State var isActive = true
    var body: some View{
        
        NavigationLink(destination: IngredientsListView(vm: IngredientsListVM(), isActive: $isActive)) {
            Text("Select Ingredients")
        }
    }
}
// MARK: - Sides Button View
struct SidesButtonView: View{
    var body: some View{
        Button{
            // Bring up the sides selector
        } label: {
            Text("Select Sides")
        }
    }
}

// MARK: - Meal Instructions Button View
struct MealInstructionsButtonView: View{
    @ObservedObject var vm: EditIdeaVM
    var body: some View{
        Button {
//            vm.activeSheet = .mealInstructions
            //bring up camera or image picker options
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

struct MealPhotoActionSheet: ViewModifier{
    @StateObject var vm: EditIdeaVM
    func body(content: Content) -> some View {
        content
            .actionSheet(isPresented: $vm.isMPActionSheetPresented, content: {
                var buttons = [ActionSheet.Button]()
                let cameraRoll = ActionSheet.Button.default(Text("Camera Roll")) {
                    print("bring up camera roll")
                    //bring up the photo picker
                }
                buttons.append(cameraRoll)
                
                let camera = ActionSheet.Button.default(Text("Take Picture")) {
                    //bring up the camera view
                    print("bring up camera to take photo")
                }
                buttons.append(camera)
                if vm.mealPhoto != nil{
                    // TODO:  make sure this actually works once photo data is saved
                    let remove = ActionSheet.Button.destructive(Text("Remove Photo")){
                        //remove photo from meal
                        vm.mealPhoto = nil
                    }
                    buttons.append(remove)
                }
                buttons.append(.cancel())
                return ActionSheet(title: Text("Select where you want to get the photo from"), message: nil, buttons: buttons)
            })
    }
}

struct MealInstructionsActionSheet: ViewModifier{
    @StateObject var vm: EditIdeaVM
    func body(content: Content) -> some View {
        content
            .actionSheet(isPresented: $vm.isMIActionSheetPresented, content: {
                var buttons = [ActionSheet.Button]()
                let cameraRoll = ActionSheet.Button.default(Text("Camera Roll")) {
                    print("bring up camera roll")
                    //bring up the photo picker
                }
                buttons.append(cameraRoll)
                
                let camera = ActionSheet.Button.default(Text("Take Picture")) {
                    //bring up the camera view
                    print("bring up camera to take photo")
                }
                buttons.append(camera)
                if vm.instructionsPhoto != nil{
                    // TODO:  make sure this actually works once photo data is saved
                    let remove = ActionSheet.Button.destructive(Text("Remove Photo")){
                        //remove photo from meal
                        vm.instructionsPhoto = nil
                    }
                    buttons.append(remove)
                }
                buttons.append(.cancel())
                return ActionSheet(title: Text("Select where you want to get the photo from"), message: nil, buttons: buttons)
            })
    }
}
/*
struct IdeaActionSheet: ViewModifier{
    @StateObject var vm: EditIdeaVM
    func body(content: Content) -> some View {
        content
        
            .actionsheet
            .sheet(item: $vm.activeSheet,
                   onDismiss: resetActiveSheet) { item in
                switch item {
                case .mealPhoto:
                    VStack{
                        Button {
                            print("Meal Photo")
                        } label: {
                            Text("meal Photo ")
                        }
                    }
                case .mealInstructions:
                    VStack{
                        Button {
                            print("Meal Instructions")
                        } label: {
                            Text("Meal Instructions")
                        }
                    }



                }
            }
        

    }
    func resetActiveSheet(){
        vm.activeSheet = nil
    }
}

*/
