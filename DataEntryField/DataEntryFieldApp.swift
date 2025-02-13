import SwiftUI

@main
struct DataEntryFieldApp: App {
    @State private var viewModel = DataEntryViewModel()
    @State private var vmUserData = DatabaseUserData()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(viewModel)
        .environment(vmUserData)

    }

}

