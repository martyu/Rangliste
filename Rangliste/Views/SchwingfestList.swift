//
//  SchwingfestList.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/21/23.
//

import SwiftUI

struct SchwingfestList: View {
	@State private var schwingfests: [Schwingfest] = MockData.schwingfests
	@State private var isShowingSheet = false
	@State private var newSchwingfestName: SchwingfestName = .frances
	private var newSchwingfest: Schwingfest {
		Schwingfest(date: Date(), location: newSchwingfestName.rawValue, ageGroups: [], scoreCards: [])
	}
	
	var body: some View {
		NavigationView {
			VStack {
				List(groupedByYear(schwingfests), id: \.year) { yearGroup in
					yearSection(for: yearGroup)
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					addButton
				}
			}
		}
		.navigationTitle("Schwingfests")
		.sheet(isPresented: $isShowingSheet) {
			AddSchwingfestView {
				$0.flatMap {
					schwingfests.append($0)
				}
				isShowingSheet = false
			}
		}
	}
	
	@ViewBuilder
	private func yearSection(for group: YearGroup) -> some View {
		Section(header: Text("\(group.year)".replacingOccurrences(of: ",", with: ""))) {
			ForEach(group.schwingfests) { schwingfest in
				schwingfestCell(schwingfest)
			}
		}
	}
	
	@ViewBuilder
	private func schwingfestCell(_ schwingfest: Schwingfest) -> some View {
		NavigationLink {
			SchwingfestView(schwingfest: schwingfest)
		} label: {
			HStack {
				Text(schwingfest.location)
				Spacer()
				Text("\(schwingfest.date, formatter: dateFormatter)")
			}
		}
	}
	
	@ViewBuilder
	private var addButton: some View {
		Button {
			isShowingSheet = true
		} label: {
			Image(systemName: "plus")
		}
	}
	
	func groupedByYear(_ schwingfests: [Schwingfest]) -> [YearGroup] {
		let grouped = Dictionary(grouping: schwingfests) { Calendar.current.component(.year, from: $0.date) }
		return grouped.map { YearGroup(year: $0.key, schwingfests: $0.value) }.sorted { $0.year > $1.year }
	}
}

extension Schwingfest: Identifiable {
	var id: String { "\(date)\(location)" }
}

struct YearGroup {
	let year: Int
	let schwingfests: [Schwingfest]
}

let dateFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .medium
	formatter.timeStyle = .none
	return formatter
}()

#Preview {
	NavigationView {
		SchwingfestList()
	}
}
