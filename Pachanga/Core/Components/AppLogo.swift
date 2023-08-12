//
//  AppLogo.swift
//  Pachanga
//
//  Created by Javier Alaves on 7/7/23.
//

import SwiftUI

struct AppLogo: View {
    var body: some View {
        Image(systemName: "volleyball")
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(.orange)
            .padding(.top, 20)
            .padding(.bottom, 20)
    }
}

struct AppLogo_Previews: PreviewProvider {
    static var previews: some View {
        AppLogo()
    }
}
