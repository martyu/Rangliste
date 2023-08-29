//
//  ClubPicker.swift
//  Rangliste
//
//  Created by Marty Ulrich on 8/29/23.
//

import Foundation
import SwiftUI

extension String {
	static var customClub: String { "Custom" }
}

struct ClubPicker: View {
	@State private var schwingerClub: String
	@State private var newSchwingerClub: String = ""
	
	private var selectedSchwingerClub: String {
		if schwingerClub == .customClub {
			return newSchwingerClub
		} else {
			return schwingerClub
		}
	}
	
	let allClubs: [String]
	let updateSchwingerClub: (String) -> ()
	
	init(allClubs: [String], selectedClub: String? = nil, updateSchwingerClub: @escaping (String) -> Void) {
		self.schwingerClub = selectedClub ?? allClubs.first ?? .customClub
		self.allClubs = allClubs
		self.updateSchwingerClub = updateSchwingerClub
	}
	
	var body: some View {
		HStack {
			Picker("Club", selection: $schwingerClub) {
				ForEach(allClubs + [.customClub], id: \.self) { club in
					Text(club).tag(club)
				}
			}
			if schwingerClub == .customClub {
				TextField("", text: $newSchwingerClub, prompt: Text("Club"))
			}
		}
		.onChange(of: schwingerClub) { newValue in
			updateSchwingerClub(selectedSchwingerClub)
		}
		.onChange(of: newSchwingerClub) { newValue in
			updateSchwingerClub(selectedSchwingerClub)
		}
	}
}

struct ClubPicker_Previews: PreviewProvider {
	static var previews: some View {
		ClubPicker(allClubs: [
			"Ripon, CA",
			"Tacoma, WA",
			"Frances, WA",
			"Truckee, CA"
		]) { newClub in
			print(newClub)
		}
	}
}
