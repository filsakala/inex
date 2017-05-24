# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

networks = PartnerNetwork.create([
                                   { name: 'Alliance', description: 'Great' },
                                   { name: 'SCI', description: 'WOW' },
                                   { name: 'Other', description: 'dunno' }
                                 ])

organizations = Organization.create([
                                      { name: 'INEX Slovakia', description: ':)', country: 'Slovakia' },
                                      { name: 'INEX SDA', description: '???', country: 'Czech Republic' }
                                    ])

organizations.first.contacts.create(name: 'Mirka', dept: 'Outgoing')
organizations.first.contacts.create(name: 'Barbi', dept: 'Incoming')

OrganizationInNetwork.create([
                               { organization: organizations.first, partner_network: networks.first },
                               { organization: organizations.first, partner_network: networks.second },
                               { organization: organizations.first, partner_network: networks.third }
                             ])

################################################################
set1 = SuperEventType.create(name: 'Dobrovoľnícke')
set2 = SuperEventType.create(name: 'Vzdelávacie')
set3 = SuperEventType.create(name: 'Promo dobrovoľníctva')
set4 = SuperEventType.create(name: 'Rozvoj medzinárodného dobrovoľníctva')
event_types = EventType.create([
                                 { title: 'Jednodňové dobrovoľnícke aktivity', super_event_type: set1 },
                                 { title: 'Víkendové dobrovoľnícke tábory',
                                   super_event_type: set1,
                                   fee_member_first: 73,
                                   fee_non_member_first: 95,
                                   fee_member_other: 50,
                                   fee_non_member_other: 70,
                                   fee_description: 'Člen prvý 73 + 2€ členské, ďalší 50, nečlen 95 prvý, 70 ďalší.',
                                   application_conditions_html: 'Toto sú podmienky účasti na tento typ eventu.',
                                   application_conditions_agreement_html: '<label>
        Súhlasím s použitím fotografií a/alebo iných audiovizuálnych záznamov
        vyrobených počas dobrovoľníckeho podujatia a obsahujúcich vyobrazenie,
        zvukový alebo audiovizuálny záznam mojej osoby, pre účely propagácie
        aktivít INEX Slovakia alebo dobrovoľníckych aktivít všeobecne, alebo pre
        účely dokladovania takýchto aktivít pre poskytovateľov grantov, darcov,
        podporovateľov a partnerov INEX
        Slovakia.<i class="small red asterisk icon"></i>
      </label>
      <label>
        Vyššie podpísaná dotknutá osoba svojím podpisom na tejto listine dáva v
        zmysle zákona č. 122/2013 Z. z. o ochrane osobných údajov a o zmene a
        doplnení niektorých zákonov v platnom znení (ďalej len "zákon")
        dobrovoľne výslovný súhlas hore uvedenému občianskemu združeniu so
        spracúvaním jej osobných údajov v rozsahu meno, priezvisko, adresa
        bydliska, dátum a rok narodenia (pri zahr. účastníkoch aj ID) pre
        účely dokladovania dotácie MŠVVaŠ SR a spracovanie štatistických údajov.
        Zároveň vyhlasuje, že si je vedomá svojich práv vyplývajúcich zo zákona.<i class="small red asterisk icon"></i>
      </label>
      <label>
        I hereby consent to the usage of photographs and/or other audiovisual
        files recorded within the duration of the voluntary activity containing
        the imagery, audial or audiovisual records of myself for the purpose of
        promoting the activities of INEX Slovakia, or promotion of volunteering
        and voluntary activities in general, or for the purpose of documentation
        of the above-mentioned activities for providers of grants, donors,
        supporters and partners of INEX
        Slovakia.<i class="small red asterisk icon"></i>
      </label>
      <label>The undersigned person concerned, by signing the form with
        accordance to the Act No.122/2013 Z.z. of Data Privacy Policy, amending
        and supplementing certain acts as amended (hereafter "Act"), voluntarily
        gives an explicit permission to the above-mentioned organization (oz.
        INEX Slovakia) to process their personal data to the following extent:
        name, surname, home address, date and year of birth (and ID number in
        the case of participants from abroad); for the purposes of documentation
        as a part of the endowment agreement between INEX Slovakia and the
        Ministry of Education, Science, Research and Sport of the Slovak
        Republic, and for statistical purposes. The undersigned hereby also
        declares that they are aware of their rights under the
        law.<i class="small red asterisk icon"></i>
      </label>',
                                   application_info_html: '<div class="ui yellow icon message">
  <i class="warning sign icon"></i>
  <div class="content">
    <div class="header">
      Pre prihlášku na workcamp či špeciálny projekt platia tieto
      pravidlá:
    </div>
    <div class="ui bulleted list">
      <div class="item">Vypisuj ju v anglickom jazyku.</div>
      <div class="item">Kliknutím na tlačidlo "Send application" súhlasíš
        s Podmienkami účasti na MTDP. Bol(a) si oboznámený(á) s
        Podmienkami
        účasti na workcamp, týmto podmienkam rozumieš a súhlasíš s nimi.
      </div>
      <div class="item">Ak si želáš byť členom INEXu, na konci prihlášky
        zašktrtni tlačidlo
        "I want to be an INEX member". Hlavnou výhodou je znížená suma
        účastníckeho príspevku na workcamp z 95 € na 75 €, a to vrátane
        členského.
      </div>
      <div class="item">Po vypísaní prihlášky treba uhradiť účastnícky
        príspevok (95€/75€) na náš účet alebo osobne v kancelárii
        INEX-u. Do popisu platby treba uviesť svoje meno a priezvisko pre
        ľahšiu identifikáciu.
        <p>
          Náš účet: 2667455125/1100 alebo v tvare IBAN: SK26 1100 0000
          0026 6745 5125 (Tatrabanka).</p>
      </div>
      <div class="item">Pre urýchlenie vybavovania prihlášky do zahraničia
        je odporúčané poslať potvrdenie z banky o odoslaní účastníckeho
        poplatku na náš účet. A to na e-mail
        <a href="mailto:out@inex.sk">out@inex.sk</a>.
      </div>
      <div class="item">Prihláška je záväzná a začína sa vybavovať až po
        uhradení účastníckeho príspevku.
      </div>
    </div>
  </div>
</div>'
                                 },
                                 { title: 'Vzdelávanie vedúcich medzinárodných dobrovoľníckych táborov', super_event_type: set2 },
                                 { title: 'Prihlášky za člena',
                                   fee_member_first: 0,
                                   fee_non_member_first: 2,
                                   fee_member_other: 0,
                                   fee_non_member_other: 0, },
                                 { title: 'EDS', super_event_type: set1 }
                               ])

