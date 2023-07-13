//
//  WebView.swift
//  Rangliste
//
//  Created by Marty Ulrich on 6/21/23.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
	let htmlContent: String
	
	func makeUIView(context: Context) -> WKWebView {
		WKWebView()
	}
	
	func updateUIView(_ webView: WKWebView, context: Context) {
		webView.loadHTMLString(htmlContent, baseURL: nil)
	}
}
