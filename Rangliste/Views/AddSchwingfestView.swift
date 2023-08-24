//
//  AddSchwingfestView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/22/23.
//

import SwiftUI
import OrderedCollections

enum SchwingfestName: String, CaseIterable {
	case tacomaSpring = "Tacoma Spring"
	case tacomaFall = "Tacoma Fall"
	case riponSpring = "Ripon Spring"
	case riponFall = "Ripon Fall"
	case newark = "Newark"
	case truckee = "Truckee"
	case portland = "Portland"
	case frances = "Frances"
	case sanDiego = "San Diego"
	case imperialValley = "Imperial Valley"
	case tillamook = "Tillamook"
}

@MainActor
struct AddSchwingfestView: View {
	@State private var schwingfestName: SchwingfestName = .frances
	@State private var date: Date = Date()
	@State private var ageGroups: [AgeGroup] = []
	@State private var newAgeGroupYoungest: String = ""
	@State private var newAgeGroupOldest: String = ""
	@State private var ageGroupName: String = ""
	
	@Binding var shouldShow: Bool
	
	init(shouldShow: Binding<Bool>) {
		_shouldShow = shouldShow
	}
	
	private let schwingfestRepo: any SchwingfestRepo = DataManager.shared
	
	var body: some View {
		NavigationView {
			VStack {
				HStack {
					Text("Location")
					Spacer()
					Picker(selection: $schwingfestName) {
						ForEach(SchwingfestName.allCases, id: \.rawValue) { name in
							Text(name.rawValue).tag(name)
						}
					} label: {
						Text("Name")
					}
				}
				
				DatePicker("Date", selection: $date, displayedComponents: .date)
				
				List {
					Section("Age Groups") {
						ForEach(ageGroups.sorted { $0.ages.lowerBound < $1.ages.lowerBound }, id: \.name) { group in
							Text(group.name).tag(group.name)
						}
						.onDelete {
							$0.forEach { ageGroups.remove(at: $0) }
						}
						AddAgeGroupCell(ageGroups: $ageGroups)
					}
				}
			}
			.padding()
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						let schwingfest = Schwingfest(date: date, location: schwingfestName.rawValue, ageGroups: ageGroups, scorecards: [])
						schwingfestRepo.saveSchwingfest(schwingfest)
						shouldShow = false
					} label: {
						Text("Save")
					}
					.disabled(
						ageGroups.isEmpty
					)
				}
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						shouldShow = false
					} label: {
						Text("Cancel")
					}
				}
			}
		}
	}
}

struct AddSchwingfestView_Previews: PreviewProvider {
	static var previews: some View {
		AddSchwingfestView(shouldShow: .constant(true))
	}
}
