//
//  RanglisteView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import SwiftUI

struct RanglisteView: View {
	let schwingfest: Schwingfest
	
	var body: some View {
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
 
 <h1>Rangliste</h1>
 """
		
		// Loop over the age groups
		for ageGroup in schwingfest.ageGroups.reversed() {
			html += "<h2>\(ageGroup.name)</h2>"
			
			// Start of table for this age group
			html += """
 <table>
 <tr>
 <th>Rank</th>
 <th>Name</th>
 <th>Results</th>
 <th>Total Points</th>
 </tr>
 """
			
			// Get the scorecards for this age group and sort them by points
			let scorecardsForGroup = schwingfest.scoreCards.filter { $0.ageGroup.id == ageGroup.id }
			let sortedScorecards = scorecardsForGroup.sorted { $0.totalPoints > $1.totalPoints }
			
			// Loop over the scorecards to create the table rows
			for (index, scoreCard) in sortedScorecards.enumerated() {
				html += """
 <tr>
 <td>\(index + 1)</td>
 <td>\(scoreCard.schwinger.firstName) \(scoreCard.schwinger.lastName)</td>
 <td>\(scoreCard.winLossTieString)</td>
 <td>\(scoreCard.totalPoints)</td>
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
		
		return WebView(htmlContent: html)
	}
}

struct RanglisteView_Previews: PreviewProvider {
	static var previews: some View {
		RanglisteView(schwingfest: MockData.schwingfest)
	}
}