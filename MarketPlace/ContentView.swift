//
//  ContentView.swift
//  MarketPlace
//
//  Created by Sadie Wilson on 8/7/23.
//

import SwiftUI
import SQLite3
import AVKit
import WebKit
import AVFoundation

//Main View
struct ContentView: View {
    
    //Set up environment and environment object variables
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var arr: ItemList
    
    //View
    var body: some View {
        NavigationView{
            List{
                ForEach(arr.items){
                    item in
                    NavigationLink(destination: DetailView(arr: arr, thisItem: item.self)){
                        VStack(alignment: .leading){
                            Image(item.image)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }.onDelete(perform: {indexSet in
                    arr.items.remove(atOffsets: indexSet)
                })
            }.navigationTitle("MarketPlace")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: NavigationLink(destination: AddView(arr: arr)){Text("Add")})
        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                readDatabase(items: &arr.items)
            }
            else if newPhase == .inactive{
                writeDatabase(items: &arr.items)
            }
        }
    }
}


struct DetailView: View{
    //Set up variables
    @StateObject var arr = ItemList()
    @Environment(\.dismiss) var dismiss
    @State var audioPlayer: AVAudioPlayer!
    var thisItem: Item
    
    //View
    var body: some View{
        NavigationView{
            ScrollView {
                VStack(alignment: .leading){
                    Group{
                        HStack{
                            Image(thisItem.image)
                                .resizable()
                                .scaledToFill()
                        }
                        HStack{
                            Text(thisItem.itemName)
                                .padding(3)
                                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        }
                        HStack{
                            Text("Price:")
                                .alignmentGuide(.leading){d in d[.trailing]}
                                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 0))
                            
                            Text(thisItem.price)
                                .padding(.bottom, 3)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
                            
                        }
                        HStack{
                            Text("Seller:")
                                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                            Text(thisItem.seller)
                                .padding(.bottom, 3)
                                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        }
                        HStack{
                            Text("Contact Number:")
                                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                            Text(thisItem.contact)
                                .padding(.bottom, 3)
                                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        }
                        HStack{
                            Text("Seller Email:")
                                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                            Text(thisItem.email)
                                .padding(.bottom, 3)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
                            
                        }
                        HStack{
                            Text("Address:")
                                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                            Text(thisItem.address)
                                .padding(.bottom, 3)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
                        }
                    }
                    HStack(alignment: .top){
                        Text("Description: ")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        Text(thisItem.description)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
                    }
                    if thisItem.music != ""{
                        HStack{
                            LinkView(link: thisItem.video)
                                .frame(width: 400, height: 200)
                        }
                    }
                    if thisItem.music != ""{
                        HStack(alignment: .center){
                            Button(action: {
                                self.audioPlayer.play()
                            }){
                                Image(systemName: "play.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }.padding(EdgeInsets(top: 10, leading: 140, bottom: 10, trailing: 0))
                            Button(action: {
                                self.audioPlayer.pause()
                            }){
                                Image(systemName: "pause.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                        HStack{
                            
                        }

                    }
                    Spacer()
                }.onAppear{
                    let sound = Bundle.main.url(forResource: thisItem.music, withExtension: ".mp3")
                    self.audioPlayer = try! AVAudioPlayer(contentsOf: sound!)
                }
                        .navigationTitle("Details")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        leading: Button("Back"){dismiss()},
                        trailing: NavigationLink(destination: EditView(arr: arr, thisItem: thisItem)){Text("Edit")})
                    .padding(.leading, 5)
                
            }.environmentObject(arr)
            
                .navigationBarBackButtonHidden()
            
        }.navigationBarBackButtonHidden()
        
    }
}


struct AddView: View{
    //Set up variables
    @StateObject var arr = ItemList()
    @State private var addPrice = ""
    @State private var addItemName = ""
    @State private var addSeller = ""
    @State private var addContact = ""
    @State private var addDescription = ""
    @State private var addImage = ""
    @State private var addAddress = ""
    @State private var addEmail = ""
    @State private var addVideo = ""
    @State private var addMusic = ""
    @Environment(\.dismiss) var dismiss

