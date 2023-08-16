////
////  DataManager.swift
////  Rangliste
////
////  Created by Marty Ulrich on 8/5/23.
////
//
//import Foundation
//import RealmModels
//
//class DataManager {
//	var schwingfests: [Schwingfest] = []
//	
//	static let shared = DataManager()
//	
//	private init() {
//		loadSchwingfests()
//	}
//	
//	func loadSchwingfests() {
////		let schwingfestsFile = schwingfestsFile
////		schwingfests = (try? JSONDecoder().decode([Schwingfest].self, from: Data(contentsOf: schwingfestsFile))) ?? []
//	}
//
//	func saveSchwingfests() {
////		try! JSONEncoder().encode(schwingfests).write(to: schwingfestsFile)
//	}
//	
//	func schwingfest(withID id: String) -> Schwingfest {
//		schwingfests.first { $0.id == id }!
//	}
//	
//	private var schwingfestsFile: URL {
//		let fileManager = FileManager.default
//		let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//		return urls[0].appending(path: "schwingfests")
//	}
//}
