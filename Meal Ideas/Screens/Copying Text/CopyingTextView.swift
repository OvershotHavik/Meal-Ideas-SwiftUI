//
//  CopyingTextView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 3/31/22.
//

import SwiftUI

struct CopyingTextView: View {
    private var image: UIImage = UIImage(named: ImageNames.copyTextExample.rawValue) ?? UIImage()
    
    var body: some View {
        GeometryReader{ screenBounds in
            ScrollView{
                VStack{
                    Text("Tips for copying from a picture")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    Text("If you have the recipe/instructions printed out, or on a box, take a picture of it. Double tap on a word to get the cursors. Drag them to the beginning and end of the recipe/instructions. You can then tap copy, and then paste it in the recipe text box. You can also copy from a document or website the same way.\n\nSee example below:")
                    NavigationLink(destination: ZoomImageView(image: image)) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: screenBounds.size.height / 2)
                    }
                }
            }
            .padding()
        }
    }
}

