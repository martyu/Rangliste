//
//  NoteblatteView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/22/23.
//

import SwiftUI

struct NoteblatteView: View {
	@State var noteblatte: ScoreCard
	
    var body: some View {
		Text(noteblatte.schwinger.lastName)
    }
}

#Preview {
	NoteblatteView(noteblatte: MockData.scoreCards.first!)
}
