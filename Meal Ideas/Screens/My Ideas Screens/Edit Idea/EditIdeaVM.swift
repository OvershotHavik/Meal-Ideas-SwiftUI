//
//  EditIdeaVM.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI
import CoreData
import Combine

enum ImagePickerSelection: Identifiable {
    case mealPhoto, instructions
    
    var id: Int {
        hashValue
    }
}

class EditIdeaVM: ObservableObject{
    
    @Published var allMeals: [UserMeals] = []
    @Published var meal : UserMeals?
    @Published var alertItem: AlertItem?
    
    // UI Adjustments
    @Published var isMPActionSheetPresented = false
    @Published var isMIActionSheetPresented = false
    @Published var showingDeleteAlert = false
    @Published var showingBackAlert = false
    @Published var isLoading = false
    
    // For Image Picker
    @Published var isShowPhotoLibrary = false
    @Published var imagePickerSelection : ImagePickerSelection?
    @Published var imageSource: UIImagePickerController.SourceType = .camera
    
    // Meal Variables
    @Published var mealPhoto = UIImage()
    @Published var mealName = ""
    @Published var mealNameInUse: Bool = false
    @Published var categories: [String] = []
    @Published var userIngredients : [UserIngredient] = []
    @Published var recipe = ""
    @Published var instructionsPhoto = UIImage()
    @Published var sides : [String] = []
    @Published var source = ""
    @Published var favorited = false
    @Published var userMealID: UUID?
    
    // for verification
    @Published var safeMealPhoto = UIImage()
    @Published var safeInstructionsPhoto = UIImage()
    @Published var safeMealIngredients: [UserIngredient] = []
    
    // Prep Time
    @Published var hourSelection = 0
    @Published var minuteSelection = 0
    @Published var secondSelection = 0
    @Published var hours = [Int](0..<25)
    @Published var minutes = [Int](0..<60)
    @Published var seconds = [Int](0..<60)
    
    private var cancellables = Set<AnyCancellable>()
    private let pc = PersistenceController.shared
    
    
    init(meal: UserMeals?){
        self.meal = meal
        convertMeal()
        getAllMeals()
        addMealNameSubscriber()
    }
    
    
    private func addMealNameSubscriber(){
        $mealName
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main) // would delay the call for the seconds you specify
            .map{[weak self] (text) -> Bool in
                return self?.checkNameAlreadyInUseSave() ?? false
            }
            .sink(receiveValue: { [weak self] isInUse in
                self?.mealNameInUse = isInUse
            })
            .store(in: &cancellables)
    }
    
    
    func deleteIngredient(at offsets: IndexSet){
        userIngredients.remove(atOffsets: offsets)
    }
    
    
    private func getAllMeals(){
        let request = NSFetchRequest<UserMeals>(entityName: EntityName.userMeals.rawValue)
        do {
            self.allMeals = try pc.container.viewContext.fetch(request)
            print("Meals Fetched")
        } catch let error {
            print("error fetching: \(error.localizedDescription)")
        }
    }
    

    func checkNameAlreadyInUseOnSubmit(){
        if allMeals.contains(where: {$0.mealName == mealName}){
            //If the meal name already exists, show alert
            self.alertItem = AlertContext.nameInUse
        }
    }
    

    func saveMeal(){
        if mealName == ""{
            //if nothing was entered for meal name, alert that it is needed
            self.alertItem = AlertContext.blankMealName
            return
        }
        if checkNameAlreadyInUseSave(){
            //if true, return
            return
        }
        
        print("Save meal...")
        var mealPhotoData: Data?
        
        if mealPhoto != UIImage(){
            mealPhotoData = mealPhoto.jpegData(compressionQuality: 0.25)
        }
        
        var instructionsPhotoData: Data?
        if instructionsPhoto != UIImage(){
            instructionsPhotoData = instructionsPhoto.jpegData(compressionQuality: 0.25)
        }
        
        var ingredients : [String] = []
        var measurements : [String] = []
        
        userIngredients = userIngredients.sorted {$0.name < $1.name}
        for x in userIngredients{
            ingredients.append(x.name)
            measurements.append(x.measurement)
        }
        
        if source != ""{
            if verifyUrl(urlString: source) == false {
                self.alertItem = AlertContext.invalidSourceURL
                return
            }
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
            case .failure(_):
                self.alertItem = AlertContext.unableToSave
            }
        }
    }
    

    private func checkNameAlreadyInUseSave() -> Bool{
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
    

    private func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    

    private func updateFavorites(){
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
    

    func deleteMeal(){
        print("Delete meal...")
        if let safeMeal = meal{
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
    
    
    private func convertMeal(){
        //Convert meal to values to be able to modify it
        guard let safeMeal = meal else {
            return
        }
        self.mealName = safeMeal.mealName ?? ""
        
        //Meal photo is being assigned in the view via a task to an image loader
        
        self.categories = safeMeal.category as? [String] ?? []
        let ingredients = safeMeal.ingredients as? [String] ?? []
        let measurements = safeMeal.measurements as? [String] ?? []
        for (index, _) in ingredients.enumerated() {
            let UserIngredient = UserIngredient(name: ingredients[index],
                                                measurement: measurements[index])
            self.userIngredients.append(UserIngredient)
            self.safeMealIngredients.append(UserIngredient)
        }
        
        self.hourSelection = Int(safeMeal.prepHour)
        self.minuteSelection = Int(safeMeal.prepMinute)
        self.secondSelection = Int(safeMeal.prepSecond)
        
        //Instructions photo is being assigned in the view via a task to an image loader

        self.recipe = safeMeal.recipe ?? ""
        
        self.sides = safeMeal.sides as? [String] ?? []
        self.source = safeMeal.source ?? ""
        self.userMealID = safeMeal.userMealID
    }


    func convertDate(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        let time = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "E, MMM d"
        let day = dateFormatter.string(from: date)
        return "\(time)\n\(day)"
    }


    func checkForChanges(){
        //user came into the view with a meal
        if let safeMeal = meal{
            guard let safeMealName = safeMeal.mealName,
                  let safeRecipe = safeMeal.recipe,
                  let safeSource = safeMeal.source else {
                      showingBackAlert = true
                      return}
            if mealPhoto != safeMealPhoto ||
                mealName != safeMealName ||
                categories != safeMeal.category as? [String] ||
                userIngredients != safeMealIngredients ||
                recipe != safeRecipe ||
                instructionsPhoto != safeInstructionsPhoto ||
                sides != safeMeal.sides as? [String] ||
                hourSelection != Int(safeMeal.prepHour) ||
                minuteSelection != Int(safeMeal.prepMinute) ||
                secondSelection != Int(safeMeal.prepSecond) ||
                source != safeSource
            {
                //user made changes, show the alert
                showingBackAlert = true
            } else {
                //no changes made, don't show the alert
                showingBackAlert = false
            }
        } else {
            //New meal not saved yet
            if mealPhoto == UIImage() &&
                mealName == "" &&
                categories == [] &&
                userIngredients == [] &&
                recipe == "" &&
                instructionsPhoto == UIImage() &&
                sides == [] &&
                hourSelection == 0 &&
                minuteSelection == 0 &&
                secondSelection == 0 &&
                source == "" {
                //no changes made, don't show the alert
                showingBackAlert = false
            } else {
                //user made changes, show the alert
                showingBackAlert = true
            }
        }
    }
}
