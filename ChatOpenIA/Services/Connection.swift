//
//  Connection.swift
//  ChatOpenIA
//
//  Created by Rafael Oliveira on 04/06/23.
//

import Foundation
import OpenAISwift
class Connection {
    static let shared = Connection()
    private var client: OpenAISwift?
    func configure(){
        self.client = OpenAISwift(authToken: K.key)
    }
    
    func getResponse(input:String, completion: @escaping (Result<String,Error>) -> Void) {
        client?.sendCompletion(with: input, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error.localizedDescription as! Error))
                break
            }
        })
        
    }
    
    
}
