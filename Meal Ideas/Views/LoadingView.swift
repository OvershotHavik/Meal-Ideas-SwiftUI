//
//  LoadingView.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 12/12/21.
//

import SwiftUI

struct loadingView: View{
    var body: some View{
        ZStack{
            VStack{
                Spacer()
                ProgressView() // Optional title
                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                    .scaleEffect(2) // doubles the size
                Spacer()
            }
//            Color(.systemBackground)
//                .ignoresSafeArea()

        }
    }
}
