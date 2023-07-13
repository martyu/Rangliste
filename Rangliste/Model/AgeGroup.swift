//
//  AgeGroup.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation

struct AgeGroup {
	let id: UUID
	let name: String
	let ages: ClosedRange<Int>
}