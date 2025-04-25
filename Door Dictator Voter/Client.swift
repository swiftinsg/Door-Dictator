//
//  Client.swift
//  Door Dictator Voter
//
//  Created by Jia Chen Yee on 4/25/25.
//

import Foundation
import Observation

@Observable
final class Client: Sendable {
    var ip: String = "192.168.1.110"
    
    var unlock: Int = 0
    var lock: Int = 0
    
    func startTimerLoop() async {
        while true {
            try? await Task.sleep(for: .seconds(0.5))
            
            guard !ip.isEmpty && (lock != 0 || unlock != 0) else { continue }
            
            let url = URL(string: "http://\(ip):8080")!
            
            let entry = VoteEntry(lock: lock, unlock: unlock)
            
            lock = 0
            unlock = 0
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(entry)
            
            _ = try? await URLSession.shared.data(for: request)
        }
    }
}
