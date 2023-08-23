//
//  AgeGroup.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation
import RealmSwift

public class AgeGroup: EmbeddedObject {
	@Persisted public var minAge: Int?
	@Persisted public var maxAge: Int?
	public var name: String {
		guard let minAge, let maxAge else { return "" }
		return "\(minAge) - \(maxAge)"
	}
}
