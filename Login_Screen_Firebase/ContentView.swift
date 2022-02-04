//
//  ContentView.swift
//  Login_Screen_Firebase
//
//  Created by Marcin on 02/02/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    @State var show = false
    
    var body: some View{
        
            
            NavigationView{
                ZStack{
                    
                    NavigationLink(destination: SingUp(show: self.$show) , isActive: self.$show) {
                        Text("")
                    }
                    .hidden()
                    
                    Login(show: self.$show)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
            }
        
    }
}

struct Login: View{
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var allert = false
    @State var error = ""
    
    var body: some View{
        ZStack{
            ZStack(alignment:.topTrailing ){
                GeometryReader{_ in
                    VStack{
                        Image(systemName: "heart")
                        
                        Text("login to your acount")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top,35)
                        
                        TextField("Email",text: self.$email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.red : self.color , lineWidth: 2))
                            .padding(.top,25)
                        HStack(spacing: 15){
                            VStack{
                                
                                if self.visible{
                                    TextField("Password",text: self.$pass)
                                }else{
                                    SecureField("Password",text: self.$pass)
                                    
                                }
                            }
                            
                            Button {
                                self.visible.toggle()
                            } label: {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                
                            }

                        }   .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color.red : self.color , lineWidth: 2))
                            .padding(.top,25)
                        
                        HStack{
                            Spacer()
                            
                            
                            Button {
                                var a = 1
                            } label: {
                                
                                Text("Forget password")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.red)
                            }

                            
                        }.padding(.top, 20)
                        
                        Button {
                            self.verify()
                        } label: {
                            Text("Log in")
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.top, 25)

                        
                    }
                    .padding(.horizontal,25)
                }
                
                Button {
                    self.show.toggle()
                } label: {
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                }
                .padding()

            
            }
           
            if self.allert{
                ErrorView(alert: self.$allert, error: self.$error)
                  
        }
       
        }
    }
    func verify(){
        
        if self.email != "" &&  self.pass != ""{
            
        
        }else{
            self.error = "Plase fill all the contents propertly"
            self.allert.toggle()
            
        }
    }
}

struct SingUp: View{
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    
    var body: some View{
        ZStack(alignment: .topLeading ){
            GeometryReader{_ in
                VStack{
                    Image("heart")
                    
                    Text("login to your acount")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                        .padding(.top,35)
                    
                    TextField("Email",text: self.$email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color.red : self.color , lineWidth: 2))
                        .padding(.top,25)
                    HStack(spacing: 15){
                        VStack{
                            
                            if self.visible{
                                TextField("Password",text: self.$pass)
                            }else{
                                SecureField("Password",text: self.$pass)
                                
                            }
                        }
                        
                        Button {
                            self.visible.toggle()
                        } label: {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            
                        }

                    }   .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color.red : self.color , lineWidth: 2))
                        .padding(.top,25)
                    HStack(spacing: 15){
                        VStack{
                            
                            if self.revisible{
                                TextField("Password",text: self.$repass)
                            }else{
                                SecureField("Password",text: self.$repass)
                                
                            }
                        }
                        
                        Button {
                            self.revisible.toggle()
                        } label: {
                            Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                
                        }

                    }   .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color.red : self.color , lineWidth: 2))
                        .padding(.top,25)
                    
                    HStack{
                        Spacer()
                        
                        
                        Button {
                            var a = 1
                        } label: {
                            
                            Text("Forget password")
                                .fontWeight(.bold)
                                .foregroundColor(Color.red)
                        }

                        
                    }.padding(.top, 20)
                    
                    Button {
                        var a = 1
                    } label: {
                        Text("Register in")
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.top, 25)

                    
                }
                .padding(.horizontal,25)
            }
            
            Button {
                self.show.toggle()
            } label: {
               Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(Color.red)
            }
            .padding()

        
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        
        GeometryReader{_ in
            LazyVStack{
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
                .background(Color.red)
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
            }.padding(.top, UIScreen.main.bounds.height - 650)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
