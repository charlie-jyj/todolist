//
//  AddressTestView.swift
//  todolist
//
//  Created by 정유진 on 6/15/24.
//

import SwiftUI

/*
 @State Old Address: 0x16f6c4530 + uuid: 725AFE62-4724-4ACE-A703-4EEC890EEBA9
 @State New Address: 0x16f6c4560 + uuid: 0A8C0149-27A1-4EE9-B18A-05B6BB4DE4EE
 @State Old Address: 0x16f6c4530 + uuid: 0A8C0149-27A1-4EE9-B18A-05B6BB4DE4EE
 @State New Address: 0x16f6c4560 + uuid: 92C341C0-CBF4-498D-9A1E-52B0F6E7C859
 @State Old Address: 0x16f6c4560 + uuid: 92C341C0-CBF4-498D-9A1E-52B0F6E7C859
 @State New Address: 0x16f6c4590 + uuid: 52A090DA-765C-49A0-A906-CB674191F060
 @State Old Address: 0x16f6c4560 + uuid: 52A090DA-765C-49A0-A906-CB674191F060
 @State New Address: 0x16f6c4590 + uuid: B4DA21D6-954B-4521-933F-D32EFC9E0E38

 address가 3개 남짓 값을 돌려쓰고 있는 부분이 의아하여 추가 검색한 내용 ->
 
 1. Memory Pooling:

 - SwiftUI, especially with smaller data structures, often employs memory pooling to enhance performance.
 - When a @State object is deallocated (when the old struct is no longer referenced), its memory space isn't immediately released back to the system. Instead, SwiftUI might hold onto it in a pool.
 - When a new @State object of the same type is created, SwiftUI can quickly grab this pre-allocated space from the pool instead of requesting fresh memory.
 
 2. Struct Size and Alignment:

 - The size of your MyStruct (assuming it just contains a String and a UUID) is relatively small.
 = Memory addresses are often aligned to specific boundaries (e.g., multiples of 8 or 16 bytes). Given the struct's size, it might only require a small allocation that fits within these alignment constraints.
 - This means SwiftUI could be reusing a limited number of address slots that fit the struct's size requirements.
 
 3. SwiftUI's Optimization Heuristics:

 - SwiftUI uses complex algorithms to decide when to reuse memory. These heuristics consider factors like:
    - The size of the data
    - The frequency of creation/destruction
    - The overall memory usage of the app
*/

/*
 
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
 @frozen @propertyWrapper public struct State<Value> : DynamicProperty {
 
 /// An interface for a stored variable that updates an external property of a
 /// view.
 ///
 /// The view gives values to these properties prior to recomputing the view's
 /// ``View/body-swift.property``.
 @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
 public protocol DynamicProperty {

     /// Updates the underlying value of the stored value.
     ///
     /// SwiftUI calls this function before rendering a view's
     /// ``View/body-swift.property`` to ensure the view has the most recent
     /// value.
     mutating func update()
 }
 
 
 */

struct AddressTestView: View {
    @State var addresssText: String = ""
    @State private var myStateString: String = ""
    
    var body: some View {
        VStack {
            Text("State Variable Address Demonstration")
                .padding(.bottom, 100)
            
//            Button("Change State") {
//                // Print old address to console
//                withUnsafePointer(to: $myStruct) { pointer in
//                    let address = String(format: "%p", Int(bitPattern: pointer))
//                    print("@State Old Address: \(address) + uuid: \(myStruct.uuid)")
//                }
//                
//                // Change the @State value
//                self.myStruct = MyStruct(data: Date().description)
//                
//                // Print new address to console
//                withUnsafePointer(to: $myStruct) { pointer in
//                    let address = String(format: "%p", Int(bitPattern: pointer))
//                    print("@State New Address: \(address) + uuid: \(myStruct.uuid)")
//                }
//            }
            
            Text("State")
            
            Button("Change State") {
                withUnsafePointer(to: myStateString) { pointer in
                    let address = String(format: "%p", Int(bitPattern: pointer))
                    print("Old Value Address: \(address)")
                }
                
                withUnsafePointer(to: $myStateString) { pointer in
                    let address = String(format: "%p", Int(bitPattern: pointer))
                    print("Old Wrapped Value Address: \(address)")
                }
                
                withUnsafePointer(to: _myStateString) { pointer in
                    let address = String(format: "%p", Int(bitPattern: pointer))
                    print("Old State Value Address: \(address)")
                }
                
                self.myStateString = Date().description
                
                withUnsafePointer(to: myStateString) { pointer in
                    let address = String(format: "%p", Int(bitPattern: pointer))
                    print("New Value Address: \(address)")
                }
                
                withUnsafePointer(to: $myStateString) { pointer in
                    let address = String(format: "%p", Int(bitPattern: pointer))
                    print("New Wrapped Value Address: \(address)")
                }
                
                withUnsafePointer(to: _myStateString) { pointer in
                    let address = String(format: "%p", Int(bitPattern: pointer))
                    print("New State Value Address: \(address)")
                }
            }
            
            Text(myStateString)
            
            Divider()
            
            BindingAddressView(myBindingString: $myStateString)
            
       }
    }
    
}

struct BindingAddressView: View {
    @Binding var myBindingString: String
    
    var body: some View {
        Text("Binding")
        
        Button("Change Binding") {
            withUnsafePointer(to: myBindingString) { pointer in
                let address = String(format: "%p", Int(bitPattern: pointer))
                print("Old Binding Address: \(address)")
            }
            
            withUnsafePointer(to: _myBindingString) { pointer in
                let address = String(format: "%p", Int(bitPattern: pointer))
                print("Old Binding Value Address: \(address)")
            }
            
            self.myBindingString = Date().description
            
            withUnsafePointer(to: myBindingString) { pointer in
                let address = String(format: "%p", Int(bitPattern: pointer))
                print("New Binding Address: \(address)")
            }
            
            withUnsafePointer(to: _myBindingString) { pointer in
                let address = String(format: "%p", Int(bitPattern: pointer))
                print("New Binding Value Address: \(address)")
            }
        }
        
        Text(myBindingString)
    }
}

#Preview {
    AddressTestView()
}
