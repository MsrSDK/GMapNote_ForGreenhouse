# encoding: utf-8
# app.rb
require "unloosen"
require "json"

content_script site: "www.google.com/maps/*" do
    main_div = document.createElement("div")
    main_div.id = "unloosen-main-div"
    save_key = "unl_save_value"

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
            for option in ["", "単棟", "連棟"]
                option_element = document.createElement("option")
                option_element.value = option
                option_element.textContent = option
                select_element.appendChild(option_element)
            end
        when "屋根形状"
            select_element = document.createElement("select")
            grid_div.appendChild(select_element)
            for option in ["", "丸屋根型(パイプハウス等)", "屋根型(フェンロー型等)"]
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
                        document.querySelectorAll(".unloosen-area-input")[0].value = ""
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
    bottom_btn_panel = document.createElement("div")
    bottom_btn_panel.style.display = "flex"
    bottom_btn_panel.style.padding = "6px"
    bottom_btn_panel.style.flexDirection = "row"
    bottom_btn_panel.style.gap = "6px"
    # 値抽出ボタンを作成
    get_value_button = document.createElement("button")
    get_value_button.textContent = "値を取得"
    get_value_button.classList.add("unloosen-button", "secondary")
    get_value_button.addEventListener("click") do
        begin
            if h1_tags = document.querySelectorAll("h1")
                c_name = ""
                h1_tags.length.to_i.times do |i|
                    c_name = h1_tags[i]&.textContent
                end
                grid_div.querySelectorAll("input")[0].value = c_name
            end
        rescue => e
            puts "顧客候補名の取得に失敗しました :("
            # puts "Error: #{e.message}"
        end
        begin
            if pluscode_element = document.querySelector("button[data-tooltip='Plus Code をコピーします']")
                pluscode = pluscode_element&.textContent
                pluscode = pluscode.gsub("、", " ")    # 、をスペースに置換
                pluscode = pluscode.split(" ")
                grid_div.querySelectorAll("input")[5].value = pluscode[-1] if pluscode[-1]    # 都道府県
                grid_div.querySelectorAll("input")[6].value = pluscode[1] if pluscode[1]    # 所在市区町村
            end
        rescue => e
            puts "都道府県または市区町村の取得に失敗しました :("
            # puts "Error: #{e.message}"
        end
        begin
            if address_elements = document.querySelector("button[data-tooltip='住所をコピーします']")
                address = address_elements&.textContent.split(" ")[1]
                grid_div.querySelectorAll("input")[7].value = address if address
            end
        rescue => e
            puts "住所の取得に失敗しました :("
            # puts "Error: #{e.message}"
        end
        begin
            if phone_elements = document.querySelector("button[data-tooltip='電話番号をコピーします']")
                phone = phone_elements&.textContent.split(" ")[0]
                phone_number = phone.gsub(/[^0-9-]/, "")    # 数字とハイフン以外を削除
                grid_div.querySelectorAll("input")[9].value = phone_number if phone_number
            end
        rescue => e
            puts "電話番号の取得に失敗しました :("
            # puts "Error: #{e.message}"
        end
        begin
            if url_elements = document.querySelector("a[data-tooltip='ウェブサイトを開きます']")
                url = url_elements&.getAttribute("href")
                grid_div.querySelectorAll("input")[10].value = url if url
            end
        rescue => e
            puts "URLの取得に失敗しました :("
            # puts "Error: #{e.message}"
        end
    end
    bottom_btn_panel.appendChild(get_value_button)
    main_div.appendChild(bottom_btn_panel)

    def clear_inputs(grid_div)
        [0,5,6,7,9,10,12,13,14,15].each do |i|
            grid_div.querySelectorAll("input")[i].value = ""
        end
    end

    # セーブボタンを作成
    save_value_button = document.createElement("button")
    save_value_button.textContent = "保存"
    save_value_button.style.marginTop = "6px"
    save_value_button.classList.add("unloosen-button", "primary")
    save_value_button.addEventListener("click") do
        data_to_save = {
            "顧客候補名" => grid_div.querySelectorAll("input")[0].value,
            "サービス名"   => grid_div.querySelectorAll("input")[1].value,
            "散布物"       => grid_div.querySelectorAll("input")[2].value,
            "散布対象"     => grid_div.querySelectorAll("input")[3].value,
            "情報元"       => grid_div.querySelectorAll("input")[4].value,
            "都道府県"     => grid_div.querySelectorAll("input")[5].value,
            "所在市区町村" => grid_div.querySelectorAll("input")[6].value,
            "住所"        => grid_div.querySelectorAll("input")[7].value,
            "部署"        => grid_div.querySelectorAll("input")[8].value,
            "電話番号"    => grid_div.querySelectorAll("input")[9].value,
            "URL"        => grid_div.querySelectorAll("input")[10].value,
            "品目"       => grid_div.querySelectorAll("input")[11].value,
            "棟形式"     => grid_div.querySelectorAll("select")[0].value,
            "屋根形状"   => grid_div.querySelectorAll("select")[1].value,
            "棟数"       => grid_div.querySelectorAll("input")[12].value,
            "ハウス面積"  => grid_div.querySelectorAll("input")[14].value,
            "備考"       => grid_div.querySelectorAll("input")[15].value,
            "記載者"     => grid_div.querySelectorAll("input")[16].value,
            "記載日"     => grid_div.querySelectorAll("input")[17].value
        }
        retrieved_json_string = JS.global[:localStorage].getItem(save_key)
        puts retrieved_json_string.to_s.length
        if retrieved_json_string.to_s.length > 5
            begin
                puts "レコード追加"
                retrieved_array_data = JSON.load(retrieved_json_string)
                if retrieved_array_data.is_a?(Array)
                    retrieved_array_data.push(data_to_save)
                    json_string_to_save = JSON.dump(retrieved_array_data)
                    JS.global[:localStorage].setItem(save_key, json_string_to_save)
                    puts ("レコードを保存しました")
                    clear_inputs(grid_div)
                end
            rescue => e
                puts "レコードの保存に失敗しました :("
                puts "Error: #{e.message}"
            end
        else
            begin
                puts "レコード新規作成"
                after_array = []
                after_array.push(data_to_save)
                json_string_to_save = JSON.dump(after_array)
                JS.global[:localStorage].setItem(save_key, json_string_to_save)
                puts ("レコードを保存しました")
                clear_inputs(grid_div)
            rescue => e
                puts "レコードの保存に失敗しました :("
                puts "Error: #{e.message}"
            end
        end
    end

    def create_table(retrieved_array_data)
        table_element = document.createElement("table")
        table_element.style.width = "100%"
        table_element.style.tableLayout = "fixed"
        table_element.border_collapse = "collapse"
        table_header = document.createElement("thead")
        table_header.style.backgroundColor = "#CDF0EA"
        header_row = document.createElement("tr")
        key_array = retrieved_array_data[0].keys
        key_array.each do |key|
            th = document.createElement("th")
            th.textContent = key
            header_row.appendChild(th)
        end
        table_header.appendChild(header_row)
        table_element.appendChild(table_header)
        # データ行作成
        table_body = document.createElement("tbody")
        retrieved_array_data.each do |row_data|
            tr = document.createElement("tr")
            row_data.values.each do |value|
                td = document.createElement("td")
                td.textContent = value.tr('０-９－', '0-9-')
                tr.appendChild(td)
            end
            table_body.appendChild(tr)
        end
        table_element.appendChild(table_body)
        table_element
    end

    def show_modal(content_container, save_key)
        retrieved_json_string = JS.global[:localStorage].getItem(save_key)
        if retrieved_json_string
            begin
                retrieved_array_data = JSON.load(retrieved_json_string)
                if retrieved_array_data.is_a?(Array)
                    table_wrapper = document.createElement("div")
                    table_wrapper.margin = "12px"
                    table_wrapper.style.scroll = "hidden"
                    table = create_table(retrieved_array_data)
                    table_wrapper.appendChild(table)
                end
            rescue => e
                puts "モーダルの表示に失敗しました :("
                puts "Error: #{e.message}"
            end
        else
            puts "レコードが見つかりませんでした"
            exit(0)
        end

        modal_con = document.createElement("div")
        modal_con.id = "unloosen-modal-div"
        modal_con.style.position = "absolute"
        modal_con.style.margin = "auto"
        modal_con.style.height = "80%"
        modal_con.style.width = "80%"
        modal_con.style.resize = "both"
        modal_con.style.top = "0"
        modal_con.style.bottom = "0"
        modal_con.style.left = "0"
        modal_con.style.right = "0"
        modal_con.style.overflow = "scroll" # 内容がはみ出した場合は隠す
        modal_con.style.color = "black"    # 文字色
        modal_con.style.backgroundColor = "#FFFFFF"    # 背景色
        modal_con.style.padding = "6px"    # 内側の余白
        modal_con.style.zIndex = "1000"    # 他の要素より手前に表示
        modal_btn_wrapper = document.createElement("div")
        modal_btn_wrapper.style.justifyContent = "flexEnd"
        # モーダル閉じるボタン
        modal_close_btn = document.createElement("button")
        modal_close_btn.textContent = "閉じる"
        modal_close_btn.style.marginTop = "6px"
        modal_close_btn.classList.add("unloosen-button", "nutral")
        modal_close_btn.addEventListener("click") do
            modal_con.remove
        end
        # レコード一括削除ボタン
        delete_record_btn = document.createElement("button")
        delete_record_btn.textContent = "レコード一括削除"
        delete_record_btn.style.marginLeft = "12px"
        delete_record_btn.classList.add("unloosen-button", "danger-primary")
        delete_record_btn.addEventListener("click") do
            JS.global[:localStorage].removeItem(save_key)
            modal_con.remove
        end
        modal_btn_wrapper.appendChild(modal_close_btn)
        modal_btn_wrapper.appendChild(delete_record_btn)
        modal_con.appendChild(table_wrapper)
        modal_con.appendChild(modal_btn_wrapper)
        content_container.appendChild(modal_con) if content_container
    end

    # テーブル表示ボタン作成
    show_table_button = document.createElement("button")
    show_table_button.textContent = "保存データ表示"
    show_table_button.style.marginTop = "6px"
    show_table_button.classList.add("unloosen-button", "show-modal")
    show_table_button.addEventListener("click") do
        show_modal(content_container, save_key)
    end

    bottom_btn_panel.appendChild(show_table_button)
    bottom_btn_panel.appendChild(save_value_button)
    main_div.appendChild(bottom_btn_panel)
end