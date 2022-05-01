//
//  MultiWheelPicker.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/31/21.
//

import SwiftUI



// Work around to fix the picker view offset issue with ios 15 right now. Currently the picker touch area is offset to the left so that the middle gets adjust when you try to change the left, and the right gets adjusted when you try to change the middle.. If/When that gets fixed we can go back to the usual picker in a hstack, till then use the following:
//struct MultiWheelPicker: UIViewRepresentable {
//    var selections: Binding<[Double]>
//    let data: [Int]
//
//    func makeCoordinator() -> MultiWheelPicker.Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<MultiWheelPicker>) -> UIPickerView {
//        let picker = UIPickerView()
//        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//
//        picker.dataSource = context.coordinator
//        picker.delegate = context.coordinator
//
//        return picker
//    }
//
//    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<MultiWheelPicker>) {
//        for comp in selections.indices {
//            if let row = data.firstIndex(of: Int(selections.wrappedValue)) {
//                view.selectRow(row, inComponent: comp, animated: false)
//            }
//        }
//    }
//
//    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
//        var parent: MultiWheelPicker
//
//        init(_ pickerView: MultiWheelPicker) {
//            parent = pickerView
//        }
//
//        func numberOfComponents(in pickerView: UIPickerView) -> Int {
//            return parent.data.count
//        }
//
//        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//            return parent.data.count
//        }
//
//        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//            return 48
//        }
//
//        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//            return String(format: "%02.0f", parent.data[row])
//        }
//
//        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//            parent.selections.wrappedValue = parent.data[row]
//        }
//    }
//}


struct BasePicker: UIViewRepresentable {
    var selection: Binding<Int>
    let data: [Int]
    let label: String
    
    init(selecting: Binding<Int>, data: [Int], label: String) {
        self.selection = selecting
        self.data = data
        self.label = label
    }
    
    
    func makeCoordinator() -> BasePicker.Coordinator {
        Coordinator(self)
    }
    
    
    func makeUIView(context: UIViewRepresentableContext<BasePicker>) -> UIPickerView {
        let picker = UIPickerView()
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<BasePicker>) {
        guard let row = data.firstIndex(of: selection.wrappedValue) else { return }
        view.selectRow(row, inComponent: 0, animated: false)
    }
    
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: BasePicker
        
        init(_ pickerView: BasePicker) {
            parent = pickerView
        }
        
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 90
        }
        
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data.count
        }
        
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "\(parent.data[row].formatted()) \(parent.label)"
        }
        
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selection.wrappedValue = parent.data[row]
        }
    }
}
