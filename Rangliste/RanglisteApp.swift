//
//  RanglisteApp.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/19/23.
//

import SwiftUI

@main
struct RanglisteApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
//			RanglisteView(schwingfest: MockData.schwingfest)
			SchwingfestList()
				.textInputAutocapitalization(.words)
				.autocorrectionDisabled(true)
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

struct SchwingfestKey: EnvironmentKey {
	static var defaultValue: Schwingfest = fatalError() as! Schwingfest
}

extension EnvironmentValues {
	var schwingfest: Schwingfest {
		get { self[SchwingfestKey.self] }
		set { self[SchwingfestKey.self] = newValue }
	}
}
