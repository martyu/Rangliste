//
//  AddSchwingfestView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/22/23.
//

import SwiftUI

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

struct AddSchwingfestView: View {
	@State var schwingfestName: SchwingfestName = .frances
	@State var date: Date = Date()
	
	let addSchwingfest: (Schwingfest?) -> ()
	
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
			}
			.padding()
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						addSchwingfest(Schwingfest(date: date, location: schwingfestName.rawValue, ageGroups: [], scoreCards: []))
					} label: {
						Text("Done")
					}
				}
				ToolbarItem(placement: .topBarLeading) {
					Button {
						addSchwingfest(nil)
					} label: {
						Text("Cancel")
					}
				}
			}
		}
	}
}

#Preview {
	AddSchwingfestView(schwingfestName: .frances, addSchwingfest: { _ in })
}