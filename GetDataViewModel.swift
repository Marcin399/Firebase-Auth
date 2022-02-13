//
//  GetDataViewModel.swift
//  Login_Screen_Firebase
//
//  Created by Marcin on 05/02/2022.
//

import Foundation
import Firebase
import SwiftUI
import grpc



class UserInfo : ObservableObject{
    @Published var islogin : Bool = false
    @Published var userid : String = "0"
    @Published var email : String = "0"
    @Published var dataFB : String = "0"
    @Published var notatki : [Int:String] = [:]
    @Published var collection : String = "0"
    @Published var index = 0
    @Published var arr : [Int] = []
    @Published var maxid : Int = 0
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var data = [dane1]()
    var db = Firestore.firestore()
    
    func getUsterData(){
        
        
        print(self.userid)
        let user = Auth.auth().currentUser
        if user != nil{
        var uid : String = user?.uid as! String
        var email : String = user?.email as! String
        self.userid = uid
        self.email = email
        print(self.email)
        print(self.userid)
        }
    
    }

    func getdata(){
        print("user id \(self.userid)")
        if self.userid != "0" {
        self.collection = self.userid
        print("finkcja getdata")
        
        db.collection(self.collection).addSnapshotListener { QuerySnapshot, error in
            print(error)
            guard let document = QuerySnapshot?.documents else {
                print("no document")
                
                return
            }
           
            document.map { (QueryDocumentSnapshot)-> dane1 in

                let data = QueryDocumentSnapshot.data()
               
                let id = data["id"] as! Int
                if id == self.maxid{
                    self.maxid = id
                    self.index = self.maxid + 1
                }
                if id >= self.maxid{
                    self.maxid = id
                    self.index = self.maxid + 1
                }
                
                
                let imie = data["imie"] as! String
                let color = data["color"] as! String
                   print("print id: \(id)")
                print("print data: \(imie)")
                self.notatki[id] = imie
                
                
                //print(self.notatki.count)
               // print(self.notatki)
                self.dataFB = imie
                return dane1(imie: imie , id: id, color: color)
            }
        
        }
        }else{
            print("wywolano elasa")
            getUsterData()  }
        
        
    }
    
    func newColection(text:String){
        
        if self.userid != ""{
            self.index = self.index + 1
            db.collection(self.userid).document("\(self.index)").setData(["imie" : text , "id" : self.index , "color" : "red"])
          
            print(self.index)
            print("dodano do kolekcji \(self.userid)")
        }else{
            print("pusty")
        }
            
    }
    
    func delatedData(dokument : String){
        
        db.collection(self.userid).document(dokument).delete(){ err in
            if let err = err {
                print("błąd w usunięciu danych")
            }else{
                
                print("dane usunięte")
            }
            
            
        }
        
    }
    

}

struct dane1 {
    var imie : String
    var id : Int
    var color : String
}

