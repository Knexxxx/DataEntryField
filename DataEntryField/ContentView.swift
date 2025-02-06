import SwiftUI
import Combine




struct ContentView: View {
    @State private var database = DatabaseUserData()
    @State var location:CGPoint = CGPoint(x:0.35, y:0.14)
    @State var opacity:CGFloat = 0
    @State var scale:CGFloat = 1.0
    @State var dataEntryState: DataEntryStates = .UNUSED
    var body: some View {
        
        let locationConverterProxy = Binding<CGPoint>(
            get: {
                return CGPoint(x: self.opacity, y:self.scale)
            },
            set: {
                let value = $0
                self.opacity = value.x
                self.scale = value.y
            })
        
        
        
        ZStack{
            GeometryReader { geometry in
                Image(systemName: "dot.scope").resizable().frame(width: 40.0+(35.0*scale), height: 40.0+(35.0*scale)).opacity(0.6+(Double(opacity)*0.3)).position(convertLocation(geometry.size.width, geometry.size.height))
                    .foregroundColor(Color.red.opacity(dataEntryState == .UNUSED ? 0.6+(Double(opacity)*0.3) : 0.0))
            }
            .zIndex(10)
            
            VStack
            {
                
                DataEntry(dataEntryState:$dataEntryState,database:database,refKeyPath:\DatabaseUserData.data,maxChars:10)
                HStack{
                    
                    Button("VALIDATE", action: {
                        KeyboardEventBus.shared.keyTapped.send("VALIDATE")
                    }
                    )
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.green, lineWidth: 2)
                    )
                    
                    Button("ESC", action: {
                        KeyboardEventBus.shared.keyTapped.send("ESC")
                    }
                    )
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.red, lineWidth: 2)
                    )
                }
                
                HStack{

                Button(action: {
                    KeyboardEventBus.shared.keyTapped.send("<-")
                }) {
                    Image(systemName: "arrowshape.left.fill") // Use SF Symbol
                        .font(.largeTitle)       // Adjust font size
                        .foregroundColor(.blue)  // Change color
                }
                
                Button(action: {
                    KeyboardEventBus.shared.keyTapped.send("->")
                }) {
                    Image(systemName: "arrowshape.right.fill") // Use SF Symbol
                        .font(.largeTitle)       // Adjust font size
                        .foregroundColor(.blue)  // Change color
                }
                
                Button(action: {
                    KeyboardEventBus.shared.keyTapped.send("DEL")

                    //                    viewModel.drafttext = String(viewModel.drafttext.dropLast())
                    
                }) {
                    Image(systemName: "delete.backward.fill") // Use SF Symbol
                        .font(.largeTitle)       // Adjust font size
                        .foregroundColor(.blue)  // Change color
                }
                
            }
                
                
                HStack{
                    Button(action: {
                        KeyboardEventBus.shared.keyTapped.send("A")
                    }) {
                        Image(systemName: "a.circle") // Use SF Symbol
                            .font(.largeTitle)       // Adjust font size
                            .foregroundColor(.blue)  // Change color
                    }
                    Button(action: {
                        KeyboardEventBus.shared.keyTapped.send("B")

                    }) {
                        Image(systemName: "b.circle") // Use SF Symbol
                            .font(.largeTitle)       // Adjust font size
                            .foregroundColor(.blue)  // Change color
                    }
                    Button(action: {
                        KeyboardEventBus.shared.keyTapped.send("C")

                    }) {
                        Image(systemName: "c.circle") // Use SF Symbol
                            .font(.largeTitle)       // Adjust font size
                            .foregroundColor(.blue)  // Change color
                    }
                    Button(action: {
                        print("Button pressed")
                        KeyboardEventBus.shared.keyTapped.send("1")

                    }) {
                        Image(systemName: "1.circle") // Use SF Symbol
                            .font(.largeTitle)       // Adjust font size
                            .foregroundColor(.blue)  // Change color
                    }
                    Button(action: {
                        print("Button pressed")
                        KeyboardEventBus.shared.keyTapped.send("+-")

                    }) {
                        Image(systemName: "plusminus.circle") // Use SF Symbol
                            .font(.largeTitle)       // Adjust font size
                            .foregroundColor(.blue)  // Change color
                    }
                }
                Spacer()
                    .frame(height:60)
                TrackpadView(location:$location).padding(10).foregroundColor(.gray)
                    .frame(width:350,height:150)
                Text("Drag to move pointer")
                    .padding(.top, -20)

            Divider()
                    .frame(height:10)

                
                TrackpadView(location:locationConverterProxy).padding(10).foregroundColor(.gray.opacity(0.4))
                    .frame(width:150,height:80)
                
                Text("Drag to set pointer size & opacity")
                    .padding(.top, -20)

                Text("PointerPos: x:\(Int(location.x * 100))% , y:\(Int(location.y * 100))%")
                //        Text("x: \(convertLocation(geometry.size.width, geometry.size.height).x)")
                
            }
        }
        .padding()
    }
    
    
    func convertLocation(_ width: CGFloat, _ height: CGFloat) -> CGPoint{
        
        return CGPoint(x: (width/2.0 + ((width/2.0)*location.x)), y: (height/2.0 + ((height/2.0)*location.y)))
    }
    
    
    
}

#Preview {
    ContentView()
}



