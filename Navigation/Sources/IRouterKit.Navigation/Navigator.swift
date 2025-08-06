//
//  RouterKViewModel.swift
//  IRouterKit.Basic
//
//  Created by Taiyou on 2025/8/4.
//
import SwiftUI
// MARK: - 导航协调器
@MainActor
public final class Navigator<D: PNavigationDestination>: ObservableObject {
    
    // 当前导航栈
    @Published public var navigationPath = [D]()
    
    // 当前展示的sheet/fullScreenCover
    @Published public var presentedItem: D?
    @Published public var presentationType: NavigationType = .push
    // 中间件
    public var middleware: ((D) -> Bool)?
    
    //=====================================================>
    
    // 防抖控制
    private var lastNavigationTime = Date.distantPast
    private var debounceInterval: TimeInterval = 0.5
    
    //=====================================================>
    
    public init(debounceInterval: TimeInterval = 0.5) {
        self.debounceInterval = debounceInterval
    }
    
    //=====================================================>
    
    // 导航方法
    public func navigate(to destination: D, type: NavigationType = .push) {
        // 防抖检查
        guard Date().timeIntervalSince(lastNavigationTime) > debounceInterval else {
            print("navigate: 防抖检查")
            return }
        lastNavigationTime = Date()
        
        // 中间件拦截
        if let middleware = middleware, !middleware(destination) {
            print("navigate: 中间件拦截")
            return
        }
        
        // 执行导航
        DispatchQueue.main.async {
            switch type {
            case .push:
                self.navigationPath.append(destination)
                print("navigate: .push (\(self.navigationPath)")
            case .sheet, .fullScreenCover:
                print("navigate: .sheet, .fullScreenCover")
                self.presentedItem = destination
                self.presentationType = type
            }
        }
    }
    
    public func isRoot() -> Bool {
        navigationPath.isEmpty
    }
    
    // 返回方法
    public func pop() {
        if !isRoot() {
            print("pop")
            navigationPath.removeLast()
        }
    }
    
    // 返回到根视图
    public func popToRoot() {
        navigationPath.removeAll()
    }
    
    // 关闭sheet/fullScreenCover
    public func dismiss() {
        presentedItem = nil
    }
}
