//
//  EditIdeaVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI


enum ImagePickerSelection: Identifiable {
    case mealPhoto, instructions
    
    var id: Int {
        hashValue
    }
}

final class EditIdeaVM: ObservableObject{

    
    @Published var meal : UserMeals?
    @Published var alertItem: AlertItem?
    
    
    // MARK: - UI Adjustments
    @Published var isMPActionSheetPresented = false
    @Published var isMIActionSheetPresented = false
    @Published var showingDeleteAlert = false
    
    // MARK: - For Image Picker
    @Published var isShowPhotoLibrary = false
    @Published var imagePickerSelection : ImagePickerSelection?
    @Published var imageSource: UIImagePickerController.SourceType = .camera

    
    // MARK: - Meal Variables
    @Published var mealPhoto = UIImage()
    @Published var mealName = ""
    @Published var categories: [String] = []
    @Published var userIngredients : [UserIngredient] = []
    @Published var recipe = ""
    @Published var instructionsPhoto = UIImage()
    @Published var sides : [String] = []
    @Published var source = ""
    @Published var favorited = false
    
    // MARK: - Sets for selections
    @Published var ingredientSet = Set<String>()
    @Published var categorySet = Set<String>()
    @Published var sidesSet = Set<String>()
    
    // MARK: - used for Core Data
    private let pc = PersistenceController.shared

    init(meal: UserMeals?){
        self.meal = meal
        convertMeal()
    }
    
    // MARK: - Remove Category
    func deleteCat(at offsets: IndexSet){
        categories.remove(atOffsets: offsets)
    }
    // MARK: - Remove Ingredient
    func deleteIngredient(at offsets: IndexSet){
        userIngredients.remove(atOffsets: offsets)
    }
    // MARK: - Remove Sides
    func deleteSide(at offsets: IndexSet){
        sides.remove(atOffsets: offsets)
    }
    
    
    
    // MARK: - Save Meal
    func saveMeal(){
        
        print("Save meal...")
        var mealPhotoData: Data?
        
        if mealPhoto != UIImage(){
            mealPhotoData = mealPhoto.jpegData(compressionQuality: 1.0)
        }
        
        var instructionsPhotoData: Data?
        if instructionsPhoto != UIImage(){
            instructionsPhotoData = instructionsPhoto.jpegData(compressionQuality: 1.0)
        }
        
        var ingredients : [String] = []
        var measurements : [String] = []
        
        userIngredients = userIngredients.sorted {$0.name < $1.name}
        for x in userIngredients{
            ingredients.append(x.name)
            measurements.append(x.measurement)
        }
        
        //Update existing meal, or create a new one
        if let safeMeal = meal{
            safeMeal.mealName = mealName
            safeMeal.mealPhoto = mealPhotoData
            safeMeal.category = categories as NSObject
            safeMeal.ingredients = ingredients as NSObject
            safeMeal.sides = sides as NSObject
            safeMeal.source = source
            safeMeal.instructionsPhoto = instructionsPhotoData
            safeMeal.recipe = recipe
            safeMeal.favorite = favorited
            safeMeal.measurements = measurements as NSObject
        } else {
            let newMealCD = UserMeals(context: pc.container.viewContext)
            newMealCD.mealName = mealName
            newMealCD.mealPhoto = mealPhotoData
            newMealCD.category = categories as NSObject
            newMealCD.ingredients = ingredients as NSObject
            newMealCD.sides = sides as NSObject
            newMealCD.source = source
            newMealCD.instructionsPhoto = instructionsPhotoData
            newMealCD.recipe = recipe
            newMealCD.favorite = favorited
            newMealCD.measurements = measurements as NSObject
        }

        
        pc.saveData(){ result in
            switch result {
            case .success(_):
                print("Successfully saved \(self.mealName)")
                self.alertItem = AlertItem(title: Text("Success!"),
                                      message: Text("\(self.mealName) saved"),
                                      dismissButton: .default(Text("OK")))
                // TODO:  Make it so it pops the view back to the previous view
            case .failure(_):
                self.alertItem = AlertContext.unableToSave
            }
        }
    }

    // MARK: - Delete Meal
    func deleteMeal(){
        print("Delete meal...")
        if let safeMeal = meal{
            pc.deleteMeal(meal: safeMeal)
        }
    }
    
