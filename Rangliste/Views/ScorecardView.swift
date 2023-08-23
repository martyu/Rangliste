//
//  ScorecardView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/22/23.
//

import SwiftUI

struct ScorecardView: View {
	@EnvironmentObject var schwingfest: Schwingfest
	
	@Binding var scorecard: Scorecard
	
	@State private var showAddMatch: Bool = false
				
	var body: some View {
		List {
			Section(header: Text("Schwinger")) {
				TextField("First", text: $scorecard.schwinger.firstName)
				TextField("Last", text: $scorecard.schwinger.lastName)
				Stepper("Age: \(scorecard.schwinger.age)", value: $scorecard.schwinger.age, in: 1...99)
				Picker("Age Group", selection: $scorecard.ageGroup) {
					ForEach(schwingfest.ageGroups, id: \.name) { ageGroup in
						Text(ageGroup.name).tag(ageGroup)
					}
				}
			}
			let resultsForSchwinger = scorecard.matches.map { $0.result(for: scorecard.schwinger) }
			Section(content: {
				if !resultsForSchwinger.isEmpty {
					ForEach($scorecard.matches, id: \.round) { $match in
						HStack {
							Text("\(match.round).  \(scorecard.opponent(for: match).fullName)")
								.truncationMode(.middle)
							Spacer()
							Text("\(match.result(for: scorecard.schwinger).outcomeSymbol) \(match.result(for: scorecard.schwinger).points.pointsFormatted)").monospacedDigit()
						}
					}
					.onDelete { matchIndexesToDelete in
						matchIndexesToDelete.forEach { DataManager.shared.removeMatch(scorecard.matches[$0]) }
						scorecard = scorecard
					}
				}
			}, header: {
				Text("Matches")
			}, footer: {
				HStack {
					Text("Total")
					Spacer()
					Text("\(resultsForSchwinger.map(\.points).reduce(0, +).pointsFormatted)").monospacedDigit().bold()
				}
			})
		}
		.navigationTitle(scorecard.schwinger.fullName)
		.minimumScaleFactor(0.5)
		.font(.system(size: 16))
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					showAddMatch = true
				} label: {
					Image(systemName: "plus")
				}
				.disabled(scorecard.availableRoundsForSchwinger.isEmpty)
			}
		}
		.sheet(isPresented: $showAddMatch) {
			AddMatchView(
				shouldShow: $showAddMatch,
				scorecard: scorecard) { addMatchView in
					DataManager.shared.addMatch(
						Match(
							schwingfest: schwingfest.id,
							round: addMatchView.round,
							schwinger1: addMatchView.schwinger,
							schwinger2: addMatchView.opponent.schwinger,
							resultSchwinger1: addMatchView.resultSchwinger,
							resultSchwinger2: addMatchView.resultOpponent
						)
					)
				}
		}
	}
}

//struct ScorecardView_Previews: PreviewProvider {
//	static var previews: some View {
//		ScorecardViewPreview()
//	}
//}
//
//private struct ScorecardViewPreview: View {
//	@StateObject var scorecard: Scorecard
//
//	var body: some View {
//		NavigationView {
//			ScorecardView(scorecard: Binding(get: {
//				DataManager.shared.schwingfests.first!.scorecards.first!
//			}, set: { newValue in
//				DataManager.shared.schwingfests.first!.scorecards.removeAll { $0.schwingfest == newValue.schwingfest && $0.schwinger == newValue.schwinger }
//				scorecard = newValue
//			}
//				.environmentObject(DataManager.shared.schwingfest(withID: DataManager.shared.schwingfests.first!.id))
//		}
//	}
//}
