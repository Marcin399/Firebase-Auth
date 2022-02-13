//
//  ContentView.swift
//  Login_Screen_Firebase
//
//  Created by Marcin on 02/02/2022.
//


import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var user = UserInfo()
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var body: some View {
        
        Home()
            .environmentObject(user)
            .onAppear {
                
                user.getUsterData()
                
                user.getdata()
                print("wywołano funkcje getdata w contentVier")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        ContentView()
        
    }
}

struct Home : View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if self.status{
                    
                    Homescreen()
                    
                }
                else{
                    
                    ZStack{
                        
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            
                            Text("")
                        }
                        .hidden()
                        
                        Login(show: self.$show)
                            .background(
                                Image("my_grad_2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .blur(radius: 50))
                        
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    print(UserDefaults.standard.value(forKey: "status"))
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct Homescreen : View {
    @EnvironmentObject var user : UserInfo
    @State var text : String = ""
    @State var i = 0
    @State var delate : String = "0"
    @State var delate1 : String = "deate"
    
    
    var body: some View{
        
        
        VStack{
            
            HStack{
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 25))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                Spacer()
                Text(self.user.userid)
                    .font(.system(size: 12, weight: .thin))
                Spacer()
            Button(action: {
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                user.userid = "0"
                user.email = "0"
                user.dataFB = "0"
                user.collection = "0"
                user.notatki.removeAll()
                user.index = 0
                print("wyzerowane")
            }) {
                
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 25))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .foregroundColor(Color.white)
                    .background()
            }
            }
            
            //---------
            ScrollView( showsIndicators: false){
            ForEach (user.notatki.sorted(by: >), id: \.key) { key, value in // wyswitlanie danych
                    HStack{
                        Text(value)
                            .padding(.horizontal, 20)
                             .font(.system(size: 15, weight: .semibold))
                        Spacer()
                        Button {
                            user.notatki.removeAll()
                            self.user.delatedData(dokument: "\(key)")
                            self.user.getdata()
                            }label: {
                            Image(systemName: "trash")
                                    .padding(.horizontal, 20)
                        }
                    
                    }
                    .padding(.vertical, 15)
                    .frame(width: UIScreen.main.bounds.width - 25)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    
                }
            }.cornerRadius(20)
            //--------
            HStack{
            TextField("Dane do wysłania", text: self.$text)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                .background(.regularMaterial)
                .cornerRadius(15)
             
            
            Button {
                if self.text != ""{
                    self.user.notatki.removeAll()
                    self.user.newColection(text: self.text) // wysyłanie danych z pola
                    self.user.getdata()
                    self.text = ""
                   
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                   // .padding( 15)
                    .font(.system(size: 32))
                    .foregroundColor(Color.white)
            
            }
            
            }.padding(.horizontal, 15)
                .padding(.top, 10)
        }
    }
}

struct Login : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    @EnvironmentObject var user: UserInfo
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topTrailing) {
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        
                        
                        Text("Log in to your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Color2"))
                            .padding(.top, 35)
                            .padding(.bottom , 20)
                        
                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color3") : self.color,lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                    
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color3") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                
                                self.reset()
                                
                            }) {
                                
                                Text("Forget password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Color2"))
                            }
                        }
                        .padding(.top, 20)
                        
                        Button(action: {
                            
                            self.verify()
                            
                        }) {
                            
                            Text("Log in")
                                .fontWeight(.bold)
                                .foregroundColor(Color("Color2"))
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                                
                        }
                        .background(Color("Color"))
                       
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                    }.padding(.top, 150)
                    .padding(.horizontal, 25)
                }
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Color2"))
                }
                .padding()
            }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    func verify(){
        
        if self.email != "" && self.pass != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("success")
                user.islogin = true
                
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
                user.userid = "0"
                user.email = "0"
                user.dataFB = "0"
                user.collection = "0"
                user.notatki.removeAll()
                user.index = 0
                print("wyzerowane")
                user.getUsterData()
                user.getdata()
            }
        }
        else{
            
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
    
    func reset(){
        
        if self.email != ""{
            
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
}

struct SignUp : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    @EnvironmentObject var user : UserInfo
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topLeading) {
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        
                        
                        Text("Register")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Color2"))
                            .padding(.top, 85)
                        
                        TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color3") : self.color,lineWidth: 2))
                            .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color3") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.revisible{
                                    
                                    TextField("Re-enter", text: self.$repass)
                                        .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Re-enter", text: self.$repass)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.revisible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color("Color3") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                       
                        Button(action: {
                            
                            self.register()
                            
                        }) {
                            
                            Text("Register")
                                .foregroundColor(Color("Color2"))
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 25)
                }
                Spacer()
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Image(systemName: "chevron.left")
                        .padding(.vertical , 40)
                        .font(.title)
                        .foregroundColor(Color("Color2"))
                        
                }
                .padding()
                //.offset(x: 0, y: -100)
            }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            Image("my_grad_2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 50))
    }
    
    func register(){
        
        if self.email != ""{
            
            if self.pass == self.repass{
                
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    
                    if err != nil{
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    print("success")
                    user.userid = "1"
                    user.islogin = true
                    
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    user.userid = "0"
                    user.email = "0"
                    user.dataFB = "0"
                    user.collection = "0"
                    user.notatki.removeAll()
                    user.index = 0
                    print("wyzerowane")
                    user.getUsterData()
                    user.getdata()
                }
            }
            else{
                
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
}


struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        
        GeometryReader{_ in
            ZStack{
            VStack{
                
                HStack{
                    
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    
                    self.alert.toggle()
                    
                }) {
                    
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
                
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 40)
            
            .background(Color.white)
            .cornerRadius(15)
        } .offset(x:20 , y: 250)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
        
    }
}
