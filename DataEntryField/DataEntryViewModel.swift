import SwiftUI
import Observation

@Observable
class DataEntryViewModel {
    var data: String = "AB1" // Example property
    var drafttext: String = "" // Example property
    var dataEntryState: DataEntryStates = .UNUSED
    var cursorPos: Int = 0
//    @Published var location: CGPoint = CGPoint()
    var maxChar: Int = 4
    // Reference to the environment instance
    var databaseUserData: DatabaseUserData?
    
    init(databaseUserData: DatabaseUserData? = nil) {
            self.databaseUserData = databaseUserData
        }
    
    
    
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
            // ✅ Save value to DatabaseUserData instance
           databaseUserData?.data = drafttext
           print("Saved to DatabaseUserData: \(drafttext)")
            
            
          /*  data = drafttext*/ //TODO: implement saving drafttext to Database
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

