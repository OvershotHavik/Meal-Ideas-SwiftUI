//
//  ZoomImageView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/22/21.
//

import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    typealias UIViewType = PDFView

    private var image: UIImage
    private var website: String?
    
    init(_ image: UIImage, website: String?) {
        self.image = image
        self.website = website
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
    var website: String?
    @State private var isShareSheetShowing = false
    
    var body: some View {
        ZStack {
            PDFKitRepresentedView(image, website: website)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if website != nil{
                    if website != ""{
                        Button {
                            print("Share tapped")
                            presentShareAS()
                        } label: {
                            Image(systemName: SFSymbols.share.rawValue)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }


    private func presentShareAS(){
        isShareSheetShowing.toggle()
        if let safeWebsite = website{
            let shareActionSheet = UIActivityViewController(activityItems: [safeWebsite],  applicationActivities: nil)
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            
            window?.rootViewController?.present(shareActionSheet, animated: true, completion: nil)
        }
    }
}
 
