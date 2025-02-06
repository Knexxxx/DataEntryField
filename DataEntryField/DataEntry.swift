import SwiftUI

struct DataEntry: View {
    @Binding var dataEntryState: DataEntryStates
    @Bindable var database: DatabaseUserData
    // @State var vm = DataEntryViewModel()
    // The editing view model (still injected via the environment).
    // The external database model that holds the saved text.
    
    @State private var isVisible = true // Toggle for blinking
    @State var cursorPos: Int = 0
    /// The key path to the property on DatabaseUserData that contains the saved text.
    let refKeyPath: ReferenceWritableKeyPath<DatabaseUserData, String>
    @State var drafttext: String = ""
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
        switch dataEntryState {
        case .UNUSED:    return .green
        case .EDIT:      return .red
        case .HIGHLIGHT: return .yellow
        }
    }
    
    func processKeyboard(key: String) {
        
        if key.count > 1
        {
            SpecialKey(key: key)
            return
        }
        if dataEntryState != .EDIT
        {
            drafttext = ""
            dataEntryState = .EDIT
        }
        if maxChars > drafttext.count
        {
            drafttext += key
            cursorPos += 1
        }
    }
    
        
    func SpecialKey(key: String) {
        guard dataEntryState != .UNUSED || key == "DEL" else { return }

        switch key {
        case "VALIDATE":
            print("VALIDATED")
            database.data = drafttext
            print("Saved to DatabaseUserData: \(drafttext)")
            dataEntryState = .UNUSED
            
        case "ESC":
            print("ESCAPED")
            drafttext = ""
            dataEntryState = .UNUSED
            
        case "+-":
            print("+-")
            if drafttext.hasSuffix("+") {
                drafttext.removeLast()
                cursorPos -= 1
                processKeyboard(key: "-")
            }
            else { processKeyboard(key: "+")}


        case "<-" where cursorPos > 0:
            cursorPos -= 1

        case "->" where cursorPos < drafttext.count:
            cursorPos += 1

        case "DEL":
            dataEntryState = .EDIT
            drafttext = ""
            cursorPos = 0

        default:
            break
        }
    }

        
        
        
        
        
        
    
    
    
    var body: some View {
        // Use @Bindable to automatically update when viewModel changes.
        HStack {
            ZStack(alignment: dataEntryState == .EDIT ? .leading : .center) {
                // Display content depending on the editing state.
                if dataEntryState == .UNUSED {
                    // Display the saved text from the database (via the key path).
                    Text(savedText)
                        .lineLimit(1)
                        .foregroundColor(.cyan)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .cornerRadius(2)
                } else if dataEntryState == .HIGHLIGHT {
                    Text(highlight(text: drafttext))
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .cornerRadius(2)
                } else if dataEntryState == .EDIT {
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
//                            vm.GetMaxChars(_maxchar: maxChars)
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
            .onReceive(KeyboardEventBus.shared.keyTapped) { key in
                processKeyboard(key:key) // Append received key
                print("Received key: \(key)")
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
//            vm.tapReceived()
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
