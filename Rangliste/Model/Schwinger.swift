//
//  Schwinger.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation

struct Schwinger: Identifiable {
	let id: UUID
	var firstName: String
	var lastName: String
	var age: Int
	var ageGroup: AgeGroup?
}
