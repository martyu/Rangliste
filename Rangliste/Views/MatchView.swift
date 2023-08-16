//import SwiftUI
//import RealmModels
//
//struct MatchView: View {
//	init(match: Binding<Match>, results: [String] = Outcome.allCases.map { "\($0)" }) {
//		self._match = match
//		self.results = results
//	}
//	
//	@State private var showAlert = false
//	@State private var alertMessage = ""
//	
//	@Environment(\.schwingfestID) var schwingfestId
//	@Environment(\.managedObjectContext) var moc
//
//	@Binding var match: Match
//	private var schwingfest: Schwingfest { DataManager.shared.schwingfest(withID: schwingfestId) }
//	
//	private var results = Outcome.allCases.map { "\($0)" }
//	private var schwingers: [Schwinger] {
//		schwingfest.scoreCards.map(\.schwinger)
//	}
//	
//	var body: some View {
//		NavigationView {
//			Form {
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
//				ResultPicker(outcome: $match.resultSchwinger1.outcome, points: $match.resultSchwinger1.points, schwingerName: match.schwinger1.fullName)
//				ResultPicker(outcome: $match.resultSchwinger2.outcome, points: $match.resultSchwinger1.points, schwingerName: match.schwinger2.fullName)
//				TextField("Round", value: $match.round, formatter: NumberFormatter())
//					.keyboardType(.numberPad)
//			}
//			.navigationBarTitle("Match Details")
//			.alert(isPresented: $showAlert, content: { alertView })
//		}
//	}
//	
//	private func handleRoundChange() {
//		let existingRounds = schwingfest.scoreCards.map { $0.matches.map { $0.round } }.flatMap { $0 }
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
//			MockData.schwingfest.scoreCards[0].matches[0]
//		}, set: { match in
//			MockData.schwingfest.scoreCards[0].matches[0] = match
//		})
//		MatchView(match: match)
//    }
//}
//
//struct ResultPicker: View {
//	@Binding var outcome: Outcome
//	@Binding var points: Double
//	
//	static var points: [Double] { [8.5, 8.75, 9, 9.25, 9.5, 9.75, 10] }
//
//	var schwingerName: String
//	
//	var body: some View {
//		VStack {
//			Picker("\(schwingerName)", selection: $outcome) {
//				ForEach(Outcome.allCases) { outcome in
//					Text(outcome.rawValue).tag(outcome)
//				}
//			}
//			Picker("Points", selection: $points) {
//				ForEach(Self.points) { point in
//					Text("\(point.pointsFormatted)").tag(point)
//				}
//			}
//		}
//	}
//}
//
//extension Double: Identifiable {
//	public var id: String {
//		"\(self)"
//	}
//}
//
