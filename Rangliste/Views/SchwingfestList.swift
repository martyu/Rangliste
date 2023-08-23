//
//  SchwingfestList.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/21/23.
//

import SwiftUI

@MainActor
struct SchwingfestList: View {
	@StateObject private var schwingfestRepo = DataManager.shared
	
	@State private var isShowingSheet = false
	@State private var confirmDeleteIndexes: IndexSet?
	
	var body: some View {
		NavigationView {
			List {
				let groups = Dictionary(grouping: schwingfestRepo.schwingfests, by: { $0.year })
				let keys = Array(groups.keys).sorted()
				ForEach(keys, id: \.self) { year in
					yearSection(year: year, schwingfests: groups[year]!.sorted { $0.date < $1.date })
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
			AddSchwingfestView(shouldShow: $isShowingSheet)
		}
	}
	
	@ViewBuilder
	private func yearSection(year: Int, schwingfests: [Schwingfest]) -> some View {
		Section(header: Text("\(year)".replacingOccurrences(of: ",", with: ""))) {
			ForEach(schwingfests) { schwingfest in
				schwingfestCell(schwingfest)
			}
			.onDelete { indexSet in
//				confirmDeleteIndexes = indexSet
				for index in indexSet {
					schwingfestRepo.schwingfests.remove(schwingfests[index])
				}
			}
		}
//		.deleteConfirmation(isShowingDeleteConfirmation: isPresent($confirmDeleteIndexes)) {
//			for index in confirmDeleteIndexes! {
//				schwingfestRepo.schwingfests.remove(schwingfests[index])
//			}
//		}
	}
	
	@ViewBuilder
	private func schwingfestCell(_ schwingfest: Schwingfest) -> some View {
		NavigationLink {
			SchwingfestView()
				.environmentObject(schwingfest)
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
}

extension Schwingfest {
	var year: Int { Calendar.current.component(.year, from: date) }
}

extension Schwingfest: Identifiable {
	var id: String {
		"\(date)-\(location)"
	}
}

let dateFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .medium
	formatter.timeStyle = .none
	return formatter
}()

struct SchwingfestList_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			SchwingfestList()
		}
	}
}