    // MARK: - Convert meal to values to be able to modify it
    func convertMeal(){
        guard let safeMeal = meal else {
            return
        }
        self.mealName = safeMeal.mealName ?? ""
        
        
        if let safeMealPhotoData = safeMeal.mealPhoto{
            self.mealPhoto = UIImage(data: safeMealPhotoData) ?? UIImage()
        }
        
        self.categories = safeMeal.category as? [String] ?? []
        let ingredients = safeMeal.ingredients as? [String] ?? []
        let measurements = safeMeal.measurements as? [String] ?? []
        for (index, _) in ingredients.enumerated() {
            let UserIngredient = UserIngredient(name: ingredients[index],
                                                measurement: measurements[index])
            self.userIngredients.append(UserIngredient)
        }
        
        if let safeInstructionsData = safeMeal.instructionsPhoto{
            self.instructionsPhoto = UIImage(data: safeInstructionsData) ?? UIImage()
        }
        self.recipe = safeMeal.recipe ?? ""
        
        self.sides = safeMeal.sides as? [String] ?? []
        self.source = safeMeal.source ?? ""
        
    }
}

/*
//Original before changing to use Core Data
final class EditIdeaVM: ObservableObject{
    @Published var meal : UserMealModel?
    @Published var alertItem: AlertItem?
    
    @Published var mealPhoto : UIImage?
    @Published var mealName = ""
    @Published var categories: [String] = []
    @Published var userIngredients : [UserIngredient] = []
    @Published var recipe = ""
    @Published var instructionsPhoto : UIImage?
    @Published var sides : [String] = []
    @Published var source = ""
    @Published var favorited = false
    

    init(meal: UserMealModel?){
        self.meal = meal
    }
    
    // MARK: - Remove Category
    func deleteCat(at offsets: IndexSet){
        categories.remove(atOffsets: offsets)
    }
    // MARK: - Remove Ingredient
    func deleteIngredient(at offsets: IndexSet){
        userIngredients.remove(atOffsets: offsets)
    }
    // MARK: - Remove Sides
    func deleteSide(at offsets: IndexSet){
        sides.remove(atOffsets: offsets)
    }
    
    
    
    // MARK: - Save Meal
    func saveMeal(){
        print("Save meal...")
        var mealPhotoData: Data?
        if let safePhoto = mealPhoto{
            mealPhotoData = safePhoto.jpegData(compressionQuality: 1.0)
        }
        
        var instructionsPhotoData: Data?
        if let safePhoto = instructionsPhoto{
            instructionsPhotoData = safePhoto.jpegData(compressionQuality: 1.0)
        }
        
        var ingredients : [String] = []
        var measurements : [String] = []
        
        userIngredients = userIngredients.sorted {$0.name < $1.name}
        for x in userIngredients{
            ingredients.append(x.name)
            measurements.append(x.measurement)
        }
        
        
        let newMeal = UserMealModel(mealName: mealName,
                                    mealPhoto: mealPhotoData,
                                    category: categories,
                                    ingredients: ingredients,
                                    sides: sides,
                                    source: source,
                                    instructionsPhoto: instructionsPhotoData,
                                    recipe: recipe,
                                    favorite: favorited,
                                    measurements: measurements)
        print(newMeal)
        // TODO:  save meal to core data
    }
    // MARK: - Delete Meal
    func deleteMeal(){
        print("Delete meal...")
        // TODO:  delete the meal from core data
    }
    
    // MARK: - Convert meal to values to be able to modify it
    func convertMeal(){
        guard let safeMeal = meal else {
            return
        }
        self.mealName = safeMeal.mealName
        
        if let safeMealPhotoData = safeMeal.mealPhoto{
            self.mealPhoto = UIImage(data: safeMealPhotoData)
        }
        
        self.categories = safeMeal.category
        
        for (index, _) in safeMeal.ingredients.enumerated(){
            let UserIngredient = UserIngredient(name: safeMeal.ingredients[index],
                                                measurement: safeMeal.measurements[index])
            self.userIngredients.append(UserIngredient)
        }
        
        if let safeInstructionsData = safeMeal.instructionsPhoto{
            self.instructionsPhoto = UIImage(data: safeInstructionsData)
        }
        self.recipe = safeMeal.recipe
        
        self.sides = safeMeal.sides
        self.source = safeMeal.source
        
    }
}
*/
