//
//  NoValidDataPresentView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 04.06.23.
//

import SwiftUI

struct NoValidDataView: View {
    var body: some View {
//        ZStack {
//            Color(.red)
//            VStack(alignment: .center) {
//                Text("No connection to openHAB.")
//                Text("Please check the URL and the API-Token in Settings.")
//            }
//            .multilineTextAlignment(.center)
//            .padding(0)
//        }
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("CONNECTION ERROR")
//                        .bold()
                        .font(.headline)
                    Text("No connection to openHAB.Please check the URL and the API-Token in Settings.")
                        .font(.subheadline)
//                        .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                }
                Spacer()
            }
            .foregroundColor(Color.white)
            .padding(12)
            .background(.red)
            .cornerRadius(8)
            .padding()
                    }
    }
}

struct NoValidDataPresentView_Previews: PreviewProvider {
    static var previews: some View {
        NoValidDataView()
    }
}
