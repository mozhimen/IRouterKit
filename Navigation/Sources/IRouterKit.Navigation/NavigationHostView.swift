
import SwiftUI
import SUtilKit_SwiftUI
struct NavigationHostView<V:View,D: PNavigationDestination>:View {
    @EnvironmentObject var navigator: Navigator<D>
    var content: I_AListener<V>
    
    var body: some View {
        if !navigator.isRoot() {
            content()
        }else{
#if os(iOS)
            if #available(iOS 16.0, *) {
                NavigationStack(path: $navigator.navigationPath, root: {
                    content()
                })
            }else{
                ////                // iOS 13-15 回退实现
                NavigationView {
                    content()
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
#else
            // macOS 实现（建议使用 NavigationStack）
            NavigationView {
                content()
            }
#endif
        }
    }
}
