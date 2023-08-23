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
				opponentScorecard.availableRoundsForSchwinger.isEmpty == false
			}
	}

	var possibleOpponents: [Scorecard] {
		possibleOpponentScorecards.filter { $0.schwinger != schwinger }
	}

	var availableRoundsForSchwinger: [Int] {
		(1...7).filter { possibleRound in
			matches.map(\.round).contains(possibleRound) == false
		}
	}
	
	var availableRoundsForOpponents: [Scorecard: [Int]] {
		Dictionary(uniqueKeysWithValues: possibleOpponentScorecards.map { ($0, $0.availableRoundsForSchwinger) })
	}
}

struct AddMatchView: View {
	@EnvironmentObject var schwingfest: Schwingfest
	
	@Binding var shouldShow: Bool
	
	@State var opponent: Scorecard
	@State var resultOpponent: MatchResult
	@State var resultSchwinger: MatchResult
	@State var round: Int = 1
	
	let schwinger: Schwinger
	let possibleOpponents: [AgeGroup: [Scorecard]]
	let addMatch: (AddMatchView) -> ()
	let availableRoundsForSchwinger: [Int]
	let availableRoundsForOpponents: [Scorecard: [Int]]
	
	private var availableRounds: [Int] {
		Array(
			OrderedSet(
				availableRoundsForSchwinger
			).intersection(
				OrderedSet(
					availableRoundsForOpponents[opponent]!
				)
			)
		)
	}
		
	init(shouldShow: Binding<Bool>, scorecard: Scorecard, addMatch: @escaping (AddMatchView) -> ()) {
		_shouldShow = shouldShow
				
		self.addMatch = addMatch
		self.schwinger = scorecard.schwinger
		self.possibleOpponents = scorecard.possibleOpponentScorecards.filter { $0.schwinger != scorecard.schwinger }.schwingersGroupedByAgeGroup
		self.opponent = possibleOpponents.first!.value.first!
		self.resultOpponent = MatchResult()
		self.resultSchwinger = MatchResult()
		self.availableRoundsForOpponents = scorecard.availableRoundsForOpponents
		self.availableRoundsForSchwinger = scorecard.availableRoundsForSchwinger
	}
		
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Select Opponent")) {
					opponentPicker
				}
				
				Section(header: Text("Match Details")) {
					MatchResultView(matchResult: $resultSchwinger, title: "Result for \(schwinger.fullName)", extraRound: round == 7)
					MatchResultView(matchResult: $resultOpponent, title: "Result for \(opponent.schwinger.fullName)", extraRound: round == 7)
					roundPicker
				}
				
				Button(title) {
					addMatch(self)
					shouldShow = false
				}
			}
			.navigationTitle(title)
		}
		.task {
			round = availableRounds[0]
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
	
	@ViewBuilder
	private var opponentPicker: some View {
		OpponentPicker(opponentsByAgeGroup: possibleOpponents, selectedAgeGroup: opponent.ageGroup, selectedOpponent: $opponent)
	}
	
	private var title: String {
		"Add Match"
	}
}

struct OpponentPicker: View {
	let opponentsByAgeGroup: [AgeGroup: [Scorecard]]
	
	@State private var selectedAgeGroup: AgeGroup
	@Binding var selectedOpponent: Scorecard
	
	init(opponentsByAgeGroup: [AgeGroup : [Scorecard]], selectedAgeGroup: AgeGroup, selectedOpponent: Binding<Scorecard>) {
		self.opponentsByAgeGroup = opponentsByAgeGroup
		_selectedAgeGroup = State(initialValue: selectedAgeGroup)
		_selectedOpponent = selectedOpponent
	}
	
	var body: some View {
		Picker("Select Age Group", selection: $selectedAgeGroup) {
			ForEach(Array(opponentsByAgeGroup.keys), id: \.self) { ageGroup in
				Text(ageGroup.name).tag(ageGroup)
			}
		}
		
		if let opponents = opponentsByAgeGroup[selectedAgeGroup] {
			Picker("Select Opponent", selection: $selectedOpponent) {
				ForEach(opponents, id: \.self) { opponent in
					Text(opponent.schwinger.fullName).tag(opponent)
				}
			}
		}
	}
}

struct MatchResultView: View {
	@Binding var matchResult: MatchResult
	var title: String
	let extraRound: Bool
	
	var body: some View {
		VStack {
			Picker(title, selection: $matchResult.outcome) {
				ForEach(Outcome.allCases, id: \.self) { outcome in
					Text(outcome.rawValue.capitalized).tag(outcome)
				}
			}
			Stepper("Points: \(matchResult.points.pointsFormatted)", value: $matchResult.points, in: extraRound ? 0...0.25 : 8.5...10, step: 0.25)
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
