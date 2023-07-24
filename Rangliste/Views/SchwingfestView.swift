//
//  SchwingfestView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/22/23.
//

import SwiftUI

//TODO: add plus button in top right to add more schwingers

struct SchwingfestView: View {
	@State var schwingfest: Schwingfest
	
	var body: some View {
		List {
			ForEach(schwingfest.scoreCards) { scoreCard in
				NavigationLink {
					NoteblatteView(noteblatte: scoreCard)
				} label: {
					Text(scoreCard.schwinger.fullName)
						.frame(alignment: .leading)
					Spacer()
				}
			}
			.onDelete { indexSet in
				schwingfest.scoreCards.remove(atOffsets: indexSet)
			}
		}
		.navigationTitle("\(schwingfest.location) \(schwingfest.date.year)")
	}
}

#Preview {
	SchwingfestView(schwingfest: MockData.schwingfest)
}
