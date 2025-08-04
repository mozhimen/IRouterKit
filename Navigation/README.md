
设计一个高度通用、可扩展的 SwiftUI 导航封装库，支持多种导航模式（push、sheet、fullScreenCover）、防抖处理、中间件拦截和深度链接。

使用示例

定义导航目标
```
enum AppDestination: NavigationDestination {
    case productDetail(Product)
    case userProfile(User)
    case settings
    
    var id: String {
        switch self {
        case .productDetail(let product): return "product-\(product.id)"
        case .userProfile(let user): return "user-\(user.id)"
        case .settings: return "settings"
        }
    }
    
    @ViewBuilder func makeView() -> some View {
        switch self {
        case .productDetail(let product):
            ProductDetailView(product: product)
        case .userProfile(let user):
            UserProfileView(user: user)
        case .settings:
            SettingsView()
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
```
在应用中使用
```
@main
struct MyApp: App {
    @StateObject private var navCoordinator = NavigationCoordinator<AppDestination>(debounceInterval: 0.5)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .navigationHost(coordinator: navCoordinator)
                .environmentObject(navCoordinator)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var navCoordinator: NavigationCoordinator<AppDestination>
    private let sampleProduct = Product(id: "1", name: "示例产品")
    private let currentUser = User(id: "user1", name: "当前用户")
    
    var body: some View {
        VStack(spacing: 20) {
            // 普通导航按钮
            Button("查看产品详情") {
                navCoordinator.navigate(to: .productDetail(sampleProduct))
            }
            
            // 带防抖的导航按钮
            Text("用户资料")
                .withDebouncedNavigation(
                    to: .userProfile(currentUser),
                    coordinator: navCoordinator
                ) {
                    Text("用户资料")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            
            // Sheet形式展示
            Button("设置") {
                navCoordinator.navigate(to: .settings, type: .sheet)
            }
            
            // 测试返回按钮
            if !navCoordinator.navigationPath.isEmpty {
                Button("返回") {
                    navCoordinator.pop()
                }
            }
        }
        .padding()
    }
}
```
添加中间件
```
// 在应用启动时配置
navCoordinator.middleware = { destination in
    switch destination {
    case .productDetail:
        print("正在导航到产品详情")
        return true
    case .userProfile:
        // 检查用户权限
        return User.isLoggedIn
    case .settings:
        return true
    }
}
```

高级功能扩展
深度链接支持
```
extension NavigationCoordinator {
    public func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        switch components.path {
        case "/product":
            if let id = components.queryItems?.first(where: { $0.name == "id" })?.value,
               let product = findProduct(by: id) {
                navigate(to: .productDetail(product))
            }
        case "/profile":
            navigate(to: .userProfile(currentUser))
        default:
            break
        }
    }
}
```
导航分析追踪
```
extension NavigationCoordinator {
    private func trackNavigation(to destination: Destination) {
        Analytics.track(event: "navigation", properties: [
            "destination": destination.id,
            "type": presentationType.rawValue
        ])
    }
    
    // 修改navigate方法，添加追踪
    public func navigate(to destination: Destination, type: NavigationType = .push) {
        // ...原有逻辑...
        trackNavigation(to: destination)
    }
}
```
自定义转场动画
```
extension NavigationCoordinator {
    public var transition: AnyTransition {
        switch presentationType {
        case .push: return .opacity
        case .sheet: return .slide
        case .fullScreenCover: return .identity
        }
    }
}

// 在makeView中使用
extension AppDestination {
    @ViewBuilder func makeView() -> some View {
        switch self {
        case .productDetail(let product):
            ProductDetailView(product: product)
                .transition(navCoordinator.transition)
        // ...其他case...
        }
    }
}
```
兼容性注意事项
NavigationView 限制:

iOS 13 的 NavigationView 只能处理单一层级导航

我们通过维护路径数组模拟多级导航

实际项目中可能需要根据需求调整导航逻辑

全屏覆盖:

iOS 13 没有 fullScreenCover，需要回退到全屏 sheet

可以通过条件编译处理不同平台差异

性能考虑:

iOS 13 的导航性能可能不如新版

对于复杂导航结构，建议合理组织视图层次

macOS 适配:

macOS 上的 NavigationView 表现与 iOS 不同

可能需要为 macOS 添加特定处理逻辑

***



***

库的优势
类型安全：使用泛型和关联类型确保导航目标类型安全

高度可扩展：支持添加新的导航类型和功能

集中管理：所有导航逻辑集中在协调器中

解耦设计：视图不需要知道导航的具体实现

功能丰富：内置防抖、中间件、深度链接等高级功能

SwiftUI原生集成：完全基于SwiftUI原生API构建

这个封装库可以作为一个独立的Swift包发布，通过SPM集成到项目中。它提供了企业级应用所需的完整导航解决方案，同时保持了SwiftUI声明式编程的优雅特性。
