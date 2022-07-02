//
//  ContentView.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-05-23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var library = Library(with: API())
    
    private let gradient = LinearGradient(colors: [Color("PaleGreen"),Color("LightBraun")],
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing)
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                gradient
                    .ignoresSafeArea()
                
                List {
                    
                    Group {
                        Link(destination: TimerView(),
                             label: "Timers")
                        Link(destination: NotificationsView(),
                             label: "Notifications")
                        Link(destination: URLSessionsView(library: library),
                             label: "URL Sessions")

                    }
                    .listRowBackground(Color.gray.opacity(0.3))
                }
            }
            .navigationTitle("Combine it!")

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
