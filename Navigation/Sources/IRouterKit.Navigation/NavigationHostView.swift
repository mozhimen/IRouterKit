
import SwiftUI
import SUtilKit_SwiftUI
public struct NavigationHostView<V:View,D: PNavigationDestination>:View {
    @EnvironmentObject var navigator: Navigator<D>
    public var _content: I_AListener<V>
    
    public init(@ViewBuilder content:@escaping I_AListener<V>) {
        self._content = content
    }
    
    public var body: some View {
#if os(iOS)
        if #available(iOS 16.0, *) {
            NavigationStack(path: $navigator.navigationPath,root: _content)
        }else{
            ////                // iOS 13-15 回退实现
            NavigationView(content: _content)
                .navigationViewStyle(StackNavigationViewStyle())
        }
#else
        // macOS 实现（建议使用 NavigationStack）
        NavigationView(content: _content)
#endif
    }
}
