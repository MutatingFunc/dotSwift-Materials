//: # Classes, Structs, & Copy-On-Write
  
import UIKit
import PlaygroundSupport

/*:
 ### Structs
 **Value-sematics**
 
 Includes: most Swift standard library types
*/

struct Struct {
    var number: Int
}


let value = Struct(number: 1)

var valueCopy = value
valueCopy.number = 2

value.number // 1
valueCopy.number // 2

// Not equal, assignment copies the value


/*:
 ### Classes
 **Reference-sematics**
 
 Includes: most Objective-C types (NSAttributedString, UIView)
*/

class Class {
    var number: Int
    init(number: Int) { self.number = number }
}


let object = Class(number: 1)

var objectCopy = object
objectCopy.number = 2

object.number // 2
objectCopy.number // 2

// Equal, assignment copies the reference to a shared value

/*:
 >
 > Copying an Int takes ~1 ns, while the time taken to pass a larger struct scales linearly (<∞ ns).
 >
 > Passing a class instance takes a constant time of around ~15 ns. This overhead comes from _reference counting_, used to free up memory when an object has no references.
 >
 > | <https://www.dotconferences.com/2019/01/johannes-weiss-high-performance-systems-in-swift>
 >
*/

/*:
 ### Copy-on-write structs
 **Value-sematics**
 
 Includes: large or variable length structs (String, Array, Dictionary)
 
 > Value-semantics are desirable for data models, but when the value contains many bytes the cost of copying structs around can become higher than that of managing class instances.
 >
 > To get good performance for large amounts of data, we would usually have to fall back to classes and give up value-semantics.
 >
 > In Swift, we can use copy-on-write to preserve the semantics we want.
 
 */

struct BigStruct {
    class DataRef {
        var number: Int
        init(number: Int) {
            self.number = number
        }
        
        func copy() -> DataRef {
            return DataRef(number: self.number)
        }
    }
    
    var dataRef: DataRef
    
    init(number: Int) {
        self.dataRef = DataRef(number: number)
    }
    
    var number: Int {
        get { return dataRef.number }
        set {
            if isKnownUniquelyReferenced(&dataRef) == false {
                self.dataRef = dataRef.copy()
            }
            self.dataRef.number = newValue
        }
    }
}


let bigValue = BigStruct(number: 1)

var bigValueCopy = bigValue
bigValueCopy.number = 2

bigValue.number // 1
bigValueCopy.number // 2

/*
 There is still the performance cost of copying the full value,
 but it is deferred to the first write.
 We're counting on writes being rare enough that we get
*/
