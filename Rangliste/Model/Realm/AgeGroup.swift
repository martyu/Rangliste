//
//  AgeGroup.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation
import RealmSwift

public class AgeGroup: Object {
	@Persisted public var name: String?
	@Persisted public var minAge: Int?
	@Persisted public var maxAge: Int?
}
