//
//  ConfirmDeleteModifier.swift
//  Rangliste
//
//  Created by Marty Ulrich on 7/23/23.
//

import SwiftUI
import Combine

struct DeleteConfirmationModifier: ViewModifier {
	@Binding var isShowingDeleteConfirmation: Bool
	let onConfirm: () -> Void

	func body(content: Content) -> some View {
		content
			.actionSheet(isPresented: $isShowingDeleteConfirmation) {
				ActionSheet(title: Text("Delete Item"),
							message: Text("Are you sure you want to delete this item?"),
							buttons: [
								.destructive(Text("Delete"), action: onConfirm),
								.cancel()
							])
			}
	}
}

extension View {
	func deleteConfirmation(isShowingDeleteConfirmation: Binding<Bool>, onConfirm: @escaping () -> Void) -> some View {
		self.modifier(DeleteConfirmationModifier(isShowingDeleteConfirmation: isShowingDeleteConfirmation, onConfirm: onConfirm))
	}
}
