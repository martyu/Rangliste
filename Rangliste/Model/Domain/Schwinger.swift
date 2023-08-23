//
//  Schwinger.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation

class Schwinger: Codable, Identifiable {
	let id: UUID
	var firstName: String
	var lastName: String
	var age: Int
	
	init(id: UUID = UUID(), firstName: String, lastName: String, age: Int) {
		self.id = id
		self.firstName = firstName
		self.lastName = lastName
		self.age = age
	}
}

extension Schwinger: Hashable {
	static func == (lhs: Schwinger, rhs: Schwinger) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
