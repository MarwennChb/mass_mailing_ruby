require "google_drive"
require 'rubygems'
require 'nokogiri'
require 'open-uri'

def get_all_the_urls_of_val_doise_townhalls() #on va utiliser le code de la session d'avant avce nokogiri, l'enjeu est de le mettre dans le spreadsheet
    page = Nokogiri::HTML(open("https://annuaire-des-mairies.com/val-d-oise.html"))
    session = GoogleDrive::Session.from_config("config.json") #utilisez votre fichier config.json pour l'authetification de votre application sur drive
    ws = session.spreadsheet_by_key("1ZXlxQDMwwlYX6oXl1mPAhyve1HLynLyNAsh9I9o8f3s").worksheets[0] #on crée un sheet sur drive et ici on l'appele par son lien
    cities = ""

    i = 1
    page.css('a.lientxt').each do |town|
        site = "https://annuaire-des-mairies.com" + town['href'][1..-1]
        cities = town.text
        ws[(i), 1] = cities #on utilise les commandes de doogle_drive pour écrire dans les colonnes et les lignes
        ws[(i), 2] = get_the_email_of_a_townhal_from_its_webpage(site) #on parcourt l'array avec page.css et on rempli au fure et à mesure le sheet avec le nom des villes et leur emails
        i += 1
    end
    ws.save
end

def get_the_email_of_a_townhal_from_its_webpage (adresse)
    page = Nokogiri::HTML(open(adresse))  
    return page.css('td.style27 p.Style22 font')[6].text
end

get_all_the_urls_of_val_doise_townhalls()

