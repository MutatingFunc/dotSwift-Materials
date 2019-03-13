//: # Unicode Support
  
import UIKit
import PlaygroundSupport

//: ### The fun stuff

let 😀 = "Unicode is fun 😎 \u{1F607}"

let 😞 = 😀 + "\n" + "But please don't overuse it."

//: ### Defining operators (a world of no autocompletion)

//: **Square root**: ⌥ v → √
//:
//: Not to be confused with the tick: ✓
prefix operator √

prefix func √ <T: FloatingPoint>(value: T) -> T {
    return sqrt(value)
}

let root = √4 // 2

//: **Multiply**: ??? → ×
//:
//: Use text replacement to type this, or define a custom keyboard layout with Ukelele!
infix operator ×: MultiplicationPrecedence
func × (lhs: Double, rhs: Double) -> Double {
    return lhs * rhs
}

let result = √4 × 3 + 1 // 7

//: **Spaceship operator**: <=>
//:
//: Useful for sorting functions
infix operator <=>: ComparisonPrecedence

enum Ordering {
    case ascending
    case equal
    case descending
}

func <=> <T: Comparable>(lhs: T, rhs: T) -> Ordering {
    if lhs < rhs {
        return .ascending
    } else if lhs == rhs {
        return .equal
    } else {
        return .descending
    }
}

let nineDivThree = 9 <=> 3 // .descending

//: ### Defining precedence groups
//: See https://github.com/apple/swift-evolution/blob/master/proposals/0077-operator-precedence.md for a complete list of precedence groups and operators.

precedencegroup FunctionalPrecedence {
    associativity: left // Evaluate from left to right
    higherThan: AssignmentPrecedence // Evaluates before assignment
    lowerThan: TernaryPrecedence // Evaluates after resolving a ternary result
}

//: **Pipe**: |>

infix operator |>: FunctionalPrecedence

func |> <T, U>(lhs: T, rhs: (T) -> U) -> U {
    return rhs(lhs)
}

//: **Apply**: <|

infix operator <|: FunctionalPrecedence

func <| <T, U>(lhs: T, rhs: (T) -> U) -> T {
    rhs(lhs)
    return lhs
}

//: **Usage**

extension UIView {
    func constrainAllSides(ofSubview: UIView) {
        // Constrain the view
    }
}

let myView = UIView()

let isAdded =
    UILabel()
        <| {$0.text = "test"}
        <| myView.constrainAllSides
        <| myView.addSubview
        |> myView.subviews.contains
