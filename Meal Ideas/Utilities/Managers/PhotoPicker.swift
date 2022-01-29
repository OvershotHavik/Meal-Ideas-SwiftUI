//
//  PhotoPicker.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/29/22.
//

import SwiftUI
import PhotosUI


struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    let filter: PHPickerFilter
    var limit: Int  // 0 == 'no limit'.
    @Binding var isLoading: Bool
    let onComplete: ([PHPickerResult]) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = limit
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.onComplete(results)
            parent.isLoading = false
            picker.dismiss(animated: true)
        }
        private let parent: PhotoPicker
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
    }
    static func convertToUIImageArray(fromResults results: [PHPickerResult], onComplete: @escaping ([UIImage]?, Error?) -> Void) {
        var images = [UIImage]()
        let dispatchGroup = DispatchGroup()
        for result in results {
            dispatchGroup.enter()
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (imageOrNil, errorOrNil) in
                    if let error = errorOrNil {
                        onComplete(nil, error)
                        dispatchGroup.leave()
                    }
                    if let image = imageOrNil as? UIImage {
                        images.append(image)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            onComplete(images, nil)
        }
    }
}



/*
 
 Usage within the EditIdea View:
 
 May end up using for the photo version, but image picker works fine for now. If I add the option to allow more photos to be saved, maybe we can allow the user to pick more later, but sticking with 1 for now
 
 would need to then switch between the source type, if the user selects camera, use the original image picker, if photo, use this
 
 PhotoPicker(filter: .images,
             limit: 1,
             isLoading: $vm.isLoading) { results in
     PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
         if let error = errorOrNil {
             print(error)
         }
         if let images = imagesOrNil {
             if let first = images.first {
                 print(first)
                 vm.mealPhoto = first
             }
         }
     }
 }
 */

/*

demo:

import SwiftUI
struct ContentView: View {
    @State private var showPhotoSheet = false
    @State private var image: UIImage? = nil
    @State var isLoading = false
    var body: some View {
        VStack {
            Button(action: { showPhotoSheet = true }) {
                Label("Choose photo", systemImage: "photo.fill")
            }
            
            .fullScreenCover(isPresented: $showPhotoSheet) {
                PhotoPicker(filter: .images, limit: 1, isLoading: $isLoading) { results in
                    PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
                        if let error = errorOrNil {
                            print(error)
                        }
                        if let images = imagesOrNil {
                            if let first = images.first {
                                print(first)
                                image = first
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
            
            
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, maxHeight: 200)
            }
        }
    }
}
*/
