//
//  AddPlaceView.swift
//  HappyPlaces
//
//  Created by addjn on 07/11/20.
//

import SwiftUI

struct AddPlaceView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
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
                    TextField("title", text: $title)
                }
                Section {
                    TextField("description", text: $desc)
                }
                Section {
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
                            Button(action: {
                                self.showImagePicker.toggle()
                            }) {
                                Image(systemName: "camera")
                                    .resizable()
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                                    .padding(.vertical, 30)
                            }
                        }
                        Spacer()
                        
                    }
                }
                HStack {
                    Spacer()
                    Button("Save") {
                        if self.title == "" || self.desc == "" || self.inputImage == nil {
                            self.isError = true
                        } else {
                            let newPlace = Place(context: self.moc)
                            newPlace.id = UUID()
                            newPlace.title = self.title
                            newPlace.desc = self.desc
                            
                            var date: String {
                                let currentDate = self.date
                                let formatter = DateFormatter()
                                formatter.dateStyle = .long
                                let dateString = formatter.string(from: currentDate)
                                return dateString
                            }
                            
                            newPlace.date = date
                            
                            let pickedImage = inputImage?.jpegData(compressionQuality: 0.5)
                            self.outputImage = pickedImage
                            
                            newPlace.image = pickedImage
                            
                            try? self.moc.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Add a Place", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button("Cancel") {
                                        self.presentationMode.wrappedValue.dismiss()
                                    })
            .alert(isPresented: self.$isError, content: {
                Alert(title: Text("Error"), message: Text("nandayo? ada yang kurang tuch."), dismissButton: .default(Text("ok")))
            })
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) { ImagePicker(image: self.$inputImage) }
            
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView()
    }
}
