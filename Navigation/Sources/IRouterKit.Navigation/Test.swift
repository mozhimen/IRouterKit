//
//  Test.swift
//  IRouterKit.Navigation
//
//  Created by Taiyou on 2025/8/4.
//
import SwiftUI


//@main
//struct MyApp: App {
//    @StateObject private var navigator = Navigator<AppDestination>(debounceInterval: 0.5)
//    
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .navigationHost(navigator: navigator)
//                .environmentObject(navigator)
//        }
//    }
//}

struct ContentView: View {
    @EnvironmentObject var navigator: Navigator<AppDestination>
    private let sampleProduct = Product(id: "1", name: "示例产品")
    private let currentUser = User(id: "user1", name: "当前用户")
    
    var body: some View {
        VStack(spacing: 20) {
            // 普通导航按钮
            Button("查看产品详情") {
                navigator.navigate(to: .productDetail(sampleProduct))
            }
            
            // 带防抖的导航按钮
            Text("用户资料")
                .withDebouncedNavigation(to: .userProfile(currentUser), navigator: navigator, label: {
                    Text("用户资料")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
            
            // Sheet形式展示
            Button("设置") {
                navigator.navigate(to: .settings, type: .sheet)
            }
            
            // 测试返回按钮
            if !navigator.navigationPath.isEmpty {
                Button("返回") {
                    navigator.pop()
                }
            }
        }
        .padding()
    }
}

enum AppDestination: NavigationDestination {
    case productDetail(Product)
    case userProfile(User)
    case settings
    
    nonisolated var id: String {
        switch self {
        case .productDetail(let product): return "product-\(product.id)"
        case .userProfile(let user): return "user-\(user.id)"
        case .settings: return "settings"
        }
    }

    // 自定义 Hashable 实现
    nonisolated func hash(into hasher: inout Hasher) {
          switch self {
          case .productDetail(let product):
              hasher.combine("productDetail")
              hasher.combine(product.id)
          case .userProfile(let user):
              hasher.combine("userProfile")
              hasher.combine(user.id)
          case .settings:
              hasher.combine("settings")
          }
      }
    
    @ViewBuilder func makeView() -> some View {
        switch self {
        case .productDetail(let product):
            Text("1")
        case .userProfile(let user):
            Text("2")
        case .settings:
            Text("3")
        }
    }
    
    nonisolated static func == (lhs: AppDestination, rhs: AppDestination) -> Bool {
            switch (lhs, rhs) {
            case (.productDetail(let l), .productDetail(let r)):
                return l.id == r.id
            case (.userProfile(let l), .userProfile(let r)):
                return l.id == r.id
            case (.settings, .settings):
                return true
            default:
                return false
            }
        }
}

struct Product: Identifiable {
    let id: String
    let name: String
}

struct User: Identifiable {
    let id: String
    let name: String
}
