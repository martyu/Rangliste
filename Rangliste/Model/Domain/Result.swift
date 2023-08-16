////
////  MatchResult.swift
////  Rangliste
////
////  Created by Marty Ulrich on 6/21/23.
////
//
//import Foundation
//
//struct MatchResult: Codable {
//	var outcome: Outcome = .tie
//	var points: Double = 9
//}
//
//extension MatchResult {
//	var outcomeSymbol: String {
//		switch outcome {
//		case .loss: return "o"
//		case .tie: return "-"
//		case .win: return "+"
//		}
//	}
//}
//
//extension Double {
//	var pointsFormatted: String {
//		String(format: "%.2f", self)
//	}
//}
//
//extension MatchResult: Hashable {}
//
//enum Outcome: String, CaseIterable, Codable {
//	case win = "Win"
//	case tie = "Tie"
//	case loss = "Loss"
//}
//
//extension Outcome: Identifiable {
//	var id: Outcome {
//		self
//	}
//}
//
//extension MatchResult {
//	static var random: MatchResult {
//		switch (0...2).randomElement()! {
//		case 0:
//			return MatchResult(outcome: .win, points: 9.75)
//		case 1:
//			return MatchResult(outcome: .tie, points: 9.00)
//		case 2:
//			return MatchResult(outcome: .loss, points: 8.75)
//		default:
//			fatalError()
//		}
//	}
//}
