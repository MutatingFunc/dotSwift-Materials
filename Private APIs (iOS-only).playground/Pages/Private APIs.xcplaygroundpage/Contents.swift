
import PlaygroundSupport
import UIKit
import ObjectiveC

// Hackery

assert(Bundle(path: "/System/Library/PrivateFrameworks/SpringBoardUIServices.framework")!.load())

let className = "SBUIPowerDownViewController"

// …to get this weird runtime class object

let Controller = NSClassFromString(className) as! UIViewController.Type

// Creating a view to display the view heirarchy

let vc = UIViewController()
vc.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

let textView = UITextView(frame: vc.view.bounds)
textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
vc.view.addSubview(textView)

// Creating the class from a private API (Magic)

let shutdown = Controller.init()
shutdown.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
shutdown.view.frame = vc.view.bounds
vc.view.addSubview(shutdown.view)
vc.addChild(shutdown)
Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
    UIView.animate(withDuration: 1, animations: { 
        shutdown.view.alpha = 0
    }, completion: { _ in
        shutdown.removeFromParent()
        shutdown.view.removeFromSuperview()
        shutdown.view.alpha = 1
    })
}

// Using a private API to render the view heirarchy as text

let selector = Selector("recursiveDescription")
let text = shutdown.view.perform(selector)?.takeRetainedValue() as? NSString
textView.text = text as? String

    // Set the playground's live view

PlaygroundPage.current.liveView = vc
