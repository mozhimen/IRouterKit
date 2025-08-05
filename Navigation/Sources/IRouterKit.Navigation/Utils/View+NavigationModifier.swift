//
//  View+Navigation.swift
//  IRouterKit.Navigation
//
//  Created by Taiyou on 2025/8/4.
//
import SwiftUI

// MARK: - 视图扩展
public extension View {
    /// 添加导航处理能力
    func modifierNavigation<D: PNavigationDestination>(
        navigator: Navigator<D>
    ) -> some View {
        self.modifier(
            NavigationModifier(
                navigator: navigator
            ))
    }
    
    /// 添加防抖点击导航
    func modifierDebouncedNavigation<V: View,D: PNavigationDestination>(
        to destination: D,
        type: NavigationType = .push,
        navigator: Navigator<D>,
        debounceInterval: TimeInterval = 0.5,
        @ViewBuilder label:@escaping () -> V
    ) ->some View {
        self.modifier(
            NavigationDebouncedModifier(
                destination: destination,
                type: type,
                navigator: navigator,
                debounceInterval: debounceInterval,
                label: label
            ))
    }
}
