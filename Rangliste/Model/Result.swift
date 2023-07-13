//
//  Result.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation

enum Result {
	case win(points: Double)
	case tie(points: Double)
	case loss(points: Double)
	
	var points: Double {
		switch self {
		case .loss(let points):
			return points
		case .win(let points):
			return points
		case .tie(let points):
			return points
		}
	}
}

extension Result {
	static var random: Result {
		switch (0...2).randomElement()! {
		case 0:
			return .win(points: 9.75)
		case 1:
			return .tie(points: 9)
		case 2:
			return .loss(points: 8.75)
		default:
			fatalError()
		}
	}
}