event_categories = EventCategory.create([
                                          { name: 'Agriculture', abbr: 'AGRI' },
                                          { name: 'Archaelogy', abbr: 'ARCH' },
                                          { name: 'Art', abbr: 'ART' },
                                          { name: 'Construction', abbr: '???' },
                                          { name: 'Cultural heritage', abbr: '???' },
                                          { name: 'Disabled', abbr: '???' },
                                          { name: 'Disaster relief', abbr: '???' },
                                          { name: 'Environment', abbr: '???' },
                                          { name: 'Festival', abbr: '???' },
                                          { name: 'Language study', abbr: '???' },
                                          { name: 'Manual', abbr: '???' },
                                          { name: 'Medical', abbr: '???' },
                                          { name: 'Peace', abbr: '???' },
                                          { name: 'Restoration, renovation', abbr: '???' },
                                          { name: 'Social', abbr: '???' },
                                          { name: 'Sport', abbr: '???' },
                                          { name: 'Study, discussion, research', abbr: '???' },
                                          { name: 'Teaching', abbr: '???' },
                                          { name: 'Work with animals', abbr: '???' },
                                          { name: 'Work with kids', abbr: '???' },
                                          { name: 'Work with the eldery', abbr: '???' },
                                          { name: 'Yoga', abbr: '???' }
                                        ])

events = Event.create([
                        { title: 'Naše mesto - Integra', from: Date.today, to: Date.tomorrow, organization: organizations.first, event_type: event_types.first, country: 'Slovakia', capacity_total: 10, capacity_men: 5, capacity_women: 5, free_total: 10, free_men: 5, free_women: 5, is_published: true },
                        { title: 'Naše mesto - INEX', from: Date.today, to: Date.tomorrow, organization: organizations.first, event_type: event_types.first, country: 'Slovakia', capacity_total: 10, capacity_men: 5, capacity_women: 5, free_total: 10, free_men: 5, free_women: 5, is_published: true },
                        { title: 'Jarné upratovanie', from: Date.today, to: Date.tomorrow, organization: organizations.first, event_type: event_types.first, country: 'Slovakia' },
                        { title: 'Víkendový workcamp', from: Date.today, to: Date.tomorrow, organization: organizations.second, event_type: event_types.second, country: 'Slovakia' },
                        { title: 'Stretko', from: Date.parse('01-01-1993'), to: Date.parse('01-01-1993'), organization: organizations.first, event_type: event_types.first, country: 'Slovakia' },
                        { title: 'Stretko', from: Date.parse('01-01-2000'), to: Date.parse('01-01-2000'), organization: organizations.first, event_type: event_types.first, country: 'Slovakia' },
                        { title: 'Silvester', from: Date.parse('31-12-2014'), to: Date.parse('02-01-2015'), organization: organizations.first, event_type: event_types.first, country: 'Slovakia' },
                        { title: 'Prihlášky za člena', organization: organizations.first, event_type: event_types.fourth, is_published: false },
                      ])

events_with_categories = EventWithCategory.create([
                                                    { event_category: event_categories.first, event: events.first },
                                                    { event_category: event_categories.first, event: events.fourth },
                                                  ])

extra_fees = ExtraFee.create([
                               { event: events.first, amount: 100, currency: "EUR" },
                               { event: events.fourth, amount: 250, currency: "EUR" }
                             ])

employees = Employee.create([
                              { department: 'outgoing', work_mail: 'out@inex.sk' },
                              # { department: 'incoming', work_mail: 'inex@inex.sk' },
                              # { department: 'finance', work_mail: 'finance@inex.sk' },
                              # { department: 'EVS', work_mail: 'evs@inex.sk' }
                            ])

# Tasks
tasks = Task.create([
                      { employee: employees.first, title: 'Urguj!' },
                      { employee: employees.second, title: 'Tábor Brekov' }
                    ])

task_lists = TaskList.create([
                               { task: tasks.first, title: 'Otvor Outlook', state: 'dokončená' },
                               { task: tasks.first, title: 'Napíš mail', state: 'nedokončená' },
                               { task: tasks.first, title: 'Odošli', state: 'nedokončená' },
                               { task: tasks.second, title: 'Acceptance letter sent?', state: 'dokončená' },
                               { task: tasks.second, title: 'Dohodnutá cesta?', state: 'dokončená' },
                               { task: tasks.second, title: 'Infosheet?', state: 'nedokončená' }
                             ])

# Contact list
contact_lists = ContactList.create([
                                     { title: 'Incoming', employee: employees.second },
                                     { title: 'Outgoing', employee: employees.first },
                                   ])

contacts = Contact.create([
                            { name: 'Ján', nickname: 'Johnny', mail: 'johnny@gmail.me' },
                            { name: 'AAA', nickname: 'AAAAAA', mail: 'aaa@gmail.me' },
                            { name: 'BBB', nickname: 'BBBBBBB', mail: 'bbbb@gmail.me' },
                            { name: 'CCC', nickname: 'CCCCC', mail: 'ccccc@gmail.me' }
                          ])

# Knowledge
knowledges = Knowledge.create([
                                { title: 'Ako pridávať veci na web', text: 'Easy nie?' },
                                { title: 'Ako na Incoming', text: 'Easy nie?' },
                                { title: 'Ako na Outgoing', text: 'Easy nie?' },
                                { title: 'Ako na EDS', text: 'Easy nie?' }
                              ])

knowledge_emps = EmployeeWithKnowledge.create([
                                                { employee: employees.first, knowledge: knowledges.first },
                                                { employee: employees.second, knowledge: knowledges.second },
                                                { employee: employees.first, knowledge: knowledges.third },
                                                { employee: employees.fifth, knowledge: knowledges.fourth }
                                              ])

knowledge_category = KnowledgeCategory.create([
                                                { category: 'web' },
                                                { category: 'incoming' },
                                                { category: 'outgoing' },
                                                { category: 'eds' },
                                                { category: 'kancelária' },
                                              ])

knowledge_with_tags = KnowledgeInCategory.create([
                                                   { knowledge: knowledges.first, knowledge_category: knowledge_category.first },
                                                   { knowledge: knowledges.second, knowledge_category: knowledge_category.second },
                                                   { knowledge: knowledges.third, knowledge_category: knowledge_category.third },
                                                   { knowledge: knowledges.fourth, knowledge_category: knowledge_category.fourth },
                                                   { knowledge: knowledges.fourth, knowledge_category: knowledge_category.fifth },
                                                 ])
# users
user = User.new(login_mail: 'test@test.test', password_digest: '$2a$10$BUqvKf5QcuEr5a3dhQ0uFubxpIzYXWqqkKobiD.duWdSYuCkvnjfu', role: 'employee', nickname: 'Mirka', name: 'Mirka', surname: 'Mirka')
employees.first.update(user: user)
user.save(validate: false)
user = User.new(login_mail: 'test2@test.test', password_digest: '$2a$10$BUqvKf5QcuEr5a3dhQ0uFubxpIzYXWqqkKobiD.duWdSYuCkvnjfu', name: '???', surname: '???')
user.save(validate: false)

# events.first.leaders.create(user: user)
# events.first.trainers.create(user: user)

user = User.new(login_mail: 'philipiny@gmail.com', password_digest: '$2a$10$BUqvKf5QcuEr5a3dhQ0uFubxpIzYXWqqkKobiD.duWdSYuCkvnjfu', role: 'employee', nickname: 'Barbi', name: 'Barbi', surname: 'Barbi')
employees.second.update(user: user)
user.save(validate: false)
user = User.new(login_mail: 'test4@test.test', password_digest: '$2a$10$BUqvKf5QcuEr5a3dhQ0uFubxpIzYXWqqkKobiD.duWdSYuCkvnjfu', role: 'employee', nickname: 'Majka', name: 'Majka', surname: 'Majka')
employees.third.update(user: user)
user.save(validate: false)

