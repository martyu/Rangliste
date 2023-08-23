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
	@Published var schwingfests: Set<Schwingfest> = Set()
	
//	@MainActor
	private init() {
		loadSchwingfests()
		NotificationCenter.default.addObserver(self, selector: #selector(saveSchwingfests), name: .deviceDidShakeNotification, object: nil)
	}
	
	deinit {
		saveSchwingfests()
	}
}

extension DataManager {
//	@MainActor
	static let shared = DataManager()
	
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

	private func loadSchwingfests() {
		let schwingfestsFile = schwingfestsFile
		schwingfests = (try? JSONDecoder().decode(Set<Schwingfest>.self, from: Data(contentsOf: schwingfestsFile))) ?? Set<Schwingfest>()
//		schwingfests = Set(MockData().schwingfests)
	}

	@objc
	private func saveSchwingfests() {
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
