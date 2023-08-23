//
//  Match.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation
import RealmSwift

public class Match: Object {
	@Persisted public var round: Int?
	@Persisted public var schwinger1: Schwinger?
	@Persisted public var schwinger2: Schwinger?
	@Persisted public var resultSchwinger1: MatchResult? = MatchResult()
	@Persisted public var resultSchwinger2: MatchResult? = MatchResult()
	@Persisted(originProperty: "matches") public var scorecard: LinkingObjects<Scorecard>
}

extension Match {
	public func result(for schwinger: Schwinger) -> MatchResult? {
		if schwinger1 == schwinger {
			return resultSchwinger1
		} else if schwinger2 == schwinger {
			return resultSchwinger2
		} else {
			fatalError()
		}
	}
}