# events.first.local_partners.create(user: user)
# events.first.trainers.create(user: user)

user = User.new(login_mail: 'test5@test.test', password_digest: '$2a$10$BUqvKf5QcuEr5a3dhQ0uFubxpIzYXWqqkKobiD.duWdSYuCkvnjfu', role: 'employee', nickname: 'Domča', name: 'Domča', surname: 'Domča')
employees.fourth.update(user: user)
user.save(validate: false)

# events.first.leaders.create(user: user)
# events.first.local_partners.create(user: user)

#countries
Country.create([
                 { name: "Andorra", flag_code: "ad" },
                 { name: "United Arab Emirates", flag_code: "ae" },
                 { name: "Afghanistan", flag_code: "af" },
                 { name: "Antigua", flag_code: "ag" },
                 { name: "Anguilla", flag_code: "ai" },
                 { name: "Albania", flag_code: "al" },
                 { name: "Armenia", flag_code: "am" },
                 { name: "Netherlands Antilles", flag_code: "an" },
                 { name: "Angola", flag_code: "ao" },
                 { name: "Argentina", flag_code: "ar" },
                 { name: "American Samoa", flag_code: "as" },
                 { name: "Austria", flag_code: "at" },
                 { name: "Australia", flag_code: "au" },
                 { name: "Aruba", flag_code: "aw" },
                 { name: "Aland Islands", flag_code: "ax" },
                 { name: "Azerbaijan", flag_code: "az" },
                 { name: "Bosnia", flag_code: "ba" },
                 { name: "Barbados", flag_code: "bb" },
                 { name: "Bangladesh", flag_code: "bd" },
                 { name: "Belgium", flag_code: "be" },
                 { name: "Burkina Faso", flag_code: "bf" },
                 { name: "Bulgaria", flag_code: "bg" },
                 { name: "Bahrain", flag_code: "bh" },
                 { name: "Burundi", flag_code: "bi" },
                 { name: "Benin", flag_code: "bj" },
                 { name: "Bermuda", flag_code: "bm" },
                 { name: "Brunei", flag_code: "bn" },
                 { name: "Bolivia", flag_code: "bo" },
                 { name: "Brazil", flag_code: "br" },
                 { name: "Bahamas", flag_code: "bs" },
                 { name: "Bhutan", flag_code: "bt" },
                 { name: "Bouvet Island", flag_code: "bv" },
                 { name: "Botswana", flag_code: "bw" },
                 { name: "Belarus", flag_code: "by" },
                 { name: "Belize", flag_code: "bz" },
                 { name: "Canada", flag_code: "ca" },
                 { name: "Cocos Islands", flag_code: "cc" },
                 { name: "Congo", flag_code: "cd" },
                 { name: "Central African Republic", flag_code: "cf" },
                 { name: "Congo Brazzaville", flag_code: "cg" },
                 { name: "Switzerland", flag_code: "ch" },
                 { name: "Cote Divoire", flag_code: "ci" },
                 { name: "Cook Islands", flag_code: "ck" },
                 { name: "Chile", flag_code: "cl" },
                 { name: "Cameroon", flag_code: "cm" },
                 { name: "China", flag_code: "cn" },
                 { name: "Colombia", flag_code: "co" },
                 { name: "Costa Rica", flag_code: "cr" },
                 { name: "Serbia", flag_code: "cs" },
                 { name: "Cuba", flag_code: "cu" },
                 { name: "Cape Verde", flag_code: "cv" },
                 { name: "Christmas Island", flag_code: "cx" },
                 { name: "Cyprus", flag_code: "cy" },
                 { name: "Czech Republic", flag_code: "cz" },
                 { name: "Germany", flag_code: "de" },
                 { name: "Djibouti", flag_code: "dj" },
                 { name: "Denmark", flag_code: "dk" },
                 { name: "Dominica", flag_code: "dm" },
                 { name: "Dominican Republic", flag_code: "do" },
                 { name: "Algeria", flag_code: "dz" },
                 { name: "Ecuador", flag_code: "ec" },
                 { name: "Estonia", flag_code: "ee" },
                 { name: "Egypt", flag_code: "eg" },
                 { name: "Western Sahara", flag_code: "eh" },
                 { name: "Eritrea", flag_code: "er" },
                 { name: "Spain", flag_code: "es" },
                 { name: "Ethiopia", flag_code: "et" },
                 { name: "European Union", flag_code: "eu" },
                 { name: "Finland", flag_code: "fi" },
                 { name: "Fiji", flag_code: "fj" },
                 { name: "Falkland Islands", flag_code: "fk" },
                 { name: "Micronesia", flag_code: "fm" },
                 { name: "Faroe Islands", flag_code: "fo" },
                 { name: "France", flag_code: "fr" },
                 { name: "Gabon", flag_code: "ga" },
                 { name: "United Kingdom", flag_code: "gb" },
                 { name: "Grenada", flag_code: "gd" },
                 { name: "Georgia", flag_code: "ge" },
                 { name: "French Guiana", flag_code: "gf" },
                 { name: "Ghana", flag_code: "gh" },
                 { name: "Gibraltar", flag_code: "gi" },
                 { name: "Greenland", flag_code: "gl" },
                 { name: "Gambia", flag_code: "gm" },
                 { name: "Guinea", flag_code: "gn" },
                 { name: "Guadeloupe", flag_code: "gp" },
                 { name: "Equatorial Guinea", flag_code: "gq" },
                 { name: "Greece", flag_code: "gr" },
                 { name: "Sandwich Islands", flag_code: "gs" },
                 { name: "Guatemala", flag_code: "gt" },
                 { name: "Guam", flag_code: "gu" },
                 { name: "Guinea-bissau", flag_code: "gw" },
                 { name: "Guyana", flag_code: "gy" },
                 { name: "Hong Kong", flag_code: "hk" },
                 { name: "Heard Island", flag_code: "hm" },
                 { name: "Honduras", flag_code: "hn" },
                 { name: "Croatia", flag_code: "hr" },
                 { name: "Haiti", flag_code: "ht" },
                 { name: "Hungary", flag_code: "hu" },
                 { name: "Indonesia", flag_code: "id" },
                 { name: "Ireland", flag_code: "ie" },
                 { name: "Israel", flag_code: "il" },
                 { name: "India", flag_code: "in" },
                 { name: "Indian Ocean Territory", flag_code: "io" },
                 { name: "Iraq", flag_code: "iq" },
                 { name: "Iran", flag_code: "ir" },
                 { name: "Iceland", flag_code: "is" },
                 { name: "Italy", flag_code: "it" },
                 { name: "Jamaica", flag_code: "jm" },
                 { name: "Jordan", flag_code: "jo" },
                 { name: "Japan", flag_code: "jp" },
                 { name: "Kenya", flag_code: "ke" },
                 { name: "Kyrgyzstan", flag_code: "kg" },
                 { name: "Cambodia", flag_code: "kh" },
                 { name: "Kiribati", flag_code: "ki" },
                 { name: "Comoros", flag_code: "km" },
                 { name: "Saint Kitts And Nevis", flag_code: "kn" },
                 { name: "North Korea", flag_code: "kp" },
                 { name: "South Korea", flag_code: "kr" },
                 { name: "Kuwait", flag_code: "kw" },
                 { name: "Cayman Islands", flag_code: "ky" },
                 { name: "Kazakhstan", flag_code: "kz" },
                 { name: "Laos", flag_code: "la" },
                 { name: "Lebanon", flag_code: "lb" },
                 { name: "Saint Lucia", flag_code: "lc" },
                 { name: "Liechtenstein", flag_code: "li" },
                 { name: "Sri Lanka", flag_code: "lk" },
                 { name: "Liberia", flag_code: "lr" },
                 { name: "Lesotho", flag_code: "ls" },
                 { name: "Lithuania", flag_code: "lt" },
                 { name: "Luxembourg", flag_code: "lu" },
                 { name: "Latvia", flag_code: "lv" },
                 { name: "Libya", flag_code: "ly" },
                 { name: "Morocco", flag_code: "ma" },
                 { name: "Monaco", flag_code: "mc" },
                 { name: "Moldova", flag_code: "md" },
                 { name: "Montenegro", flag_code: "me" },
                 { name: "Madagascar", flag_code: "mg" },
                 { name: "Marshall Islands", flag_code: "mh" },
                 { name: "Macedonia", flag_code: "mk" },
                 { name: "Mali", flag_code: "ml" },
                 { name: "Myanmar", flag_code: "mm" },
                 { name: "Mongolia", flag_code: "mn" },
                 { name: "Macau", flag_code: "mo" },
                 { name: "Northern Mariana Islands", flag_code: "mp" },
                 { name: "Martinique", flag_code: "mq" },
                 { name: "Mauritania", flag_code: "mr" },
                 { name: "Montserrat", flag_code: "ms" },
                 { name: "Malta", flag_code: "mt" },
                 { name: "Mauritius", flag_code: "mu" },
                 { name: "Maldives", flag_code: "mv" },
                 { name: "Malawi", flag_code: "mw" },
                 { name: "Mexico", flag_code: "mx" },
                 { name: "Malaysia", flag_code: "my" },
                 { name: "Mozambique", flag_code: "mz" },
                 { name: "Namibia", flag_code: "na" },
                 { name: "New Caledonia", flag_code: "nc" },
                 { name: "Niger", flag_code: "ne" },
                 { name: "Norfolk Island", flag_code: "nf" },
                 { name: "Nigeria", flag_code: "ng" },
                 { name: "Nicaragua", flag_code: "ni" },
                 { name: "Netherlands", flag_code: "nl" },
                 { name: "Norway", flag_code: "no" },
                 { name: "Nepal", flag_code: "np" },
                 { name: "Nauru", flag_code: "nr" },
                 { name: "Niue", flag_code: "nu" },
                 { name: "New Zealand", flag_code: "nz" },
                 { name: "Oman", flag_code: "om" },
                 { name: "Panama", flag_code: "pa" },
                 { name: "Peru", flag_code: "pe" },
                 { name: "French Polynesia", flag_code: "pf" },
                 { name: "New Guinea", flag_code: "pg" },
                 { name: "Philippines", flag_code: "ph" },
                 { name: "Pakistan", flag_code: "pk" },
                 { name: "Poland", flag_code: "pl" },
                 { name: "Saint Pierre", flag_code: "pm" },
                 { name: "Pitcairn Islands", flag_code: "pn" },
                 { name: "Puerto Rico", flag_code: "pr" },
                 { name: "Palestine", flag_code: "ps" },
                 { name: "Portugal", flag_code: "pt" },
                 { name: "Palau", flag_code: "pw" },
                 { name: "Paraguay", flag_code: "py" },
                 { name: "Qatar", flag_code: "qa" },
                 { name: "Reunion", flag_code: "re" },
                 { name: "Romania", flag_code: "ro" },
                 { name: "Serbia", flag_code: "rs" },
                 { name: "Russia", flag_code: "ru" },
                 { name: "Rwanda", flag_code: "rw" },
                 { name: "Saudi Arabia", flag_code: "sa" },
                 { name: "Solomon Islands", flag_code: "sb" },
                 { name: "Seychelles", flag_code: "sc" },
                 { name: "Sudan", flag_code: "sd" },
                 { name: "Sweden", flag_code: "se" },
                 { name: "Singapore", flag_code: "sg" },
                 { name: "Saint Helena", flag_code: "sh" },
                 { name: "Slovenia", flag_code: "si" },
                 { name: "Svalbard", flag_code: "sj" },
                 { name: "Slovakia", flag_code: "sk" },
                 { name: "Sierra Leone", flag_code: "sl" },
                 { name: "San Marino", flag_code: "sm" },
                 { name: "Senegal", flag_code: "sn" },
                 { name: "Somalia", flag_code: "so" },
                 { name: "Suriname", flag_code: "sr" },
                 { name: "Sao Tome", flag_code: "st" },
                 { name: "El Salvador", flag_code: "sv" },
                 { name: "Syria", flag_code: "sy" },
                 { name: "Swaziland", flag_code: "sz" },
                 { name: "Caicos Islands", flag_code: "tc" },
                 { name: "Chad", flag_code: "td" },
                 { name: "French Territories", flag_code: "tf" },
                 { name: "Togo", flag_code: "tg" },
                 { name: "Thailand", flag_code: "th" },
                 { name: "Tajikistan", flag_code: "tj" },
                 { name: "Tokelau", flag_code: "tk" },
                 { name: "Timorleste", flag_code: "tl" },
                 { name: "Turkmenistan", flag_code: "tm" },
                 { name: "Tunisia", flag_code: "tn" },
                 { name: "Tonga", flag_code: "to" },
                 { name: "Turkey", flag_code: "tr" },
                 { name: "Trinidad", flag_code: "tt" },
                 { name: "Tuvalu", flag_code: "tv" },
                 { name: "Taiwan", flag_code: "tw" },
                 { name: "Tanzania", flag_code: "tz" },
                 { name: "Ukraine", flag_code: "ua" },
                 { name: "Uganda", flag_code: "ug" },
                 { name: "Us Minor Islands", flag_code: "um" },
                 { name: "United States", flag_code: "us" },
                 { name: "Uruguay", flag_code: "uy" },
                 { name: "Uzbekistan", flag_code: "uz" },
                 { name: "Vatican City", flag_code: "va" },
                 { name: "Saint Vincent", flag_code: "vc" },
                 { name: "Venezuela", flag_code: "ve" },
                 { name: "British Virgin Islands", flag_code: "vg" },
                 { name: "Us Virgin Islands", flag_code: "vi" },
                 { name: "Vietnam", flag_code: "vn" },
                 { name: "Vanuatu", flag_code: "vu" },
                 { name: "Wallis And Futuna", flag_code: "wf" },
                 { name: "Samoa", flag_code: "ws" },
                 { name: "Yemen", flag_code: "ye" },
                 { name: "Mayotte", flag_code: "yt" },
                 { name: "South Africa", flag_code: "za" },
                 { name: "Zambia", flag_code: "zm" },
                 { name: "Zimbabwe", flag_code: "zw" }
               ])

