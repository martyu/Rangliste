//
//  AddSchwingfest.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/13/23.
//

import Foundation

protocol SchwingfestRepository {
	func fetchSchwingfest() async throws -> Schwingfest
	func saveSchwingfest(_ schwingfest: Schwingfest) async throws
}

protocol SchwingerRepository {
	func fetchSchwinger(id: UUID) async throws -> Schwinger
	func fetchSchwingers() async throws -> [Schwinger]
	func saveSchwinger(_ schwinger: Schwinger) async throws
}

protocol AgeGroupManager {
	func fetchAgeGroup(for age: Int) async throws -> AgeGroup
	func fetchAllAgeGroups() async throws -> [AgeGroup]
}

protocol MatchRepository {
	func fetchMatches(for schwinger: Schwinger) async throws -> [Match]
	func saveMatch(_ match: Match) async throws
}

protocol ScoreCardRepository {
	func fetchScoreCards(for schwinger: Schwinger) async throws -> [ScoreCard]
	func saveScoreCard(_ scoreCard: ScoreCard) async throws
}

protocol ScoreCardPointCalculator {
	func calculateTotalPoints(_ scoreCard: ScoreCard) async throws -> Double
}

protocol ScoreCardPresentation {
	func formatScoreCard(_ scoreCard: ScoreCard) async throws -> String
}

protocol RanglisteInteractor {
	func compileRangliste(for schwingfest: Schwingfest) async throws -> String
}
