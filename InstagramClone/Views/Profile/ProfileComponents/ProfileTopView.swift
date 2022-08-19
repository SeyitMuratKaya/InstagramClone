//
//  ProfileTopView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct ProfileTopView: View {
    @Binding var showSettingsSheet:Bool
    @Binding var showImagePickerSheet:Bool
    
    var body: some View {
        HStack{
            Button{
                showImagePickerSheet.toggle()
            }label: {
                Image(systemName: "plus")
            }
            .padding([.leading])
            Spacer()
            Button{
                showSettingsSheet.toggle()
            }label: {
                Image(systemName: "line.3.horizontal.circle")
            }
            .padding([.trailing])
        }
    }
}

struct ProfileTopView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTopView(showSettingsSheet: .constant(false),showImagePickerSheet: .constant(false))
    }
}
