//
//  RanglisteView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import SwiftUI

enum RanglisteType {
	case detailed
	case simple
}

struct RanglisteView: View {
	let schwingfest: Schwingfest
	
	let ranglisteType: RanglisteType
	
	@State var shareUrl: URL?
	
	var body: some View {
		let html: String
		switch ranglisteType {
		case .detailed:
			html = generateDetailedHTML()
		case .simple:
			html = generateSimpleHTML()
		}
		
		return VStack {
			ShareLink("Share", item: shareUrl ?? URL(string: "http://google.com")!).disabled(shareUrl == nil)
				.padding()
			WebView(htmlContent: html, title: schwingfest.displayTitle) { pdfUrl in
				shareUrl = pdfUrl
			}
		}
	}
	
	func sortedRankings(for scorecards: [Scorecard]) -> [(ranking: String, scorecard: Scorecard)] {
		let sortedScorecards = scorecards.sorted(by: { $0.totalPoints > $1.totalPoints })
		var rankings: [(ranking: String, scorecard: Scorecard)] = []
		var currentRank = 1
		var tieStartIndex: Int? = nil // Store the index where the tie starts

		for index in 0..<sortedScorecards.count {
			if index > 0 && sortedScorecards[index].totalPoints == sortedScorecards[index - 1].totalPoints {
				if tieStartIndex == nil {
					tieStartIndex = index - 1
				}
			} else {
				if let tieStart = tieStartIndex {
					// Update the rankings from tieStart to index-1
					for tieIndex in tieStart..<index {
						let suffix = String(UnicodeScalar(Int(UInt8(96)) + tieIndex - tieStart + 1)!)
						rankings[tieIndex].ranking = "\(currentRank)\(suffix)"
					}
					currentRank += 1
					tieStartIndex = nil
				} else if index > 0 {
					currentRank += 1
				}
			}
			
			let ranking = "\(currentRank)"
			rankings.append((ranking, scorecard: sortedScorecards[index]))
		}

		// Handle the case where the array ends with a tie
		if let tieStart = tieStartIndex {
			for tieIndex in tieStart..<rankings.count {
				let suffix = String(UnicodeScalar(Int(UInt8(96)) + tieIndex - tieStart + 1)!)
				rankings[tieIndex].ranking = "\(currentRank)\(suffix)"
			}
		}

		return rankings
	}

	func generateDetailedHTML() -> String {
		let groupedByAgeGroup = Dictionary(grouping: schwingfest.scorecards, by: { $0.ageGroup })
		let sortedAgeGroups = groupedByAgeGroup.keys.sorted(by: >)
		
		var html = """
  <style>
   .schwinger-container {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr; /* Three equal columns */
  gap: 16px;
   }
   .schwinger-item {
  padding: 8px;
   }
   .line {
  display: flex;
  justify-content: space-between;
   }
   .ranking, .outcome-symbol {
  margin-right: 16px;
  display: inline-block;
  width: 32px;
   }
   .top-line {
  font-weight: bold;
   }
   .line-separator {
  border-bottom: 1px solid #000;
  margin: 4px 0;
   }
   h1 {
  font-size: 32px; /* Not too big */
  text-align: center;
   }
   h2 {
  grid-column: 1 / 4; /* Span across all three columns */
   }
  </style>
  <h1>\(schwingfest.displayTitle)</h1> <!-- Title -->
  <div class="schwinger-container">
  """
		
		for ageGroup in sortedAgeGroups {
			let scorecards = groupedByAgeGroup[ageGroup]!.sorted(by: { $0.totalPoints > $1.totalPoints })
			let rankings = sortedRankings(for: scorecards)
			html += "<h2>\(ageGroup.name)</h2>"
			for ranking in rankings {
				let scorecard = ranking.scorecard
				html += """
 <div class="schwinger-item">
  <div class="line top-line">
   <div><span class="ranking">\(ranking.ranking)</span><span class="schwinger-name">\(scorecard.schwinger.fullName)</span></div>
   <span>\(scorecard.totalPoints.pointsFormatted)</span>
  </div>
  <div class="line-separator"></div>
 """
				
				for match in scorecard.matches {
					let matchResult = match.result(for: scorecard.schwinger)
					html += """
  <div class="line">
  <div><span class="outcome-symbol">\((matchResult.outcomeSymbol))</span><span>\(match.opponent(for: scorecard.schwinger).fullName)</span></div>
   <span>\(matchResult.points.pointsFormatted)</span>
  </div>
  """
				}
				
				html += "</div>"
			}
		}
		
		html += "</div>"
		
		return html
	}
	
	func generateSimpleHTML() -> String {
		var html =
 """
 <!DOCTYPE html>
 <html>
 <head>
 <style>
 /* styles */
 th, td {
 text-align: left;
 padding: 0 15px; /* This adds padding to the left and right of each cell */
 }
 </style>
 </head>
 <body>
 
 <h1>\(schwingfest.displayTitle)</h1>
 """
		
		// Loop over the age groups
		for ageGroup in schwingfest.ageGroups.reversed() {
			html += "<h2>\(ageGroup.name)</h2>"
			
			// Start of table for this age group
			html += """
 <table>
 <tr>
 </tr>
 """
			
			// Get the scorecards for this age group and sort them by points
			let scorecardsForGroup = schwingfest.scorecards.filter { $0.ageGroup.ages == ageGroup.ages }
			let sortedScorecards = sortedRankings(for: scorecardsForGroup)
			
			// Loop over the scorecards to create the table rows
			for (index, scoreCard) in sortedScorecards {
				html += """
 <tr>
 <td>\(index)</td>
 <td>\(scoreCard.schwinger.fullName)</td>
 <td>\(scoreCard.schwingerClub)</td>
 <td>\(scoreCard.winLossTieString)</td>
 <td>\(scoreCard.totalPoints.pointsFormatted)</td>
 </tr>
 """
			}
			// End of table for this age group
			html += "</table>"
		}
		
		// End of HTML document
		html += """
 </body>
 </html>
 """
		return html
	}
}

struct RanglisteView_Previews: PreviewProvider {
	static var previews: some View {
		RanglisteView(schwingfest: MockData().schwingfest, ranglisteType: .detailed)
			.previewDisplayName("Detailed")
		RanglisteView(schwingfest: MockData().schwingfest, ranglisteType: .simple)
			.previewDisplayName("Simple")
	}
}

private extension Schwingfest {
	var displayTitle: String {
		"\(location) \(date.year)"
	}
}
