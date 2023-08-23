//
//  String+NonNil.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/16/23.
//

import Foundation

extension String? {
	var emptyIfNil: String {
		get {
			guard let self else { return "" }
			return self
		}
		set {
			self = newValue
		}
	}
}
