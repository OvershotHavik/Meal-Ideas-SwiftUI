//
//  ImageLoader.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 11/30/21.
//

import SwiftUI

final class ImageLoader: ObservableObject{
    @Published var image: Image? = nil
    //If network call is good, pass up the actual image, if it's nil, it stays the placeholder
    func load(fromURLString urlString: String){
        NetworkManager.shared.downloadImage(fromURLString: urlString) { uiImage in
            guard let uiImage = uiImage else { return }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
}

struct RemoteImage: View{
    
    //helper for the placeholder and to use the placeholder or the actual image if it gets one
    var image: Image?
    var body: some View{
        image?.resizable() ?? Image("Placeholder").resizable() // If image is nil, use the image in asset as a placeholder
    }
}


struct LoadRemoteImageView: View{ // Used in the list view as a view
    
    @StateObject var imageLoader = ImageLoader()
    let urlString: String
    
    var body: some View{
        RemoteImage(image: imageLoader.image)
            .onAppear {
                imageLoader.load(fromURLString: urlString)
            }
    }
}
