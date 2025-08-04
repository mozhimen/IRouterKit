//
//  NavigationDestination.swift
//  IRouterKit.Basic
//
//  Created by Taiyou on 2025/8/4.
//
import SwiftUI

// MARK: - 导航动作协议
@MainActor
public protocol NavigationDestination:  Identifiable,Sendable,Hashable {
    associatedtype DestinationView: View
    @ViewBuilder func makeView() -> DestinationView
}
