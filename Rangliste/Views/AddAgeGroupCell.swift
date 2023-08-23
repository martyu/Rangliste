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
				ageGroups.append(AgeGroup(name: ageGroupName.isEmpty ? nil : ageGroupName, ages: ages!))
				newAgeGroupOldest = ""
				newAgeGroupYoungest = ""
				ageGroupName = ""
			}
			.buttonStyle(BorderedButtonStyle())
			.disabled(newAgeGroupOldest.isEmpty || newAgeGroupYoungest.isEmpty || (ages.flatMap { intersectsRange(x: $0, y: ageGroups.map(\.ages)) } ?? true) == true )
		}
		.minimumScaleFactor(0.5)
		.keyboardType(.numberPad)
	}
	
	private var ages: ClosedRange<Int>? {
		guard
			let newAgeGroupYoungest = Int(newAgeGroupYoungest),
			let newAgeGroupOldest = Int(newAgeGroupOldest),
			newAgeGroupYoungest < newAgeGroupOldest
		else {
			return nil
		}
		
		return newAgeGroupYoungest...newAgeGroupOldest
	}
}

func intersectsRange(x: ClosedRange<Int>, y: [ClosedRange<Int>]) -> Bool {
	return y.contains { $0.overlaps(x) }
}
