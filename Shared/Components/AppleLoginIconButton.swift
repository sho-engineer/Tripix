//
//  AppleLoginIconButton.swift
//  Tripix (iOS)
//
//  Created by 石井　翔 on 2024/10/30.
//

import SwiftUI

struct AppleLoginIconButton: View {
    var action: () -> Void
    
    var body: some View {
        BaseIconButton(imageName: "apple_logo", action: action)
    }
}
