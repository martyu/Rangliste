//
//  AddAgeGroupCell.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/21/23.
//

import SwiftUI
import OrderedCollections

struct AddAgeGroupCell: View {
	@State private var newAgeGroupYoungest: String = ""
	@State private var newAgeGroupOldest: String = ""
	@State private var ageGroupName: String = ""
	
	@Binding var ageGroups: [AgeGroup]

	var body: some View {
		HStack {
			TextField("", text: $newAgeGroupYoungest, prompt: Text("Youngest"))
			TextField("", text: $newAgeGroupOldest, prompt: Text("Oldest"))
			TextField("", text: $ageGroupName, prompt: Text("Name (optional)"))
			Button("Add") {
				ageGroups.append(AgeGroup(name: ageGroupName.isEmpty ? nil : ageGroupName, ages: Int(newAgeGroupYoungest)!...Int(newAgeGroupOldest)!))
				newAgeGroupOldest = ""
				newAgeGroupYoungest = ""
				ageGroupName = ""
			}
			.buttonStyle(BorderedButtonStyle())
			.disabled(newAgeGroupOldest.isEmpty || newAgeGroupYoungest.isEmpty)
		}
		.minimumScaleFactor(0.5)
		.keyboardType(.numberPad)
	}
}
