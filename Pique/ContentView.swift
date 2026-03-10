//  ContentView.swift
//  Pique
//
//  Created by Henry Stamerjohann, Declarative IT GmbH, 07/03/2026

import SwiftUI

struct ContentView: View {
    private let formats = [
        (".mhl", "doc.text.magnifyingglass", Color.orange),
        ("Media Hash List", "externaldrive.badge.checkmark", Color.blue),
        ("XML Manifest", "chevron.left.forwardslash.chevron.right", Color.green),
    ]

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.seal.text.page.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("PiqueMHL")
                .font(.largeTitle.bold())

            Text("Quick Look previews for Media Hash Lists")
                .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                ForEach(formats, id: \.0) { name, icon, color in
                    Label(name, systemImage: icon)
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
                        .foregroundStyle(color)
                }
            }

            Text("Supports `.mhl` Media Hash List manifests used for camera card verification workflows.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 560)

            Text("Select an `.mhl` file in Finder and press Space to preview hashes, creator metadata, and XML source.")
                .font(.callout)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 560)
                .padding(.top, 4)
        }
        .padding(48)
        .frame(minWidth: 640, minHeight: 340)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