HtmlArticle.create([
                     { category: 'o_nas', title: 'INEX', content: '<h1><span style="font-weight: normal; font-size: 2rem; line-height: 1.2857em;">INEX Slovakia (INternational EXchanges)</span><span style="font-weight: normal;"></span></h1><p> </p><p><span style="font-weight: normal;">Sme neziskovou organizáciou a snažíme sa pomôcť mladým ľuďom v ich osobnostnom rozvoji prostredníctvom medzinárodného dobrovoľníctva, neformálneho vzdelávania a zmysluplného prežívania voľného času.&nbsp;</span><span style="line-height: 1.4285em;">Veríme, že našou budúcnosťou sú aktívni ľudia so zdravým sebavedomím, toleranciou, kritickým myslením, všeobecným prehľadom a ochotou pomôcť svojmu okoliu.</span></p><p> </p><p><span style="font-weight: normal;">Na Slovensku sme jedinou organizáciou svojho druhu od roku 1993.&nbsp;</span><span style="line-height: 1.4285em;">Naše aktivity sú pre mladých ľudí, lídrov, pracovníkov s mládežou, dobrovoľníkov, ale i širšiu verejnosť.&nbsp;</span><span style="line-height: 1.4285em;">Vďaka členstvu v medzinárodných sieťach Alliance of European Voluntary Service Organisations a Service Civil International ponúkame dobrovoľníkom viac ako 2000 projektov v 80 krajinách sveta. Našou strešnou organizáciou na Slovensku je Rada mládeže Slovenska.</span></p><div><br></div><p></p>' },
                     { category: 'o_nas', title: 'Náš tím', content: '<h1><span style="font-weight: normal; font-size: 2rem; line-height: 1.2857em;">Náš tím – kancelária + EVS + inexáčik+ pracovné skupiny</span><span style="font-weight: normal;"></span></h1><p><span style="font-weight: normal;">Fotka + 2 vety</span></p><p><span style="font-weight: normal;">Inexáčik</span></p><h2><span style="font-weight: normal;">Promo tím:</span></h2><p><span style="font-weight: normal;">Tvorí ho skupina dobrovoľníkov, ktorí sa v minulosti zúčastnili našich aktivít. Chcú, aby sa o dobrovoľníctve dozvedelo, čo najviac ľudí nielen od kamarátov, známych. Vytvárajú informačné materiály, chodia prezentovať na školy, festivaly, udalosti.</span></p><p><span style="font-weight: normal;">Venuješ sa marketingu, grafike, tvorbe videí, foteniu a chceš mať prax do životopisu?</span></p><p><span style="font-weight: normal;"></span></p><span class="red"><p><span style="font-weight: normal;"></span></p><span class="large-bold"><p><span style="font-weight: normal;"></span></p>Napíš nám na out@inex.sk a pridaj sa do tímu.&nbsp;</span></span><div><span style="font-size: 1.714rem; font-weight: bold; line-height: 1.2857em;"><br></span></div><div><span style="font-size: 1.714rem; line-height: 1.2857em;">Školiteľský tím</span><br></div><div><span class="red"><span class="large-bold"><br></span></span></div><div><span class="red"><span class="large-bold">Naši školitelia nie sú žiadni sivobradí starci. Sú to mladí ľudia, z ktorých mnohí sa zúčastnili rôznych školení doma i v zahraničí. &nbsp;Školia nových lídrov medzinárodných dobrovoľníckych táborov. Školiteľský tím je len na pozvánku :) takže ak si myslíš, že tam patríš, musíš sa snažiť.<span style="font-weight: normal;"><span class="blue"></span></span></span><span style="font-weight: normal;"><span class="blue"></span></span></span><span style="font-weight: normal;"><span class="blue"></span><span class="large-bold"></span></span><br><p></p></div>' },
                     { category: 'o_nas', title: 'Partneri', content: '<h1><span style="font-weight: normal; font-size: 2rem; line-height: 1.2857em;">Členstvo v sietiach</span><span style="font-weight: normal;"></span></h1><p><span style="font-weight: normal;">Členstvo a partnerstvo v sietiach je pre nás kľúčové. Na základe nich prichádza k výmene dobrovoľníkov po celom svete a dodržiavanie štandardov jednotlivých projektov. Kvalita projektov je pre nás dôležitejšia než kvantita.</span></p><p><span style="font-weight: normal;">logo alliance, SCI, RMS</span></p><p><span style="font-weight: normal;">Alliance of European Voluntary Service Organisations je medzinárodná organizácia. Zastrešuje organizácie z Európy, Ameriky a Ázie. Jej členom sme od roku 1993. Zúčastňujeme sa medzinárodných stretnutí Technical Meeting (v marci - kedy sa dozvieme program workcampov na leto) a General Assembly (v novembri - kedy sa rozhoduje o ďaľšom smerovaní siete).</span></p><p><span style="font-weight: normal;">Service Civil International je dobrovoľnícka organizácia. Venuje sa propagácii mieru organizovaním medzinárodných dobrovoľníckych projektov pre ľudí bez rozdielu veku a príslušnosti. INEX je partnerom od roku 1994.</span></p><p><span style="font-weight: normal;">Rada mládeže Slovenska &nbsp;je našou strešnou organizáciou na Slovensku od roku 1993.</span></p>' },
                     { category: 'aktivity', title: 'Dobrovoľnícke', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'aktivity', title: 'Vzdelávacie', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'aktivity', title: 'Promo', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'aktivity', title: 'Rozvoj dobrovoľníctva', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'pomoz', title: 'Ako dobrovoľník', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'pomoz', title: 'Ako účastník školení', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'pomoz_financne', title: 'Na účet', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'pomoz_financne', title: '2%', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'media', title: 'Napísali o nás', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'media', title: 'Publikácie', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'media', title: 'Výročné správy', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'media', title: 'Logá', content: '<h1>Default Content</h1> <p>Hello world</p>' },
                     { category: 'footer', content: '<h4>Copyright © 2017 INEX Slovakia</h4>' },
                     { category: 'kontakty_adresa', content: '<h4>INEX Slovakia - občianske združenie</h4>Prokopova 15<br>851 01 Bratislava 5<br>Slovenská republika' },
                     { category: 'kontakty_cislo', content: '+421 905 501 078' },
                     { category: 'kontakty_ico', content: '30804027' },
                     { category: 'kontakty_ucet', content: 'IBAN: SK2611000000002667455125 (účet je vedený v Tatrabanke).' },
                     { category: 'kontakty_otvaracie_description', content: ' v období 01.02.2016 - 31.07.2016' },
                     { category: 'kontakty_otvaracie_pon', content: '<i class="red large meh icon"></i>zatvorené' },
                     { category: 'kontakty_otvaracie_uto', content: '<i class="green large wait icon"></i>10:00 - 16:30' },
                     { category: 'kontakty_otvaracie_str', content: '<i class="green large wait icon"></i>11:00 - 15:00' },
                     { category: 'kontakty_otvaracie_stv', content: '<i class="green large wait icon"></i>10:00 - 16:30' },
                     { category: 'kontakty_otvaracie_pia', content: '<i class="red large meh icon"></i>zatvorené' },
                     { category: 'kontakty_otvaracie_vik', content: '<i class="red large meh icon"></i>zatvorené' },
                     { category: 'kontakty_person_incoming_name', content: 'Barbi' },
                     { category: 'kontakty_person_incoming_mail', content: 'inex@inex.sk' },
                     { category: 'kontakty_person_incoming_number', content: '0909090909' },
                     { category: 'kontakty_person_incoming_description', content: 'Joined in 2013' },
                     { category: 'kontakty_person_incoming_description2', content: '<div class="left aligned item"><i class="arrow right icon"></i>Vec</div><div class="left aligned item"><i class="arrow right icon"></i>Vec</div><div class="left aligned item"><i class="arrow right icon"></i>Vec</div>' },
                     { category: 'kontakty_person_outgoing_name', content: 'Mirka' },
                     { category: 'kontakty_person_outgoing_mail', content: 'out@inex.sk' },
                     { category: 'kontakty_person_outgoing_number', content: '0909090909' },
                     { category: 'kontakty_person_outgoing_description', content: 'Joined in 2013' },
                     { category: 'kontakty_person_outgoing_description2', content: '<div class="left aligned item"><i class="arrow right icon"></i>Vec</div><div class="left aligned item"><i class="arrow right icon"></i>Vec</div><div class="left aligned item"><i class="arrow right icon"></i>Vec</div>' },
                     { category: 'kontakty_person_eds_name', content: 'Monika' },
                     { category: 'kontakty_person_eds_mail', content: 'evs@inex.sk' },
                     { category: 'kontakty_person_eds_number', content: '0909090909' },
                     { category: 'kontakty_person_eds_description', content: 'Joined in 2013' },
                     { category: 'kontakty_person_eds_description2', content: '<div class="left aligned item"><i class="arrow right icon"></i>Vec</div><div class="left aligned item"><i class="arrow right icon"></i>Vec</div><div class="left aligned item"><i class="arrow right icon"></i>Vec</div>' },
                     { category: 'faq', content: 'FAQ page' },
                     { category: 'membership', content: 'Membership page' },
                     { category: 'terms_and_conditions', content: 'Conditions page' },
                   ])

