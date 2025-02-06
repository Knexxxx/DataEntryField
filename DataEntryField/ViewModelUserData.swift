import SwiftUI
import Observation


class ViewModelUserData: ObservableObject {
    @Published var data: String = "AB1" // Example property
    @Published var drafttext: String = "" // Example property
    @Published var dataEntryState: DataEntryStates = .UNUSED
    @Published var cursorPos: Int = 0
//    @Published var location: CGPoint = CGPoint()
    var maxChar: Int = 4
    
    func GetMaxChars(_maxchar: Int)
    {
        maxChar = _maxchar
    }

    
    
    func tapReceived() {
        switch dataEntryState {
        case .UNUSED:
            dataEntryState = .HIGHLIGHT
            drafttext = data
        case .EDIT:
            print("please use validate or escape")
        case .HIGHLIGHT:
            if drafttext != data {
                print("to do: implement validation logic")
                return
            }
            dataEntryState = .UNUSED
        }
    }
    

    
    

    
    func Keyreceived(key: String)
    {
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
        if maxChar > drafttext.count
        {
            drafttext += key
            cursorPos += 1
        }
    }
    
    
    func SpecialKey(key: String)
    {
        if key == "VALIDATE" && dataEntryState != .UNUSED
        {
            print("VALIDATED")
            data = drafttext
            dataEntryState = .UNUSED
        }
        if key == "ESC" && dataEntryState != .UNUSED
        {
            print ("ESCAPED")
            drafttext = ""
            dataEntryState = .UNUSED
        }
        if key == "<-" && dataEntryState != .UNUSED
        {
            if cursorPos <= 0 {return}
            cursorPos -= 1
        }
        if key == "->" && dataEntryState != .UNUSED
        {
            if cursorPos >= drafttext.count {return}
            cursorPos += 1
        }
        if key == "DEL"
        {
            dataEntryState = .EDIT
            drafttext = ""
            cursorPos = 0
        }
    }
    
    
    
}

