//
//  EditIdeaView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

struct EditIdeaView: View {
    @StateObject var vm: EditIdeaVM
    enum FormTextField{ // will need changed to match this form
        case firstName, lastName, email
    }
    var body: some View {
        Form{
            Section(header: Text("Meal Information")) {
                MealPhotoButtonView()
                    
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
                MealInstructionsButtonView()
                
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
                // TODO:  Add a confirmation alert before processing delete
                Spacer(minLength: 5)
                DeleteButtonView(vm: vm)
//                    .frame(width: 450)
                    .listRowBackground(Color.red)
            }
            
        }
        .onAppear(perform: {
            vm.convertMeal()
        })
        .navigationTitle(vm.meal?.mealName ?? "Create a Meal")

        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
        
}

struct CreateIdeaView_Previews: PreviewProvider {
    static var previews: some View {
        EditIdeaView(vm: EditIdeaVM(meal: nil))
    }
}
// MARK: - Meal Photo Button View
struct MealPhotoButtonView: View{
    
    var body: some View{
        Button {
            //bring up camera or image picker options
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
    
    var body: some View{
        Button {
            //bring up camera or image picker options
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
    var body: some View{
            Button {
                vm.deleteMeal()
            } label: {
                Text("Delete Meal")
                    .padding()
                    .foregroundColor(.white)
            }
        
    }
}

