//
//  TestCoreDataView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/7/21.
//

import SwiftUI

struct TestCoreDataView: View {
    @StateObject var vm = TestCoreDataVM()
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                TextField("Meal Name", text: $vm.TextFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
                Button {
                    //Make sure it is not empty
                    guard !vm.TextFieldText.isEmpty else { return }
                    vm.addMeal(Text: vm.TextFieldText)
                    
                } label: {
                    Text("Add Meal Name")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .cornerRadius(10)
                }
                
                List {
                    ForEach(vm.savedMeals) {meal in
                        Text(meal.mealName ?? "No name")
                            .onTapGesture {
                                vm.updateMeal(meal: meal)
                            }
                    }
                    .onDelete(perform: vm.deleteMeal)
                }
                
                .listStyle(PlainListStyle())

            }
            .navigationTitle("Meals")
        }
    }
}

struct TestCoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        TestCoreDataView()
    }
}
