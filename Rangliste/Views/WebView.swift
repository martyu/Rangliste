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
	let title: String
	
	let sharePDFUpdated: (URL) -> ()
	
	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView()
		webView.navigationDelegate = context.coordinator
		return webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
		uiView.loadHTMLString(htmlContent, baseURL: nil)
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, WKNavigationDelegate {
		var parent: WebView
		
		init(_ parent: WebView) {
			self.parent = parent
		}
		
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			Task {
				try! await Task.sleep(nanoseconds: 1_000_000_000)
				let pdf = createHTML()
				parent.sharePDFUpdated(pdf)
			}
		}
		
		@MainActor
		func createPDF(webView: WKWebView, title: String) async -> URL {
			let pdfData = try! await webView.pdf()
			return writeToFile(data: pdfData, title: title, ext: "pdf")
		}
		
		func createHTML() -> URL {
			writeToFile(data: parent.htmlContent.data(using: .utf8)!, title: parent.title, ext: "html")
		}
		
		private func writeToFile(data: Data, title: String, ext: String) -> URL {
			let temporaryDirectoryURL = FileManager.default.temporaryDirectory
			let fileURL = temporaryDirectoryURL.appendingPathComponent("\(title).\(ext)")
			do {
				try data.write(to: fileURL)
			} catch {
				print("Failed to write PDF data to file: \(error)")
			}
			return fileURL
		}
	}
}

extension WKWebView {
	var contentSize: CGSize {
		return scrollView.contentSize
	}
}
