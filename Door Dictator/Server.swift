//
//  Server.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/23/25.
//

import Foundation
import Observation
import Vapor

@MainActor
@Observable
final class Server: Sendable {
    
    var lockVotes: Int = 0
    var unlockVotes: Int = 0
    
    var totalLockVotes: Int = 0
    var totalUnlockVotes: Int = 0
    
    func start() {
        Task {
            let app = try await Application.make(.detect())
            app.http.server.configuration.hostname = "0.0.0.0"
            app.http.server.configuration.port = 8080
            
            app.on(.POST) { req in
                let content = try req.content.decode(VoteEntry.self, using: JSONDecoder())
                
                await MainActor.run {
                    self.lockVotes += content.lock
                    self.unlockVotes += content.unlock
                    self.totalLockVotes += content.lock
                    self.totalUnlockVotes += content.unlock
                }
                
                return "thats so sigma"
            }
            
            try await app.execute()
        }
    }
}
