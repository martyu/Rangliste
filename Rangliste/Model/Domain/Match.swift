//
//  Match.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation

class Match: Codable {
	var schwingfest: String
	var round: Int
	var schwinger1: Schwinger
	var schwinger2: Schwinger
	var resultSchwinger1: MatchResult = MatchResult()
	var resultSchwinger2: MatchResult = MatchResult()
	
	init(schwingfest: String, round: Int, schwinger1: Schwinger, schwinger2: Schwinger, resultSchwinger1: MatchResult, resultSchwinger2: MatchResult) {
		self.schwingfest = schwingfest
		self.round = round
		self.schwinger1 = schwinger1
		self.schwinger2 = schwinger2
		self.resultSchwinger1 = resultSchwinger1
		self.resultSchwinger2 = resultSchwinger2
	}
}

extension Match: Comparable {
	static func < (lhs: Match, rhs: Match) -> Bool {
		lhs.round < rhs.round
	}
}

extension Match {
	func result(for schwinger: Schwinger) -> MatchResult {
		if schwinger1 == schwinger {
			return resultSchwinger1
		} else if schwinger2 == schwinger {
			return resultSchwinger2
		} else {
			fatalError()
		}
	}
	
	func opponent(for schwinger: Schwinger) -> Schwinger {
		[schwinger1, schwinger2].filter { $0 != schwinger }.first!
	}
}

extension Match: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(schwingfest)
		hasher.combine(round)
		hasher.combine(schwinger1)
		hasher.combine(schwinger2)
	}
	
	static func == (lhs: Match, rhs: Match) -> Bool {
		lhs.schwingfest == rhs.schwingfest &&
		lhs.round == rhs.round &&
		lhs.schwinger1 == rhs.schwinger1 &&
		lhs.schwinger2 == rhs.schwinger2
	}
}
