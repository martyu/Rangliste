//
//  DataManager.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/5/23.
//

import Foundation
import Combine
import UIKit

class DataManager: SchwingfestRepo, ObservableObject {
	static let shared = DataManager()

	@Published var schwingfests: Set<Schwingfest> = Set()
	
	private var cancels = Set<AnyCancellable>()
	
	private init() {
		loadSchwingfests()

		$schwingfests
			.sink { [weak self] schwingfests in
				for schwingfest in schwingfests {
					guard let self else { return }
					schwingfest.objectWillChange.sink { _ in
						self.saveSchwingfests(schwingfests)
					}
					.store(in: &self.cancels)
					
					for scorecard in schwingfest.scorecards {
						scorecard.objectWillChange.sink { _ in
							self.saveSchwingfests(schwingfests)
						}
						.store(in: &cancels)
					}
				}
				self?.saveSchwingfests(schwingfests)
			}
			.store(in: &cancels)
		
		Timer.TimerPublisher(interval: 10, runLoop: .current, mode: .default).sink { [weak self] _ in
			guard let self else { return }
			self.saveSchwingfests(self.schwingfests)
		}
		.store(in: &cancels)
	}
	
	deinit {
		saveSchwingfests(schwingfests)
	}
}

extension DataManager {
	func saveSchwingfest(_ schwingfest: Schwingfest) {
		schwingfests.insert(schwingfest)
	}
	
	func schwingfest(withID id: String) -> Schwingfest {
		guard let schwingfest = schwingfests.first(where: { $0.id == id }) else {
			fatalError("schwingfest with id not found: \(id)\n\(schwingfests.isEmpty ? "EMPTY" : "\(schwingfests.map(\.id))")")
		}
		return schwingfest
	}
	
	func addMatch(_ match: Match) {
		schwingfest(withID: match.schwingfest).scorecards.filter { [match.schwinger1, match.schwinger2].contains($0.schwinger) }.forEach {
			$0.matches = $0.matches.filter { $0.round != match.round || $0.schwingfest != match.schwingfest }
			$0.matches.append(match)
			$0.matches.sort()
		}
	}
	
	func removeMatch(_ match: Match) {
		for scorecard in schwingfest(withID: match.schwingfest).scorecards {
			scorecard.matches.removeAll { $0 == match }
			scorecard.objectWillChange.send()
		}
		objectWillChange.send()
	}
	
	func removeScorecards(atOffsets indexSet: IndexSet, forSchwingfest schwingfest: Schwingfest) {
		schwingfest.scorecards.remove(atOffsets: indexSet)
		schwingfest.scorecards.forEach { scorecard in
			scorecard.matches.removeAll { match in
				[match.schwinger1, match.schwinger2].contains(scorecard.schwinger)
			}
		}
	}

	private func loadSchwingfests() {
		print("loading")
		let schwingfestsFile = schwingfestsFile
		do {
			schwingfests = try JSONDecoder().decode(Set<Schwingfest>.self, from: Data(contentsOf: schwingfestsFile))
			//		schwingfests = Set(MockData().schwingfests)
		} catch {
			print("ERROR::: \(error)")
		}
	}

	func saveSchwingfests(_ schwingfests: Set<Schwingfest>) {
		print("saving")
		do {
			try JSONEncoder().encode(schwingfests).write(to: schwingfestsFile)
		} catch {
			fatalError("\(error)")
		}
	}
	
	private var schwingfestsFile: URL {
		let fileManager = FileManager.default
		let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
		return urls[0].appending(path: "schwingfests")
	}
}

extension Schwingfest {
	var matches: [Match] {
		scorecards.flatMap(\.matches)
	}
}
