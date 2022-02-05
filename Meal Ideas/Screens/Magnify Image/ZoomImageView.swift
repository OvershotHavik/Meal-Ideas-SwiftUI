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
 
