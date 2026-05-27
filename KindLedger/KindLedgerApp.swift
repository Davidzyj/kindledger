import SwiftUI

@main
struct KindLedgerApp: App {
    @StateObject private var store = RecordStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}

private struct RootView: View {
    var body: some View {
        if let screen = ScreenshotConfig.screen {
            ScreenshotRootView(screen: screen)
                .environment(\.locale, ScreenshotConfig.locale)
        } else {
            ContentView()
        }
    }
}
