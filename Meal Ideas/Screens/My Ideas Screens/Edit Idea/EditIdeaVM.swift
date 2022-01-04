//
//  EditIdeaVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI
import CoreData

enum ImagePickerSelection: Identifiable {
    case mealPhoto, instructions
    
    var id: Int {
        hashValue
    }
}

final class EditIdeaVM: ObservableObject{

    @Published var allMeals: [UserMeals] = []
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
    @Published var userMealID: UUID?
    
    // MARK: - Prep Time
    @Published var hourSelection = 0
    @Published var minuteSelection = 0
    @Published var secondSelection = 0
    @Published var hours = [Int](0..<25)
    @Published var minutes = [Int](0..<60)
    @Published var seconds = [Int](0..<60)
    
    
    // MARK: - used for Core Data
    private let pc = PersistenceController.shared

    init(meal: UserMeals?){
        self.meal = meal
        convertMeal()
        getAllMeals()
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
    
    // MARK: - Get All Meals
    func getAllMeals(){
        let request = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)
        do {
            self.allMeals = try pc.container.viewContext.fetch(request)
            print("Meals Fetched")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Check if name is already in use
    func checkNameAlreadyInUse(){
        if allMeals.contains(where: {$0.mealName == mealName}){
            //If the meal name already exists, return true so user will need to change it
            if meal != nil {
                if meal?.mealName == mealName{
                    //if the name is already in use by this meal, return false since it's already named this and is OK
                }
            }
            self.alertItem = AlertContext.nameInUse
        }
    }
    /*
    func checkNameAlreadyInUse() -> Bool{
        if allMeals.contains(where: {$0.mealName == mealName}){
            //If the meal name already exists, return true so user will need to change it
            if meal != nil {
                if meal?.mealName == mealName{
                    //if the name is already in use by this meal, return false since it's already named this and is OK
                    return false
                }
            }
            self.alertItem = AlertContext.nameInUse
            return true
        } else {
            return false
        }
    }
    */
    
    // MARK: - UpdateFavorite
    func updateFavorites(){
        //Update the favorites so the favorites list doesn't try to access a meal that doesn't exist
        let request = NSFetchRequest<Favorites>(entityName: EntityName.favorites.rawValue)
        var allFavorites : [Favorites] = []
        do {
            allFavorites = try pc.container.viewContext.fetch(request)
            print("Favorites Fetched")
            if let safeMeal = self.meal{
                guard let index = allFavorites.firstIndex(where: {$0.mealName == safeMeal.mealName}) else {return}
                let favoriteToUpdate = allFavorites[index]
                favoriteToUpdate.mealName = mealName
                print("Updated favorites for \(mealName)")
                try pc.container.viewContext.save()
            }

        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }

    
    // MARK: - Save Meal
    func saveMeal(){
        
        if mealName == ""{
            //if nothing was entered for meal name, alert that it is needed
            self.alertItem = AlertContext.blankMealName
            return
        }
//        if checkNameAlreadyInUse(){
//            //if true, return
//            return
//        }

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
            if safeMeal.mealName != mealName{
                updateFavorites()
                pc.clearHistory(meal: safeMeal)
            }
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
            safeMeal.prepHour = Int16(hourSelection)
            safeMeal.prepMinute = Int16(minuteSelection)
            safeMeal.prepSecond = Int16(secondSelection)
            safeMeal.modified = Date()
            safeMeal.userMealID = userMealID
            print("usermealID: \(String(describing: safeMeal.userMealID))")

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
            newMealCD.prepHour = Int16(hourSelection)
            newMealCD.prepMinute = Int16(minuteSelection)
            newMealCD.prepSecond = Int16(secondSelection)
            newMealCD.created = Date()
            newMealCD.userMealID = UUID()
            print("usermealID: \(String(describing: newMealCD.userMealID))")
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
//            pc.deleteMeal(meal: safeMeal)
            pc.clearHistory(meal: safeMeal)
                PersistenceController.shared.deleteFavorite(source: .mealDB,
                                                            mealName: safeMeal.mealName ?? "",
                                                            mealDBID: nil,
                                                            spoonID: nil,
                                                            userMealID: safeMeal.userMealID)
            pc.deleteMeal(meal: safeMeal)
            pc.saveData()
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
        
        
        self.hourSelection = Int(safeMeal.prepHour)
        self.minuteSelection = Int(safeMeal.prepMinute)
        self.secondSelection = Int(safeMeal.prepSecond)
        
        if let safeInstructionsData = safeMeal.instructionsPhoto{
            self.instructionsPhoto = UIImage(data: safeInstructionsData) ?? UIImage()
        }
        self.recipe = safeMeal.recipe ?? ""
        
        self.sides = safeMeal.sides as? [String] ?? []
        self.source = safeMeal.source ?? ""
        self.userMealID = safeMeal.userMealID
        
    }
    // MARK: - Convert Date
    func convertDate(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        let time = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "E, MMM d"
        let day = dateFormatter.string(from: date)
        return "\(time)\n\(day)"
    }
}
