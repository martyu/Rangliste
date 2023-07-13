//
//  Schwingfest.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/19/23.
//

import Foundation
import SwiftUI
import WebKit

struct Schwingfest {
	let id: UUID
	let date: Date
	let location: String
	let ageGroups: [AgeGroup]
	let scoreCards: [ScoreCard]
}
