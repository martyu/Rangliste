//
//  Schwingfest.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/19/23.
//

import Foundation
import RealmSwift

public class Schwingfest: Object, ObjectKeyIdentifiable {
	@Persisted public var date: Date
	@Persisted public var location: String
	@Persisted public var ageGroups: List<AgeGroup>
	@Persisted public var scorecards: List<Scorecard>
}
