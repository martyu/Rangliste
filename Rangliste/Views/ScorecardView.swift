//
//  ScorecardView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/22/23.
//

import SwiftUI
import RealmModels
import RealmSwift

class MatchProjection: Projection<Match> {
	@Projected(\Match.resultSchwinger1) var _resultSchwinger1
	
	var resultSchwinger1: MatchResult {
		get {
			_resultSchwinger1!
		}
		set {
			_resultSchwinger1 = newValue
		}
	}

}

class ScorecardProjection: Projection<Scorecard> {
	@Projected(\Scorecard.schwinger?.firstName) var _firstName
	@Projected(\Scorecard.schwinger?.lastName) var _lastName
	@Projected(\Scorecard.schwinger?.age) var _age
	@Projected(\Scorecard.ageGroup) var ageGroup
	@Projected(\Scorecard.schwinger) var _schwinger
	@Projected(\Scorecard.matches) var matches

	var firstName: String {
		get {
			_firstName!
		}
		set {
			_firstName = newValue
		}
	}
	
	var lastName: String {
		get {
			_lastName!
		}
		set {
			_lastName = newValue
		}
	}
	
	var age: Int {
		get {
			_age!
		}
		set {
			_age = newValue
		}
	}
	
	var schwinger: Schwinger {
		get {
			_schwinger!
		}
		set {
			_schwinger = newValue
		}
	}
}

struct ScorecardView: View {
	@ObservedRealmObject var scorecard: ScorecardProjection
//	@Environment var schwingfest: Schwingfest
	
	@State private var resultSchwinger2: MatchResult
	
	init(scorecard: ScorecardProjection, resultSchwinger2: MatchResult) {
		self.scorecard = scorecard
		self.resultSchwinger2 = resultSchwinger2
	}
	
	var body: some View {
//		List {
//			Section(header: Text("Schwinger")) {
//				TextField("First", text: $scorecard.firstName)
//				TextField("Last", text: $scorecard.lastName)
//				TextField("Age", value: $scorecard.age, formatter: NumberFormatter())
//				Picker("Age Group", selection: $scorecard.ageGroup) {
//					ForEach(schwingfest.ageGroups, id: \.name) { ageGroup in
//						Text(ageGroup.name).tag(ageGroup)
//					}
//				}
//			}
//			
			Section(header: Text("Matches")) {
				let resultsForSchwinger = scorecard.matches.map { $0.result(for: scorecard.schwinger) }
				List($scorecard.matches, id: \.round) { $match in
					HStack {
						Text("\(match.round ?? 0): \(match.schwinger2?.fullName ?? "none")")
							.truncationMode(.middle)
						Spacer()
						if let result = resultsForSchwinger[match.round ?? 1 - 1] {
							ResultPicker(result: $resultSchwinger2, schwingerName: match.schwinger2!.fullName)
							Text("\(result.outcomeSymbol) \(result.points.pointsFormatted)").monospacedDigit()
						}
					}
				}
				HStack {
					Text("Total")
					Spacer()
					Text("\(resultsForSchwinger.compactMap(\.?.points).reduce(0, +).pointsFormatted)").monospacedDigit().bold()
				}
			}
//		}
//		.navigationTitle("Score Card")
	}
}

//struct ScorecardView_Previews: PreviewProvider {
//	static var previews: some View {
//		let binding: Binding<Scorecard> = Binding<Scorecard>(get: {
//			MockData.schwingfest.scorecards.first!
//		}, set: { scorecard, _ in
//			MockData.schwingfest.scorecards[0] = scorecard
//		})
//
//		ScorecardView(scorecard: binding)
//			.environmentObject(MockData.schwingfest)
//	}
//}
