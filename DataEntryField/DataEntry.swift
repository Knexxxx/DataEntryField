import SwiftUI

struct DataEntry: View {
    @Bindable var database: DatabaseUserData
    // The editing view model (still injected via the environment).
    @Environment(DataEntryViewModel.self) var viewModel
    // The external database model that holds the saved text.
    
    @State private var isVisible = true // Toggle for blinking
    @Binding var cursorPos: Int
    /// The key path to the property on DatabaseUserData that contains the saved text.
    let refKeyPath: ReferenceWritableKeyPath<DatabaseUserData, String>
    @Binding var drafttext: String
    let maxChars: Int
    @State private var blinkingTask: Task<Void, Never>? // For managing the blinking animation
    
    /// Computes the saved text by reading from the databaseUserData using the provided key path.
    var savedText: String {
        database[keyPath: refKeyPath]
    }
    
    func updateDatabase(with newValue: String) {
        database[keyPath: refKeyPath] = newValue // Writes the value
    }
    
    var strokeColor: Color {
        switch viewModel.dataEntryState {
        case .UNUSED:    return .green
        case .EDIT:      return .red
        case .HIGHLIGHT: return .yellow
        }
    }
    
    var body: some View {
        // Use @Bindable to automatically update when viewModel changes.
        @Bindable var vm = viewModel
        HStack {
            ZStack(alignment: vm.dataEntryState == .EDIT ? .leading : .center) {
                // Display content depending on the editing state.
                if vm.dataEntryState == .UNUSED {
                    // Display the saved text from the database (via the key path).
                    Text(savedText)
                        .lineLimit(1)
                        .foregroundColor(.cyan)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .cornerRadius(2)
                } else if vm.dataEntryState == .HIGHLIGHT {
                    Text(highlight(text: drafttext))
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .cornerRadius(2)
                } else if vm.dataEntryState == .EDIT {
                    // Display the draft text and a blinking cursor.
                    Text(drafttext)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.red)
                    Text(draftWithCursor(exp: drafttext, cursorPos: cursorPos, isVisible: isVisible))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear {
                            cursorPos = drafttext.count
                            print("Enabling blinking task at \(cursorPos)")
                            viewModel.GetMaxChars(_maxchar: maxChars)
                            blinkingTask?.cancel() // Cancel any existing task.
                            blinkingTask = Task {
                                while !Task.isCancelled {
                                    try? await Task.sleep(nanoseconds: 500_000_000)
                                    await MainActor.run { isVisible.toggle() }
                                }
                            }
                        }
                        .onDisappear {
                            print("Canceling blinking task")
                            blinkingTask?.cancel()
                            blinkingTask = nil
                            isVisible = true
                        }
                }
            }
        }
        .frame(width: 150, height: 50)
        .background(Color.black)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(strokeColor, lineWidth: 2)
        )
        .onTapGesture {
            viewModel.tapReceived()
        }
    }
}

// MARK: - Helper Functions

func draftWithCursor(exp: String, cursorPos: Int, isVisible: Bool) -> AttributedString {
    guard cursorPos >= 0 && cursorPos <= exp.count else {
        print("Warning: cursor out of bounds")
        return AttributedString(exp)
    }
    var beforeCursor = AttributedString(String(exp.prefix(cursorPos)))
    // For demonstration, we set the text before the cursor to clear.
    beforeCursor.foregroundColor = .clear
    var cursor = AttributedString(isVisible ? "▌" : " ")
    cursor.foregroundColor = Color.cyan.opacity(0.5)
    var result = beforeCursor
    result += cursor
    return result
}

private func highlight(text: String) -> AttributedString {
    var attributedString = AttributedString(text.isEmpty ? "   " : text)
    attributedString.foregroundColor = .black
    attributedString.backgroundColor = .cyan
    return attributedString
}

// MARK: - Preview

//struct DataEntry_Previews: PreviewProvider {
//    @State private static var viewModel = DataEntryViewModel()
//    @State private static var drafttext = "Draft text"
//    @State private static var cursorPos = 0
//    @StateObject private static var databaseUserData = DatabaseUserData()
//    
//    static var previews: some View {
//        DataEntry(
//            cursorPos: $cursorPos,
//            refKeyPath: \DatabaseUserData.data,
//            drafttext: $drafttext,
//            maxChars: 20
//        )
//        .environment(viewModel)
//        .environmentObject(databaseUserData)
//        .padding()
//        .previewLayout(.sizeThatFits)
//    }
//}
