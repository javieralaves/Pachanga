//
//  HomeView.swift
//  Pachanga
//
//  Created by Javier Alaves on 7/7/23.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        
        ScrollView {
            
            AppLogo()
            
            // Section
            VStack (alignment: .leading) {
                
                Text("Este fin de semana")
                    .font(.title)
                    .fontWeight(.semibold)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: .infinity, height: 100)
                
                Spacer()
                
            }
            .frame(width: .infinity)
            .padding()
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
