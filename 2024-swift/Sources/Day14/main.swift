import AOCHelper
import Foundation
import Parsing
import Cocoa
import SwiftUI

func killOthers() {
    let pid = ProcessInfo.processInfo.processIdentifier
    print("This pid: \(pid)")
    let executable = Bundle.main.executableURL!
    NSWorkspace.shared.runningApplications.filter {
        $0.executableURL == executable && $0.processIdentifier != pid
    }.forEach {
        print("Killing \($0.processIdentifier)")
        $0.terminate()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

let app = NSApplication.shared
let appDelegate = AppDelegate()
app.delegate = appDelegate
app.setActivationPolicy(.regular)


let window = NSWindow(
    contentRect: NSRect(x: 0, y: 0, width: 800, height: 800),
    styleMask: [.titled, .closable, .miniaturizable, .resizable],
    backing: .buffered,
    defer: false
)

window.title = "Day 14"
window.makeKeyAndOrderFront(nil)

let input = try readInput(from: .module).trimmingCharacters(in: .whitespacesAndNewlines)
let day14 = try Day14(input: input, width: 101, height: 103)
//let day14 = Day14()
window.contentView = NSHostingView(rootView: ContentView(model: day14))

app.run()
