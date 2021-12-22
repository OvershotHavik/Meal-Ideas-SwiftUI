//
//  ZoomImageView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/22/21.
//

import SwiftUI
import PDFKit


struct PDFKitRepresentedView: UIViewRepresentable {
    //PDFKitRepresentedView
    typealias UIViewType = PDFView

    var image: UIImage
    
    init(_ image: UIImage) {
        self.image = image
    }

    func makeUIView(context _: UIViewRepresentableContext<PDFKitRepresentedView>) -> UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.backgroundColor = UIColor.systemBackground
        
        if let pdfPage = PDFPage(image: image) {
            let pdfDoc = PDFDocument()
            pdfDoc.insert(pdfPage, at: 0)
            
            pdfView.autoScales = true
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            
            pdfView.document = pdfDoc
        }
        return pdfView
    }

    func updateUIView(_ pdfView: UIViewType, context _: UIViewRepresentableContext<PDFKitRepresentedView>) {
        if let pdfPage = PDFPage(image: image) {
            let pdfDoc = PDFDocument()
            pdfDoc.insert(pdfPage, at: 0)
            
            pdfView.autoScales = true
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            
            pdfView.document = pdfDoc
        }
    }
}

struct ZoomImageView : View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var image:UIImage
    @State private var isShareSheetShowing = false
    var body: some View {
        ZStack {
        PDFKitRepresentedView(image)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Share tapped")
                    presentShareAS()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
            }
        }
    }
    // MARK: - Present Share Action Sheet
    func presentShareAS(){
        isShareSheetShowing.toggle()
        let shareActionSheet = UIActivityViewController(activityItems: [image],  applicationActivities: nil)
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        window?.rootViewController?.present(shareActionSheet, animated: true, completion: nil)
    }
}
 

/*
struct EnlargedImage: View {
    //required to pass in
    var image: UIImage!
    
    //calculated:
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    @State var originalScale: CGFloat = 1.0
    
    //for supporting closing from a sheet or navigation view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            
            GeometryReader(content: { geometry in
                Color.clear.frame(width: 1, height: 1).onAppear(perform: {
                    print("calculating geo for image")
                    print(image.size)
                    print(geometry.size)
                    if image.size.width >= image.size.height {
                        if image.size.width > geometry.size.width {
                            originalScale = 1 - ((image.size.width - geometry.size.width) / image.size.width)
                            scale = originalScale
                        } else {
                            originalScale = 1
                            scale = 1
                        }
                    } else {
                        if image.size.height > geometry.size.height {
                            originalScale = 1 - ((image.size.height - geometry.size.height) / image.size.height)
                            scale = originalScale
                        } else {
                            originalScale = 1
                            scale = 1
                        }
                    }
                    print("original scale: \(originalScale)")
                })
            })
            
            ScrollView([.vertical, .horizontal], showsIndicators: false) {
                ZStack {
        
                    Image(uiImage: image).aspectRatio(contentMode: .fit).scaleEffect(scale)
                        .gesture(MagnificationGesture().onChanged { val in
                            let delta = val / self.lastScaleValue
                            self.lastScaleValue = val
                            var newScale = self.scale * delta
                            if newScale < originalScale
                            {
                                newScale = originalScale
                            }
                            scale = newScale
                        }.onEnded{val in
                            lastScaleValue = 1
                        })
                    
                }.frame(width: image.size.width * scale, height: image!.size.height * scale, alignment: .center)
            }.background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
            //shows a close button, remove if you like:
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        mode.wrappedValue.dismiss()
                    }, label: {
                        Text("close").padding() //your close button text or image, or just remove the entire button
                    })
                }
                Spacer()
            }
        }.edgesIgnoringSafeArea(.all)
    }
}
*/
