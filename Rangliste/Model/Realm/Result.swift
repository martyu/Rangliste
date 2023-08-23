//
//  MatchResult.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation
import RealmSwift

public class MatchResult: EmbeddedObject {
	@Persisted public var outcome: Outcome = .tie
	@Persisted public var points: Double = 9
}

public extension MatchResult {
	var outcomeSymbol: String {
		switch outcome {
		case .loss: return "o"
		case .tie: return "-"
		case .win: return "+"
		}
	}
}

extension Double {
	public var pointsFormatted: String {
		String(format: "%.2f", self)
	}
}

public enum Outcome: String, CaseIterable, Codable, PersistableEnum {
	case win = "Win"
	case tie = "Tie"
	case loss = "Loss"
}

extension Outcome: Identifiable {
	public var id: Outcome {
		self
	}
}

extension MatchResult {
	static var random: MatchResult {
		let result = MatchResult()
		switch (0...2).randomElement()! {
		case 0:
			result.outcome = .win
			result.points = 9.75
		case 1:
			result.outcome = .tie
			result.points = 9.00
		case 2:
			result.outcome = .loss
			result.points = 8.75
		default:
			fatalError()
		}
		return result
	}
}
