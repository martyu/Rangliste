//import SwiftUI
//
//class ProjectedMatch: Projection<Match> {
//	@Projected(\Match.schwinger1) var _schwinger1
//	@Projected(\Match.schwinger2) var _schwinger2
//	@Projected(\Match.resultSchwinger1) var _resultSchwinger1
//	@Projected(\Match.resultSchwinger2) var _resultSchwinger2
//	@Projected(\Match.round) var round
//	
//	var schwinger1: Schwinger {
//		get {
//			_schwinger1!
//		}
//		set {
//			_schwinger1 = newValue
//		}
//	}
//	
//	var schwinger2: Schwinger {
//		get {
//			_schwinger2!
//		}
//		set {
//			_schwinger2 = newValue
//		}
//	}
//	
//	var resultSchwinger1: MatchResult {
//		get {
//			_resultSchwinger1!
//		}
//		set {
//			_resultSchwinger1 = newValue
//		}
//	}
//	
//	var resultSchwinger2: MatchResult {
//		get {
//			_resultSchwinger2!
//		}
//		set {
//			_resultSchwinger2 = newValue
//		}
//	}
//}
//
//struct MatchView: View {
//	@Environment var schwingfest: Schwingfest
//	
//	@State private var showAlert = false
//	@State private var alertMessage = ""
//
//	@ObservedRealmObject var match: ProjectedMatch
//	
//	private var results = Outcome.allCases.map { "\($0)" }
//	private var schwingers: [Schwinger] {
//		schwingfest.scorecards.compactMap(\.schwinger)
//	}
//	
//	var body: some View {
//		NavigationView {
////			Form {
//				Picker("Schwingers", selection: $match.schwinger1) {
//					ForEach(schwingers) { schwinger in
//						Text(schwinger.fullName).tag(schwinger)
//					}
//				}
//				Picker("", selection: $match.schwinger2) {
//					ForEach(schwingers) { schwinger in
//						Text(schwinger.fullName).tag(schwinger)
//					}
//				}
//			ResultPicker(result: $match.resultSchwinger1, schwingerName: match.schwinger1.fullName)
//			ResultPicker(result: $match.resultSchwinger2, schwingerName: match.schwinger2.fullName)
//				TextField("Round", value: $match.round, formatter: NumberFormatter())
//					.keyboardType(.numberPad)
////			}
//			.navigationBarTitle("Match Details")
//			.alert(isPresented: $showAlert, content: { alertView })
//		}
//	}
//	
//	private func handleRoundChange() {
//		let existingRounds = schwingfest.scorecards.map { $0.matches.map { $0.round } }.flatMap { $0 }
//		if existingRounds.contains(match.round) {
//			alertMessage = "This round already exists for this Schwinger."
//			showAlert = true
//		}
//	}
//	
//	var alertView: Alert {
//		Alert(
//			title: Text("Invalid Input"),
//			message: Text(alertMessage),
//			dismissButton: .default(Text("OK"))
//		)
//	}
//}
//
//struct MatchView_Previews: PreviewProvider {
//    static var previews: some View {
//		let match = Binding<Match>(get: {
//			MockData.schwingfest.scorecards[0].matches[0]
//		}, set: { match in
//			MockData.schwingfest.scorecards[0].matches[0] = match
//		})
//		MatchView(match: match)
//    }
//}
