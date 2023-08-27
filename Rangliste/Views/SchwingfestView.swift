//
//  SchwingfestView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/22/23.
//

import SwiftUI
import OrderedCollections

//TODO: add plus button in top right to add more schwingers


extension [Scorecard] {
	var schwingersGroupedByAgeGroup: [AgeGroup: [Scorecard]] {
		let keysAndValues = Dictionary(grouping: self) { $0.ageGroup }.sorted { $0.key < $1.key }
		return Dictionary(uniqueKeysWithValues: keysAndValues)
	}
}

struct SchwingfestView: View {
	@EnvironmentObject private var schwingfest: Schwingfest
	
	@State private var showSettings: Bool = false
	@State private var showAddScorecard: Bool = false
	@State private var showDetailedRangliste: Bool = false
	@State private var showSimpleRangliste: Bool = false

	var body: some View {
		let scorecardsByAgeGroup = Dictionary(grouping: $schwingfest.scorecards) { $0.wrappedValue.ageGroup.ages.lowerBound }.sorted { $0.key < $1.key }
		List {
			ForEach(scorecardsByAgeGroup, id: \.key) { ageGroup, scorecards in
				Section(schwingfest.scorecards.map(\.ageGroup).first { $0.ages.lowerBound == ageGroup }!.name) {
					ForEach(scorecards) { scorecard in
						makeScorecardCell(scorecard)
					}
				}
			}
			.onDelete { indexSet in
				DataManager.shared.removeScorecards(atOffsets: indexSet, forSchwingfest: schwingfest)
			}
			
			if schwingfest.scorecards.isEmpty == false {
				Button {
					showDetailedRangliste = true
				} label: {
					Text("Show Detailed Rangliste")
				}
				
				Button {
					showSimpleRangliste = true
				} label: {
					Text("Show Simple Rangliste")
				}
			}
		}
		.navigationTitle("\(schwingfest.location) \(schwingfest.date.year)")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					showAddScorecard = true
				} label: {
					Image(systemName: "plus")
				}
			}
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					showSettings = true
				} label: {
					Image(systemName: "gear")
				}
			}
		}
		.sheet(isPresented: $showSettings) {
			SchwingfestSettingsView(ageGroups: $schwingfest.ageGroups)
		}
		.sheet(isPresented: $showAddScorecard) {
			NavigationView {
				AddScorecardView(ageGroup: schwingfest.ageGroups.first!, shouldShow: $showAddScorecard)
					.environmentObject(schwingfest)
			}
		}
		.sheet(isPresented: $showDetailedRangliste) {
			RanglisteView(schwingfest: schwingfest, ranglisteType: .detailed)
				.onDisappear {
					showDetailedRangliste = false
				}
		}
		.sheet(isPresented: $showSimpleRangliste) {
			RanglisteView(schwingfest: schwingfest, ranglisteType: .simple)
				.onDisappear {
					showSimpleRangliste = false
				}
		}
	}

	@MainActor
	@ViewBuilder
	private func makeScorecardCell(_ scorecard: Binding<Scorecard>) -> some View {
		NavigationLink {
			ScorecardView(scorecard: scorecard)
				.environmentObject(schwingfest)
		} label: {
			Text(scorecard.schwinger.wrappedValue.fullName)
				.frame(alignment: .leading)
			Spacer()
		}
	}
}

@MainActor
struct SchwingfestSettingsView: View {
	@Binding var ageGroups: [AgeGroup]

	var body: some View {
		NavigationView {
			List {
				ForEach(ageGroups, id: \.name) { ageGroup in
					Text(ageGroup.name).tag(ageGroup)
				}
				.onDelete { indexSet in
					guard ageGroups.count > 1 else { return ageGroups = ageGroups }
					indexSet.forEach { ageGroups.remove(at: $0) }
				}
				
				AddAgeGroupCell(ageGroups: $ageGroups)
			}
			.navigationTitle("Age Groups")
		}
	}
}

struct SchwingfestView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			SchwingfestViewPreview()
		}
		.minimumScaleFactor(0.5)
	}
}

struct SchwingfestViewPreview: View {
	@State var schwingfest: Schwingfest = MockData().schwingfest
	
	var body: some View {
		SchwingfestView()
			.environmentObject(schwingfest)
	}
}
