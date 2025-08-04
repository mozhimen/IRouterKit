//
//  NavigationHost.swift
//  IRouterKit.Navigation
//
//  Created by Taiyou on 2025/8/4.
//
import SwiftUI

// MARK: - 导航宿主视图 (兼容版本)
struct NavigationHost<D: NavigationDestination>: View {
    @ObservedObject var navigator: Navigator<D>
    
    // 条件编译的 bodyContent 实现
    private var bodyContent: some View {
        Group {
#if os(iOS)
            if #available(iOS 16.0, *) {
                NavigationStack(path: $navigator.navigationPath) {
                    EmptyView()
                        .navigationDestination(for: D.self) { destination in
                            destination.makeView()
                                .navigationHost(navigator: navigator)
                        }
                }
            } else {
                // iOS 13-15 回退实现
                NavigationView {
                    EmptyView()
                        .background(
                            NavigationLink(
                                destination: navigator.navigationPath.last?.makeView()
                                    .navigationHost(navigator: navigator),
                                isActive: Binding(
                                    get: { !navigator.navigationPath.isEmpty },
                                    set: { _ in navigator.pop() }
                                ),
                                label: { EmptyView() }
                            )
                        )
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
#else
            // macOS 实现
            NavigationView {
                EmptyView()
                    .background(
                        NavigationLink(
                            destination: coordinator.navigationPath.last?.makeView()
                                .navigationHost(coordinator: coordinator),
                            isActive: Binding(
                                get: { !coordinator.navigationPath.isEmpty },
                                set: { _ in coordinator.pop() }
                            ),
                            label: { EmptyView() }
                        )
                    )
            }
#endif
        }
    }
    
    //================================================================>
    
    var body: some View {
        Group {
            // Sheet/FulScreenCover处理
            bodyContent
                .sheet(item: $navigator.presentedItem) { destination in
                    if navigator.presentationType == .sheet {
                        destination.makeView()
                            .navigationHost(navigator: navigator)
                    }
                }
                .fullScreenCover(item: $navigator.presentedItem) { destination in
                    if navigator.presentationType == .fullScreenCover {
                        destination.makeView()
                            .navigationHost(navigator: navigator)
                    }
                }
        }
    }
}
