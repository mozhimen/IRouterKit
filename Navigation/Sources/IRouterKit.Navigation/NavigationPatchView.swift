//
//  NavigationHost.swift
//  IRouterKit.Navigation
//
//  Created by Taiyou on 2025/8/4.
//
import SwiftUI

// MARK: - 导航宿主视图 (兼容版本)
struct NavigationPatchView<D: PNavigationDestination>: View {
    @ObservedObject var navigator: Navigator<D>
    
    // 条件编译的 bodyContent 实现
    private var bodyContent: some View {
        Group {
#if os(iOS)
            if #available(iOS 16.0, *) {
                Color.clear // 比 EmptyView 更可靠的占位视图
                    .frame(width: 1, height: 1)
                    .navigationDestination(for: D.self) { destination in
                        destination.makeView()
                            .modifierNavigation(navigator: navigator)
                    }
            } else {
                Color.clear
                    .frame(width: 1, height: 1)
                    .background(
                        NavigationLink(
                            destination: navigator.navigationPath.last?.makeView()
                                .modifierNavigation(navigator: navigator),
                            isActive: Binding(
                                get: { !navigator.isRoot() },
                                set: { isActive in
                                    if !isActive && !navigator.isRoot() {
                                        navigator.pop()
                                    }
                                }
                            ),
                            label: { EmptyView() }
                        )
                    )
            }
#else
            // macOS 实现
            Color.clear
                .frame(width: 1, height: 1)
                .background(
                    NavigationLink(
                        destination: navigator.navigationPath.last?.makeView()
                            .modifierNavigation(navigator: navigator),
                        isActive: Binding(
                            get: { !navigator.isRoot() },
                            set: { isActive in
                                if !isActive && !navigator.isRoot() {
                                    navigator.pop()
                                }
                            }
                        ),
                        label: { EmptyView() }
                    )
                )
            
#endif
        }
    }
    
    //================================================================>
    
    var body: some View {
        Group {
            // Sheet/FulScreenCover处理
#if os(iOS)
            bodyContent
                .sheet(item: $navigator.presentedItem) { destination in
                    if navigator.presentationType == .sheet {
                        destination.makeView()
                            .modifierNavigation(navigator: navigator)
                            .onDisappear {
                                if navigator.presentedItem == destination {
                                    navigator.dismiss()
                                }
                            }
                    }
                }
                .fullScreenCover(item: $navigator.presentedItem) { destination in
                    if navigator.presentationType == .fullScreenCover {
                        destination.makeView()
                            .modifierNavigation(navigator: navigator)
                            .onDisappear {
                                if navigator.presentedItem == destination {
                                    navigator.dismiss()
                                }
                            }
                    }
                }
#else
            bodyContent
                .sheet(item: $navigator.presentedItem) { destination in
                    if navigator.presentationType == .sheet {
                        destination.makeView()
                            .modifierNavigation(navigator: navigator)
                            .onDisappear {
                                if navigator.presentedItem == destination {
                                    navigator.dismiss()
                                }
                            }
                    }
                }
#endif
        }
    }
}
