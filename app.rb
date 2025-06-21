# app.rb
require "unloosen"

content_script site: "www.google.com/maps/*" do
    main_div = document.createElement("div")
    main_div.id = "unloosen-main-div"

    # スタイルを適用して画面右上に固定表示
    main_div.style.position = "fixed" # 画面に固定
    main_div.style.right = "0"        # 画面右端に配置
    # main_div.style.width = "40%"
    main_div.style.color = "black"    # 文字色
    main_div.style.backgroundColor = "#e0ffff"    # 背景色
    main_div.style.margin_top = "6px"  # 上側の余白
    main_div.style.padding = "6px"    # 内側の余白
    main_div.style.zIndex = "999"    # 他の要素より手前に表示

    # content-container要素配下に作成したdivを追加
    content_container = document.getElementById("content-container")
    content_container.appendChild(main_div) if content_container

    grid_div = document.createElement("div")
    grid_div.style.display = "grid"
    grid_div.style.gap = "6px"
    grid_div.style.gridTemplateColumns = "120px 1fr" # 2列のグリッド

    title_list = ["顧客候補名", "サービス名", "散布物", "散布対象", "基本情報", "情報元", "都道府県", "所在市区町村", "住所", "部署", "電話番号", "URL", "アトリビュート", "品目", "棟形式", "屋根形状", "棟数", "ハウス面積(m2)", "備考", "記載者", "記載日"]
    title_list.each do |title|
        # タイトルを作成
        title_element = document.createElement("span")
        title_element.textContent = title
        title_element.style.textAlign = "right"
        title_element.innerText = title + ":"
        grid_div.appendChild(title_element)
        case title
        when "顧客候補名", "都道府県", "所在市区町村", "住所", "部署", "電話番号", "URL", "棟数", "ハウス面積(m2)", "備考", "記載者", "記載日"
            input_element = document.createElement("input")
            input_element.type = "text"
            grid_div.appendChild(input_element)
        when "サービス名"
            input_element = document.createElement("input")
            input_element.type = "text"
            input_element.classList.add("has-default-value")
            input_element.value = "PTS"
            grid_div.appendChild(input_element)
        when "散布物"
            input_element = document.createElement("input")
            input_element.type = "text"
            input_element.classList.add("has-default-value")
            input_element.value = "遮光剤"
            grid_div.appendChild(input_element)
        when "散布対象"
            input_element = document.createElement("input")
            input_element.type = "text"
            input_element.classList.add("has-default-value")
            input_element.value = "ガラス室・ハウス"
            grid_div.appendChild(input_element)
        when "情報元"
            input_element = document.createElement("input")
            input_element.type = "text"
            input_element.classList.add("has-default-value")
            input_element.value = "航空写真"
            grid_div.appendChild(input_element)
        when "品目"
            input_element = document.createElement("input")
            input_element.type = "text"
            input_element.value = "トマト"
            grid_div.appendChild(input_element)
        when "棟形式"
            select_element = document.createElement("select")
            grid_div.appendChild(select_element)
            for option in ["単棟", "連棟"]
                option_element = document.createElement("option")
                option_element.value = option
                option_element.textContent = option
                select_element.appendChild(option_element)
            end
        when "屋根形状"
            select_element = document.createElement("select")
            grid_div.appendChild(select_element)
            for option in ["丸屋根型(パイプハウス等)", "屋根型(フェンロー型等)"]
                option_element = document.createElement("option")
                option_element.value = option
                option_element.textContent = option
                select_element.appendChild(option_element)
            end
        when "基本情報", "アトリビュート"
            blank_span = document.createElement("span")
            grid_div.appendChild(blank_span)
        end
        main_div.appendChild(grid_div)
    end
end