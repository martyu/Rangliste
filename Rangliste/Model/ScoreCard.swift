//
//  ScoreCard.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation

struct ScoreCard {
	let id: UUID
	let schwinger: Schwinger
	let matches: [Match]
	let ageGroup: AgeGroup
}

extension ScoreCard {
	var wins: Int {
		matches.filter { match in
			if match.schwinger1.id == schwinger.id {
				if case .win = match.resultSchwinger1 {
					return true
				}
			} else if match.schwinger2.id == schwinger.id {
				if case .win = match.resultSchwinger2 {
					return true
				}
			}
			return false
		}.count
	}
	
	var losses: Int {
		matches.filter { match in
			if match.schwinger1.id == schwinger.id {
				if case .loss = match.resultSchwinger1 {
					return true
				}
			} else if match.schwinger2.id == schwinger.id {
				if case .loss = match.resultSchwinger2 {
					return true
				}
			}
			return false
		}.count
	}
	
	var ties: Int {
		matches.filter { match in
			if match.schwinger1.id == schwinger.id {
				if case .tie = match.resultSchwinger1 {
					return true
				}
			} else if match.schwinger2.id == schwinger.id {
				if case .tie = match.resultSchwinger2 {
					return true
				}
			}
			return false
		}.count
	}
	
	var totalPoints: Double {
		return matches.reduce(0) { (result, match) -> Double in
			if match.schwinger1.id == schwinger.id {
				return result + (match.resultSchwinger1?.points ?? 0)
			} else if match.schwinger2.id == schwinger.id {
				return result + (match.resultSchwinger2?.points ?? 0)
			}
			return result
		}
	}
	
	var winLossTieString: String {
		var resultString = ""
		for match in matches {
			if match.schwinger1.id == schwinger.id {
				switch match.resultSchwinger1 {
				case .win:
					resultString += "+"
				case .loss:
					resultString += "o"
				case .tie:
					resultString += "-"
				default:
					break
				}
			} else if match.schwinger2.id == schwinger.id {
				switch match.resultSchwinger2 {
				case .win:
					resultString += "+"
				case .loss:
					resultString += "o"
				case .tie:
					resultString += "-"
				default:
					break
				}
			}
		}
		return resultString
	}
}