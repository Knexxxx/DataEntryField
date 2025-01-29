import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        VStack{
            DataEntry(cursorPos: $viewModel.cursorPos,drafttext: $viewModel.drafttext,maxChars:10, savedtext: $viewModel.data,dataEntryState: $viewModel.dataEntryState)
            HStack{
                Button(action: {
                    viewModel.Keyreceived(key: "<-")
                }) {
                    Image(systemName: "arrowshape.left.fill") // Use SF Symbol
                        .font(.largeTitle)       // Adjust font size
                        .foregroundColor(.blue)  // Change color
                }
                
                Button(action: {
                    viewModel.Keyreceived(key: "->")
                }) {
                    Image(systemName: "arrowshape.right.fill") // Use SF Symbol
                        .font(.largeTitle)       // Adjust font size
                        .foregroundColor(.blue)  // Change color
                }
                
                Button(action: {
                    viewModel.Keyreceived(key: "DEL")

//                    viewModel.drafttext = String(viewModel.drafttext.dropLast())
                    
                }) {
                    Image(systemName: "delete.backward.fill") // Use SF Symbol
                        .font(.largeTitle)       // Adjust font size
                        .foregroundColor(.blue)  // Change color
                }
                
                Button("VALIDATE", action: {
                    viewModel.Keyreceived(key: "VALIDATE")
                }
                )
                Button("ESC", action: {
                    viewModel.Keyreceived(key: "ESC")
                }
                )
            }
          
            
        }
        .padding()
        .environmentObject(viewModel)
        HStack{
            Button(action: {
                print("Button pressed")
                viewModel.Keyreceived(key: "A")
            }) {
                Image(systemName: "a.circle") // Use SF Symbol
                    .font(.largeTitle)       // Adjust font size
                    .foregroundColor(.blue)  // Change color
            }
            Button(action: {
                print("Button pressed")
                viewModel.Keyreceived(key: "B")

            }) {
                Image(systemName: "b.circle") // Use SF Symbol
                    .font(.largeTitle)       // Adjust font size
                    .foregroundColor(.blue)  // Change color
            }
            Button(action: {
                print("Button pressed")
                viewModel.Keyreceived(key: "C")

            }) {
                Image(systemName: "c.circle") // Use SF Symbol
                    .font(.largeTitle)       // Adjust font size
                    .foregroundColor(.blue)  // Change color
            }
            Button(action: {
                print("Button pressed")
                viewModel.Keyreceived(key: "1")

            }) {
                Image(systemName: "1.circle") // Use SF Symbol
                    .font(.largeTitle)       // Adjust font size
                    .foregroundColor(.blue)  // Change color
            }
        }
    }
}

#Preview {
    ContentView()
}



