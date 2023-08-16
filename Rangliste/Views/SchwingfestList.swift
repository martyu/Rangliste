//
//  SchwingfestList.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/21/23.
//

import SwiftUI
import RealmSwift
import RealmModels

struct SchwingfestList: View {
	@ObservedSectionedResults(RealmModels.Schwingfest.self, sectionKeyPath: \.year) private var schwingfests
	@State private var isShowingSheet = false
	
	var body: some View {
		NavigationView {
			List {
				ForEach(schwingfests) { section in
					yearSection(for: section)
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
				$0.flatMap { newSchwingfest in
					let _ = Task {
						let realm = try! await Realm()
						realm.beginWrite()
						realm.add(newSchwingfest)
						try realm.commitWrite()
					}
				}
				isShowingSheet = false
			}
			
		}
	}
	
	@ViewBuilder
	private func yearSection(for group: ResultsSection<Int, Schwingfest>) -> some View {
		Section(header: Text("\(group.key)".replacingOccurrences(of: ",", with: ""))) {
			ForEach(group) { schwingfest in
				schwingfestCell(schwingfest)
			}
		}
	}
	
	@ViewBuilder
	private func schwingfestCell(_ schwingfest: Schwingfest) -> some View {
		NavigationLink {
			SchwingfestView(schwingfest: schwingfest)
//				.environmentObject(schwingfest)
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
