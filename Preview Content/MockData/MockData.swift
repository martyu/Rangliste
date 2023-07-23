//
//  MockData.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation
import WebKit

class MockData {
	static let names = [
		"Fritzli Bär", "Ueli Schnitzel", "Toni Zopf", "Walter Rüebli", "Seppi Chnöpfli",
		"Hanspeter Chäschüechli", "Pius Bratwurst", "Kaspar Schoggi", "Ruedi Fondue", "Arnold Zürigschnätzlets",
		"Jürg Bündnerfleisch", "Peterli Spätzli", "Rolfli Raclette", "Werni Bürli", "Schorsch Salsiz",
		"Luzi Landjäger", "André Aargauer", "Heinrich Zibelechueche", "Moritz Maroni", "Gerhard Gugelhopf",
		"Kurtli Knöpfli", "Hansi Haferschleim", "Steffi Steinstoss", "Berti Brötlibeutel", "Vreni Vogelnest",
		"Pablo Pflaumenmus", "Zeno Zitronenzeste", "Dölf Drachenfrucht", "Frida Feigenkaktus", "Ursula Unkraut",
		"Karl Kürbiskern", "Lisa Leinsamen", "Pepe Papaya", "Regina Regenwurm", "Heidi Heuschrecke",
		"Maximilian Maulwurf", "Sandra Schneckenpost", "Pascal Pusteblume", "Rosmarie Rosenblüte", "Thomas Tulpe",
		"Jolanda Johannisbeere", "Konrad Kornblume", "Isolde Iris", "Hugo Hahnenfuss", "Gustav Grashüpfer",
		"Violetta Veilchen", "Werner Wacholder", "Adele Amsel", "Bruno Bär", "Cecile Chrysanthemum"
	]
	
	static let ageGroups = [
		AgeGroup(name: "Age 6-8", ages: 6...8),
		AgeGroup(name: "Age 9-11", ages: 9...11),
		AgeGroup(name: "Age 12-14", ages: 12...14),
		AgeGroup(name: "Juniors", ages: 15...17),
		AgeGroup(name: "Seniors", ages: 18...45)
	]
	
	static var schwingers: [Schwinger] = names.map {
		let ageGroup = ageGroups.randomElement()
		return Schwinger(
			id: UUID(),
			firstName: String($0.split(separator: " ")[0]),
			lastName: String($0.split(separator: " ")[1]),
			age: ageGroup?.ages.randomElement() ?? 18,
			ageGroup: ageGroup
		)
	}
	
	static var scoreCards: [ScoreCard] = schwingers.map { schwinger in
		var matches: [Match] = []
		for round in 1...6 {
			// Ensure a schwinger does not wrestle against himself
			var opponent: Schwinger
			repeat {
				opponent = schwingers[Int.random(in: 0..<schwingers.count)]
			} while opponent.id == schwinger.id
			
			let resultSchwinger1 = Result.random
			let resultSchwinger2 = Result.random
			let match = Match(round: round, schwinger1: schwinger, schwinger2: opponent, resultSchwinger1: resultSchwinger1, resultSchwinger2: resultSchwinger2)
			matches.append(match)
		}
		return ScoreCard(schwinger: schwinger, matches: matches, ageGroup: schwinger.ageGroup!)
	}
	
	static let schwingfest = Schwingfest(date: Date(), location: "Ripon", ageGroups: ageGroups, scoreCards: scoreCards)

	static let schwingfestNames = [
		"Eidgenössisches Schwing- und Älplerfest",
		"Unspunnen-Schwinget",
		"Kilchberger Schwinget",
		"Schwarzsee-Schwinget",
		"Weissenstein-Schwinget",
		// Add more schwingfest names as needed
	]

	static var schwingfests: [Schwingfest] {
		var schwingfests: [Schwingfest] = []

		let currentYear = Calendar.current.component(.year, from: Date())
		for year in 1950...currentYear {
			for name in schwingfestNames {
				let scoreCards = generateScoreCards()
				let date = getDateForYear(year)
				let schwingfest = Schwingfest(date: date, location: name, ageGroups: ageGroups, scoreCards: scoreCards)
				schwingfests.append(schwingfest)
			}
		}

		return schwingfests
	}

	static func generateScoreCards() -> [ScoreCard] {
		return schwingers.map { schwinger in
			var matches: [Match] = []
			for round in 1...6 {
				var opponent: Schwinger
				repeat {
					opponent = schwingers[Int.random(in: 0..<schwingers.count)]
				} while opponent.id == schwinger.id
				
				let resultSchwinger1 = Result.random
				let resultSchwinger2 = Result.random
				let match = Match(round: round, schwinger1: schwinger, schwinger2: opponent, resultSchwinger1: resultSchwinger1, resultSchwinger2: resultSchwinger2)
				matches.append(match)
			}
			return ScoreCard(schwinger: schwinger, matches: matches, ageGroup: schwinger.ageGroup!)
		}
	}

	static func getDateForYear(_ year: Int) -> Date {
		var components = DateComponents()
		components.year = year
		components.month = Int.random(in: 1...12) // Random month
		components.day = Int.random(in: 1...28) // Random day, up to 28 to always allow for February
		return Calendar.current.date(from: components)!
	}
	// Other static variables and methods...
}

extension Date {
	static func from(year: Int) -> Date {
		var components = DateComponents()
		components.year = year
		return Calendar.current.date(from: components) ?? Date()
	}
}