HomepageCard.create([
                      { title: "Title 1", url: "http://facebook.com", is_visible: true },
                      { title: "Title 2", url: "http://facebook.com", is_visible: true },
                      { title: "Title 3", url: "http://facebook.com", is_visible: false },
                      { title: "Title 4", url: "http://facebook.com", is_visible: true },
                      { title: "Title 5", url: "http://facebook.com", is_visible: true }
                    ])

Language.create([
                  { name: 'Catalan' },
                  { name: 'Chinese' },
                  { name: 'Czech' },
                  { name: 'Dutch' },
                  { name: 'English' },
                  { name: 'French' },
                  { name: 'German' },
                  { name: 'Hungarian' },
                  { name: 'Italian' },
                  { name: 'Japanese' },
                  { name: 'Norwegian' },
                  { name: 'Polish' },
                  { name: 'Russian' },
                  { name: 'Serbian' },
                  { name: 'Slovak' },
                  { name: 'Slovenian' },
                  { name: 'Spanish' },
                  { name: 'Ukrainian' },
                  { name: 'Bulgarian' },
                  { name: 'Armenian' },
                  { name: 'Arabic' },
                  { name: 'Tibetan' },
                  { name: 'Latin' },
                  { name: 'Croatian' },
                  { name: 'Portuguese' },
                  { name: 'Finnish' },

                ])

