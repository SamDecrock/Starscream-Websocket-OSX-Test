//
//  AppDelegate.swift
//  Starscream Websocket OSX Test
//
//  Created by Sam Decrock on 11/09/15.
//  Copyright (c) 2015 Sam. All rights reserved.
//

import Cocoa
import Starscream

extension NSTextView {
    func append(string: String) {
        self.textStorage?.appendAttributedString(NSAttributedString(string: string))
        self.scrollToEndOfDocument(nil)
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, WebSocketDelegate {

    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet var textviewDebug: NSTextView!
    @IBOutlet var checkboxExtratext: NSButton!
    
    var socket = WebSocket(url: NSURL(scheme: "ws", host: "localhost:8080", path: "/")!)
    var connectingCounter = 0


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }


    @IBAction func buttonStartConnecting(sender: AnyObject) {
        debug("> websocket: setting delegate")
        socket.delegate = self
        
        debug("> websocket: connecting \(++connectingCounter)...")
        socket.connect()
        
        
        
        if checkboxExtratext.state == NSOnState {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.debug("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
            }
            
        }
    }
    
    func websocketDidConnect(socket: WebSocket) {
        debug("> websocket: connected")
        connectingCounter = 0
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        debug("\(error?.localizedDescription)")
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.debug("\n> websocket: connecting \(++self.connectingCounter)...")
            self.socket.connect()
        }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func debug(string: String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.textviewDebug.append(string + "\n")
            println(string)
        })
    }


}

