//
//  Test.swift
//  IRouterKit.Navigation
//
//  Created by Taiyou on 2025/8/4.
//
import SwiftUI


#Preview {
    @Previewable @StateObject var navigator = Navigator<AppDestination>(debounceInterval: 0.5)
    //    ContentView()
    //        .modifierNavigation(navigator: navigator)
    //        .environmentObject(navigator)
    //    NavigationStackDemo()
    NavigationStackDemo5()
        .environmentObject(navigator)
        .modifierNavigation(navigator: navigator)
}

struct NavigationStackDemo: View {
    
    let colors: [Color] = [.red, .gray, .green, .orange, .pink, .brown, .cyan, .indigo, .purple, .yellow]
    
    var body: some View {
        NavigationStack {
            List(colors, id: \.self) { color in
                NavigationLink(value: color) {
                    Text("\(color.description.capitalized)")
                }
            }
            .listStyle(.plain)
            .navigationTitle("NavigationView")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Color.self) { color in
                ColorView(color: color)
            }
        }
    }
}

struct NavigationStackDemo2: View {
    @EnvironmentObject var navigator: Navigator<AppDestination>
    let colors: [Color] = [.red, .gray, .green, .orange, .pink, .brown, .cyan, .indigo, .purple, .yellow]
    
    var body: some View {
        NavigationStack {
            List(colors, id: \.self) { color in
                NavigationLink(value: AppDestination.color(color)) {
                    Text("\(color.description.capitalized)")
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: AppDestination.self) {
                $0.makeView()
            }
        }
    }
}

struct NavigationStackDemo3: View {
    @EnvironmentObject var navigator: Navigator<AppDestination>
    let colors: [Color] = [.red, .gray, .green, .orange, .pink, .brown, .cyan, .indigo, .purple, .yellow]
    
    var body: some View {
        List(colors, id: \.self) { color in
            Text("\(color.description.capitalized)")
                .onTapGesture(perform: {
                    navigator.navigate(to: .color(color))
                })
        }
        .listStyle(.plain)
    }
}

struct NavigationStackDemo4: View {
    @EnvironmentObject var navigator: Navigator<AppDestination>
    let colors: [Color] = [.red, .gray, .green, .orange, .pink, .brown, .cyan, .indigo, .purple, .yellow]
    let color:Color = .red
    
    var body: some View {
        NavigationStack(path: $navigator.navigationPath) {
            //        List(colors, id: \.self) { color in
            Text("\(color.description.capitalized)")
                .onTapGesture(perform: {
                    navigator.navigate(to: .color(color))
                })
                .background{
                    Color.clear
                        .navigationDestination(for: AppDestination.self, destination: { destination in
                            destination.makeView()
                        })
                        .frame(width: 0,height: 0)
                }
        }
        //        }
        //        .listStyle(.plain)
    }
}

struct NavigationStackDemo5: View {
    @EnvironmentObject var navigator: Navigator<AppDestination>
    let colors: [Color] = [.red, .gray, .green, .orange, .pink, .brown, .cyan, .indigo, .purple, .yellow]
    let color:Color = .red
    
    var body: some View {
        NavigationHostView<Text,AppDestination>(content: {
            //        NavigationStack.init(path: $navigator.navigationPath, root: {
                        //        List(colors, id: \.self) { color in
                        Text("\(color.description.capitalized)")
                            .onTapGesture(perform: {
                                navigator.navigate(to: .color(color))
                            }) as! Text
                    //        }
                    //        .listStyle(.plain)
            //        })
        })
    }
}

struct NavigationViewDemo: View {
    
    let colors: [Color] = [.red, .gray, .green, .orange, .pink, .brown, .cyan, .indigo, .purple, .yellow]
    
    var body: some View {
        NavigationView {
            List(colors, id: \.self) { color in
                NavigationLink {
                    ColorView(color: color)
                } label: {
                    Text("\(color.description.capitalized)")
                }
            }
            .listStyle(.plain)
            .navigationTitle("NavigationView")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ColorView: View {
    let color: Color
    @EnvironmentObject var navigator: Navigator<AppDestination>
    
    init(color: Color) {
        self.color = color
        print("new \(color.description)")
    }
    
    var body: some View {
        color
            .ignoresSafeArea()
        Text("Click")
            .onTapGesture(perform: {
                navigator.navigate(to: .settings)
            })
    }
}

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
                .modifierDebouncedNavigation(to: .userProfile(currentUser), navigator: navigator, label: {
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

enum AppDestination: PNavigationDestination {
    case productDetail(Product)
    case userProfile(User)
    case settings
    case color(Color)
    
    nonisolated var id: String {
        switch self {
        case .productDetail(let product): return "product-\(product.id)"
        case .userProfile(let user): return "user-\(user.id)"
        case .settings: return "settings"
        case .color(let color): return "color-\(color)"
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
        case .color:
            hasher.combine("color")
        }
    }
    
    @ViewBuilder func makeView() -> some View {
        switch self {
        case .color(let color):
            ColorView(color: color)
        case .productDetail(let product):
            Text("产品: \(product.name)")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow.opacity(0.3))
                .navigationTitle(product.name)
                .onAppear(perform: {
                    print("to 产品")
                })
            
        case .userProfile(let user):
            Text("用户: \(user.name)")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.3))
            
        case .settings:
            Text("设置页面")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green.opacity(0.3))
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
        case (.color(let l), .color(let r)):
            return l == r
        default:
            return false
        }
    }
}

struct Product: Identifiable,Sendable {
    let id: String
    let name: String
}

struct User: Identifiable,Sendable {
    let id: String
    let name: String
}