post_cats = BlogPostCategory.create([
                                      { name: 'eds' },
                                      { name: 'tábory' }
                                    ])

BlogPost.create([
                  { title: 'EDS článok', perex: 'Toto je perex. Perex by mal obsahovať 2-3 vety.', text: 'Toto je zvyšný text. Môže obsahovať obrázky, tabuľky a pod.', is_published: true, blog_post_category_id: post_cats.first.id },
                  { title: 'EDS článok', perex: 'Toto je perex. Perex by mal obsahovať 2-3 vety.', text: 'Toto je zvyšný text. Môže obsahovať obrázky, tabuľky a pod.', is_published: true },
                  { title: 'Tábor', perex: 'Toto je perex. Perex by mal obsahovať 2-3 vety.', text: 'Toto je zvyšný text. Môže obsahovať obrázky, tabuľky a pod.', is_published: true, blog_post_category_id: post_cats.second.id },
                  { title: 'Tábor', perex: 'Toto je perex. Perex by mal obsahovať 2-3 vety.', text: 'Toto je zvyšný text. Môže obsahovať obrázky, tabuľky a pod.', is_published: false, blog_post_category_id: post_cats.second.id },
                ])

# EDS table
event_type = event_types.fifth
t = event_type.event_tables.create(name: 'Hosťovanie')
t.add_to_header [{ name: 'Meno', type: "string" },
                 { name: 'Priezvisko', type: "string" },
                 { name: 'Mail', type: :string },
                 { name: 'E-mail partner', type: "string" },
                 { name: 'Rieši sa', type: "date" },
                 { name: 'Cesta', type: "boolean" }
                ]
row = t.event_table_rows.create
row.add([
          { name: 'Meno', value: 'Peter', color: 'green' },
          { name: 'Rieši sa', value: '31-12-2016', color: 'yellow' },
          { name: 'Cesta', value: 'true', color: 'red' }
        ])

