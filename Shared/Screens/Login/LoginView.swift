import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            // 背景色を灰色と黒の中間色に設定
            Color.backgroundGray
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image("tripix_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                CustomTextField(placeholder: String(localized: "email"), text: $email)
                CustomTextField(placeholder: String(localized: "password"), text: $password, isSecure: true)
                
                Divider()
                    .background(Color.dividerWhite)
                    .padding(.top, 20)
                
                Text(String(localized: "other_login_options"))
                    .foregroundColor(Color.dividerWhite)
                    .font(.system(size: 15))
                    .padding(.top, 15)
                
                HStack(spacing: 20) {
                    GoogleLoginIconButton {
                        // Debug print (for testing purpose)
                        print("Googleでログインボタンが押されました")
                    }
                    AppleLoginIconButton {
                        print("Appleでログインボタンが押されました")
                    }
                }
                .padding(.top, 10)
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .preferredColorScheme(.light)
            LoginView()
                .preferredColorScheme(.dark)
        }
    }
}

extension Color {
    static let backgroundGray = Color(.sRGB, white: 0.2, opacity: 1.0)
    static let dividerWhite = Color.white.opacity(0.8)
}
