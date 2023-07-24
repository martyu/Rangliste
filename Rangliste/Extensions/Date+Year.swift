//
//  Extensions.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/23/23.
//

import Foundation

extension Date {
	var year: String {
		String((Calendar.current.component(.year, from: self)))
	}
}
