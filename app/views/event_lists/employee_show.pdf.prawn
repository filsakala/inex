font Rails.root.join("public", "fonts", "DejaVuSans.ttf")
font_size 9
if @event_list.event_type.try(:title) == 'Prihlášky za člena'
	text "Prihláška za člena #{@event_list.created_at.year}", :size => 30
	text "(všetky údaje vyplňte čitateľne a paličkovým písmom)", :size => 20
	move_down 20

	text "Krstné meno: #{@event_list.name}", :size => 17
	text "Priezvisko: #{@event_list.surname}", :size => 17
	if !@event_list.birth_date.blank?
		text "Dátum narodenia: #{@event_list.birth_date.strftime("%d.%m.%Y")}", :size => 17
	end

	address = @event_list.addresses.where(title: 'permanent').take
	address = @event_list.addresses.first if !address && !@event_list.addresses.blank?
	if address
		text "Ulica a číslo: #{address.address}", :size => 17
		text "PSČ: #{address.postal_code}", :size => 17
		text "Obec: #{address.city}", :size => 17
	end

	text "Email: #{@event_list.personal_mail}", :size => 17
	text "Telefón: #{@event_list.personal_phone}", :size => 17
	text "Súhlasím, aby moje osobné údaje boli predložené členom komisie MŠ SR", :size => 10
	text "Súhlasím, aby moje osobné údaje boli použité na interné účely organizácie INEX Slovakia", :size => 10
