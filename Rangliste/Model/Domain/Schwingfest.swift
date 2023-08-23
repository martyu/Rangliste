//
//  Schwingfest.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/19/23.
//

import Foundation
import OrderedCollections

class Schwingfest: Codable, ObservableObject {
	let date: Date
	let location: String
	var ageGroups: [AgeGroup] {
		didSet {
			objectWillChange.send()
		}
	}
	var scorecards: [Scorecard] {
		didSet {
			objectWillChange.send()
		}
	}
	
	init(date: Date, location: String, ageGroups: [AgeGroup], scorecards: [Scorecard]) {
		self.date = date
		self.location = location
		self.ageGroups = ageGroups
		self.scorecards = scorecards
		
		self.scorecards = scorecards.map { scorecard in
			var scorecard = scorecard
			scorecard.schwingfest = id
			scorecard.matches = scorecard.matches.map { match in
				let match = match
				match.schwingfest = id
				return match
			}
			return scorecard
		}
	}
}

extension Schwingfest: Hashable {
	static func == (lhs: Schwingfest, rhs: Schwingfest) -> Bool {
		lhs.date == rhs.date && lhs.location == rhs.location
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
