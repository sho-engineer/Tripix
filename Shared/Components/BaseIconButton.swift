import SwiftUI

struct BaseIconButton: View {
    var imageName: String  // アイコン画像の名前
    var action: () -> Void  // ボタンが押されたときのアクション
    var backgroundColor: Color = Color.clear  // 背景色のカスタマイズ
    var shadowColor: Color = Color.black.opacity(0.1)  // 影の色のカスタマイズ
    var buttonSize: CGFloat = 50  // ボタンのサイズ

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()  // 画像のリサイズを可能にする
                .scaledToFit()  // 画像がボタン内でフィットするようにスケーリング
                .frame(width: buttonSize, height: buttonSize)  // サイズを調整
                .padding(10)  // アイコン周りの余白
                .background(backgroundColor)  // カスタム背景色
                .clipShape(Circle())  // アイコンを丸くクリップする例
                .shadow(color: shadowColor, radius: 5, x: 0, y: 2)  // ボタンに影を追加
        }
        .accessibilityLabel(Text(imageName))  // アクセシビリティラベルを追加
    }
}
