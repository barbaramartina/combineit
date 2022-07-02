//
//  SequencePublisher.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-07-01.
//

import SwiftUI
import Combine

struct SequencePublisher: View {
    
    private let sequence1 = Publishers.Sequence<[Int], Error>(sequence: [1,2,3,4,5,6])
    
    var body: some View {
        ZStack {
            Color("LightBraun")
                .ignoresSafeArea()
            
            ScrollView {
                
                DocumentationLinkView(link: "https://developer.apple.com/documentation/combine/publishers/sequence")
                
            }
        }
    }
}

struct SequencePublisher_Previews: PreviewProvider {
    static var previews: some View {
        SequencePublisher()
    }
}
