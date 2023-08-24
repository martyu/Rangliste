//
//  RanglisteView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import SwiftUI

struct RanglisteView: View {
	let schwingfest: Schwingfest
	
	@State var shareUrl: URL?
	
	var body: some View {
		let html = generateHTML(for: schwingfest)
		
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
		var tieRank: Int? = nil
		var tieSuffix = 1

		for index in 0..<sortedScorecards.count {
			if index > 0 && sortedScorecards[index].totalPoints == sortedScorecards[index - 1].totalPoints {
				if tieRank == nil {
					tieRank = currentRank
				}
				tieSuffix += 1
			} else {
				tieRank = nil
				tieSuffix = 1
				if index > 0 {
					currentRank += 1
				}
			}

			let ranking: String
			if let tieRank = tieRank {
				let suffix = String(UnicodeScalar(Int(UInt8(96)) + tieSuffix)!)
				ranking = "\(tieRank)\(suffix)"
			} else {
				ranking = "\(currentRank)"
			}

			rankings.append((ranking, scorecard: sortedScorecards[index]))
		}

		return rankings
	}

	func generateHTML(for schwingfest: Schwingfest) -> String {
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
			html += "<h2>\(ageGroup.name)</h2>" // Age Group Heading in its own row
			for ranking in rankings {
				let scorecard = ranking.scorecard
				html += """
 <div class="schwinger-item">
  <div class="line top-line">
   <div><span class="ranking">\((ranking.ranking))</span><span class="schwinger-name">\((scorecard.schwinger.fullName))</span></div>
   <span>\(scorecard.totalPoints)</span>
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
}

struct RanglisteView_Previews: PreviewProvider {
	static var previews: some View {
		RanglisteView(schwingfest: MockData().schwingfest)
	}
}

private extension Schwingfest {
	var displayTitle: String {
		"\(location) \(date.year)"
	}
}
