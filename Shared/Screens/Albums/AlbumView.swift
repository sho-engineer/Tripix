import SwiftUI

struct AlbumView: View {
    @State private var uploadStatus: [UUID: Bool] = [:] // Google Photosへのアップロード状態を管理
    @State private var appleUploadStatus: [UUID: Bool] = [:] // Apple Photosへのアップロード状態を管理
    @State private var showMoreAlbums: Bool = false // もっとアルバムを表示するかどうか
    @State private var searchText: String = "" // 検索テキストの管理

    let albums: [Album]

    // アルバムを全て表示するか、最初の数個だけ表示するかを決める
    private var visibleAlbums: [Album] {
        showMoreAlbums ? albums : Array(albums.prefix(3))
    }

    var body: some View {
        NavigationView {
            VStack {
                // 検索バーを上部に配置
                searchBar

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(visibleAlbums) { album in
                            albumSection(for: album)
                            Divider() // 各アルバムの下に区切り線
                        }

                        // See more albumsボタン
                        if !showMoreAlbums {
                            Button(action: {
                                showMoreAlbums.toggle()
                            }) {
                                Text("See more albums")
                                    .font(.headline)
                                    .foregroundColor(.gray) // 文字をグレーに
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.1)) // ボタン背景色
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray, lineWidth: 1) // グレーの境界線
                                    )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 20) // 画面下部の余白を確保
                }
            }
            .navigationBarTitle("Albums", displayMode: .inline)
        }
    }

    // 検索バーのビュー
    private var searchBar: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search albums", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle()) // テキストフィールドスタイル
            }
            .padding(.vertical, 5)
            .background(Color.white)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }

    // アルバムごとのセクションを描画する関数
    private func albumSection(for album: Album) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(album.title)
                    .font(.headline)
                Spacer()
                Text("\(album.photoCount) photos")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            photoGrid(for: album.photos)

            // アップロードボタンを横並びに配置
            HStack(spacing: 10) {
                uploadButton(for: album, platform: .google)
                uploadButton(for: album, platform: .apple)
            }
        }
        .padding(.horizontal)
    }

    // アップロードボタン（Google Photos/Apple Photos共通）
    private func uploadButton(for album: Album, platform: UploadPlatform) -> some View {
        Button(action: {
            toggleUploadStatus(for: album.id, platform: platform)
        }) {
            HStack {
                Image(systemName: platform.iconName)
                    .font(.title2)
                    .foregroundColor(uploadStatus(for: album.id, platform: platform) ? platform.activeColor : .gray)
                Text(uploadStatus(for: album.id, platform: platform) ? "Uploaded" : platform.buttonTitle)
                    .font(.subheadline)
                    .foregroundColor(uploadStatus(for: album.id, platform: platform) ? platform.activeColor : .gray)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(uploadStatus(for: album.id, platform: platform) ? platform.activeColor.opacity(0.2) : Color.gray.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(uploadStatus(for: album.id, platform: platform) ? platform.activeColor : Color.gray, lineWidth: 1)
            )
        }
        .disabled(uploadStatus(for: album.id, platform: platform)) // ボタンを無効化
    }

    // アップロード状態を管理
    private func uploadStatus(for albumId: UUID, platform: UploadPlatform) -> Bool {
        switch platform {
        case .google:
            return uploadStatus[albumId] == true
        case .apple:
            return appleUploadStatus[albumId] == true
        }
    }

    // アップロード状態をトグルする
    private func toggleUploadStatus(for albumId: UUID, platform: UploadPlatform) {
        switch platform {
        case .google:
            uploadStatus[albumId] = !(uploadStatus[albumId] ?? false)
        case .apple:
            appleUploadStatus[albumId] = !(appleUploadStatus[albumId] ?? false)
        }
    }

    // アルバムの写真グリッドを描画する関数
    private func photoGrid(for photos: [String]) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(photos.prefix(6), id: \.self) { photo in
                Image(photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            }
        }
    }
}

// アップロード先プラットフォームの種類
enum UploadPlatform {
    case google
    case apple

    var iconName: String {
        switch self {
        case .google:
            return "g.circle.fill"
        case .apple:
            return "applelogo"
        }
    }

    var buttonTitle: String {
        switch self {
        case .google:
            return "Save to Google Photos"
        case .apple:
            return "Save to Apple Photos"
        }
    }

    var activeColor: Color {
        switch self {
        case .google:
            return .green
        case .apple:
            return .blue
        }
    }
}

// モックデータ
struct Album: Identifiable {
    let id = UUID()
    let title: String
    let photoCount: Int
    let photos: [String]
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView(albums: [
            Album(title: "Golden Gate Park", photoCount: 13, photos: ["photo1", "photo2", "photo3", "photo4", "photo5", "photo6"]),
            Album(title: "San Francisco Zoo", photoCount: 12, photos: ["photo1", "photo2", "photo3", "photo4", "photo5", "photo6"]),
            Album(title: "Alcatraz Island", photoCount: 15, photos: ["photo1", "photo2", "photo3", "photo4", "photo5", "photo6"])
        ])
    }
}
