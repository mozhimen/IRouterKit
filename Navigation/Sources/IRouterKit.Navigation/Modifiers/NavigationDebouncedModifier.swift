//
//  NavigationDebouncedModifier.swift
//  IRouterKit.Navigation
//
//  Created by Taiyou on 2025/8/5.
//
import SwiftUI
// MARK: - 防抖导航修饰符 (不变)
struct NavigationDebouncedModifier<D: PNavigationDestination>: ViewModifier {
    let destination: D
    let type: NavigationType
    @ObservedObject var navigator: Navigator<D>
    let debounceInterval: TimeInterval
    let label: () -> any View
    
    @State private var isEnabled = true
    
    //====================================================?
    
    func body(content: Content) -> some View {
        AnyView(label())
            .onTapGesture {
                guard isEnabled else { return }
                isEnabled = false
                
                navigator.navigate(to: destination, type: type)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval) {
                    isEnabled = true
                }
            }
            .disabled(!isEnabled)
    }
}
