# app.rb
require "unloosen"

content_script site: "www.google.com/maps/*" do
    main_div = document.createElement("div")
    main_div.id = "unloosen-main-div"

    # スタイルを適用して画面右上に固定表示
    main_div.style.position = "fixed" # 画面に固定
    main_div.style.right = "0"        # 画面右端に配置
    main_div.style.width = "40%"
    main_div.style.color = "black"    # 文字色
    main_div.style.backgroundColor = "#e0ffff"    # 背景色
    main_div.style.margin_top = "6px"  # 上側の余白
    main_div.style.padding = "6px"    # 内側の余白
    main_div.style.zIndex = "999"    # 他の要素より手前に表示

    # content-container要素配下に作成したdivを追加
    content_container = document.getElementById("content-container")
    content_container.appendChild(main_div) if content_container
end