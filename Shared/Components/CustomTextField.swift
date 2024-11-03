import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .leading) {
                    // プレースホルダーを条件付きで表示
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(.placeholderGray)
                            .padding(.horizontal, 16)
                    }
                    
                    // テキストフィールドの種類を切り替え
                    if isSecure && !isPasswordVisible {
                        SecureField("", text: $text)
                            .textFieldStyle()
                    } else {
                        TextField("", text: $text)
                            .textFieldStyle()
                    }
                }
                .background(Color.fieldBackground)
                .cornerRadius(8)
                
                // パスワード表示・非表示の切り替えボタン
                if isSecure {
                    Button(action: {
                        withAnimation {
                            isPasswordVisible.toggle()
                        }
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.iconGray)
                            .padding(.trailing, 16)
                    }
                    .accessibilityLabel(Text(isPasswordVisible ? "Hide password" : "Show password"))
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.borderGray, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// テキストフィールドの共通スタイルを拡張
extension View {
    func textFieldStyle() -> some View {
        self
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .foregroundColor(.white)
    }
}

// カスタムカラーの定義
extension Color {
    static let fieldBackground = Color(.sRGB, white: 0.3, opacity: 1.0)
    static let placeholderGray = Color.gray.opacity(0.5)
    static let iconGray = Color.gray.opacity(0.8)
    static let borderGray = Color.gray.opacity(0.6)
}
