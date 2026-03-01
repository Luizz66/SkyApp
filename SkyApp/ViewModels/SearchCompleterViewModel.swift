//
//  SearchCompleterViewModel.swift
//  SkyApp
//
//  Created by Luiz Gustavo Barros Campos on 09/12/25.
//

import MapKit
import Combine

class SearchCompleterViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var queryFragment: String = ""
    @Published var suggestions: [MKLocalSearchCompletion] = []
    
    private var completer: MKLocalSearchCompleter
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        self.completer = MKLocalSearchCompleter()
        super.init()
        
        completer.delegate = self
        completer.resultTypes = .address
        
        // Atualiza o completer toda vez que o texto muda
        $queryFragment
            .receive(on: RunLoop.main)
            .sink { [weak self] fragment in
                self?.completer.queryFragment = fragment
            }
            .store(in: &cancellables)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
    }
}

class Search: ObservableObject {
    @Published var isSearch: Bool = false
}
