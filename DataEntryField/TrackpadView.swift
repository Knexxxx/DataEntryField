
import SwiftUI
struct TrackpadView: View {
  @Binding var location:CGPoint
  var body: some View {
    GeometryReader { geometry in
   
      Rectangle().gesture(DragGesture().onChanged({ value in
        //next 7 lines convert the value passed in by the 
        //DragGuesture handler to a normalized value between
        //-1.0 and 1.0, so it is size independent
        let size = geometry.size
        let xDistance = value.location.x - (size.width/2.0)          
        let yDistance = value.location.y - (size.height/2.0)
        let normalizedX = xDistance / (size.width/2.0)
        let normalizedY = yDistance / (size.height/2.0)
        let clampedX = min(max(normalizedX, -1.0), 1.0)
        let clampedY = min(max(normalizedY, -1.0), 1.0)
        //next line applies the new location to the location
        //bound variable, no need for a delegate
        location = CGPoint(x: clampedX, y: clampedY)
      }))
    }
  }
}
struct TrackpadView_Previews: PreviewProvider {
  @State static var location:CGPoint = CGPoint()
  static var previews: some View {
    TrackpadView(location: $location)
  }
}
