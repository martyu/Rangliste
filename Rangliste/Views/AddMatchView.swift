//
//  AddMatchView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/21/23.
//

import SwiftUI
import OrderedCollections

extension Scorecard {
	var possibleOpponentScorecards: [Scorecard] {
		DataManager.shared
			.schwingfest(withID: schwingfest)
			.scorecards
			.filter { opponentScorecard in
				opponentScorecard.schwinger != schwinger &&
				
				//TODO: dont filter this, just show a nav view of all groups
				opponentScorecard.ageGroup == ageGroup &&
				opponentScorecard.availableRoundsForSchwinger.isEmpty == false
			}
	}

	var possibleOpponents: [Schwinger] {
		possibleOpponentScorecards.map(\.schwinger)
	}

	var availableRoundsForSchwinger: [Int] {
		(1...7).filter { possibleRound in
			matches.map(\.round).contains(possibleRound) == false
		}
	}
	
	var availableRoundsForOpponents: [Schwinger: [Int]] {
		Dictionary(uniqueKeysWithValues: possibleOpponentScorecards.map { ($0.schwinger, $0.availableRoundsForSchwinger) })
	}
}

struct AddMatchView: View {
	@Binding var shouldShow: Bool
	
	@State var opponent: Schwinger
	@State var resultOpponent: MatchResult
	@State var resultSchwinger: MatchResult
	@State var round: Int
	@State var roundIndex = 0 {
		didSet {
			round = availableRounds[roundIndex]
		}
	}
	
	let schwinger: Schwinger
	let possibleOpponents: [Schwinger]
	let isEdit: Bool
	let addMatch: (AddMatchView) -> ()
	let availableRoundsForSchwinger: [Int]
	let availableRoundsForOpponents: [Schwinger: [Int]]
	
	private var availableRounds: [Int] {
		Array(OrderedSet(availableRoundsForSchwinger).intersection(OrderedSet(availableRoundsForOpponents[opponent]!)))
	}
		
	init(shouldShow: Binding<Bool>, scorecard: Scorecard, match: Match? = nil, addMatch: @escaping (AddMatchView) -> ()) {
		_shouldShow = shouldShow
				
		self.addMatch = addMatch
		self.schwinger = scorecard.schwinger
		self.possibleOpponents = scorecard.possibleOpponents
		self.opponent = match.flatMap(scorecard.opponent) ?? possibleOpponents.first!
		self.resultOpponent = match.flatMap(scorecard.matchResult) ?? MatchResult()
		self.resultSchwinger = match?.result(for: scorecard.schwinger) ?? MatchResult()
		self.isEdit = match != nil
		self.round = match?.round ?? 1
		self.availableRoundsForOpponents = scorecard.availableRoundsForOpponents
		self.availableRoundsForSchwinger = scorecard.availableRoundsForSchwinger
		
		self.round = match?.round ?? availableRounds[0]
	}
		
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Select Opponent")) {
					Picker(opponent.fullName, selection: $opponent) {
						ForEach(possibleOpponents, id: \.id) { opponent in
							Text(opponent.fullName).tag(opponent)
						}
					}
				}
				
				Section(header: Text("Match Details")) {
					MatchResultView(matchResult: $resultSchwinger, title: "Result for \(schwinger.fullName)")
					MatchResultView(matchResult: $resultOpponent, title: "Result for \(opponent.fullName)")
					roundPicker
				}
				
				Button(title) {
					addMatch(self)
					shouldShow = false
				}
			}
			.navigationTitle(title)
		}
	}
	
	@ViewBuilder
	private var roundPicker: some View {
		VStack {
			Text("Round")
			Picker(selection: $round) {
				ForEach(availableRounds, id: \.self) { availableRound in
					Text("\(availableRound)")
				}
			} label: {
				Text("Round")
			}.pickerStyle(.segmented)
		}
	}
	
	private var title: String {
		isEdit ? "Edit Match" : "Add Match"
	}
}

struct MatchResultView: View {
	@Binding var matchResult: MatchResult
	var title: String
	let extraRound: Bool = false
	
	var body: some View {
		VStack {
			Picker(title, selection: $matchResult.outcome) {
				ForEach(Outcome.allCases, id: \.self) { outcome in
					Text(outcome.rawValue.capitalized).tag(outcome)
				}
			}
			Stepper("Points: \(matchResult.points.pointsFormatted)", value: $matchResult.points, in: 8.5...10, step: 0.25)
		}
	}
}

struct AddMatchView_Previews: PreviewProvider {
    static var previews: some View {
		let schwingfest = AddMatchViewPreview.schwingfest
		return AddMatchViewPreview()
			.environmentObject(schwingfest)
    }
}

private struct AddMatchViewPreview: View {
	@State var shouldShow: Bool = true
	@State var scorecard: Scorecard = Self.schwingfest.scorecards.first!
	static let schwingfest = MockData().schwingfest
	var body: some View {
		AddMatchView(
			shouldShow: .constant(true),
			scorecard: scorecard,
			addMatch: { _ in }
		)
	}
}
