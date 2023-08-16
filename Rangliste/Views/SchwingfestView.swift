//
//  SchwingfestView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/22/23.
//

import SwiftUI
import RealmModels

//TODO: add plus button in top right to add more schwingers

struct SchwingfestView: View {
	var schwingfest: Schwingfest
	
	var body: some View {
		List {
			ForEach(.constant(schwingfest.scorecards)) { scoreCard in
//				NavigationLink {
//					NoteblatteView(scoreCard: scoreCard)
//						.environmentObject(schwingfest)
//				} label: {
//					Text(scoreCard.schwinger.wrappedValue.fullName)
//						.frame(alignment: .leading)
//					Spacer()
//				}
			}
			.onDelete { indexSet in
//				schwingfest.scoreCards.remove(atOffsets: indexSet)
			}
		}
		.navigationTitle("\(schwingfest.location) \(schwingfest.date.year)")
	}
}

//struct SchwingfestView_Previews: PreviewProvider {
//	static var previews: some View {
//		SchwingfestView()
//			.environmentObject(MockData.schwingfest)
//	}
//}
