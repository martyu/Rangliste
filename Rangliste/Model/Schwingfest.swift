//
//  Schwingfest.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/19/23.
//

import Foundation

struct Schwingfest {
	static func == (lhs: Schwingfest, rhs: Schwingfest) -> Bool {
		lhs.id == rhs.id
	}
	
	let date: Date
	let location: String
	var ageGroups: [AgeGroup]
	var scoreCards: [ScoreCard]
}
