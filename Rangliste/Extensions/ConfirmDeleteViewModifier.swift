////
////  ConfirmDeleteModifier.swift
////  Rangliste
////
////  Created by Marty Ulrich on 7/23/23.
////
//
//import SwiftUI
//import Combine
//
//struct ConfirmDeleteModifier: ViewModifier {
//	@Binding var items: [String]
//	@State var itemsToDelete: IndexSet?
//	@State private var showingDeleteAlert = false
//
//	func body(content: Content) -> some View {
//		content
//			.alert(isPresented: $showingDeleteAlert) {
//				Alert(title: Text("Are you sure you want to delete this?"),
//					  primaryButton: .destructive(Text("Delete")) {
//						if let set = itemsToDelete, let item = set.first {
//							items.remove(at: item)
//						}
//					  },
//					  secondaryButton: .cancel { }
//				)
//			}
//			.onChange(of: itemsToDelete) { value in
//				if value != nil {
//					showingDeleteAlert = true
//				}
//			}
//	}
//}
//
//extension View {
//	func confirmDelete(items: Binding<[String]>, itemsToDelete: IndexSet?, showingDeleteAlert: Bool) -> some View {
//		modifier(ConfirmDeleteModifier(items: items, itemsToDelete: itemsToDelete, showingDeleteAlert: showingdele))
//	}
//}
