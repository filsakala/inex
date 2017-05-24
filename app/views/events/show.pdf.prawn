font_families.update(
		"DejaVuSans" => { :bold => Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"),
		                  :normal => Rails.root.join("public", "fonts", "DejaVuSans.ttf") })
font "DejaVuSans"
font_size 9

additional_page_cnt = params[:plus_page].to_i
additional_page_cnt ||= 0
table_row_cnt = @volunteers.count
max_rows_per_page = 15
max_rows_per_full_page = 22
# Get page count according to vols count and additional pages...
page_cnt = ((table_row_cnt - 16) / max_rows_per_full_page) + 2 + additional_page_cnt
# Doplnkove prazdne riadky k vyplnenym
filling_rows = ((page_cnt - 1) * max_rows_per_full_page + max_rows_per_page) - table_row_cnt
table_data = []
@volunteers.each_with_index do |vol, row|
	city = get_city_from_event_list_or_its_user(vol.event_list)
	year = get_year_from_event_list_or_its_user(vol.event_list)
	table_data << [row + 1, "#{vol.event_list.name} #{vol.event_list.surname}",
	               city, year, "", ""]
end
(1..filling_rows).each do |row|
	table_data << [row + table_row_cnt, "", "", "", "", ""]
end

(1..page_cnt).each do |page|
	define_grid(:columns => 20, :rows => 8, :gutter => 0)
	grid([0, 0], [0, 19]).bounding_box do
		formatted_text([{ :text => "Projekt " },
		                { :text => '„Prečo áno?“ ',
		                  :font => "DejaVuSans",
		                  :styles => [:bold],
		                },
		                { :text => "bol podporený z dotácie Ministerstva školstva, vedy, výskumu a športu SR „Programy pre mládež 2014 – 2020“." }
		               ], align: :center, size: 8)
	end
	grid([0.3, 0], [0.3, 4]).bounding_box do
		image Rails.root.join('app', 'assets', 'images', 'inex_logo_with_text_small.png'), :scale => 0.4
	end
	grid([0.3, 5], [0.3, 14]).bounding_box do
		formatted_text([{ :text => "INEX Slovakia", :styles => [:bold] },
		                { :text => " - občianske združenie" }
		               ], align: :center, size: 14)
		move_down 2
		text "Prezenčná listina / List of participants", align: :center, size: 12
	end
	grid([1.1, 1.5], [1.1, 19]).bounding_box do
		text "Názov podujatia: #{@event.title}", size: 10
	end
	grid([1.3, 1.5], [1.3, 10]).bounding_box do
		text "Miesto: #{@event.city}", size: 10
	end
	grid([1.3, 10], [1.3, 19]).bounding_box do
		text "Termín: #{@event.from_to}", size: 10
	end
	# grid([1.3, 16], [1.3, 19]).bounding_box do
	# 	text "Čas (od/do):", size: 10
	# end
	if page != page_cnt
		grid_from = [1.5, 0]
		grid_to = [8, 19]
	else # 15 na stranu
		grid_from = [1.5, 0]
		grid_to = [5, 19]
	end
	grid(grid_from, grid_to).bounding_box do
		stroke_horizontal_rule
		move_down 10
# Tabulka
		font_size 8
		table_content = [["Číslo\nNumber", "Meno a Priezvisko\nName and Surname", "Obec trvalého pobytu\nPermanent residence", "Rok narodenia\nYear of Birth", "ID (len účastníci zo zahr.)\nID number", "Podpis*\nSignature*"]]
		from = (page - 1) * max_rows_per_full_page
		if page != page_cnt # max_rows = 22
			to = from + max_rows_per_full_page - 1
		else # max_rows = 15
			to = from + max_rows_per_page - 1
		end
		table_content += table_data[from..to]
		table(table_content,
		      cell_style: { overflow: :shrink_to_fit, size: 8, height: 17 },
		      column_widths: [bounds.width / 20, bounds.width * 4 / 20, bounds.width * 5 / 20, bounds.width * 3 / 20, bounds.width * 3 / 20, bounds.width * 4 / 20],
		      header: true) do
			row(0).style(height: 25)
		end
	end
	if page == page_cnt
		grid([6, 0], [7, 19]).bounding_box do
			text "* Súhlasím s použitím fotografií a/alebo iných audiovizuálnych záznamov vyrobených počas dobrovoľníckeho podujatia a obsahujúcich vyobrazenie, zvukový alebo audiovizuálny záznam mojej osoby, pre účely propagácie aktivít INEX Slovakia alebo dobrovoľníckych aktivít všeobecne, alebo pre účely dokladovania takýchto aktivít pre poskytovateľov grantov, darcov, podporovateľov a partnerov INEX Slovakia.
** Vyššie podpísaná dotknutá osoba svojím podpisom na tejto listine dáva v zmysle zákona č. 122/2013 Z. z. o ochrane osobných údajov a o zmene a doplnení niektorých zákonov v platnom znení (ďalej len \"zákon\") dobrovoľne výslovný súhlas hore uvedenému občianskemu združeniu so spracúvaním jej osobných údajov v rozsahu meno, priezvisko, obec trvalého bydliska, rok narodenia (pri zahr. účastníkoch aj ID) pre účely dokladovania dotácie MŠVVaŠ SR a spracovanie štatistických údajov. Zároveň vyhlasuje, že si je vedomá svojich práv vyplývajúcich zo zákona.
* I hereby consent to the usage of photographs and/or other audiovisual files recorded within the duration of the voluntary activity containing the imagery, audial or audiovisual records of myself for the purpose of promoting the activities of INEX Slovakia, or promotion of volunteering and voluntary activities in general, or for the purpose of documentation of the above-mentioned activities for providers of grants, donors, supporters and partners of INEX Slovakia.
** The undersigned person concerned, by signing the form with accordance to the Act No.122/2013 Z.z. of Data Privacy Policy, amending and supplementing certain acts as amended (hereafter \"Act\"), voluntarily gives an explicit permission to the above-mentioned organization (oz. INEX Slovakia) to process their personal data to the following extent: name, surname, place of permanent residence (city, town or village), year of birth (and ID number in the case of participants from abroad); for the purposes of documentation as a part of the endowment agreement between INEX Slovakia and the Ministry of Education, Science, Research and Sport of the Slovak Republic, and for statistical purposes. The undersigned hereby also declares that they are aware of their rights under the law.", size: 7
		end
		grid([7.7, 0], [7.7, 3.5]).bounding_box do
			text "Meno a priezvisko zodp. realizátora:", size: 11
		end
		grid([8, 4], [8, 8]).bounding_box do
			stroke_horizontal_rule
		end
		grid([7.85, 10], [7.85, 15]).bounding_box do
			text "Pečiatka organizácie:", size: 11
		end
	end
	grid([8, 18.75], [8, 19]).bounding_box do
		text "Strana #{page}"
	end
	start_new_page if page_cnt != page
end