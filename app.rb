# app.rb
require "unloosen"

content_script site: "www.google.com/maps/*" do
    main_div = document.createElement("div")
    main_div.id = "unloosen-bottom-div"
    main_div.innerText = "Hello from Unloosen! This is at the bottom of the screen."

    # スタイルを適用して画面下部に固定表示
    main_div.style.position = "fixed" # 画面に固定
    main_div.style.bottom = "0"       # 画面下部に配置
    main_div.style.left = "0"         # 画面左端に配置
    main_div.style.width = "100%"     # 画面幅いっぱいに広げる
    main_div.style.color = "black"    # 文字色
    main_div.style.backgroundColor = "white"    # 背景色
    main_div.style.textAlign = "center" # テキストを中央揃え
    main_div.style.padding = "8px"    # 内側の余白
    main_div.style.zIndex = "999"    # 他の要素より手前に表示

    # 4. body要素に作成したdivを追加
    document.body.appendChild(main_div)
end