# app.rb
require "unloosen"

content_script site: "www.google.com/maps/*" do
    main_div = document.createElement("div")
    main_div.id = "unloosen-main-div"

    # スタイルを適用して画面右上に固定表示
    main_div.style.position = "fixed" # 画面に固定
    main_div.style.right = "0"        # 画面右端に配置
    main_div.style.resize = "both" # 横方向にリサイズ可能
    main_div.style.overflow = "scroll" # 内容がはみ出した場合は隠す
    main_div.style.color = "black"    # 文字色
    main_div.style.backgroundColor = "#CDF0EA"    # 背景色
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

    title_list = ["顧客候補名", "サービス名", "散布物", "散布対象", "基本情報", "情報元", "都道府県", "所在市区町村", "住所", "部署", "電話番号", "URL", "アトリビュート", "品目", "棟形式", "屋根形状", "棟数", "面積算出式", "入力", "ハウス面積(m2)", "備考", "記載者", "記載日"]
    title_list.each do |title|
        # タイトルを作成
        title_element = document.createElement("span")
        title_element.textContent = title
        title_element.style.textAlign = "right"
        title_element.innerText = title + ":"
        grid_div.appendChild(title_element)
        case title
        when "顧客候補名", "都道府県", "所在市区町村", "住所", "部署", "電話番号", "URL", "棟数", "備考", "記載者", "記載日"
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
        when "面積算出式"
            input_element = document.createElement("input")
            input_element.type = "text"
            input_element.placeholder = "面積算出式を入力"
            input_element.classList.add("unloosen-area-calculation-input")
            grid_div.appendChild(input_element)
        when "ハウス面積(m2)"
            input_element = document.createElement("input")
            input_element.type = "text"
            input_element.classList.add("unloosen-area-input")
            grid_div.appendChild(input_element)
        when "入力"
            button_div = document.createElement("div")
            button_div.style.display = "flex"
            button_div.style.gap = "6px"
            button_list = [["insert", "面積取得"], ["AC", "AC"], ["plus", "+"], ["times", "*"], ["minus", "-"], ["division", "/"], ["iquals", "="]]
            button_list.each do |btn|
                button_element = document.createElement("button")
                button_element.textContent = btn[1]
                button_element.classList.add("unloosen-#{btn[0]}-button")
                case btn[0]
                when "insert"
                    button_element.classList.add("unloosen-button", "secondary", "small")
                when "AC"
                    button_element.classList.add("unloosen-button", "danger-primary", "small")
                when "iquals"
                    button_element.classList.add("unloosen-button", "primary", "small")
                else
                    button_element.classList.add("unloosen-button", "nutral", "small")
                end
                button_div.appendChild(button_element)
            end
            button_list.each do |btn|
                button_element = button_div.querySelector(".unloosen-#{btn[0]}-button")
                case btn[0]
                when "insert"
                    button_element.addEventListener("click") do
                        begin
                            ruler = document.querySelector("div#ruler")
                            ruler_div_2 = ruler.querySelectorAll("div")[2]
                            current_value_str = ruler_div_2.textContent
                            current_value = current_value_str.split(" ")
                            current_value = current_value[1].gsub(/[ ,]/, '') if current_value[1]
                            calc_str = document.querySelectorAll(".unloosen-area-calculation-input")[0].value
                            calc_new_str = "#{calc_str} #{current_value}" if current_value
                            document.querySelectorAll(".unloosen-area-calculation-input")[0].value = calc_new_str
                        rescue => e
                            puts "Ruler value not found :("
                            # puts "Error: #{e.message}"
                        end
                    end
                when "plus"
                    button_element.addEventListener("click") do
                        calc_str = document.querySelectorAll(".unloosen-area-calculation-input")[0].value
                        calc_new_str = "#{calc_str} + "
                        document.querySelectorAll(".unloosen-area-calculation-input")[0].value = calc_new_str
                    end
                when "times"
                    button_element.addEventListener("click") do
                        calc_str = document.querySelectorAll(".unloosen-area-calculation-input")[0].value
                        calc_str << " * "
                        document.querySelectorAll(".unloosen-area-calculation-input")[0].value = calc_str
                    end
                when "minus"
                    button_element.addEventListener("click") do
                        calc_str = document.querySelectorAll(".unloosen-area-calculation-input")[0].value
                        calc_str << " - "
                        document.querySelectorAll(".unloosen-area-calculation-input")[0].value = calc_str
                    end
                when "division"
                    button_element.addEventListener("click") do
                        calc_str = document.querySelectorAll(".unloosen-area-calculation-input")[0].value
                        calc_str << " / "
                        document.querySelectorAll(".unloosen-area-calculation-input")[0].value = calc_str
                    end
                when "AC"
                    button_element.addEventListener("click") do
                        document.querySelectorAll(".unloosen-area-calculation-input")[0].value = ""
                    end
                when "iquals"
                    button_element.addEventListener("click") do
                        calc_str = document.querySelectorAll(".unloosen-area-calculation-input")[0].value
                        if calc_str.strip.empty?
                            alert("面積算出式が入力されていません。")
                        else
                            begin
                                result = eval(calc_str)
                                document.querySelectorAll(".unloosen-area-input")[0].value = result.to_s
                            rescue => e
                                alert("計算に失敗しました: #{e.message}")
                            end
                        end
                    end
                end
            end
            grid_div.appendChild(button_div)
        end
        main_div.appendChild(grid_div)
    end
    # ボタンを作成
    get_value_button = document.createElement("button")
    get_value_button.textContent = "値を取得"
    get_value_button.style.marginTop = "6px"
    get_value_button.classList.add("unloosen-button", "secondary")
    get_value_button.addEventListener("click") do
        if c_name = document.getElementsByTagName("h1")[0]&.textContent
            grid_div.querySelectorAll("input")[0].value = c_name
        end
        if pluscode_element = document.querySelector("button[data-tooltip='Plus Code をコピーします']")
            pluscode = pluscode_element&.textContent
            pluscode = pluscode.gsub("、", " ")    # 、をスペースに置換
            pluscode = pluscode.split(" ")
            grid_div.querySelectorAll("input")[5].value = pluscode[-1] if pluscode[-1]    # 都道府県
            grid_div.querySelectorAll("input")[6].value = pluscode[1] if pluscode[1]    # 所在市区町村
        end
        if address_elements = document.querySelector("button[data-tooltip='住所をコピーします']")
            address = address_elements&.textContent.split(" ")[1]
            grid_div.querySelectorAll("input")[7].value = address if address
        end
        if phone_elements = document.querySelector("button[data-tooltip='電話番号をコピーします']")
            phone = phone_elements&.textContent.split(" ")[0]
            phone_number = phone.gsub(/[^0-9-]/, "")    # 数字とハイフン以外を削除
            grid_div.querySelectorAll("input")[9].value = phone_number if phone_number
        end
        if url_elements = document.querySelector("a[data-tooltip='ウェブサイトを開きます']")
            url = url_elements&.getAttribute("href")
            grid_div.querySelectorAll("input")[10].value = url if url
        end
    end
    main_div.appendChild(get_value_button)
end