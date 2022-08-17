//
//  ProfileTopView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct ProfileTopView: View {
    @Binding var showSettingsSheet:Bool
    
    var body: some View {
        HStack{
            Button{
                
            }label: {
                Image(systemName: "plus")
            }
            .padding([.leading])
            Spacer()
            Button{
                showSettingsSheet.toggle()
            }label: {
                Image(systemName: "gear")
            }
            .padding([.trailing])
        }
    }
}

struct ProfileTopView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTopView(showSettingsSheet: .constant(false))
    }
}
