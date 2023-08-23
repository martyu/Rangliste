//
//  SchwingfestView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/22/23.
//

import SwiftUI
import OrderedCollections

//TODO: add plus button in top right to add more schwingers

struct SchwingfestView: View {
	@EnvironmentObject private var schwingfest: Schwingfest
	
	@State private var showSettings: Bool = false
	@State private var showAddScorecard: Bool = false

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
				schwingfest.scorecards.remove(atOffsets: indexSet)
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

//extension Binding where Value == OrderedSet<Scorecard> {
//	func toBindingArray() -> OrderedSet<Binding<Scorecard>> {
//		OrderedSet<Binding<Scorecard>>(self.wrappedValue.indices.map { index in
//			Binding<Scorecard>(
//				get: { self.wrappedValue[index] },
//				set: { newValue in
//					wrappedValue.update(newValue, at: index)
////					set.update(newValue, at: index)
////					self.wrappedValue = set
//				}
//			)
//		})
//	}
//}
//
//extension Binding: Hashable, Equatable where Value == Scorecard {
//	public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
//		lhs.wrappedValue == rhs.wrappedValue
//	}
//
//	public func hash(into hasher: inout Hasher) {
//		hasher.combine(wrappedValue.hashValue)
//	}
//}
