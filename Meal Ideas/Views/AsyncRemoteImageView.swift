//
//  AsycnRemoteImage.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/19/22.
//

import SwiftUI

struct AsyncRemoteImageView: View {
    private let source: URLRequest
    @State private var image: UIImage?

    @Environment(\.asyncImageLoader) private var imageLoader

    init(source: URL) {
        self.init(source: URLRequest(url: source))
    }

    init(source: URLRequest) {
        self.source = source
    }

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
            } else {
                Rectangle()
                    .background(Color.red)
            }
        }
        .task {
            await loadImage(at: source)
        }
    }

    func loadImage(at source: URLRequest) async {
        do {
            image = try await imageLoader.fetch(source)
        } catch {
            print(error)
        }
    }
}
/*
struct AsycnRemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        AsycnRemoteImage(source: <#URL#>)
    }
}
*/
