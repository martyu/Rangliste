//
//  Protocols.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/16/23.
//

import Foundation
import Combine

protocol SchwingfestRepo: ObservableObject {
	func saveSchwingfest(_ schwingfest: Schwingfest)
	func schwingfest(withID id: String) -> Schwingfest
	var schwingfests: Set<Schwingfest> { get }
}

extension SchwingfestRepo {
	func schwingfest(withID id: String) -> Schwingfest {
		schwingfests.first { $0.id == id }!
	}
}
