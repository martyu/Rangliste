//
//  Scorecard.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation

public class Scorecard: Codable, Identifiable, ObservableObject {
	var schwingfest: String
	var schwinger: Schwinger
	var matches: [Match]
	var ageGroup: AgeGroup
	
	init(schwingfest: String, schwinger: Schwinger, matches: [Match], ageGroup: AgeGroup) {
		self.schwingfest = schwingfest
		self.schwinger = schwinger
		self.matches = matches
		self.ageGroup = ageGroup
	}
	
	public var id: String { "\(schwingfest)-\(schwinger.id)" }
}

extension Scorecard {
	func opponent(for round: Int) -> Schwinger {
		let match = matches[round]
		return opponent(for: match)
	}
	
	func opponent(for match: Match) -> Schwinger {
		[match.schwinger1, match.schwinger2].first { $0 != schwinger }!
	}
	
	func matchResult(for round: Int) -> MatchResult? {
		matches[safe: round].flatMap(matchResult)
	}
	
	func matchResult(for match: Match) -> MatchResult? {
		match.result(for: schwinger)
	}
}

extension Scorecard {
	var wins: Int {
		matches.filter { match in
			if match.schwinger1.id == schwinger.id {
				if case .win = match.resultSchwinger1.outcome {
					return true
				}
			} else if match.schwinger2.id == schwinger.id {
				if case .win = match.resultSchwinger2.outcome {
					return true
				}
			}
			return false
		}.count
	}
	
	var losses: Int {
		matches.filter { match in
			if match.schwinger1.id == schwinger.id {
				if case .loss = match.resultSchwinger1.outcome {
					return true
				}
			} else if match.schwinger2.id == schwinger.id {
				if case .loss = match.resultSchwinger2.outcome {
					return true
				}
			}
			return false
		}.count
	}
	
	var ties: Int {
		matches.filter { match in
			if match.schwinger1.id == schwinger.id {
				if case .tie = match.resultSchwinger1.outcome {
					return true
				}
			} else if match.schwinger2.id == schwinger.id {
				if case .tie = match.resultSchwinger2.outcome {
					return true
				}
			}
			return false
		}.count
	}
	
	var totalPoints: Double {
		return matches.reduce(0) { (result, match) -> Double in
			if match.schwinger1.id == schwinger.id {
				return result + (match.resultSchwinger1.points)
			} else if match.schwinger2.id == schwinger.id {
				return result + (match.resultSchwinger2.points)
			}
			return result
		}
	}
	
	var winLossTieString: String {
		var resultString = ""
		for match in matches {
			if match.schwinger1.id == schwinger.id {
				switch match.resultSchwinger1.outcome {
				case .win:
					resultString += "+"
				case .loss:
					resultString += "o"
				case .tie:
					resultString += "-"
				}
			} else if match.schwinger2.id == schwinger.id {
				switch match.resultSchwinger2.outcome {
				case .win:
					resultString += "+"
				case .loss:
					resultString += "o"
				case .tie:
					resultString += "-"
				}
			}
		}
		return resultString
	}
}

extension Scorecard: Equatable {
	public static func == (lhs: Scorecard, rhs: Scorecard) -> Bool {
		lhs.schwinger == rhs.schwinger &&
		lhs.schwingfest == rhs.schwingfest
	}
}

extension Scorecard: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(schwingfest)
		hasher.combine(schwinger)
	}
}

extension Collection {
	/// Returns the element at the specified index if it is within bounds, otherwise nil.
	subscript (safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
