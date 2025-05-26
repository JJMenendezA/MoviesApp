//
//  VideoPlayer.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 12/01/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI
import WebKit

struct VideoPlayer: UIViewRepresentable {
    
    let videoURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let youTubeURL = videoURL
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youTubeURL))
    }
}
