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

    var body: some View {
        ZStack {
<<<<<<< HEAD:Door Dictator/Views/ContentView.swift
            if camera.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                CameraView(session: camera.captureSession)
                    .cornerRadius(12)
                    .overlay(
                        FaceOverlayView(faces: camera.detectedFaces)
                    )
            }

=======
//            BulgeEffectView(points: [
//                CGPoint(x: 0.5, y: 0.5),
//                CGPoint(x: 0.2, y: 0.2),
//                CGPoint(x: 0.3, y: 0.3),
//                CGPoint(x: 0.8, y: 0.2),
//            ])
            BulgeDemoView()
            
>>>>>>> main:Door Dictator/ContentView.swift
            VStack {
                Text("4 people stuck outside")
                    .font(.system(size: 48))
                    .padding(100)
                
                Spacer()
                
                VoteTallyView(unlock: server.unlockVotes, lock: server.lockVotes, isVotingOverruled: server.isVotingOverruled)
            }

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
        .onAppear {
            camera.checkPermissionsAndSetupCameras()
        }
        .task {
            server.start()
        }
        .frame(width: 1920, height: 1080)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
