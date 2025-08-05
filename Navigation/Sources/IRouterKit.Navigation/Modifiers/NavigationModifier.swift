//
//  NavigationHostModifier.swift
//  IRouterKit.Navigation
//
//  Created by Taiyou on 2025/8/4.
//
import SwiftUI

// MARK: - 导航宿主修饰符
struct NavigationModifier<D: PNavigationDestination>: ViewModifier {
    @ObservedObject var navigator: Navigator<D>
    
    func body(content: Content) -> some View {
        content.background(
            NavigationPatchView(navigator: navigator)
                .frame(width: 0, height: 0)
        )
    }
}
