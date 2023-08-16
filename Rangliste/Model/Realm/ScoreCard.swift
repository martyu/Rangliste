//
//  ScoreCard.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation
import RealmSwift

public class ScoreCard: Object, Identifiable {
	@Persisted public var id: String = UUID().uuidString
	@Persisted public var schwinger: Schwinger?
	@Persisted public var matches: List<Match>
	@Persisted public var ageGroup: AgeGroup?
	@Persisted(originProperty: "scorecards") public var schwingfest: LinkingObjects<Schwingfest>
}

public extension ScoreCard {
	func otherSchwinger(for round: Int) -> Schwinger {
		let match = matches[round]
		return [match.schwinger1, match.schwinger2].first { $0 != schwinger }!!
	}
	
	func matchResult(for round: Int) -> MatchResult? {
		matches[round].result(for: schwinger!)
	}
}

public extension ScoreCard {
	var wins: Int {
		matches.filter { match in
			if match.schwinger1?.id == self.schwinger?.id {
				if case .win = match.resultSchwinger1?.outcome {
					return true
				}
			} else if match.schwinger2?.id == self.schwinger?.id {
				if case .win = match.resultSchwinger2?.outcome {
					return true
				}
			}
			return false
		}.count
	}
	
	var losses: Int {
		matches.filter { match in
			if match.schwinger1?.id == self.schwinger?.id {
				if case .loss = match.resultSchwinger1?.outcome {
					return true
				}
			} else if match.schwinger2?.id == self.schwinger?.id {
				if case .loss = match.resultSchwinger2?.outcome {
					return true
				}
			}
			return false
		}.count
	}
	
	var ties: Int {
		matches.filter { match in
			if match.schwinger1?.id == self.schwinger?.id {
				if case .tie = match.resultSchwinger1?.outcome {
					return true
				}
			} else if match.schwinger2?.id == self.schwinger?.id {
				if case .tie = match.resultSchwinger2?.outcome {
					return true
				}
			}
			return false
		}.count
	}
	
	var totalPoints: Double {
		matches.reduce(0) { (result, match) -> Double in
			if match.schwinger1?.id == self.schwinger?.id {
				return result + (match.resultSchwinger1!.points)
			} else if match.schwinger2?.id == self.schwinger?.id {
				return result + (match.resultSchwinger2!.points)
			}
			return result
		}.magnitude
	}
	
	var winLossTieString: String {
		var resultString = ""
		for match in matches {
			if match.schwinger1?.id == self.schwinger?.id {
				switch match.resultSchwinger1!.outcome {
				case .win:
					resultString += "+"
				case .loss:
					resultString += "o"
				case .tie:
					resultString += "-"
				}
			} else if match.schwinger2?.id == self.schwinger?.id {
				switch match.resultSchwinger2!.outcome {
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
