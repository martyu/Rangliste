////
////  Match.swift
////  Rangliste
////
////  Created by Marty Ulrich on 6/21/23.
////
//
//import Foundation
//
//struct Match: Codable {
//	var round: Int
//	var schwinger1: Schwinger
//	var schwinger2: Schwinger
//	var resultSchwinger1: MatchResult = MatchResult()
//	var resultSchwinger2: MatchResult = MatchResult()
//}
//
//extension Match: Comparable {
//	static func < (lhs: Match, rhs: Match) -> Bool {
//		lhs.round < rhs.round
//	}
//}
//
//extension Match {
//	func result(for schwinger: Schwinger) -> MatchResult? {
//		if schwinger1 == schwinger {
//			return resultSchwinger1
//		} else if schwinger2 == schwinger {
//			return resultSchwinger2
//		} else {
//			fatalError()
//		}
//	}
//}
