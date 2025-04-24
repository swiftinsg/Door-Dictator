//
//  ContentView.swift
//  Door Dictator
//
//  Created by Jia Chen Yee on 4/23/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var server = Server()
    @State private var camera = Camera()

    @State private var showCameraControls = true
    
    var body: some View {
        ZStack {
            if camera.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                CameraBulgeView()
                    .environment(camera)
            }

            VStack {
                Text("^[\(camera.normalizedFacePositions.count) people](inflect: true) stuck outside")
                    .font(.system(size: 48))
                    .padding(100)
                
                Spacer()
                
                VoteTallyView(unlock: server.unlockVotes, lock: server.lockVotes, isVotingOverruled: server.isVotingOverruled)
            }

            if showCameraControls {
                HStack {
                    Text("Camera Source:")
                    Picker("Camera Source", selection: $camera.selectedCameraIndex) {
                        ForEach(0..<camera.availableCameras.count, id: \.self) { index in
                            Text(camera.availableCameras[index].localizedName)
                                .tag(index)
                        }
                    }
                    .disabled(camera.isLoading || camera.availableCameras.isEmpty)
                    .frame(width: 200)
                }
            }
        }
        .task {
            server.start()
            await camera.checkPermissionsAndSetupCameras()
        }
        .frame(width: 1920, height: 1080)
        .preferredColorScheme(.light)
        .focusable(true)
        .onKeyPress(.escape) {
            showCameraControls.toggle()
            return .handled
        }
    }
}

#Preview {
    ContentView()
}
