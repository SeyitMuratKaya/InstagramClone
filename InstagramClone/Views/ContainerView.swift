//
//  ContainerView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 12.08.2022.
//

import SwiftUI

enum Page {
    case authView
    case contentView
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .authView
}

struct ContainerView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
            case .authView:
                AuthView()
            case .contentView:
                ContentView()
            }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView().environmentObject(ViewRouter())
    }
}
