//
//  ShakeResponder.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/21/23.
//

import SwiftUI
import UIKit

//struct ShakeResponder: ViewModifier {
//	@State private var enabled: Bool = false
//	
//	let handler: (Bool) -> ()
//
//	func body(content: Content) -> some View {
//		content
//			.onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
//				enabled.toggle()
//				handler(enabled)
//			}
//	}
//}
//
//extension View {
//	func onShake(handler: @escaping (Bool) -> ()) -> some View {
//		modifier(ShakeResponder(handler: handler))
//	}
//}

extension UIWindow {
	open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		if motion == .motionShake {
			NotificationCenter.default.post(name: .deviceDidShakeNotification, object: self)
		}
	}
}

// This extension to Notification.Name makes it easier to listen for the custom notification.
extension Notification.Name {
	static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}
