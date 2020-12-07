//
//  ContentView.swift
//  HappyPlaces
//
//  Created by addjn on 07/11/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Place.entity(), sortDescriptors: []) var places: FetchedResults<Place>
    @State var isAddPlace = false
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(places) { place in
                        NavigationLink(destination: PlaceDetail(place: place)) {
                            HStack {
                                if place.image != nil {
                                    Image(uiImage: UIImage(data: place.image!)!)
                                        .resizable()
                                        .frame(width: 75, height: 75)
                                        .cornerRadius(10)
                                } else {
                                    Image(systemName: "camera")
                                        .resizable()
                                        .frame(width: 75, height: 75)
                                        .cornerRadius(25)
                                }
                                VStack(alignment: .leading) {
                                    Text(place.title ?? "unknown")
                                        .font(.title2)
                                        .bold()
                                    Text(place.desc ?? "unknown")
                                        .font(.title3)
                                }
                            }
                            .padding(5)
                        }
                    }
                    .onDelete(perform: delete)
                   
                }
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Button(action: {
                            self.isAddPlace = true
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .padding(.trailing)
                                .padding(.bottom)
                        })
                    }
                }
            }
      
            .navigationBarTitle("Happy Places")
            .sheet(isPresented: self.$isAddPlace, content: {
                AddPlaceView()
            })
            .onAppear {
                try? self.moc.save()
            }
        }
        
    }
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let place = places[index]
            moc.delete(place)
        }
    }
    func edit(at offsets: IndexSet) {
        for index in offsets {
            let place = places[index]
            print(place)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
