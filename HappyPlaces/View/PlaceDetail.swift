//
//  PlaceDetail.swift
//  HappyPlaces
//
//  Created by addjn on 07/11/20.
//

import SwiftUI

struct PlaceDetail: View {
    var place: Place
    @State var isEdit = false
    var body: some View {
        VStack {
            if place.image != nil {
                Image(uiImage: UIImage(data: place.image!)!)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
            }
            Text(place.desc ?? "nani")
                .padding()
            Text("\(place.date ?? "nani")")
                .padding()
            Spacer()

        }
        .navigationBarTitle("\(place.title ?? "nani")", displayMode: .inline)
        .navigationBarItems(trailing: Button("Edit"){ self.isEdit = true })
        .sheet(isPresented: self.$isEdit) {
            EditView(place: place)
        }
    }
}


