require 'gmail'
require "google_drive"
require 'rubygems'

session = GoogleDrive::Session.from_config("config.json") #on utilise la gem ruby google drive pour l'authentification. ici n'oubliez pas de mettre votre fichier de config au même dossier que ce fichier ruby
$ws = session.spreadsheet_by_key("1ZXlxQDMwwlYX6oXl1mPAhyve1HLynLyNAsh9I9o8f3s").worksheets[0] #on indique où se trouve notre sheet

$gmail = Gmail.connect("xxxxx", "xxxxx") #on utilise la gem gmail pour se connecter au compte avec lequel on va envoyer notre mailing. ici mettez vos identifiants.

$townhall_mail = [] #on va créer un array dans lequel on va stocker la 2ème colonne du sheet : les emails
$townhall_name = [] #on va créer un array dans lequel on va stocker la 1ère colonne du sheet : les noms des villes

def send_email_to_line (mail, name) #cette fonction va envoyer les emails elle prend en entrée une valeur de ville avec le mail associé
	$gmail.deliver do 
	  to mail #l'adresse mail à laquelle gmail.deliver va envoyé le mail, en input de notre fonction
	  subject "Formation digitale THP"

	  html_part do
	    content_type 'text/html; charset=UTF-8'
	    body get_the_email_html(name) #le html qui provient de la fonction get-the-email_html appliquée à au nom de la ville
	  end
	end
end

def go_through_all_the_lines # cette fonction va récupérer les données du sheet et les stocker dans les 2 array définits Ligne 10 et 11
		(1..$ws.num_rows).each do |x|
		    $townhall_mail << $ws[x, 2]
		    $townhall_name << $ws[x, 1]
		end
end

def get_the_email_html (townhall_name) #cette fonction "personnalise" un code html avec le nom spécifique de chaque ville. Elle revoie un code html qui va être prit par la 

return "<p> Bonjour,
					Je m'appelle jimmythpbot, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau. La formation s'appelle The Hacking Project (http://thehackingproject.org/). Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.<br>
					Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à #{townhall_name}, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec #{townhall_name} ! <br>
					Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80
					</p>"
end

def demarre #la fonction qui va démarrer notre programme
	go_through_all_the_lines # on va remplir les array avec els noms devilles et les emails associés

	for j in 1..$ws.num_rows #on va parcourir les arrays ligne par ligne
		mail = $townhall_mail[j]
		namae = $townhall_name[j]
		send_email_to_line(mail, namae) #pour chaque ligne, on execute la fonction send_mail... avec comme input la nom de la ville à la ligne j et le mail à cette même ligne
	end
end

demarre #demarre le prgramme en executant la fonction de démarrage demarre