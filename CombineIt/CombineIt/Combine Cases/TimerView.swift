//
//  TimerView.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-05-23.
//

import SwiftUI

struct TimerView: View {
    
    /// Autoconnects will automatically connect when the subscriber below attaches
    /// This is a ConnectablePublisher which is convenient when you need to do an additional configuration previous to start receiving values
    let timer = Timer.publish(every: 2,
                              tolerance: 0.5,
                              on: .main,
                              in: .common).autoconnect()
    
    @State private var count = 0
    
    var body: some View {
        
        ZStack {
            Color("LightBraun")
                .ignoresSafeArea()
            
            ScrollView {
                
                DocumentationLinkView(link: "https://developer.apple.com/documentation/foundation/timer/3329589-publish")
                
                Group {
                    Text("Using timers with Publishers:")
                                .onReceive(timer) { time in
                                    if count == 10 {
                                        timer.upstream.connect().cancel()
                                    } else {
                                        print("The time is now \(time)")
                                    }
                                    count += 1
                                }
                    Text("... count changing to: \(count)")
                }
                .padding(.top, 16)
                
            }
            
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}

