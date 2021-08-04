//
//  SwiftUIToolbarLeakDemoApp.swift
//  SwiftUIToolbarLeakDemo
//
//  Created by Matt Curtis on 7/21/21.
//

import SwiftUI

@main
struct SwiftUIToolbarLeakDemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            HStack {
                ViewDemonstratingExtraGhostView()
                
                ViewDemonstratingViewRecreation()
            }
            .frame(width: 500, height: 200)
        }
    }
    
}

struct ViewDemonstratingExtraGhostView: View {
    
    var body: some View {
        Color.red
            .toolbar {
                ToolbarItem {
                    Color.clear
                        .onAppear {
                            print("You should see this message printed twice.")
                        }
                }
            }
    }
    
}

struct ViewDemonstratingViewRecreation: View {
    
    @State var someState = 0
    
    var body: some View {
        Color.blue
            .toolbar {
                ToolbarItem {
                    Text(String(describing: someState))
                        .onAppear {
                            print("You should see this message printed many times.")
                        }
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {
                    _ in
                    
                    someState += 100
                }
            }
    }
    
}
