//
//  MockData.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation
import WebKit
import OrderedCollections

class MockData {
	let names = [
		"Fritzli Bär", "Ueli Schnitzel", "Toni Zopf", "Walter Rüebli", "Seppi Chnöpfli",
		"Hanspeter Chäschüechli", "Pius Bratwurst", "Kaspar Schoggi", "Ruedi Fondue", "Arnold Zürigschnätzlets",
		"Jürg Bündnerfleisch", "Peterli Spätzli", "Rolfli Raclette", "Werni Bürli", "Schorsch Salsiz",
		"Luzi Landjäger", "André Aargauer", "Heinrich Zibelechueche", "Moritz Maroni", "Gerhard Gugelhopf",
		"Kurtli Knöpfli", "Hansi Haferschleim", "Steffi Steinstoss", "Berti Brötlibeutel", "Vreni Vogelnest",
		"Pablo Pflaumenmus", "Zeno Z itronenzeste", "Dölf Drachenfrucht", "Frida Feigenkaktus", "Ursula Unkraut",
		"Karl Kürbiskern", "Lisa Leinsamen", "Pepe Papaya", "Regina Regenwurm", "Heidi Heuschrecke",
		"Maximilian Maulwurf", "Sandra Schneckenpost", "Pascal Pusteblume", "Rosmarie Rosenblüte", "Thomas Tulpe",
		"Jolanda Johannisbeere", "Konrad Kornblume", "Isolde Iris", "Hugo Hahnenfuss", "Gustav Grashüpfer",
		"Violetta Veilchen", "Werner Wacholder", "Adele Amsel", "Bruno Bär", "Cecile Chrysanthemum"
	]
	
	let ageGroups: [AgeGroup] = [
		AgeGroup(name: "Age 6-8", ages: 6...8),
		AgeGroup(name: "Age 9-11", ages: 9...11),
		AgeGroup(name: "Age 12-14", ages: 12...14),
		AgeGroup(name: "Juniors", ages: 15...17),
		AgeGroup(name: "Seniors", ages: 18...45)
	]
	
	lazy var schwingers: [Schwinger] = names.map {
		let ageGroup = ageGroups.randomElement()
		return Schwinger(
			id: UUID(),
			firstName: String($0.split(separator: " ")[0]),
			lastName: String($0.split(separator: " ")[1]),
			age: ageGroup!.ages.randomElement()!
		)
	}
	
	init() {
		let currentYear = Calendar.current.component(.year, from: Date())
		for year in 2022...currentYear {
			for name in schwingfestNames {
				let date = getDateForYear(year)
				let schwingfest = Schwingfest(date: date, location: name, ageGroups: ageGroups, scorecards: [])
				schwingfest.scorecards = generateScoreCards(for: schwingfest)
				schwingfests.append(schwingfest)
			}
		}
	}
	
	var scorecards: [Scorecard] = []
	var schwingfest: Schwingfest {
		guard let schwingfest = schwingfests.first else { fatalError("oh nooooo") }
		return schwingfest
	}
	@Published var schwingfests: [Schwingfest] = []

	let schwingfestNames = [
		"Eidgenössisches Schwing- und Älplerfest",
		"Unspunnen-Schwinget",
		"Kilchberger Schwinget",
		"Schwarzsee-Schwinget",
		"Weissenstein-Schwinget",
	]

	let schwingerClubs = [
		"Tacoma, WA",
		"Frances, WA",
		"Ripon, CA",
		"Truckee, CA",
		"Muotathal, CH"
	]

	func generateScoreCards(for schwingfest: Schwingfest) -> [Scorecard] {
		schwingers.map { schwinger in
			var matches: [Match] = []
			for round in 1...6 {
				var opponent: Schwinger
				repeat {
					opponent = schwingers[Int.random(in: 0..<schwingers.count)]
				} while opponent.id == schwinger.id
				
				let resultSchwinger1 = MatchResult.random
				let resultSchwinger2 = MatchResult.random
				let match = Match(schwingfest: schwingfest.id, round: round, schwinger1: schwinger, schwinger2: opponent, resultSchwinger1: resultSchwinger1, resultSchwinger2: resultSchwinger2)
				matches.append(match)
			}
			return Scorecard(
				schwingfest: schwingfest.id,
				schwinger: schwinger,
				matches: matches,
				ageGroup: ageGroups.randomElement()!,
				schwingerClub: schwingerClubs.randomElement()!
			)
		}
	}

	func getDateForYear(_ year: Int) -> Date {
		var components = DateComponents()
		components.year = year
		components.month = Int.random(in: 1...12) // Random month
		components.day = Int.random(in: 1...28) // Random day, up to 28 to always allow for February
		return Calendar.current.date(from: components)!
	}
	// Other lazy variables and methods...
}
