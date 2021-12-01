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
                TextField("Meal Name", text: $vm.mealName)
            }
            
            Section(header: Text("Category")){
                CategorySelectView()
                
                ForEach(vm.categories, id: \.self){ cat in
                    Text(cat)
                }
            }
            
            Section(header: Text("Ingredients")){
                IngredientSelectView()
                
                ForEach($vm.userIngredients) {$ing in
                    HStack{
                        Text(ing.name)
                        TextField("Measurement", text: $ing.measurement)
                    }
                }
            }
            
            
            Section(header: Text("Sides")){
                SidesButtonView()
                ForEach(vm.sides, id: \.self) {side in
                    Text(side)
                }
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
                Text("Or type in below:")
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
                DeleteButtonView()
                    .frame(width: 450)
                    .listRowBackground(Color.red)
            }
            
        }
        .navigationTitle(vm.meal?.mealName ?? "Create a Meal")

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
//            Button {
//                //bring up ingredient selector
//            } label: {
//                Text("Select Ingredient(s)")
//            }
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
    var body: some View{
            Button {
                //Delete if meal exists
            } label: {
                Text("Delete Meal")
                    .padding()
                    .foregroundColor(.white)
            }
        
    }
}