    //View
    var body: some View{
        NavigationView{
            VStack{
                Group{
                    HStack{
                        Text("Item Name:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addItemName)
                    }
                    HStack{
                        Text("Price:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addPrice)
                    }
                    HStack{
                        Text("Seller:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addSeller)
                    }
                    HStack{
                        Text("Contact Number:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addContact)
                    }
                    HStack{
                        Text("Contact Email:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addEmail)
                    }
                    HStack{
                        Text("Address:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addAddress)
                    }
                }
                HStack(alignment: .top){
                    Text("Description:")
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                    TextField("", text: $addDescription, axis: .vertical)
                        .lineLimit(5)
                }
                HStack{
                    Text("Image:")
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                    TextField("", text: $addImage)
                }
                HStack{
                    Text("Video:")
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                    TextField("", text: $addVideo)
                }
                HStack{
                    Text("Music:")
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                    TextField("", text: $addMusic)
                }
                Spacer()
            }.navigationTitle("Add New Item")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading:
                        Button("Cancel"){
                            dismiss()
                        },
                    trailing:
                        Button("Save"){
                            addItem(price: addPrice, itemName: addItemName, seller: addSeller, contact: addContact, description: addDescription, image: addImage, email: addEmail, address: addAddress, video: addVideo, music: addMusic)
                            dismiss()
                        }
                    )
        }.environmentObject(arr)
            .navigationBarBackButtonHidden()
    }
    
    //Add Item Function
    func addItem(price: String, itemName: String, seller: String, contact: String, description: String, image: String, email: String, address: String, video: String, music: String){
        arr.items.append(Item(price: price, itemName: itemName, seller: seller, contact: contact, description: description, image: image, email: email, address: address, video: video, music: music))
    }
}

struct EditView: View{
    //Set up variables
    @StateObject var arr = ItemList()
    @State private var addPrice = ""
    @State private var addItemName = ""
    @State private var addSeller = ""
    @State private var addContact = ""
    @State private var addDescription = ""
    @State private var addImage = ""
    @State private var addAddress = ""
    @State private var addEmail = ""
    @State private var addVideo = ""
    @State private var addMusic = ""
    @Environment(\.dismiss) var dismiss
    var thisItem: Item
    
    //View
    var body: some View{
        NavigationView{
            VStack{
                Group{
                    HStack{
                        Text("Item Name:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addItemName)
                            .onAppear{self.addItemName = thisItem.itemName}
                    }
                    HStack{
                        Text("Price:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addPrice)
                            .onAppear{self.addPrice = thisItem.price}
                    }
                    HStack{
                        Text("Seller:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addSeller)
                            .onAppear{self.addSeller = thisItem.seller}
                    }
                    HStack{
                        Text("Contact Number:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addContact)
                            .onAppear{self.addContact = thisItem.contact}
                    }
                    HStack{
                        Text("Contact Email:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addEmail)
                            .onAppear{self.addEmail = thisItem.email}
                    }
                    HStack{
                        Text("Address:")
                            .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                        TextField("", text: $addAddress)
                            .onAppear{self.addAddress = thisItem.address}
                    }
                }
                HStack(alignment: .top){
                    Text("Description:")
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                    TextField("", text: $addDescription, axis: .vertical)
                        .onAppear{self.addDescription = thisItem.description}
                        .lineLimit(5)
                }
                HStack{
                    Text("Image:")
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                    TextField("", text: $addImage)
                        .onAppear{self.addImage = thisItem.image}
                }
                HStack{
                    Text("Video:")
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                    TextField("", text: $addVideo)
                        .onAppear{self.addVideo = thisItem.video}
                }
                HStack{
                    Text("Music:")
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                    TextField("", text: $addMusic)
                        .onAppear{self.addMusic = thisItem.music}
                }
                Spacer()
            }.navigationTitle("Edit Item")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading:
                        Button("Cancel"){
                            dismiss()
                        },
                    trailing:
                        Button("Save"){
                            updateItem(price: addPrice, itemName: addItemName, seller: addSeller, contact: addContact, description: addDescription, image: addImage, email: addEmail, address: addAddress, video: addVideo, music: addMusic)
                            dismiss()
                        }
                    )
        }.environmentObject(arr)
            .navigationBarBackButtonHidden()
    }
    
    //Update Item Function
    func updateItem(price: String, itemName: String, seller: String, contact: String, description: String, image: String, email: String, address: String, video: String, music: String){
        let index = arr.items.firstIndex(of: thisItem)
        arr.items[index!].price = price
        arr.items[index!].itemName = itemName
        arr.items[index!].seller = seller
        arr.items[index!].contact = contact
        arr.items[index!].description = description
        arr.items[index!].image = image
        arr.items[index!].email = email
        arr.items[index!].address = address
        arr.items[index!].video = video
        arr.items[index!].music = music
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ItemList())
    }
}

//Struct for Item Array
struct Item: Identifiable, Equatable{
    let id = UUID()
    var price: String
    var itemName: String
    var seller: String
    var contact: String
    var description: String
    var image: String
    var email: String
    var address: String
    var video: String
    var music: String
}

class ItemList: ObservableObject{
    @Published var items = [Item]()
}

//Database functions
func readDatabase(items: inout[Item]){
    items.removeAll()
    
    var db: OpaquePointer?
        
    let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ItemDatabase.sqlite")
    
    if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
        print("Error opening database")
        return
    }
    
    //let drop = "DROP TABLE Items"
    
    //sqlite3_exec(db, drop, nil, nil, nil)
    
    let createTableQuery = "CREATE TABLE IF NOT EXISTS Items(id INTEGER PRIMARY KEY AUTOINCREMENT, price TEXT, itemName TEXT, seller TEXT, contact TEXT, description TEXT, image TEXT, email TEXT, address TEXT, video TEXT, music TEXT)"
    
    if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK{
        print("Error creating table")
        return
    }
    
    let queryString = "SELECT * FROM Items"
    
    var stmt: OpaquePointer?
    
    if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
        print("Error preparing insert")
        return
    }
    
    while(sqlite3_step(stmt) == SQLITE_ROW){
        _ = sqlite3_column_int(stmt, 0)
        let price = String(cString: sqlite3_column_text(stmt, 1))
        let itemName = String(cString: sqlite3_column_text(stmt, 2))
        let seller = String(cString: sqlite3_column_text(stmt, 3))
        let contact = String(cString: sqlite3_column_text(stmt, 4))
        let description = String(cString: sqlite3_column_text(stmt, 5))
        let image = String(cString: sqlite3_column_text(stmt, 6))
        let email = String(cString: sqlite3_column_text(stmt, 7))
        let address = String(cString: sqlite3_column_text(stmt, 8))
        let video = String(cString: sqlite3_column_text(stmt, 9))
        let music = String(cString: sqlite3_column_text(stmt, 10))
        
        items.append(Item(price: price, itemName: itemName, seller: seller, contact: contact, description: description, image: image, email: email, address: address, video: video, music: music))
    }
    
    sqlite3_finalize(stmt)
    sqlite3_close(db)
}

func writeDatabase(items: inout[Item]){
    var db: OpaquePointer?
    
    let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("ItemDatabase.sqlite")
    
    sqlite3_open(fileUrl.path, &db)
    
    let deleteQuery = "DELETE FROM Items"
    
    sqlite3_exec(db, deleteQuery, nil, nil, nil)
    
    let queryString = "INSERT INTO Items (price, itemName, seller, contact, description, image, email, address, video, music) VALUES (?,?,?,?,?,?,?,?,?,?)"
    
    var stmt: OpaquePointer?
    
    for item in items{
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            print("error preparing insert")
            return
        }
        
        if(sqlite3_bind_text(stmt, 1, (item.price as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding price")
            return
        }
        
        if(sqlite3_bind_text(stmt, 2, (item.itemName as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding itemName")
            return
        }
        
        if(sqlite3_bind_text(stmt, 3, (item.seller as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding seller")
            return
        }
        
        if(sqlite3_bind_text(stmt, 4, (item.contact as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding contact")
            return
        }
        
        if(sqlite3_bind_text(stmt, 5, (item.description as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding description")
            return
        }
        
        if(sqlite3_bind_text(stmt, 6, (item.image as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding image")
            return
        }
        
        if(sqlite3_bind_text(stmt, 7, (item.email as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding email")
            return
        }
        
        if(sqlite3_bind_text(stmt, 8, (item.address as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding address")
            return
        }
        
        if(sqlite3_bind_text(stmt, 9, (item.video as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding address")
            return
        }
        
        if(sqlite3_bind_text(stmt, 10, (item.music as NSString).utf8String, -1, nil) != SQLITE_OK){
            print("Failure binding address")
            return
        }
        
        if(sqlite3_step(stmt) != SQLITE_DONE){
            print("Failure inserting item")
            return
        }
        sqlite3_finalize(stmt)
    }
    sqlite3_close(db)
}

struct LinkView: View{
    var link: String
    var body: some View{
        WebView(url: URL(string: link.embed)!)
    }
}

struct WebView: UIViewRepresentable{
    var url: URL
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
extension String{
    var embed: String {
        var strings = self.components(separatedBy: "/")
        let videoID = strings.last ?? ""
        strings.removeLast()
        let embedURL = strings.joined(separator: "/") + "/embed/\(videoID)"
        return embedURL
    }
}
