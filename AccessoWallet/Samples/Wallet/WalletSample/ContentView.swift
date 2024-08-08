//
//  ContentView.swift
//

import SwiftUI
import AccessoWallet

struct ContentView: View {
    @State private var isLoading = false
    @State private var showUpdateAlert = false
    @State var passName: String = "pass"
    @State var passType: PassType = .eventTicket
    @State var useLogo: Bool = false
    @State var useStrip: Bool = false
    @State var useBackground: Bool = false
    @State var useThumbnail: Bool = false

    var body: some View {
        List {
            Section("Content") {
                TextField("Pass name", text: $passName)
                Picker("Pass type", selection: $passType) {
                    ForEach(PassType.allCases) {
                        Text($0.rawValue)
                    }
                }
                Toggle(isOn: $useLogo, label: {
                    Text("Logo image")
                })
                Toggle(isOn: $useStrip, label: {
                    Text("Strip image")
                })
                Toggle(isOn: $useBackground, label: {
                    Text("Background image")
                })
                Toggle(isOn: $useThumbnail, label: {
                    Text("Thumbnail image")
                })
            }

            Section("Update pass") {
                HStack {
                    Button("Trigger update pass notification") {
                        Task {
                            try await WalletProvider.shared.updatePass()
                        }
                    }
                    Spacer()
                    Button {
                        showUpdateAlert = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }

            Section("Add to wallet") {
                if !passName.isEmpty, let pass = try? createPass() {
                    AccessoWallet.AddToWalletButton(pass: pass)
                        .padding()
                }
            }
        }
        .alert(isPresented: $showUpdateAlert) {
            Alert(title: Text("Updating Passes"), message: Text("Updating wallet passes isn't supported on the simulator - you must be using a physical device. You will also need to make changes in the backend to register your push token for this to work."), dismissButton: .default(Text("Okay")))
        }
    }

    func createPass() throws -> WalletPass {
        guard let fileURL = Bundle.main.url(forResource: "pass", withExtension: "json") else {
            throw NSError(domain: "Error finding pass.json", code: 180)
        }
        let jsonData = try Data(contentsOf: fileURL)
        let walletData = try JSONDecoder().decode(WalletData.self, from: jsonData)
        return WalletPass(
            name: passName,
            passType: passType,
            walletData: walletData,
            logo: useLogo ? "https://storage.googleapis.com/happyland-1365.appspot.com/logo.png" : nil,
            // Note: picsum generates random images for testing purposes. However, if called too many times in a row it will return 404s
            strip: useStrip ? "https://picsum.photos/200/50" : nil,
            background: useBackground ? "https://picsum.photos/300/600" : nil,
            thumbnail: useThumbnail ? "https://picsum.photos/400/400" : nil
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
