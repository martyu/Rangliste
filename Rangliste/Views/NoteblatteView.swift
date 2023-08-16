////
////  NoteblatteView.swift
////  Rangliste
////
////  Created by Marty Ulrich on 7/22/23.
////
//
//import SwiftUI
//import RealmModels
//
//struct NoteblatteView: View {
//	@Binding var scoreCard: ScoreCard
//	@Environment var schwingfest: Schwingfest
//	
//	var body: some View {
//		List {
//			Section(header: Text("Schwinger")) {
//				TextField("First", text: $scoreCard.schwinger.firstName)
//				TextField("Last", text: $scoreCard.schwinger.lastName)
//				TextField("Age", value: $scoreCard.schwinger.age, formatter: NumberFormatter())
//				Picker("Age Group", selection: $scoreCard.ageGroup) {
//					ForEach(schwingfest.ageGroups, id: \.name) { ageGroup in
//						Text(ageGroup.name).tag(ageGroup)
//					}
//				}
//			}
//			
//			Section(header: Text("Matches")) {
////				let resultsForSchwinger = scoreCard.matches.map { $0.result(for: scoreCard.schwinger) }
////				ForEach($scoreCard.matches, id: \.round) { match in
////					HStack {
////						Text("\(match.round): \(match.schwinger2.fullName)")
////							.truncationMode(.middle)
////						Spacer()
////						if let result = resultsForSchwinger[match.round-1] {
////							ResultPicker(schwingerName: match.schwinger2.firstName) {
////
////							}
////							Text("\(result.outcomeSymbol) \(result.points.pointsFormatted)").monospacedDigit()
////						}
////					}
////				}
//				HStack {
//					Text("Total")
//					Spacer()
////					Text("\(resultsForSchwinger.compactMap(\.?.points).reduce(0, +).pointsFormatted)").monospacedDigit().bold()
//				}
//			}
//		}
//		.navigationTitle("Score Card")
//	}
//}
//
////struct NoteblatteView_Previews: PreviewProvider {
////	static var previews: some View {
////		let binding: Binding<ScoreCard> = Binding<ScoreCard>(get: {
////			MockData.schwingfest.scoreCards.first!
////		}, set: { scoreCard, _ in
////			MockData.schwingfest.scoreCards[0] = scoreCard
////		})
////		
////		NoteblatteView(scoreCard: binding)
////			.environmentObject(MockData.schwingfest)
////	}
////}