EventRowAssociation.create([
                             { my: 'country', their_1: 'Country' },
                             { my: 'code', their_1: 'Code', their_2: 'Number' },
                             { my: 'from', their_1: 'Start' },
                             { my: 'to', their_1: 'End' },
                             { my: 'title', their_1: 'Camp Name' },
                             { my: 'capacity_total', their_1: 'nVol' },
                             { my: 'free_total', their_1: 'nVol' },
                             { my: 'capacity_men', their_1: 'M Free' },
                             { my: 'free_men', their_1: 'M Free' },
                             { my: 'capacity_women', their_1: 'F Free' },
                             { my: 'free_women', their_1: 'F Free' },
                             { my: 'notes', their_1: 'Internal Notes' },
                             { my: 'extra_fee', their_1: 'Extra costs' },
                             { my: 'amount', their_1: 'Extra costs' },
                             { my: 'extra_fee', their_1: 'Currency name' },
                             { my: 'currency', their_1: 'Currency name' },
                             { my: 'event_category', their_1: 'Family camp' },
                             { my: 'event_category', their_1: 'Mixed age camp' },
                             { my: 'event_category', their_1: 'Not for the disabled' },
                             { my: 'event_category', their_1: 'No more war' },
                             { my: 'event_category', their_1: 'Climate for Peace' },
                             { my: 'event_category', their_1: 'Child friendly camp' },
                             { my: 'event_category', their_1: 'Child minimum age' },
                             { my: 'event_category', their_1: 'Agriculture' },
                             { my: 'event_category', their_1: 'Archaeology' },
                             { my: 'event_category', their_1: 'Art' },
                             { my: 'event_category', their_1: 'Construction' },
                             { my: 'event_category', their_1: 'Disabled' },
                             { my: 'event_category', their_1: 'Teaching' },
                             { my: 'event_category', their_1: 'Work with the elderly' },
                             { my: 'event_category', their_1: 'Environment' },
                             { my: 'event_category', their_1: 'Festival' },
                             { my: 'event_category', their_1: 'Cultural heritage' },
                             { my: 'event_category', their_1: 'Work with kids' },
                             { my: 'event_category', their_1: 'Language study' },
                             { my: 'event_category', their_1: 'Manual' },
                             { my: 'event_category', their_1: 'Medical' },
                             { my: 'event_category', their_1: 'Peace' },
                             { my: 'event_category', their_1: 'Disaster relief' },
                             { my: 'event_category', their_1: 'Restoration, renovation' },
                             { my: 'event_category', their_1: 'Social' },
                             { my: 'event_category', their_1: 'Sport' },
                             { my: 'event_category', their_1: 'Study, discussion, research' },
                             { my: 'event_category', their_1: 'Yoga' },
                             { my: 'event_category', their_1: 'Work with animals' },
                             { my: 'is_cancelled', their_1: 'Cancelled' },
                             { my: 'required_spoken_language', their_1: 'Required Language' },
                             { my: 'max_age', their_1: 'Max I Age' },
                             { my: 'min_age', their_1: 'Min I Age' },
                             { my: 'event_document', their_1: 'Motivation Letter Required' },
                             { my: 'ignore', their_1: 'SCI ID' },
                             { my: 'ignore', their_1: 'nReg' },
                             { my: 'ignore', their_1: 'No Show' },
                             { my: 'ignore', their_1: 'Publish From' },
                             { my: 'ignore', their_1: 'Last Update' },
                             { my: 'ignore', their_1: 'Infosheet date' },
                             { my: 'ignore', their_1: 'OptionalLanguages' },
                             { my: 'ignore', their_1: 'Max N Age' },
                             { my: 'ignore', their_1: 'Min N Age' },
                             { my: 'ignore', their_1: 'Urgent' },
                             { my: 'ignore', their_1: 'Promoted camp' },
                             { my: 'ignore', their_1: 'Promoted reason' },
                             { my: 'code_alliance', their_1: 'code' },
                             { my: 'capacity_total', their_1: 'numvol' },
                             { my: 'free_total', their_1: 'numvol' },
                             { my: 'capacity_men', their_1: 'free_m' },
                             { my: 'free_men', their_1: 'free_m' },
                             { my: 'capacity_women', their_1: 'free_f' },
                             { my: 'free_women', their_1: 'free_f' },
                             { my: 'no_more_from', their_1: 'no_more_from' }
                           ])

Education.create([
                   { etype: 'ZŠ', name_sk: "Základné", name_en: "Základné" },
                   { etype: "SŠ", name_sk: "Učňovské", name_en: "Učňovské" },
                   { etype: "SŠ", name_sk: "Učňovské s maturitou", name_en: "Učňovské s maturitou" },
                   { etype: "SŠ", name_sk: "Stredné (bez maturity)", name_en: "Stredné (bez maturity)" },
                   { etype: "SŠ", name_sk: "Úplné stredné všeobecné s maturitou", name_en: "Úplné stredné všeobecné s maturitou" },
                   { etype: "SŠ", name_sk: "Úplné stredné odborné s maturitou", name_en: "Úplné stredné odborné s maturitou" },
                   { etype: "SŠ", name_sk: "Vyššie odborné", name_en: "Vyššie odborné" },
                   { etype: "VŠ", name_sk: "Vysokoškolské 1. stupeň (Bc.)", name_en: "Vysokoškolské 1. stupeň (Bc.)" },
                   { etype: "VŠ", name_sk: "Vysokoškolské 2. stupeň (Mgr., Dr., Ing.)", name_en: "Vysokoškolské 2. stupeň (Mgr., Dr., Ing.)" },
                   { etype: "VŠ", name_sk: "Vysokoškolské 3. stupeň (PhD., CSc.)", name_en: "Vysokoškolské 3. stupeň (PhD., CSc.)" }
                 ])

