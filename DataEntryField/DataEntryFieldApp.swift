import SwiftUI

@main
struct DataEntryFieldApp: App {
    @State private var viewModel = ViewModelDataEntry()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(viewModel)
    }

}

