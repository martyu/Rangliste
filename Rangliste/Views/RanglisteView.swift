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
	
	func sortedRankings(for scorecards: [Scorecard]) -> [[Scorecard]] {
		let sortedScorecards = scorecards.sorted(by: { $0.totalPoints > $1.totalPoints })
		var rankings: [[Scorecard]] = []
		var currentRank: [Scorecard] = []

		for index in 0..<sortedScorecards.count {
			if index == 0 || sortedScorecards[index].totalPoints == sortedScorecards[index - 1].totalPoints {
				// Continue the tie
				currentRank.append(sortedScorecards[index])
			} else {
				// Sort the ties using the tiebreaker closure
				currentRank.sort(by: tiebreaker)
				
				// Add the current rank array to rankings and start a new one
				rankings.append(currentRank)
				currentRank = [sortedScorecards[index]]
			}
		}
		
		// Handle the case where the array ends with a tie or a unique rank
		if !currentRank.isEmpty {
			// Sort the ties using the tiebreaker closure before adding
			currentRank.sort(by: tiebreaker)
			rankings.append(currentRank)
		}

		return rankings
	}

	func rankingsToStringMapped(from nestedRankings: [[Scorecard]]) -> [(ranking: String, scorecard: Scorecard)] {
		var result: [(ranking: String, scorecard: Scorecard)] = []
		var currentRank = 1

		for tiedRankings in nestedRankings {
			let count = tiedRankings.count

			if count == 1 {
				// No tie
				let ranking = "\(currentRank)"
				result.append((ranking, tiedRankings[0]))
			} else {
				// There is a tie
				for (index, scorecard) in tiedRankings.enumerated() {
					let suffix = String(UnicodeScalar(Int(UInt8(96)) + index + 1)!) // 'a', 'b', 'c', etc.
					let ranking = "\(currentRank)\(suffix)"
					result.append((ranking, scorecard))
				}
			}

			currentRank += 1
		}

		return result
	}
	
	// Assuming that Scorecard has methods like numberOfWins(), numberOf10s(), numberOfTies(), and countOfWinsAgainst(_:)
	func tiebreaker(_ a: Scorecard, _ b: Scorecard) -> Bool {
		// Count how many times 'a' has beaten 'b' and vice versa
		let winsOfAOverB = a.numberOfWins(against: b)
		let winsOfBOverA = b.numberOfWins(against: a)

		if winsOfAOverB != winsOfBOverA {
			return winsOfAOverB > winsOfBOverA
		}

		// Check the total number of wins
		let winsA = a.wins.count
		let winsB = b.wins.count
		if winsA != winsB {
			return winsA > winsB
		}

		// Check the number of 10s
		let tensA = a.tens.count
		let tensB = b.tens.count
		if tensA != tensB {
			return tensA > tensB
		}

		// Check the number of ties
		let tiesA = a.ties.count
		let tiesB = b.ties.count
		return tiesA > tiesB
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
			let stringMappedRankings = rankingsToStringMapped(from: sortedRankings(for: scorecards))

			html += "<h2>\(ageGroup.name)</h2>"
			for ranking in stringMappedRankings {
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
			let rankings = rankingsToStringMapped(from: sortedScorecards)
			
			// Loop over the scorecards to create the table rows
			for (ranking, scoreCard) in rankings {
				html += """
 <tr>
 <td>\(ranking)</td>
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
