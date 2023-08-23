//
//  ResultPicker.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/21/23.
//

import SwiftUI

struct ResultPicker: View {
	@Binding var result: MatchResult
	
	static var points: [Double] { [8.5, 8.75, 9, 9.25, 9.5, 9.75, 10] }
	
	var body: some View {
		HStack(spacing: 16) {
			Menu {
				Picker("", selection: $result.outcome) {
					ForEach(Outcome.allCases) { outcome in
						Text(outcome.rawValue).tag(outcome)
					}
				}
			} label: {
				Text(result.outcome.rawValue)
			}
			Menu {
				Picker("", selection: $result.points) {
					ForEach(Self.points) { point in
						Text("\(point.pointsFormatted)").tag(point)
					}
				}
			} label: {
				Text(result.points.pointsFormatted)
			}
		}
	}
}

extension Double: Identifiable {
	public var id: String {
		"\(self)"
	}
}

private struct ResultPickerPreview: View {
	@State var result = MatchResult(outcome: .loss, points: 9)
	
	var body: some View {
		ResultPicker(result: $result)
	}
}

struct ResultPicker_Previews: PreviewProvider {
	static var previews: some View {
		ResultPickerPreview()
	}
}
