//
//  Binding+isPresent.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/21/23.
//

import Foundation
import SwiftUI

public func isPresent<Value>(_ binding: Binding<Value?>) -> Binding<Bool> {
	Binding<Bool>(
		get: { binding.wrappedValue != nil },
		set: { newValue in
			if !newValue {
				binding.wrappedValue = nil
			}
		}
	)
}
