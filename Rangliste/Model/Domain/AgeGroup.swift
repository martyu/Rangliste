//
//  AgeGroup.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation

class AgeGroup: Codable {
	var name: String
	var ages: ClosedRange<Int>
	
	init(name: String? = nil, ages: ClosedRange<Int>) {
		self.name = name ?? "\(ages.lowerBound) - \(ages.upperBound)"
		self.ages = ages
	}
}

extension AgeGroup: Hashable {
	static func == (lhs: AgeGroup, rhs: AgeGroup) -> Bool {
		lhs.name == rhs.name && lhs.ages == rhs.ages
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(name)
	}
}
