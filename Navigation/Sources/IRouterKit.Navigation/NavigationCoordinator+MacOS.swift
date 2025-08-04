//
//  NavigationCoordinator+MacOs.swift
//  IRouterKit.Navigation
//
//  Created by Taiyou on 2025/8/4.
//
import SwiftUI

extension Navigator {
    #if os(macOS)
    public func navigateOnMac(to destination: D) {
        // macOS 特定的导航逻辑
        if let window = NSApp.keyWindow {
            let hostingView = NSHostingView(
                rootView: destination.makeView()
                    .navigationHost(coordinator: self)
            )
            let newWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered,
                defer: false
            )
            newWindow.contentView = hostingView
            newWindow.makeKeyAndOrderFront(nil)
        }
    }
    #endif
}
