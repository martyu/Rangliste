//
//  AddScorecardView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/16/23.
//

import SwiftUI
import OrderedCollections

struct AddScorecardView: View {
	@EnvironmentObject private var schwingfest: Schwingfest
	
	@State var firstName: String = ""
	@State var lastName: String = ""
	@State var age: String = ""
	@State var ageGroup: AgeGroup
	
	@Binding var shouldShow: Bool
			
    var body: some View {
		List {
			TextField("First Name", text: $firstName)
			TextField("Last Name", text: $lastName)
			TextField("Age", text: $age)
			Picker("Age Group", selection: $ageGroup, content: {
				ForEach(schwingfest.ageGroups, id: \.name) { ageGroup in
					Text(ageGroup.name).tag(ageGroup)
				}
			})
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Done") {
					let schwinger = Schwinger(firstName: firstName, lastName: lastName, age: Int(age)!)
					let scorecard = Scorecard(schwingfest: schwingfest.id, schwinger: schwinger, matches: [], ageGroup: ageGroup)
					schwingfest.scorecards.append(scorecard)
					shouldShow = false
				}
				.disabled(firstName.isEmpty || lastName.isEmpty || age.isEmpty || Int(age) == nil)
			}
		}
		.navigationTitle("Add Schwinger")
    }
}
//
//struct AddScorecardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddScorecardView()
//    }
//}
