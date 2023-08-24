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
				let pdf = await createPDF(webView: webView, title: parent.title)
				parent.sharePDFUpdated(pdf)
			}
		}
		
		@MainActor
		func createPDF(webView: WKWebView, title: String) async -> URL {
//			let contentHeight = webView.scrollView.contentSize.height * 2
//			let pageWidth = webView.bounds.width
//			let pageHeight = webView.bounds.height
//			let totalPages = ceil(contentHeight / pageHeight)
//			
//			let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
//			let pdfData = pdfRenderer.pdfData { context in
//				for i in 0..<Int(totalPages) {
//					context.beginPage()
//					let yOffset = CGFloat(i) * pageHeight
//					webView.scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
//					webView.layer.render(in: context.cgContext)
//				}
//			}
			let pdfData = try! await webView.pdf()
			return writeToFile(pdfData: pdfData, title: title)
		}
		
		private func writeToFile(pdfData: Data, title: String) -> URL {
			let temporaryDirectoryURL = FileManager.default.temporaryDirectory
			let fileURL = temporaryDirectoryURL.appendingPathComponent("\(title).pdf")
			do {
				try pdfData.write(to: fileURL)
			} catch {
				print("Failed to write PDF data to file: \(error)")
			}
			return fileURL
		}
		
//		@MainActor
//		private func saveAsPDF(webView: WKWebView, title: String?) async -> URL {
//			let pdfConfiguration = WKPDFConfiguration()
//
//			/// Using `webView.scrollView.frame` allows us to capture the entire page, not just the visible portion
//			pdfConfiguration.rect = CGRect(x: 0, y: 0, width: webView.scrollView.contentSize.width, height: webView.scrollView.contentSize.height)
//
//			webView.(configuration: pdfConfiguration) { result in
//				switch result {
//				case .success(let data):
//					guard let downloadsDirectory = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
//						return
//					}
//
//					do {
//						let savePath = downloadsDirectory.appendingPathComponent(title ?? "PDF").appendingPathExtension("pdf")
//						try data.write(to: savePath)
//
//						print("Successfully created and saved PDF at \(savePath)")
//					} catch let error {
//						print("Could not save pdf due to \(error.localizedDescription)")
//					}
//
//				case .failure(let failure):
//					print(failure.localizedDescription)
//				}
//			}
//		}
	}
}

extension WKWebView {
	var contentSize: CGSize {
		return scrollView.contentSize
	}
}