else
	top_cursor = cursor
	#### TOP LOGO, NADPISY ###
	define_grid(:columns => 20, :rows => 10, :gutter => 0)
	grid([0, 0], [0, 4]).bounding_box do
		image Rails.root.join('app', 'assets', 'images', 'inex_logo_with_text_small.png'), :scale => 0.4
	end
	grid([0, 5], [0, 14]).bounding_box do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf") do
			text "VOLUNTEER EXCHANGE FORM (VEF)", align: :center, size: 13
		end
		move_down 2
		text "(PLEASE WRITE IN BLOCK CAPITALS AND ANSWER ALL QUESTIONS)", align: :center, size: 7
	end
	grid([0, 17], [0, 19]).bounding_box do
		move_down 2
		text "FOR OFFICIAL USE", align: :center, size: 7
		transparent(0.5) { stroke_bounds }
	end
	stroke_horizontal_rule

	### 1. Zakladne udaje ###
	move_down 5
	y_position = cursor
	bounding_box([0, y_position], :width => bounds.width / 19) do
		text "1."
	end
	bounding_box([bounds.width / 19, y_position], :width => 9 * bounds.width / 19) do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"), :style => :bold do
			text "SURNAME: #{@event_list.surname}"
		end
		text "Present address:"
		present_addresses = @event_list.addresses.where(title: 'Actual')
		permanent_addresses = @event_list.addresses.where(title: 'Permanent')
		if present_addresses.any?
			present_addresses.each do |address|
				text "#{address.address}, #{address.postal_code}, #{address.city}, #{address.country}"
			end
		else
			permanent_addresses.each do |address|
				text "#{address.address}, #{address.postal_code}, #{address.city}, #{address.country}"
			end
		end
		text "Phone: #{@event_list.personal_phone}"
		text "Email: #{@event_list.personal_mail}"
	end
	tmp_cursor = cursor
	bounding_box([10 * bounds.width / 19, y_position], width: 9 * bounds.width / 19) do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"), :style => :bold do
			text "FIRST NAME: #{@event_list.name}"
		end
		text "Permanent address (if different):"
		present_addresses = @event_list.addresses.where(title: 'Actual')
		permanent_addresses = @event_list.addresses.where(title: 'Permanent')
		if permanent_addresses.any?
			permanent_addresses.each do |address|
				text "#{address.address}, #{address.postal_code}, #{address.city}, #{address.country}"
			end
		else
			present_addresses.each do |address|
				text "#{address.address}, #{address.postal_code}, #{address.city}, #{address.country}"
			end
		end
		font Rails.root.join("public", "fonts", "DejaVuSans.ttf") do
			if @event_list.sex == 'M'
				text "\u2612 Male"
			else
				text "\u2610 Male"
			end
			if @event_list.sex == 'W' || @event_list.sex == 'Z' || @event_list.sex == 'Ž'
				text "\u2612 Female"
			else
				text "\u2610 Female"
			end
		end
	end
	move_cursor_to(tmp_cursor) if tmp_cursor < cursor

	### 2. Birthplace ###
	stroke_horizontal_rule
	move_down 5
	y_position = cursor
	bounding_box([0, y_position], :width => bounds.width / 19) do
		text "2."
	end
	bounding_box([bounds.width / 19, y_position], :width => 8 * bounds.width / 19) do
		if !@event_list.birth_date.blank?
			text "Birthdate: #{@event_list.birth_date.strftime("%d.%m.%Y")}"
		end
		text "Birthplace: #{@event_list.place_of_birth}"
		text "Nationality: #{@event_list.nationality}"
		text "Occupation: #{@event_list.occupation}"
	end

	### 3. EMERGENCY CONTACT ###
	tmp_cursor = cursor
	bounding_box([9 * bounds.width / 19, y_position], :width => bounds.width / 19) do
		text "3."
	end
	bounding_box([10 * bounds.width / 19, y_position], width: 9 * bounds.width / 19) do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"), :style => :bold do
			text "EMERGENCY CONTACT (during the camp duration):"
		end
		text "Name: #{@event_list.emergency_name}"
		text "Telephone: #{@event_list.emergency_phone}"
		text "Email: #{@event_list.emergency_mail}"
	end
	if tmp_cursor < cursor
		move_cursor_to tmp_cursor
	end

	### 4. LANGUAGES ###
	stroke_horizontal_rule
	move_down 5
	y_position = cursor
	bounding_box([0, y_position], :width => bounds.width / 19) do
		text "4."
	end
	bounding_box([bounds.width / 19, y_position], :width => 18 * bounds.width / 19) do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"), :style => :bold do
			text "LANGUAGES"
		end
		@event_list.language_skills.each do |ls|
			text "#{ls.try(:language).try(:name)} - #{ls.try(:level)}"
		end
	end

	### 5. PAST VOLUNTEER EXPERIENCES ###
	stroke_horizontal_rule
	move_down 5
	y_position = cursor
	bounding_box([0, y_position], :width => bounds.width / 19) do
		text "5."
	end
	bounding_box([bounds.width / 19, y_position], :width => 18 * bounds.width / 19) do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"), :style => :bold do
			text "PAST VOLUNTEER EXPERIENCES/GENERAL SKILLS (indicate the country, year and type of work)"
		end
	end
	span(bounds.width) do
		text @event_list.experiences
	end

	### 6. PROJECTS TABLE ###
	stroke_horizontal_rule
	move_down 5
	y_position = cursor
	bounding_box([0, y_position], :width => bounds.width / 19) do
		text "6."
	end
	bounding_box([bounds.width / 19, y_position], :width => 18 * bounds.width / 19) do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"), :style => :bold do
			text "PROJECT CHOICES ACCORDING TO PREFERENCE"
		end
	end
	y_position = cursor
	all_events = @event_list.events.select(:code, :title, :from, :to, :is_only_date)
	if @event_list.events.count == 1
		all_events_with_header = [["\#", "Code ", "Name", "Dates"]]
		all_events.each_with_index do |event, i|
			all_events_with_header << [(i + 1).to_s,
			                           event.code,
			                           event.title[0, 10],
			                           event.from_to]
		end
		table(all_events_with_header,
		      cell_style: { overflow: :shrink_to_fit, size: 8 },
		      column_widths: [bounds.width / 20, bounds.width * 3 / 20, bounds.width * 8 / 20, bounds.width * 8 / 20],
		      header: true)
	elsif @event_list.events.count > 1
		events_with_header = [["\#", "Code ", "Name", "Dates", "\#", "Code ", "Name", "Dates"]]
		all_events[0...(all_events.length/2.0).ceil].each_with_index do |event, i|
			events_with_header << [(i + 1).to_s,
			                       event.code,
			                       event.title[0, 10],
			                       event.from_to]
		end

		all_events[(all_events.length/2.0).ceil...all_events.length].each_with_index do |event, i|
			events_with_header[i+1] += [((all_events.length/2.0).ceil + i + 1).to_s,
			                            event.code,
			                            event.title[0, 10],
			                            event.from_to]
		end
		table(events_with_header,
		      :cell_style => { overflow: :shrink_to_fit, size: 8 },
		      header: true)
	end

	### 7. WHY ###
	move_down 5
	stroke_horizontal_rule
	move_down 5
	y_position = cursor
	bounding_box([0, y_position], :width => bounds.width / 19) do
		text "7."
	end
	bounding_box([bounds.width / 19, y_position], :width => 18 * bounds.width / 19) do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"), :style => :bold do
			text "WHY DO YOU WISH TO TAKE PART IN A VOLUNTEER PROJECT?"
		end
	end
	span(bounds.width) do
		text @event_list.why
	end

	### 8. REMARKS ON HEALTH ###
	stroke_horizontal_rule
	move_down 5
	y_position = cursor
	bounding_box([0, y_position], :width => bounds.width / 19) do
		text "8."
	end
	bounding_box([bounds.width / 19, y_position], :width => 18 * bounds.width / 19) do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"), :style => :bold do
			text "REMARKS ON HEALTH/SPECIAL NEEDS/DIET"
		end
	end
	span(bounds.width) do
		text @event_list.on_health
	end
	stroke_horizontal_rule

	### 9. GENERAL REMARKS ###
	move_down 5
	y_position = cursor
	bounding_box([0, y_position], :width => bounds.width / 19) do
		text "9."
	end
	bounding_box([bounds.width / 19, y_position], :width => 18 * bounds.width / 19) do
		font Rails.root.join("public", "fonts", "DejaVuSans-Bold.ttf"), :style => :bold do
			text "GENERAL REMARKS"
		end
	end
	span(bounds.width) do
		text @event_list.remarks
	end

	stroke_horizontal_rule
	move_down 5
	y_position = cursor

	span(bounds.width) do
		text "\u2611 Bol(a) som oboznámený(á) a súhlasím s podmienkami účasti na Medzinárodných táboroch dobrovoľníckej práce (MTDP), s finančnými podmienkami a podmienkami poistenia na MTDP. I accept the conditions of participation according to the programme of this organisation and I understand and accept the condition of health insurance on the workcamp."
	end
	move_down 5
	y_position = cursor

	bounding_box([0, y_position], :width => bounds.width / 2) do
		image_path = Rails.root.join('app', 'assets', 'images', 'inex_logo_with_text_small.png')
		table [[{ :image => image_path, scale: 0.9, borders: [:top, :left, :bottom] }, "INEX Slovakia\nProkopova 15\n851 01 Bratislava 5\nSlovakia\n\nTel.: +421 905 501 078\nemail: out@inex.sk, in@inex.sk\nwww.inex.sk"]], cell_style: { size: 10 }, column_widths: [bounds.width / 3, bounds.width / 1.6]
	end

	bounding_box([51 * bounds.width / 100, y_position], :width => 40 * bounds.width / 100) do
		text "Signature (signature of parent if you are under 18):"
		move_down 60
		text "Date:"
	end
end