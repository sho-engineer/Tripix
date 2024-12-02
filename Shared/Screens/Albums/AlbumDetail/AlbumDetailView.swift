import SwiftUI

struct PhotoDetailView: View {
    @State private var captionText: String = "This is a sample caption." // 初期キャプション
    @State private var selectedPhotoIndex: Int = 0 // 現在表示中の画像のインデックス
    @State private var isEditing: Bool = false // 編集モーダルの状態
    @State private var isShareSheetPresented: Bool = false // SNSシェアモーダルの状態

    // AIガイドのサマリー
    @State private var aiSummary: String? = "This is a guide summary provided by AI. It includes historical insights and interesting facts about the location."

    let photos: [String] // アルバム内の写真

    var body: some View {
        NavigationView {
            VStack {
                // 選択された画像とそのキャプション
                VStack(spacing: 10) {
                    TabView(selection: $selectedPhotoIndex) {
                        ForEach(photos.indices, id: \.self) { index in
                            Image(photos[index])
                                .resizable()
                                .scaledToFit()
                                .tag(index)
                                .cornerRadius(16)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 300)

                    // キャプション表示
                    VStack(alignment: .leading) {
                        Text("Caption")
                            .font(.headline)
                            .foregroundColor(.black)

                        Text(captionText)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // 他の写真を表示
                VStack(alignment: .leading) {
                    Text("Other photos in the album")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(photos.indices, id: \.self) { index in
                                Image(photos[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        selectedPhotoIndex = index // 写真を選択
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()

                // アクションボタン (編集ボタンを含む)
                HStack(spacing: 30) {
                    actionButton(icon: "arrow.clockwise", text: "Edit") {
                        isEditing = true // 編集モーダルを表示
                    }

                    actionButton(icon: "arrow.down.to.line", text: "Save to phone") {
                        // 保存アクション
                    }

                    actionButton(icon: "link", text: "Share") {
                        isShareSheetPresented = true // シェアモーダルを表示
                    }
                }
                .padding(.top, 10)
            }
            .padding()
            .navigationBarTitle("Photo Details", displayMode: .inline)
            .sheet(isPresented: $isEditing) {
                EditModalView(captionText: $captionText, aiSummary: aiSummary)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.8) // モーダルの高さを8割に設定
            }
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(items: [captionText]) // シェア内容
            }
        }
    }

    // ボタンビュー
    private func actionButton(icon: String, text: String, action: @escaping () -> Void) -> some View {
        VStack {
            Button(action: action) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    )
            }
            Text(text)
                .font(.footnote)
                .foregroundColor(.black)
        }
    }
}

// モーダルビュー
struct EditModalView: View {
    @Binding var captionText: String
    var aiSummary: String? // AIガイドのサマリー

    @Environment(\.dismiss) private var dismiss // モーダルを閉じるための環境変数

    @State private var additionalText: String = "" // 追加の内容

    var body: some View {
        VStack(spacing: 20) {
            // タイトル
            Text("Edit Details")
                .font(.headline)
                .padding(.top, 20) // 上部の余白を調整

            // キャプション編集フィールド
            VStack(alignment: .leading, spacing: 10) {
                Text("Caption")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                TextField("Enter a new caption...", text: $captionText)
                    .padding()
                    .frame(height: 50) // テキストフィールドの高さ
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.top, 10) // タイトルとフィールド間の間隔を調整

            // AIサマリーセクション（サマリーが存在する場合のみ表示）
            if let summary = aiSummary {
                VStack(alignment: .leading, spacing: 10) {
                    Text("AI Guide Summary")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(summary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }

            // 追加内容の入力フィールド
            VStack(alignment: .leading, spacing: 10) {
                Text("Additional Information")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                TextField("Enter additional details...", text: $additionalText)
                    .padding()
                    .frame(height: 50) // テキストフィールドの高さ
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Spacer() // コンテンツを上に寄せる

            // 保存ボタン
            Button(action: {
                dismiss() // モーダルを閉じる
            }) {
                Text("Save")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20) // ボタンの下部余白を調整
        }
        .padding(.top, 10) // 全体の上部余白を追加
    }
}

// シェアシート
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any] // シェアする内容
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil // 除外するアクティビティタイプ

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // 更新処理は不要
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(
            photos: [
                "photo1", "photo2", "photo3", "photo4", "photo5"
            ]
        )
    }
}
