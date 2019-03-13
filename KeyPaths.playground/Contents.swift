//: # KeyPaths

import UIKit
import PlaygroundSupport

struct Person {
    var name: String
    let uniqueID: Int
}

var person = Person(name: "Fred", uniqueID: 42)

//: ### KeyPath (read-only)

let uniqueIDKeypath = \Person.uniqueID

person[keyPath: uniqueIDKeypath] // 42

type(of: uniqueIDKeypath) // KeyPath<Person, Int>

// Compilation error:
// person[keyPath: uniqueIDKeypath] = 99

//: ### WritableKeyPath

let nameKeypath = \Person.name

person.name // "Fred"

person[keyPath: nameKeypath] = "Jim"

person.name // "Jim"

type(of: nameKeypath) // WritableKeyPath<Person, String>
