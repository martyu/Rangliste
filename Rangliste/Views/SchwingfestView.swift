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
		NavigationView {
			ScrollView {
				ForEach(schwingfest.scoreCards) { scoreCard in
					NavigationLink {
						NoteblatteView(noteblatte: scoreCard)
					} label: {
						Text("\(scoreCard.schwinger.firstName) \(scoreCard.schwinger.lastName)")
							.frame(alignment: .leading)
						Spacer()
					}
					.padding()
					Divider()
				}
			}
		}
	}
}

#Preview {
	SchwingfestView(schwingfest: MockData.schwingfest)
}
