import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State var location:CGPoint = CGPoint(x:0, y:0)
    @State var opacity:CGFloat = 0
    @State var scale:CGFloat = 1.0
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
                Image(systemName: "dot.scope").resizable().frame(width: 20.0+(15.0*scale), height: 20.0+(15.0*scale)).opacity(0.6+(Double(opacity)*0.3)).position(convertLocation(geometry.size.width, geometry.size.height))
                    .foregroundColor(.red)
            }
            .zIndex(10)
            
            VStack
            {
                
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
                TrackpadView(location:$location).padding(10).foregroundColor(.gray)
                    .frame(width:70,height:70)
                
                TrackpadView(location:locationConverterProxy).padding(10).foregroundColor(.gray)
                    .frame(width:50,height:50)
                
                
                Text("x: \(location.x), y: \(location.y)")
                //        Text("x: \(convertLocation(geometry.size.width, geometry.size.height).x)")
                
            }
        }
        .padding()
        .environmentObject(viewModel)
    }
    
    
    func convertLocation(_ width: CGFloat, _ height: CGFloat) -> CGPoint{
        
        return CGPoint(x: (width/2.0 + ((width/2.0)*location.x)), y: (height/2.0 + ((height/2.0)*location.y)))
    }
    
    
    
}

#Preview {
    ContentView()
}



