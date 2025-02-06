import SwiftUI

@main
struct DataEntryFieldApp: App {
    @State private var viewModel = DataEntryViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(viewModel)

    }

}

