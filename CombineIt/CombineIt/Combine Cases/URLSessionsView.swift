//
//  URLSessionsView.swift
//  CombineIt
//
//  Created by Barbara Rodeker on 2022-05-23.
//

import SwiftUI

struct URLSessionsView: View {
    
    @ObservedObject var library: Library
    
    var body: some View {
        ZStack {
            Color("LightBraun")
                .ignoresSafeArea()
            
            ScrollView {
                
                DocumentationLinkView(link: "https://developer.apple.com/documentation/foundation/urlsession/processing_url_session_data_task_results_with_combine")

                Button {
                    library.loadBooks()
                } label: {
                    Text("Load Books")
                        .font(.largeTitle)
                }
                .padding()
                .border(.gray, width: 2)
                
                ForEach(library.books ?? []) { book in
                    HStack {
                        Text(book.name)
                        Text(book.amazonURL)
                    }
                }
                
            }
        }
    }
}

struct URLSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        URLSessionsView(library: Library(with: API()))
    }
}
