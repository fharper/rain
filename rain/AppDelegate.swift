//
//  AppDelegate.swift
//  rain
//
//  Created by Frédéric Harper on 2020-08-22.
//  fred.dev

import Cocoa
import AVFoundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let menu = NSMenu()
    var rainSound: AVAudioPlayer?

    //Run when the application finish loading
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menu.delegate = self;
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"));
            button.action = #selector(menuActions(_:));
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"));
        }
    }

    //Either play the rainforest sound or show the menu
    @objc func menuActions(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!;
        
        //Trick to show the menu only on right click
        if (event.type == NSEvent.EventType.rightMouseUp) {
            statusItem.menu = menu;
            statusItem.button?.performClick(nil);
        }
        else {
        
            //Never played before
            if (rainSound == nil) {
                let path = Bundle.main.path(forResource: "Rainstorm.mp3", ofType:nil)!
                let url = URL(fileURLWithPath: path)

                do {
                    rainSound = try AVAudioPlayer(contentsOf: url);
                    rainSound?.numberOfLoops = -1;
                } catch {
                    NSLog("wtf")
                }
            }
            
            //Play or stop
            if(rainSound?.isPlaying == true) {
                rainSound?.stop();
            }
            else {
                rainSound?.play();
            }
        }
    }
    
    //Run when the meny close: trick to show the menu only on right click
    @objc func menuDidClose(_ menu: NSMenu) {
        statusItem.menu = nil;
     }
}
