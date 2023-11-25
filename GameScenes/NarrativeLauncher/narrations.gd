extends Node

var narration1 = {
	"played": false,
	"dialogue":
		[
			{
				"text": "Au commencement, il y eu le jour de la grande malédiction. Teils, comme tous les autres, fut frappé par la maladie",
				"sound": preload("res://Assets/Narration/teils_1.wav")
			}
		]
}

var narration2 = {
	"played": false,
	"dialogue":
		[
			{
				"text": "Lorsqu'il découvrit sa première orbe de soin, il crût bien être sauvé...",
				"sound": preload("res://Assets/Narration/teils_2.wav")
			}, 
			{
				"text": "Mais son espoir fût de courte durée, les orbes elles même êtaient frappées par la malédiction et perdaient peu à peu de leur aura.",
				"sound": preload("res://Assets/Narration/teils_3.wav")
			},
			{
				"text": "Le temps lui manquait. Il lui fallait maintenant trouver un moyen d'échapper à ce monde...",
				"sound": preload("res://Assets/Narration/teils_4.wav")
			}
		]
}

var narration3 = {
	"played": false,
	"dialogue":
		[
			{
				"text": "Quand il aperçut le portail, il crût être sauvé...",
				"sound": preload("res://Assets/Narration/teils_5.wav")
			}, 
			{
				"text": "Mais il allait bientôt découvrir ce qui l'attendait de l'autre côté",
				"sound": preload("res://Assets/Narration/teils_6.wav")
			}
		]
}

var narration4 = {
	"played": false,
	"dialogue":
		[
			{
				"text": "Un monde lugubre et angoissant. Mais la cure était quelque part dans ce monde, il le savait.",
				"sound": preload("res://Assets/Narration/teils_7.wav")
			}, 
			{
				"text": "Mais prends garde Teils, car les anciennes pierres sont totalement corrompues, dans ce bas monde ...",
				"sound": preload("res://Assets/Narration/teils_8.wav")
			}
		]
}

var enter_level3 = {
	"played": false,
	"dialogue":
		[
			{
				"text": "La première fois que Teils utilisa la pierre de sommeil, il fut envahit d'une sensation de pouvoir.",
				"sound": preload("res://Assets/Narration/teils_9.wav")
			}, 
			{
				"text": "Mais fais attention à son pouvoir, Teils, tu pourrais y laisser tes esprits...",
				"sound": preload("res://Assets/Narration/teils_10.wav")
			}
		]
}

var welcome_level3 = {
	"played": false,
	"dialogue":
		[
			{
				"text": "Sois prudent, Teils, mais ne perds pas trop de temps",
				"sound": preload("res://Assets/Narration/teils_11.wav")
			},
			{
				"text": "Apprends à utiliser le temps comme ta vie, et n'oublie ce qui se passe de l'autre côté...",
				"sound": preload("res://Assets/Narration/teils_12.wav")
			}
		]
}

var enter_level4 = {
	"played": false,
	"dialogue":
		[
			{
				"text": "Lorsque Teils trouva sa première pierre mentale, il pensait avoir enfin trouvé le salut.",
				"sound": preload("res://Assets/Narration/teils_13.wav")
			}, 
			{
				"text": "Mais il n'est pas encore temps pour le repos Teils, un nouveau monde s'ouvre devant toi...",
				"sound": preload("res://Assets/Narration/teils_14.wav")
			}
		]
}

var welcome_level4 = {
	"played": false,
	"dialogue":
		[
			{
				"text": "... et ce monde te réserve bien des surprises",
				"sound": preload("res://Assets/Narration/teils_15.wav")
			},
			{
				"text": "Sois courageux Teils, ton destin t'attends...",
				"sound": preload("res://Assets/Narration/teils_16.wav")
			}
		]
}

var end_level4 = {
	"played": false,
	"dialogue":
		[
			{
				"text": "Sois fier de toi, Teils, tu as livré tes premiers combats avec bravoure...",
				"sound": preload("res://Assets/Narration/teils_17.wav")
			},
			{
				"text": "Mais ce n'est que le début, de puissants ennemis te barrent encore le chemin pour assurer ta survie.",
				"sound": preload("res://Assets/Narration/teils_18.wav")
			}
		]
}

var narrations = [
	narration1, # 0
	narration2, # 1
	narration3, # 2
	narration4, # 3
	enter_level3, # 4
	welcome_level3, # 5
	enter_level4, # 6
	welcome_level4, # 7
	end_level4 # 8
]
