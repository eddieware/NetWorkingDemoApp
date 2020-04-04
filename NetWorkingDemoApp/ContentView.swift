//
//  ContentView.swift
//  NetWorkingDemoApp
//
//  Created by EDUARDO MEJIA on 04/04/20.
//  Copyright © 2020 EDDIEWARE. All rights reserved.
//

import SwiftUI
//codable nos lo transforma a una estructura json
struct Response: Codable {
    var results:[Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
        NavigationView{
            List{
                ForEach(results, id: \.trackId){item in
                    VStack(alignment: .leading){
                        Text(item.trackName)
                            .font(.headline)
                        Text(item.collectionName)
                    }
                    
                }
            
            }.onAppear(perform: loadData)
        .navigationBarTitle("Songs List")
    }
}

func loadData(){
    //step 1
    guard let url = URL (string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else{
        print("URL invalid")
        return
    }
    //Step 2
    let request = URLRequest(url: url)
    //step 3
    URLSession.shared.dataTask(with: request){data, response, error in
        //step4
        if let data2 = data{
            //si data no es nulo se asigna a data2
            if let decodeResponse = try? JSONDecoder().decode(Response.self, from: data2){
               
                DispatchQueue.main.async {
                     //se ejecuta en el main thread
                     self.results = decodeResponse.results
                   
                }
                return //es para que se salga
            }
        }
        print("Fetch failed: \(error?.localizedDescription ?? "Unknow error")")
    }.resume()// el resume es para que se ejecute este codigo y se lleva siempre
    
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
