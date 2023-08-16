//
//  RanglisteApp.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/19/23.
//

import SwiftUI

@main
struct RanglisteApp: App {
    var body: some Scene {
        WindowGroup {
//			RanglisteView(schwingfest: MockData.schwingfest)
			SchwingfestList()
        }
    }
}

//struct SchwingfestKey: EnvironmentKey {
//	static var defaultValue: Schwingfest = MockData.schwingfest
//}
//
//extension EnvironmentValues {
//	var schwingfest: Schwingfest {
//		get { self[SchwingfestKey.self] }
//		set { self[SchwingfestKey.self] = newValue }
//	}
//}

struct SchwingfestIDKey: EnvironmentKey {
	static var defaultValue: String = ""
}

extension EnvironmentValues {
	var schwingfestID: String {
		get { self[SchwingfestIDKey.self] }
		set { self[SchwingfestIDKey.self] = newValue }
	}
}
