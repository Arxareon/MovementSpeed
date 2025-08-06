--[[ NAMESPACE ]]

---@class MovementSpeedNamespace
local ns = select(2, ...)


--[[ LOCALIZATIONS (WoW locales: https://warcraft.wiki.gg/wiki/API_GetLocale#Values) ]]

ns.localizations = {}

--TODO: verity AI translations (from enUS)
--TODO: adjust the date formats for the translated languages

--# flags will be replaced by text or number values via code
--\n represents the newline character

--[ English ]

---@class strings
ns.localizations.enUS = {
	options = {
		main = {
			description = "Customize #ADDON to fit your needs.\nType #KEYWORD1 or #KEYWORD2 for chat commands.",
			shortcuts = {
				title = "Shortcuts",
				description = "Access specific options by expanding the #ADDON categories on the left or by clicking a button here.",
			},
		},
		speedValue = {
			title = "Speed Value",
			units = {
				label = "Displayed Units",
				tooltip = "Select which unit types should be present in the speed value text.",
				list = {
					{
						label = "Percentage",
						tooltip = "Show the speed value as a percentage of the base running speed (which is 7 yards per second)."
					},
					{
						label = "Yards/second",
						tooltip = "Show the speed value as distance in yards traveled per second.",
					},
					{
						label = "Coordinates/second",
						tooltip = "Show the speed value as distance in coordinates traveled per second.",
					},
				},
			},
			fractionals = {
				label = "Max Fractional Digits",
				tooltip = "Set the maximal number of decimal places that should be displayed in the fractional part of the speed values.\n\nEach speed value will be rounded to the nearest number based on the decimal accuracy specified here.\n\nCoordinate values are always displayed with at least one fractional digit.",
			},
			zeros = {
				label = "Show trailing zeros",
				tooltip = "Always show the specified number of decimal digits, don't trim trailing zeros.",
			},
		},
		speedDisplay = {
			title = "#TYPE Display",
			referenceName = "the #TYPE display",
			copy = {
				label = "Copy #TYPE values",
				tooltip = "Set these options to mirror the values of matching options set for the #TITLE.",
			},
			visibility = {
				title = "Visibility",
				hidden = {
					label = "Hidden",
					tooltip = "Enable or disable the #ADDON displays.",
				},
				autoHide = {
					label = "Hide while stationary",
					tooltip = "Automatically hide the speed display while you are not moving.",
				},
				statusNotice = {
					label = "Chat notice if hidden",
					tooltip = "Get a chat notification about the status of the speed display if it's not visible after the interface loads.",
				},
			},
			update = {
				title = "Speed Update",
				throttle = {
					label = "Throttle Updates",
					tooltip = "Slow the update rate of the speed value to match the specified #FREQUENCY instead of the framerate.\n\nThis will improve CPU performance by a small amount.",
				},
				frequency = {
					label = "Update Frequency",
					tooltip = "Set the time in seconds to wait before speed value is updated again.",
				},
			},
			font = {
				title = "Font & Text",
				family = {
					label = "Font",
					tooltip = "Select the font of the speed value text.",
					default = "This is a default font used by Blizzard.",
					custom = {
						"You may set the #OPTION_CUSTOM option to any font of your liking by replacing the #FILE_CUSTOM file with another TrueType Font file found in:",
						"while keeping the original #FILE_CUSTOM name.",
						"You may need to restart the game client after replacing the Custom font file.",
					},
				},
				size = {
					label = "Font Size",
					tooltip = "Set the size of the displayed text.",
				},
				valueColoring = {
					label = "Individual Value Coloring",
					tooltip = "Color the speed values in the display with the default #ADDON color palette.",
				},
				color = {
					label = "Font Color",
					tooltip = "The color of the entire speed value text when the #VALUE_COLORING option is turned off.",
				},
				alignment = {
					label = "Text Alignment",
					tooltip = "Select the horizontal alignment of the text inside the speed display.",
				},
			},
			background = {
				title = "Background",
				visible = {
					label = "Visible",
					tooltip = "Toggle the visibility of the background elements of speed display.",
				},
				colors = {
					bg = {
						label = "Background Color",
					},
					border = {
						label = "Border Color",
					},
				},
			},
		},
		playerSpeed = {
			title = "Player Speed",
			description = "Calculate your speed, modified by your Speed stat, mounts, buffs, debuffs or the type movement activity.",
		},
		travelSpeed = {
			title = "Travel Speed",
			description = "Calculate the estimated speed at which you are actually traveling through the current zone horizontally.",
		},
		targetSpeed = {
			title = "Target Speed",
			description = "View the current movement speed of any player or NPC you are inspecting via mouseover.",
			mouseover = {
				title = "Inspect Tooltip",
				enabled = {
					label = "Enable Integration",
					tooltip = "Enable or disable the #ADDON integration within the mouseover target inspect tooltip."
				},
			},
		},
	},
	presets = {
		"Under Minimap",
		"Under #TYPE display",
		"Above #TYPE display",
		"Right of #TYPE display",
		"Left of #TYPE display",
	},
	chat = {
		position = {
			save = "The #TYPE display position was saved.",
			cancel = "The repositioning of the #TYPE display was cancelled.",
			error = "Hold SHIFT until the mouse button is released to save the position.",
		},
		status = {
			visible = "The #TYPE display is visible (#AUTO).",
			notVisible = "The #TYPE display is not visible (#AUTO).",
			hidden = "The #TYPE display is hidden (#AUTO).",
			auto = "auto-hide: #STATE",
		},
		help = {
			move = "Hold SHIFT to drag the speed displays anywhere you like.",
		},
		options = {
			description = "open the #ADDON options",
		},
		preset = {
			description = "apply a #TYPE display preset (e.g. #INDEX)",
			response = "The #PRESET preset was applied to the #TYPE display.",
			unchanged = "The specified preset could not be applied.",
			error = "Please enter a valid preset index (e.g. #INDEX).",
			list = "The following presets are available:",
		},
		save = {
			description = "save this #TYPE display setup as the #CUSTOM preset",
			response = "The current #TYPE display position and visibility was saved to the #CUSTOM preset.",
		},
		reset = {
			description = "reset the #TYPE display #CUSTOM preset to default",
			response = "The #CUSTOM preset has been reset to default.",
		},
		toggle = {
			description = "show or hide the #TYPE display (#HIDDEN)",
			hiding = "The #TYPE display has been hidden.",
			unhiding = "The #TYPE display has been made visible.",
			hidden = "hidden",
			notHidden = "not hidden",
		},
		auto = {
			description = "hide the #TYPE display while stationary (#STATE)",
			response = "The #TYPE display automatic hide was set to #STATE.",
		},
		size = {
			description = "set font size of the #TYPE display (e.g. #SIZE)",
			response = "The #TYPE display font size was set to #VALUE.",
			unchanged = "The #TYPE display font size was not changed.",
			error = "Please enter a valid number value (e.g. #SIZE).",
		},
		swap = {
			description = "swap display set by chat commands (current: #ACTIVE)",
			response = "The display affected by chat commands has been changed to the #ACTIVE display.",
		},
		profile = {
			description = "activate a settings profile (e.g. #INDEX)",
			response = "The #PROFILE settings profile was activated.",
			unchanged = "The specified profile could not be activated.",
			error = "Please enter a valid profile name or index (e.g. #INDEX).",
			list = "The following profiles are available:",
		},
		default = {
			description = "reset the active #PROFILE settings profile to default",
			response = "The active #PROFILE settings profile has been reset to default.",
			responseCategory = "Settings of the #CATEGORY category in the active #PROFILE settings profile have been reset to default.",
		},
	},
	targetSpeed = "Speed: #SPEED",
	speedTooltip = {
		title = "#SPEED details:",
		description = "Live movement status summary.",
		playerSpeed = "Calculated based on the type of your current movement activity, modified by the Speed stat and various buffs, debuffs, mounts & other effects.",
		travelSpeed = "Estimated by tracking your horizontal movement through the current zone, negatively affected by obstacles and the angle of movement during flight.",
		instanceError = "Not available while in this instance!",
		text = {
			"#YARDS yards / second.",
			"#PERCENT of the base running speed.",
			"#COORDS coordinates / second.",
		},
		mapTitle = "Current zone: #MAP",
		mapSize = "Map size: #SIZE",
		mapSizeValues = "#W x #H yards",
		hintOptions = "Right-click to access specific options.",
		hintMove = "Hold SHIFT & drag to reposition.",
	},
	speedValue = {
		yardsps = "#YARDS yards/s",
		yps = "#YARDS y/s",
		coordsps = "#COORDS coords/s",
		cps = "#COORDS c/s",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "Options",
		default = "Default",
		custom = "Custom",
		enabled = "enabled",
		disabled = "disabled",
		days = "days",
		hours = "hours",
		minutes = "minutes",
		seconds = "seconds",
	},
}

--[ Portuguese (Brazil) ]

---@class strings
ns.localizations.ptBR = {
	options = {
		main = {
			description = "Personalize o #ADDON para atender às suas necessidades.\nDigite #KEYWORD1 ou #KEYWORD2 para comandos de chat.",
			shortcuts = {
				title = "Atalhos",
				description = "Acesse opções específicas expandindo as categorias do #ADDON à esquerda ou clicando em um botão aqui.",
			},
		},
		speedValue = {
			title = "Valor de Velocidade",
			units = {
				label = "Unidades Exibidas",
				tooltip = "Selecione quais tipos de unidade devem estar presentes no texto do valor de velocidade.",
				list = {
					{
						label = "Porcentagem",
						tooltip = "Mostra o valor de velocidade como uma porcentagem da velocidade base de corrida (que é 7 jardas por segundo)."
					},
					{
						label = "Jardas/segundo",
						tooltip = "Mostra o valor de velocidade como distância em jardas percorridas por segundo.",
					},
					{
						label = "Coordenadas/segundo",
						tooltip = "Mostra o valor de velocidade como distância em coordenadas percorridas por segundo.",
					},
				},
			},
			fractionals = {
				label = "Máximo de Casas Decimais",
				tooltip = "Defina o número máximo de casas decimais que devem ser exibidas na parte fracionária dos valores de velocidade.\n\nCada valor será arredondado para o número mais próximo com base na precisão decimal especificada aqui.\n\nOs valores de coordenadas sempre são exibidos com pelo menos um dígito decimal.",
			},
			zeros = {
				label = "Mostrar zeros finais",
				tooltip = "Sempre mostrar o número especificado de casas decimais, não remova zeros finais.",
			},
		},
		speedDisplay = {
			title = "Exibição #TYPE",
			referenceName = "a exibição #TYPE",
			copy = {
				label = "Copiar valores #TYPE",
				tooltip = "Defina estas opções para espelhar os valores das opções correspondentes definidas para o #TITLE.",
			},
			visibility = {
				title = "Visibilidade",
				hidden = {
					label = "Oculto",
					tooltip = "Ative ou desative as exibições do #ADDON.",
				},
				autoHide = {
					label = "Ocultar parado",
					tooltip = "Oculta automaticamente a exibição de velocidade quando você não está se movendo.",
				},
				statusNotice = {
					label = "Aviso no chat se oculto",
					tooltip = "Receba uma notificação no chat sobre o status da exibição de velocidade se ela não estiver visível após o carregamento da interface.",
				},
			},
			update = {
				title = "Atualização de Velocidade",
				throttle = {
					label = "Limitar Atualizações",
					tooltip = "Diminua a taxa de atualização do valor de velocidade para corresponder à #FREQUENCY especificada em vez da taxa de quadros.\n\nIsso melhora um pouco o desempenho do processador.",
				},
				frequency = {
					label = "Frequência de Atualização",
					tooltip = "Defina o tempo em segundos para aguardar antes de atualizar o valor de velocidade novamente.",
				},
			},
			font = {
				title = "Fonte & Texto",
				family = {
					label = "Fonte",
					tooltip = "Selecione a fonte do texto do valor de velocidade.",
					default = "Esta é uma fonte padrão usada pela Blizzard.",
					custom = {
						"Você pode definir a opção #OPTION_CUSTOM para qualquer fonte desejada substituindo o arquivo #FILE_CUSTOM por outro arquivo TrueType Font encontrado em:",
						"mantendo o nome original #FILE_CUSTOM.",
						"Pode ser necessário reiniciar o cliente do jogo após substituir o arquivo de fonte personalizada.",
					},
				},
				size = {
					label = "Tamanho da Fonte",
					tooltip = "Defina o tamanho do texto exibido.",
				},
				valueColoring = {
					label = "Coloração Individual de Valores",
					tooltip = "Colore os valores de velocidade na exibição com a paleta de cores padrão do #ADDON.",
				},
				color = {
					label = "Cor da Fonte",
					tooltip = "A cor de todo o texto do valor de velocidade quando a opção #VALUE_COLORING está desativada.",
				},
				alignment = {
					label = "Alinhamento do Texto",
					tooltip = "Selecione o alinhamento horizontal do texto dentro da exibição de velocidade.",
				},
			},
			background = {
				title = "Fundo",
				visible = {
					label = "Visível",
					tooltip = "Ative ou desative a visibilidade dos elementos de fundo da exibição de velocidade.",
				},
				colors = {
					bg = {
						label = "Cor do Fundo",
					},
					border = {
						label = "Cor da Borda",
					},
				},
			},
		},
		playerSpeed = {
			title = "Velocidade do Jogador",
			description = "Calcula sua velocidade, modificada pelo atributo Velocidade, montarias, bônus, penalidades ou o tipo de movimento.",
		},
		travelSpeed = {
			title = "Velocidade de Viagem",
			description = "Calcula a velocidade estimada em que você realmente está se movendo horizontalmente pela zona atual.",
		},
		targetSpeed = {
			title = "Velocidade do Alvo",
			description = "Veja a velocidade de movimento atual de qualquer jogador ou PNJ que você está inspecionando com o mouse.",
			mouseover = {
				title = "Tooltip de Inspeção",
				enabled = {
					label = "Ativar Integração",
					tooltip = "Ative ou desative a integração do #ADDON no tooltip de inspeção do alvo ao passar o mouse."
				},
			},
		},
	},
	presets = {
		"Abaixo do minimapa",
		"Abaixo da exibição #TYPE",
		"Acima da exibição #TYPE",
		"À direita da exibição #TYPE",
		"À esquerda da exibição #TYPE",
	},
	chat = {
		position = {
			save = "A posição da exibição #TYPE foi salva.",
			cancel = "O reposicionamento da exibição #TYPE foi cancelado.",
			error = "Segure SHIFT até soltar o botão do mouse para salvar a posição.",
		},
		status = {
			visible = "A exibição #TYPE está visível (#AUTO).",
			notVisible = "A exibição #TYPE não está visível (#AUTO).",
			hidden = "A exibição #TYPE está oculta (#AUTO).",
			auto = "ocultar automaticamente: #STATE",
		},
		help = {
			move = "Segure SHIFT para arrastar as exibições de velocidade para onde quiser.",
		},
		options = {
			description = "abrir as opções do #ADDON",
		},
		preset = {
			description = "aplicar um predefinido de exibição #TYPE (ex: #INDEX)",
			response = "O predefinido #PRESET foi aplicado à exibição #TYPE.",
			unchanged = "O predefinido especificado não pôde ser aplicado.",
			error = "Por favor, insira um índice de predefinido válido (ex: #INDEX).",
			list = "Os seguintes predefinidos estão disponíveis:",
		},
		save = {
			description = "salvar esta configuração de exibição #TYPE como o predefinido #CUSTOM",
			response = "A posição e visibilidade atuais da exibição #TYPE foram salvas no predefinido #CUSTOM.",
		},
		reset = {
			description = "restaurar o predefinido #CUSTOM da exibição #TYPE para o padrão",
			response = "O predefinido #CUSTOM foi restaurado para o padrão.",
		},
		toggle = {
			description = "mostrar ou ocultar a exibição #TYPE (#HIDDEN)",
			hiding = "A exibição #TYPE foi ocultada.",
			unhiding = "A exibição #TYPE foi tornada visível.",
			hidden = "oculta",
			notHidden = "não oculta",
		},
		auto = {
			description = "ocultar a exibição #TYPE enquanto parado (#STATE)",
			response = "A ocultação automática da exibição #TYPE foi definida para #STATE.",
		},
		size = {
			description = "definir o tamanho da fonte da exibição #TYPE (ex: #SIZE)",
			response = "O tamanho da fonte da exibição #TYPE foi definido para #VALUE.",
			unchanged = "O tamanho da fonte da exibição #TYPE não foi alterado.",
			error = "Por favor, insira um valor numérico válido (ex: #SIZE).",
		},
		swap = {
			description = "trocar a exibição afetada pelos comandos de chat (atual: #ACTIVE)",
			response = "A exibição afetada pelos comandos de chat foi alterada para a exibição #ACTIVE.",
		},
		profile = {
			description = "ativar um perfil de configurações (ex: #INDEX)",
			response = "O perfil de configurações #PROFILE foi ativado.",
			unchanged = "O perfil especificado não pôde ser ativado.",
			error = "Por favor, insira um nome ou índice de perfil válido (ex: #INDEX).",
			list = "Os seguintes perfis estão disponíveis:",
		},
		default = {
			description = "restaurar o perfil de configurações #PROFILE ativo para o padrão",
			response = "O perfil de configurações #PROFILE ativo foi restaurado para o padrão.",
			responseCategory = "As configurações da categoria #CATEGORY no perfil de configurações #PROFILE ativo foram restauradas para o padrão.",
		},
	},
	targetSpeed = "Velocidade: #SPEED",
	speedTooltip = {
		title = "Detalhes de #SPEED:",
		description = "Resumo do status de movimento ao vivo.",
		playerSpeed = "Calculado com base no tipo de atividade de movimento atual, modificado pelo atributo Velocidade e por vários bônus, penalidades, montarias e outros efeitos.",
		travelSpeed = "Estimado rastreando seu movimento horizontal pela zona atual, afetado negativamente por obstáculos e pelo ângulo de movimento durante o voo.",
		instanceError = "Não disponível nesta instância!",
		text = {
			"#YARDS jardas / segundo.",
			"#PERCENT da velocidade base de corrida.",
			"#COORDS coordenadas / segundo.",
		},
		mapTitle = "Zona atual: #MAP",
		mapSize = "Tamanho do mapa: #SIZE",
		mapSizeValues = "#W x #H jardas",
		hintOptions = "Clique com o botão direito para acessar opções específicas.",
		hintMove = "Segure SHIFT e arraste para reposicionar.",
	},
	speedValue = {
		yardsps = "#YARDS jardas/s",
		yps = "#YARDS j/s",
		coordsps = "#COORDS coords/s",
		cps = "#COORDS c/s",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "Opções",
		default = "Padrão",
		custom = "Personalizado",
		enabled = "habilitado",
		disabled = "desabilitado",
		days = "dias",
		hours = "horas",
		minutes = "minutos",
		seconds = "segundos",
	},
}

--[ German ]

---@class strings
ns.localizations.deDE = {
	options = {
		main = {
			description = "Passe #ADDON nach deinen Bedürfnissen an.\nGib #KEYWORD1 oder #KEYWORD2 für Chatbefehle ein.",
			shortcuts = {
				title = "Kurzbefehle",
				description = "Greife auf bestimmte Optionen zu, indem du die #ADDON-Kategorien links erweiterst oder hier auf einen Button klickst.",
			},
		},
		speedValue = {
			title = "Geschwindigkeitswert",
			units = {
				label = "Angezeigte Einheiten",
				tooltip = "Wähle aus, welche Einheitentypen im Geschwindigkeitswert-Text angezeigt werden sollen.",
				list = {
					{
						label = "Prozent",
						tooltip = "Zeige den Geschwindigkeitswert als Prozentsatz der Basislaufgeschwindigkeit (7 Meter pro Sekunde)."
					},
					{
						label = "Meter/Sekunde",
						tooltip = "Zeige den Geschwindigkeitswert als zurückgelegte Meter pro Sekunde an.",
					},
					{
						label = "Koordinaten/Sekunde",
						tooltip = "Zeige den Geschwindigkeitswert als zurückgelegte Koordinaten pro Sekunde an.",
					},
				},
			},
			fractionals = {
				label = "Maximale Dezimalstellen",
				tooltip = "Lege die maximale Anzahl an Dezimalstellen fest, die im Bruchteil der Geschwindigkeitswerte angezeigt werden.\n\nJeder Geschwindigkeitswert wird auf die nächste Zahl gerundet, basierend auf der hier angegebenen Genauigkeit.\n\nKoordinatenwerte werden immer mit mindestens einer Dezimalstelle angezeigt.",
			},
			zeros = {
				label = "Nachfolgende Nullen anzeigen",
				tooltip = "Zeige immer die angegebene Anzahl an Dezimalstellen, entferne keine nachfolgenden Nullen.",
			},
		},
		speedDisplay = {
			title = "#TYPE Anzeige",
			referenceName = "die #TYPE Anzeige",
			copy = {
				label = "#TYPE Werte kopieren",
				tooltip = "Setze diese Optionen, um die Werte der entsprechenden Optionen des #TITLE zu spiegeln.",
			},
			visibility = {
				title = "Sichtbarkeit",
				hidden = {
					label = "Versteckt",
					tooltip = "Aktiviere oder deaktiviere die #ADDON-Anzeigen.",
				},
				autoHide = {
					label = "Beim Stillstand ausblenden",
					tooltip = "Blende die Geschwindigkeitsanzeige automatisch aus, wenn du dich nicht bewegst.",
				},
				statusNotice = {
					label = "Chat-Hinweis bei Ausblendung",
					tooltip = "Erhalte eine Chat-Benachrichtigung über den Status der Geschwindigkeitsanzeige, wenn sie nach dem Laden der Oberfläche nicht sichtbar ist.",
				},
			},
			update = {
				title = "Geschwindigkeitsaktualisierung",
				throttle = {
					label = "Updates drosseln",
					tooltip = "Verlangsame die Aktualisierungsrate des Geschwindigkeitswertes auf die angegebene #FREQUENCY statt auf die Bildrate.\n\nDies verbessert die CPU-Leistung geringfügig.",
				},
				frequency = {
					label = "Aktualisierungshäufigkeit",
					tooltip = "Lege die Zeit in Sekunden fest, die zwischen den Aktualisierungen des Geschwindigkeitswertes gewartet werden soll.",
				},
			},
			font = {
				title = "Schrift & Text",
				family = {
					label = "Schriftart",
					tooltip = "Wähle die Schriftart des Geschwindigkeitswert-Textes.",
					default = "Dies ist eine von Blizzard verwendete Standardschriftart.",
					custom = {
						"Du kannst die Option #OPTION_CUSTOM auf eine beliebige Schriftart setzen, indem du die Datei #FILE_CUSTOM durch eine andere TrueType-Schriftart aus:",
						"ersetzt und den ursprünglichen Namen #FILE_CUSTOM beibehältst.",
						"Nach dem Ersetzen der benutzerdefinierten Schriftdatei musst du den Spielclient möglicherweise neu starten.",
					},
				},
				size = {
					label = "Schriftgröße",
					tooltip = "Lege die Größe des angezeigten Textes fest.",
				},
				valueColoring = {
					label = "Individuelle Wertfarbe",
					tooltip = "Färbe die Geschwindigkeitswerte in der Anzeige mit der Standardfarbpalette von #ADDON.",
				},
				color = {
					label = "Schriftfarbe",
					tooltip = "Die Farbe des gesamten Geschwindigkeitswert-Textes, wenn die Option #VALUE_COLORING deaktiviert ist.",
				},
				alignment = {
					label = "Textausrichtung",
					tooltip = "Wähle die horizontale Ausrichtung des Textes in der Geschwindigkeitsanzeige.",
				},
			},
			background = {
				title = "Hintergrund",
				visible = {
					label = "Sichtbar",
					tooltip = "Schalte die Sichtbarkeit der Hintergrundelemente der Geschwindigkeitsanzeige ein oder aus.",
				},
				colors = {
					bg = {
						label = "Hintergrundfarbe",
					},
					border = {
						label = "Rahmenfarbe",
					},
				},
			},
		},
		playerSpeed = {
			title = "Spielergeschwindigkeit",
			description = "Berechne deine Geschwindigkeit, beeinflusst durch deinen Tempo-Wert, Reittiere, Buffs, Debuffs oder die Art der Bewegung.",
		},
		travelSpeed = {
			title = "Reisegeschwindigkeit",
			description = "Berechne die geschätzte Geschwindigkeit, mit der du dich tatsächlich horizontal durch die aktuelle Zone bewegst.",
		},
		targetSpeed = {
			title = "Zielgeschwindigkeit",
			description = "Sieh dir die aktuelle Bewegungsgeschwindigkeit eines Spielers oder NPCs an, den du per Mouseover inspizierst.",
			mouseover = {
				title = "Inspektions-Tooltip",
				enabled = {
					label = "Integration aktivieren",
					tooltip = "Aktiviere oder deaktiviere die #ADDON-Integration im Mouseover-Inspektions-Tooltip."
				},
			},
		},
	},
	presets = {
		"Unter der Minikarte",
		"Unter der #TYPE Anzeige",
		"Oberhalb der #TYPE Anzeige",
		"Rechts von der #TYPE Anzeige",
		"Links von der #TYPE Anzeige",
	},
	chat = {
		position = {
			save = "Die Position der #TYPE Anzeige wurde gespeichert.",
			cancel = "Die Neupositionierung der #TYPE Anzeige wurde abgebrochen.",
			error = "Halte SHIFT gedrückt, bis die Maustaste losgelassen wird, um die Position zu speichern.",
		},
		status = {
			visible = "Die #TYPE Anzeige ist sichtbar (#AUTO).",
			notVisible = "Die #TYPE Anzeige ist nicht sichtbar (#AUTO).",
			hidden = "Die #TYPE Anzeige ist versteckt (#AUTO).",
			auto = "automatisch ausblenden: #STATE",
		},
		help = {
			move = "Halte SHIFT gedrückt, um die Geschwindigkeitsanzeigen beliebig zu verschieben.",
		},
		options = {
			description = "Öffne die #ADDON Optionen",
		},
		preset = {
			description = "Wende ein #TYPE Anzeige-Preset an (z.B. #INDEX)",
			response = "Das #PRESET-Preset wurde auf die #TYPE Anzeige angewendet.",
			unchanged = "Das angegebene Preset konnte nicht angewendet werden.",
			error = "Bitte gib einen gültigen Preset-Index ein (z.B. #INDEX).",
			list = "Folgende Presets sind verfügbar:",
		},
		save = {
			description = "Speichere dieses #TYPE Anzeige-Setup als das #CUSTOM Preset",
			response = "Die aktuelle Position und Sichtbarkeit der #TYPE Anzeige wurde im #CUSTOM Preset gespeichert.",
		},
		reset = {
			description = "Setze das #TYPE Anzeige #CUSTOM Preset auf Standard zurück",
			response = "Das #CUSTOM Preset wurde auf Standard zurückgesetzt.",
		},
		toggle = {
			description = "Zeige oder verstecke die #TYPE Anzeige (#HIDDEN)",
			hiding = "Die #TYPE Anzeige wurde versteckt.",
			unhiding = "Die #TYPE Anzeige wurde sichtbar gemacht.",
			hidden = "versteckt",
			notHidden = "nicht versteckt",
		},
		auto = {
			description = "Blende die #TYPE Anzeige beim Stillstand aus (#STATE)",
			response = "Das automatische Ausblenden der #TYPE Anzeige wurde auf #STATE gesetzt.",
		},
		size = {
			description = "Setze die Schriftgröße der #TYPE Anzeige (z.B. #SIZE)",
			response = "Die Schriftgröße der #TYPE Anzeige wurde auf #VALUE gesetzt.",
			unchanged = "Die Schriftgröße der #TYPE Anzeige wurde nicht geändert.",
			error = "Bitte gib einen gültigen Zahlenwert ein (z.B. #SIZE).",
		},
		swap = {
			description = "Wechsle die Anzeige, die durch Chatbefehle gesteuert wird (aktuell: #ACTIVE)",
			response = "Die Anzeige, die durch Chatbefehle beeinflusst wird, wurde auf die #ACTIVE Anzeige geändert.",
		},
		profile = {
			description = "Aktiviere ein Einstellungsprofil (z.B. #INDEX)",
			response = "Das #PROFILE Einstellungsprofil wurde aktiviert.",
			unchanged = "Das angegebene Profil konnte nicht aktiviert werden.",
			error = "Bitte gib einen gültigen Profilnamen oder Index ein (z.B. #INDEX).",
			list = "Folgende Profile sind verfügbar:",
		},
		default = {
			description = "Setze das aktive #PROFILE Einstellungsprofil auf Standard zurück",
			response = "Das aktive #PROFILE Einstellungsprofil wurde auf Standard zurückgesetzt.",
			responseCategory = "Die Einstellungen der Kategorie #CATEGORY im aktiven #PROFILE Einstellungsprofil wurden auf Standard zurückgesetzt.",
		},
	},
	targetSpeed = "Geschwindigkeit: #SPEED",
	speedTooltip = {
		title = "#SPEED Details:",
		description = "Live-Bewegungsstatus-Übersicht.",
		playerSpeed = "Berechnet basierend auf deiner aktuellen Bewegungsart, beeinflusst durch den Tempo-Wert sowie verschiedene Buffs, Debuffs, Reittiere und andere Effekte.",
		travelSpeed = "Geschätzt durch Verfolgung deiner horizontalen Bewegung in der aktuellen Zone, negativ beeinflusst durch Hindernisse und den Bewegungswinkel beim Fliegen.",
		instanceError = "Nicht verfügbar in dieser Instanz!",
		text = {
			"#YARDS Meter / Sekunde.",
			"#PERCENT der Basislaufgeschwindigkeit.",
			"#COORDS Koordinaten / Sekunde.",
		},
		mapTitle = "Aktuelle Zone: #MAP",
		mapSize = "Kartengröße: #SIZE",
		mapSizeValues = "#W x #H Meter",
		hintOptions = "Rechtsklick für spezifische Optionen.",
		hintMove = "Halte SHIFT & ziehe zum Verschieben.",
	},
	speedValue = {
		yardsps = "#YARDS m/s",
		yps = "#YARDS m/s",
		coordsps = "#COORDS Koord./s",
		cps = "#COORDS K/s",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "Optionen",
		default = "Standard",
		custom = "Benutzerdefiniert",
		enabled = "aktiviert",
		disabled = "deaktiviert",
		days = "Tage",
		hours = "Stunden",
		minutes = "Minuten",
		seconds = "Sekunden",
	},
}

--[ French ]

---@class strings
ns.localizations.frFR = {
	options = {
		main = {
			description = "Personnalisez #ADDON selon vos besoins.\nTapez #KEYWORD1 ou #KEYWORD2 pour les commandes de chat.",
			shortcuts = {
				title = "Raccourcis",
				description = "Accédez à des options spécifiques en développant les catégories #ADDON à gauche ou en cliquant sur un bouton ici.",
			},
		},
		speedValue = {
			title = "Valeur de vitesse",
			units = {
				label = "Unités affichées",
				tooltip = "Sélectionnez les types d'unités à afficher dans le texte de la valeur de vitesse.",
				list = {
					{
						label = "Pourcentage",
						tooltip = "Afficher la valeur de vitesse en pourcentage de la vitesse de course de base (qui est de 7 yards par seconde)."
					},
					{
						label = "Yards/seconde",
						tooltip = "Afficher la valeur de vitesse comme distance en yards parcourue par seconde.",
					},
					{
						label = "Coordonnées/seconde",
						tooltip = "Afficher la valeur de vitesse comme distance en coordonnées parcourue par seconde.",
					},
				},
			},
			fractionals = {
				label = "Nombre maximal de décimales",
				tooltip = "Définissez le nombre maximal de décimales à afficher dans la partie fractionnaire des valeurs de vitesse.\n\nChaque valeur de vitesse sera arrondie au nombre le plus proche selon la précision décimale indiquée ici.\n\nLes valeurs de coordonnées sont toujours affichées avec au moins une décimale.",
			},
			zeros = {
				label = "Afficher les zéros finaux",
				tooltip = "Toujours afficher le nombre de décimales spécifié, ne pas supprimer les zéros finaux.",
			},
		},
		speedDisplay = {
			title = "Affichage #TYPE",
			referenceName = "l'affichage #TYPE",
			copy = {
				label = "Copier les valeurs #TYPE",
				tooltip = "Définissez ces options pour refléter les valeurs des options correspondantes définies pour le #TITLE.",
			},
			visibility = {
				title = "Visibilité",
				hidden = {
					label = "Caché",
					tooltip = "Activer ou désactiver les affichages #ADDON.",
				},
				autoHide = {
					label = "Cacher à l'arrêt",
					tooltip = "Masquer automatiquement l'affichage de la vitesse lorsque vous ne bougez pas.",
				},
				statusNotice = {
					label = "Notification de chat si caché",
					tooltip = "Recevez une notification dans le chat sur le statut de l'affichage de la vitesse s'il n'est pas visible après le chargement de l'interface.",
				},
			},
			update = {
				title = "Mise à jour de la vitesse",
				throttle = {
					label = "Limiter les mises à jour",
					tooltip = "Ralentir la fréquence de mise à jour de la valeur de vitesse pour correspondre à la #FREQUENCY spécifiée au lieu du taux d'images.\n\nCela améliorera légèrement les performances du processeur.",
				},
				frequency = {
					label = "Fréquence de mise à jour",
					tooltip = "Définissez le temps en secondes à attendre avant que la valeur de vitesse soit mise à jour à nouveau.",
				},
			},
			font = {
				title = "Police & Texte",
				family = {
					label = "Police",
					tooltip = "Sélectionnez la police du texte de la valeur de vitesse.",
					default = "Ceci est une police par défaut utilisée par Blizzard.",
					custom = {
						"Vous pouvez définir l'option #OPTION_CUSTOM sur n'importe quelle police en remplaçant le fichier #FILE_CUSTOM par un autre fichier TrueType Font trouvé dans :",
						"tout en gardant le nom original #FILE_CUSTOM.",
						"Vous devrez peut-être redémarrer le client du jeu après avoir remplacé le fichier de police personnalisée.",
					},
				},
				size = {
					label = "Taille de la police",
					tooltip = "Définissez la taille du texte affiché.",
				},
				valueColoring = {
					label = "Coloration individuelle des valeurs",
					tooltip = "Colorer les valeurs de vitesse dans l'affichage avec la palette de couleurs par défaut de #ADDON.",
				},
				color = {
					label = "Couleur de la police",
					tooltip = "La couleur de tout le texte de la valeur de vitesse lorsque l'option #VALUE_COLORING est désactivée.",
				},
				alignment = {
					label = "Alignement du texte",
					tooltip = "Sélectionnez l'alignement horizontal du texte dans l'affichage de la vitesse.",
				},
			},
			background = {
				title = "Arrière-plan",
				visible = {
					label = "Visible",
					tooltip = "Activer ou désactiver la visibilité des éléments d'arrière-plan de l'affichage de la vitesse.",
				},
				colors = {
					bg = {
						label = "Couleur d'arrière-plan",
					},
					border = {
						label = "Couleur de la bordure",
					},
				},
			},
		},
		playerSpeed = {
			title = "Vitesse du joueur",
			description = "Calculez votre vitesse, modifiée par votre statistique de vitesse, montures, buffs, debuffs ou le type d'activité de mouvement.",
		},
		travelSpeed = {
			title = "Vitesse de déplacement",
			description = "Calculez la vitesse estimée à laquelle vous vous déplacez réellement horizontalement dans la zone actuelle.",
		},
		targetSpeed = {
			title = "Vitesse de la cible",
			description = "Affichez la vitesse de déplacement actuelle de tout joueur ou PNJ que vous inspectez via le survol de la souris.",
			mouseover = {
				title = "Tooltip d'inspection",
				enabled = {
					label = "Activer l'intégration",
					tooltip = "Activer ou désactiver l'intégration #ADDON dans le tooltip d'inspection de la cible au survol."
				},
			},
		},
	},
	presets = {
		"Sous la mini-carte",
		"Sous l'affichage #TYPE",
		"Au-dessus de l'affichage #TYPE",
		"À droite de l'affichage #TYPE",
		"À gauche de l'affichage #TYPE",
	},
	chat = {
		position = {
			save = "La position de l'affichage #TYPE a été enregistrée.",
			cancel = "Le repositionnement de l'affichage #TYPE a été annulé.",
			error = "Maintenez SHIFT enfoncé jusqu'à ce que le bouton de la souris soit relâché pour enregistrer la position.",
		},
		status = {
			visible = "L'affichage #TYPE est visible (#AUTO).",
			notVisible = "L'affichage #TYPE n'est pas visible (#AUTO).",
			hidden = "L'affichage #TYPE est caché (#AUTO).",
			auto = "masquage auto : #STATE",
		},
		help = {
			move = "Maintenez SHIFT pour déplacer les affichages de vitesse où vous le souhaitez.",
		},
		options = {
			description = "ouvrir les options de #ADDON",
		},
		preset = {
			description = "appliquer un préréglage d'affichage #TYPE (ex : #INDEX)",
			response = "Le préréglage #PRESET a été appliqué à l'affichage #TYPE.",
			unchanged = "Le préréglage spécifié n'a pas pu être appliqué.",
			error = "Veuillez entrer un index de préréglage valide (ex : #INDEX).",
			list = "Les préréglages suivants sont disponibles :",
		},
		save = {
			description = "enregistrer cette configuration d'affichage #TYPE comme préréglage #CUSTOM",
			response = "La position et la visibilité actuelles de l'affichage #TYPE ont été enregistrées dans le préréglage #CUSTOM.",
		},
		reset = {
			description = "réinitialiser le préréglage #CUSTOM de l'affichage #TYPE par défaut",
			response = "Le préréglage #CUSTOM a été réinitialisé par défaut.",
		},
		toggle = {
			description = "afficher ou cacher l'affichage #TYPE (#HIDDEN)",
			hiding = "L'affichage #TYPE a été caché.",
			unhiding = "L'affichage #TYPE a été rendu visible.",
			hidden = "caché",
			notHidden = "non caché",
		},
		auto = {
			description = "cacher l'affichage #TYPE à l'arrêt (#STATE)",
			response = "Le masquage automatique de l'affichage #TYPE a été défini sur #STATE.",
		},
		size = {
			description = "définir la taille de la police de l'affichage #TYPE (ex : #SIZE)",
			response = "La taille de la police de l'affichage #TYPE a été définie sur #VALUE.",
			unchanged = "La taille de la police de l'affichage #TYPE n'a pas été modifiée.",
			error = "Veuillez entrer une valeur numérique valide (ex : #SIZE).",
		},
		swap = {
			description = "changer l'affichage affecté par les commandes de chat (actuel : #ACTIVE)",
			response = "L'affichage affecté par les commandes de chat a été changé pour l'affichage #ACTIVE.",
		},
		profile = {
			description = "activer un profil de paramètres (ex : #INDEX)",
			response = "Le profil de paramètres #PROFILE a été activé.",
			unchanged = "Le profil spécifié n'a pas pu être activé.",
			error = "Veuillez entrer un nom ou un index de profil valide (ex : #INDEX).",
			list = "Les profils suivants sont disponibles :",
		},
		default = {
			description = "réinitialiser le profil de paramètres #PROFILE actif par défaut",
			response = "Le profil de paramètres #PROFILE actif a été réinitialisé par défaut.",
			responseCategory = "Les paramètres de la catégorie #CATEGORY dans le profil de paramètres #PROFILE actif ont été réinitialisés par défaut.",
		},
	},
	targetSpeed = "Vitesse : #SPEED",
	speedTooltip = {
		title = "Détails #SPEED :",
		description = "Résumé du statut de mouvement en direct.",
		playerSpeed = "Calculé selon le type de votre activité de mouvement actuelle, modifié par la statistique de vitesse et divers buffs, debuffs, montures et autres effets.",
		travelSpeed = "Estimé en suivant votre déplacement horizontal dans la zone actuelle, affecté négativement par les obstacles et l'angle de déplacement en vol.",
		instanceError = "Non disponible dans cette instance !",
		text = {
			"#YARDS yards / seconde.",
			"#PERCENT de la vitesse de course de base.",
			"#COORDS coordonnées / seconde.",
		},
		mapTitle = "Zone actuelle : #MAP",
		mapSize = "Taille de la carte : #SIZE",
		mapSizeValues = "#W x #H yards",
		hintOptions = "Clique-droit pour accéder aux options spécifiques.",
		hintMove = "Maintenez SHIFT & faites glisser pour repositionner.",
	},
	speedValue = {
		yardsps = "#YARDS yards/s",
		yps = "#YARDS y/s",
		coordsps = "#COORDS coords/s",
		cps = "#COORDS c/s",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "Options",
		default = "Par défaut",
		custom = "Personnalisé",
		enabled = "activé",
		disabled = "désactivé",
		days = "jours",
		hours = "heures",
		minutes = "minutes",
		seconds = "secondes",
	},
}

--[ Spanish (Spain) ]

---@class strings
ns.localizations.esES = {
	options = {
		main = {
			description = "Personaliza #ADDON según tus necesidades.\nEscribe #KEYWORD1 o #KEYWORD2 para comandos de chat.",
			shortcuts = {
				title = "Atajos",
				description = "Accede a opciones específicas expandiendo las categorías de #ADDON a la izquierda o haciendo clic en un botón aquí.",
			},
		},
		speedValue = {
			title = "Valor de velocidad",
			units = {
				label = "Unidades mostradas",
				tooltip = "Selecciona qué tipos de unidades deben aparecer en el texto del valor de velocidad.",
				list = {
					{
						label = "Porcentaje",
						tooltip = "Muestra el valor de velocidad como porcentaje de la velocidad base de carrera (que es 7 yardas por segundo)."
					},
					{
						label = "Yardas/segundo",
						tooltip = "Muestra el valor de velocidad como distancia en yardas recorridas por segundo.",
					},
					{
						label = "Coordenadas/segundo",
						tooltip = "Muestra el valor de velocidad como distancia en coordenadas recorridas por segundo.",
					},
				},
			},
			fractionals = {
				label = "Máximo de decimales",
				tooltip = "Establece el número máximo de decimales que se mostrarán en la parte fraccionaria de los valores de velocidad.\n\nCada valor se redondeará al número más cercano según la precisión decimal especificada aquí.\n\nLos valores de coordenadas siempre se muestran con al menos un decimal.",
			},
			zeros = {
				label = "Mostrar ceros finales",
				tooltip = "Muestra siempre el número especificado de decimales, no elimines los ceros finales.",
			},
		},
		speedDisplay = {
			title = "Visualización #TYPE",
			referenceName = "la visualización #TYPE",
			copy = {
				label = "Copiar valores #TYPE",
				tooltip = "Configura estas opciones para reflejar los valores de las opciones equivalentes establecidas para el #TITLE.",
			},
			visibility = {
				title = "Visibilidad",
				hidden = {
					label = "Oculto",
					tooltip = "Activa o desactiva las visualizaciones de #ADDON.",
				},
				autoHide = {
					label = "Ocultar al estar parado",
					tooltip = "Oculta automáticamente la visualización de velocidad cuando no te estás moviendo.",
				},
				statusNotice = {
					label = "Aviso en el chat si está oculto",
					tooltip = "Recibe una notificación en el chat sobre el estado de la visualización de velocidad si no es visible tras cargar la interfaz.",
				},
			},
			update = {
				title = "Actualización de velocidad",
				throttle = {
					label = "Limitar actualizaciones",
					tooltip = "Reduce la frecuencia de actualización del valor de velocidad para que coincida con la #FREQUENCY especificada en vez de la tasa de fotogramas.\n\nEsto mejorará ligeramente el rendimiento de la CPU.",
				},
				frequency = {
					label = "Frecuencia de actualización",
					tooltip = "Establece el tiempo en segundos que debe esperar antes de actualizar el valor de velocidad de nuevo.",
				},
			},
			font = {
				title = "Fuente y texto",
				family = {
					label = "Fuente",
					tooltip = "Selecciona la fuente del texto del valor de velocidad.",
					default = "Esta es una fuente predeterminada usada por Blizzard.",
					custom = {
						"Puedes establecer la opción #OPTION_CUSTOM en cualquier fuente que desees reemplazando el archivo #FILE_CUSTOM por otro archivo TrueType Font encontrado en:",
						"manteniendo el nombre original #FILE_CUSTOM.",
						"Puede que necesites reiniciar el cliente del juego después de reemplazar el archivo de fuente personalizada.",
					},
				},
				size = {
					label = "Tamaño de fuente",
					tooltip = "Establece el tamaño del texto mostrado.",
				},
				valueColoring = {
					label = "Coloreado individual de valores",
					tooltip = "Colorea los valores de velocidad en la visualización con la paleta de colores predeterminada de #ADDON.",
				},
				color = {
					label = "Color de fuente",
					tooltip = "El color de todo el texto del valor de velocidad cuando la opción #VALUE_COLORING está desactivada.",
				},
				alignment = {
					label = "Alineación de texto",
					tooltip = "Selecciona la alineación horizontal del texto dentro de la visualización de velocidad.",
				},
			},
			background = {
				title = "Fondo",
				visible = {
					label = "Visible",
					tooltip = "Activa o desactiva la visibilidad de los elementos de fondo de la visualización de velocidad.",
				},
				colors = {
					bg = {
						label = "Color de fondo",
					},
					border = {
						label = "Color del borde",
					},
				},
			},
		},
		playerSpeed = {
			title = "Velocidad del jugador",
			description = "Calcula tu velocidad, modificada por tu estadística de velocidad, monturas, beneficios, perjuicios o el tipo de movimiento.",
		},
		travelSpeed = {
			title = "Velocidad de viaje",
			description = "Calcula la velocidad estimada a la que realmente te desplazas horizontalmente por la zona actual.",
		},
		targetSpeed = {
			title = "Velocidad del objetivo",
			description = "Muestra la velocidad de movimiento actual de cualquier jugador o PNJ que inspecciones con el ratón.",
			mouseover = {
				title = "Tooltip de inspección",
				enabled = {
					label = "Activar integración",
					tooltip = "Activa o desactiva la integración de #ADDON en el tooltip de inspección del objetivo al pasar el ratón."
				},
			},
		},
	},
	presets = {
		"Debajo del minimapa",
		"Debajo de la visualización #TYPE",
		"Encima de la visualización #TYPE",
		"A la derecha de la visualización #TYPE",
		"A la izquierda de la visualización #TYPE",
	},
	chat = {
		position = {
			save = "La posición de la visualización #TYPE ha sido guardada.",
			cancel = "El cambio de posición de la visualización #TYPE ha sido cancelado.",
			error = "Mantén SHIFT pulsado hasta soltar el botón del ratón para guardar la posición.",
		},
		status = {
			visible = "La visualización #TYPE está visible (#AUTO).",
			notVisible = "La visualización #TYPE no está visible (#AUTO).",
			hidden = "La visualización #TYPE está oculta (#AUTO).",
			auto = "ocultar automáticamente: #STATE",
		},
		help = {
			move = "Mantén SHIFT para arrastrar las visualizaciones de velocidad donde quieras.",
		},
		options = {
			description = "abrir las opciones de #ADDON",
		},
		preset = {
			description = "aplicar un preajuste de visualización #TYPE (ej: #INDEX)",
			response = "El preajuste #PRESET se ha aplicado a la visualización #TYPE.",
			unchanged = "No se pudo aplicar el preajuste especificado.",
			error = "Por favor, introduce un índice de preajuste válido (ej: #INDEX).",
			list = "Los siguientes preajustes están disponibles:",
		},
		save = {
			description = "guardar esta configuración de visualización #TYPE como el preajuste #CUSTOM",
			response = "La posición y visibilidad actual de la visualización #TYPE se ha guardado en el preajuste #CUSTOM.",
		},
		reset = {
			description = "restablecer el preajuste #CUSTOM de la visualización #TYPE a los valores predeterminados",
			response = "El preajuste #CUSTOM ha sido restablecido a los valores predeterminados.",
		},
		toggle = {
			description = "mostrar u ocultar la visualización #TYPE (#HIDDEN)",
			hiding = "La visualización #TYPE ha sido ocultada.",
			unhiding = "La visualización #TYPE se ha hecho visible.",
			hidden = "oculta",
			notHidden = "no oculta",
		},
		auto = {
			description = "ocultar la visualización #TYPE al estar parado (#STATE)",
			response = "La ocultación automática de la visualización #TYPE se ha establecido en #STATE.",
		},
		size = {
			description = "establecer el tamaño de fuente de la visualización #TYPE (ej: #SIZE)",
			response = "El tamaño de fuente de la visualización #TYPE se ha establecido en #VALUE.",
			unchanged = "El tamaño de fuente de la visualización #TYPE no ha cambiado.",
			error = "Por favor, introduce un valor numérico válido (ej: #SIZE).",
		},
		swap = {
			description = "cambiar la visualización afectada por los comandos de chat (actual: #ACTIVE)",
			response = "La visualización afectada por los comandos de chat ha cambiado a la visualización #ACTIVE.",
		},
		profile = {
			description = "activar un perfil de configuración (ej: #INDEX)",
			response = "El perfil de configuración #PROFILE ha sido activado.",
			unchanged = "No se pudo activar el perfil especificado.",
			error = "Por favor, introduce un nombre o índice de perfil válido (ej: #INDEX).",
			list = "Los siguientes perfiles están disponibles:",
		},
		default = {
			description = "restablecer el perfil de configuración #PROFILE activo a los valores predeterminados",
			response = "El perfil de configuración #PROFILE activo ha sido restablecido a los valores predeterminados.",
			responseCategory = "Los ajustes de la categoría #CATEGORY en el perfil de configuración #PROFILE activo han sido restablecidos a los valores predeterminados.",
		},
	},
	targetSpeed = "Velocidad: #SPEED",
	speedTooltip = {
		title = "Detalles de #SPEED:",
		description = "Resumen del estado de movimiento en vivo.",
		playerSpeed = "Calculado según el tipo de actividad de movimiento actual, modificado por la estadística de velocidad y varios beneficios, perjuicios, monturas y otros efectos.",
		travelSpeed = "Estimado siguiendo tu movimiento horizontal por la zona actual, afectado negativamente por obstáculos y el ángulo de movimiento durante el vuelo.",
		instanceError = "¡No disponible en esta instancia!",
		text = {
			"#YARDS yardas / segundo.",
			"#PERCENT de la velocidad base de carrera.",
			"#COORDS coordenadas / segundo.",
		},
		mapTitle = "Zona actual: #MAP",
		mapSize = "Tamaño del mapa: #SIZE",
		mapSizeValues = "#W x #H yardas",
		hintOptions = "Haz clic derecho para acceder a opciones específicas.",
		hintMove = "Mantén SHIFT y arrastra para reposicionar.",
	},
	speedValue = {
		yardsps = "#YARDS yardas/s",
		yps = "#YARDS y/s",
		coordsps = "#COORDS coords/s",
		cps = "#COORDS c/s",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "Opciones",
		default = "Predeterminado",
		custom = "Personalizado",
		enabled = "activado",
		disabled = "desactivado",
		days = "días",
		hours = "horas",
		minutes = "minutos",
		seconds = "segundos",
	},
}

--[ Spanish (Mexico) ]

---@class strings
ns.localizations.esMX = {
	options = {
		main = {
			description = "Personaliza #ADDON según tus necesidades.\nEscribe #KEYWORD1 o #KEYWORD2 para comandos de chat.",
			shortcuts = {
				title = "Atajos",
				description = "Accede a opciones específicas expandiendo las categorías de #ADDON a la izquierda o haciendo clic en un botón aquí.",
			},
		},
		speedValue = {
			title = "Valor de velocidad",
			units = {
				label = "Unidades mostradas",
				tooltip = "Selecciona qué tipos de unidades deben aparecer en el texto del valor de velocidad.",
				list = {
					{
						label = "Porcentaje",
						tooltip = "Muestra el valor de velocidad como porcentaje de la velocidad base de carrera (que es 7 yardas por segundo)."
					},
					{
						label = "Yardas/segundo",
						tooltip = "Muestra el valor de velocidad como distancia en yardas recorridas por segundo.",
					},
					{
						label = "Coordenadas/segundo",
						tooltip = "Muestra el valor de velocidad como distancia en coordenadas recorridas por segundo.",
					},
				},
			},
			fractionals = {
				label = "Máximo de decimales",
				tooltip = "Establece el número máximo de decimales que se mostrarán en la parte fraccionaria de los valores de velocidad.\n\nCada valor se redondeará al número más cercano según la precisión decimal especificada aquí.\n\nLos valores de coordenadas siempre se muestran con al menos un decimal.",
			},
			zeros = {
				label = "Mostrar ceros finales",
				tooltip = "Muestra siempre el número especificado de decimales, no elimines los ceros finales.",
			},
		},
		speedDisplay = {
			title = "Visualización #TYPE",
			referenceName = "la visualización #TYPE",
			copy = {
				label = "Copiar valores #TYPE",
				tooltip = "Configura estas opciones para reflejar los valores de las opciones equivalentes establecidas para el #TITLE.",
			},
			visibility = {
				title = "Visibilidad",
				hidden = {
					label = "Oculto",
					tooltip = "Activa o desactiva las visualizaciones de #ADDON.",
				},
				autoHide = {
					label = "Ocultar al estar parado",
					tooltip = "Oculta automáticamente la visualización de velocidad cuando no te estás moviendo.",
				},
				statusNotice = {
					label = "Aviso en el chat si está oculto",
					tooltip = "Recibe una notificación en el chat sobre el estado de la visualización de velocidad si no es visible tras cargar la interfaz.",
				},
			},
			update = {
				title = "Actualización de velocidad",
				throttle = {
					label = "Limitar actualizaciones",
					tooltip = "Reduce la frecuencia de actualización del valor de velocidad para que coincida con la #FREQUENCY especificada en vez de la tasa de fotogramas.\n\nEsto mejorará ligeramente el rendimiento del CPU.",
				},
				frequency = {
					label = "Frecuencia de actualización",
					tooltip = "Establece el tiempo en segundos que debe esperar antes de actualizar el valor de velocidad de nuevo.",
				},
			},
			font = {
				title = "Fuente y texto",
				family = {
					label = "Fuente",
					tooltip = "Selecciona la fuente del texto del valor de velocidad.",
					default = "Esta es una fuente predeterminada usada por Blizzard.",
					custom = {
						"Puedes establecer la opción #OPTION_CUSTOM en cualquier fuente que desees reemplazando el archivo #FILE_CUSTOM por otro archivo TrueType Font encontrado en:",
						"manteniendo el nombre original #FILE_CUSTOM.",
						"Puede que necesites reiniciar el cliente del juego después de reemplazar el archivo de fuente personalizada.",
					},
				},
				size = {
					label = "Tamaño de fuente",
					tooltip = "Establece el tamaño del texto mostrado.",
				},
				valueColoring = {
					label = "Coloreado individual de valores",
					tooltip = "Colorea los valores de velocidad en la visualización con la paleta de colores predeterminada de #ADDON.",
				},
				color = {
					label = "Color de fuente",
					tooltip = "El color de todo el texto del valor de velocidad cuando la opción #VALUE_COLORING está desactivada.",
				},
				alignment = {
					label = "Alineación de texto",
					tooltip = "Selecciona la alineación horizontal del texto dentro de la visualización de velocidad.",
				},
			},
			background = {
				title = "Fondo",
				visible = {
					label = "Visible",
					tooltip = "Activa o desactiva la visibilidad de los elementos de fondo de la visualización de velocidad.",
				},
				colors = {
					bg = {
						label = "Color de fondo",
					},
					border = {
						label = "Color del borde",
					},
				},
			},
		},
		playerSpeed = {
			title = "Velocidad del jugador",
			description = "Calcula tu velocidad, modificada por tu estadística de velocidad, monturas, beneficios, perjuicios o el tipo de movimiento.",
		},
		travelSpeed = {
			title = "Velocidad de viaje",
			description = "Calcula la velocidad estimada a la que realmente te desplazas horizontalmente por la zona actual.",
		},
		targetSpeed = {
			title = "Velocidad del objetivo",
			description = "Muestra la velocidad de movimiento actual de cualquier jugador o PNJ que inspecciones con el mouse.",
			mouseover = {
				title = "Tooltip de inspección",
				enabled = {
					label = "Activar integración",
					tooltip = "Activa o desactiva la integración de #ADDON en el tooltip de inspección del objetivo al pasar el mouse."
				},
			},
		},
	},
	presets = {
		"Debajo del minimapa",
		"Debajo de la visualización #TYPE",
		"Encima de la visualización #TYPE",
		"A la derecha de la visualización #TYPE",
		"A la izquierda de la visualización #TYPE",
	},
	chat = {
		position = {
			save = "La posición de la visualización #TYPE ha sido guardada.",
			cancel = "El cambio de posición de la visualización #TYPE ha sido cancelado.",
			error = "Mantén SHIFT presionado hasta soltar el botón del mouse para guardar la posición.",
		},
		status = {
			visible = "La visualización #TYPE está visible (#AUTO).",
			notVisible = "La visualización #TYPE no está visible (#AUTO).",
			hidden = "La visualización #TYPE está oculta (#AUTO).",
			auto = "ocultar automáticamente: #STATE",
		},
		help = {
			move = "Mantén SHIFT para arrastrar las visualizaciones de velocidad donde quieras.",
		},
		options = {
			description = "abrir las opciones de #ADDON",
		},
		preset = {
			description = "aplicar un preajuste de visualización #TYPE (ej: #INDEX)",
			response = "El preajuste #PRESET se ha aplicado a la visualización #TYPE.",
			unchanged = "No se pudo aplicar el preajuste especificado.",
			error = "Por favor, ingresa un índice de preajuste válido (ej: #INDEX).",
			list = "Los siguientes preajustes están disponibles:",
		},
		save = {
			description = "guardar esta configuración de visualización #TYPE como el preajuste #CUSTOM",
			response = "La posición y visibilidad actual de la visualización #TYPE se ha guardado en el preajuste #CUSTOM.",
		},
		reset = {
			description = "restablecer el preajuste #CUSTOM de la visualización #TYPE a los valores predeterminados",
			response = "El preajuste #CUSTOM ha sido restablecido a los valores predeterminados.",
		},
		toggle = {
			description = "mostrar u ocultar la visualización #TYPE (#HIDDEN)",
			hiding = "La visualización #TYPE ha sido ocultada.",
			unhiding = "La visualización #TYPE se ha hecho visible.",
			hidden = "oculta",
			notHidden = "no oculta",
		},
		auto = {
			description = "ocultar la visualización #TYPE al estar parado (#STATE)",
			response = "La ocultación automática de la visualización #TYPE se ha establecido en #STATE.",
		},
		size = {
			description = "establecer el tamaño de fuente de la visualización #TYPE (ej: #SIZE)",
			response = "El tamaño de fuente de la visualización #TYPE se ha establecido en #VALUE.",
			unchanged = "El tamaño de fuente de la visualización #TYPE no ha cambiado.",
			error = "Por favor, ingresa un valor numérico válido (ej: #SIZE).",
		},
		swap = {
			description = "cambiar la visualización afectada por los comandos de chat (actual: #ACTIVE)",
			response = "La visualización afectada por los comandos de chat ha cambiado a la visualización #ACTIVE.",
		},
		profile = {
			description = "activar un perfil de configuración (ej: #INDEX)",
			response = "El perfil de configuración #PROFILE ha sido activado.",
			unchanged = "No se pudo activar el perfil especificado.",
			error = "Por favor, ingresa un nombre o índice de perfil válido (ej: #INDEX).",
			list = "Los siguientes perfiles están disponibles:",
		},
		default = {
			description = "restablecer el perfil de configuración #PROFILE activo a los valores predeterminados",
			response = "El perfil de configuración #PROFILE activo ha sido restablecido a los valores predeterminados.",
			responseCategory = "Los ajustes de la categoría #CATEGORY en el perfil de configuración #PROFILE activo han sido restablecidos a los valores predeterminados.",
		},
	},
	targetSpeed = "Velocidad: #SPEED",
	speedTooltip = {
		title = "Detalles de #SPEED:",
		description = "Resumen del estado de movimiento en vivo.",
		playerSpeed = "Calculado según el tipo de actividad de movimiento actual, modificado por la estadística de velocidad y varios beneficios, perjuicios, monturas y otros efectos.",
		travelSpeed = "Estimado siguiendo tu movimiento horizontal por la zona actual, afectado negativamente por obstáculos y el ángulo de movimiento durante el vuelo.",
		instanceError = "¡No disponible en esta instancia!",
		text = {
			"#YARDS yardas / segundo.",
			"#PERCENT de la velocidad base de carrera.",
			"#COORDS coordenadas / segundo.",
		},
		mapTitle = "Zona actual: #MAP",
		mapSize = "Tamaño del mapa: #SIZE",
		mapSizeValues = "#W x #H yardas",
		hintOptions = "Haz clic derecho para acceder a opciones específicas.",
		hintMove = "Mantén SHIFT y arrastra para reposicionar.",
	},
	speedValue = {
		yardsps = "#YARDS yardas/s",
		yps = "#YARDS y/s",
		coordsps = "#COORDS coords/s",
		cps = "#COORDS c/s",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "Opciones",
		default = "Predeterminado",
		custom = "Personalizado",
		enabled = "activado",
		disabled = "desactivado",
		days = "días",
		hours = "horas",
		minutes = "minutos",
		seconds = "segundos",
	},
}

--[ Italian ]

---@class strings
ns.localizations.itIT = {
	options = {
		main = {
			description = "Personalizza #ADDON secondo le tue esigenze.\nDigita #KEYWORD1 o #KEYWORD2 per i comandi in chat.",
			shortcuts = {
				title = "Scorciatoie",
				description = "Accedi a opzioni specifiche espandendo le categorie di #ADDON a sinistra o cliccando un pulsante qui.",
			},
		},
		speedValue = {
			title = "Valore Velocità",
			units = {
				label = "Unità Visualizzate",
				tooltip = "Seleziona quali tipi di unità devono essere presenti nel testo del valore della velocità.",
				list = {
					{
						label = "Percentuale",
						tooltip = "Mostra il valore della velocità come percentuale della velocità base di corsa (che è 7 yard al secondo)."
					},
					{
						label = "Yard/secondo",
						tooltip = "Mostra il valore della velocità come distanza in yard percorse al secondo.",
					},
					{
						label = "Coordinate/secondo",
						tooltip = "Mostra il valore della velocità come distanza in coordinate percorse al secondo.",
					},
				},
			},
			fractionals = {
				label = "Cifre Decimali Massime",
				tooltip = "Imposta il numero massimo di cifre decimali da visualizzare nella parte frazionaria dei valori di velocità.\n\nOgni valore di velocità verrà arrotondato al numero più vicino in base alla precisione decimale specificata qui.\n\nI valori delle coordinate sono sempre visualizzati con almeno una cifra decimale.",
			},
			zeros = {
				label = "Mostra zeri finali",
				tooltip = "Mostra sempre il numero specificato di cifre decimali, non rimuovere gli zeri finali.",
			},
		},
		speedDisplay = {
			title = "Visualizzazione #TYPE",
			referenceName = "la visualizzazione #TYPE",
			copy = {
				label = "Copia valori #TYPE",
				tooltip = "Imposta queste opzioni per rispecchiare i valori delle opzioni corrispondenti impostate per il #TITLE.",
			},
			visibility = {
				title = "Visibilità",
				hidden = {
					label = "Nascosto",
					tooltip = "Abilita o disabilita le visualizzazioni di #ADDON.",
				},
				autoHide = {
					label = "Nascondi da fermo",
					tooltip = "Nascondi automaticamente la visualizzazione della velocità quando non ti muovi.",
				},
				statusNotice = {
					label = "Notifica chat se nascosto",
					tooltip = "Ricevi una notifica in chat sullo stato della visualizzazione della velocità se non è visibile dopo il caricamento dell'interfaccia.",
				},
			},
			update = {
				title = "Aggiornamento Velocità",
				throttle = {
					label = "Limita Aggiornamenti",
					tooltip = "Rallenta la frequenza di aggiornamento del valore della velocità per corrispondere alla #FREQUENCY specificata invece che al frame rate.\n\nQuesto migliorerà leggermente le prestazioni della CPU.",
				},
				frequency = {
					label = "Frequenza Aggiornamento",
					tooltip = "Imposta il tempo in secondi da attendere prima che il valore della velocità venga aggiornato di nuovo.",
				},
			},
			font = {
				title = "Font & Testo",
				family = {
					label = "Font",
					tooltip = "Seleziona il font del testo del valore della velocità.",
					default = "Questo è un font predefinito usato da Blizzard.",
					custom = {
						"Puoi impostare l'opzione #OPTION_CUSTOM su qualsiasi font desideri sostituendo il file #FILE_CUSTOM con un altro file TrueType Font trovato in:",
						"mantenendo il nome originale #FILE_CUSTOM.",
						"Potresti dover riavviare il client di gioco dopo aver sostituito il file del font personalizzato.",
					},
				},
				size = {
					label = "Dimensione Font",
					tooltip = "Imposta la dimensione del testo visualizzato.",
				},
				valueColoring = {
					label = "Colorazione Valori Individuali",
					tooltip = "Colora i valori della velocità nella visualizzazione con la palette di colori predefinita di #ADDON.",
				},
				color = {
					label = "Colore Font",
					tooltip = "Il colore dell'intero testo del valore della velocità quando l'opzione #VALUE_COLORING è disattivata.",
				},
				alignment = {
					label = "Allineamento Testo",
					tooltip = "Seleziona l'allineamento orizzontale del testo all'interno della visualizzazione della velocità.",
				},
			},
			background = {
				title = "Sfondo",
				visible = {
					label = "Visibile",
					tooltip = "Attiva o disattiva la visibilità degli elementi di sfondo della visualizzazione della velocità.",
				},
				colors = {
					bg = {
						label = "Colore Sfondo",
					},
					border = {
						label = "Colore Bordo",
					},
				},
			},
		},
		playerSpeed = {
			title = "Velocità Giocatore",
			description = "Calcola la tua velocità, modificata dalla statistica Velocità, dalle cavalcature, dai bonus, dai malus o dal tipo di movimento.",
		},
		travelSpeed = {
			title = "Velocità di Viaggio",
			description = "Calcola la velocità stimata con cui ti stai effettivamente muovendo orizzontalmente nella zona attuale.",
		},
		targetSpeed = {
			title = "Velocità Bersaglio",
			description = "Visualizza la velocità di movimento attuale di qualsiasi giocatore o PNG che stai ispezionando tramite mouseover.",
			mouseover = {
				title = "Tooltip Ispezione",
				enabled = {
					label = "Abilita Integrazione",
					tooltip = "Abilita o disabilita l'integrazione di #ADDON nel tooltip di ispezione del bersaglio al passaggio del mouse."
				},
			},
		},
	},
	presets = {
		"Sotto la minimappa",
		"Sotto la visualizzazione #TYPE",
		"Sopra la visualizzazione #TYPE",
		"A destra della visualizzazione #TYPE",
		"A sinistra della visualizzazione #TYPE",
	},
	chat = {
		position = {
			save = "La posizione della visualizzazione #TYPE è stata salvata.",
			cancel = "Il riposizionamento della visualizzazione #TYPE è stato annullato.",
			error = "Tieni premuto SHIFT fino al rilascio del tasto del mouse per salvare la posizione.",
		},
		status = {
			visible = "La visualizzazione #TYPE è visibile (#AUTO).",
			notVisible = "La visualizzazione #TYPE non è visibile (#AUTO).",
			hidden = "La visualizzazione #TYPE è nascosta (#AUTO).",
			auto = "nascondi automaticamente: #STATE",
		},
		help = {
			move = "Tieni premuto SHIFT per trascinare le visualizzazioni della velocità dove preferisci.",
		},
		options = {
			description = "apri le opzioni di #ADDON",
		},
		preset = {
			description = "applica un preset di visualizzazione #TYPE (es: #INDEX)",
			response = "Il preset #PRESET è stato applicato alla visualizzazione #TYPE.",
			unchanged = "Il preset specificato non può essere applicato.",
			error = "Inserisci un indice di preset valido (es: #INDEX).",
			list = "I seguenti preset sono disponibili:",
		},
		save = {
			description = "salva questa configurazione di visualizzazione #TYPE come preset #CUSTOM",
			response = "La posizione e la visibilità attuali della visualizzazione #TYPE sono state salvate nel preset #CUSTOM.",
		},
		reset = {
			description = "reimposta il preset #CUSTOM della visualizzazione #TYPE ai valori predefiniti",
			response = "Il preset #CUSTOM è stato reimpostato ai valori predefiniti.",
		},
		toggle = {
			description = "mostra o nascondi la visualizzazione #TYPE (#HIDDEN)",
			hiding = "La visualizzazione #TYPE è stata nascosta.",
			unhiding = "La visualizzazione #TYPE è stata resa visibile.",
			hidden = "nascosta",
			notHidden = "non nascosta",
		},
		auto = {
			description = "nascondi la visualizzazione #TYPE da fermo (#STATE)",
			response = "La funzione di nascondimento automatico della visualizzazione #TYPE è stata impostata su #STATE.",
		},
		size = {
			description = "imposta la dimensione del font della visualizzazione #TYPE (es: #SIZE)",
			response = "La dimensione del font della visualizzazione #TYPE è stata impostata su #VALUE.",
			unchanged = "La dimensione del font della visualizzazione #TYPE non è stata modificata.",
			error = "Inserisci un valore numerico valido (es: #SIZE).",
		},
		swap = {
			description = "cambia la visualizzazione controllata dai comandi in chat (attuale: #ACTIVE)",
			response = "La visualizzazione controllata dai comandi in chat è stata cambiata in #ACTIVE.",
		},
		profile = {
			description = "attiva un profilo di impostazioni (es: #INDEX)",
			response = "Il profilo di impostazioni #PROFILE è stato attivato.",
			unchanged = "Il profilo specificato non può essere attivato.",
			error = "Inserisci un nome o indice di profilo valido (es: #INDEX).",
			list = "I seguenti profili sono disponibili:",
		},
		default = {
			description = "reimposta il profilo di impostazioni #PROFILE attivo ai valori predefiniti",
			response = "Il profilo di impostazioni #PROFILE attivo è stato reimpostato ai valori predefiniti.",
			responseCategory = "Le impostazioni della categoria #CATEGORY nel profilo di impostazioni #PROFILE attivo sono state reimpostate ai valori predefiniti.",
		},
	},
	targetSpeed = "Velocità: #SPEED",
	speedTooltip = {
		title = "Dettagli #SPEED:",
		description = "Riepilogo dello stato di movimento in tempo reale.",
		playerSpeed = "Calcolato in base al tipo di attività di movimento attuale, modificato dalla statistica Velocità e da vari bonus, malus, cavalcature e altri effetti.",
		travelSpeed = "Stimato tracciando il tuo movimento orizzontale nella zona attuale, influenzato negativamente da ostacoli e dall'angolo di movimento durante il volo.",
		instanceError = "Non disponibile in questa istanza!",
		text = {
			"#YARDS yard / secondo.",
			"#PERCENT della velocità base di corsa.",
			"#COORDS coordinate / secondo.",
		},
		mapTitle = "Zona attuale: #MAP",
		mapSize = "Dimensione mappa: #SIZE",
		mapSizeValues = "#W x #H yard",
		hintOptions = "Clic destro per accedere a opzioni specifiche.",
		hintMove = "Tieni premuto SHIFT e trascina per riposizionare.",
	},
	speedValue = {
		yardsps = "#YARDS yard/s",
		yps = "#YARDS y/s",
		coordsps = "#COORDS coord/s",
		cps = "#COORDS c/s",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "Opzioni",
		default = "Predefinito",
		custom = "Personalizzato",
		enabled = "abilitato",
		disabled = "disabilitato",
		days = "giorni",
		hours = "ore",
		minutes = "minuti",
		seconds = "secondi",
	},
}

--[ Korean ]

---@class strings
ns.localizations.koKR = {
	options = {
		main = {
			description = "#ADDON을 필요에 맞게 설정하세요.\n채팅 명령어로 #KEYWORD1 또는 #KEYWORD2를 입력하세요.",
			shortcuts = {
				title = "바로가기",
				description = "왼쪽의 #ADDON 카테고리를 확장하거나 여기 버튼을 클릭하여 특정 옵션에 접근하세요.",
			},
		},
		speedValue = {
			title = "속도 값",
			units = {
				label = "표시 단위",
				tooltip = "속도 값 텍스트에 어떤 단위 유형이 표시될지 선택하세요.",
				list = {
					{
						label = "퍼센트",
						tooltip = "기본 달리기 속도(초당 7야드)의 퍼센트로 속도 값을 표시합니다."
					},
					{
						label = "야드/초",
						tooltip = "초당 이동한 거리(야드)로 속도 값을 표시합니다.",
					},
					{
						label = "좌표/초",
						tooltip = "초당 이동한 거리(좌표)로 속도 값을 표시합니다.",
					},
				},
			},
			fractionals = {
				label = "최대 소수점 자리수",
				tooltip = "속도 값의 소수점 부분에 표시될 최대 자리수를 설정하세요.\n\n여기서 지정한 소수점 정확도에 따라 각 속도 값이 반올림됩니다.\n\n좌표 값은 항상 최소 한 자리 소수점으로 표시됩니다.",
			},
			zeros = {
				label = "0 표시",
				tooltip = "지정한 소수점 자리수를 항상 표시하며, 끝의 0을 생략하지 않습니다.",
			},
		},
		speedDisplay = {
			title = "#TYPE 표시",
			referenceName = "#TYPE 표시",
			copy = {
				label = "#TYPE 값 복사",
				tooltip = "이 옵션을 설정하면 #TITLE에 설정된 동일한 옵션 값을 반영합니다.",
			},
			visibility = {
				title = "표시 여부",
				hidden = {
					label = "숨김",
					tooltip = "#ADDON 표시를 활성화 또는 비활성화합니다.",
				},
				autoHide = {
					label = "정지 시 숨김",
					tooltip = "이동하지 않을 때 속도 표시를 자동으로 숨깁니다.",
				},
				statusNotice = {
					label = "숨김 시 채팅 알림",
					tooltip = "인터페이스 로드 후 속도 표시가 보이지 않으면 채팅으로 상태 알림을 받습니다.",
				},
			},
			update = {
				title = "속도 업데이트",
				throttle = {
					label = "업데이트 속도 제한",
					tooltip = "속도 값의 업데이트 빈도를 프레임레이트 대신 지정한 #FREQUENCY로 맞춥니다.\n\nCPU 성능이 소폭 향상됩니다.",
				},
				frequency = {
					label = "업데이트 빈도",
					tooltip = "속도 값이 다시 업데이트되기까지 대기할 시간을 초 단위로 설정하세요.",
				},
			},
			font = {
				title = "글꼴 및 텍스트",
				family = {
					label = "글꼴",
					tooltip = "속도 값 텍스트의 글꼴을 선택하세요.",
					default = "블리자드에서 사용하는 기본 글꼴입니다.",
					custom = {
						"#OPTION_CUSTOM 옵션을 원하는 글꼴로 설정하려면 #FILE_CUSTOM 파일을 다른 TrueType Font 파일로 교체하세요:",
						"#FILE_CUSTOM 원래 이름을 유지하세요.",
						"사용자 글꼴 파일을 교체한 후 게임 클라이언트를 재시작해야 할 수 있습니다.",
					},
				},
				size = {
					label = "글꼴 크기",
					tooltip = "표시되는 텍스트의 크기를 설정하세요.",
				},
				valueColoring = {
					label = "개별 값 색상",
					tooltip = "표시에 #ADDON 기본 색상 팔레트로 속도 값을 색칠합니다.",
				},
				color = {
					label = "글꼴 색상",
					tooltip = "#VALUE_COLORING 옵션이 꺼져 있을 때 전체 속도 값 텍스트의 색상입니다.",
				},
				alignment = {
					label = "텍스트 정렬",
					tooltip = "속도 표시 내 텍스트의 수평 정렬을 선택하세요.",
				},
			},
			background = {
				title = "배경",
				visible = {
					label = "표시",
					tooltip = "속도 표시의 배경 요소 표시 여부를 설정합니다.",
				},
				colors = {
					bg = {
						label = "배경 색상",
					},
					border = {
						label = "테두리 색상",
					},
				},
			},
		},
		playerSpeed = {
			title = "플레이어 속도",
			description = "속도 스탯, 탈것, 버프, 디버프, 이동 방식에 따라 수정된 자신의 속도를 계산합니다.",
		},
		travelSpeed = {
			title = "이동 속도",
			description = "현재 지역을 수평으로 실제로 이동하는 추정 속도를 계산합니다.",
		},
		targetSpeed = {
			title = "대상 속도",
			description = "마우스오버로 검사 중인 플레이어나 NPC의 현재 이동 속도를 확인합니다.",
			mouseover = {
				title = "툴팁 검사",
				enabled = {
					label = "통합 활성화",
					tooltip = "마우스오버 대상 검사 툴팁에서 #ADDON 통합을 켜거나 끕니다."
				},
			},
		},
	},
	presets = {
		"미니맵 아래",
		"#TYPE 표시 아래",
		"#TYPE 표시 위",
		"#TYPE 표시 오른쪽",
		"#TYPE 표시 왼쪽",
	},
	chat = {
		position = {
			save = "#TYPE 표시 위치가 저장되었습니다.",
			cancel = "#TYPE 표시 위치 변경이 취소되었습니다.",
			error = "SHIFT를 누른 채 마우스 버튼을 뗄 때까지 유지하면 위치가 저장됩니다.",
		},
		status = {
			visible = "#TYPE 표시가 보입니다 (#AUTO).",
			notVisible = "#TYPE 표시가 보이지 않습니다 (#AUTO).",
			hidden = "#TYPE 표시가 숨겨졌습니다 (#AUTO).",
			auto = "자동 숨김: #STATE",
		},
		help = {
			move = "SHIFT를 누른 채 속도 표시를 원하는 곳으로 드래그하세요.",
		},
		options = {
			description = "#ADDON 옵션 열기",
		},
		preset = {
			description = "#TYPE 표시 프리셋 적용 (예: #INDEX)",
			response = "#PRESET 프리셋이 #TYPE 표시로 적용되었습니다.",
			unchanged = "지정한 프리셋을 적용할 수 없습니다.",
			error = "유효한 프리셋 인덱스를 입력하세요 (예: #INDEX).",
			list = "사용 가능한 프리셋 목록:",
		},
		save = {
			description = "현재 #TYPE 표시 설정을 #CUSTOM 프리셋으로 저장",
			response = "현재 #TYPE 표시 위치와 표시 여부가 #CUSTOM 프리셋에 저장되었습니다.",
		},
		reset = {
			description = "활성 #TYPE 표시 #CUSTOM 프리셋을 기본값으로 초기화",
			response = "#CUSTOM 프리셋이 기본값으로 초기화되었습니다.",
		},
		toggle = {
			description = "#TYPE 표시를 보이거나 숨기기 (#HIDDEN)",
			hiding = "#TYPE 표시가 숨겨졌습니다.",
			unhiding = "#TYPE 표시가 보이게 되었습니다.",
			hidden = "숨김",
			notHidden = "숨기지 않음",
		},
		auto = {
			description = "정지 시 #TYPE 표시 숨기기 (#STATE)",
			response = "#TYPE 표시 자동 숨김이 #STATE로 설정되었습니다.",
		},
		size = {
			description = "#TYPE 표시 글꼴 크기 설정 (예: #SIZE)",
			response = "#TYPE 표시 글꼴 크기가 #VALUE로 설정되었습니다.",
			unchanged = "#TYPE 표시 글꼴 크기가 변경되지 않았습니다.",
			error = "유효한 숫자 값을 입력하세요 (예: #SIZE).",
		},
		swap = {
			description = "채팅 명령으로 제어되는 표시 전환 (현재: #ACTIVE)",
			response = "채팅 명령으로 제어되는 표시가 #ACTIVE 표시로 변경되었습니다.",
		},
		profile = {
			description = "설정 프로필 활성화 (예: #INDEX)",
			response = "#PROFILE 설정 프로필이 활성화되었습니다.",
			unchanged = "지정한 프로필을 활성화할 수 없습니다.",
			error = "유효한 프로필 이름 또는 인덱스를 입력하세요 (예: #INDEX).",
			list = "사용 가능한 프로필 목록:",
		},
		default = {
			description = "활성 #PROFILE 설정 프로필을 기본값으로 초기화",
			response = "활성 #PROFILE 설정 프로필이 기본값으로 초기화되었습니다.",
			responseCategory = "활성 #PROFILE 설정 프로필의 #CATEGORY 카테고리 설정이 기본값으로 초기화되었습니다.",
		},
	},
	targetSpeed = "속도: #SPEED",
	speedTooltip = {
		title = "#SPEED 상세 정보:",
		description = "실시간 이동 상태 요약.",
		playerSpeed = "현재 이동 방식, 속도 스탯, 다양한 버프/디버프, 탈것 및 기타 효과에 따라 계산됩니다.",
		travelSpeed = "현재 지역에서 수평 이동을 추적하여 추정하며, 장애물과 비행 시 이동 각도에 따라 감소합니다.",
		instanceError = "이 인스턴스에서는 사용할 수 없습니다!",
		text = {
			"#YARDS 야드 / 초.",
			"기본 달리기 속도의 #PERCENT.",
			"#COORDS 좌표 / 초.",
		},
		mapTitle = "현재 지역: #MAP",
		mapSize = "지도 크기: #SIZE",
		mapSizeValues = "#W x #H 야드",
		hintOptions = "오른쪽 클릭으로 특정 옵션에 접근하세요.",
		hintMove = "SHIFT를 누른 채 드래그하여 위치를 변경하세요.",
	},
	speedValue = {
		yardsps = "#YARDS 야드/초",
		yps = "#YARDS 야드/초",
		coordsps = "#COORDS 좌표/초",
		cps = "#COORDS 좌표/초",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#YEAR년 #MONTH월 #DAY일",
		options = "옵션",
		default = "기본값",
		custom = "사용자 설정",
		enabled = "활성화됨",
		disabled = "비활성화됨",
		days = "일",
		hours = "시간",
		minutes = "분",
		seconds = "초",
	},
}

--[ Chinese (traditional, Taiwan) ]

---@class strings
ns.localizations.zhTW = {
	options = {
		main = {
			description = "自訂#ADDON以符合您的需求\n輸入#KEYWORD1或#KEYWORD2以使用聊天指令。",
			shortcuts = {
				title = "捷徑",
				description = "展開左側的#ADDON分類或點擊此處按鈕以存取特定選項。",
			},
		},
		speedValue = {
			title = "速度數值",
			units = {
				label = "顯示單位",
				tooltip = "選擇速度數值文字中要顯示的單位類型。",
				list = {
					{
						label = "百分比",
						tooltip = "以基礎奔跑速度（每秒7碼）的百分比顯示速度數值。"
					},
					{
						label = "碼/秒",
						tooltip = "以每秒移動的距離（碼）顯示速度數值。",
					},
					{
						label = "座標/秒",
						tooltip = "以每秒移動的距離（座標）顯示速度數值。",
					},
				},
			},
			fractionals = {
				label = "最多小數位數",
				tooltip = "設定速度數值小數部分顯示的最大位數。\n\n每個速度數值將依據此處指定的小數精度四捨五入。\n\n座標值至少會顯示一位小數。",
			},
			zeros = {
				label = "顯示尾端零",
				tooltip = "永遠顯示指定的小數位數，不移除尾端零。",
			},
		},
		speedDisplay = {
			title = "#TYPE顯示",
			referenceName = "#TYPE顯示",
			copy = {
				label = "複製#TYPE數值",
				tooltip = "設定此選項以同步#TITLE設定的相同選項數值。",
			},
			visibility = {
				title = "可見性",
				hidden = {
					label = "隱藏",
					tooltip = "啟用或停用#ADDON顯示。",
				},
				autoHide = {
					label = "靜止時隱藏",
					tooltip = "當您未移動時自動隱藏速度顯示。",
				},
				statusNotice = {
					label = "隱藏時聊天通知",
					tooltip = "介面載入後速度顯示不可見時於聊天收到狀態通知。",
				},
			},
			update = {
				title = "速度更新",
				throttle = {
					label = "更新頻率限制",
					tooltip = "將速度數值的更新頻率降低為指定的#FREQUENCY，而非依據畫面更新率。\n\n可略微提升CPU效能。",
				},
				frequency = {
					label = "更新頻率",
					tooltip = "設定再次更新速度數值前需等待的秒數。",
				},
			},
			font = {
				title = "字型與文字",
				family = {
					label = "字型",
					tooltip = "選擇速度數值文字的字型。",
					default = "這是Blizzard使用的預設字型。",
					custom = {
						"您可將#OPTION_CUSTOM選項設為任意字型，只需將#FILE_CUSTOM檔案替換為其他TrueType字型檔案，檔案位置：",
						"請保持原始檔名#FILE_CUSTOM。",
						"替換自訂字型檔案後可能需要重新啟動遊戲。",
					},
				},
				size = {
					label = "字型大小",
					tooltip = "設定顯示文字的大小。",
				},
				valueColoring = {
					label = "個別數值著色",
					tooltip = "以#ADDON預設配色為顯示中的速度數值著色。",
				},
				color = {
					label = "字型顏色",
					tooltip = "關閉#VALUE_COLORING選項時整個速度數值文字的顏色。",
				},
				alignment = {
					label = "文字對齊",
					tooltip = "選擇速度顯示內文字的水平對齊方式。",
				},
			},
			background = {
				title = "背景",
				visible = {
					label = "可見",
					tooltip = "切換速度顯示背景元素的可見性。",
				},
				colors = {
					bg = {
						label = "背景顏色",
					},
					border = {
						label = "邊框顏色",
					},
				},
			},
		},
		playerSpeed = {
			title = "玩家速度",
			description = "計算您的速度，受速度屬性、坐騎、增益、減益或移動類型影響。",
		},
		travelSpeed = {
			title = "移動速度",
			description = "計算您在目前區域實際水平移動的估算速度。",
		},
		targetSpeed = {
			title = "目標速度",
			description = "查看您滑鼠懸停檢查的玩家或NPC目前移動速度。",
			mouseover = {
				title = "檢查提示",
				enabled = {
					label = "啟用整合",
					tooltip = "啟用或停用#ADDON於滑鼠懸停目標檢查提示的整合。"
				},
			},
		},
	},
	presets = {
		"小地圖下方",
		"#TYPE顯示下方",
		"#TYPE顯示上方",
		"#TYPE顯示右側",
		"#TYPE顯示左側",
	},
	chat = {
		position = {
			save = "#TYPE顯示位置已儲存。",
			cancel = "#TYPE顯示重新定位已取消。",
			error = "按住SHIFT直到放開滑鼠按鈕以儲存位置。",
		},
		status = {
			visible = "#TYPE顯示可見（#AUTO）。",
			notVisible = "#TYPE顯示不可見（#AUTO）。",
			hidden = "#TYPE顯示已隱藏（#AUTO）。",
			auto = "自動隱藏：#STATE",
		},
		help = {
			move = "按住SHIFT拖曳速度顯示到任意位置。",
		},
		options = {
			description = "開啟#ADDON選項",
		},
		preset = {
			description = "套用#TYPE顯示預設（如#INDEX）",
			response = "#PRESET預設已套用至#TYPE顯示。",
			unchanged = "指定的預設無法套用。",
			error = "請輸入有效的預設索引（如#INDEX）。",
			list = "可用預設如下：",
		},
		save = {
			description = "將此#TYPE顯示設定儲存為#CUSTOM預設",
			response = "目前#TYPE顯示位置與可見性已儲存至#CUSTOM預設。",
		},
		reset = {
			description = "將#TYPE顯示#CUSTOM預設重設為預設值",
			response = "#CUSTOM預設已重設為預設值。",
		},
		toggle = {
			description = "顯示或隱藏#TYPE顯示（#HIDDEN）",
			hiding = "#TYPE顯示已隱藏。",
			unhiding = "#TYPE顯示已顯示。",
			hidden = "隱藏",
			notHidden = "未隱藏",
		},
		auto = {
			description = "靜止時隱藏#TYPE顯示（#STATE）",
			response = "#TYPE顯示自動隱藏已設定為#STATE。",
		},
		size = {
			description = "設定#TYPE顯示字型大小（如#SIZE）",
			response = "#TYPE顯示字型大小已設定為#VALUE。",
			unchanged = "#TYPE顯示字型大小未變更。",
			error = "請輸入有效的數值（如#SIZE）。",
		},
		swap = {
			description = "切換聊天指令控制的顯示（目前：#ACTIVE）",
			response = "聊天指令控制的顯示已切換為#ACTIVE顯示。",
		},
		profile = {
			description = "啟用設定檔（如#INDEX）",
			response = "#PROFILE設定檔已啟用。",
			unchanged = "指定的設定檔無法啟用。",
			error = "請輸入有效的設定檔名稱或索引（如#INDEX）。",
			list = "可用設定檔如下：",
		},
		default = {
			description = "將目前#PROFILE設定檔重設為預設值",
			response = "目前#PROFILE設定檔已重設為預設值。",
			responseCategory = "目前#PROFILE設定檔的#CATEGORY分類設定已重設為預設值。",
		},
	},
	targetSpeed = "速度：#SPEED",
	speedTooltip = {
		title = "#SPEED詳細：",
		description = "即時移動狀態摘要。",
		playerSpeed = "依據您目前移動類型、速度屬性及各種增益、減益、坐騎和其他效果計算。",
		travelSpeed = "追蹤您在目前區域的水平移動估算，受障礙物與飛行時移動角度影響。",
		instanceError = "此副本中無法使用！",
		text = {
			"#YARDS碼/秒。",
			"基礎奔跑速度的#PERCENT。",
			"#COORDS座標/秒。",
		},
		mapTitle = "目前區域：#MAP",
		mapSize = "地圖大小：#SIZE",
		mapSizeValues = "#W x #H碼",
		hintOptions = "右鍵點擊以存取特定選項。",
		hintMove = "按住SHIFT並拖曳以重新定位。",
	},
	speedValue = {
		yardsps = "#YARDS碼/秒",
		yps = "#YARDS碼/秒",
		coordsps = "#COORDS座標/秒",
		cps = "#COORDS座標/秒",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "選項",
		default = "預設",
		custom = "自訂",
		enabled = "已啟用",
		disabled = "已停用",
		days = "天",
		hours = "小時",
		minutes = "分鐘",
		seconds = "秒",
	},
}

--[ Chinese (simplified, PRC) ]

---@class strings
ns.localizations.zhCN = {
	options = {
		main = {
			description = "自定义#ADDON以满足您的需求\n输入#KEYWORD1或#KEYWORD2以使用聊天命令。",
			shortcuts = {
				title = "快捷方式",
				description = "通过展开左侧的#ADDON类别或点击此处按钮访问特定选项。",
			},
		},
		speedValue = {
			title = "速度数值",
			units = {
				label = "显示单位",
				tooltip = "选择速度数值文本中应显示的单位类型。",
				list = {
					{
						label = "百分比",
						tooltip = "以基础奔跑速度（每秒7码）的百分比显示速度数值。"
					},
					{
						label = "码/秒",
						tooltip = "以每秒移动的距离（码）显示速度数值。",
					},
					{
						label = "坐标/秒",
						tooltip = "以每秒移动的距离（坐标）显示速度数值。",
					},
				},
			},
			fractionals = {
				label = "最大小数位数",
				tooltip = "设置速度数值小数部分显示的最大位数。\n\n每个速度数值将根据此处指定的小数精度四舍五入。\n\n坐标值始终至少显示一位小数。",
			},
			zeros = {
				label = "显示末尾零",
				tooltip = "始终显示指定的小数位数，不去除末尾零。",
			},
		},
		speedDisplay = {
			title = "#TYPE显示",
			referenceName = "#TYPE显示",
			copy = {
				label = "复制#TYPE数值",
				tooltip = "设置此选项以镜像#TITLE设置的对应选项数值。",
			},
			visibility = {
				title = "可见性",
				hidden = {
					label = "隐藏",
					tooltip = "启用或禁用#ADDON显示。",
				},
				autoHide = {
					label = "静止时隐藏",
					tooltip = "当您未移动时自动隐藏速度显示。",
				},
				statusNotice = {
					label = "隐藏时聊天通知",
					tooltip = "界面加载后速度显示不可见时在聊天中收到状态通知。",
				},
			},
			update = {
				title = "速度更新",
				throttle = {
					label = "更新频率限制",
					tooltip = "将速度数值的更新频率降低为指定的#FREQUENCY，而不是帧率。\n\n这将略微提升CPU性能。",
				},
				frequency = {
					label = "更新频率",
					tooltip = "设置再次更新速度数值前等待的秒数。",
				},
			},
			font = {
				title = "字体与文本",
				family = {
					label = "字体",
					tooltip = "选择速度数值文本的字体。",
					default = "这是暴雪使用的默认字体。",
					custom = {
						"您可以通过将#FILE_CUSTOM文件替换为其他TrueType字体文件，将#OPTION_CUSTOM选项设置为任意字体，文件位置：",
						"请保持原始文件名#FILE_CUSTOM。",
						"替换自定义字体文件后可能需要重启游戏客户端。",
					},
				},
				size = {
					label = "字体大小",
					tooltip = "设置显示文本的大小。",
				},
				valueColoring = {
					label = "单独数值着色",
					tooltip = "使用#ADDON默认配色方案为显示中的速度数值着色。",
				},
				color = {
					label = "字体颜色",
					tooltip = "关闭#VALUE_COLORING选项时整个速度数值文本的颜色。",
				},
				alignment = {
					label = "文本对齐",
					tooltip = "选择速度显示内文本的水平对齐方式。",
				},
			},
			background = {
				title = "背景",
				visible = {
					label = "可见",
					tooltip = "切换速度显示背景元素的可见性。",
				},
				colors = {
					bg = {
						label = "背景颜色",
					},
					border = {
						label = "边框颜色",
					},
				},
			},
		},
		playerSpeed = {
			title = "玩家速度",
			description = "计算您的速度，受速度属性、坐骑、增益、减益或移动类型影响。",
		},
		travelSpeed = {
			title = "移动速度",
			description = "计算您在当前区域实际水平移动的估算速度。",
		},
		targetSpeed = {
			title = "目标速度",
			description = "查看您鼠标悬停检查的玩家或NPC当前移动速度。",
			mouseover = {
				title = "检查提示",
				enabled = {
					label = "启用集成",
					tooltip = "启用或禁用#ADDON在鼠标悬停目标检查提示中的集成。"
				},
			},
		},
	},
	presets = {
		"小地图下方",
		"#TYPE显示下方",
		"#TYPE显示上方",
		"#TYPE显示右侧",
		"#TYPE显示左侧",
	},
	chat = {
		position = {
			save = "#TYPE显示位置已保存。",
			cancel = "#TYPE显示重新定位已取消。",
			error = "按住SHIFT直到释放鼠标按钮以保存位置。",
		},
		status = {
			visible = "#TYPE显示可见（#AUTO）。",
			notVisible = "#TYPE显示不可见（#AUTO）。",
			hidden = "#TYPE显示已隐藏（#AUTO）。",
			auto = "自动隐藏：#STATE",
		},
		help = {
			move = "按住SHIFT拖动速度显示到任意位置。",
		},
		options = {
			description = "打开#ADDON选项",
		},
		preset = {
			description = "应用#TYPE显示预设（如#INDEX）",
			response = "#PRESET预设已应用于#TYPE显示。",
			unchanged = "指定的预设无法应用。",
			error = "请输入有效的预设索引（如#INDEX）。",
			list = "可用预设如下：",
		},
		save = {
			description = "将此#TYPE显示设置保存为#CUSTOM预设",
			response = "当前#TYPE显示位置和可见性已保存到#CUSTOM预设。",
		},
		reset = {
			description = "将#TYPE显示#CUSTOM预设重置为默认",
			response = "#CUSTOM预设已重置为默认。",
		},
		toggle = {
			description = "显示或隐藏#TYPE显示（#HIDDEN）",
			hiding = "#TYPE显示已隐藏。",
			unhiding = "#TYPE显示已显示。",
			hidden = "隐藏",
			notHidden = "未隐藏",
		},
		auto = {
			description = "静止时隐藏#TYPE显示（#STATE）",
			response = "#TYPE显示自动隐藏已设置为#STATE。",
		},
		size = {
			description = "设置#TYPE显示字体大小（如#SIZE）",
			response = "#TYPE显示字体大小已设置为#VALUE。",
			unchanged = "#TYPE显示字体大小未更改。",
			error = "请输入有效的数值（如#SIZE）。",
		},
		swap = {
			description = "切换聊天命令控制的显示（当前：#ACTIVE）",
			response = "聊天命令控制的显示已切换为#ACTIVE显示。",
		},
		profile = {
			description = "激活设置档（如#INDEX）",
			response = "#PROFILE设置档已激活。",
			unchanged = "指定的设置档无法激活。",
			error = "请输入有效的设置档名称或索引（如#INDEX）。",
			list = "可用设置档如下：",
		},
		default = {
			description = "将当前#PROFILE设置档重置为默认",
			response = "当前#PROFILE设置档已重置为默认。",
			responseCategory = "当前#PROFILE设置档的#CATEGORY类别设置已重置为默认。",
		},
	},
	targetSpeed = "速度：#SPEED",
	speedTooltip = {
		title = "#SPEED详情：",
		description = "实时移动状态摘要。",
		playerSpeed = "根据您当前移动类型、速度属性及各种增益、减益、坐骑和其他效果计算。",
		travelSpeed = "通过追踪您在当前区域的水平移动估算，受障碍物和飞行时移动角度影响。",
		instanceError = "在此副本中不可用！",
		text = {
			"#YARDS码/秒。",
			"基础奔跑速度的#PERCENT。",
			"#COORDS坐标/秒。",
		},
		mapTitle = "当前区域：#MAP",
		mapSize = "地图大小：#SIZE",
		mapSizeValues = "#W x #H码",
		hintOptions = "右键点击以访问特定选项。",
		hintMove = "按住SHIFT并拖动以重新定位。",
	},
	speedValue = {
		yardsps = "#YARDS码/秒",
		yps = "#YARDS码/秒",
		coordsps = "#COORDS坐标/秒",
		cps = "#COORDS坐标/秒",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#MONTH/#DAY/#YEAR",
		options = "选项",
		default = "默认",
		custom = "自定义",
		enabled = "已启用",
		disabled = "已禁用",
		days = "天",
		hours = "小时",
		minutes = "分钟",
		seconds = "秒",
	},
}

--[ Russian ]

---@class strings
ns.localizations.ruRU = {
	options = {
		main = {
			description = "Настройте #ADDON под свои нужды.\nВведите #KEYWORD1 или #KEYWORD2 для команд чата.",
			shortcuts = {
				title = "Ярлыки",
				description = "Получите доступ к отдельным опциям, раскрыв категории #ADDON слева или нажав кнопку здесь.",
			},
		},
		speedValue = {
			title = "Значение скорости",
			units = {
				label = "Отображаемые единицы",
				tooltip = "Выберите, какие типы единиц должны присутствовать в тексте значения скорости.",
				list = {
					{
						label = "Проценты",
						tooltip = "Показывать значение скорости в процентах от базовой скорости бега (7 ярдов в секунду)."
					},
					{
						label = "Ярды/секунда",
						tooltip = "Показывать значение скорости как расстояние в ярдах, пройденное за секунду.",
					},
					{
						label = "Координаты/секунда",
						tooltip = "Показывать значение скорости как расстояние в координатах, пройденное за секунду.",
					},
				},
			},
			fractionals = {
				label = "Максимум знаков после запятой",
				tooltip = "Установите максимальное количество знаков после запятой, отображаемых в дробной части значения скорости.\n\nКаждое значение скорости будет округлено до ближайшего числа согласно указанной точности.\n\nЗначения координат всегда отображаются минимум с одной цифрой после запятой.",
			},
			zeros = {
				label = "Показывать нули в конце",
				tooltip = "Всегда показывать указанное количество знаков после запятой, не удалять нули в конце.",
			},
		},
		speedDisplay = {
			title = "Отображение #TYPE",
			referenceName = "отображение #TYPE",
			copy = {
				label = "Копировать значения #TYPE",
				tooltip = "Установите эти опции, чтобы зеркалировать значения соответствующих опций, заданных для #TITLE.",
			},
			visibility = {
				title = "Видимость",
				hidden = {
					label = "Скрыто",
					tooltip = "Включить или выключить отображения #ADDON.",
				},
				autoHide = {
					label = "Скрывать при неподвижности",
					tooltip = "Автоматически скрывать отображение скорости, когда вы не двигаетесь.",
				},
				statusNotice = {
					label = "Уведомление в чате, если скрыто",
					tooltip = "Получайте уведомление в чате о статусе отображения скорости, если оно не видно после загрузки интерфейса.",
				},
			},
			update = {
				title = "Обновление скорости",
				throttle = {
					label = "Ограничить обновления",
					tooltip = "Замедлить частоту обновления значения скорости до указанной #FREQUENCY вместо частоты кадров.\n\nЭто немного повысит производительность процессора.",
				},
				frequency = {
					label = "Частота обновления",
					tooltip = "Установите время в секундах, через которое значение скорости будет обновлено снова.",
				},
			},
			font = {
				title = "Шрифт и текст",
				family = {
					label = "Шрифт",
					tooltip = "Выберите шрифт текста значения скорости.",
					default = "Это стандартный шрифт, используемый Blizzard.",
					custom = {
						"Вы можете установить опцию #OPTION_CUSTOM на любой шрифт, заменив файл #FILE_CUSTOM на другой файл TrueType Font из:",
						"сохранив оригинальное имя #FILE_CUSTOM.",
						"Возможно, потребуется перезапустить игровой клиент после замены файла пользовательского шрифта.",
					},
				},
				size = {
					label = "Размер шрифта",
					tooltip = "Установите размер отображаемого текста.",
				},
				valueColoring = {
					label = "Индивидуальная окраска значений",
					tooltip = "Окрашивать значения скорости в отображении с помощью стандартной цветовой палитры #ADDON.",
				},
				color = {
					label = "Цвет шрифта",
					tooltip = "Цвет всего текста значения скорости, если опция #VALUE_COLORING выключена.",
				},
				alignment = {
					label = "Выравнивание текста",
					tooltip = "Выберите горизонтальное выравнивание текста внутри отображения скорости.",
				},
			},
			background = {
				title = "Фон",
				visible = {
					label = "Видимый",
					tooltip = "Включить или выключить видимость фоновых элементов отображения скорости.",
				},
				colors = {
					bg = {
						label = "Цвет фона",
					},
					border = {
						label = "Цвет рамки",
					},
				},
			},
		},
		playerSpeed = {
			title = "Скорость игрока",
			description = "Рассчитать вашу скорость с учетом характеристики 'Скорость', маунтов, баффов, дебаффов и типа движения.",
		},
		travelSpeed = {
			title = "Скорость перемещения",
			description = "Рассчитать примерную скорость, с которой вы реально перемещаетесь по текущей зоне по горизонтали.",
		},
		targetSpeed = {
			title = "Скорость цели",
			description = "Посмотреть текущую скорость движения любого игрока или NPC, которого вы инспектируете через наведение мыши.",
			mouseover = {
				title = "Подсказка инспекции",
				enabled = {
					label = "Включить интеграцию",
					tooltip = "Включить или выключить интеграцию #ADDON в подсказке инспекции цели при наведении мыши."
				},
			},
		},
	},
	presets = {
		"Под миникартой",
		"Под отображением #TYPE",
		"Над отображением #TYPE",
		"Справа от отображения #TYPE",
		"Слева от отображения #TYPE",
	},
	chat = {
		position = {
			save = "Позиция отображения #TYPE сохранена.",
			cancel = "Перемещение отображения #TYPE отменено.",
			error = "Удерживайте SHIFT до отпускания кнопки мыши для сохранения позиции.",
		},
		status = {
			visible = "Отображение #TYPE видно (#AUTO).",
			notVisible = "Отображение #TYPE не видно (#AUTO).",
			hidden = "Отображение #TYPE скрыто (#AUTO).",
			auto = "авто-скрытие: #STATE",
		},
		help = {
			move = "Удерживайте SHIFT, чтобы перетаскивать отображения скорости куда угодно.",
		},
		options = {
			description = "открыть настройки #ADDON",
		},
		preset = {
			description = "применить пресет отображения #TYPE (например, #INDEX)",
			response = "Пресет #PRESET применён к отображению #TYPE.",
			unchanged = "Указанный пресет не удалось применить.",
			error = "Пожалуйста, введите корректный индекс пресета (например, #INDEX).",
			list = "Доступные пресеты:",
		},
		save = {
			description = "сохранить эту настройку отображения #TYPE как пресет #CUSTOM",
			response = "Текущая позиция и видимость отображения #TYPE сохранены в пресет #CUSTOM.",
		},
		reset = {
			description = "сбросить пресет #CUSTOM отображения #TYPE к стандартным значениям",
			response = "Пресет #CUSTOM сброшен к стандартным значениям.",
		},
		toggle = {
			description = "показать или скрыть отображение #TYPE (#HIDDEN)",
			hiding = "Отображение #TYPE скрыто.",
			unhiding = "Отображение #TYPE стало видимым.",
			hidden = "скрыто",
			notHidden = "не скрыто",
		},
		auto = {
			description = "скрывать отображение #TYPE при неподвижности (#STATE)",
			response = "Автоматическое скрытие отображения #TYPE установлено на #STATE.",
		},
		size = {
			description = "установить размер шрифта отображения #TYPE (например, #SIZE)",
			response = "Размер шрифта отображения #TYPE установлен на #VALUE.",
			unchanged = "Размер шрифта отображения #TYPE не изменён.",
			error = "Пожалуйста, введите корректное числовое значение (например, #SIZE).",
		},
		swap = {
			description = "сменить отображение, управляемое командами чата (текущее: #ACTIVE)",
			response = "Отображение, управляемое командами чата, изменено на #ACTIVE.",
		},
		profile = {
			description = "активировать профиль настроек (например, #INDEX)",
			response = "Профиль настроек #PROFILE активирован.",
			unchanged = "Указанный профиль не удалось активировать.",
			error = "Пожалуйста, введите корректное имя или индекс профиля (например, #INDEX).",
			list = "Доступные профили:",
		},
		default = {
			description = "сбросить активный профиль настроек #PROFILE к стандартным значениям",
			response = "Активный профиль настроек #PROFILE сброшен к стандартным значениям.",
			responseCategory = "Настройки категории #CATEGORY в активном профиле #PROFILE сброшены к стандартным значениям.",
		},
	},
	targetSpeed = "Скорость: #SPEED",
	speedTooltip = {
		title = "Детали #SPEED:",
		description = "Сводка статуса движения в реальном времени.",
		playerSpeed = "Рассчитывается на основе типа вашей текущей активности движения, модифицируется характеристикой 'Скорость', а также различными баффами, дебаффами, маунтами и другими эффектами.",
		travelSpeed = "Оценивается по вашему горизонтальному перемещению по текущей зоне, снижается из-за препятствий и угла движения при полёте.",
		instanceError = "Недоступно в этом подземелье!",
		text = {
			"#YARDS ярдов / секунда.",
			"#PERCENT от базовой скорости бега.",
			"#COORDS координат / секунда.",
		},
		mapTitle = "Текущая зона: #MAP",
		mapSize = "Размер карты: #SIZE",
		mapSizeValues = "#W x #H ярдов",
		hintOptions = "Правый клик для доступа к отдельным опциям.",
		hintMove = "Удерживайте SHIFT и перетаскивайте для перемещения.",
	},
	speedValue = {
		yardsps = "#YARDS ярд/с",
		yps = "#YARDS ярд/с",
		coordsps = "#COORDS коорд/с",
		cps = "#COORDS к/с",
		coordPair = "(#X, #Y)",
		separator = " | ",
	},
	misc = {
		date = "#DAY.#MONTH.#YEAR",
		options = "Настройки",
		default = "Стандарт",
		custom = "Пользовательский",
		enabled = "включено",
		disabled = "выключено",
		days = "дней",
		hours = "часов",
		minutes = "минут",
		seconds = "секунд",
	},
}