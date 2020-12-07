//
//  EditView.swift
//  HappyPlaces
//
//  Created by addjn on 07/11/20.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    var place: Place
    
    @State var title = ""
    @State var desc = ""
    @State var isError = false
    @State var date = Date()
    
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var outputImage: Data?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(place.title ?? "nani", text: $title)
                }
                Section {
                    TextField(place.desc ?? "nani", text: $desc)
                }
                Section(header: Text("\(place.date ?? "nani")" )) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                }
                Section {
                    HStack {
                        Spacer()
                        if image != nil {
                            image!
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical)
                                .onTapGesture { self.showImagePicker.toggle() }
                        } else {
                            if self.place.image != nil {
                                Image(uiImage: UIImage(data: place.image!)!)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.vertical)
                                    .onTapGesture { self.showImagePicker.toggle() }
                            } else {
                                Button(action: {
                                    self.showImagePicker.toggle()
                                }) {
                                    Image(systemName: "camera")
                                        .resizable()
                                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                                        .padding(.vertical, 30)
                                    
                                }
                            }
                        }
                        Spacer()
                        
                    }
                }
                HStack {
                    Spacer()
                    Button("Save") {
                        if self.title == "" || self.desc == "" {
                            self.isError = true
                        } else {
                            moc.delete(place)

                            let newPlace = Place(context: self.moc)
                            newPlace.id = UUID()
                            
                            newPlace.setValue(title, forKey: "title")
                            newPlace.setValue(desc, forKey: "desc")
                            newPlace.setValue("\(date)", forKey: "date")
                            
                            let pickedImage = inputImage?.jpegData(compressionQuality: 0.5)
                            self.outputImage = pickedImage
                            
                            newPlace.setValue(pickedImage, forKey: "image")

                            try? self.moc.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Edit Place", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button("Cancel") {
                                        self.presentationMode.wrappedValue.dismiss()
                                    })
            .alert(isPresented: self.$isError, content: {
                Alert(title: Text("Error"), message: Text("nandayo? ada yang kurang tuch."), dismissButton: .default(Text("ok")))
            })
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) { ImagePicker(image: self.$inputImage) }
            .onAppear {
                self.title = place.title ?? "nani"
                self.desc = place.desc ?? "nani"
                self.image = Image(uiImage: UIImage(data: place.image!)!) 

            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
}