Permission.create([
                    { controller: "mercury/images", action: "index", role: "eds" },
                    { controller: "mercury/images", action: "create", role: "eds" },
                    { controller: "mercury/images", action: "new", role: "eds" },
                    { controller: "mercury/images", action: "edit", role: "eds" },
                    { controller: "mercury/images", action: "show", role: "eds" },
                    { controller: "mercury/images", action: "update", role: "eds" },
                    { controller: "mercury/images", action: "destroy", role: "eds" },
                    { controller: "homepage_cards", action: "toggle_is_visible", role: "eds" },
                    { controller: "homepage_cards", action: "index", role: "eds" },
                    { controller: "homepage_cards", action: "create", role: "eds" },
                    { controller: "homepage_cards", action: "new", role: "eds" },
                    { controller: "homepage_cards", action: "edit", role: "eds" },
                    { controller: "homepage_cards", action: "show", role: "eds" },
                    { controller: "homepage_cards", action: "update", role: "eds" },
                    { controller: "homepage_cards", action: "destroy", role: "eds" },
                    { controller: "import_workcamps", action: "import", role: "eds" },
                    { controller: "import_workcamps", action: "index", role: "eds" },
                    { controller: "import_workcamps", action: "create", role: "eds" },
                    { controller: "import_workcamps", action: "new", role: "eds" },
                    { controller: "import_workcamps", action: "edit", role: "eds" },
                    { controller: "import_workcamps", action: "show", role: "eds" },
                    { controller: "import_workcamps", action: "update", role: "eds" },
                    { controller: "import_workcamps", action: "destroy", role: "eds" },
                    { controller: "blog_posts", action: "categories", role: "eds" },
                    { controller: "blog_posts", action: "mercury_update", role: "eds" },
                    { controller: "blog_posts", action: "toggle_is_published", role: "eds" },
                    { controller: "blog_posts", action: "index", role: "nologin" },
                    { controller: "blog_posts", action: "create", role: "eds" },
                    { controller: "blog_posts", action: "new", role: "eds" },
                    { controller: "blog_posts", action: "show", role: "nologin" },
                    { controller: "blog_posts", action: "update", role: "eds" },
                    { controller: "blog_posts", action: "destroy", role: "eds" },
                    { controller: "blog_posts", action: "edit", role: "eds" },
                    { controller: "contacts", action: "index", role: "eds" },
                    { controller: "contacts", action: "create", role: "eds" },
                    { controller: "contacts", action: "new", role: "eds" },
                    { controller: "contacts", action: "edit", role: "eds" },
                    { controller: "contacts", action: "show", role: "eds" },
                    { controller: "contacts", action: "update", role: "eds" },
                    { controller: "contacts", action: "destroy", role: "eds" },
                    { controller: "contact_lists", action: "remove", role: "eds" },
                    { controller: "contact_lists", action: "add", role: "eds" },
                    { controller: "contact_lists", action: "add_put", role: "eds" },
                    { controller: "contact_lists", action: "organizations", role: "eds" },
                    { controller: "contact_lists", action: "events", role: "eds" },
                    { controller: "contact_lists", action: "events_second", role: "eds" },
                    { controller: "contact_lists", action: "events_third", role: "eds" },
                    { controller: "contact_lists", action: "index", role: "eds" },
                    { controller: "contact_lists", action: "create", role: "eds" },
                    { controller: "contact_lists", action: "new", role: "eds" },
                    { controller: "contact_lists", action: "edit", role: "eds" },
                    { controller: "contact_lists", action: "edit", role: "eds" },
                    { controller: "contact_lists", action: "update", role: "eds" },
                    { controller: "contact_lists", action: "destroy", role: "eds" },
                    { controller: "event_categories", action: "index", role: "eds" },
                    { controller: "event_categories", action: "create", role: "eds" },
                    { controller: "event_categories", action: "new", role: "eds" },
                    { controller: "event_categories", action: "edit", role: "eds" },
                    { controller: "event_categories", action: "update", role: "eds" },
                    { controller: "event_categories", action: "destroy", role: "eds" },
                    { controller: "event_categories", action: "destroy", role: "eds" },
                    { controller: "sessions", action: "forgotten_password", role: "nologin" },
                    { controller: "sessions", action: "index", role: "nologin" },
                    { controller: "sessions", action: "create", role: "nologin" },
                    { controller: "sessions", action: "new", role: "nologin" },
                    { controller: "sessions", action: "edit", role: "nologin" },
                    { controller: "sessions", action: "show", role: "nologin" },
                    { controller: "sessions", action: "update", role: "nologin" },
                    { controller: "sessions", action: "destroy", role: "nologin" },
                    { controller: "homepage", action: "set_lang", role: "nologin" },
                    { controller: "homepage", action: "kontakty", role: "nologin" },
                    { controller: "homepage", action: "search", role: "nologin" },
                    { controller: "homepage", action: "search_page", role: "nologin" },
                    { controller: "homepage", action: "mercury_update", role: "eds" },
                    { controller: "homepage", action: "edit_cards", role: "eds" },
                    { controller: "homepage", action: "index", role: "nologin" },
                    { controller: "homepage", action: "create", role: "eds" },
                    { controller: "homepage", action: "new", role: "eds" },
                    { controller: "homepage", action: "edit", role: "eds" },
                    { controller: "homepage", action: "show", role: "nologin" },
                    { controller: "homepage", action: "update", role: "eds" },
                    { controller: "homepage", action: "destroy", role: "eds" },
                    { controller: "html_articles", action: "mercury_update", role: "eds" },
                    { controller: "html_articles", action: "index", role: "nologin" },
                    { controller: "html_articles", action: "create", role: "eds" },
                    { controller: "html_articles", action: "new", role: "eds" },
                    { controller: "html_articles", action: "edit", role: "eds" },
                    { controller: "html_articles", action: "show", role: "nologin" },
                    { controller: "html_articles", action: "update", role: "eds" },
                    { controller: "html_articles", action: "destroy", role: "eds" },
                    { controller: "homepage_partners", action: "index", role: "eds" },
                    { controller: "homepage_partners", action: "create", role: "eds" },
                    { controller: "homepage_partners", action: "new", role: "eds" },
                    { controller: "homepage_partners", action: "edit", role: "eds" },
                    { controller: "homepage_partners", action: "show", role: "eds" },
                    { controller: "homepage_partners", action: "update", role: "eds" },
                    { controller: "homepage_partners", action: "destroy", role: "eds" },
                    { controller: "event_lists", action: "sort", role: "user" },
                    { controller: "event_lists", action: "register", role: "user" },
                    { controller: "event_lists", action: "step_second", role: "user" },
                    { controller: "event_lists", action: "register_child", role: "user" },
                    { controller: "event_lists", action: "step_second_child", role: "user" },
                    { controller: "event_lists", action: "create_registration_child", role: "user" },
                    { controller: "event_lists", action: "payment_info", role: "user" },
                    { controller: "event_lists", action: "create", role: "user" },
                    { controller: "event_lists", action: "new", role: "user" },
                    { controller: "event_lists", action: "edit", role: "user" },
                    { controller: "event_lists", action: "show", role: "user" },
                    { controller: "event_lists", action: "update", role: "user" },
                    { controller: "event_lists", action: "add_event", role: "user" },
                    { controller: "event_lists", action: "remove_event", role: "user" },
                    { controller: "tasks", action: "index_others", role: "eds" },
                    { controller: "tasks", action: "repeatable", role: "eds" },
                    { controller: "tasks", action: "add_to_my_list", role: "eds" },
                    { controller: "tasks", action: "index", role: "eds" },
                    { controller: "tasks", action: "create", role: "eds" },
                    { controller: "tasks", action: "new", role: "eds" },
                    { controller: "tasks", action: "edit", role: "eds" },
                    { controller: "tasks", action: "update", role: "eds" },
                    { controller: "tasks", action: "destroy", role: "eds" },
                    { controller: "task_lists", action: "update_state", role: "eds" },
                    { controller: "events", action: "show_public", role: "nologin" },
                    { controller: "events", action: "import_1", role: "eds" },
                    { controller: "events", action: "import_2", role: "eds" },
                    { controller: "events", action: "import_3", role: "eds" },
                    { controller: "events", action: "import_4", role: "eds" },
                    { controller: "events", action: "step_second", role: "eds" },
                    { controller: "events", action: "step_third", role: "eds" },
                    { controller: "events", action: "step_fourth", role: "eds" },
                    { controller: "events", action: "step_fifth", role: "eds" },
                    { controller: "events", action: "index", role: "eds" },
                    { controller: "events", action: "create", role: "eds" },
                    { controller: "events", action: "new", role: "eds" },
                    { controller: "events", action: "edit", role: "eds" },
                    { controller: "events", action: "show", role: "eds" },
                    { controller: "events", action: "update", role: "eds" },
                    { controller: "events", action: "destroy", role: "eds" },
                    { controller: "event_types", action: "index", role: "eds" },
                    { controller: "event_types", action: "create", role: "eds" },
                    { controller: "event_types", action: "new", role: "eds" },
                    { controller: "event_types", action: "edit", role: "eds" },
                    { controller: "event_types", action: "show", role: "eds" },
                    { controller: "event_types", action: "update", role: "eds" },
                    { controller: "event_types", action: "destroy", role: "eds" },
                    { controller: "organizations", action: "index", role: "eds" },
                    { controller: "organizations", action: "create", role: "eds" },
                    { controller: "organizations", action: "new", role: "eds" },
                    { controller: "organizations", action: "edit", role: "eds" },
                    { controller: "organizations", action: "show", role: "eds" },
                    { controller: "organizations", action: "update", role: "eds" },
                    { controller: "organizations", action: "destroy", role: "eds" },
                    { controller: "partner_networks", action: "index", role: "eds" },
                    { controller: "partner_networks", action: "create", role: "eds" },
                    { controller: "partner_networks", action: "new", role: "eds" },
                    { controller: "partner_networks", action: "edit", role: "eds" },
                    { controller: "partner_networks", action: "show", role: "eds" },
                    { controller: "partner_networks", action: "update", role: "eds" },
                    { controller: "partner_networks", action: "destroy", role: "eds" },
                    { controller: "users", action: "new", role: "nologin" },
                    { controller: "users", action: "edit", role: "nologin" },
                    { controller: "users", action: "create", role: "nologin" },
                    { controller: "users", action: "show_events", role: "nologin" },
                    { controller: "users", action: "show_bags", role: "nologin" },
                    { controller: "users", action: "show", role: "user" },
                    { controller: "users", action: "update", role: "nologin" },
                    { controller: "event_types", action: "application_conditions", role: "nologin" },
                  ])
