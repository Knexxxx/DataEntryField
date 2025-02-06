import SwiftUI

struct DataEntry: View {
    @Environment(ViewModelDataEntry.self) var viewModel
    @State private var isVisible = true // Toggle for blinking
    @Binding var cursorPos: Int
    @Binding var drafttext: String
    let maxChars: Int
    @Binding var savedtext: String
    @Binding var dataEntryState: DataEntryStates
    @State private var blinkingTask: Task<Void, Never>? // Store the blinking task
    
    
    var strokeColor: Color {
        switch dataEntryState {
        case .UNUSED:
            return .green
        case .EDIT:
            return .red
        case .HIGHLIGHT:
            return .yellow
        }
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: dataEntryState == .EDIT ? .leading : .center) {
                // Background and state-dependent text
                if dataEntryState == .UNUSED {
                    Text(savedtext)
                        .lineLimit(1) // Prevents line wrapping
                        .foregroundColor(.cyan) // Text color
                        .frame(maxWidth: .infinity, alignment: .center) // Centered text
//                        .background(Color.green.opacity(0.3)) // Outer background
                        .cornerRadius(2)
                } else if dataEntryState == .HIGHLIGHT {
                    Text(highlight(text: drafttext))
                        .lineLimit(1) // Prevents line wrapping
                        .foregroundColor(.black) // Text color
                        .frame(maxWidth: .infinity, alignment: .center) // Align text to the left
                    //                        .background(Color.cyan)
                        .cornerRadius(2)
                } else if dataEntryState == .EDIT {
                    Text(drafttext)
                        .lineLimit(1) // Prevents line wrapping
                        .frame(maxWidth: .infinity, alignment: .leading) // Align cursor text to the left
                        .foregroundColor(.red) // Text color
                    Text(draftWithCursor(exp: drafttext, cursorPos: cursorPos, isVisible: isVisible))
                        .lineLimit(1) // Prevents line wrapping
                        .frame(maxWidth: .infinity, alignment: .leading) // Align cursor text to the left
                        .onAppear {
                            cursorPos = drafttext.count
                            print("enabling blinking task at \(cursorPos)")
                            viewModel.GetMaxChars(_maxchar: maxChars)
                            // Cancel any existing blinking task
                            blinkingTask?.cancel()
                            // Start a new blinking task
                            blinkingTask = Task {
                                while !Task.isCancelled {
                                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.8 seconds
                                    await MainActor.run {
                                        isVisible.toggle()
                                    }
                                }
                            }
                            
                        }
                        .onDisappear {
                            print("canceling blinking task")
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


func draftWithCursor(exp: String, cursorPos: Int, isVisible: Bool) -> AttributedString {
    // Validate the cursor position
    guard cursorPos >= 0 && cursorPos <= exp.count else {
        print("warning: cursor out of bounds")
        return AttributedString(exp) // Return original string if out of bounds
    }
    // Create attributed string components
    var beforeCursor = AttributedString(String(exp.prefix(cursorPos)))
    beforeCursor.foregroundColor = .cyan
    beforeCursor.foregroundColor = .clear
//    var afterCursor = AttributedString(String(exp.suffix(exp.count - cursorPos)))
//    afterCursor.foregroundColor = .cyan
    
    // Create the cursor part
    var cursor = AttributedString(isVisible ? "▌" : " ")
    cursor.foregroundColor = Color.cyan.opacity(0.5)
    
    // Combine all parts
    var result = beforeCursor
    result += cursor
//    result += afterCursor
    
    return result
}


private func highlight(text: String) -> AttributedString {
    var attributedString = AttributedString(text.isEmpty ? "   " : text)
    attributedString.foregroundColor = .black  // Set text color to black
    attributedString.backgroundColor = .cyan   // Set background color to cyan
    return attributedString
}

// MARK: - Preview
struct DataEntry_Previews: PreviewProvider {
    @State private static var viewModel = ViewModelDataEntry()
    @State private static var draftText = "DraftText"
    @State private static var savedText = "SavedText"
    @State private static var state = DataEntryStates.UNUSED
    
    static var previews: some View {
        DataEntry(
            cursorPos: $viewModel.cursorPos,
            drafttext: $draftText,
            maxChars: 20,
            savedtext: $savedText,
            dataEntryState: $state
        )
        .environment(viewModel)
    }
}
