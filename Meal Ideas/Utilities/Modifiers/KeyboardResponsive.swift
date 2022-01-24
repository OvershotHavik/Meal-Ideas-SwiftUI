//
//  KeyboardResponsive.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 1/24/22.
//

import SwiftUI
import Combine

//struct KeyboardResponsiveModifier: ViewModifier {
//  @State private var offset: CGFloat = 0
//
//  func body(content: Content) -> some View {
//    content
//      .padding(.bottom, offset)
//      .onAppear {
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
//          let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//          let height = value.height
////          let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom
//            let scenes = UIApplication.shared.connectedScenes
//            let windowScene = scenes.first as? UIWindowScene
//            let window = windowScene?.windows.first
//            let bottomInset = window?.safeAreaInsets.bottom
//          self.offset = height - (bottomInset ?? 0)
//        }
//
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notif in
//          self.offset = 0
//        }
//    }
//  }
//}
//
//extension View {
//  func keyboardResponsive() -> ModifiedContent<Self, KeyboardResponsiveModifier> {
//    return modifier(KeyboardResponsiveModifier())
//  }
//}





//
//extension View {
//    func onKeyboard(_ keyboardYOffset: Binding<CGFloat>) -> some View {
//        return ModifiedContent(content: self, modifier: KeyboardModifier(keyboardYOffset))
//    }
//}
//
//struct KeyboardModifier: ViewModifier {
//    @Binding var keyboardYOffset: CGFloat
//    let keyboardWillAppearPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
//    let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
//
//    init(_ offset: Binding<CGFloat>) {
//        _keyboardYOffset = offset
//    }
//
//    func body(content: Content) -> some View {
//        return content.offset(x: 0, y: -$keyboardYOffset.wrappedValue)
//            .animation(.easeInOut(duration: 0.33))
//            .onReceive(keyboardWillAppearPublisher) { notification in
//                let keyWindow = UIApplication.shared.connectedScenes
//                    .filter { $0.activationState == .foregroundActive }
//                    .map { $0 as? UIWindowScene }
//                    .compactMap { $0 }
//                    .first?.windows
//                    .filter { $0.isKeyWindow }
//                    .first
//
//                let yOffset = keyWindow?.safeAreaInsets.bottom ?? 0
//
//                let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
//
//                self.$keyboardYOffset.wrappedValue = keyboardFrame.height - yOffset
//        }.onReceive(keyboardWillHidePublisher) { _ in
//            self.$keyboardYOffset.wrappedValue = 0
//        }
//    }
//}

//
//struct AdaptsToKeyboard: ViewModifier {
//    @State var currentHeight: CGFloat = 0
//
//    func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            content
//                .padding(.bottom, self.currentHeight)
//                .onAppear(perform: {
//                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
//                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
//                        .compactMap { notification in
//                            withAnimation(.easeOut(duration: 0.16)) {
//                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
//                            }
//                    }
//                    .map { rect in
//                        rect.height - geometry.safeAreaInsets.bottom
//                    }
//                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
//
//                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
//                        .compactMap { notification in
//                            CGFloat.zero
//                    }
//                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
//                })
//        }
//    }
//}
//
//extension View {
//    func adaptsToKeyboard() -> some View {
//        return modifier(AdaptsToKeyboard())
//    }
//}




//struct KeyboardAdaptive: ViewModifier {
//    @State var bottomPadding: CGFloat = 0
//
//    func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            content
//                .padding(.bottom, self.bottomPadding)
////                .animation(.easeOut(duration: 0.16))
//                .onAppear(perform: {
//                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
//                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
//                        .compactMap { notification in
//                            notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
//                    }
//                    .map { rect in
//                        rect.height - geometry.safeAreaInsets.bottom
//                    }
//                    .subscribe(Subscribers.Assign(object: self, keyPath: \.bottomPadding))
//
//                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
//                        .compactMap { notification in
//                            CGFloat.zero
//                    }
//                    .subscribe(Subscribers.Assign(object: self, keyPath: \.bottomPadding))
//                })
//        }
//    }
//}
//
//extension View {
//    func keyboardAdaptive() -> some View {
//        ModifiedContent(content: self, modifier: KeyboardAdaptive())
//    }
//}

/*

import SwiftUI

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}
*/
