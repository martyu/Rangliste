//
//  Schwinger.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation
import RealmSwift

public class Schwinger: Object, Identifiable {
	@Persisted(primaryKey: true) public var id = UUID()
	@Persisted public var firstName: String
	@Persisted public var lastName: String
	@Persisted public var age: Int
}
