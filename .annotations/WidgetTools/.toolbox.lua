--NOTE: Annotations are for development purposes only, providing documentation for use with LUA Language Server. This file does not need to be loaded by the game client.


--[[ LOCALIZATIONS ]]

---English
---@class toolboxStrings_enUS
local enUS = {
	chat = {
		welcome = {
			thanks = "Thank you for using #ADDON!",
			hint = "Type #KEYWORD to see the chat command list.",
			keywords = "#KEYWORD or #KEYWORD_ALTERNATE",
		},
		help = {
			list = "#ADDON chat command list:",
		},
	},
	popupInput = {
		title = "Specify the text",
		tooltip = "Press " .. KEY_ENTER .. " to accept the specified text or " .. KEY_ESCAPE .. " to dismiss it."
	},
	reload = {
		title = "Pending Changes",
		description = "Reload the interface to apply the pending changes.",
		accept = {
			label = "Reload Now",
			tooltip = "You may choose to reload the interface now to apply the pending changes.",
		},
		cancel = {
			label = "Later",
			tooltip = "Reload the interface later with the /reload chat command or by logging out.",
		},
	},
	multiSelector = {
		locked = "Locked",
		minLimit = "At least #MIN options must be selected.",
		maxLimit = "Only #MAX options can be selected at once.",
	},
	dropdown = {
		selected = "This is the currently selected option.",
		none = "No option has been selected.",
		open = "Click to view the list of options.",
		previous = {
			label = "Previous option",
			tooltip = "Select the previous option.",
		},
		next = {
			label = "Next option",
			tooltip = "Select the next option.",
		},
		clear = "Clear selection",
	},
	copyBox = "Copy the text by pressing:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Specify the value",
			tooltip = "Enter any value within range.",
		},
		decrease = {
			label = "Decrease",
			tooltip = {
				"Subtract #VALUE from the value.",
				"Hold ALT to subtract #VALUE instead.",
			},
		},
		increase = {
			label = "Increase",
			tooltip = {
				"Add #VALUE to the value.",
				"Hold ALT to add #VALUE instead.",
			},
		},
	},
	color = {
		picker = {
			label = "Pick a color",
			tooltip = "Open the color picker to customize the color#ALPHA.",
			alpha = " and change the opacity",
		},
		hex = {
			label = "Add via HEX color code",
			tooltip = "You may change the color via HEX code instead of using the color picker.",
		}
	},
	settings = {
		save = "Changes will be finalized on close.",
		cancel = {
			label = "Revert Changes",
			tooltip = "Dismiss all changes made on this page, and load the saved values.",
		},
		defaults = {
			label = "Restore Defaults",
			tooltip = "Restore all settings on this page (or the whole category) to default values.",
		},
		warning = "Are you sure you want to reset the settings on the #PAGE page or all settings in the whole #CATEGORY category to defaults?",
		warningSingle = "Are you sure you want to reset the settings on the #PAGE page to defaults?",
	},
	value = {
		copy = "Copy Value",
		paste = "Paste Value",
		revert = "Revert Changes",
		restore = "Restore Default",
		note = "Right-click to copy or revert.",
	},
	points = {
		left = "Left",
		right = "Right",
		center = "Center",
		top = {
			left = "Top Left",
			right = "Top Right",
			center = "Top Center",
		},
		bottom = {
			left = "Bottom Left",
			right = "Bottom Right",
			center = "Bottom Center",
		},
	},
	strata = {
		lowest = "Low Background",
		lower = "Middle Background",
		low = "High Background",
		lowMid = "Low Middle",
		highMid = "High Middle",
		high = "Low Foreground",
		higher = "Middle Foreground",
		highest = "High Foreground",
	},
	about = {
		title = "About",
		description = "Thanks for using #ADDON! Copy the links to see how to share feedback, get help & support development.",
		version = "Version",
		date = "Date",
		author = "Author",
		license = "License",
		curseForge = "CurseForge Page",
		wago = "Wago Page",
		repository = "GitHub Repository",
		issues = "Issues & Feedback",
		changelog = {
			label = "Update Notes",
			tooltip = "Notes of all the changes, updates & fixes introduced with the latest version release: #VERSION.",
		},
		fullChangelog = {
			label = "#ADDON Changelog",
			tooltip = "The complete list of update notes of all addon version releases.",
			open = {
				label = "Changelog",
				tooltip = "Read the full list of update notes of all addon version releases.",
			},
		},
	},
	sponsors = {
		title = "Sponsors",
		description = "Your continued support is greatly appreciated! Thank you!",
	},
	dataManagement = {
		title = "Data Management",
		description = "Configure #ADDON settings further by managing profiles and backups via importing, exporting options.",
	},
	profiles = {
		title = "Profiles",
		description = "Create, edit and apply unique options profiles specific to each of your characters.",
		select = {
			label = "Select a Profile",
			tooltip = "Choose the options data storage profile to be used for your current character.\n\nThe data in the active profile will be overwritten automatically when settings are modified and saved!",
			profile = "Profile",
			main = "Main",
		},
		new = {
			label = "New Profile",
			tooltip = "Create a new default profile.",
		},
		duplicate = {
			label = "Duplicate",
			tooltip = "Create a new profile, copying the data from the currently active profile.",
		},
		rename = {
			label = "Rename",
			tooltip = "Rename the currently active profile.",
			description = "Rename #PROFILE to:",
		},
		delete = {
			tooltip = "Delete the currently active profile.",
			warning = "Are you sure you want to remove the currently active #PROFILE #ADDON settings profile and permanently delete all settings data stored in it?"
		},
		reset = {
			warning = "Are you sure you want to override the currently active #PROFILE #ADDON settings profile with default values?",
		},
	},
	backup = {
		title = "Backup",
		description = "Import or export data in the currently active profile to save, share or move settings, or edit specific values manually.",
		box = {
			label = "Import or Export Current Profile",
			tooltip = {
				"The backup string in this box contains the currently active addon profile data.",
				"Copy the text to save, share or load data for another account from it.",
				"To load data from a string you have, override the text inside this box, then press " .. KEY_ENTER .. " or click the #LOAD button.",
				"Note: If you're using custom font or texture files, those files cannot carry over with this string. They will need to be saved separately, and pasted into the addon folder to become usable.",
				"Only load strings you have verified yourself or trust the source of!",
			},
		},
		allProfiles = {
			label = "Import or Export All Profiles",
			tooltipLine = "The backup string in this box contains the list of all addon profiles and the data stored in each specific one as well as the name of currently active profile.",
			open = {
				label = "All Profiles",
				tooltip = "Access the full profile list and backup or modify the data stored in each one.",
			},
		},
		compact = {
			label = "Compact",
			tooltip = "Toggle between a compact, and a more readable & editable view.",
		},
		load = {
			label = "Load",
			tooltip = "Check the current string, and attempt to load the data from it.",
		},
		reset = {
			tooltip = "Dismiss all changes made to the string, and reset it to contain the currently stored data.",
		},
		import = "Load the string",
		warning = "Are you sure you want to attempt to load the currently inserted string?\n\nAll unsaved changes will be dismissed.\n\nIf you've copied it from an online source or someone else has sent it to you, only load it after you've checked the code inside and you know what you are doing.\n\nIf don't trust the source, you may want to cancel to prevent any unwanted actions.",
		error = "The provided backup string could not be validated and no data was loaded. It might be missing some characters or errors may have been introduced if it was edited.",
	},
	position = {
		title = "Position",
		description = {
			static = "Fine-tune the position of #FRAME on the screen via the options provided here.",
			movable = "Drag & drop #FRAME while holding SHIFT to position it anywhere on the screen, fine-tune it here.",
		},
		relativePoint = {
			label = "Linking Screen Point",
			tooltip = "Attach the chosen anchor point of #FRAME to the linking point selected here.",
		},
		-- relativeTo = {
		-- 	label = "Link to Frame",
		-- 	tooltip = "Type the name of another UI element, a frame to link the position of #FRAME to.\n\nFind out the names of frames by toggling the debug UI via the /framestack chat command.",
		-- },
		anchor = {
			label = "Linking Anchor Point",
			tooltip = "Select which point #FRAME should be anchored from when linking to the chosen screen point.",
		},
		keepInPlace = {
			label = "Keep in place",
			tooltip = "Don't move #FRAME when changing the #ANCHOR, update the offset values instead.",
		},
		offsetX= {
			label = "Horizontal Offset",
			tooltip = "Set the amount of horizontal offset (X axis) of #FRAME from the selected #ANCHOR.",
		},
		offsetY = {
			label = "Vertical Offset",
			tooltip = "Set the amount of vertical offset (Y axis) of #FRAME from the selected #ANCHOR.",
		},
		keepInBounds = {
			label = "Keep in screen bounds",
			tooltip = "Make sure #FRAME cannot be moved out of screen bounds.",
		},
	},
	presets = {
		apply = {
			label = "Apply a Preset",
			tooltip = "Change the position of #FRAME by choosing and applying one of these presets.",
			list = { "Under Minimap", },
			select = "Select a preset…",
		},
		save = {
			label = "Update #CUSTOM Preset",
			tooltip = "Save the current position and visibility of #FRAME to the #CUSTOM preset.",
			warning = "Are you sure you want to override the #CUSTOM preset with the current values?",
		},
		reset = {
			label = "Reset #CUSTOM Preset",
			tooltip = "Override currently saved #CUSTOM preset data with the default values, then apply it.",
			warning = "Are you sure you want to override the #CUSTOM preset with the default values?",
		},
	},
	layer = {
		strata = {
			label = "Screen Layer",
			tooltip = "Raise or lower #FRAME to be in front of or behind other UI elements.",
		},
		keepOnTop = {
			label = "Reveal on mouse interaction",
			tooltip = "Allow #FRAME to be moved above other frames within the same #STRATA when being interacted with.",
		},
		level = {
			label = "Frame Level",
			tooltip = "The exact position of #FRAME above and under other frames within the same #STRATA stack.",
		},
	},
	font = {
		title = "Text",
		path = {
			label = "Font",
			tooltip = "Select the font.",
			default = {
				label = "Localized Default",
				tooltip = "This is a localized default font used by Blizzard.",
			},
			base = "This is a base game font.",
			custom = "This is a custom font.",
			otf = "OpenType Font license.",
			file = "File path: #PATH",
			replace = "The Custom option offers full customization by letting you use any font by replacing the #FILE_CUSTOM placeholder font file with any other TrueType Font file found in\n#FONTS_DIRECTORY\nwhile keeping its original #FILE_CUSTOM file name.",
			reminder = "You may need to fully restart the game client after replacing the font file to apply the change.",
		},
		size = {
			label = "Size",
			tooltip = "Set the font size.",
		},
		alignment = {
			label = "Alignment",
			tooltip = "Select the horizontal text alignment.",
		},
		color = {
			label = "#COLOR_TYPE Color",
			tooltip = "Set the #COLOR_TYPE text color.",
		},
	},
	date = "#MONTH/#DAY/#YEAR",
	override = "Override",
	example = "Example",
}

---Portuguese (Brazil)
---@class toolboxStrings_ptBR
local ptBR = {
	chat = {
		welcome = {
			thanks = "Obrigado por usar #ADDON!",
			hint = "Digite #KEYWORD para ver a lista de comandos do chat.",
			keywords = "#KEYWORD ou #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Lista de comandos do chat do #ADDON:",
		},
	},
	popupInput = {
		title = "Especifique o texto",
		tooltip = "Pressione " .. KEY_ENTER .. " para aceitar o texto especificado ou " .. KEY_ESCAPE .. " para cancelar.",
	},
	reload = {
		title = "Alterações Pendentes",
		description = "Recarregue a interface para aplicar as alterações pendentes.",
		accept = {
			label = "Recarregar Agora",
			tooltip = "Você pode escolher recarregar a interface agora para aplicar as alterações pendentes.",
		},
		cancel = {
			label = "Depois",
			tooltip = "Recarregue a interface depois com o comando /reload ou saindo do jogo.",
		},
	},
	multiSelector = {
		locked = "Bloqueado",
		minLimit = "Pelo menos #MIN opções devem ser selecionadas.",
		maxLimit = "Apenas #MAX opções podem ser selecionadas ao mesmo tempo.",
	},
	dropdown = {
		selected = "Esta é a opção atualmente selecionada.",
		none = "Nenhuma opção foi selecionada.",
		open = "Clique para ver a lista de opções.",
		previous = {
			label = "Opção anterior",
			tooltip = "Selecionar a opção anterior.",
		},
		next = {
			label = "Próxima opção",
			tooltip = "Selecionar a próxima opção.",
		},
		clear = "Limpar seleção",
	},
	copyBox = "Copie o texto pressionando:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Especifique o valor",
			tooltip = "Digite qualquer valor dentro do intervalo.",
		},
		decrease = {
			label = "Diminuir",
			tooltip = {
				"Subtrai #VALUE do valor.",
				"Segure ALT para subtrair #VALUE em vez disso.",
			},
		},
		increase = {
			label = "Aumentar",
			tooltip = {
				"Adiciona #VALUE ao valor.",
				"Segure ALT para adicionar #VALUE em vez disso.",
			},
		},
	},
	color = {
		picker = {
			label = "Escolher uma cor",
			tooltip = "Abra o seletor de cores para personalizar a cor#ALPHA.",
			alpha = " e alterar a opacidade",
		},
		hex = {
			label = "Adicionar via código HEX",
			tooltip = "Você pode alterar a cor via código HEX em vez de usar o seletor de cores.",
		}
	},
	settings = {
		save = "As alterações serão finalizadas ao fechar.",
		cancel = {
			label = "Reverter Alterações",
			tooltip = "Desfazer todas as alterações feitas nesta página e carregar os valores salvos.",
		},
		defaults = {
			label = "Restaurar Padrões",
			tooltip = "Restaurar todas as configurações desta página (ou categoria) para os valores padrão.",
		},
		warning = "Tem certeza que deseja redefinir as configurações da página #PAGE ou todas as configurações da categoria #CATEGORY para os padrões?",
		warningSingle = "Tem certeza que deseja redefinir as configurações da página #PAGE para os padrões?",
	},
	value = {
		copy = "Copiar Valor",
		paste = "Colar Valor",
		revert = "Reverter Alterações",
		restore = "Restaurar Padrão",
		note = "Clique com o botão direito para copiar ou reverter.",
	},
	points = {
		left = "Esquerda",
		right = "Direita",
		center = "Centro",
		top = {
			left = "Superior Esquerdo",
			right = "Superior Direito",
			center = "Superior Centro",
		},
		bottom = {
			left = "Inferior Esquerdo",
			right = "Inferior Direito",
			center = "Inferior Centro",
		},
	},
	strata = {
		lowest = "Plano de Fundo Baixo",
		lower = "Plano de Fundo Médio",
		low = "Plano de Fundo Alto",
		lowMid = "Meio Baixo",
		highMid = "Meio Alto",
		high = "Primeiro Plano Baixo",
		higher = "Primeiro Plano Médio",
		highest = "Primeiro Plano Alto",
	},
	about = {
		title = "Sobre",
		description = "Obrigado por usar #ADDON! Copie os links para saber como enviar feedback, obter ajuda e apoiar o desenvolvimento.",
		version = "Versão",
		date = "Data",
		author = "Autor",
		license = "Licença",
		curseForge = "Página CurseForge",
		wago = "Página Wago",
		repository = "Repositório GitHub",
		issues = "Problemas & Feedback",
		changelog = {
			label = "Notas da Atualização",
			tooltip = "Notas de todas as mudanças, atualizações e correções introduzidas na versão mais recente: #VERSION.",
		},
		fullChangelog = {
			label = "Changelog do #ADDON",
			tooltip = "A lista completa de notas de atualização de todas as versões do addon.",
			open = {
				label = "Changelog",
				tooltip = "Leia a lista completa de notas de atualização de todas as versões do addon.",
			},
		},
	},
	sponsors = {
		title = "Patrocinadores",
		description = "Seu apoio contínuo é muito apreciado! Obrigado!",
	},
	dataManagement = {
		title = "Gerenciamento de Dados",
		description = "Configure ainda mais as opções do #ADDON gerenciando perfis e backups através das opções de importação e exportação.",
	},
	profiles = {
		title = "Perfis",
		description = "Crie, edite e aplique perfis de opções exclusivos para cada um dos seus personagens.",
		select = {
			label = "Selecionar um Perfil",
			tooltip = "Escolha o perfil de armazenamento de dados de opções a ser usado para seu personagem atual.\n\nOs dados do perfil ativo serão sobrescritos automaticamente quando as configurações forem modificadas e salvas!",
			profile = "Perfil",
			main = "Principal",
		},
		new = {
			label = "Novo Perfil",
			tooltip = "Criar um novo perfil padrão.",
		},
		duplicate = {
			label = "Duplicar",
			tooltip = "Criar um novo perfil, copiando os dados do perfil ativo.",
		},
		rename = {
			label = "Renomear",
			tooltip = "Renomear o perfil ativo.",
			description = "Renomear #PROFILE para:",
		},
		delete = {
			tooltip = "Excluir o perfil ativo.",
			warning = "Tem certeza que deseja remover o perfil de configurações #PROFILE #ADDON ativo e excluir permanentemente todos os dados armazenados nele?"
		},
		reset = {
			warning = "Tem certeza que deseja sobrescrever o perfil de configurações #PROFILE #ADDON ativo com os valores padrão?",
		},
	},
	backup = {
		title = "Backup",
		description = "Importe ou exporte dados do perfil ativo para salvar, compartilhar, mover configurações ou editar valores manualmente.",
		box = {
			label = "Importar ou Exportar Perfil Atual",
			tooltip = {
				"A string de backup nesta caixa contém os dados do perfil ativo do addon.",
				"Copie o texto para salvar, compartilhar ou carregar dados para outra conta.",
				"Para carregar dados de uma string que você possui, substitua o texto nesta caixa e pressione " .. KEY_ENTER .. " ou clique no botão #LOAD.",
				"Nota: Se você estiver usando arquivos de fonte ou textura personalizados, esses arquivos não serão transferidos com esta string. Eles precisarão ser salvos separadamente e colados na pasta do addon para serem utilizáveis.",
				"Carregue apenas strings que você mesmo verificou ou confia na fonte!",
			},
		},
		allProfiles = {
			label = "Importar ou Exportar Todos os Perfis",
			tooltipLine = "A string de backup nesta caixa contém a lista de todos os perfis do addon e os dados armazenados em cada um, bem como o nome do perfil ativo.",
			open = {
				label = "Todos os Perfis",
				tooltip = "Acesse a lista completa de perfis e faça backup ou modifique os dados armazenados em cada um.",
			},
		},
		compact = {
			label = "Compacto",
			tooltip = "Alternar entre uma visualização compacta e uma mais legível/editável.",
		},
		load = {
			label = "Carregar",
			tooltip = "Verifique a string atual e tente carregar os dados dela.",
		},
		reset = {
			tooltip = "Desfazer todas as alterações feitas na string e restaurá-la para conter os dados atualmente armazenados.",
		},
		import = "Carregar a string",
		warning = "Tem certeza que deseja tentar carregar a string inserida?\n\nTodas as alterações não salvas serão descartadas.\n\nSe você a copiou de uma fonte online ou alguém lhe enviou, só carregue após verificar o código e saber o que está fazendo.\n\nSe não confiar na fonte, cancele para evitar ações indesejadas.",
		error = "A string de backup fornecida não pôde ser validada e nenhum dado foi carregado. Pode estar faltando caracteres ou erros podem ter sido introduzidos se foi editada.",
	},
	position = {
		title = "Posição",
		description = {
			static = "Ajuste a posição de #FRAME na tela usando as opções fornecidas aqui.",
			movable = "Arraste e solte #FRAME segurando SHIFT para posicioná-lo em qualquer lugar da tela, ajuste aqui.",
		},
		relativePoint = {
			label = "Ponto de Ligação na Tela",
			tooltip = "Anexe o ponto de ancoragem escolhido de #FRAME ao ponto de ligação selecionado aqui.",
		},
		-- relativeTo = {
		-- 	label = "Vincular a Quadro",
		-- 	tooltip = "Digite o nome de outro elemento da interface, um quadro para vincular a posição de #FRAME.\n\nDescubra os nomes dos quadros ativando a interface de depuração com o comando /framestack.",
		-- },
		anchor = {
			label = "Ponto de Ancoragem",
			tooltip = "Selecione de qual ponto #FRAME deve ser ancorado ao vincular ao ponto da tela escolhido.",
		},
		keepInPlace = {
			label = "Manter no lugar",
			tooltip = "Não mova #FRAME ao alterar o #ANCHOR, atualize os valores de deslocamento em vez disso.",
		},
		offsetX= {
			label = "Deslocamento Horizontal",
			tooltip = "Defina a quantidade de deslocamento horizontal (eixo X) de #FRAME a partir do #ANCHOR selecionado.",
		},
		offsetY = {
			label = "Deslocamento Vertical",
			tooltip = "Defina a quantidade de deslocamento vertical (eixo Y) de #FRAME a partir do #ANCHOR selecionado.",
		},
		keepInBounds = {
			label = "Manter dentro da tela",
			tooltip = "Certifique-se de que #FRAME não possa ser movido para fora dos limites da tela.",
		},
	},
	presets = {
		apply = {
			label = "Aplicar um Predefinido",
			tooltip = "Altere a posição de #FRAME escolhendo e aplicando um destes predefinidos.",
			list = { "Abaixo do Minimap", },
			select = "Selecione um predefinido…",
		},
		save = {
			label = "Atualizar Predefinido #CUSTOM",
			tooltip = "Salve a posição e visibilidade atuais de #FRAME no predefinido #CUSTOM.",
			warning = "Tem certeza que deseja sobrescrever o predefinido #CUSTOM com os valores atuais?",
		},
		reset = {
			label = "Redefinir Predefinido #CUSTOM",
			tooltip = "Sobrescreva os dados do predefinido #CUSTOM com os valores padrão e aplique.",
			warning = "Tem certeza que deseja sobrescrever o predefinido #CUSTOM com os valores padrão?",
		},
	},
	layer = {
		strata = {
			label = "Camada da Tela",
			tooltip = "Eleve ou abaixe #FRAME para ficar à frente ou atrás de outros elementos da interface.",
		},
		keepOnTop = {
			label = "Revelar ao interagir com o mouse",
			tooltip = "Permitir que #FRAME seja movido acima de outros quadros na mesma #STRATA ao ser interagido.",
		},
		level = {
			label = "Nível do Quadro",
			tooltip = "A posição exata de #FRAME acima ou abaixo de outros quadros na mesma pilha #STRATA.",
		},
	},
	font = {
		title = "Texto",
		path = {
			label = "Fonte",
			tooltip = "Selecione a fonte.",
			default = {
				label = "Padrão Localizado",
				tooltip = "Esta é uma fonte padrão localizada usada pela Blizzard.",
			},
			base = "Esta é uma fonte do jogo base.",
			custom = "Esta é uma fonte personalizada.",
			otf = "Licença de fonte OpenType.",
			file = "Caminho do arquivo: #PATH",
			replace = "A opção Personalizada oferece total customização, permitindo que você use qualquer fonte substituindo o arquivo de fonte #FILE_CUSTOM por qualquer outro arquivo TrueType encontrado em\n#FONTS_DIRECTORY\nmantendo o nome original do arquivo #FILE_CUSTOM.",
			reminder = "Pode ser necessário reiniciar completamente o cliente do jogo após substituir o arquivo de fonte para aplicar a alteração.",
		},
		size = {
			label = "Tamanho",
			tooltip = "Defina o tamanho da fonte.",
		},
		alignment = {
			label = "Alinhamento",
			tooltip = "Selecione o alinhamento horizontal do texto.",
		},
		color = {
			label = "Cor de #COLOR_TYPE",
			tooltip = "Defina a cor do texto #COLOR_TYPE.",
		},
	},
	date = "#DAY/#MONTH/#YEAR",
	override = "Sobrescrever",
	example = "Exemplo",
}

---German
---@class toolboxStrings_deDE
local deDE = {
	chat = {
		welcome = {
			thanks = "Danke, dass du #ADDON verwendest!",
			hint = "Gib #KEYWORD ein, um die Liste der Chatbefehle anzuzeigen.",
			keywords = "#KEYWORD oder #KEYWORD_ALTERNATE",
		},
		help = {
			list = "#ADDON Chatbefehlsliste:",
		},
	},
	popupInput = {
		title = "Text angeben",
		tooltip = "Drücke " .. KEY_ENTER .. ", um den angegebenen Text zu übernehmen, oder " .. KEY_ESCAPE .. ", um abzubrechen."
	},
	reload = {
		title = "Ausstehende Änderungen",
		description = "Lade das Interface neu, um die ausstehenden Änderungen anzuwenden.",
		accept = {
			label = "Jetzt neu laden",
			tooltip = "Du kannst das Interface jetzt neu laden, um die ausstehenden Änderungen anzuwenden.",
		},
		cancel = {
			label = "Später",
			tooltip = "Lade das Interface später mit dem Chatbefehl /reload oder durch Ausloggen neu.",
		},
	},
	multiSelector = {
		locked = "Gesperrt",
		minLimit = "Mindestens #MIN Optionen müssen ausgewählt werden.",
		maxLimit = "Es können nur #MAX Optionen gleichzeitig ausgewählt werden.",
	},
	dropdown = {
		selected = "Dies ist die aktuell ausgewählte Option.",
		none = "Es wurde keine Option ausgewählt.",
		open = "Klicke, um die Liste der Optionen anzuzeigen.",
		previous = {
			label = "Vorherige Option",
			tooltip = "Vorherige Option auswählen.",
		},
		next = {
			label = "Nächste Option",
			tooltip = "Nächste Option auswählen.",
		},
		clear = "Auswahl löschen",
	},
	copyBox = "Kopiere den Text mit:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Wert angeben",
			tooltip = "Gib einen Wert im gültigen Bereich ein.",
		},
		decrease = {
			label = "Verringern",
			tooltip = {
				"Subtrahiere #VALUE vom Wert.",
				"Halte ALT, um stattdessen #VALUE zu subtrahieren.",
			},
		},
		increase = {
			label = "Erhöhen",
			tooltip = {
				"Addiere #VALUE zum Wert.",
				"Halte ALT, um stattdessen #VALUE zu addieren.",
			},
		},
	},
	color = {
		picker = {
			label = "Farbe auswählen",
			tooltip = "Öffne den Farbwähler, um die Farbe#ALPHA anzupassen.",
			alpha = " und die Transparenz zu ändern",
		},
		hex = {
			label = "Per HEX-Farbcode hinzufügen",
			tooltip = "Du kannst die Farbe auch per HEX-Code ändern, anstatt den Farbwähler zu benutzen.",
		}
	},
	settings = {
		save = "Änderungen werden beim Schließen übernommen.",
		cancel = {
			label = "Änderungen verwerfen",
			tooltip = "Alle auf dieser Seite vorgenommenen Änderungen verwerfen und gespeicherte Werte laden.",
		},
		defaults = {
			label = "Standard wiederherstellen",
			tooltip = "Alle Einstellungen auf dieser Seite (oder der gesamten Kategorie) auf Standardwerte zurücksetzen.",
		},
		warning = "Bist du sicher, dass du die Einstellungen der Seite #PAGE oder alle Einstellungen der Kategorie #CATEGORY auf Standard zurücksetzen möchtest?",
		warningSingle = "Bist du sicher, dass du die Einstellungen der Seite #PAGE auf Standard zurücksetzen möchtest?",
	},
	value = {
		copy = "Wert kopieren",
		paste = "Wert einfügen",
		revert = "Änderungen verwerfen",
		restore = "Standard wiederherstellen",
		note = "Rechtsklick, um zu kopieren oder rückgängig zu machen.",
	},
	points = {
		left = "Links",
		right = "Rechts",
		center = "Mitte",
		top = {
			left = "Oben Links",
			right = "Oben Rechts",
			center = "Oben Mitte",
		},
		bottom = {
			left = "Unten Links",
			right = "Unten Rechts",
			center = "Unten Mitte",
		},
	},
	strata = {
		lowest = "Niedrigster Hintergrund",
		lower = "Mittlerer Hintergrund",
		low = "Höchster Hintergrund",
		lowMid = "Niedriges Mittel",
		highMid = "Hohes Mittel",
		high = "Niedriger Vordergrund",
		higher = "Mittlerer Vordergrund",
		highest = "Höchster Vordergrund",
	},
	about = {
		title = "Über",
		description = "Danke, dass du #ADDON verwendest! Kopiere die Links, um Feedback zu geben, Hilfe zu erhalten oder die Entwicklung zu unterstützen.",
		version = "Version",
		date = "Datum",
		author = "Autor",
		license = "Lizenz",
		curseForge = "CurseForge-Seite",
		wago = "Wago-Seite",
		repository = "GitHub-Repository",
		issues = "Probleme & Feedback",
		changelog = {
			label = "Update-Hinweise",
			tooltip = "Hinweise zu allen Änderungen, Updates & Fehlerbehebungen der neuesten Version: #VERSION.",
		},
		fullChangelog = {
			label = "#ADDON Changelog",
			tooltip = "Die vollständige Liste aller Update-Hinweise zu allen Addon-Versionen.",
			open = {
				label = "Changelog",
				tooltip = "Lies die vollständige Liste aller Update-Hinweise zu allen Addon-Versionen.",
			},
		},
	},
	sponsors = {
		title = "Sponsoren",
		description = "Deine fortlaufende Unterstützung wird sehr geschätzt! Vielen Dank!",
	},
	dataManagement = {
		title = "Datenverwaltung",
		description = "Konfiguriere #ADDON weiter, indem du Profile und Backups verwaltest, importierst oder exportierst.",
	},
	profiles = {
		title = "Profile",
		description = "Erstelle, bearbeite und verwende individuelle Optionsprofile für jeden deiner Charaktere.",
		select = {
			label = "Profil auswählen",
			tooltip = "Wähle das Optionsdaten-Profil, das für deinen aktuellen Charakter verwendet werden soll.\n\nDie Daten im aktiven Profil werden automatisch überschrieben, wenn Einstellungen geändert und gespeichert werden!",
			profile = "Profil",
			main = "Haupt",
		},
		new = {
			label = "Neues Profil",
			tooltip = "Ein neues Standardprofil erstellen.",
		},
		duplicate = {
			label = "Duplizieren",
			tooltip = "Ein neues Profil erstellen, das die Daten des aktuell aktiven Profils kopiert.",
		},
		rename = {
			label = "Umbenennen",
			tooltip = "Das aktuell aktive Profil umbenennen.",
			description = "#PROFILE umbenennen in:",
		},
		delete = {
			tooltip = "Das aktuell aktive Profil löschen.",
			warning = "Bist du sicher, dass du das aktuell aktive #PROFILE #ADDON-Einstellungsprofil entfernen und alle darin gespeicherten Daten dauerhaft löschen möchtest?"
		},
		reset = {
			warning = "Bist du sicher, dass du das aktuell aktive #PROFILE #ADDON-Einstellungsprofil mit Standardwerten überschreiben möchtest?",
		},
	},
	backup = {
		title = "Backup",
		description = "Importiere oder exportiere Daten des aktuell aktiven Profils, um Einstellungen zu speichern, zu teilen, zu übertragen oder Werte manuell zu bearbeiten.",
		box = {
			label = "Aktuelles Profil importieren oder exportieren",
			tooltip = {
				"Der Backup-String in diesem Feld enthält die Daten des aktuell aktiven Addon-Profils.",
				"Kopiere den Text, um Daten zu speichern, zu teilen oder für einen anderen Account zu laden.",
				"Um Daten aus einem String zu laden, ersetze den Text in diesem Feld und drücke " .. KEY_ENTER .. " oder klicke auf die #LOAD Schaltfläche.",
				"Hinweis: Wenn du eigene Schriftarten oder Texturen verwendest, werden diese Dateien nicht mit diesem String übertragen. Sie müssen separat gespeichert und in den Addon-Ordner eingefügt werden.",
				"Lade nur Strings, die du selbst überprüft hast oder deren Quelle du vertraust!",
			},
		},
		allProfiles = {
			label = "Alle Profile importieren oder exportieren",
			tooltipLine = "Der Backup-String in diesem Feld enthält die Liste aller Addon-Profile und die darin gespeicherten Daten sowie den Namen des aktuell aktiven Profils.",
			open = {
				label = "Alle Profile",
				tooltip = "Greife auf die vollständige Profilliste zu und sichere oder bearbeite die darin gespeicherten Daten.",
			},
		},
		compact = {
			label = "Kompakt",
			tooltip = "Zwischen einer kompakten und einer besser lesbaren/bearbeitbaren Ansicht umschalten.",
		},
		load = {
			label = "Laden",
			tooltip = "Überprüfe den aktuellen String und versuche, die Daten daraus zu laden.",
		},
		reset = {
			tooltip = "Alle Änderungen am String verwerfen und ihn auf die aktuell gespeicherten Daten zurücksetzen.",
		},
		import = "String laden",
		warning = "Bist du sicher, dass du versuchst, den aktuell eingefügten String zu laden?\n\nAlle nicht gespeicherten Änderungen werden verworfen.\n\nWenn du ihn aus einer Online-Quelle kopiert hast oder jemand ihn dir geschickt hat, lade ihn nur, nachdem du den Code überprüft hast und weißt, was du tust.\n\nWenn du der Quelle nicht vertraust, solltest du abbrechen, um unerwünschte Aktionen zu vermeiden.",
		error = "Der bereitgestellte Backup-String konnte nicht validiert werden und es wurden keine Daten geladen. Es könnten Zeichen fehlen oder Fehler wurden beim Bearbeiten eingefügt.",
	},
	position = {
		title = "Position",
		description = {
			static = "Feinabstimmung der Position von #FRAME auf dem Bildschirm über die hier bereitgestellten Optionen.",
			movable = "Ziehe #FRAME mit gedrückter SHIFT-Taste, um es beliebig zu positionieren, und passe es hier an.",
		},
		relativePoint = {
			label = "Verknüpfungspunkt Bildschirm",
			tooltip = "Verbinde den gewählten Ankerpunkt von #FRAME mit dem hier ausgewählten Verknüpfungspunkt.",
		},
		-- relativeTo = {
		-- 	label = "Mit Frame verknüpfen",
		-- 	tooltip = "Gib den Namen eines anderen UI-Elements ein, um die Position von #FRAME daran zu verknüpfen.\n\nDie Namen von Frames findest du über das Debug-UI mit dem Chatbefehl /framestack.",
		-- },
		anchor = {
			label = "Verknüpfungs-Ankerpunkt",
			tooltip = "Wähle, von welchem Punkt #FRAME verankert werden soll, wenn er mit dem gewählten Bildschirm-Punkt verknüpft wird.",
		},
		keepInPlace = {
			label = "Position beibehalten",
			tooltip = "#FRAME nicht verschieben, wenn der #ANCHOR geändert wird, sondern nur die Offset-Werte anpassen.",
		},
		offsetX= {
			label = "Horizontaler Versatz",
			tooltip = "Lege den horizontalen Versatz (X-Achse) von #FRAME zum gewählten #ANCHOR fest.",
		},
		offsetY = {
			label = "Vertikaler Versatz",
			tooltip = "Lege den vertikalen Versatz (Y-Achse) von #FRAME zum gewählten #ANCHOR fest.",
		},
		keepInBounds = {
			label = "Im Bildschirm halten",
			tooltip = "Stelle sicher, dass #FRAME nicht außerhalb des Bildschirms verschoben werden kann.",
		},
	},
	presets = {
		apply = {
			label = "Voreinstellung anwenden",
			tooltip = "Ändere die Position von #FRAME, indem du eine dieser Voreinstellungen auswählst und anwendest.",
			list = { "Unter der Minimap", },
			select = "Voreinstellung auswählen…",
		},
		save = {
			label = "#CUSTOM Voreinstellung aktualisieren",
			tooltip = "Speichere die aktuelle Position und Sichtbarkeit von #FRAME in der #CUSTOM Voreinstellung.",
			warning = "Bist du sicher, dass du die #CUSTOM Voreinstellung mit den aktuellen Werten überschreiben möchtest?",
		},
		reset = {
			label = "#CUSTOM Voreinstellung zurücksetzen",
			tooltip = "Überschreibe die gespeicherten #CUSTOM Voreinstellungsdaten mit den Standardwerten und wende sie an.",
			warning = "Bist du sicher, dass du die #CUSTOM Voreinstellung mit den Standardwerten überschreiben möchtest?",
		},
	},
	layer = {
		strata = {
			label = "Bildschirmebene",
			tooltip = "#FRAME vor oder hinter anderen UI-Elementen anzeigen.",
		},
		keepOnTop = {
			label = "Bei Mausinteraktion hervorheben",
			tooltip = "Erlaube, dass #FRAME bei Interaktion über anderen Frames derselben #STRATA angezeigt wird.",
		},
		level = {
			label = "Frame-Level",
			tooltip = "Die genaue Position von #FRAME über oder unter anderen Frames im selben #STRATA-Stack.",
		},
	},
	font = {
		title = "Text",
		path = {
			label = "Schriftart",
			tooltip = "Wähle die Schriftart aus.",
			default = {
				label = "Lokalisierte Standardschrift",
				tooltip = "Dies ist eine lokalisierte Standardschriftart, die von Blizzard verwendet wird.",
			},
			base = "Dies ist eine Grundspiel-Schriftart.",
			custom = "Dies ist eine benutzerdefinierte Schriftart.",
			otf = "OpenType-Schriftlizenz.",
			file = "Dateipfad: #PATH",
			replace = "Die Option Benutzerdefiniert bietet vollständige Anpassung, indem Sie die Schriftdatei #FILE_CUSTOM durch eine andere TrueType-Schriftdatei ersetzen, die in\n#FONTS_DIRECTORY\ngefunden wird, während der ursprüngliche Dateiname #FILE_CUSTOM beibehalten wird.",
			reminder = "Möglicherweise müssen Sie den Spielclient vollständig neu starten, nachdem Sie die Schriftdatei ersetzt haben, damit die Änderung wirksam wird.",
		},
		size = {
			label = "Größe",
			tooltip = "Stelle die Schriftgröße ein.",
		},
		alignment = {
			label = "Ausrichtung",
			tooltip = "Wähle die horizontale Textausrichtung.",
		},
		color = {
			label = "#COLOR_TYPE-Farbe",
			tooltip = "Lege die #COLOR_TYPE-Textfarbe fest.",
		},
	},
	date = "#DAY.#MONTH.#YEAR",
	override = "Überschreiben",
	example = "Beispiel",
}

---French
---@class toolboxStrings_frFR
local frFR = {
	chat = {
		welcome = {
			thanks = "Merci d'utiliser #ADDON !",
			hint = "Tapez #KEYWORD pour voir la liste des commandes du chat.",
			keywords = "#KEYWORD ou #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Liste des commandes du chat de #ADDON :",
		},
	},
	popupInput = {
		title = "Spécifiez le texte",
		tooltip = "Appuyez sur " .. KEY_ENTER .. " pour valider le texte ou sur " .. KEY_ESCAPE .. " pour annuler."
	},
	reload = {
		title = "Modifications en attente",
		description = "Rechargez l'interface pour appliquer les modifications en attente.",
		accept = {
			label = "Recharger maintenant",
			tooltip = "Vous pouvez choisir de recharger l'interface maintenant pour appliquer les modifications en attente.",
		},
		cancel = {
			label = "Plus tard",
			tooltip = "Rechargez l'interface plus tard avec la commande /reload ou en vous déconnectant.",
		},
	},
	multiSelector = {
		locked = "Verrouillé",
		minLimit = "Au moins #MIN options doivent être sélectionnées.",
		maxLimit = "Seulement #MAX options peuvent être sélectionnées à la fois.",
	},
	dropdown = {
		selected = "Ceci est l'option actuellement sélectionnée.",
		none = "Aucune option n'a été sélectionnée.",
		open = "Cliquez pour voir la liste des options.",
		previous = {
			label = "Option précédente",
			tooltip = "Sélectionner l'option précédente.",
		},
		next = {
			label = "Option suivante",
			tooltip = "Sélectionner l'option suivante.",
		},
		clear = "Effacer la sélection",
	},
	copyBox = "Copiez le texte en appuyant sur :\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Spécifiez la valeur",
			tooltip = "Entrez une valeur dans la plage autorisée.",
		},
		decrease = {
			label = "Diminuer",
			tooltip = {
				"Soustraire #VALUE de la valeur.",
				"Maintenez ALT pour soustraire #VALUE à la place.",
			},
		},
		increase = {
			label = "Augmenter",
			tooltip = {
				"Ajouter #VALUE à la valeur.",
				"Maintenez ALT pour ajouter #VALUE à la place.",
			},
		},
	},
	color = {
		picker = {
			label = "Choisir une couleur",
			tooltip = "Ouvrez le sélecteur de couleur pour personnaliser la couleur#ALPHA.",
			alpha = " et modifier l'opacité",
		},
		hex = {
			label = "Ajouter via code couleur HEX",
			tooltip = "Vous pouvez changer la couleur via un code HEX au lieu d'utiliser le sélecteur de couleur.",
		}
	},
	settings = {
		save = "Les modifications seront appliquées à la fermeture.",
		cancel = {
			label = "Annuler les modifications",
			tooltip = "Annuler toutes les modifications apportées à cette page et charger les valeurs enregistrées.",
		},
		defaults = {
			label = "Restaurer les valeurs par défaut",
			tooltip = "Restaurer tous les paramètres de cette page (ou de la catégorie entière) aux valeurs par défaut.",
		},
		warning = "Êtes-vous sûr de vouloir réinitialiser les paramètres de la page #PAGE ou tous les paramètres de la catégorie #CATEGORY aux valeurs par défaut ?",
		warningSingle = "Êtes-vous sûr de vouloir réinitialiser les paramètres de la page #PAGE aux valeurs par défaut ?",
	},
	value = {
		copy = "Copier la valeur",
		paste = "Coller la valeur",
		revert = "Annuler les modifications",
		restore = "Restaurer la valeur par défaut",
		note = "Clique droit pour copier ou annuler.",
	},
	points = {
		left = "Gauche",
		right = "Droite",
		center = "Centre",
		top = {
			left = "Haut gauche",
			right = "Haut droite",
			center = "Haut centre",
		},
		bottom = {
			left = "Bas gauche",
			right = "Bas droite",
			center = "Bas centre",
		},
	},
	strata = {
		lowest = "Arrière-plan bas",
		lower = "Arrière-plan moyen",
		low = "Arrière-plan haut",
		lowMid = "Bas milieu",
		highMid = "Haut milieu",
		high = "Premier plan bas",
		higher = "Premier plan moyen",
		highest = "Premier plan haut",
	},
	about = {
		title = "À propos",
		description = "Merci d'utiliser #ADDON ! Copiez les liens pour savoir comment donner votre avis, obtenir de l'aide et soutenir le développement.",
		version = "Version",
		date = "Date",
		author = "Auteur",
		license = "Licence",
		curseForge = "Page CurseForge",
		wago = "Page Wago",
		repository = "Dépôt GitHub",
		issues = "Problèmes & Retours",
		changelog = {
			label = "Notes de mise à jour",
			tooltip = "Notes de tous les changements, mises à jour et corrections introduits dans la dernière version : #VERSION.",
		},
		fullChangelog = {
			label = "Historique de #ADDON",
			tooltip = "La liste complète des notes de mise à jour de toutes les versions de l'addon.",
			open = {
				label = "Historique",
				tooltip = "Lire la liste complète des notes de mise à jour de toutes les versions de l'addon.",
			},
		},
	},
	sponsors = {
		title = "Sponsors",
		description = "Votre soutien continu est très apprécié ! Merci !",
	},
	dataManagement = {
		title = "Gestion des données",
		description = "Configurez davantage #ADDON en gérant les profils et sauvegardes via les options d'import/export.",
	},
	profiles = {
		title = "Profils",
		description = "Créez, modifiez et appliquez des profils d'options uniques pour chacun de vos personnages.",
		select = {
			label = "Sélectionner un profil",
			tooltip = "Choisissez le profil de stockage des options à utiliser pour votre personnage actuel.\n\nLes données du profil actif seront automatiquement écrasées lorsque les paramètres seront modifiés et enregistrés !",
			profile = "Profil",
			main = "Principal",
		},
		new = {
			label = "Nouveau profil",
			tooltip = "Créer un nouveau profil par défaut.",
		},
		duplicate = {
			label = "Dupliquer",
			tooltip = "Créer un nouveau profil en copiant les données du profil actif.",
		},
		rename = {
			label = "Renommer",
			tooltip = "Renommer le profil actif.",
			description = "Renommer #PROFILE en :",
		},
		delete = {
			tooltip = "Supprimer le profil actif.",
			warning = "Êtes-vous sûr de vouloir supprimer le profil de paramètres #PROFILE #ADDON actif et de supprimer définitivement toutes les données qui y sont stockées ?"
		},
		reset = {
			warning = "Êtes-vous sûr de vouloir écraser le profil de paramètres #PROFILE #ADDON actif avec les valeurs par défaut ?",
		},
	},
	backup = {
		title = "Sauvegarde",
		description = "Importez ou exportez les données du profil actif pour sauvegarder, partager ou transférer les paramètres, ou modifier des valeurs manuellement.",
		box = {
			label = "Importer ou exporter le profil actuel",
			tooltip = {
				"La chaîne de sauvegarde dans cette boîte contient les données du profil actif de l'addon.",
				"Copiez le texte pour sauvegarder, partager ou charger des données pour un autre compte.",
				"Pour charger des données à partir d'une chaîne, remplacez le texte dans cette boîte, puis appuyez sur " .. KEY_ENTER .. " ou cliquez sur le bouton #LOAD.",
				"Remarque : Si vous utilisez des fichiers de police ou de texture personnalisés, ces fichiers ne seront pas transférés avec cette chaîne. Ils devront être enregistrés séparément et placés dans le dossier de l'addon pour être utilisables.",
				"Ne chargez que des chaînes que vous avez vérifiées vous-même ou dont vous faites confiance à la source !",
			},
		},
		allProfiles = {
			label = "Importer ou exporter tous les profils",
			tooltipLine = "La chaîne de sauvegarde dans cette boîte contient la liste de tous les profils de l'addon et les données stockées dans chacun, ainsi que le nom du profil actif.",
			open = {
				label = "Tous les profils",
				tooltip = "Accédez à la liste complète des profils et sauvegardez ou modifiez les données stockées dans chacun.",
			},
		},
		compact = {
			label = "Compact",
			tooltip = "Basculer entre une vue compacte et une vue plus lisible/modifiable.",
		},
		load = {
			label = "Charger",
			tooltip = "Vérifiez la chaîne actuelle et essayez de charger les données à partir de celle-ci.",
		},
		reset = {
			tooltip = "Annuler toutes les modifications apportées à la chaîne et la réinitialiser pour contenir les données actuellement enregistrées.",
		},
		import = "Charger la chaîne",
		warning = "Êtes-vous sûr de vouloir tenter de charger la chaîne actuellement insérée ?\n\nToutes les modifications non enregistrées seront annulées.\n\nSi vous l'avez copiée d'une source en ligne ou si quelqu'un vous l'a envoyée, ne la chargez qu'après avoir vérifié le code et être sûr de ce que vous faites.\n\nSi vous ne faites pas confiance à la source, annulez pour éviter toute action indésirable.",
		error = "La chaîne de sauvegarde fournie n'a pas pu être validée et aucune donnée n'a été chargée. Il se peut qu'il manque des caractères ou que des erreurs aient été introduites lors de l'édition.",
	},
	position = {
		title = "Position",
		description = {
			static = "Ajustez précisément la position de #FRAME à l'écran via les options fournies ici.",
			movable = "Faites glisser #FRAME en maintenant SHIFT pour le positionner n'importe où à l'écran, puis ajustez-le ici.",
		},
		relativePoint = {
			label = "Point d'ancrage à l'écran",
			tooltip = "Attachez le point d'ancrage choisi de #FRAME au point de liaison sélectionné ici.",
		},
		-- relativeTo = {
		-- 	label = "Lier à une frame",
		-- 	tooltip = "Tapez le nom d'un autre élément d'interface pour lier la position de #FRAME.\n\nTrouvez les noms des frames en activant l'interface de debug via la commande /framestack.",
		-- },
		anchor = {
			label = "Point d'ancrage",
			tooltip = "Sélectionnez à partir de quel point #FRAME doit être ancré lors de la liaison au point d'écran choisi.",
		},
		keepInPlace = {
			label = "Garder en place",
			tooltip = "Ne déplacez pas #FRAME lors du changement de #ANCHOR, mettez à jour les valeurs de décalage à la place.",
		},
		offsetX= {
			label = "Décalage horizontal",
			tooltip = "Définissez la quantité de décalage horizontal (axe X) de #FRAME à partir de l'#ANCHOR sélectionné.",
		},
		offsetY = {
			label = "Décalage vertical",
			tooltip = "Définissez la quantité de décalage vertical (axe Y) de #FRAME à partir de l'#ANCHOR sélectionné.",
		},
		keepInBounds = {
			label = "Garder dans les limites de l'écran",
			tooltip = "Assurez-vous que #FRAME ne puisse pas être déplacé hors de l'écran.",
		},
	},
	presets = {
		apply = {
			label = "Appliquer un préréglage",
			tooltip = "Changez la position de #FRAME en choisissant et en appliquant un de ces préréglages.",
			list = { "Sous la Minicarte", },
			select = "Sélectionnez un préréglage…",
		},
		save = {
			label = "Mettre à jour le préréglage #CUSTOM",
			tooltip = "Enregistrez la position et la visibilité actuelles de #FRAME dans le préréglage #CUSTOM.",
			warning = "Êtes-vous sûr de vouloir écraser le préréglage #CUSTOM avec les valeurs actuelles ?",
		},
		reset = {
			label = "Réinitialiser le préréglage #CUSTOM",
			tooltip = "Écrasez les données du préréglage #CUSTOM avec les valeurs par défaut, puis appliquez-le.",
			warning = "Êtes-vous sûr de vouloir écraser le préréglage #CUSTOM avec les valeurs par défaut ?",
		},
	},
	layer = {
		strata = {
			label = "Calque d'écran",
			tooltip = "Montez ou descendez #FRAME pour qu'il soit devant ou derrière d'autres éléments de l'interface.",
		},
		keepOnTop = {
			label = "Révéler lors d'une interaction souris",
			tooltip = "Permettre à #FRAME d'être déplacé au-dessus d'autres frames dans la même #STRATA lors d'une interaction.",
		},
		level = {
			label = "Niveau de frame",
			tooltip = "La position exacte de #FRAME au-dessus ou en dessous d'autres frames dans la même pile #STRATA.",
		},
	},
	font = {
		title = "Texte",
		path = {
			label = "Police",
			tooltip = "Sélectionnez la police.",
			default = {
				label = "Police par défaut localisée",
				tooltip = "Ceci est une police par défaut localisée utilisée par Blizzard.",
			},
			base = "Ceci est une police du jeu de base.",
			custom = "Ceci est une police personnalisée.",
			otf = "Licence de police OpenType.",
			file = "Chemin du fichier : #PATH",
			replace = "L’option Personnalisée offre une personnalisation complète en vous permettant d’utiliser n’importe quelle police en remplaçant le fichier de police #FILE_CUSTOM par n’importe quel autre fichier TrueType trouvé dans\n#FONTS_DIRECTORY\ntout en conservant son nom de fichier #FILE_CUSTOM.",
			reminder = "Vous devrez peut-être redémarrer complètement le client du jeu après avoir remplacé le fichier de police pour appliquer le changement.",
		},
		size = {
			label = "Taille",
			tooltip = "Définissez la taille de la police.",
		},
		alignment = {
			label = "Alignement",
			tooltip = "Sélectionnez l’alignement horizontal du texte.",
		},
		color = {
			label = "Couleur #COLOR_TYPE",
			tooltip = "Définissez la couleur du texte #COLOR_TYPE.",
		},
	},
	date = "#DAY/#MONTH/#YEAR",
	override = "Écraser",
	example = "Exemple",
}

---Spanish (Spain)
---@class toolboxStrings_esES
local esES = {
	chat = {
		welcome = {
			thanks = "¡Gracias por usar #ADDON!",
			hint = "Escribe #KEYWORD para ver la lista de comandos de chat.",
			keywords = "#KEYWORD o #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Lista de comandos de chat de #ADDON:",
		},
	},
	popupInput = {
		title = "Especifica el texto",
		tooltip = "Pulsa " .. KEY_ENTER .. " para aceptar el texto especificado o " .. KEY_ESCAPE .. " para descartarlo."
	},
	reload = {
		title = "Cambios Pendientes",
		description = "Recarga la interfaz para aplicar los cambios pendientes.",
		accept = {
			label = "Recargar Ahora",
			tooltip = "Puedes elegir recargar la interfaz ahora para aplicar los cambios pendientes.",
		},
		cancel = {
			label = "Más tarde",
			tooltip = "Recarga la interfaz más tarde con el comando /reload o cerrando sesión.",
		},
	},
	multiSelector = {
		locked = "Bloqueado",
		minLimit = "Debes seleccionar al menos #MIN opciones.",
		maxLimit = "Solo se pueden seleccionar #MAX opciones a la vez.",
	},
	dropdown = {
		selected = "Esta es la opción seleccionada actualmente.",
		none = "No se ha seleccionado ninguna opción.",
		open = "Haz clic para ver la lista de opciones.",
		previous = {
			label = "Opción anterior",
			tooltip = "Seleccionar la opción anterior.",
		},
		next = {
			label = "Siguiente opción",
			tooltip = "Seleccionar la siguiente opción.",
		},
		clear = "Borrar selección",
	},
	copyBox = "Copia el texto pulsando:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Especifica el valor",
			tooltip = "Introduce cualquier valor dentro del rango.",
		},
		decrease = {
			label = "Disminuir",
			tooltip = {
				"Resta #VALUE al valor.",
				"Mantén ALT para restar #VALUE en su lugar.",
			},
		},
		increase = {
			label = "Aumentar",
			tooltip = {
				"Suma #VALUE al valor.",
				"Mantén ALT para sumar #VALUE en su lugar.",
			},
		},
	},
	color = {
		picker = {
			label = "Elige un color",
			tooltip = "Abre el selector de color para personalizar el color#ALPHA.",
			alpha = " y cambiar la opacidad",
		},
		hex = {
			label = "Añadir por código HEX",
			tooltip = "Puedes cambiar el color usando un código HEX en vez del selector de color.",
		}
	},
	settings = {
		save = "Los cambios se aplicarán al cerrar.",
		cancel = {
			label = "Revertir Cambios",
			tooltip = "Descarta todos los cambios realizados en esta página y carga los valores guardados.",
		},
		defaults = {
			label = "Restaurar Valores Predeterminados",
			tooltip = "Restaura todos los ajustes de esta página (o de toda la categoría) a los valores predeterminados.",
		},
		warning = "¿Seguro que quieres restablecer los ajustes de la página #PAGE o todos los ajustes de la categoría #CATEGORY a los valores predeterminados?",
		warningSingle = "¿Seguro que quieres restablecer los ajustes de la página #PAGE a los valores predeterminados?",
	},
	value = {
		copy = "Copiar valor",
		paste = "Pegar valor",
		revert = "Revertir Cambios",
		restore = "Restaurar Predeterminado",
		note = "Haz clic derecho para copiar o revertir.",
	},
	points = {
		left = "Izquierda",
		right = "Derecha",
		center = "Centro",
		top = {
			left = "Arriba Izquierda",
			right = "Arriba Derecha",
			center = "Arriba Centro",
		},
		bottom = {
			left = "Abajo Izquierda",
			right = "Abajo Derecha",
			center = "Abajo Centro",
		},
	},
	strata = {
		lowest = "Fondo Bajo",
		lower = "Fondo Medio",
		low = "Fondo Alto",
		lowMid = "Medio Bajo",
		highMid = "Medio Alto",
		high = "Primer Plano Bajo",
		higher = "Primer Plano Medio",
		highest = "Primer Plano Alto",
	},
	about = {
		title = "Acerca de",
		description = "¡Gracias por usar #ADDON! Copia los enlaces para saber cómo enviar comentarios, obtener ayuda y apoyar el desarrollo.",
		version = "Versión",
		date = "Fecha",
		author = "Autor",
		license = "Licencia",
		curseForge = "Página de CurseForge",
		wago = "Página de Wago",
		repository = "Repositorio GitHub",
		issues = "Incidencias y Comentarios",
		changelog = {
			label = "Notas de Actualización",
			tooltip = "Notas de todos los cambios, actualizaciones y correcciones introducidos en la última versión: #VERSION.",
		},
		fullChangelog = {
			label = "Historial de #ADDON",
			tooltip = "La lista completa de notas de actualización de todas las versiones del addon.",
			open = {
				label = "Historial",
				tooltip = "Lee la lista completa de notas de actualización de todas las versiones del addon.",
			},
		},
	},
	sponsors = {
		title = "Patrocinadores",
		description = "¡Tu apoyo continuo es muy apreciado! ¡Gracias!",
	},
	dataManagement = {
		title = "Gestión de Datos",
		description = "Configura más opciones de #ADDON gestionando perfiles y copias de seguridad mediante importación y exportación.",
	},
	profiles = {
		title = "Perfiles",
		description = "Crea, edita y aplica perfiles de opciones únicos para cada uno de tus personajes.",
		select = {
			label = "Seleccionar un Perfil",
			tooltip = "Elige el perfil de almacenamiento de opciones que se usará para tu personaje actual.\n\n¡Los datos del perfil activo se sobrescribirán automáticamente al modificar y guardar los ajustes!",
			profile = "Perfil",
			main = "Principal",
		},
		new = {
			label = "Nuevo Perfil",
			tooltip = "Crear un nuevo perfil predeterminado.",
		},
		duplicate = {
			label = "Duplicar",
			tooltip = "Crear un nuevo perfil copiando los datos del perfil activo.",
		},
		rename = {
			label = "Renombrar",
			tooltip = "Renombrar el perfil activo.",
			description = "Renombrar #PROFILE a:",
		},
		delete = {
			tooltip = "Eliminar el perfil activo.",
			warning = "¿Seguro que quieres eliminar el perfil de ajustes #PROFILE #ADDON activo y borrar permanentemente todos los datos almacenados en él?"
		},
		reset = {
			warning = "¿Seguro que quieres sobrescribir el perfil de ajustes #PROFILE #ADDON activo con los valores predeterminados?",
		},
	},
	backup = {
		title = "Copia de Seguridad",
		description = "Importa o exporta los datos del perfil activo para guardar, compartir o mover ajustes, o editar valores manualmente.",
		box = {
			label = "Importar o Exportar Perfil Actual",
			tooltip = {
				"La cadena de copia de seguridad en esta caja contiene los datos del perfil activo del addon.",
				"Copia el texto para guardar, compartir o cargar datos para otra cuenta.",
				"Para cargar datos desde una cadena, reemplaza el texto en esta caja y pulsa " .. KEY_ENTER .. " o haz clic en el botón #LOAD.",
				"Nota: Si usas archivos de fuentes o texturas personalizados, esos archivos no se transferirán con esta cadena. Deberás guardarlos aparte y pegarlos en la carpeta del addon para poder usarlos.",
				"¡Solo carga cadenas que hayas verificado tú mismo o en las que confíes en la fuente!",
			},
		},
		allProfiles = {
			label = "Importar o Exportar Todos los Perfiles",
			tooltipLine = "La cadena de copia de seguridad en esta caja contiene la lista de todos los perfiles del addon y los datos almacenados en cada uno, así como el nombre del perfil activo.",
			open = {
				label = "Todos los Perfiles",
				tooltip = "Accede a la lista completa de perfiles y haz copia de seguridad o modifica los datos almacenados en cada uno.",
			},
		},
		compact = {
			label = "Compacto",
			tooltip = "Alterna entre una vista compacta y una más legible/editable.",
		},
		load = {
			label = "Cargar",
			tooltip = "Comprueba la cadena actual e intenta cargar los datos desde ella.",
		},
		reset = {
			tooltip = "Descarta todos los cambios realizados en la cadena y restáurala para que contenga los datos actualmente guardados.",
		},
		import = "Cargar la cadena",
		warning = "¿Seguro que quieres intentar cargar la cadena insertada?\n\nTodos los cambios no guardados se descartarán.\n\nSi la has copiado de una fuente online o alguien te la ha enviado, solo cárgala después de revisar el código y saber lo que haces.\n\nSi no confías en la fuente, cancela para evitar acciones no deseadas.",
		error = "La cadena de copia de seguridad proporcionada no se pudo validar y no se cargaron datos. Puede que falten caracteres o se hayan introducido errores al editarla.",
	},
	position = {
		title = "Posición",
		description = {
			static = "Ajusta la posición de #FRAME en la pantalla con las opciones proporcionadas aquí.",
			movable = "Arrastra y suelta #FRAME manteniendo SHIFT para colocarlo en cualquier parte de la pantalla, ajústalo aquí.",
		},
		relativePoint = {
			label = "Punto de Anclaje en Pantalla",
			tooltip = "Vincula el punto de anclaje elegido de #FRAME al punto seleccionado aquí.",
		},
		-- relativeTo = {
		-- 	label = "Vincular a Marco",
		-- 	tooltip = "Escribe el nombre de otro elemento de la interfaz, un marco al que vincular la posición de #FRAME.\n\nDescubre los nombres de los marcos activando la interfaz de depuración con el comando /framestack.",
		-- },
		anchor = {
			label = "Punto de Anclaje",
			tooltip = "Selecciona desde qué punto debe anclarse #FRAME al vincularlo al punto de pantalla elegido.",
		},
		keepInPlace = {
			label = "Mantener en su sitio",
			tooltip = "No muevas #FRAME al cambiar el #ANCHOR, actualiza los valores de desplazamiento en su lugar.",
		},
		offsetX= {
			label = "Desplazamiento Horizontal",
			tooltip = "Establece la cantidad de desplazamiento horizontal (eje X) de #FRAME desde el #ANCHOR seleccionado.",
		},
		offsetY = {
			label = "Desplazamiento Vertical",
			tooltip = "Establece la cantidad de desplazamiento vertical (eje Y) de #FRAME desde el #ANCHOR seleccionado.",
		},
		keepInBounds = {
			label = "Mantener en los límites de la pantalla",
			tooltip = "Asegúrate de que #FRAME no pueda moverse fuera de los límites de la pantalla.",
		},
	},
	presets = {
		apply = {
			label = "Aplicar un Preajuste",
			tooltip = "Cambia la posición de #FRAME eligiendo y aplicando uno de estos preajustes.",
			list = { "Debajo del Minimapa", },
			select = "Selecciona un preajuste…",
		},
		save = {
			label = "Actualizar Preajuste #CUSTOM",
			tooltip = "Guarda la posición y visibilidad actual de #FRAME en el preajuste #CUSTOM.",
			warning = "¿Seguro que quieres sobrescribir el preajuste #CUSTOM con los valores actuales?",
		},
		reset = {
			label = "Restablecer Preajuste #CUSTOM",
			tooltip = "Sobrescribe los datos guardados del preajuste #CUSTOM con los valores predeterminados y aplícalo.",
			warning = "¿Seguro que quieres sobrescribir el preajuste #CUSTOM con los valores predeterminados?",
		},
	},
	layer = {
		strata = {
			label = "Capa de Pantalla",
			tooltip = "Sube o baja #FRAME para que esté delante o detrás de otros elementos de la interfaz.",
		},
		keepOnTop = {
			label = "Mostrar al interactuar con el ratón",
			tooltip = "Permite que #FRAME se mueva por encima de otros marcos en la misma #STRATA al interactuar con él.",
		},
		level = {
			label = "Nivel del Marco",
			tooltip = "La posición exacta de #FRAME por encima o por debajo de otros marcos en la misma pila #STRATA.",
		},
	},
	font = {
		title = "Texto",
		path = {
			label = "Fuente",
			tooltip = "Selecciona la fuente.",
			default = {
				label = "Predeterminada localizada",
				tooltip = "Esta es una fuente predeterminada localizada utilizada por Blizzard.",
			},
			base = "Esta es una fuente del juego base.",
			custom = "Esta es una fuente personalizada.",
			otf = "Licencia de fuente OpenType.",
			file = "Ruta del archivo: #PATH",
			replace = "La opción Personalizada ofrece una personalización completa, permitiéndote usar cualquier fuente sustituyendo el archivo #FILE_CUSTOM por cualquier otro archivo TrueType encontrado en\n#FONTS_DIRECTORY\nmanteniendo el nombre original del archivo #FILE_CUSTOM.",
			reminder = "Puede que necesites reiniciar completamente el cliente del juego después de reemplazar el archivo de fuente para aplicar el cambio.",
		},
		size = {
			label = "Tamaño",
			tooltip = "Establece el tamaño de la fuente.",
		},
		alignment = {
			label = "Alineación",
			tooltip = "Selecciona la alineación horizontal del texto.",
		},
		color = {
			label = "Color de #COLOR_TYPE",
			tooltip = "Establece el color del texto #COLOR_TYPE.",
		},
	},
	date = "#DAY/#MONTH/#YEAR",
	override = "Sobrescribir",
	example = "Ejemplo",
}

---Spanish (Mexico)
---@class toolboxStrings_esMX
local esMX = {
	chat = {
		welcome = {
			thanks = "¡Gracias por usar #ADDON!",
			hint = "Escribe #KEYWORD para ver la lista de comandos de chat.",
			keywords = "#KEYWORD o #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Lista de comandos de chat de #ADDON:",
		},
	},
	popupInput = {
		title = "Especifica el texto",
		tooltip = "Presiona " .. KEY_ENTER .. " para aceptar el texto especificado o " .. KEY_ESCAPE .. " para descartarlo."
	},
	reload = {
		title = "Cambios Pendientes",
		description = "Recarga la interfaz para aplicar los cambios pendientes.",
		accept = {
			label = "Recargar Ahora",
			tooltip = "Puedes elegir recargar la interfaz ahora para aplicar los cambios pendientes.",
		},
		cancel = {
			label = "Después",
			tooltip = "Recarga la interfaz después con el comando /reload o cerrando sesión.",
		},
	},
	multiSelector = {
		locked = "Bloqueado",
		minLimit = "Debes seleccionar al menos #MIN opciones.",
		maxLimit = "Solo se pueden seleccionar #MAX opciones a la vez.",
	},
	dropdown = {
		selected = "Esta es la opción seleccionada actualmente.",
		none = "No se ha seleccionado ninguna opción.",
		open = "Haz clic para ver la lista de opciones.",
		previous = {
			label = "Opción anterior",
			tooltip = "Seleccionar la opción anterior.",
		},
		next = {
			label = "Siguiente opción",
			tooltip = "Seleccionar la siguiente opción.",
		},
		clear = "Borrar selección",
	},
	copyBox = "Copia el texto presionando:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Especifica el valor",
			tooltip = "Ingresa cualquier valor dentro del rango.",
		},
		decrease = {
			label = "Disminuir",
			tooltip = {
				"Resta #VALUE al valor.",
				"Mantén ALT para restar #VALUE en su lugar.",
			},
		},
		increase = {
			label = "Aumentar",
			tooltip = {
				"Suma #VALUE al valor.",
				"Mantén ALT para sumar #VALUE en su lugar.",
			},
		},
	},
	color = {
		picker = {
			label = "Elige un color",
			tooltip = "Abre el selector de color para personalizar el color#ALPHA.",
			alpha = " y cambiar la opacidad",
		},
		hex = {
			label = "Agregar por código HEX",
			tooltip = "Puedes cambiar el color usando un código HEX en vez del selector de color.",
		}
	},
	settings = {
		save = "Los cambios se aplicarán al cerrar.",
		cancel = {
			label = "Revertir Cambios",
			tooltip = "Descarta todos los cambios hechos en esta página y carga los valores guardados.",
		},
		defaults = {
			label = "Restaurar Valores Predeterminados",
			tooltip = "Restaura todos los ajustes de esta página (o de toda la categoría) a los valores predeterminados.",
		},
		warning = "¿Seguro que quieres restablecer los ajustes de la página #PAGE o todos los ajustes de la categoría #CATEGORY a los valores predeterminados?",
		warningSingle = "¿Seguro que quieres restablecer los ajustes de la página #PAGE a los valores predeterminados?",
	},
	value = {
		copy = "Copiar valor",
		paste = "Pegar valor",
		revert = "Revertir Cambios",
		restore = "Restaurar Predeterminado",
		note = "Haz clic derecho para copiar o revertir.",
	},
	points = {
		left = "Izquierda",
		right = "Derecha",
		center = "Centro",
		top = {
			left = "Arriba Izquierda",
			right = "Arriba Derecha",
			center = "Arriba Centro",
		},
		bottom = {
			left = "Abajo Izquierda",
			right = "Abajo Derecha",
			center = "Abajo Centro",
		},
	},
	strata = {
		lowest = "Fondo Bajo",
		lower = "Fondo Medio",
		low = "Fondo Alto",
		lowMid = "Medio Bajo",
		highMid = "Medio Alto",
		high = "Primer Plano Bajo",
		higher = "Primer Plano Medio",
		highest = "Primer Plano Alto",
	},
	about = {
		title = "Acerca de",
		description = "¡Gracias por usar #ADDON! Copia los enlaces para saber cómo enviar comentarios, obtener ayuda y apoyar el desarrollo.",
		version = "Versión",
		date = "Fecha",
		author = "Autor",
		license = "Licencia",
		curseForge = "Página de CurseForge",
		wago = "Página de Wago",
		repository = "Repositorio GitHub",
		issues = "Incidencias y Comentarios",
		changelog = {
			label = "Notas de Actualización",
			tooltip = "Notas de todos los cambios, actualizaciones y correcciones introducidos en la última versión: #VERSION.",
		},
		fullChangelog = {
			label = "Historial de #ADDON",
			tooltip = "La lista completa de notas de actualización de todas las versiones del addon.",
			open = {
				label = "Historial",
				tooltip = "Lee la lista completa de notas de actualización de todas las versiones del addon.",
			},
		},
	},
	sponsors = {
		title = "Patrocinadores",
		description = "¡Tu apoyo continuo es muy apreciado! ¡Gracias!",
	},
	dataManagement = {
		title = "Gestión de Datos",
		description = "Configura más opciones de #ADDON gestionando perfiles y respaldos mediante importación y exportación.",
	},
	profiles = {
		title = "Perfiles",
		description = "Crea, edita y aplica perfiles de opciones únicos para cada uno de tus personajes.",
		select = {
			label = "Seleccionar un Perfil",
			tooltip = "Elige el perfil de almacenamiento de opciones que se usará para tu personaje actual.\n\n¡Los datos del perfil activo se sobrescribirán automáticamente al modificar y guardar los ajustes!",
			profile = "Perfil",
			main = "Principal",
		},
		new = {
			label = "Nuevo Perfil",
			tooltip = "Crear un nuevo perfil predeterminado.",
		},
		duplicate = {
			label = "Duplicar",
			tooltip = "Crear un nuevo perfil copiando los datos del perfil activo.",
		},
		rename = {
			label = "Renombrar",
			tooltip = "Renombrar el perfil activo.",
			description = "Renombrar #PROFILE a:",
		},
		delete = {
			tooltip = "Eliminar el perfil activo.",
			warning = "¿Seguro que quieres eliminar el perfil de ajustes #PROFILE #ADDON activo y borrar permanentemente todos los datos almacenados en él?"
		},
		reset = {
			warning = "¿Seguro que quieres sobrescribir el perfil de ajustes #PROFILE #ADDON activo con los valores predeterminados?",
		},
	},
	backup = {
		title = "Respaldo",
		description = "Importa o exporta los datos del perfil activo para guardar, compartir o mover ajustes, o editar valores manualmente.",
		box = {
			label = "Importar o Exportar Perfil Actual",
			tooltip = {
				"La cadena de respaldo en esta caja contiene los datos del perfil activo del addon.",
				"Copia el texto para guardar, compartir o cargar datos para otra cuenta.",
				"Para cargar datos desde una cadena, reemplaza el texto en esta caja y presiona " .. KEY_ENTER .. " o haz clic en el botón #LOAD.",
				"Nota: Si usas archivos de fuentes o texturas personalizados, esos archivos no se transferirán con esta cadena. Deberás guardarlos aparte y pegarlos en la carpeta del addon para poder usarlos.",
				"¡Solo carga cadenas que hayas verificado tú mismo o en las que confíes en la fuente!",
			},
		},
		allProfiles = {
			label = "Importar o Exportar Todos los Perfiles",
			tooltipLine = "La cadena de respaldo en esta caja contiene la lista de todos los perfiles del addon y los datos almacenados en cada uno, así como el nombre del perfil activo.",
			open = {
				label = "Todos los Perfiles",
				tooltip = "Accede a la lista completa de perfiles y haz respaldo o modifica los datos almacenados en cada uno.",
			},
		},
		compact = {
			label = "Compacto",
			tooltip = "Alterna entre una vista compacta y una más legible/editable.",
		},
		load = {
			label = "Cargar",
			tooltip = "Verifica la cadena actual e intenta cargar los datos desde ella.",
		},
		reset = {
			tooltip = "Descarta todos los cambios hechos a la cadena y restáurala para que contenga los datos actualmente guardados.",
		},
		import = "Cargar la cadena",
		warning = "¿Seguro que quieres intentar cargar la cadena insertada?\n\nTodos los cambios no guardados se descartarán.\n\nSi la copiaste de una fuente en línea o alguien te la envió, solo cárgala después de revisar el código y saber lo que haces.\n\nSi no confías en la fuente, cancela para evitar acciones no deseadas.",
		error = "La cadena de respaldo proporcionada no se pudo validar y no se cargaron datos. Puede que falten caracteres o se hayan introducido errores al editarla.",
	},
	position = {
		title = "Posición",
		description = {
			static = "Ajusta la posición de #FRAME en la pantalla con las opciones proporcionadas aquí.",
			movable = "Arrastra y suelta #FRAME manteniendo SHIFT para colocarlo en cualquier parte de la pantalla, ajústalo aquí.",
		},
		relativePoint = {
			label = "Punto de Anclaje en Pantalla",
			tooltip = "Vincula el punto de anclaje elegido de #FRAME al punto seleccionado aquí.",
		},
		-- relativeTo = {
		-- 	label = "Vincular a Marco",
		-- 	tooltip = "Escribe el nombre de otro elemento de la interfaz, un marco al que vincular la posición de #FRAME.\n\nDescubre los nombres de los marcos activando la interfaz de depuración con el comando /framestack.",
		-- },
		anchor = {
			label = "Punto de Anclaje",
			tooltip = "Selecciona desde qué punto debe anclarse #FRAME al vincularlo al punto de pantalla elegido.",
		},
		keepInPlace = {
			label = "Mantener en su lugar",
			tooltip = "No muevas #FRAME al cambiar el #ANCHOR, actualiza los valores de desplazamiento en su lugar.",
		},
		offsetX= {
			label = "Desplazamiento Horizontal",
			tooltip = "Establece la cantidad de desplazamiento horizontal (eje X) de #FRAME desde el #ANCHOR seleccionado.",
		},
		offsetY = {
			label = "Desplazamiento Vertical",
			tooltip = "Establece la cantidad de desplazamiento vertical (eje Y) de #FRAME desde el #ANCHOR seleccionado.",
		},
		keepInBounds = {
			label = "Mantener en los límites de la pantalla",
			tooltip = "Asegúrate de que #FRAME no pueda moverse fuera de los límites de la pantalla.",
		},
	},
	presets = {
		apply = {
			label = "Aplicar un Preajuste",
			tooltip = "Cambia la posición de #FRAME eligiendo y aplicando uno de estos preajustes.",
			list = { "Debajo del Minimapa", },
			select = "Selecciona un preajuste…",
		},
		save = {
			label = "Actualizar Preajuste #CUSTOM",
			tooltip = "Guarda la posición y visibilidad actual de #FRAME en el preajuste #CUSTOM.",
			warning = "¿Seguro que quieres sobrescribir el preajuste #CUSTOM con los valores actuales?",
		},
		reset = {
			label = "Restablecer Preajuste #CUSTOM",
			tooltip = "Sobrescribe los datos guardados del preajuste #CUSTOM con los valores predeterminados y aplícalo.",
			warning = "¿Seguro que quieres sobrescribir el preajuste #CUSTOM con los valores predeterminados?",
		},
	},
	layer = {
		strata = {
			label = "Capa de Pantalla",
			tooltip = "Sube o baja #FRAME para que esté delante o detrás de otros elementos de la interfaz.",
		},
		keepOnTop = {
			label = "Mostrar al interactuar con el mouse",
			tooltip = "Permite que #FRAME se mueva por encima de otros marcos en la misma #STRATA al interactuar con él.",
		},
		level = {
			label = "Nivel del Marco",
			tooltip = "La posición exacta de #FRAME por encima o por debajo de otros marcos en la misma pila #STRATA.",
		},
	},
	font = {
		title = "Texto",
		path = {
			label = "Fuente",
			tooltip = "Selecciona la fuente.",
			default = {
				label = "Predeterminada localizada",
				tooltip = "Esta es una fuente predeterminada localizada usada por Blizzard.",
			},
			base = "Esta es una fuente del juego base.",
			custom = "Esta es una fuente personalizada.",
			otf = "Licencia de fuente OpenType.",
			file = "Ruta del archivo: #PATH",
			replace = "La opción Personalizada permite una personalización completa al reemplazar el archivo de fuente #FILE_CUSTOM con cualquier otro archivo TrueType encontrado en\n#FONTS_DIRECTORY\nmanteniendo el nombre original del archivo #FILE_CUSTOM.",
			reminder = "Puede que necesites reiniciar por completo el cliente del juego después de reemplazar el archivo de fuente para aplicar el cambio.",
		},
		size = {
			label = "Tamaño",
			tooltip = "Configura el tamaño de la fuente.",
		},
		alignment = {
			label = "Alineación",
			tooltip = "Selecciona la alineación horizontal del texto.",
		},
		color = {
			label = "Color de #COLOR_TYPE",
			tooltip = "Configura el color del texto #COLOR_TYPE.",
		},
	},
	date = "#DAY/#MONTH/#YEAR",
	override = "Sobrescribir",
	example = "Ejemplo",
}

---Italian
---@class toolboxStrings_itIT
local itIT = {
	chat = {
		welcome = {
			thanks = "Grazie per aver utilizzato #ADDON!",
			hint = "Digita #KEYWORD per vedere la lista dei comandi della chat.",
			keywords = "#KEYWORD o #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Lista dei comandi della chat di #ADDON:",
		},
	},
	popupInput = {
		title = "Specifica il testo",
		tooltip = "Premi " .. KEY_ENTER .. " per accettare il testo specificato o " .. KEY_ESCAPE .. " per annullare."
	},
	reload = {
		title = "Modifiche in sospeso",
		description = "Ricarica l'interfaccia per applicare le modifiche in sospeso.",
		accept = {
			label = "Ricarica ora",
			tooltip = "Puoi scegliere di ricaricare l'interfaccia ora per applicare le modifiche in sospeso.",
		},
		cancel = {
			label = "Più tardi",
			tooltip = "Ricarica l'interfaccia più tardi con il comando /reload o disconnettendoti.",
		},
	},
	multiSelector = {
		locked = "Bloccato",
		minLimit = "Devono essere selezionate almeno #MIN opzioni.",
		maxLimit = "Possono essere selezionate solo #MAX opzioni alla volta.",
	},
	dropdown = {
		selected = "Questa è l'opzione attualmente selezionata.",
		none = "Nessuna opzione selezionata.",
		open = "Clicca per vedere la lista delle opzioni.",
		previous = {
			label = "Opzione precedente",
			tooltip = "Seleziona l'opzione precedente.",
		},
		next = {
			label = "Opzione successiva",
			tooltip = "Seleziona l'opzione successiva.",
		},
		clear = "Cancella selezione",
	},
	copyBox = "Copia il testo premendo:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Specifica il valore",
			tooltip = "Inserisci un valore compreso nell'intervallo.",
		},
		decrease = {
			label = "Diminuisci",
			tooltip = {
				"Sottrai #VALUE dal valore.",
				"Tieni premuto ALT per sottrarre #VALUE invece.",
			},
		},
		increase = {
			label = "Aumenta",
			tooltip = {
				"Aggiungi #VALUE al valore.",
				"Tieni premuto ALT per aggiungere #VALUE invece.",
			},
		},
	},
	color = {
		picker = {
			label = "Scegli un colore",
			tooltip = "Apri il selettore colori per personalizzare il colore#ALPHA.",
			alpha = " e cambia l'opacità",
		},
		hex = {
			label = "Aggiungi tramite codice colore HEX",
			tooltip = "Puoi cambiare il colore tramite codice HEX invece di usare il selettore colori.",
		}
	},
	settings = {
		save = "Le modifiche saranno applicate alla chiusura.",
		cancel = {
			label = "Annulla modifiche",
			tooltip = "Annulla tutte le modifiche fatte in questa pagina e carica i valori salvati.",
		},
		defaults = {
			label = "Ripristina predefiniti",
			tooltip = "Ripristina tutte le impostazioni di questa pagina (o dell'intera categoria) ai valori predefiniti.",
		},
		warning = "Sei sicuro di voler ripristinare le impostazioni della pagina #PAGE o tutte le impostazioni della categoria #CATEGORY ai valori predefiniti?",
		warningSingle = "Sei sicuro di voler ripristinare le impostazioni della pagina #PAGE ai valori predefiniti?",
	},
	value = {
		copy = "Copia valore",
		paste = "Incolla valore",
		revert = "Annulla modifiche",
		restore = "Ripristina predefinito",
		note = "Clic destro per copiare o annullare.",
	},
	points = {
		left = "Sinistra",
		right = "Destra",
		center = "Centro",
		top = {
			left = "Alto Sinistra",
			right = "Alto Destra",
			center = "Alto Centro",
		},
		bottom = {
			left = "Basso Sinistra",
			right = "Basso Destra",
			center = "Basso Centro",
		},
	},
	strata = {
		lowest = "Sfondo Basso",
		lower = "Sfondo Medio",
		low = "Sfondo Alto",
		lowMid = "Medio Basso",
		highMid = "Medio Alto",
		high = "Primo Piano Basso",
		higher = "Primo Piano Medio",
		highest = "Primo Piano Alto",
	},
	about = {
		title = "Informazioni",
		description = "Grazie per aver utilizzato #ADDON! Copia i link per sapere come inviare feedback, ottenere aiuto e supportare lo sviluppo.",
		version = "Versione",
		date = "Data",
		author = "Autore",
		license = "Licenza",
		curseForge = "Pagina CurseForge",
		wago = "Pagina Wago",
		repository = "Repository GitHub",
		issues = "Problemi & Feedback",
		changelog = {
			label = "Note di aggiornamento",
			tooltip = "Note di tutti i cambiamenti, aggiornamenti e correzioni introdotti con l'ultima versione: #VERSION.",
		},
		fullChangelog = {
			label = "Changelog di #ADDON",
			tooltip = "L'elenco completo delle note di aggiornamento di tutte le versioni dell'addon.",
			open = {
				label = "Changelog",
				tooltip = "Leggi l'elenco completo delle note di aggiornamento di tutte le versioni dell'addon.",
			},
		},
	},
	sponsors = {
		title = "Sponsor",
		description = "Il tuo continuo supporto è molto apprezzato! Grazie!",
	},
	dataManagement = {
		title = "Gestione Dati",
		description = "Configura ulteriormente #ADDON gestendo profili e backup tramite importazione ed esportazione.",
	},
	profiles = {
		title = "Profili",
		description = "Crea, modifica e applica profili di opzioni unici per ciascuno dei tuoi personaggi.",
		select = {
			label = "Seleziona un Profilo",
			tooltip = "Scegli il profilo di archiviazione delle opzioni da usare per il tuo personaggio attuale.\n\nI dati nel profilo attivo verranno sovrascritti automaticamente quando le impostazioni vengono modificate e salvate!",
			profile = "Profilo",
			main = "Principale",
		},
		new = {
			label = "Nuovo Profilo",
			tooltip = "Crea un nuovo profilo predefinito.",
		},
		duplicate = {
			label = "Duplica",
			tooltip = "Crea un nuovo profilo copiando i dati dal profilo attivo.",
		},
		rename = {
			label = "Rinomina",
			tooltip = "Rinomina il profilo attivo.",
			description = "Rinomina #PROFILE in:",
		},
		delete = {
			tooltip = "Elimina il profilo attivo.",
			warning = "Sei sicuro di voler rimuovere il profilo #PROFILE #ADDON attivo e cancellare definitivamente tutti i dati in esso contenuti?"
		},
		reset = {
			warning = "Sei sicuro di voler sovrascrivere il profilo #PROFILE #ADDON attivo con i valori predefiniti?",
		},
	},
	backup = {
		title = "Backup",
		description = "Importa o esporta i dati del profilo attivo per salvare, condividere o spostare le impostazioni, o modificare manualmente i valori.",
		box = {
			label = "Importa o Esporta Profilo Attuale",
			tooltip = {
				"La stringa di backup in questa casella contiene i dati del profilo attivo dell'addon.",
				"Copia il testo per salvare, condividere o caricare dati per un altro account.",
				"Per caricare dati da una stringa, sostituisci il testo in questa casella e premi " .. KEY_ENTER .. " o clicca sul pulsante #LOAD.",
				"Nota: Se usi file di font o texture personalizzati, questi file non verranno trasferiti con questa stringa. Dovranno essere salvati separatamente e inseriti nella cartella dell'addon per essere utilizzabili.",
				"Carica solo stringhe che hai verificato personalmente o di cui ti fidi della fonte!",
			},
		},
		allProfiles = {
			label = "Importa o Esporta Tutti i Profili",
			tooltipLine = "La stringa di backup in questa casella contiene l'elenco di tutti i profili dell'addon e i dati memorizzati in ciascuno, oltre al nome del profilo attivo.",
			open = {
				label = "Tutti i Profili",
				tooltip = "Accedi all'elenco completo dei profili e fai backup o modifica i dati memorizzati in ciascuno.",
			},
		},
		compact = {
			label = "Compatto",
			tooltip = "Alterna tra una visualizzazione compatta e una più leggibile/modificabile.",
		},
		load = {
			label = "Carica",
			tooltip = "Controlla la stringa attuale e prova a caricare i dati da essa.",
		},
		reset = {
			tooltip = "Annulla tutte le modifiche apportate alla stringa e ripristinala ai dati attualmente salvati.",
		},
		import = "Carica la stringa",
		warning = "Sei sicuro di voler tentare di caricare la stringa inserita?\n\nTutte le modifiche non salvate verranno annullate.\n\nSe l'hai copiata da una fonte online o qualcuno te l'ha inviata, caricala solo dopo aver controllato il codice e sapere cosa stai facendo.\n\nSe non ti fidi della fonte, annulla per evitare azioni indesiderate.",
		error = "La stringa di backup fornita non può essere validata e nessun dato è stato caricato. Potrebbero mancare caratteri o essere stati introdotti errori durante la modifica.",
	},
	position = {
		title = "Posizione",
		description = {
			static = "Regola la posizione di #FRAME sullo schermo tramite le opzioni qui fornite.",
			movable = "Trascina #FRAME tenendo premuto SHIFT per posizionarlo ovunque sullo schermo, regola qui.",
		},
		relativePoint = {
			label = "Punto di Collegamento Schermo",
			tooltip = "Collega il punto di ancoraggio scelto di #FRAME al punto selezionato qui.",
		},
		-- relativeTo = {
		-- 	label = "Collega a Frame",
		-- 	tooltip = "Digita il nome di un altro elemento UI, un frame a cui collegare la posizione di #FRAME.\n\nScopri i nomi dei frame attivando la UI di debug tramite il comando /framestack.",
		-- },
		anchor = {
			label = "Punto di Ancoraggio",
			tooltip = "Seleziona da quale punto #FRAME deve essere ancorato quando si collega al punto schermo scelto.",
		},
		keepInPlace = {
			label = "Mantieni in posizione",
			tooltip = "Non spostare #FRAME quando cambi #ANCHOR, aggiorna invece i valori di offset.",
		},
		offsetX= {
			label = "Offset Orizzontale",
			tooltip = "Imposta la quantità di offset orizzontale (asse X) di #FRAME dal #ANCHOR selezionato.",
		},
		offsetY = {
			label = "Offset Verticale",
			tooltip = "Imposta la quantità di offset verticale (asse Y) di #FRAME dal #ANCHOR selezionato.",
		},
		keepInBounds = {
			label = "Mantieni nei limiti dello schermo",
			tooltip = "Assicurati che #FRAME non possa essere spostato fuori dai limiti dello schermo.",
		},
	},
	presets = {
		apply = {
			label = "Applica un Predefinito",
			tooltip = "Cambia la posizione di #FRAME scegliendo e applicando uno di questi predefiniti.",
			list = { "Sotto la Minimap", },
			select = "Seleziona un predefinito…",
		},
		save = {
			label = "Aggiorna Predefinito #CUSTOM",
			tooltip = "Salva la posizione e la visibilità attuali di #FRAME nel predefinito #CUSTOM.",
			warning = "Sei sicuro di voler sovrascrivere il predefinito #CUSTOM con i valori attuali?",
		},
		reset = {
			label = "Ripristina Predefinito #CUSTOM",
			tooltip = "Sovrascrivi i dati salvati del predefinito #CUSTOM con i valori predefiniti e applicalo.",
			warning = "Sei sicuro di voler sovrascrivere il predefinito #CUSTOM con i valori predefiniti?",
		},
	},
	layer = {
		strata = {
			label = "Livello Schermo",
			tooltip = "Alza o abbassa #FRAME per essere davanti o dietro altri elementi UI.",
		},
		keepOnTop = {
			label = "Mostra all'interazione del mouse",
			tooltip = "Consenti a #FRAME di essere spostato sopra altri frame nello stesso #STRATA quando viene interagito.",
		},
		level = {
			label = "Livello del Frame",
			tooltip = "La posizione esatta di #FRAME sopra o sotto altri frame nello stesso stack #STRATA.",
		},
	},
	font = {
		title = "Testo",
		path = {
			label = "Carattere",
			tooltip = "Seleziona il carattere.",
			default = {
				label = "Predefinito localizzato",
				tooltip = "Questo è un carattere predefinito localizzato usato da Blizzard.",
			},
			base = "Questo è un carattere del gioco base.",
			custom = "Questo è un carattere personalizzato.",
			otf = "Licenza del font OpenType.",
			file = "Percorso del file: #PATH",
			replace = "L’opzione Personalizzato offre una completa personalizzazione permettendoti di usare qualsiasi carattere sostituendo il file #FILE_CUSTOM con un qualsiasi altro file TrueType trovato in\n#FONTS_DIRECTORY\nmantenendo il nome originale del file #FILE_CUSTOM.",
			reminder = "Potrebbe essere necessario riavviare completamente il client di gioco dopo aver sostituito il file del carattere per applicare la modifica.",
		},
		size = {
			label = "Dimensione",
			tooltip = "Imposta la dimensione del carattere.",
		},
		alignment = {
			label = "Allineamento",
			tooltip = "Seleziona l’allineamento orizzontale del testo.",
		},
		color = {
			label = "Colore #COLOR_TYPE",
			tooltip = "Imposta il colore del testo #COLOR_TYPE.",
		},
	},
	date = "#DAY/#MONTH/#YEAR",
	override = "Sovrascrivi",
	example = "Esempio",
}

---Korean
---@class toolboxStrings_koKR
local koKR = {
	chat = {
		welcome = {
			thanks = "#ADDON을(를) 사용해 주셔서 감사합니다!",
			hint = "#KEYWORD를 입력하여 채팅 명령어 목록을 확인하세요.",
			keywords = "#KEYWORD 또는 #KEYWORD_ALTERNATE",
		},
		help = {
			list = "#ADDON 채팅 명령어 목록:",
		},
	},
	popupInput = {
		title = "텍스트를 입력하세요",
		tooltip = KEY_ENTER .. "를 눌러 입력한 텍스트를 적용하거나 " .. KEY_ESCAPE .. "를 눌러 취소합니다."
	},
	reload = {
		title = "적용 대기 중인 변경 사항",
		description = "변경 사항을 적용하려면 인터페이스를 다시 불러오세요.",
		accept = {
			label = "지금 다시 불러오기",
			tooltip = "지금 인터페이스를 다시 불러와 변경 사항을 적용할 수 있습니다.",
		},
		cancel = {
			label = "나중에",
			tooltip = "/reload 명령어나 로그아웃으로 나중에 인터페이스를 다시 불러올 수 있습니다.",
		},
	},
	multiSelector = {
		locked = "잠김",
		minLimit = "#MIN개 이상의 옵션을 선택해야 합니다.",
		maxLimit = "한 번에 #MAX개 옵션만 선택할 수 있습니다.",
	},
	dropdown = {
		selected = "현재 선택된 옵션입니다.",
		none = "선택된 옵션이 없습니다.",
		open = "옵션 목록을 보려면 클릭하세요.",
		previous = {
			label = "이전 옵션",
			tooltip = "이전 옵션을 선택합니다.",
		},
		next = {
			label = "다음 옵션",
			tooltip = "다음 옵션을 선택합니다.",
		},
		clear = "선택 지우기",
	},
	copyBox = "텍스트 복사:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "값 지정",
			tooltip = "범위 내의 값을 입력하세요.",
		},
		decrease = {
			label = "감소",
			tooltip = {
				"값에서 #VALUE만큼 뺍니다.",
				"ALT를 누르고 있으면 #VALUE만큼 더 뺍니다.",
			},
		},
		increase = {
			label = "증가",
			tooltip = {
				"값에 #VALUE만큼 더합니다.",
				"ALT를 누르고 있으면 #VALUE만큼 더 더합니다.",
			},
		},
	},
	color = {
		picker = {
			label = "색상 선택",
			tooltip = "색상 선택기를 열어 색상#ALPHA을(를) 지정하세요.",
			alpha = " 및 투명도 변경",
		},
		hex = {
			label = "HEX 색상 코드로 추가",
			tooltip = "색상 선택기 대신 HEX 코드로 색상을 변경할 수 있습니다.",
		}
	},
	settings = {
		save = "닫을 때 변경 사항이 적용됩니다.",
		cancel = {
			label = "변경 사항 되돌리기",
			tooltip = "이 페이지에서 변경한 내용을 모두 취소하고 저장된 값을 불러옵니다.",
		},
		defaults = {
			label = "기본값 복원",
			tooltip = "이 페이지(또는 전체 카테고리)의 모든 설정을 기본값으로 복원합니다.",
		},
		warning = "#PAGE 페이지 또는 #CATEGORY 카테고리의 모든 설정을 기본값으로 초기화하시겠습니까?",
		warningSingle = "#PAGE 페이지의 설정을 기본값으로 초기화하시겠습니까?",
	},
	value = {
		copy = "값 복사",
		paste = "값 붙여넣기",
		revert = "변경 사항 되돌리기",
		restore = "기본값 복원",
		note = "오른쪽 클릭으로 복사하거나 되돌릴 수 있습니다.",
	},
	points = {
		left = "왼쪽",
		right = "오른쪽",
		center = "가운데",
		top = {
			left = "왼쪽 상단",
			right = "오른쪽 상단",
			center = "가운데 상단",
		},
		bottom = {
			left = "왼쪽 하단",
			right = "오른쪽 하단",
			center = "가운데 하단",
		},
	},
	strata = {
		lowest = "최하단 배경",
		lower = "중간 배경",
		low = "상위 배경",
		lowMid = "하위 중간",
		highMid = "상위 중간",
		high = "하위 전경",
		higher = "중간 전경",
		highest = "상위 전경",
	},
	about = {
		title = "정보",
		description = "#ADDON을(를) 사용해 주셔서 감사합니다! 피드백, 도움 요청, 개발 지원 방법은 링크를 참고하세요.",
		version = "버전",
		date = "날짜",
		author = "제작자",
		license = "라이선스",
		curseForge = "CurseForge 페이지",
		wago = "Wago 페이지",
		repository = "GitHub 저장소",
		issues = "문제 및 피드백",
		changelog = {
			label = "업데이트 노트",
			tooltip = "최신 버전(#VERSION)에 적용된 모든 변경, 업데이트, 수정 사항 노트입니다.",
		},
		fullChangelog = {
			label = "#ADDON 변경 기록",
			tooltip = "모든 애드온 버전의 전체 업데이트 노트 목록입니다.",
			open = {
				label = "변경 기록",
				tooltip = "모든 애드온 버전의 전체 업데이트 노트를 확인하세요.",
			},
		},
	},
	sponsors = {
		title = "후원자",
		description = "지속적인 후원에 진심으로 감사드립니다!",
	},
	dataManagement = {
		title = "데이터 관리",
		description = "프로필 및 백업을 가져오기/내보내기로 #ADDON 설정을 추가로 관리하세요.",
	},
	profiles = {
		title = "프로필",
		description = "각 캐릭터별로 고유한 옵션 프로필을 생성, 편집, 적용할 수 있습니다.",
		select = {
			label = "프로필 선택",
			tooltip = "현재 캐릭터에 사용할 옵션 데이터 저장 프로필을 선택하세요.\n\n활성 프로필의 데이터는 설정을 수정하고 저장할 때 자동으로 덮어씌워집니다!",
			profile = "프로필",
			main = "메인",
		},
		new = {
			label = "새 프로필",
			tooltip = "새 기본 프로필을 생성합니다.",
		},
		duplicate = {
			label = "복제",
			tooltip = "현재 활성 프로필의 데이터를 복사하여 새 프로필을 만듭니다.",
		},
		rename = {
			label = "이름 변경",
			tooltip = "현재 활성 프로필의 이름을 변경합니다.",
			description = "#PROFILE의 이름을 다음으로 변경:",
		},
		delete = {
			tooltip = "현재 활성 프로필을 삭제합니다.",
			warning = "현재 활성 #PROFILE #ADDON 설정 프로필을 삭제하고 저장된 모든 데이터를 영구적으로 삭제하시겠습니까?"
		},
		reset = {
			warning = "현재 활성 #PROFILE #ADDON 설정 프로필을 기본값으로 덮어쓰시겠습니까?",
		},
	},
	backup = {
		title = "백업",
		description = "현재 활성 프로필의 데이터를 가져오기/내보내기로 저장, 공유, 이동하거나 값을 직접 수정할 수 있습니다.",
		box = {
			label = "현재 프로필 가져오기/내보내기",
			tooltip = {
				"이 상자의 백업 문자열에는 현재 활성 애드온 프로필 데이터가 포함되어 있습니다.",
				"텍스트를 복사하여 데이터를 저장, 공유하거나 다른 계정에 불러올 수 있습니다.",
				"가지고 있는 문자열로 데이터를 불러오려면 이 상자의 텍스트를 덮어쓴 후 " .. KEY_ENTER .. "를 누르거나 #LOAD 버튼을 클릭하세요.",
				"참고: 커스텀 폰트나 텍스처 파일을 사용하는 경우, 해당 파일은 이 문자열로 함께 전송되지 않습니다. 별도로 저장 후 애드온 폴더에 넣어야 사용할 수 있습니다.",
				"직접 확인했거나 신뢰하는 소스의 문자열만 불러오세요!",
			},
		},
		allProfiles = {
			label = "모든 프로필 가져오기/내보내기",
			tooltipLine = "이 상자의 백업 문자열에는 모든 애드온 프로필 목록과 각 프로필에 저장된 데이터, 그리고 현재 활성 프로필 이름이 포함되어 있습니다.",
			open = {
				label = "모든 프로필",
				tooltip = "전체 프로필 목록에 접근하여 각 프로필의 데이터를 백업하거나 수정할 수 있습니다.",
			},
		},
		compact = {
			label = "간단히",
			tooltip = "간단한 보기와 더 읽기 쉽고 편집 가능한 보기로 전환합니다.",
		},
		load = {
			label = "불러오기",
			tooltip = "현재 문자열을 확인하고 데이터를 불러옵니다.",
		},
		reset = {
			tooltip = "문자열에 적용된 모든 변경 사항을 취소하고 현재 저장된 데이터로 초기화합니다.",
		},
		import = "문자열 불러오기",
		warning = "현재 입력된 문자열을 불러오시겠습니까?\n\n저장되지 않은 모든 변경 사항이 취소됩니다.\n\n온라인 소스에서 복사했거나 다른 사람이 보낸 경우, 내부 코드를 확인하고 신뢰할 수 있을 때만 불러오세요.\n\n신뢰하지 않는 소스라면 원치 않는 동작을 방지하기 위해 취소하는 것이 좋습니다.",
		error = "제공된 백업 문자열을 검증할 수 없어 데이터를 불러오지 못했습니다. 일부 문자가 누락되었거나 편집 중 오류가 발생했을 수 있습니다.",
	},
	position = {
		title = "위치",
		description = {
			static = "#FRAME의 화면 내 위치를 여기서 세밀하게 조정하세요.",
			movable = "SHIFT를 누른 채 #FRAME을 드래그하여 원하는 위치로 옮기고, 여기서 세밀하게 조정하세요.",
		},
		relativePoint = {
			label = "화면 기준점",
			tooltip = "#FRAME의 선택한 기준점을 여기서 선택한 연결점에 붙입니다.",
		},
		-- relativeTo = {
		-- 	label = "프레임에 연결",
		-- 	tooltip = "다른 UI 요소(프레임) 이름을 입력하여 #FRAME의 위치를 연결할 수 있습니다.\n\n/framestack 명령어로 프레임 이름을 확인할 수 있습니다.",
		-- },
		anchor = {
			label = "연결 기준점",
			tooltip = "선택한 화면 기준점에 연결할 때 #FRAME이 어느 지점에서 고정될지 선택하세요.",
		},
		keepInPlace = {
			label = "위치 유지",
			tooltip = "#ANCHOR를 변경해도 #FRAME을 이동하지 않고 오프셋 값만 업데이트합니다.",
		},
		offsetX= {
			label = "수평 오프셋",
			tooltip = "선택한 #ANCHOR로부터 #FRAME의 수평(X축) 오프셋을 설정합니다.",
		},
		offsetY = {
			label = "수직 오프셋",
			tooltip = "선택한 #ANCHOR로부터 #FRAME의 수직(Y축) 오프셋을 설정합니다.",
		},
		keepInBounds = {
			label = "화면 내에 유지",
			tooltip = "#FRAME이 화면 밖으로 나가지 않도록 합니다.",
		},
	},
	presets = {
		apply = {
			label = "프리셋 적용",
			tooltip = "#FRAME의 위치를 아래 프리셋 중 하나를 선택해 변경하세요.",
			list = { "미니맵 아래", },
			select = "프리셋 선택…",
		},
		save = {
			label = "#CUSTOM 프리셋 업데이트",
			tooltip = "현재 #FRAME의 위치와 표시 상태를 #CUSTOM 프리셋에 저장합니다.",
			warning = "#CUSTOM 프리셋을 현재 값으로 덮어쓰시겠습니까?",
		},
		reset = {
			label = "#CUSTOM 프리셋 초기화",
			tooltip = "저장된 #CUSTOM 프리셋 데이터를 기본값으로 덮어쓰고 적용합니다.",
			warning = "#CUSTOM 프리셋을 기본값으로 덮어쓰시겠습니까?",
		},
	},
	layer = {
		strata = {
			label = "화면 레이어",
			tooltip = "#FRAME을 다른 UI 요소보다 앞이나 뒤로 이동시킵니다.",
		},
		keepOnTop = {
			label = "마우스 상호작용 시 위로 표시",
			tooltip = "마우스 상호작용 시 #FRAME이 같은 #STRATA 내 다른 프레임 위로 이동할 수 있도록 허용합니다.",
		},
		level = {
			label = "프레임 레벨",
			tooltip = "같은 #STRATA 스택 내에서 #FRAME이 위/아래에 위치할 정확한 레벨입니다.",
		},
	},
	font = {
		title = "텍스트",
		path = {
			label = "글꼴",
			tooltip = "글꼴을 선택하세요.",
			default = {
				label = "지역화된 기본 글꼴",
				tooltip = "이것은 블리자드에서 사용하는 지역화된 기본 글꼴입니다.",
			},
			base = "이것은 기본 게임 글꼴입니다.",
			custom = "이것은 사용자 지정 글꼴입니다.",
			otf = "OpenType 글꼴 라이선스.",
			file = "파일 경로: #PATH",
			replace = "사용자 지정 옵션은 #FILE_CUSTOM 글꼴 파일을\n#FONTS_DIRECTORY\n내에서 찾을 수 있는 다른 TrueType 글꼴 파일로 교체하여 완전한 사용자 지정을 제공합니다. 단, 원래의 #FILE_CUSTOM 파일 이름은 유지해야 합니다.",
			reminder = "글꼴 파일을 교체한 후 변경 사항을 적용하려면 게임 클라이언트를 완전히 재시작해야 할 수 있습니다.",
		},
		size = {
			label = "크기",
			tooltip = "글꼴 크기를 설정하세요.",
		},
		alignment = {
			label = "정렬",
			tooltip = "텍스트의 가로 정렬을 선택하세요.",
		},
		color = {
			copy = "값 복사",
			paste = "값 붙여넣기",
		},
	},
	date = "#YEAR년 #MONTH월 #DAY일",
	override = "덮어쓰기",
	example = "예시",
}

---Chinese (traditional, Taiwan)
---@class toolboxStrings_zhTW
local zhTW = {
	chat = {
		welcome = {
			thanks = "感謝您使用#ADDON！",
			hint = "輸入#KEYWORD來查看聊天指令列表。",
			keywords = "#KEYWORD 或 #KEYWORD_ALTERNATE",
		},
		help = {
			list = "#ADDON 聊天指令列表：",
		},
	},
	popupInput = {
		title = "請輸入文字",
		tooltip = "按下" .. KEY_ENTER .. "以接受輸入的文字，或按" .. KEY_ESCAPE .. "以取消。",
	},
	reload = {
		title = "有待套用的變更",
		description = "請重新載入介面以套用變更。",
		accept = {
			label = "立即重載",
			tooltip = "您可以選擇現在重載介面以套用變更。",
		},
		cancel = {
			label = "稍後",
			tooltip = "稍後可使用 /reload 指令或登出來重載介面。",
		},
	},
	multiSelector = {
		locked = "已鎖定",
		minLimit = "至少需選擇 #MIN 個選項。",
		maxLimit = "一次只能選擇 #MAX 個選項。",
	},
	dropdown = {
		selected = "這是目前選擇的選項。",
		none = "尚未選擇任何選項。",
		open = "點擊以檢視選項列表。",
		previous = {
			label = "上一個選項",
			tooltip = "選擇上一個選項。",
		},
		next = {
			label = "下一個選項",
			tooltip = "選擇下一個選項。",
		},
		clear = "清除選取",
	},
	copyBox = "請按下：\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac) 來複製文字",
	slider = {
		value = {
			label = "請輸入數值",
			tooltip = "請輸入範圍內的數值。",
		},
		decrease = {
			label = "減少",
			tooltip = {
				"從數值中減去 #VALUE。",
				"按住 ALT 可減去 #VALUE。",
			},
		},
		increase = {
			label = "增加",
			tooltip = {
				"將 #VALUE 加到數值中。",
				"按住 ALT 可加上 #VALUE。",
			},
		},
	},
	color = {
		picker = {
			label = "選擇顏色",
			tooltip = "開啟顏色選擇器自訂顏色#ALPHA。",
			alpha = "並調整透明度",
		},
		hex = {
			label = "以 HEX 色碼新增",
			tooltip = "您也可以直接輸入 HEX 色碼來變更顏色。",
		}
	},
	settings = {
		save = "關閉時將套用變更。",
		cancel = {
			label = "還原變更",
			tooltip = "放棄本頁所有變更並載入已儲存的值。",
		},
		defaults = {
			label = "恢復預設值",
			tooltip = "將本頁（或整個分類）所有設定恢復為預設值。",
		},
		warning = "確定要將 #PAGE 頁面或 #CATEGORY 分類的所有設定恢復為預設值嗎？",
		warningSingle = "確定要將 #PAGE 頁面的設定恢復為預設值嗎？",
	},
	value = {
		copy = "複製數值",
		paste = "貼上數值",
		revert = "還原變更",
		restore = "恢復預設",
		note = "右鍵點擊可複製或還原。",
	},
	points = {
		left = "左",
		right = "右",
		center = "中",
		top = {
			left = "左上",
			right = "右上",
			center = "上中",
		},
		bottom = {
			left = "左下",
			right = "右下",
			center = "下中",
		},
	},
	strata = {
		lowest = "最低背景",
		lower = "中等背景",
		low = "高背景",
		lowMid = "低中層",
		highMid = "高中層",
		high = "低前景",
		higher = "中前景",
		highest = "高前景",
	},
	about = {
		title = "關於",
		description = "感謝您使用#ADDON！複製下方連結以提供回饋、取得協助或支持開發。",
		version = "版本",
		date = "日期",
		author = "作者",
		license = "授權",
		curseForge = "CurseForge 頁面",
		wago = "Wago 頁面",
		repository = "GitHub 儲存庫",
		issues = "問題與回饋",
		changelog = {
			label = "更新紀錄",
			tooltip = "此版本（#VERSION）所有變更、更新與修正說明。",
		},
		fullChangelog = {
			label = "#ADDON 更新紀錄",
			tooltip = "所有版本的完整更新說明列表。",
			open = {
				label = "更新紀錄",
				tooltip = "閱讀所有版本的完整更新說明。",
			},
		},
	},
	sponsors = {
		title = "贊助者",
		description = "感謝您的持續支持！",
	},
	dataManagement = {
		title = "資料管理",
		description = "透過匯入、匯出選項管理設定檔與備份以進一步設定#ADDON。",
	},
	profiles = {
		title = "設定檔",
		description = "為每個角色建立、編輯並套用專屬設定檔。",
		select = {
			label = "選擇設定檔",
			tooltip = "選擇目前角色要使用的設定檔。\n\n當設定變更並儲存時，啟用的設定檔資料會自動被覆蓋！",
			profile = "設定檔",
			main = "主要",
		},
		new = {
			label = "新增設定檔",
			tooltip = "建立新的預設設定檔。",
		},
		duplicate = {
			label = "複製",
			tooltip = "以目前啟用的設定檔資料建立新設定檔。",
		},
		rename = {
			label = "重新命名",
			tooltip = "重新命名目前啟用的設定檔。",
			description = "將 #PROFILE 重新命名為：",
		},
		delete = {
			tooltip = "刪除目前啟用的設定檔。",
			warning = "確定要移除目前啟用的 #PROFILE #ADDON 設定檔並永久刪除所有儲存資料嗎？"
		},
		reset = {
			warning = "確定要將目前啟用的 #PROFILE #ADDON 設定檔覆蓋為預設值嗎？",
		},
	},
	backup = {
		title = "備份",
		description = "匯入或匯出目前啟用設定檔的資料以儲存、分享、搬移設定，或手動編輯特定值。",
		box = {
			label = "匯入或匯出目前設定檔",
			tooltip = {
				"此欄位的備份字串包含目前啟用的設定檔資料。",
				"複製文字以儲存、分享或載入到其他帳號。",
				"若要從字串載入資料，請覆蓋此欄位內容後按" .. KEY_ENTER .. "或點擊#LOAD按鈕。",
				"注意：若您使用自訂字型或材質檔案，這些檔案不會隨字串一同轉移。需另外儲存並放入插件資料夾。",
				"請僅載入您自行驗證或信任來源的字串！",
			},
		},
		allProfiles = {
			label = "匯入或匯出所有設定檔",
			tooltipLine = "此欄位的備份字串包含所有設定檔及其資料，以及目前啟用的設定檔名稱。",
			open = {
				label = "所有設定檔",
				tooltip = "存取完整設定檔列表並備份或修改各自資料。",
			},
		},
		compact = {
			label = "精簡",
			tooltip = "切換精簡或可讀/可編輯檢視。",
		},
		load = {
			label = "載入",
			tooltip = "檢查目前字串並嘗試載入資料。",
		},
		reset = {
			tooltip = "放棄對字串的所有變更，並重設為目前儲存的資料。",
		},
		import = "載入字串",
		warning = "確定要嘗試載入目前輸入的字串嗎？\n\n所有未儲存的變更將被放棄。\n\n若您是從網路來源複製或他人傳送，請確認內容安全再載入。\n\n若不信任來源，建議取消以避免不預期的行為。",
		error = "無法驗證提供的備份字串，未載入任何資料。可能缺少字元或編輯時產生錯誤。",
	},
	position = {
		title = "位置",
		description = {
			static = "可在此微調#FRAME於螢幕上的位置。",
			movable = "按住 SHIFT 拖曳#FRAME至螢幕任意位置，並可於此微調。",
		},
		relativePoint = {
			label = "螢幕連結點",
			tooltip = "將#FRAME選定的錨點連結到此處選擇的螢幕點。",
		},
		-- relativeTo = {
		-- 	label = "連結到框架",
		-- 	tooltip = "輸入其他 UI 元素名稱，將#FRAME位置連結至該框架。\n\n可用 /framestack 指令查詢框架名稱。",
		-- },
		anchor = {
			label = "連結錨點",
			tooltip = "選擇#FRAME連結到螢幕點時要從哪個錨點對齊。",
		},
		keepInPlace = {
			label = "保持原位",
			tooltip = "變更#ANCHOR時不移動#FRAME，只更新偏移值。",
		},
		offsetX= {
			label = "水平偏移",
			tooltip = "設定#FRAME自選定#ANCHOR的水平（X軸）偏移量。",
		},
		offsetY = {
			label = "垂直偏移",
			tooltip = "設定#FRAME自選定#ANCHOR的垂直（Y軸）偏移量。",
		},
		keepInBounds = {
			label = "保持在螢幕內",
			tooltip = "確保#FRAME不會被移出螢幕範圍。",
		},
	},
	presets = {
		apply = {
			label = "套用預設位置",
			tooltip = "選擇並套用下列預設位置以變更#FRAME位置。",
			list = { "小地圖下方", },
			select = "選擇預設位置…",
		},
		save = {
			label = "更新#CUSTOM預設",
			tooltip = "將目前#FRAME的位置與顯示狀態儲存至#CUSTOM預設。",
			warning = "確定要以目前值覆蓋#CUSTOM預設嗎？",
		},
		reset = {
			label = "重設#CUSTOM預設",
			tooltip = "以預設值覆蓋#CUSTOM預設資料並套用。",
			warning = "確定要以預設值覆蓋#CUSTOM預設嗎？",
		},
	},
	layer = {
		strata = {
			label = "畫面層級",
			tooltip = "將#FRAME提升或降低至其他 UI 元素的前後。",
		},
		keepOnTop = {
			label = "滑鼠互動時顯示在最上層",
			tooltip = "互動時允許#FRAME在同一#STRATA內移到其他框架之上。",
		},
		level = {
			label = "框架層級",
			tooltip = "#FRAME在同一#STRATA堆疊中上下的精確位置。",
		},
	},
	font = {
		title = "文字",
		path = {
			label = "字體",
			tooltip = "選擇字體。",
			default = {
				label = "在地化預設字體",
				tooltip = "這是 Blizzard 使用的在地化預設字體。",
			},
			base = "這是遊戲本體的字體。",
			custom = "這是自訂字體。",
			otf = "OpenType 字體授權。",
			file = "檔案路徑：#PATH",
			replace = "自訂選項提供完整的自訂功能，讓您可以將 #FILE_CUSTOM 字體檔替換為在\n#FONTS_DIRECTORY\n中找到的任何 TrueType 字體檔，同時保持原本的 #FILE_CUSTOM 檔名。",
			reminder = "替換字體檔後，您可能需要完全重新啟動遊戲客戶端才能套用變更。",
		},
		size = {
			label = "大小",
			tooltip = "設定字體大小。",
		},
		alignment = {
			label = "對齊",
			tooltip = "選擇文字的水平對齊方式。",
		},
		color = {
			label = "#COLOR_TYPE 顏色",
			tooltip = "設定 #COLOR_TYPE 文字顏色。",
		},
	},
	date = "#YEAR/#MONTH/#DAY",
	override = "覆蓋",
	example = "範例",
}

---Chinese (simplified, PRC)
---@class toolboxStrings_zhCN
local zhCN = {
	chat = {
		welcome = {
			thanks = "感谢您使用#ADDON！",
			hint = "输入#KEYWORD查看聊天命令列表。",
			keywords = "#KEYWORD 或 #KEYWORD_ALTERNATE",
		},
		help = {
			list = "#ADDON 聊天命令列表：",
		},
	},
	popupInput = {
		title = "请输入文本",
		tooltip = "按" .. KEY_ENTER .. "确认输入的文本，或按" .. KEY_ESCAPE .. "取消。",
	},
	reload = {
		title = "待应用更改",
		description = "请重新加载界面以应用待处理的更改。",
		accept = {
			label = "立即重载",
			tooltip = "您可以选择现在重载界面以应用更改。",
		},
		cancel = {
			label = "稍后",
			tooltip = "稍后可通过/reload命令或注销来重载界面。",
		},
	},
	multiSelector = {
		locked = "已锁定",
		minLimit = "至少需要选择 #MIN 个选项。",
		maxLimit = "一次只能选择 #MAX 个选项。",
	},
	dropdown = {
		selected = "这是当前选中的选项。",
		none = "尚未选择任何选项。",
		open = "点击查看选项列表。",
		previous = {
			label = "上一个选项",
			tooltip = "选择上一个选项。",
		},
		next = {
			label = "下一个选项",
			tooltip = "选择下一个选项。",
		},
		clear = "清除选择",
	},
	copyBox = "按下：\n" .. CTRL_KEY_TEXT .. " + C (Windows)\n" .. COMMAND .. " + C (Mac) 复制文本",
	slider = {
		value = {
			label = "请输入数值",
			tooltip = "输入范围内的任意数值。",
		},
		decrease = {
			label = "减少",
			tooltip = {
				"从当前值减去#VALUE。",
				"按住ALT可减去#VALUE。",
			},
		},
		increase = {
			label = "增加",
			tooltip = {
				"将#VALUE加到当前值。",
				"按住ALT可加上#VALUE。",
			},
		},
	},
	color = {
		picker = {
			label = "选择颜色",
			tooltip = "打开颜色选择器自定义颜色#ALPHA。",
			alpha = "并调整透明度",
		},
		hex = {
			label = "通过HEX颜色码添加",
			tooltip = "您可以通过HEX颜色码更改颜色，而不是使用颜色选择器。",
		}
	},
	settings = {
		save = "关闭时将应用更改。",
		cancel = {
			label = "撤销更改",
			tooltip = "放弃本页所有更改并加载已保存的值。",
		},
		defaults = {
			label = "恢复默认",
			tooltip = "将本页（或整个分类）的所有设置恢复为默认值。",
		},
		warning = "确定要将#PAGE页面或#CATEGORY分类的所有设置恢复为默认值吗？",
		warningSingle = "确定要将#PAGE页面的设置恢复为默认值吗？",
	},
	value = {
		copy = "复制数值",
		paste = "粘贴数值",
		revert = "撤销更改",
		restore = "恢复默认",
		note = "右键点击可复制或撤销。",
	},
	points = {
		left = "左",
		right = "右",
		center = "中",
		top = {
			left = "左上",
			right = "右上",
			center = "上中",
		},
		bottom = {
			left = "左下",
			right = "右下",
			center = "下中",
		},
	},
	strata = {
		lowest = "最低背景",
		lower = "中等背景",
		low = "高背景",
		lowMid = "低中层",
		highMid = "高中层",
		high = "低前景",
		higher = "中前景",
		highest = "高前景",
	},
	about = {
		title = "关于",
		description = "感谢您使用#ADDON！复制下方链接以反馈、获取帮助或支持开发。",
		version = "版本",
		date = "日期",
		author = "作者",
		license = "许可证",
		curseForge = "CurseForge页面",
		wago = "Wago页面",
		repository = "GitHub仓库",
		issues = "问题与反馈",
		changelog = {
			label = "更新说明",
			tooltip = "本次版本（#VERSION）所有更改、更新与修复说明。",
		},
		fullChangelog = {
			label = "#ADDON更新日志",
			tooltip = "所有插件版本的完整更新说明列表。",
			open = {
				label = "更新日志",
				tooltip = "阅读所有插件版本的完整更新说明。",
			},
		},
	},
	sponsors = {
		title = "赞助者",
		description = "非常感谢您的持续支持！",
	},
	dataManagement = {
		title = "数据管理",
		description = "通过导入、导出选项管理配置文件和备份以进一步配置#ADDON。",
	},
	profiles = {
		title = "配置文件",
		description = "为每个角色创建、编辑并应用专属配置文件。",
		select = {
			label = "选择配置文件",
			tooltip = "选择当前角色要使用的配置文件。\n\n当设置更改并保存时，激活的配置文件数据会自动被覆盖！",
			profile = "配置文件",
			main = "主",
		},
		new = {
			label = "新建配置文件",
			tooltip = "创建新的默认配置文件。",
		},
		duplicate = {
			label = "复制",
			tooltip = "以当前激活的配置文件数据创建新配置文件。",
		},
		rename = {
			label = "重命名",
			tooltip = "重命名当前激活的配置文件。",
			description = "将#PROFILE重命名为：",
		},
		delete = {
			tooltip = "删除当前激活的配置文件。",
			warning = "确定要移除当前激活的#PROFILE #ADDON配置文件并永久删除其中所有数据吗？"
		},
		reset = {
			warning = "确定要将当前激活的#PROFILE #ADDON配置文件覆盖为默认值吗？",
		},
	},
	backup = {
		title = "备份",
		description = "导入或导出当前激活配置文件的数据以保存、分享、迁移设置，或手动编辑特定值。",
		box = {
			label = "导入或导出当前配置文件",
			tooltip = {
				"此框中的备份字符串包含当前激活的插件配置文件数据。",
				"复制文本以保存、分享或为其他账号加载数据。",
				"如需从字符串加载数据，请覆盖此框内文本后按" .. KEY_ENTER .. "或点击#LOAD按钮。",
				"注意：如果您使用自定义字体或材质文件，这些文件不会随字符串一起转移。需单独保存并放入插件文件夹。",
				"请仅加载您自己验证或信任来源的字符串！",
			},
		},
		allProfiles = {
			label = "导入或导出所有配置文件",
			tooltipLine = "此框中的备份字符串包含所有插件配置文件及其数据，以及当前激活配置文件的名称。",
			open = {
				label = "所有配置文件",
				tooltip = "访问完整配置文件列表并备份或修改各自数据。",
			},
		},
		compact = {
			label = "精简",
			tooltip = "在精简和更易读/可编辑视图间切换。",
		},
		load = {
			label = "加载",
			tooltip = "检查当前字符串并尝试加载数据。",
		},
		reset = {
			tooltip = "放弃对字符串的所有更改，并重置为当前保存的数据。",
		},
		import = "加载字符串",
		warning = "确定要尝试加载当前输入的字符串吗？\n\n所有未保存的更改将被放弃。\n\n如果您是从网络来源复制或他人发送，仅在确认内容安全时加载。\n\n如不信任来源，建议取消以避免意外操作。",
		error = "无法验证提供的备份字符串，未加载任何数据。可能缺少字符或编辑时出现错误。",
	},
	position = {
		title = "位置",
		description = {
			static = "可在此微调#FRAME在屏幕上的位置。",
			movable = "按住SHIFT拖动#FRAME到屏幕任意位置，并可在此微调。",
		},
		relativePoint = {
			label = "屏幕锚点",
			tooltip = "将#FRAME选定的锚点连接到此处选择的屏幕点。",
		},
		-- relativeTo = {
		-- 	label = "连接到框体",
		-- 	tooltip = "输入其他UI元素名称，将#FRAME位置连接到该框体。\n\n可用/framestack命令查询框体名称。",
		-- },
		anchor = {
			label = "连接锚点",
			tooltip = "选择#FRAME连接到屏幕点时要从哪个锚点对齐。",
		},
		keepInPlace = {
			label = "保持原位",
			tooltip = "更改#ANCHOR时不移动#FRAME，只更新偏移值。",
		},
		offsetX= {
			label = "水平偏移",
			tooltip = "设置#FRAME相对于选定#ANCHOR的水平（X轴）偏移量。",
		},
		offsetY = {
			label = "垂直偏移",
			tooltip = "设置#FRAME相对于选定#ANCHOR的垂直（Y轴）偏移量。",
		},
		keepInBounds = {
			label = "保持在屏幕内",
			tooltip = "确保#FRAME不会被移出屏幕范围。",
		},
	},
	presets = {
		apply = {
			label = "应用预设",
			tooltip = "选择并应用下列预设以更改#FRAME位置。",
			list = { "小地图下方", },
			select = "选择预设…",
		},
		save = {
			label = "更新#CUSTOM预设",
			tooltip = "将当前#FRAME的位置和可见性保存到#CUSTOM预设。",
			warning = "确定要用当前值覆盖#CUSTOM预设吗？",
		},
		reset = {
			label = "重置#CUSTOM预设",
			tooltip = "用默认值覆盖#CUSTOM预设数据并应用。",
			warning = "确定要用默认值覆盖#CUSTOM预设吗？",
		},
	},
	layer = {
		strata = {
			label = "屏幕层级",
			tooltip = "将#FRAME提升或降低到其他UI元素的前后。",
		},
		keepOnTop = {
			label = "鼠标交互时置顶",
			tooltip = "允许#FRAME在同一#STRATA内与其他框体交互时置于其上方。",
		},
		level = {
			label = "框体层级",
			tooltip = "#FRAME在同一#STRATA堆栈中上下的精确位置。",
		},
	},
	font = {
		title = "文本",
		path = {
			label = "字体",
			tooltip = "选择字体。",
			default = {
				label = "本地化默认字体",
				tooltip = "这是 Blizzard 使用的本地化默认字体。",
			},
			base = "这是基础游戏字体。",
			custom = "这是自定义字体。",
			otf = "OpenType 字体许可。",
			file = "文件路径：#PATH",
			replace = "自定义选项提供完全自定义功能，允许你将 #FILE_CUSTOM 字体文件替换为在\n#FONTS_DIRECTORY\n中找到的任何 TrueType 字体文件，同时保持原有的 #FILE_CUSTOM 文件名。",
			reminder = "替换字体文件后，你可能需要完全重启游戏客户端才能应用更改。",
		},
		size = {
			label = "大小",
			tooltip = "设置字体大小。",
		},
		alignment = {
			label = "对齐",
			tooltip = "选择文本的水平对齐方式。",
		},
		color = {
			label = "#COLOR_TYPE 颜色",
			tooltip = "设置 #COLOR_TYPE 文本颜色。",
		},
	},
	date = "#YEAR/#MONTH/#DAY",
	override = "覆盖",
	example = "示例",
}

---Russian
---@class toolboxStrings_ruRU
local ruRU = {
	chat = {
		welcome = {
			thanks = "Спасибо за использование #ADDON!",
			hint = "Введите #KEYWORD, чтобы увидеть список команд чата.",
			keywords = "#KEYWORD или #KEYWORD_ALTERNATE",
		},
		help = {
			list = "Список команд чата #ADDON:",
		},
	},
	popupInput = {
		title = "Укажите текст",
		tooltip = "Нажмите " .. KEY_ENTER .. ", чтобы принять указанный текст, или " .. KEY_ESCAPE .. ", чтобы отменить.",
	},
	reload = {
		title = "Ожидающие изменения",
		description = "Перезагрузите интерфейс, чтобы применить ожидающие изменения.",
		accept = {
			label = "Перезагрузить сейчас",
			tooltip = "Вы можете перезагрузить интерфейс сейчас, чтобы применить ожидающие изменения.",
		},
		cancel = {
			label = "Позже",
			tooltip = "Перезагрузите интерфейс позже с помощью команды /reload или выйдите из игры.",
		},
	},
	multiSelector = {
		locked = "Заблокировано",
		minLimit = "Необходимо выбрать как минимум #MIN вариантов.",
		maxLimit = "Можно выбрать не более #MAX вариантов одновременно.",
	},
	dropdown = {
		selected = "Это выбранный в данный момент вариант.",
		none = "Ни один вариант не выбран.",
		open = "Нажмите, чтобы просмотреть список вариантов.",
		previous = {
			label = "Предыдущий вариант",
			tooltip = "Выбрать предыдущий вариант.",
		},
		next = {
			label = "Следующий вариант",
			tooltip = "Выбрать следующий вариант.",
		},
		clear = "Очистить выделение",
	},
	copyBox = "Скопируйте текст, нажав:\n" .. CTRL_KEY_TEXT .." + C (Windows)\n" .. COMMAND .. " + C (Mac)",
	slider = {
		value = {
			label = "Укажите значение",
			tooltip = "Введите любое значение в пределах диапазона.",
		},
		decrease = {
			label = "Уменьшить",
			tooltip = {
				"Вычесть #VALUE из значения.",
				"Удерживайте ALT, чтобы вычесть #VALUE вместо этого.",
			},
		},
		increase = {
			label = "Увеличить",
			tooltip = {
				"Добавить #VALUE к значению.",
				"Удерживайте ALT, чтобы добавить #VALUE вместо этого.",
			},
		},
	},
	color = {
		picker = {
			label = "Выбрать цвет",
			tooltip = "Откройте палитру, чтобы настроить цвет#ALPHA.",
			alpha = " и изменить прозрачность",
		},
		hex = {
			label = "Добавить через HEX-код",
			tooltip = "Вы можете изменить цвет через HEX-код вместо палитры.",
		}
	},
	settings = {
		save = "Изменения будут применены при закрытии.",
		cancel = {
			label = "Отменить изменения",
			tooltip = "Отменить все изменения на этой странице и загрузить сохранённые значения.",
		},
		defaults = {
			label = "Восстановить по умолчанию",
			tooltip = "Восстановить все настройки этой страницы (или всей категории) по умолчанию.",
		},
		warning = "Вы уверены, что хотите сбросить настройки страницы #PAGE или все настройки категории #CATEGORY по умолчанию?",
		warningSingle = "Вы уверены, что хотите сбросить настройки страницы #PAGE по умолчанию?",
	},
	value = {
		copy = "Копировать значение",
		paste = "Вставить значение",
		revert = "Отменить изменения",
		restore = "Восстановить по умолчанию",
		note = "Щёлкните правой кнопкой, чтобы скопировать или отменить.",
	},
	points = {
		left = "Слева",
		right = "Справа",
		center = "По центру",
		top = {
			left = "Верхний левый",
			right = "Верхний правый",
			center = "Верхний центр",
		},
		bottom = {
			left = "Нижний левый",
			right = "Нижний правый",
			center = "Нижний центр",
		},
	},
	strata = {
		lowest = "Низкий фон",
		lower = "Средний фон",
		low = "Высокий фон",
		lowMid = "Низкий средний",
		highMid = "Высокий средний",
		high = "Низкий передний план",
		higher = "Средний передний план",
		highest = "Высокий передний план",
	},
	about = {
		title = "О модификации",
		description = "Спасибо за использование #ADDON! Скопируйте ссылки, чтобы оставить отзыв, получить помощь или поддержать разработку.",
		version = "Версия",
		date = "Дата",
		author = "Автор",
		license = "Лицензия",
		curseForge = "Страница CurseForge",
		wago = "Страница Wago",
		repository = "Репозиторий GitHub",
		issues = "Ошибки и обратная связь",
		changelog = {
			label = "Примечания к обновлению",
			tooltip = "Список всех изменений, обновлений и исправлений в последней версии: #VERSION.",
		},
		fullChangelog = {
			label = "История изменений #ADDON",
			tooltip = "Полный список изменений всех версий аддона.",
			open = {
				label = "История изменений",
				tooltip = "Просмотрите полный список изменений всех версий аддона.",
			},
		},
	},
	sponsors = {
		title = "Спонсоры",
		description = "Ваша поддержка очень ценится! Спасибо!",
	},
	dataManagement = {
		title = "Управление данными",
		description = "Настройте #ADDON дополнительно, управляя профилями и резервными копиями через импорт и экспорт.",
	},
	profiles = {
		title = "Профили",
		description = "Создавайте, редактируйте и применяйте уникальные профили настроек для каждого персонажа.",
		select = {
			label = "Выбрать профиль",
			tooltip = "Выберите профиль хранения настроек для текущего персонажа.\n\nДанные активного профиля будут автоматически перезаписаны при изменении и сохранении настроек!",
			profile = "Профиль",
			main = "Основной",
		},
		new = {
			label = "Новый профиль",
			tooltip = "Создать новый профиль по умолчанию.",
		},
		duplicate = {
			label = "Дублировать",
			tooltip = "Создать новый профиль, скопировав данные из активного профиля.",
		},
		rename = {
			label = "Переименовать",
			tooltip = "Переименовать активный профиль.",
			description = "Переименовать #PROFILE в:",
		},
		delete = {
			tooltip = "Удалить активный профиль.",
			warning = "Вы уверены, что хотите удалить активный профиль настроек #PROFILE #ADDON и навсегда удалить все данные в нём?"
		},
		reset = {
			warning = "Вы уверены, что хотите перезаписать активный профиль настроек #PROFILE #ADDON значениями по умолчанию?",
		},
	},
	backup = {
		title = "Резервная копия",
		description = "Импортируйте или экспортируйте данные активного профиля для сохранения, передачи или ручного редактирования настроек.",
		box = {
			label = "Импорт или экспорт текущего профиля",
			tooltip = {
				"Строка резервной копии содержит данные активного профиля аддона.",
				"Скопируйте текст для сохранения, передачи или загрузки данных для другого аккаунта.",
				"Чтобы загрузить данные из строки, замените текст в этом поле, затем нажмите " .. KEY_ENTER .. " или кнопку #LOAD.",
				"Внимание: если вы используете пользовательские шрифты или текстуры, эти файлы не будут перенесены вместе со строкой. Их нужно сохранить отдельно и поместить в папку аддона.",
				"Загружайте только строки, в которых вы уверены или которым доверяете!",
			},
		},
		allProfiles = {
			label = "Импорт или экспорт всех профилей",
			tooltipLine = "Строка резервной копии содержит список всех профилей аддона и данные каждого, а также имя активного профиля.",
			open = {
				label = "Все профили",
				tooltip = "Откройте полный список профилей и сделайте резервную копию или измените данные каждого.",
			},
		},
		compact = {
			label = "Компактно",
			tooltip = "Переключение между компактным и более читаемым/редактируемым видом.",
		},
		load = {
			label = "Загрузить",
			tooltip = "Проверить текущую строку и попытаться загрузить данные из неё.",
		},
		reset = {
			tooltip = "Отменить все изменения строки и сбросить её к текущим сохранённым данным.",
		},
		import = "Загрузить строку",
		warning = "Вы уверены, что хотите попытаться загрузить вставленную строку?\n\nВсе несохранённые изменения будут отменены.\n\nЕсли вы скопировали её из интернета или получили от кого-то, загружайте только после проверки содержимого и если уверены в безопасности.\n\nЕсли не доверяете источнику, отмените действие для предотвращения нежелательных последствий.",
		error = "Указанная строка резервной копии не прошла проверку, данные не были загружены. Возможно, отсутствуют символы или были допущены ошибки при редактировании.",
	},
	position = {
		title = "Положение",
		description = {
			static = "Точно настройте положение #FRAME на экране с помощью этих опций.",
			movable = "Перетащите #FRAME, удерживая SHIFT, чтобы разместить его в любом месте экрана, а затем отрегулируйте здесь.",
		},
		relativePoint = {
			label = "Точка привязки экрана",
			tooltip = "Привяжите выбранную точку якоря #FRAME к выбранной здесь точке.",
		},
		-- relativeTo = {
		-- 	label = "Привязать к фрейму",
		-- 	tooltip = "Введите имя другого UI-элемента, чтобы привязать позицию #FRAME.\n\nУзнать имена фреймов можно через команду /framestack.",
		-- },
		anchor = {
			label = "Точка якоря",
			tooltip = "Выберите, к какой точке #FRAME будет привязан при соединении с выбранной точкой экрана.",
		},
		keepInPlace = {
			label = "Оставить на месте",
			tooltip = "Не перемещать #FRAME при изменении #ANCHOR, а только обновлять значения смещения.",
		},
		offsetX= {
			label = "Горизонтальное смещение",
			tooltip = "Установите величину смещения по X для #FRAME относительно выбранного #ANCHOR.",
		},
		offsetY = {
			label = "Вертикальное смещение",
			tooltip = "Установите величину смещения по Y для #FRAME относительно выбранного #ANCHOR.",
		},
		keepInBounds = {
			label = "Держать в пределах экрана",
			tooltip = "Не позволять #FRAME выходить за пределы экрана.",
		},
	},
	presets = {
		apply = {
			label = "Применить пресет",
			tooltip = "Измените положение #FRAME, выбрав и применив один из этих пресетов.",
			list = { "Под миникартой", },
			select = "Выберите пресет…",
		},
		save = {
			label = "Обновить пресет #CUSTOM",
			tooltip = "Сохранить текущее положение и видимость #FRAME в пресет #CUSTOM.",
			warning = "Вы уверены, что хотите перезаписать пресет #CUSTOM текущими значениями?",
		},
		reset = {
			label = "Сбросить пресет #CUSTOM",
			tooltip = "Перезаписать данные пресета #CUSTOM значениями по умолчанию и применить.",
			warning = "Вы уверены, что хотите перезаписать пресет #CUSTOM значениями по умолчанию?",
		},
	},
	layer = {
		strata = {
			label = "Слой экрана",
			tooltip = "Поднять или опустить #FRAME относительно других UI-элементов.",
		},
		keepOnTop = {
			label = "Показывать при взаимодействии мышью",
			tooltip = "Позволяет #FRAME быть поверх других фреймов в том же #STRATA при взаимодействии.",
		},
		level = {
			label = "Уровень фрейма",
			tooltip = "Точное положение #FRAME выше или ниже других фреймов в том же стеке #STRATA.",
		},
	},
	font = {
		title = "Текст",
		path = {
			label = "Шрифт",
			tooltip = "Выберите шрифт.",
			default = {
				label = "Локализованный стандарт",
				tooltip = "Это локализованный шрифт по умолчанию, используемый Blizzard.",
			},
			base = "Это шрифт базовой версии игры.",
			custom = "Это пользовательский шрифт.",
			otf = "Лицензия шрифта OpenType.",
			file = "Путь к файлу: #PATH",
			replace = "Параметр «Пользовательский» предоставляет полную настройку, позволяя использовать любой шрифт, заменив файл #FILE_CUSTOM любым другим файлом TrueType, найденным в\n#FONTS_DIRECTORY\nпри этом сохранив исходное имя файла #FILE_CUSTOM.",
			reminder = "После замены файла шрифта может потребоваться полностью перезапустить игровой клиент, чтобы изменения вступили в силу.",
		},
		size = {
			label = "Размер",
			tooltip = "Установите размер шрифта.",
		},
		alignment = {
			label = "Выравнивание",
			tooltip = "Выберите горизонтальное выравнивание текста.",
		},
		color = {
			label = "Цвет #COLOR_TYPE",
			tooltip = "Установите цвет текста #COLOR_TYPE.",
		},
	},
	date = "#DAY.#MONTH.#YEAR",
	override = "Перезаписать",
	example = "Пример",
}


--[[ TOOLBOX ]]

---Read-only reference to the Widget Toolbox table
---@class toolbox : widgetToolbox
---@field strings toolboxStrings
---@field classic boolean Classic vs modern UI code separation
---@field clipboard toolboxClipboard
local wt = {}

	---Localized strings
	---@alias toolboxStrings
	---| toolboxStrings_enUS
	---| toolboxStrings_ptBR
	---| toolboxStrings_deDE
	---| toolboxStrings_frFR
	---| toolboxStrings_esES
	---| toolboxStrings_esMX
	---| toolboxStrings_itIT
	---| toolboxStrings_koKR
	---| toolboxStrings_zhTW
	---| toolboxStrings_zhCN
	---| toolboxStrings_ruRU

	--Widget data clipboard
	---@class toolboxClipboard
	---@field toggle boolean|nil Toggle value
	---@field selection wrappedInteger|nil Selector index
	---@field selections wrappedBooleanArray|nil Multiselector data
	---@field anchor wrappedAnchor|nil Frame Anchor Point
	---@field justifyH wrappedJustifyH|nil Horizontal text alignment value
	---@field justifyV wrappedJustifyV|nil Vertical text alignment value
	---@field strata wrappedStrata|nil Frame Strata value
	---@field text string|nil Text value
	---@field numeric number|nil Number value
	---@field color color|nil RGB(A) color value


--[[ TABLE MANAGEMENT ]]

---Align all keys in a table to a reference table, filling missing values and removing mismatched or invalid pairs
---***
---@param targetTable table Reference to the table to get into alignment with the sample
---@param tableToSample table Reference to the table to sample keys & data from
---***
---@return table|any targetTable Reference to **targetTable** (it was already overwritten during the operation, no need for setting it again)
function wt.HarmonizeData(targetTable, tableToSample) end


--[[ DATA MANAGEMENT ]]

--| Conversion

---Return a position table used by WidgetTools assembled from the provided values which are returned by [Region:GetPoint(...)](https://warcraft.wiki.gg/wiki/API_Region_GetPoint)
---***
---@param anchor? FramePoint Base anchor point | ***Default:*** "TOPLEFT"
---@param relativeTo? Frame Relative to this Frame or Region
---@param relativePoint? FramePoint Relative anchor point
---@param offsetX? number | ***Default:*** 0
---@param offsetY? number | ***Default:*** 0
---***
---@return positionData # Table containing the position values as used by WidgetTools
---<p></p>
function wt.PackPosition(anchor, relativeTo, relativePoint, offsetX, offsetY) return {} end

---Extract, verify and return the position values used by [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) from a position table used by WidgetTools
---***
---@param t? positionData Table containing parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
---***
---@return FramePoint anchor ***Default:*** "TOPLEFT"
---@return AnyFrameObject|nil relativeTo ***Default:*** "nil" *(anchor relative to screen dimensions)*<ul><li>***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).</li></ul>
---@return FramePoint? relativePoint
---@return number|nil offsetX ***Default:*** 0
---@return number|nil offsetY ***Default:*** 0
---<hr><p></p>
function wt.UnpackPosition(t) return "TOPLEFT" end

--[ Color ]

--| Verification

---Check if a variable is a valid color table
---@param t any
---@return boolean|color
function wt.IsColor(t)
	return false

	--| Returns

	---@alias color
	---| colorData
	---| colorRGBA
	---| colorRGB

		---@class colorData : rgbData_base, alpha_opaqueDefault

			---@class rgbData_base
			---@field r number Red | ***Range:*** (0, 1)
			---@field g number Green | ***Range:*** (0, 1)
			---@field b number Blue | ***Range:*** (0, 1)

			---@class alpha_opaqueDefault
		---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1
end

---Check & silently repair a color data table
---@param color any
---@return boolean|color ***Default:*** `{ r = 1, g = 1, b = 1, a = 1 }`
function wt.VerifyColor(color)

	---@class rgbData_optional
	---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 1
	---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 1
	---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 1

	return false
end

--| Conversion

---Return a table constructed from color values
---***
---@param red? number Red | ***Range:*** (0, 1) | ***Default:*** 1
---@param green? number Green | ***Range:*** (0, 1) | ***Default:*** 1
---@param blue? number Blue | ***Range:*** (0, 1) | ***Default:*** 1
---@param alpha? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1
---***
---@return color # Table containing the color values
function wt.PackColor(red, green, blue, alpha) return {} end

---Extract, verify and return the color values found in a table
---***
---@param color? color Table containing the color values | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alpha? boolean Specify whether to return the full RGBA set or just the RGB values | ***Default:*** true
---***
---@return number r Red | ***Range:*** (0, 1) | ***Default:*** 1
---@return number g Green | ***Range:*** (0, 1) | ***Default:*** 1
---@return number b Blue | ***Range:*** (0, 1) | ***Default:*** 1
---@return number? a Opacity | ***Range:*** (0, 1)
function wt.UnpackColor(color, alpha) return 1, 1, 1 end

---Convert RGB(A) color values in Range: (0, 1) to HEX color code
---***
---@param color? color The RGB(A) color data with all channels in Range: (0, 1) | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alphaFirst? boolean Put the alpha value first: ARGB output instead of RGBA | ***Default:*** false
---@param hashtag? boolean Whether to add a "#" to the beginning of the color description | ***Default:*** true
---***
---@return string hex Color code in HEX format<ul><li>***Examples:***<ul><li>**RGB:** "#2266BB"</li><li>**RGBA:** "#2266BBAA"</li></ul></li></ul>
function wt.ColorToHex(color, alphaFirst, hashtag) return "" end

---Convert a HEX color code into RGB or RGBA in Range: (0, 1)
---***
---@param hex string String in HEX color code format<ul><li>***Examples:***<ul><li>**RGB:** "#2266BB" (where the "#" is optional)</li><li>**RGBA:** "#2266BBAA" (where the "#" is optional)</li></ul></li></ul>
---***
---@return number r Red | ***Range:*** (0, 1) | ***Default:*** 1
---@return number g Green  | ***Range:*** (0, 1) | ***Default:*** 1
---@return number b Blue | ***Range:*** (0, 1) | ***Default:*** 1
---@return number? a Alpha | ***Range:*** (0, 1)
function wt.HexToColor(hex) return 1, 1, 1 end

---Brighten or darken the RGB values of a color by an exponent
---***
---@param color color Table containing the color values
---@param exponent? number ***Default:*** 0.55<ul><li>***Note:*** Values greater than 1 darken, smaller than 1 brighten the color.</li></ul>
---***
---@return any color Reference to **color** (it was already updated during the operation, no need for setting it again)
function wt.AdjustGamma(color, exponent) end

---Turn a color data table into a Blizzard color manager object
---***
---@param color color Table containing the color values
---***
---@return colorRGB|colorRGBA
function wt.CreateColor(color) return {} end


--[[ FORMATTING ]]

--[ Escape Sequences ]

---Create a markup texture string snippet via escape sequences based on the specified values
---***
---@param path string Path to the specific texture file relative to the root directory of the specific WoW client<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
---@param width? number ***Default:*** *width of the texture file*
---@param height? number ***Default:*** **width**
---@param offsetX? number | ***Default:*** 0
---@param offsetY? number | ***Default:*** 0
---@param t? table Additional parameters are to be provided in this table
---***
---@return string # ***Default:*** ""
function wt.Texture(path, width, height, offsetX, offsetY, t) return "" end

---Remove most visual formatting (like coloring) & other (like hyperlink) [escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences) from a string
--- - ***Note:*** *Grammar* escape sequences are not yet supported, and will not be removed.
---@param s string
---@return string s
function wt.Clear(s) return "" end

--[ Hyperlinks ]

---Format a clickable hyperlink text via escape sequences
---***
---@param linkType ExtendedHyperlinkType [Type of the hyperlink](https://warcraft.wiki.gg/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
---@param content? string A colon-separated chain of parameters determined by **type** (Example: "content1:content2:content3") | ***Default:*** ""
---@param text string Clickable text to be displayed as the hyperlink
---***
---@return string # ***Default:*** ""
---<p></p>
function wt.Hyperlink(linkType, content, text)

	--| Parameters

	---@alias ExtendedHyperlinkType # linkType
	---| HyperlinkType
	---| "addon"
	---| "mawpower"

	return ""
end

---Format a custom clickable addon hyperlink text via escape sequences
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param type? string A unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks) in order to be able to set unique hyperlink click handlers via ***WidgetToolbox*.SetHyperlinkHandler(...)** | ***Default:*** "-"
---@param content? string A colon-separated chain of data strings carried by the hyperlink to be provided to the handler function (Example: "content1:content2:content3") | ***Default:*** ""
---@param text string Clickable text to be displayed as the hyperlink
function wt.CustomHyperlink(addon, type, content, text) end

---Register a function to handle custom hyperlink clicks
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)<ul><li>***Note:*** Duplicate addon key that already had rules registered under will be overwritten.</li></ul>
---@param linkType? string Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** "-"
---@param handler fun(...) Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via ***WidgetToolbox*.CustomHyperlink(...)**
function wt.SetHyperlinkHandler(addon, linkType, handler) end


--[[ WIDGET MANAGEMENT ]]

---Check if a variable is a recognizable WidgetTools custom table
---@param t any
---***
---@return boolean|AnyTypeName # Return the type name of the object if recognized, false if not
---<p></p>
function wt.IsWidget(t)

	--| Returns

	---@alias AnyTypeName
	---| WidgetTypeName
	---| MutatedWidgetTypeName
	---| SettingsPageTypeName
	---| OptionsTemplateTypeName
	---| "SettingsCategory"

		---@alias WidgetTypeName
		---| "Action"
		---| "Toggle"
		---| "Selector"
		---| "SpecialSelector"
		---| "Multiselector"
		---| "Textbox"
		---| "Numeric"
		---| "Colormanager"
		---| "Profilemanager"

		---@alias MutatedWidgetTypeName
		---| "Button"
		---| "CustomButton"
		---| "Radiobutton"
		---| "Checkbox"
		---| "Radiogroup"
		---| "DropdownRadiogroup"
		---| "SpecialRadiogroup"
		---| "Checkgroup"
		---| "Editbox"
		---| "MultilineEditbox"
		---| "Slider"
		---| "ClassicSlider"
		---| "Colorpicker"

		---@alias SettingsPageTypeName
		---| "SettingsPage"
		---| "ProfilesPage"

		---@alias OptionsTemplateTypeName
		---| "PositionOptions"
		---| "FontOptions"

	return false
end


--[[ FRAME MANAGEMENT ]]

--[ Position ]

---Set the position and anchoring of a frame when it is unknown which parameters will be nil
---***
---@param frame AnyFrameObject Reference to the frame to be moved
---@param position? positionData Table of parameters to call **frame**:[SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
---@param unlink? boolean If true, unlink the position of **frame** from **position.relativeTo** (preventing anchor family connections) by moving a positioning aid frame to **position** first, convert its position to absolute, breaking relative links (making it relative to screen points instead), then move **frame** to the position of the aid | ***Default:*** false
---@param userPlaced? boolean Remember the position if **frame**:[IsMovable()](https://warcraft.wiki.gg/wiki/API_Frame_IsMovable) | ***Default:*** true
function wt.SetPosition(frame, position, unlink, userPlaced) end

---Set the anchor of a frame while keeping its positioning by updating its relative offsets
---***
---@param frame AnyFrameObject Reference to the frame to be update
---@param anchor FramePoint New anchor point to set
---***
---@return number? offsetX The new horizontal offset value | ***Default:*** nil
---@return number? offsetY The new vertical offset value | ***Default:*** nil
---<p></p>
function wt.SetAnchor(frame, anchor) end

---Convert the position of a frame positioned relative to another to absolute position (making it relative to screen points, the UIParent instead)
---***
---@param frame AnyFrameObject Reference to the frame the position of which to be converted to absolute position
---@param keepAnchor? boolean If true, restore the original anchor of **frame** (as its closest anchor to the nearest screen point will be chosen after conversion) | ***Default:*** true
function wt.ConvertToAbsolutePosition(frame, keepAnchor) end

--| Arrangement

---Set the arrangement ordering description of a child frame by which to automatically position it in a columns within rows arrangement in its parent container via ***WidgetToolbox*.ArrangeContent(...)**
---@param frame AnyFrameObject Reference to the child frame to set the arrangement ordering description for
---@param index integer|nil If set, use this ordering index for **frame** by which to schedule placing it during arrangement (instead of relying on its child index), or if nil, delete the ordering directive set for **frame**
---@param wrap boolean|nil If true, place **frame** into a new row within its container instead of adding it to the current row being filled, or if nil, delete the wrapping directive set for **frame**<ul><li>***Note:*** If the item would not fit in the row with other items in there, it will automatically be placed in a new row.</li></ul>
---@param skip boolean|nil If true, ignore all other directives and don't include **frame** in the arrangement when positioning the children of the parent frame, or if nil, delete the skipping directive set for **frame**
function wt.SetArrangementDirective(frame, index, wrap, skip) end

---Arrange the child frames of a container frame into stacked rows based on the parameters provided
--- - ***Note:*** The frames will be arranged into columns based on the the number of child frames assigned to a given row, anchored to "TOPLEFT", "TOP" and "TOPRIGHT" in order (by default) up to 3 frames. Columns in rows with more frames will be attempted to be spaced out evenly between the frames placed at the main 3 anchors.
---***
---@param container Frame Reference to the parent container frame the child frames of which are to be arranged based on their arrangement descriptions
---@param t? arrangementRules Arrange the child frames of **container** based on the specifications provided in this table
function wt.ArrangeContent(container, t) end

--| Movability

---Set the movability of a frame based in the specified values
---***
---@param frame AnyFrameObject Reference to the frame to make movable/unmovable
---@param movable? boolean Whether to make the frame movable or unmovable | ***Default:*** false
---@param t? movabilityData When specified, set **frame** as movable, dynamically updating the position settings widgets when it's moved by the user
function wt.SetMovability(frame, movable, t)

	--| Parameters

	---@class movabilityData # t
	---@field modifier? ModifierKey|any The specific (or any) modifier key required to be pressed down to move **t.frame** (if **t.frame** has the "OnUpdate" script defined) | ***Default:*** nil *(no modifier)*<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://warcraft.wiki.gg/wiki/API_IsModifierKeyDown) is used.</li></ul>
	---@field triggers? Frame[] List of frames that should handle inputs to initiate or stop the movement when interacted with | ***Default:*** **t.frame**
	---@field events? movementEvents Table containing functions to call when certain movement events occur
	---@field cursor? boolean If true, change the cursor to a movement cross when mousing over **t.frame** and **t.modifier** is pressed down if set | ***Default:*** **t.modifier** ~= nil

		---@class movementEvents
		---@field onStart? function Function to call when **frame** starts moving
		---@field onMove? function Function to call every with frame update while **frame** is moving (if **frame** has the "OnUpdate" script defined)
		---@field onStop? function Function to call when the movement of **frame** is stopped and the it was moved successfully
		---@field onCancel? function Function to call when the movement of **frame** is cancelled (because the modifier key was released early as an example)
end

--[ Visibility ]

---Set the visibility of a frame based on the value provided
---***
---@param frame AnyFrameObject Reference to the frame to hide or show
---@param visible? boolean If false, hide the frame, show it if true | ***Default:*** false
function wt.SetVisibility(frame, visible) end

--[ Backdrop ]

---Set the backdrop of a frame with BackdropTemplate with the specified parameters
---***
---@param frame backdropFrame|BackdropTemplate|AnyFrameObject Reference to the frame to set the backdrop of<ul><li>***Note:*** The template of **frame** must have been set as: `BackdropTemplateMixin and "BackdropTemplate"`.</li></ul>
---@param backdrop? backdropData Parameters to set the custom backdrop with | ***Default:*** nil *(remove the backdrop)*
---@param updates? backdropUpdateRule[] Table of backdrop update rules, modifying the specified parameters on trigger<ul><li>***Note:*** All update rules are additive, calling ***WidgetToolbox*.SetBackdrop(...)** multiple times with **updates** specified *will not* override previously set update rules. The base **backdrop** values used for these old rules *will not* change by setting a new backdrop via ***WidgetToolbox*.SetBackdrop(...)** either!</li></ul>
function wt.SetBackdrop(frame, backdrop, updates)

	--| Parameters

	---@class backdropFrame # frame
	---@field backdropInfo backdropInfo

	---@class backdropData # backdrop
	---@field background? backdropBackgroundData Table containing the parameters used for the background
	---@field border? backdropBorderData Table containing the parameters used for the border

		---@class backdropBackgroundData
		---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture
		---@field color? color Apply the specified color to the background texture

		---@class backdropBorderData
		---@field texture? backdropBorderTextureData Parameters used for setting the border texture
		---@field color? color Apply the specified color to the border texture

	---@class backdropUpdateRule # updates
	---@field triggers? AnyFrameObject[] References to the frames to add the listener script to | ***Default:*** { **frame** }
	---@field rules table<AnyScriptType, string|fun(frame: AnyFrameObject, self: AnyFrameObject, ...: any): backdropUpdate: backdropUpdateData|nil, fill: boolean|nil> List of events and update actions returning backdrop values to update the backdrop with, or, if they are set but not valid functions to call, restore the base **backdrop** unconditionally on event trigger<ul><li>***Note:*** Return an empty table `{}` for **backdropUpdate** and true for **fill** in order to restore the base **backdrop** after evaluation.</li><li>***Note:*** Return an empty table `{}` for **backdropUpdate** and false or nil for **fill** to do nothing (keep the current backdrop).</li></ul><hr><p>@*param* `frame` AnyFrameObject ― Reference to backdrop frame</p><p>@*param* `self` AnyFrameObject ― Reference to the specific trigger frame</p><p>@*param* `...` any ― Any leftover arguments will be passed from the handler script to **updates[*key*].rule**</p><hr><p>@*return* `backdropUpdate`? backdropUpdateData|nil ― Parameters to update the backdrop with | ***Default:*** nil *(remove the backdrop)*</p><p>@*return* `fill`? boolean|nil ― If true, fill the specified defaults for the unset values in **backdropUpdates** with the values provided in **backdrop** at matching keys, if false, fill them with their corresponding values from the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure), **frame**:[GetBackdropColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods) and **frame**:[GetBackdropBorderColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods) | ***Default:*** `false`</p>

		---@alias AnyScriptType
		---| "OnLoad"
		---| "OnShow"
		---| "OnHide"
		---| "OnEnter"
		---| "OnLeave"
		---| "OnMouseDown"
		---| "OnMouseUp"
		---| "OnMouseWheel"
		---| "OnAttributeChanged"
		---| "OnSizeChanged"
		---| "OnEvent"
		---| "OnUpdate"
		---| "OnDragStart"
		---| "OnDragStop"
		---| "OnReceiveDrag"
		---| "PreClick"
		---| "OnClick"
		---| "PostClick"
		---| "OnDoubleClick"
		---| "OnValueChanged"
		---| "OnMinMaxChanged"
		---| "OnUpdateModel"
		---| "OnModelCleared"
		---| "OnModelLoaded"
		---| "OnAnimStarted"
		---| "OnAnimFinished"
		---| "OnEnterPressed"
		---| "OnEscapePressed"
		---| "OnSpacePressed"
		---| "OnTabPressed"
		---| "OnTextChanged"
		---| "OnTextSet"
		---| "OnCursorChanged"
		---| "OnInputLanguageChanged"
		---| "OnEditFocusGained"
		---| "OnEditFocusLost"
		---| "OnHorizontalScroll"
		---| "OnVerticalScroll"
		---| "OnScrollRangeChanged"
		---| "OnCharComposition"
		---| "OnChar"
		---| "OnKeyDown"
		---| "OnKeyUp"
		---| "OnGamePadButtonDown"
		---| "OnGamePadButtonUp"
		---| "OnGamePadStick"
		---| "OnColorSelect"
		---| "OnHyperlinkEnter"
		---| "OnHyperlinkLeave"
		---| "OnHyperlinkClick"
		---| "OnMessageScrollChanged"
		---| "OnMovieFinished"
		---| "OnMovieShowSubtitle"
		---| "OnMovieHideSubtitle"
		---| "OnTooltipSetDefaultAnchor"
		---| "OnTooltipCleared"
		---| "OnTooltipAddMoney"
		---| "OnTooltipSetUnit"
		---| "OnTooltipSetItem"
		---| "OnTooltipSetSpell"
		---| "OnTooltipSetQuest"
		---| "OnTooltipSetAchievement"
		---| "OnTooltipSetFramestack"
		---| "OnTooltipSetEquipmentSet"
		---| "OnEnable"
		---| "OnDisable"
		---| "OnArrowPressed"
		---| "OnExternalLink"
		---| "OnButtonUpdate"
		---| "OnError"
		---| "OnDressModel"
		---| "OnCooldownDone"
		---| "OnPanFinished"
		---| "OnUiMapChanged"
		---| "OnRequestNewSize"

		---@class backdropUpdateData
		---@field background? backdropUpdateBackgroundData Table containing the parameters used for the background | ***Default:*** **backdrop.background** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*
		---@field border? backdropUpdateBorderData Table containing the parameters used for the border | ***Default:*** **backdrop** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropBorderColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

			---@class backdropUpdateBackgroundData
			---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture | ***Default:*** **backdrop.background.texture** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure))*
			---@field color? color Apply the specified color to the background texture | ***Default:*** **backdrop.background.color** if **fill** == true *(if it's false, keep the currently set values of **frame**:[GetBackdropColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

				---@class backdropBackgroundTextureData : pathData_ChatFrameDefault
				---@field size number Size of a single background tile square
				---@field tile? boolean Whether to repeat the texture to fill the entire size of the frame | ***Default:*** `true`
				---@field insets? insetData Offset the position of the background texture from the edges of the frame inward

					---@class insetData
					---@field l? number Left side | ***Default:*** 0
					---@field r? number Right side | ***Default:*** 0
					---@field t? number Top | ***Default:*** 0
					---@field b? number Bottom | ***Default:*** 0

			---@class backdropUpdateBorderData
			---@field texture? backdropBorderTextureData Parameters used for setting the border texture | ***Default:*** **backdrop.border.texture** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure))*
			---@field color? color Apply the specified color to the border texture | ***Default:*** **backdrop.border.color** if **fill** == true *(if it's false, keep the currently set values of **frame**:[GetBackdropBorderColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

				---@class backdropBorderTextureData
				---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/Tooltips/UI-Tooltip-Border"<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
				---@field width number Width of the backdrop edge
end

--[ Dependencies ]

---Assign dependency rule listeners from a defined a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to add
---@param setState fun(state: boolean) Function to call to set the state of the frame, enabling it on a true, or disabling it on a false input
function wt.AddDependencies(rules, setState) end

---Check and evaluate all dependencies in a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to check
---@return boolean? state
function wt.CheckDependencies(rules) end


--[[ TOOLTIP MANAGEMENT ]]

---@alias AnyTooltipData
---| tooltipData
---| widgetTooltipTextData
---| itemTooltipTextData
---| presetTooltipTextData
---| addonCompartmentTooltipData

---Register tooltip data and set up a GameTooltip for a frame to be toggled on hover
---***
---@param frame AnyFrameObject Owner frame the tooltip to be registered for<ul><li>***Note:*** If tooltip data for **owner** has already been added to the registry, it will be fully overwritten with **t**.</li><ul><li>***Note:*** Duplicate triggers may still be added if **duplicate** is set to true.</li></ul></li></ul>
---@param t? tooltipData The tooltip parameters are to be provided in this table
---@param toggle? tooltipToggleData Additional toggle rule parameters are to be provided in this table
---@param duplicate? boolean If true, execute even if tooltip data has already been registered for **owner**, potentially adding duplicate toggle triggers, or, automatically call ***WidgetToolbox*.UpdateTooltipData(...)** instead to avoid this | ***Default:*** false
---***
---@return tooltipData|nil # Reference to the tooltip data table registered for **owner** to display the tooltip info by | ***Default:*** nil
function wt.AddTooltip(frame, t, toggle, duplicate)

	--| Parameters

	---@class tooltipData : tooltipFrameData, tooltipTextData # t
	---@field anchor? TooltipAnchor ***Default:*** "ANCHOR_CURSOR"
	---@field offset? offsetData Values to offset the position of ***tooltipData*.tooltip** by
	---@field position? positionData_base|positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** "TOPLEFT" if ***tooltipData*.anchor** == "ANCHOR_NONE"<ul><li>***Note:*** **t.offset** will be used when calling [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) as well.</li></ul>
	---@field flipColors? boolean Flip the default color values of the title and the text lines | ***Default:*** `false`

		---@class tooltipFrameData
		---@field tooltip? GameTooltip Reference to the tooltip frame to set up | ***Default:*** *default WidgetTools custom tooltip*

		---@class tooltipTextData
		---@field title? string String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR) | ***Default:*** **owner:GetName()** or **tostring(owner)**
		---@field lines? tooltipLineData[] Table containing the lists of parameters for the text lines after the title

			---@class tooltipLineData
			---@field text string Text to be displayed in the line
			---@field font? string|FontObject The [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to set for this line | ***Default:*** GameTooltipTextSmall
			---@field color? rgbData_base Table containing the RGB values to color this line with (overriding **font**)
			---@field wrap? boolean Allow the text in this line to be wrapped | ***Default:*** `true`

	---@class tooltipToggleData # toggle
	---@field triggers? Frame[] List of references to additional frames to add hover events to to toggle ***tooltipData*.tooltip** for **owner** besides **owner** itself
	---@field checkParent? boolean Whether to check if **owner** is being hovered before hiding ***tooltipData*.tooltip** when triggers stop being hovered | ***Default:*** `true`
	---@field replace? boolean If false, while ***tooltipData*.tooltip** is already visible for a different owner, don't change it | ***Default:*** `true`<ul><li>***Note:*** If ***tooltipData*.tooltip** is already shown for **owner**, ***WidgetToolbox*.UpdateTooltip(...)** will be called anyway.</li></ul>
end

---Update and show a GameTooltip already set up to be toggled for a frame
---***
---@param frame AnyFrameObject Owner frame the tooltip to be updated for<ul><li>***Note:*** If no entry has been registered for **owner** in the tooltip data registry via ***WidgetToolbox*.AddTooltip(...)** yet, no tooltip will be shown.</li></ul>
---@param t? tooltipUpdateData|tooltipData Use this set of parameters to update the tooltip for **owner** with | ***Default:*** *(fill values from the data in the registry)*
function wt.UpdateTooltip(frame, t)

	--| Parameters

	---@class tooltipUpdateData # t
	---@field title? string String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR) | ***Default:*** **owner.tooltipData.title**
	---@field lines? tooltipLineData[] Table containing the lists of parameters for the text lines after the title | ***Default:*** **owner.tooltipData.lines**
	---@field tooltip? GameTooltip Reference to the tooltip frame to set up | ***Default:*** **owner.tooltipData.tooltip**
	---@field offset? offsetData Values to offset the position of ***tooltipData*.tooltip** by | ***Default:*** **owner.tooltipData.offset**
	---@field position? positionData_base|positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** **owner.tooltipData.position**
	---@field flipColors? boolean Flip the default color values of the title and the text lines | ***Default:*** **owner.tooltipData.flipColors**
	---@field anchor? TooltipAnchor [GameTooltip anchor](https://warcraft.wiki.gg/wiki/API_GameTooltip_SetOwner) | ***Default:*** **owner.tooltipData.anchor**
 end

---Verify and update the tooltip data values stored in the registry for a frame
---***
---@param frame AnyFrameObject Owner frame the tooltip data to be updated for<ul><li>***Note:*** If no entry has been registered for **owner** in the tooltip data registry via ***WidgetToolbox*.AddTooltip(...)** yet, no data will be changed.</li></ul>
---@param t? tooltipUpdateData|tooltipData The parameters to update the tooltip with are to be provided in this table | ***Default:*** *(fill values from the data in the registry or use default values for required values missing from the registry)*
---@param linesUpdate boolean|nil If true, replace the full set of lines in the registry with **t.lines**, or if explicitly false, append the lines to the current list of lines, or if nil or something else, adjust the values of existing lines at matching indexes instead without adding or removing lines | ***Default:*** `nil`
---***
---@return tooltipData|nil # Reference to the tooltip data table registered for **owner** to display the tooltip info by | ***Default:*** `nil`
function wt.UpdateTooltipData(frame, t, linesUpdate) end

---Add default value and utility menu hint tooltip lines to widget tooltip tables
---***
---@param frames AnyFrameObject[] List of reference to the frames to add the tooltip lines to<ul><li>***Note:*** If no entry has been registered for a frame in the list in the tooltip data registry via ***WidgetToolbox*.AddTooltip(...)** yet, no changes will be made for that frame.</li></ul>
---@param default? string Default value, formatted | ***Default:*** *(don't show default value)*
---@param utilityNote? boolean Is true, add a note for the utility context menu | ***Default:*** true
function wt.AddWidgetTooltipLines(frames, default, utilityNote) end


--[[ POPUP MANAGEMENT ]]

---Register the data for a Blizzard popup dialog for use
---***
---@param key? string Unique string to be used as the identifier key in the global `StaticPopupDialogs` table | ***Default:*** *table id of `t` or a random ID string*<ul><li>***Note:*** the default value will be appended to `key` even if its set and a valid string if that key already exist in the global `StaticPopupDialogs` table.
---@param t? popupDialogData Optional parameters
---***
---@return string key The unique identifier key the popup data was created under in the global `StaticPopupDialogs` table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
function wt.RegisterPopupDialog(key, t)

	--| Parameters

	---@class popupDialogData # t
	---@field text? string The text to display as the message in the popup window
	---@field accept? string The text to display on the label of the accept button | ***Default:*** ***WidgetToolbox*.strings.misc.accept**
	---@field cancel? string The text to display on the label of the cancel button | ***Default:*** ***WidgetToolbox*.strings.misc.cancel**
	---@field alt? string The text to display on the label of the third alternative button
	---@field onAccept? function Called when the accept button is pressed and an OnAccept event happens
	---@field onCancel? function Called when the cancel button is pressed, the popup is overwritten (by another popup for instance) or the popup expires and an OnCancel event happens
	---@field onAlt? function Called when the alternative button is pressed and an OnAlt event happens

	return ""
end

---Update already existing popup dialog data
---***
---@param key string The unique identifier key representing the defaults warning popup dialog in the global `StaticPopupDialogs` table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
---@param t? popupDialogData Optional parameters
---***
---@return string? key The unique identifier key created for this popup in the global `StaticPopupDialogs` table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide) | ***Default:*** nil
function wt.UpdatePopupDialog(key, t) end


--[[ ADDON COMPARTMENT ]]

---Set up the [Addon Compartment](https://warcraft.wiki.gg/wiki/Addon_compartment#Automatic_registration) functionality by registering global functions for call
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param calls? addonCompartmentFunctions Functions to call wrapped in a table<ul><li>***Note:*** `AddonCompartmentFunc`, `AddonCompartmentFuncOnEnter` and/or `AddonCompartmentFuncOnLeave` must be set in the specified **addon**'s TOC file to enable this functionality, defining the names of the global functions to be set for call.</li></ul>
---@param tooltip? addonCompartmentTooltipData|tooltipData List of text lines to be added to the tooltip of the addon compartment button displayed when mousing over it<ul><li>***Note:*** Both `AddonCompartmentFuncOnEnter` and `AddonCompartmentFuncOnLeave` must be set in the specified **addon**'s TOC file to enable this functionality, defining the names of the global functions to be overloaded.</li></ul>
function wt.SetUpAddonCompartment(addon, calls, tooltip)

	--| Parameters

	---@class addonCompartmentFunctions # calls
	---@field onClick? fun(addon: string, button: string, frame: Button) Called when the **addon**'s compartment button is clicked<ul><li>***Note:*** `AddonCompartmentFunc`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>
	---@field onEnter? fun(addon: string, frame: Button|Frame) Called when the **addon**'s compartment button is being hovered before the tooltip (if set) is shown<ul><li>***Note:*** `AddonCompartmentFuncOnEnter`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>
	---@field onLeave? fun(addon: string, frame: Button|Frame) Called when the **addon**'s compartment button is stopped being hovered before the tooltip (if set) is hidden<ul><li>***Note:*** `AddonCompartmentFuncOnLeave`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>

	---@class addonCompartmentTooltipData : tooltipFrameData, tooltipTextData # tooltip
	---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** [GetAddOnMetadata(**addon**, "title")](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata)
end


--[[ CHAT CONTROL ]]

---Register a list of chat keywords and related commands for use
---***
---@param addon string The name of the addon's folder (the addon namespace not the display title)
---@param keywords string[] List of addon-specific keywords to register to listen to when typed as slash commands<ul><li>***Note:*** A slash character (`/`) will appended before each keyword specified here during registration, it doesn't need to be included.</li></ul>
---@param t chatCommandManagerCreationData Optional parameters
---***
---@return chatCommandManager? manager Table containing command handler functions | ***Default:*** nil
function wt.RegisterChatCommands(addon, keywords, t)

	--| Parameters

	---@class chatCommandManagerCreationData # t
	---@field commands? chatCommandData[] Indexed table with the list of commands to register under the specified **keywords**
	---@field colors? chatCommandColors Color palette used when printing out default-formatted chat messages
	---@field defaultHandler? fun(commandManager: chatCommandManager, command: string, ...: string) Default handler function to call when an unrecognized command is typed, executed before a help command is triggered, listing all registered commands<hr><p>@*param* `commandManager` commandManager ― Reference to the command manager</p><p>@*param* `command` string ― The unrecognized command typed after the keyword (separated by a space character)</p><p>@*param* `...` string Payload of the command typed, any words following the command name separated by spaces (split, returned unpacked)</p>
	---@field onWelcome? function Called when the welcome message with keyword hints is printed out

		---@class chatCommandData
		---@field command string Name of the slash command word (no spaces) to recognize after the keyword (separated by a space character)
		---@field description? string|fun(): string Note to append to the first specified keyword and **command** in this command's line in the list printed out via the help command(s)
		---@field handler? fun(manager: chatCommandManager, ...: string): result: boolean|nil, ...: any Function to be called when the specific command was recognized after being typed into chat<hr><p>@*param* `...` string ― Payload of the command typed, any words following the command name separated by spaces split and returned one by one</p><hr><p>@*return* `result`? boolean|nil ― Call **[*value*].onSuccess** if true or **[*value*].onError** if false (not nil) after the operation | ***Default:*** nil *(no response)*</p><p>@*return* `...` any ― Leftover arguments to be passed over to response handler scripts</p>
		---@field success? string|fun(...: any): string Response message (or a function returning the message string) to print out on success after **commands[*value*].handler** returns with true<p>@*param* `...` any ― Leftover arguments passed over by the handler script</p>
		---@field error? string|fun(...: any): string Response message (or a function returning the message string) to print out on error after **commands[*value*].handler** returns with false (not nil)<hr><p>@*param* `...` any ― Any leftover arguments passed over by the handler script</p>
		---@field onSuccess? fun(manager: chatCommandManager, ...: any) Function to call after **commands[*value*].handler** returns with true to handle a successful result (after **success** is printed)<hr><p>@*param* `manager` chatCommandManager ― Reference to this chat command manager</p><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
		---@field onError? fun(manager: chatCommandManager, ...: any) Function to call after **commands[*value*].handler** returns with false (not nil) to handle a failed result (after **error** is printed)<hr><p>@*param* `manager` chatCommandManager ― Reference to this chat command manager</p><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
		---@field hidden? boolean Skip printing this command when listing out chat commands on help | ***Default:*** `false`<ul><li>***Note:*** If **onHelp** is specified, it will still be called even if the command is hidden.</li></ul>
		---@field help? boolean If true, call **chatCommandManager.help()** on trigger | ***Default:*** `false`
		---@field onHelp? function Function to call after a specified help command has been triggered or an invalid command is typed with the specified keywords

		---@class chatCommandColors
		---@field title? color Color for the addon title used for branding chat messages | ***Default:*** `YELLOW_FONT_COLOR`
		---@field content? color Color for chat message contents appended after the title (used for success & error responses) | ***Default:*** `WHITE_FONT_COLOR`
		---@field command? color Used to color the registered chat commands when they are being listed | ***Default:*** `LIGHTBLUE_FONT_COLOR`
		---@field description? color Used to color the description of registered chat commands when they are being listed | ***Default:*** `LIGHTGRAY_FONT_COLOR`

	--| Returns

	---@class chatCommandManager
	local _ = {}

		---Print out a formatted chat message
		---@param message string Message content
		---@param title? string Title to start the message with | ***Default:*** *(**addon** title)*<ul><li>***Note:*** If "IconTexture" is specified in the TOC file of **addon**, a logo will also be included at the start of the message.</li></ul>
		---@param contentColor? chatCommandColorNames|color ***Default:*** "content"
		---@param titleColor? chatCommandColorNames|color ***Default:*** "title"
		function _.print(message, title, titleColor, contentColor) end

			---@alias chatCommandColorNames
			---| "title"
			---| "content"
			---| "command"
			---| "description"

		--Print a welcome message with a hint about chat keywords
		function _.welcome() end

		--Trigger a help command, listing all registered chat commands with their specified descriptions, calling their onHelp handlers
		function _.help() end

		---Find and a specific command by its name and call its handler script
		---***
		---@param command string Name of the slash command word (no spaces)
		---@param ... any Any further arguments are used as the payload of the command, passed over to its handler
		---***
		---@return boolean # Whether the command was found and the handler called successfully
		function _.handleCommand(command, ...) return false end
end


--[[ SETTINGS MANAGEMENT ]]

---Settings data management rule registry
---@class settingsRegistry
---@field rules table<string, settingsRule[]> Collection of rules describing where to save/load settings data to/from, and what change handlers to call in the process linked to each specific settings category under an addon
---@field changeHandlers table<string, function> List of pairs of addon-specific unique keys and change handler scripts

	---@class settingsRule
	---@field widget AnyWidgetType|AnyGUIWidgetType Reference to the widget to be saved & loaded data to/from with defined **loadData** and **saveData** functions
	---@field onChange? string[] List of keys referencing functions to be called after the value of **widget** was changed by the user or via settings data management

---Register the settings page to the Settings window if it wasn't already
--- - ***Note:*** No settings page will be registered if **WidgetToolsDB.lite** is true.
---@param page settingsPage Reference to the settings page to register to Settings
---@param parent? settingsPage Reference to the parent settings page to set **page** as a child category page of | ***Default:*** *set as a parent category page*
---@param icon? boolean If true, append the icon set for the settings page to its button title in the AddOns list of the Settings window as well | ***Default:*** true if **parent** == nil
function wt.RegisterSettingsPage(page, parent, icon) end

--| Settings data

---Register a settings data management entry for a settings widget to the settings data management registry for batched data handling
---***
---@param widget AnyWidgetType|AnyGUIWidgetType Reference to the widget to be saved & loaded data to/from with defined **widget.loadData()** & **widget.saveData()** functions
---@param t settingsData Optional parameters
---***
---@return integer|nil index The index for the new entry for **widget** where it ended up in the settings data management registry | ***Default:*** nil
function wt.AddSettingsDataManagementEntry(widget, t)

	--| Parameters

		---@alias AnyWidgetType # widget
		---| action
		---| toggle
		---| selector
		---| specialSelector
		---| multiselector
		---| textbox
		---| numeric
		---| colormanager
		---| profilemanager

		---@alias AnyGUIWidgetType # widget
		---| checkbox
		---| radiobutton
		---| radiogroup
		---| dropdownRadiogroup
		---| specialRadiogroup
		---| checkgroup
		---| customEditbox
		---| customEditbox
		---| multilineEditbox
		---| customSlider
		---| colorpicker

end

---Load all data from storage to the widgets specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].loadData(...)** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** false
function wt.LoadSettingsData(category, key, handleChanges) end

---Save all data from the widgets to storage specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].saveData(...)** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.SaveSettingsData(category, key) end

---Call all **onChange** handlers registered in the settings data management registry in the specified **category** under the specified **key**
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.ApplySettingsData(category, key) end

---Set a data snapshot for each widget specified in the settings data management registry in the specified **category** under the specified **key** calling **[*widget*].revertData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.SnapshotSettingsData(category, key) end

---Set & load the stored data managed by each widget specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].revertData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.RevertSettingsData(category, key) end

---Set & load the default data managed by each widget specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].resetData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.ResetSettingsData(category, key) end

---Handle changes for widgets in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].onChange()** for each
---@param index integer Filter the call of change handlers to only include the list under the specified index not each list in the specified **category** under the specified **key**
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
function wt.HandleWidgetChanges(index, category, key) end


--[[ TOOLTIP ]]

---Create and set up a new custom GameTooltip frame
---***
---@param name string Unique string piece to place in the name of the the tooltip to distinguish it from other tooltips (use the addon namespace string as an example)
---@return GameTooltip tooltip
function wt.CreateGameTooltip(name) return {} end


--[[ POPUP ]]

--| Input Box

---Show a movable input window with a textbox, accept and cancel buttons
---***
---@param t? popupInputBoxData Optional parameters
function wt.CreatePopupInputBox(t)

	--| Parameters

	---@class popupInputBoxData : positionableObject, tooltipDescribableWidget # t
	---@field title? string Text to be displayed as the title | ***Default:*** *(no title)*
	---@field text? string Text to set as the starting text inside the input editbox | ***Default:*** ""
	---@field accept? fun(text: string) Function to call when the inputted text is accepted
	---@field cancel? function Function to call when the inputted text is dismissed

		---@class tooltipDescribableWidget
		---@field tooltip? widgetTooltipTextData List of text lines to be added to the tooltip of the widget displayed when mousing over the frame
end

--| Reload Notice

---Show a movable reload notice window on screen with a reload now and cancel button
---***
---@param t? reloadNoticeData Optional parameters
---***
---@return Frame reload Reference to the reload notice panel frame
function wt.CreateReloadNotice(t)

	--| Parameters

	---@class reloadNoticeData # t
	---@field title? string Text to be shown as the title of the reload notice | ***Default:*** "Pending Changes" *(when the language is set to English)*
	---@field message? string Text to be shown as the message of the reload notice | ***Default:*** "Reload the interface to apply the pending changes." *(when the language is set to English)*
	---@field position? reloadFramePositionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPRIGHT", -300, -80

		---@class reloadFramePositionData : positionData_base
		---@field anchor? FramePoint ***Default:*** "TOPRIGHT"
		---@field offset? reloadFrameOffsetData

			---@class reloadFrameOffsetData
			---@field x? number Horizontal offset value | ***Default:*** -300
			---@field y? number Vertical offset value | ***Default:*** -80

	return {}
end


--[[ TEXT ]]

--[ Font ]

---Create a new [Font](https://warcraft.wiki.gg/wiki/UIOBJECT_Font) object to be used when setting the look of a [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) using a [FontInstance](https://warcraft.wiki.gg/wiki/UIOBJECT_FontInstance)
---***
---@param name string A unique identifier name to set for the hew font object to be accessed by and referred to later<ul><li>***Note:*** If a font object with that name already exists, it will *not* be overwritten and its reference key will be returned.</li><li>***Example:*** Access the reference to the font object created via the globals table: `local customFont = _G["CustomFontName"]`.</li></ul>
---@param t? fontCreationData Optional parameters
---***
---@return string name, Font font ***Default*** *(on invalid input)****:*** "GameFontNormal", **GameFontNormal**
function wt.CreateFont(name, t)

	--| Parameters

	---@class fontCreationData
	---@field template? FontObject An existing [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to copy as a baseline
	---@field font? fontData Table containing font properties used for [FontInstance:SetFont(...)](https://warcraft.wiki.gg/wiki/API_FontInstance_SetFont) (overriding **t.template**)
	---@field color? colorData_whiteDefault|color Apply the specified color to the font (overriding **t.template**)
	---@field spacing? number Set the character spacing of the text using this font (overriding **t.template**)
	---@field shadow? { offset: offsetData, color: colorData_blackDefault|color } Set a text shadow with the following parameters (overriding **t.template**)
	---@field justify? justifyData_centered Set the justification of the text using font (overriding **t.template**)
	---@field wrap? boolean Whether or not to allow the text lines using this font to wrap (overriding **t.template**)

		---@class fontData
		---@field path string Path to the font file relative to the WoW client directory<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Fonts/Font.ttf), otherwise use `\\`.</li><li>***Note:*** **File format:** Font files must be in TTF or OTF format.</li></ul>
		---@field size number The default display size of the new font object
		---@field style TBFFlags Comma separated string of font styling flags

		---@class colorData_whiteDefault : colorData
		---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 1
		---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 1
		---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 1

		---@class colorData_blackDefault : colorData
		---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 1
		---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 1
		---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 1

		---@class justifyData_centered : justifyData_left
		---@field h? JustifyHorizontal Horizontal text alignment| ***Default:*** "CENTER"

	return "", {}
end

--[ Textline ]

---Create a text object ([FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString)) with the specified parameters
---***
---@param t? textCreationData Optional parameters
---@return FontString text
function wt.CreateText(t)

	--| Parameters

	---@class textCreationData : positionableObject # t
	---@field parent? AnyFrameObject Reference to parent frame to create and assign the text to | ***Default:*** UIParent
	---@field name? string String appended to the name of **t.parent** used to set the name of the new [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** "Text"
	---@field width? number
	---@field height? number
	---@field layer? DrawLayer
	---@field text? string Text to be shown
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used | ***Default:*** "GameFontNormal"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
	---@field color? color Apply the specified color to the text (overriding **t.font**)
	---@field justify? justifyData Set the justification of the text (overriding **t.font**)
	---@field wrap? boolean Whether or not to allow the text lines to wrap (overriding **t.font**) | ***Default:*** `true`

		---@class justifyData
		---@field h? JustifyHorizontal Horizontal text alignment
		---@field v? JustifyVertical Vertical text alignment

	return {}
end

---Add a title to a frame
---***
---@param frame AnyFrameObject Reference to the frame to add the title textline to
---@param t? titleCreationData Optional parameters
---***
---@return FontString? # ***Default:*** nil
function wt.CreateTitle(frame, t)

	--| Parameters

	---@class titleCreationData # t
	---@field anchor? FramePoint ***Default:*** "TOPLEFT"
	---@field offset? offsetData The offset from the anchor point relative to the specified frame
	---@field width? number ***Default:*** *width of the text*
	---@field text? string Text to be shown as the main title of the frame
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontHighlight"
	---@field color? color Apply the specified color to the title (overriding **t.font**)
	---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding **t.font**) | ***Default:*** "LEFT"
end

---Add a description to a titled frame
---***
---@param title FontString Reference to the already existing title textline to place the description next to
---@param t? descriptionCreationData Table of parameters to create a description
---***
---@return FontString? # ***Default:*** nil
function wt.CreateDescription(title, t)

	--| Parameters

	---@class descriptionCreationData # t
	---@field offset? offsetData The offset from the default position (right side of the separator to the right of **t.title**)
	---@field width? number ***Default:*** *width of the parent frame of **t.title** - width of **t.title** (& separator, offsets)*
	---@field widthOffset? number Increase the calculated with by this amount | ***Default:*** 0
	---@field spacer? number Space to leave between **t.title** & the separator and the separator & the description | ***Default:*** 5
	---@field text? string Text to be shown as the description of the frame
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontHighlightSmall2"
	---@field color? descriptionColorData|color Apply the specified color to the description (overriding **t.font**)
	---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding **t.font**) | ***Default:*** "LEFT"

		---@class descriptionColorData
		---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** HIGHLIGHT_FONT_COLOR.r
		---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** HIGHLIGHT_FONT_COLOR.g
		---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** HIGHLIGHT_FONT_COLOR.b
		---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 0.55
end


--[[ TEXTURE ]]

---Create a [Texture](https://warcraft.wiki.gg/wiki/UIOBJECT_Texture) image [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
---***
---@param frame AnyFrameObject Reference to the frame to set as the parent of the new texture
---@param t textureCreationData Optional parameters
---@param updates? table<AnyScriptType, textureUpdateRule> Table of key, value pairs containing the list of events to link texture changes to, and what parameters to change
---***
---@return Texture? texture ***Default:*** nil
function wt.CreateTexture(frame, t, updates)

	--| Parameters

	---@class textureCreationData : positionableObject, pathData_ChatFrameDefault # t
	---@field name? string String appended to the name of **t.parent** used to set the name of the new texture | ***Default:*** "Texture"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData ***Default:*** *size of* **parent**
	---@field atlas? string Name of the texture atlas to use instead of creating a texture based on **t.path**<ul><li>***Note:*** Settings this will override whatever **t.path** is set to.</li></ul>
	---@field layer? DrawLayer
	---@field level? integer Sublevel to set within the specified draw layer | ***Range:*** (-8, 7)
	---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** *no tiling*
	---@field wrap? wrapData Set the warp mode for each axis
	---@field filterMode? FilterMode | ***Default:*** "LINEAR"
	---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis
	---@field color? color Apply the specified color to the texture
	---@field edges? edgeCoordinates Edge coordinate offsets
	---@field vertices? vertexCoordinates Vertex coordinate offsets<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, **t.edges** will be used first ignoring **t.vertices**.</li></ul>
	---@field events? table<ScriptType, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the texture object and the functions to assign as event handlers called when they trigger

		---@class pathData_ChatFrameDefault
		---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/ChatFrame/ChatFrameBackground"<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>

		---@class sizeData
		---@field w number Width
		---@field h number Height

		---@class tileData
		---@field h? boolean Horizontal | ***Default:*** `false`
		---@field v? boolean Vertical | ***Default:*** `false`

		---@class wrapData
		---@field h? WrapMode|boolean Horizontal | ***Value:*** true = "REPEAT" | ***Default:*** "CLAMP"
		---@field v? WrapMode|boolean Vertical | ***Value:*** true = "REPEAT" | ***Default:*** "CLAMP"

		---@class axisData
		---@field h? boolean Horizontal x axis | ***Default:*** `false`
		---@field v? boolean Vertical y axis | ***Default:*** `false`

		---@class edgeCoordinates
		---@field l number Left | ***Reference Range:*** (0, 1) | ***Default:*** 0
		---@field r number Right | ***Reference Range:*** (0, 1) | ***Default:*** 1
		---@field t number Top | ***Value:*** *using canvas coordinates (inverted y axis)* | | ***Reference Range:*** (0, 1) | ***Default:*** 0
		---@field b number Bottom | ***Value:*** *using canvas coordinates (inverted y axis)* | | ***Reference Range:*** (0, 1) | ***Default:*** 1

		---@class vertexCoordinates
		---@field topLeft vertexCoordinates_topLeft
		---@field topRight vertexCoordinates_topRight
		---@field bottomLeft vertexCoordinates_bottomLeft
		---@field bottomRight vertexCoordinates_bottomRight

				---@class vertexCoordinates_topLeft
				---@field x number ***Reference Range:*** (0, 1) | ***Default:*** 0
				---@field y number ***Value:*** *using canvas coordinates (inverted y axis)* | ***Reference Range:*** (0, 1) | ***Default:*** 0

				---@class vertexCoordinates_topRight
				---@field x number ***Reference Range:*** (0, 1) | ***Default:*** 1
				---@field y number ***Value:*** *using canvas coordinates (inverted y axis)* | ***Reference Range:*** (0, 1) | ***Default:*** 0

				---@class vertexCoordinates_bottomLeft
				---@field x number ***Reference Range:*** (0, 1) | ***Default:*** 0
				---@field y number ***Value:*** *using canvas coordinates (inverted y axis)* | ***Reference Range:*** (0, 1) | ***Default:*** 1

				---@class vertexCoordinates_bottomRight
				---@field x number ***Reference Range:*** (0, 1) | ***Default:*** 1
				---@field y number ***Value:*** *using canvas coordinates (inverted y axis)* | ***Reference Range:*** (0, 1) | ***Default:*** 1

		---@class attributeEventData
		---@field name string
		---@field handler fun(...: any)

	---@class textureUpdateRule # updates
	---@field frame? AnyFrameObject Reference to the frame to add the listener script to | ***Default:*** **t.parent**
	---@field rule? fun(self: Frame, ...: any): data: textureUpdateData|nil Evaluate the event and specify the texture updates to set, or, if nil, restore the base values unconditionally on event trigger<hr><p>@*param* `self` AnyFrameObject — Reference to **updates[*key*].frame**</p><p>@*param* `...` any — Any leftover arguments will be passed from the handler script to **updates[*key*].rule**</p><hr><p>@*return* `data` textureUpdateData|nil — Parameters to update the texture with | ***Default:*** **t**</p>

		---@class textureUpdateData
		---@field position? positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** **t.position**
		---@field size? sizeData | ***Default:*** **t.size**
		---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** **t.path**<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
		---@field layer? DrawLayer | ***Default:*** **t.layer**
		---@field level? integer Sublevel to set within the specified draw layer | ***Range:*** (-8, 7) | ***Default:*** **t.level**
		---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** **t.tile**
		---@field wrap? wrapData Set the warp mode for each axis | ***Default:*** **t.wrap**
		---@field filterMode? FilterMode | ***Default:*** **t.filterMode**
		---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis | ***Default:*** **t.flip**
		---@field color? color Apply the specified color to the texture | ***Default:*** **t.color**
		---@field edges? edgeCoordinates Edge coordinate offsets ***Default:*** **t.edges**
		---@field vertices? vertexCoordinates Vertex coordinate offsets ***Default:*** **t.vertices**<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, **t.edges** will be used first ignoring **t.vertices**.</li></ul>
end

---Create a [Line](https://warcraft.wiki.gg/wiki/UIOBJECT_Line) [TextureBase](https://warcraft.wiki.gg/wiki/UIOBJECT_TextureBase) object
---***
---@param frame AnyFrameObject Reference to the frame to set as the parent of the new line
---@param t lineCreationData Optional parameters
---***
---@return Line? line ***Default:*** nil
function wt.CreateLine(frame, t)

	--| Parameters

	---@class lineCreationData # t
	---@field name? string String appended to the name of **t.parent** used to set the name of the new line | ***Default:*** "Line"
	---@field startPosition? pointData Parameters to call [Line:SetStartPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetStartPoint) with | ***Default:*** "TOPLEFT"
	---@field endPosition? pointData Parameters to call [Line:SetEndPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetEndPoint) with | ***Default:*** "TOPLEFT"
	---@field thickness? number ***Default:*** 4
	---@field layer? DrawLayer 
	---@field level? integer Sublevel to set within the draw layer specified with **t.layer** | ***Range:*** (-8, 7)
	---@field color? color Apply the specified color to the line

		---@class pointData
		---@field relativeTo AnyFrameObject
		---@field relativePoint FramePoint
		---@field offset? offsetData
end


--[[ CONTAINER FRAME ]]

--[ Base Frame ]

---Create & set up a new base frame
---***
---@param t? frameCreationData Optional parameters
---@return Frame frame
function wt.CreateFrame(t)

	--| Parameters

	---@class frameCreationData : positionableScreenObject, arrangeableObject, visibleObject_base, initializableContainer # t
	---@field parent? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** nil *(parentless frame)*<ul><li>***Note:*** You may use [Region:SetParent(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
	---@field name? string Unique string used to set the name of the new frame | ***Default:*** nil *(anonymous frame)*<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field append? boolean When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** `true` if **t.name** ~= nil and **t.parent** ~= nil and **t.parent** ~= UIParent
	---@field size? sizeData_zeroDefault|sizeData ***Default:*** *no size*<ul><li>***Note:*** Omitting or setting either value to 0 will result in the frame being invisible and not getting placed on the screen.</li></ul>
	---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the **t.onEvent** table.</li></ul>
	---@field onEvent? table<WowEvent, fun(self: Frame, ...: any)> Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame<ul><li>***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.</li><li>***Example:*** "[ADDON_LOADED](https://warcraft.wiki.gg/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.<pre>```function(self, addon)```<br>&#9;```if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch```<br>&#9;```self:UnregisterEvent("ADDON_LOADED")```<br>&#9;```--Do something```<br>```end```</pre></li></ul>

		---@class positionableScreenObject : positionableObject
		---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** `false`

			---@class positionableObject
			---@field position? positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"

				---@class positionData : positionData_base
				---@field offset? offsetData

					---@class positionData_base
					---@field anchor? FramePoint ***Default:*** "TOPLEFT"
					---@field relativeTo? AnyFrameObject|string Frame reference or name, or "nil" to anchor relative to screen dimensions | ***Default:*** "nil"<ul><li>***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).</li><li>***Note:*** Default to "nil" when an invalid frame name is provided.</li></ul>
					---@field relativePoint? FramePoint ***Default:*** **anchor**

					---@class offsetData
					---@field x? number Horizontal offset value | ***Default:*** 0
					---@field y? number Vertical offset value | ***Default:*** 0

		---@class arrangeableObject
		---@field arrange? arrangementDirective When set, automatically position the frame in a columns within rows arrangement in its parent container via ***WidgetToolbox*.ArrangeContent(**t.parent**, ...)**

			---@class arrangementDirective
			---@field wrap? boolean Place the frame into a new row within its container instead of adding it to the current row being filled | ***Default:*** `true`<ul><li>***Note:*** If the item would not fit in the row with other items in there, it will automatically be placed in a new row.</li></ul>
			---@field index? integer The ordering index of the frame by which to be placed during arrangement | ***Default:*** *use the ordering of the children of the parent container frame*

		---@class visibleObject_base
		---@field visible? boolean Whether to make the frame visible during initialization or not | ***Default:*** `true`
		---@field frameStrata? FrameStrata Pin the frame to the specified strata
		---@field frameLevel? integer The ordering level of the frame within its strata to set
		---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** `false`

		---@class initializableContainer
		---@field arrangement? arrangementRules If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
		---@field initialize? fun(container?: Frame, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

			---@class arrangementRules
			---@field margins? spacingData Inset the content inside the container frame by the specified amount on each side
			---@field gaps? number The amount of space to leave between rows and items within rows | ***Default:*** 8
			---@field flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** `false`
			---@field resize? boolean Set the height of the container frame to match the space taken up by the arranged content (including margins) | ***Default:*** `true`

				---@class spacingData
				---@field l? number Space to leave on the left side | ***Default:*** 12
				---@field r? number Space to leave on the right side (doesn't need to be negated) | ***Default:*** 12
				---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** 12
				---@field b? number Space to leave at the bottom | ***Default:*** 12

		---@class sizeData_zeroDefault
		---@field w? number Width | ***Default:*** 0
		---@field h? number Height | ***Default:*** 0

	return {}
end

---Create & set up a new customizable frame with BackdropTemplate
---***
---@param t? frameCreationData Optional parameters
---@return Frame|BackdropTemplate frame
function wt.CreateCustomFrame(t) return {} end

--[ Scrollframe ]

---Create an empty vertically scrollable frame
---***
---@param t? scrollframeCreationData Optional parameters
---@return Frame scrollChild
---@return ScrollFrame scrollframe
function wt.CreateScrollframe(t)

	--| Parameters

	---@class scrollframeCreationData : childObject, positionableObject, initializableContainer, scrollSpeedData # t
	---@field name? string Unique string used to append to the name of **t.parent** when setting the names of the name of the scroll parent and its scrollable child frame | ***Default:*** "Scroller" *(for the scrollable child frame)*<ul><li>***Note:*** Space characters will be removed when used for setting the frame names.</li></ul>
	---@field size? sizeData_parentDefault|sizeData ***Default:*** **t.parent** and *size of the parent frame* or *no size*
	---@field scrollSize? sizeData_scroll|sizeData ***Default:*** *size of the parent frame*

		---@class scrollSpeedData
		---@field scrollSpeed? number Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25

		---@class sizeData_parentDefault
		---@field w? number Width | ***Default:*** *width of the parent frame*
		---@field h? number Height | ***Default:*** *height of the parent frame*

		---@class sizeData_scroll
		---@field w? number Horizontal size of the scrollable child frame | ***Default:*** **t.size.width** - 16
		---@field h? number Vertical size of the scrollable child frame | ***Default:*** 0 *(no height)*

	return {}, {}
end

--[ Panel ]

---Create a new simple panel frame
---***
---@param t? panelCreationData Optional parameters
---***
---@return panel|Frame panel Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame) overloaded with custom fields or none if **WidgetToolsDB.lite** is true**
function wt.CreatePanel(t)

	--| Parameters

	---@class panelCreationData : labeledChildObject, describableObject, positionableScreenObject, arrangeableObject, visibleObject_base, backdropData, liteObject # t
	---@field name? string Unique string used to set the frame name | ***Default:*** "Panel"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_panel|sizeData
	---@field background? backdropBackgroundData_panel Table containing the parameters used for the background
	---@field border? backdropBorderData_panel Table containing the parameters used for the border
	---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the panel and the functions to assign as event handlers called when they trigger
	---@field arrangement? arrangementRules_panel If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
	---@field initialize? fun(container?: panel, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? panel ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

		---@class labeledChildObject : titledChildObject, labeledObject_base

			---@class titledChildObject : namedChildObject, titledObject_base

				---@class namedChildObject : childObject, namedObject_base
				---@field append? boolean Instead of setting the specified name by itself, append it to the name of the specified parent frame | ***Default:*** `true` if t.parent ~= UIParent

					---@class childObject
					---@field parent? AnyFrameObject Reference to the frame to set as the parent

					---@class namedObject_base
					---@field name? string Unique string used to set the frame name | ***Default:*** "Frame"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>

				---@class titledObject_base
				---@field title? string Text to be displayed as the title | ***Default:*** **t.name**

			---@class labeledObject_base
			---@field label? boolean Whether to show the title textline or not | ***Default:*** `true`

		---@class describableObject
		---@field description? string Text to be displayed as the subtitle or description | ***Default:*** *no description textline shown*

		---@class liteObject
		---@field lite? boolean If false, overrule **WidgetToolsDB.lite** and use full GUI functionality | ***Default:*** `true`

		---@class sizeData_panel
		---@field w? number Width | ***Default:*** **t.parent** and *width of the parent frame* - 20 or 0
		---@field h? number Height | ***Default:*** 0<ul><li>***Note:*** If content is added, arranged and **t.arrangeContent.resize** is true, the height will be set dynamically based on the calculated height of the content.</li></ul>

		---@class backdropBackgroundData_panel
		---@field texture? backdropBackgroundTextureData_panel Parameters used for setting the background texture
		---@field color? backgroundColorData_panel Apply the specified color to the background texture

			---@class backdropBackgroundTextureData_panel : backdropBackgroundTextureData
			---@field size? number Size of a single background tile square | ***Default:*** 5
			---@field insets? insetData_panel Offset the position of the background texture from the edges of the frame inward

				---@class insetData_panel
				---@field l? number Left side | ***Default:*** 4
				---@field r? number Right side | ***Default:*** 4
				---@field t? number Top | ***Default:*** 4
				---@field b? number Bottom | ***Default:*** 4

			---@class backgroundColorData_panel
			---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 0.175
			---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 0.175
			---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 0.175
			---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 0.65

		---@class backdropBorderData_panel
		---@field texture? backdropBorderTextureData_panel Parameters used for setting the border texture
		---@field color? borderColorData_panel Apply the specified color to the border texture

			---@class backdropBorderTextureData_panel : backdropBorderTextureData
			---@field width? number Width of the backdrop edge | ***Default:*** 16

			---@class borderColorData_panel
			---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 0.75
			---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 0.75
			---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 0.75
			---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 0.5

		---@class arrangementRules_panel : arrangementRules
		---@field margins? spacingData_panel Inset the content inside the container frame by the specified amount on each side
		---@field gaps? number The amount of space to leave between rows and items within rows | ***Default:*** 8
		---@field flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** `false`
		---@field resize? boolean Set the height of the container frame to match the space taken up by the arranged content (including margins) | ***Default:*** `true`

			---@class spacingData_panel : spacingData
			---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** **t.description** and 30 or 12

	--| Returns

	---@class panel : Frame
	---@field title? FontString Reference to the title textline appearing above the panel
	---@field description? FontString Reference to the description textline appearing in the panel

	return {}
end


--[[ CONTEXT MENU ]]

---Create a Blizzard context menu
---***
---@param t? contextMenuCreationData Optional parameters
---***
---@return contextMenu menu Table containing a reference to the root description of the context menu
function wt.CreateContextMenu(t)

	--| Parameters

	---@class contextMenuCreationData : contextMenuCreationData_base # t
	---@field triggers? contextMenuTriggerData[] List of trigger frames and behavior to link to toggle the context menu | ***Default:*** *(no triggers)*

		---@class contextMenuCreationData_base
		---@field initialize? fun(menu: contextMenu|contextSubmenu) This function will be called while setting up the menu to perform specific tasks like creating menu content items right away<hr><p>@*param* `menu` contextMenu|contextSubmenu ― Reference to the container of menu elements (such as titles, widgets, dividers or other frames) for menu items to be added to during initialization</p>

		---@class contextMenuTriggerData
		---@field frame AnyFrameObject? Reference to the frame to set as a trigger | ***Default:*** UIParent *(opened at cursor position)*
		---@field rightClick? boolean If true, create and open the context menu via a right-click mouse click event on **frame** | ***Default:*** `true`
		---@field leftClick? boolean If true, create and open the context menu via a left-click mouse click event on **frame** | ***Default:*** `false`
		---@field hover? boolean If true, create and open the context menu via a mouse hover event on **frame** | ***Default:*** `false`
		---@field condition? fun(action: "click"|"hover"|nil): boolean Function to call and evaluate before creating and opening the menu: if the returned value is not true, don't open the menu

	--| Returns

	---@class contextMenu
	---@field rootDescription? RootMenuDescriptionProxy Container of menu elements (such as titles, widgets, dividers or other frames)
	local _ = {}

		---Open the context menu
		---***
		---@param trigger? integer Index of the trigger to activate to have the menu opened defined in **t.triggers** | ***Default:*** 1
		---@param action "click"|"hover"|nil The action that prompted the menu to be opened | ***Default:*** *no action:* `nil`
		function _.open(trigger, action) end

	return _
end

---Create a Blizzard context menu attached to a custom button frame to open it
---***
---@param t? popupMenuCreationData Optional parameters
---***
---@return Frame menu Table containing a reference to the root description of the context menu
---@return contextMenu menu Table containing a reference to the root description of the context menu
function wt.CreatePopupMenu(t)

	--| Parameters

	---@class popupMenuCreationData : labeledChildObject, tooltipDescribableWidget, positionableScreenObject, arrangeableObject, visibleObject_base, contextMenuCreationData_base # t
	---@field parent? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** nil *(parentless frame)*<ul><li>***Note:*** You may use [Region:SetParent(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
	---@field name? string Unique string used to set the frame name | ***Default:*** "PopupMenu"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_menuButton|sizeData
	---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the **t.onEvent** table.</li></ul>
	---@field onEvent? table<WowEvent, fun(self: Frame, ...: any)> Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame<ul><li>***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.</li><li>***Example:*** "[ADDON_LOADED](https://warcraft.wiki.gg/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.<pre>```function(self, addon)```<br>&#9;```if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch```<br>&#9;```self:UnregisterEvent("ADDON_LOADED")```<br>&#9;```--Do something```<br>```end```</pre></li></ul>

		---@class sizeData_menuButton
		---@field w? number Width | ***Default:*** 180
		---@field h? number Height | ***Default:*** 26

	return {}, {}
end

--[ Elements ]

---Create a submenu item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new submenu to
---@param t? contextSubmenuCreationData Optional parameters
---***
---@return contextSubmenu|nil menu Table containing a reference to the root description of the context menu
function wt.CreateSubmenu(menu, t)

	--| Parameters

	---@class contextSubmenu # menu
	---@field rootDescription ElementMenuDescriptionProxy Container of menu elements (such as titles, widgets, dividers or other frames)

	---@class contextSubmenuCreationData : contextMenuCreationData_base # t
	---@field title? string Text to be shown on the opener button item representing the submenu within the parent menu | ***Default:*** "Submenu"
end

---Create a textline item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? menuTextlineCreationData Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil textline Reference to the context textline UI object
function wt.CreateMenuTextline(menu, t)

	--| Parameters

	---@class menuTextlineCreationData : queuedMenuItem # t
	---@field text? string Text to be shown on the textline item within the parent menu | ***Default:*** "Title"

		---@class queuedMenuItem
		---@field queue? boolean If true, the item will only appear when additional items are added to the menu | ***Default:*** `false`
end

---Create a divider item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? queuedMenuItem Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil divider Reference to the context divider UI object
function wt.CreateMenuDivider(menu, t) end

---Create a spacer item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? queuedMenuItem Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil spacer Reference to the context spacer UI object
function wt.CreateMenuSpacer(menu, t) end

---Create a button item for an already existing Blizzard context menu
---***
---@param menu contextMenu|contextSubmenu Reference to the parent menu to add the new item to
---@param t? menuButtonCreationData Optional parameters
---***
---@return ElementMenuDescriptionProxy|nil button Reference to the context button UI object
function wt.CreateMenuButton(menu, t)

	--| Parameters

	---@class menuButtonCreationData # t
	---@field title? string Text to be shown on the button item within the parent menu | ***Default:*** "Button"
	---@field action? fun(...: any) Function to call when the button is clicked in the menu<hr><p>@*param* `...` any</p>
end


--[[ SETTINGS PAGE ]]

---Create an new Settings Panel frame and add it to the Options
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param t? settingsPageCreationData Optional parameters
---***
---@return settingsPage|nil page Table containing references to the settings canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions
function wt.CreateSettingsPage(addon, t)

	--| Parameters

	---@class settingsPageCreationData : settingsPageCreationData_base, describableObject, settingsCategoryData, settingsPageEvents, initializableOptionsContainer, liteObject # t
	---@field append? boolean When setting the name of the settings category page, append **t.name** after **addon** | ***Default:*** `true` if **t.name** ~= nil
	---@field icon? string Path to the texture file to use as the icon of this settings page | ***Default:*** *the addon's logo specified in its TOC file with the "IconTexture" tag*
	---@field titleIcon? boolean Append **t.icon** to the title of the button of the setting page in the AddOns list of the Settings window as well | ***Default:*** `true` if **t.register == true**
	---@field scroll? settingsPageScrollData If set, make the canvas frame scrollable by creating a [ScrollFrame](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame) as its child
	---@field autoSave? boolean If true, automatically save the values of all widgets registered for settings data management under settings keys listed in **t.dataManagement.keys**, committing their data to storage via ***WidgetToolbox*.SaveOptionsData(...)** | ***Default:*** `true` if **t.dataManagement.keys** ~= nil<ul><li>***Note:*** If **t.dataManagement.keys** is not set, the automatic load will not be executed even if this is set to true.</li></ul>
	---@field autoLoad? boolean If true, automatically load all data to the widgets registered for settings data management under settings keys listed in **t.dataManagement.keys** from storage via ***WidgetToolbox*.LoadOptionsData(...)** | ***Default:*** `true` if **t.dataManagement.keys** ~= nil<ul><li>***Note:*** If **t.dataManagement.keys** is not set, the automatic load will not be executed even if this is set to true.</li></ul>
	---@field arrangement? arrangementData_settingsPage If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table

		---@class settingsPageCreationData_base
		---@field register? boolean|settingsPage If true, register the new page to the Settings panel as a parent category or a subcategory of an already registered parent category if a reference to an existing settings category parent page provided | ***Default:*** `false`<ul><li>***Note:*** The page can be registered later via ***WidgetToolbox*.RegisterSettingsPage(...)**.</li></ul>
		---@field name? string Unique string used to set the name of the canvas frame | ***Default:*** **addon**<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
		---@field title? string Text to be shown as the title of the settings page | ***Default:*** [GetAddOnMetadata(**addon**, "title")](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata)
		---@field static? boolean If true, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** `false`

		---@class settingsCategoryData
		---@field dataManagement? settingsData_collection If set, register this settings page to settings data management for batched data saving & loading and handling data changes of all linked widgets

			---@class settingsData_collection : settingsData_base
			---@field keys? string[] An ordered list of unique strings appended to **category** linking a subset of settings data rules to be handled together in the specified order via this settings category page | ***Default:*** { **t.name** }

				---@class settingsData_base
				---@field category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** **addon**

		---@class settingsPageEvents
		---@field onLoad? fun(user: boolean) Called after the data of the settings widgets linked to this page has been loaded from storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onSave? fun(user: boolean) Called after the data of the settings widgets linked to this page has been committed to storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onApply? fun(user: boolean) Called after the data of the settings widgets linked to this page has been applied by calling change handlers<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onCancel? fun(user: boolean) Called after the changes are scrapped (for instance when the custom "Revert Changes" button is clicked)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
		---@field onDefault? fun(user: boolean, category: boolean) Called after settings data handled by this settings page has been restored to default values (for example when the "Accept" or "These Settings" - affecting this settings category page only - is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p><p>@*param* `category` boolean — Marking whether the call is through **[*settingsCategory*].defaults(...)** or not (or example when "All Settings" have been clicked)</p>

		---@class initializableOptionsContainer : initializableContainer
		---@field initialize? fun(container?: Frame, width: number, height: number, category?: string, keys?: string[], name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `category`? string A unique string used for categorizing settings data management rules & change handler scripts</p><p>@*param* `keys`? string[] Reference to **t.dataManagement.keys**, a list of unique strings appended to **category** linking a subset of settings data rules to be handled together in the specified order</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

		---@class settingsPageScrollData : scrollSpeedData
		---@field height? number Set the height of the scrollable child frame to the specified value | ***Default:*** 0 *(no height)*
		---@field speed? number Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25

		---@class arrangementData_settingsPage : arrangementRules
		---@field margins? spacingData_settingsPage Inset the content inside the canvas frame by the specified amount on each side
		---@field gaps? number The amount of space to leave between rows | ***Default:*** 44
		---@field resize? boolean Set the height of the canvas frame to match the space taken up by the arranged content (including margins) | ***Default:*** **t.scroll** ~= nil

			---@class spacingData_settingsPage
			---@field l? number Space to leave on the left side | 10
			---@field r? number Space to leave on the right side (doesn't need to be negated) | ***Default:*** 10
			---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** 44
			---@field b? number Space to leave at the bottom | ***Default:*** 44

	--| Returns

	---@class settingsPage
	---@field canvas? canvasFrame|Frame The settings page main canvas frame
	---@field category? table The registered settings category page
	---@field content? Frame The content frame to house the settings widgets or other page content
	---@field header? Frame The header frame containing the page title, description and icon
	---@field title FontString
	---@field description? FontString
	---@field iconTexture? string
	---@field icon? Texture
	local _ = {}

		---@class canvasFrame : Frame
		---@field OnCommit function
		---@field OnRefresh function
		---@field OnDefault function

		---Returns the type of this object
		---***
		---@return "SettingsPage"
		---<p></p>
		function _.getType() return "SettingsPage" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---Toggle the availability of the reset defaults and revert changes cancel buttons for this page
		---***
		---@param state boolean? ***Default:*** `true`
		function _.setStatic(state) end

		---Returns the unique identifier key representing the reset defaults warning popup dialog in the global **StaticPopupDialogs** table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
		---@return string
		function _.getResetPopupKey() return "" end

		---Open the Settings window to this category page
		--- - ***Note:*** No category page will be opened if **WidgetToolsDB.lite** is true.
		function _.open() end

		---Force update all linked settings widgets in this category page
		---***
		---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _.load(handleChanges, user) end

		---Force save all settings data of this category page from all linked widgets
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _.save(user) end

		---Apply settings data of this category page by calling all registered **onChange** handlers of all linked widgets
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _.apply(user) end

		---Revert any changes made in this category page and reload all linked widget data
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _.revert(user) end

		---Reset all settings data of this category page to default values
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _.reset(user) end
end

---Create an new Settings category with a parent page, its child pages, and set up shared settings data management for them
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param parent settingsPageCreationData|settingsPage Settings page creation parameters to create, or reference to an existing *unregistered* settings page to set as the parent page for the new category<ul><li>***Note:*** If the provided parent candidate page is already registered (containing a **category** value), it will be dismissed and no new category will be created at all.</li></ul>
---@param pages? settingsPageCreationData[]|settingsPage[] List of settings page creation parameters to create, or references to an existing *unregistered* settings pages to add as subcategories under **parent**<ul><li>***Note:*** Already registered pages (which contain a **category** value) will be skipped and won't be included in the new category.</li></ul>
---@param t? settingsCategoryCreationData Optional parameters
---***
---@return settingsCategory|nil category Table containing references to settings pages and utility functions or nil if the specified **parent** was invalid
function wt.CreateSettingsCategory(addon, parent, pages, t)

	--| Parameters

	---@class settingsCategoryCreationData # t
	---@field onLoad? fun(user: boolean) Called after the data of the settings widgets linked to all pages of this settings category has been loaded from storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
	---@field onDefaults? fun(user: boolean) Called after settings data handled by all pages of this settings category has been restored to default values (for example when the "All Settings" option is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>

	--| Returns

	---@class settingsCategory
	---@field pages settingsPage[]
	local _ = {}

		---Returns the type of this object
		---***
		---@return "SettingsCategory"
		---<p></p>
		function _.getType() return "SettingsCategory" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---Force update the settings widgets for all pages in this category
		---***
		---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _.load(handleChanges, user) end

		---Reset all settings data to their default values for all pages in this category
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param callListeners? boolean If true, call the **onDefault** listeners (if set) of each individual category page separately | ***Default:*** `true`
		function _.defaults(user, callListeners) end
end


--[[ ACTION ]]

---Create a non-GUI action widget
---***
---@param t? actionCreationData Optional parameters
---***
---@return action action Reference to the new action widget, utility functions and more wrapped in a table
function wt.CreateAction(t)

	--| Parameters

	---Optional parameters
	---@class actionCreationData : togglableObject # t
	---@field action? fun(self: action, user?: boolean) Function to call when the button is triggered (clicked by the user or triggered programmatically)<ul><li>***Note:*** This function will be called when an "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" script event happens, there's no need to register it again under **t.events.OnClick**.</li></ul><hr><p>@*param* `self` action — Reference to the widget table</p><p>@*param* `user`? boolean — Marking whether the call is due to a user interaction or not | ***Default:*** `false`</p>
	---@field listeners? actionEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class togglableObject
		---@field disabled? boolean If true, set the state of this widget to be disabled during initialization | ***Default:*** `false`<ul><li>***Note:*** Dependency rule evaluations may re-enable the widget after initialization.</li></ul>
		---@field dependencies? dependencyRule[] Automatically enable or disable the widget based on the set of rules described in subtables

			---@class dependencyRule
			---@field frame AnyFrameObject|toggle|selector|multiselector|specialSelector|textbox|numeric Tie the state of the widget to the evaluation of the current value of the frame specified here
			---@field evaluate? fun(value?: any): evaluation: boolean Call this function to evaluate the current value of the specified frame, enabling the dependant widget when true, or disabling it when false is returned | ***Default:*** *no evaluation, only for checkboxes*<ul><li>***Note:*** **evaluate** must be defined if the [FrameType](https://warcraft.wiki.gg/wiki/API_CreateFrame#Frame_types) if **frame** is not "CheckButton".</li><li>***Overloads:***</li><ul><li>function(`value`: boolean) -> `evaluation`: boolean — If **frame** is recognized as a checkbox</li><li>function(`value`: string) -> `evaluation`: boolean — If **frame** is recognized as an editbox</li><li>function(`value`: number) -> `evaluation`: boolean — If **frame** is recognized as a slider</li><li>function(`value`: integer) -> `evaluation`: boolean — If **frame** is recognized as a dropdown or selector</li><li>function(`value`: boolean[]) -> `evaluation`: boolean — If **frame** is recognized as multiselector</li><li>function(`value`: AnchorPoint|JustifyH|JustifyV|FrameStrata) -> `evaluation`: boolean — If **frame** is recognized as a special selector</li><li>function(`value`: nil) -> `evaluation`: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*</li></ul></ul>

		---@class actionEventListeners
		---@field enabled? actionEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **action.setEnabled(...)** was called
		---@field trigger? actionEventListener_triggered[] Ordered list of functions to call when a "triggered" event is invoked after **action.trigger(...)** was called
		---@field _? actionEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class actionEventListener_enabled : eventHandlerIndex
			---@field handler ActionEventHandler_enabled Handler function to register for call

				---@class eventHandlerIndex
				---@field callIndex? integer Set when to call **handler** in the execution order | ***Default:*** *placed at the end of the current list*

				---@alias ActionEventHandler_enabled
				---| fun(self: ActionType, state: boolean) Called when an "enabled" event is invoked after **action.setEnabled(...)** was called<hr><p>@*param* `self` ActionType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

					---@alias ActionType
					---| action
					---| actionButton
					---| customButton

			---@class actionEventListener_triggered : eventHandlerIndex
			---@field handler ActionEventHandler_triggered Handler function to register for call

				---@alias ActionEventHandler_triggered
				---| fun(self: ActionType) Called when a "triggered" event is invoked after **action.trigger(...)** was called<hr><p>@*param* `self` ActionType ― Reference to the widget table</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class actionEventListener_any : eventTag, eventHandlerIndex
			---@field handler ActionEventHandler_any Handler function to register for call

				---@class eventTag
				---@field event string Custom event tag

				---@alias ActionEventHandler_any
			---| fun(self: ActionType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ActionType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class action
	---@field invoke action_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener action_setListener Hook a handler function as a listener for a custom widget event
	local _ = {}

		---Returns the type of this object
		---***
		---@return "Action"
		---<p></p>
		function _.getType() return "Action" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---@class action_invoke
		local invoke = {}

			--Invoke an "enabled" event calling registered listeners
			function invoke.enabled() end

			---Invoke a "triggered" event calling registered listeners
			---@param user boolean
			function invoke.triggered(user) end

			---Invoke a custom event calling registered listeners
			---@param event string Custom event tag
			---@param ... any Any number of leftover arguments passed to listeners
			function invoke._(event, ...) end

		---@class action_setListener
		local setListener = {}

			---Register a listener for a "enabled" event trigger
			---@param listener ActionEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---Register a listener for a "triggered" event trigger
			---@param listener ActionEventHandler_triggered Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.triggered(listener, callIndex) end

			---Register a listener for a custom event trigger
			---@param event string Custom event tag
			---@param listener ActionEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

		---Trigger the action registered for the button (if it is enabled)
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "trigger" event and call registered listeners | ***Default:*** `false`
		function _.trigger(user, silent) end

	return _
end

--| Button

---Create a Blizzard button GUI frame with enhanced widget functionality
---***
---@param t? actionButtonCreationData Optional parameters
---@param action? action Reference to an already existing action manager to mutate into a button instead of creating a new base widget
---***
---@return actionButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
function wt.CreateButton(t, action)

	--| Parameters

	--Optional parameters
	---@class actionButtonCreationData : actionCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject # t
	---@field name? string Unique string used to set the frame name | ***Default:*** "Button"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field titleOffset? offsetData Offset the position of the label of the button
	---@field size? sizeData_button|sizeData
	---@field font? labelFontOptions_highlight List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
	---@field events? table<ScriptButton, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the button and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" when the button is clicked.</li><li>***Note:*** **t.action** will automatically be called when an "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" event triggers, there is no need to register it here as well.</li></ul>

		---@class sizeData_button
	---@field w? number Width | ***Default:*** 80
	---@field h? number Height | ***Default:*** 22

		---@class labelFontOptions_highlight
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** "GameFontNormal"
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** "GameFontHighlight"
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** "GameFontDisable"

	--| Returns

	---@class actionButton : action
	---@field label FontString|nil
	---@field frame Frame Frame to catch mouse interactions and serve as a hover trigger to be able to show the tooltip or when the button is disabled
	---@field widget Button
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "Action"
		---@return "Button"
		---<p></p>
		function _.getType() return "Action", "Button" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end

---Create a Blizzard button GUI frame with customizable backdrop and enhanced widget functionality
---***
---@param t? customButtonCreationData Optional parameters
---@param action? action Reference to an already existing action button to mutate into a custom button instead of creating a new base widget
---***
---@return customButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button) (inheriting [BackdropTemplate](https://warcraft.wiki.gg/wiki/BackdropTemplate)), utility functions and more wrapped in a table
function wt.CreateCustomButton(t, action)

	--| Parameters

	--Optional parameters
	---@class customButtonCreationData : actionButtonCreationData, customizableObject # t
	---@field font? labelFontOptions_small_highlight Table of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *small default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>

		---@class customizableObject
		---@field backdrop? backdropData Parameters to set the custom backdrop with
		---@field backdropUpdates? backdropUpdateRule[] Table of key, value pairs containing the list of events to set listeners for assigned to **t.backdropUpdates[*key*].frame**, linking backdrop changes to it, modifying the specified parameters on trigger
		--- - ***Note:*** All update rules are additive, calling ***WidgetToolbox*.SetBackdrop(...)** multiple times with **t.backdropUpdates** specified *will not* override previously set update rules. The base **backdrop** values used for these old rules *will not* change by setting a new backdrop via ***WidgetToolbox*.SetBackdrop(...)** either!

		---@class labelFontOptions_small_highlight
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** "GameFontNormalSmall"
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** "GameFontHighlightSmall"
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** "GameFontDisableSmall"

	--| Returns

	---@class customButton : actionButton
	---@field widget Button|BackdropTemplate
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "Action"
		---@return "CustomButton"
		---<p></p>
		function _.getType() return "Action", "CustomButton" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end


--[[ TOGGLE ]]

---Create a non-GUI toggle widget with boolean data management logic
---***
---@param t? toggleCreationData Optional parameters
---***
---@return toggle toggle Reference to the new toggle widget, utility functions and more wrapped in a table
function wt.CreateToggle(t)

	--| Parameters

	--Optional parameters
	---@class toggleCreationData : togglableObject, settingsWidget # t
	---@field listeners? toggleEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): state: boolean|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `state` boolean|nil | ***Default:*** `false`</p>
	---@field saveData? fun(state: boolean) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `state` boolean</p>
	---@field value? boolean The starting state of the widget to set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid
	---@field default? boolean Default value of the widget | ***Default:*** `false`

		---@class settingsWidget
		---@field dataManagement? settingsData If set, register this widget to settings data management for batched data saving & loading and handling data changes
		---@field instantSave? boolean Immediately commit the data to storage whenever it's changed via the widget | ***Default:*** `true`<ul><li>***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.</li></ul>

			---@class settingsData
			---@field category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(register as a global rule)*
			---@field key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
			---@field index? integer Set when to place this widget in the execution order when saving or loading batched settings data | ***Default:*** *placed at the end of the current list*
			---@field onChange? table<string|integer, function|string> table<string|integer, function|string> List of new or already defined functions to call after the value of the widget was changed by the user or via settings data management<ul><li>**[*key*]**? string|integer ― A unique string appended to **category** to point to a newly defined function to be added to settings data management or just the index of the next function name | ***Default:*** *next assigned index*</li><li>**[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function</li><ul><li>***Note:*** Function definitions will be replaced by key references when they are registered to settings data management. Functions registered under duplicate keys are overwritten.</li></ul></ul>

		---@class toggleEventListeners
		---@field enabled? toggleEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **toggle.setEnabled(...)** was called
		---@field loaded? toggleEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? toggleEventListener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field toggled? toggleEventListener_toggled[] Ordered list of functions to call when an "toggled" event is invoked after **toggle.setState(...)** was called
		---@field [string]? toggleEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class toggleEventListener_enabled : eventHandlerIndex
			---@field handler ToggleEventHandler_enabled Handler function to register for call

				---@alias ToggleEventHandler_enabled
				---| fun(self: ToggleType, state: boolean) Called when an "enabled" event is invoked after **toggle.setEnabled(...)** was called<hr><p>@*param* `self` ToggleType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

					---@alias ToggleType
					---| toggle
					---| checkbox
					---| radiobutton

			---@class toggleEventListener_loaded : eventHandlerIndex
			---@field handler ToggleEventHandler_loaded Handler function to register for call

				---@alias ToggleEventHandler_loaded
				---| fun(self: ToggleType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` ToggleType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

			---@class toggleEventListener_saved : eventHandlerIndex
			---@field handler ToggleEventHandler_saved Handler function to register for call

				---@alias ToggleEventHandler_saved
				---| fun(self: ToggleType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` ToggleType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

			---@class toggleEventListener_toggled : eventHandlerIndex
			---@field handler ToggleEventHandler_toggled Handler function to register for call

				---@alias ToggleEventHandler_toggled
				---| fun(self: ToggleType, state: boolean, user: boolean) Called when an "toggled" event is invoked after **toggle.setState(...)** was called<hr><p>@*param* `self` ToggleType ― Reference to the toggle widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class toggleEventListener_any : eventTag, eventHandlerIndex
			---@field handler ToggleEventHandler_any Handler function to register for call

				---@alias ToggleEventHandler_any
				---| fun(self: ToggleType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ToggleType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class toggle
	---@field invoke toggle_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener toggle_setListener Hook a handler function as a listener for a custom widget event
	local _ = {}

		---Returns the type of this object
		---***
		---@return "Toggle"
		---<p></p>
		function _.getType() return "Toggle" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---@class toggle_invoke
		local invoke = {}

			--Invoke an "enabled" event calling registered listeners
			function invoke.enabled() end

			---Invoke a "loaded" event calling registered listeners
			---@param success boolean
			function invoke.loaded(success) end

			---Invoke a "saved" event calling registered listeners
			---@param success boolean
			function invoke.saved(success) end

			---Invoke a "toggled" event calling registered listeners
			---@param user boolean
			function invoke.toggled(user) end

			---Invoke a custom event calling registered listeners
			---@param event string Custom event tag
			---@param ... any Any number of leftover arguments passed to listeners
			function invoke._(event, ...) end

		---@class toggle_setListener
		local setListener = {}

			---Register a listener for a "enabled" event trigger
			---@param listener ToggleEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---Register a listener for a "loaded" event trigger
			---@param listener ToggleEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---Register a listener for a "saved" event trigger
			---@param listener ToggleEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---Register a listener for a "toggled" event trigger
			---@param listener ToggleEventHandler_toggled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.toggled(listener, callIndex) end

			---Register a listener for a custom event trigger
			---@param event string Custom event tag
			---@param listener ToggleEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(state, silent) end

		---Get the currently stored data via **t.getData()**
		---@return boolean|nil
		function _.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param state? boolean Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(state, handleChanges, silent) end

		---Get the currently set default value
		---@return boolean default
		function _.getDefault() return false end

		---Set the default value
		---@param state? boolean ***Default:*** `false`
		function _.setDefault(state) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **toggle.revertData()**
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **toggle.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Returns the current toggle state of the widget
		---@return boolean
		function _.getState() return false end

		---Verify and set the toggle value of the widget to the provided state
		---***
		---@param state? boolean ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "toggled" event and call registered listeners | ***Default:*** `false`
		function _.setState(state, user, silent) end

		---Flip the current toggle state of the widget
		---***
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "toggled" event and call registered listeners | ***Default:*** `false`
		function _.toggleState(user, silent) end

		---Utility turn a toggle state value into formatted string
		---***
		---@param state? boolean ***Default:*** *(current value)*
		---@return string
		function _.formatValue(state) return "" end

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--| Checkbox

---Create a Blizzard checkbox GUI frame with enhanced widget functionality
---***
---@param t? checkboxCreationData Optional parameters
---@param toggle? toggle Reference to an already existing toggle to mutate into a checkbox instead of creating a new base widget
---***
---@return checkbox|toggle # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateCheckbox(t, toggle)

	--| Parameters

	--Optional parameters
	---@class checkboxCreationData : toggleCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** "Toggle"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_checkbox|sizeData
	---@field font? labelFontOptions List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
	---@field events? table<ScriptButton, fun(self: checkbox, state: boolean, button?: string, down?: boolean)|fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the checkbox and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` AnyFrameObject ― Reference to the toggle frame</p><p>@*param* `state` boolean ― The checked state of the toggle frame</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** "LeftButton"</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** `false`</p></li></ul>

		---@class tooltipDescribableSettingsWidget
		---@field showDefault? boolean If true, show the default value of the widget in its tooltip and display the reset button its the utility menu | ***Default:*** `true`
		---@field utilityMenu? boolean If true, assign a context menu to the settings widget frame to allow for quickly resetting changes or the default value | ***Default:*** `true`

		---@class sizeData_checkbox
	---@field w? number Width | ***Default:*** **t.label** and 180 or **t.size.h**
	---@field h? number Height | ***Default:*** 26

		---@class labelFontOptions
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** "GameFontHighlight"
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in a highlighted state | ***Default:*** "GameFontNormal"
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** "GameFontDisable"

	--| Returns

	---@class checkbox: toggle
	---@field frame Frame Click target
	---@field widget SettingsCheckbox Checkbox
	---@field label FontString|nil
	local _ = {}

		---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"SettingsCheckboxTemplate"`
		---@class SettingsCheckbox : CheckButton
		---@field HoverBackground Frame

		---Returns all object types of this mutated widget
		---***
		---@return "Toggle"
		---@return "Checkbox"
		---<p></p>
		function _.getType() return "Toggle", "Checkbox" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end

---Create a classic Blizzard checkbox GUI frame with enhanced widget functionality
---***
---@param t? checkboxCreationData Optional parameters
---@param toggle? toggle Reference to an already existing toggle to mutate into a checkbox instead of creating a new base widget
---***
---@return checkbox|toggle # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateClassicCheckbox(t, toggle)

	--| Returns

	---@class customCheckbox : toggle
	---@field frame Frame Click target
	---@field widget CheckButton|BackdropTemplate Checkbox
	---@field label FontString|nil
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "Toggle"
		---@return "ClassicCheckbox"
		---<p></p>
		function _.getType() return "Toggle", "ClassicCheckbox" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end

--| Radiobutton

---Create a Blizzard radio button GUI frame with enhanced widget functionality
---***
---@param t? radiobuttonCreationData Optional parameters
---@param toggle? toggle Reference to an already existing toggle to mutate into a radio button instead of creating a new base widget
---***
---@return radiobutton|toggle # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateRadiobutton(t, toggle)

	--| Parameters

	--Optional parameters
	---@class radiobuttonCreationData : checkboxCreationData # t
	---@field size? sizeData_radiobutton|sizeData
	---@field clearable? boolean Whether this radio button should be clearable by right clicking on it or not | ***Default:*** `false`<ul><li>***Note:*** The radio button will be registered for "RightButtonUp" triggers to call "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" events with **button** = "RightButton".</li></ul>
	---@field events? table<ScriptButton, fun(self: radiobutton, state: boolean, button?: string, down?: boolean)|fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the radio button and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` AnyFrameObject ― Reference to the toggle frame</p><p>@*param* `state` boolean ― The checked state of the toggle frame</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** "LeftButton"</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** `false`</p></li></ul>

		---@class sizeData_radiobutton
	---@field w? number Width | ***Default:***  **t.label** and 180 or **t.size.h**
	---@field h? number Height | ***Default:*** 18

		---@class labelFontOptions_small
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** "GameFontHighlightSmall"
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** "GameFontDisableSmall"

	--| Returns

	---@class radiobutton: toggle
	---@field frame Frame Click target
	---@field widget CheckButton Radio button
	---@field label FontString|nil
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "Toggle"
		---@return "Radiobutton"
		---<p></p>
		function _.getType() return "Toggle", "Radiobutton" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end


--[[ SELECTOR ]]

---Create a non-GUI selector widget (managing a set of toggle widgets) with integer (selection index) data management logic
---***
---@param t? selectorCreationData Optional parameters
---***
---@return selector selector Reference to the new selector widget, utility functions and more wrapped in a table
function wt.CreateSelector(t)

	--| Parameters

	--Optional parameters
	---@class selectorCreationData : togglableObject, settingsWidget, selectorCreationData_base # t
	---@field items? (selectorItem|selectorToggle|toggle)[] Table containing subtables with data used to create item widgets, or already existing toggles
	---@field listeners? selectorEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): selected: integer|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `selected` integer|nil | ***Default:*** nil *(no selection)*</p>
	---@field saveData? fun(selected?: integer) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `selected`? integer</p>
	---@field value? integer The index of the item to be set as selected during initialization | ***Default:*** **t.getData()** or **t.default** if invalid or 1 if **t.clearable** is false
	---@field default? integer Default value of the widget | ***Default:*** 1 or nil *(no selection)* if **t.clearable** is true

		---@class selectorCreationData_base
		---@field clearable? boolean If true, the value of the selector input should be clearable and allowed to be set to nil | ***Default:*** `false`

		---@class selectorItem
		---@field title? string Text to be shown on the right of the item to represent the item within the selector frame (if **t.labels** is true)
		---@field tooltip? itemTooltipTextData|widgetTooltipTextData List of text lines to be added to the tooltip of the item displayed when mousing over the frame
		---@field onSelect? function The function to be called when the item is selected by the user

			---@class itemTooltipTextData : tooltipTextData
			---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** **t.items[*index*].title**

			---@class widgetTooltipTextData : tooltipTextData
			---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**

		---@class selectorToggle : toggle
		---@field index integer The index of this toggle item inside a selector widget

		---@class selectorEventListeners
		---@field enabled? selectorEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **selector.setEnabled(...)** was called
		---@field loaded? selectorEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? selectorEventListener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field selected? selectorEventListener_selected[] Ordered list of functions to call when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared
		---@field updated? selectorEventListener_updated[] Ordered list of functions to call when an "updated" event is invoked after **selector.updatedItems(...)** was called
		---@field added? selectorEventListener_added[] Ordered list of functions to call when an "added" event is invoked when a new toggle item is added to the selector via **selector.updatedItems(...)**
		---@field [string]? selectorEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class selectorEventListener_enabled : eventHandlerIndex
			---@field handler SelectorEventHandler_enabled Handler function to register for call

				---@alias SelectorEventHandler_enabled
				---| fun(self: SelectorType, state: boolean) Called when an "enabled" event is invoked after **selector.setEnabled(...)** was called<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

					---@alias SelectorType
					---| selector
					---| radiogroup
					---| dropdownRadiogroup

			---@class selectorEventListener_loaded : eventHandlerIndex
			---@field handler SelectorEventHandler_loaded Handler function to register for call

				---@alias SelectorEventHandler_loaded
				---| fun(self: SelectorType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

			---@class selectorEventListener_saved : eventHandlerIndex
			---@field handler SelectorEventHandler_saved Handler function to register for call

				---@alias SelectorEventHandler_saved
				---| fun(self: SelectorType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

			---@class selectorEventListener_selected : eventHandlerIndex
			---@field handler SelectorEventHandler_selected Handler function to register for call

				---@alias SelectorEventHandler_selected
				---| fun(self: SelectorType, selected?: integer, user: boolean) Called when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `selected` integer ― The index of the currently selected item</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class selectorEventListener_updated : eventHandlerIndex
			---@field handler SelectorEventHandler_updated Handler function to register for call

				---@alias SelectorEventHandler_updated
				---| fun(self: SelectorType) Called when an "updated" event is invoked after **selector.updatedItems(...)** was called<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p>

			---@class selectorEventListener_added : eventHandlerIndex
			---@field handler SelectorEventHandler_updated Handler function to register for call

				---@alias SelectorEventHandler_added
				---| fun(self: SelectorType, toggle: toggle|selectorToggle) Called when a new toggle item is added to the selector via **selector.updatedItems(...)**<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `toggle` toggle|selectorToggle ― Reference to the toggle widget added to the selector</p>

			---@class selectorEventListener_any : eventTag, eventHandlerIndex
			---@field handler SelectorEventHandler_any Handler function to register for call

				---@alias SelectorEventHandler_any
				---| fun(self: SelectorType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` SelectorType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class selector
	---@field toggles (toggle|selectorToggle)[]
	---@field invoke selector_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener selector_setListener Hook a handler function as a listener for a custom widget event
	local _ = {}

		---Returns the type of this object
		---***
		---@return "Selector"
		---<p></p>
		function _.getType() return "Selector" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---@class selector_invoke
		local invoke = {}

			--Invoke an "enabled" event calling registered listeners
			function invoke.enabled() end

			---Invoke a "loaded" event calling registered listeners
			---@param success boolean
			function invoke.loaded(success) end

			---Invoke a "saved" event calling registered listeners
			---@param success boolean
			function invoke.saved(success) end

			---Invoke a "selected" event calling registered listeners
			---@param user boolean
			function invoke.selected(user) end

			--Invoke a "updated" event calling registered listeners
			function invoke.updated() end

			---Invoke an "added" event calling registered listeners
			---@param toggle toggle|selectorToggle
			function invoke.added(toggle) end

			--Invoke a custom event calling registered listeners
			---@param event string Custom event tag
			---@param ... any Any number of leftover arguments passed to listeners
			function invoke._(event, ...) end

		---@class selector_setListener
		local setListener = {}

			---Register a listener for a "enabled" event trigger
			---@param listener SelectorEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---Register a listener for a "loaded" event trigger
			---@param listener SelectorEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---Register a listener for a "saved" event trigger
			---@param listener SelectorEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---Register a listener for a "selected" event trigger
			---@param listener SelectorEventHandler_selected Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.selected(listener, callIndex) end

			---Register a listener for a "updated" event trigger
			---@param listener SelectorEventHandler_updated Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.updated(listener, callIndex) end

			---Register a listener for a "added" event trigger
			---@param listener SelectorEventHandler_added Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.added(listener, callIndex) end

			---Register a listener for a custom event trigger
			---@param event string Custom event tag
			---@param listener SelectorEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Update the list of items currently set for the selector widget, updating its parameters and toggle widgets
		--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
		--- - ***Note:*** The currently selected item may not be the same after an item was removed. In that case, the item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use **selector.setSelected(...)** to correct the selection if needed!
		---***
		---@param newItems (selectorItem|toggle|selectorToggle)[] Table containing subtables with data used to update the toggle widgets, or already existing toggle widgets
		---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
		function _.updateItems(newItems, silent) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.saveData(data, silent) end

			---@class wrappedInteger
			---@field index? integer ***Default:*** nil *(no selection)*

		---Get the currently stored data via **t.getData()**
		---@return integer|nil
		function _.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param data? wrappedInteger If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return integer|nil default
		function _.getDefault() end

		---Set the default value
		---@param index integer|nil | ***Default:*** *no change*
		function _.setDefault(index) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Returns the index of the currently selected item or nil if there is no selection
		---@return integer|nil index
		function _.getSelected() end

		---Verify and set the specified item as selected
		---***
		---@param index? integer ***Default:*** nil *(no selection)*
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		function _.setSelected(index, user, silent) end

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

---Create a non-GUI special selector widget (managing a set of toggle widgets) with data management logic specific to the specified **itemset**
---***
---@param itemset SpecialSelectorItemset Specify what type of selector should be created
---@param t? specialSelectorCreationData Optional parameters
---***
---@return specialSelector specialSelector Reference to the new selector widget, utility functions and more wrapped in a table
function wt.CreateSpecialSelector(itemset, t)

	--| Parameters

	--Specify what type of selector should be created
	---@alias CreateSpecialSelector_param1 # itemset
	---| SpecialSelectorItemset

		---@alias SpecialSelectorItemset
		---| "anchor" Using the set of [AnchorPoint](https://warcraft.wiki.gg/wiki/Anchors) items
		---| "justifyH" Using the set of horizontal text alignment items (JustifyH)
		---| "justifyV" Using the set of vertical text alignment items (JustifyV)
		---| "strata" Using the set of [FrameStrata](https://warcraft.wiki.gg/wiki/Frame_Strata) items (excluding "WORLD")

	--Optional parameters
	---@class specialSelectorCreationData : togglableObject, settingsWidget, selectorCreationData_base # t
	---@field listeners? specialSelectorEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: integer|specialSelectorValueTypes|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `value` integer|AnchorPoint|JustifyH|JustifyV|FrameStrata|nil — The index or the value of the item to be set as selected ***Default:*** nil *(no selection)*</p>
	---@field saveData? fun(value?: specialSelectorValueTypes) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata</p>
	---@field value? integer|specialSelectorValueTypes The item to be set as selected during initialization | ***Default:*** **t.getData()** or **t.default** if invalid or *option 1* if **t.clearable** is false
	---@field default? integer|specialSelectorValueTypes Default value of the widget | ***Default:*** *option 1* or nil *(no selection)* if **t.clearable** is true

		---@alias specialSelectorValueTypes
		---| FramePoint
		---| JustifyHorizontal
		---| JustifyVertical
		---| FrameStrata

		---@class specialSelectorEventListeners
		---@field enabled? specialSelectorEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **selector.setEnabled(...)** was called
		---@field loaded? specialSelectorEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? specialSelectorEventListener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field selected? specialSelectorEventListener_selected[] Ordered list of functions to call when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared
		---@field [string]? specialSelectorEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class specialSelectorEventListener_enabled : eventHandlerIndex
			---@field handler SpecialSelectorEventHandler_enabled Handler function to register for call

				---@alias SpecialSelectorEventHandler_enabled
				---| fun(self: SpecialSelectorType, state: boolean) Called when an "enabled" event is invoked after **selector.setEnabled(...)** was called<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

					---@alias SpecialSelectorType
					---| selector
					---| specialSelector

			---@class specialSelectorEventListener_loaded : eventHandlerIndex
			---@field handler SpecialSelectorEventHandler_loaded Handler function to register for call

				---@alias SpecialSelectorEventHandler_loaded
				---| fun(self: SpecialSelectorType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

			---@class specialSelectorEventListener_saved : eventHandlerIndex
			---@field handler SpecialSelectorEventHandler_saved Handler function to register for call

				---@alias SpecialSelectorEventHandler_saved
				---| fun(self: SpecialSelectorType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

			---@class specialSelectorEventListener_selected : eventHandlerIndex
			---@field handler SpecialSelectorEventHandler_selected Handler function to register for call

				---@alias SpecialSelectorEventHandler_selected
				---| fun(self: SpecialSelectorType, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class specialSelectorEventListener_any : eventTag, eventHandlerIndex
			---@field handler SpecialSelectorEventHandler_any Handler function to register for call

				---@alias SpecialSelectorEventHandler_any
				---| fun(self: SpecialSelectorType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` SpecialSelectorType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class specialSelector
	---@field toggles (toggle|selectorToggle)[]
	---@field invoke specialSelector_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener specialSelector_setListener Hook a handler function as a listener for a custom widget event
	local _ = {}

		---Returns the type of this object
		---***
		---@return "SpecialSelector"
		---<p></p>
		function _.getType() return "SpecialSelector" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---Return the itemset type specified for this special selector on creation
		---@return SpecialSelectorItemset itemset
		function _.getItemset() return "anchor" end

		---@class specialSelector_invoke
		local invoke = {}

			--Invoke an "enabled" event calling registered listeners
			function invoke.enabled() end

			---Invoke a "loaded" event calling registered listeners
			---@param success boolean
			function invoke.loaded(success) end

			---Invoke a "saved" event calling registered listeners
			---@param success boolean
			function invoke.saved(success) end

			---Invoke a "selected" event calling registered listeners
			---@param user boolean
			function invoke.selected(user) end

			---Invoke a custom event calling registered listeners
			---@param event string Custom event tag
			---@param ... any Any number of leftover arguments passed to listeners
			function invoke._(event, ...) end

		---@class specialSelector_setListener
		local setListener = {}

			---Register a listener for a "enabled" event trigger
			---@param listener SpecialSelectorEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---Register a listener for a "loaded" event trigger
			---@param listener SpecialSelectorEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---Register a listener for a "saved" event trigger
			---@param listener SpecialSelectorEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---Register a listener for a "selected" event trigger
			---@param listener SpecialSelectorEventHandler_selected Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.selected(listener, callIndex) end

			---Register a listener for a custom event trigger
			---@param event string Custom event tag
			---@param listener SpecialSelectorEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.saveData(data, silent) end

			---@class wrappedAnchor
			---@field value? FramePoint ***Default:*** nil *(no selection)*

			---@class wrappedJustifyH
			---@field value? JustifyHorizontal ***Default:*** nil *(no selection)*

			---@class wrappedJustifyV
			---@field value? JustifyVertical ***Default:*** nil *(no selection)*

			---@class wrappedStrata
			---@field value? FrameStrata ***Default:*** nil *(no selection)*

		---Get the currently stored data via **t.getData()**
		---@return specialSelectorValueTypes|nil
		function _.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param data? wrappedInteger|wrappedAnchor|wrappedJustifyH|wrappedJustifyV|wrappedStrata If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return specialSelectorValueTypes|nil default
		function _.getDefault() end

		---Set the default value
		---***
		---@param selected integer|specialSelectorValueTypes|nil | ***Default:*** *no change*
		---<p></p>
		function _.setDefault(selected) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
		---***
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Returns the value of the currently selected item or nil if there is no selection
		---@return specialSelectorValueTypes|nil selected
		---<p></p>
		function _.getSelected() end

		---Set the specified item as selected
		---***
		---@param selected integer|specialSelectorValueTypes|nil The index or the value of the item to be set as selected | ***Default:*** *no selection:* `nil`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "selected" event and call registered listeners | ***Default:*** `false`
		---<p></p>
		function _.setSelected(selected, user, silent) end

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

---Create a non-GUI multiselector widget (managing a set of toggle widgets) with boolean mask data management logic
---***
---@param t? multiselectorCreationData Optional parameters
---***
---@return multiselector multiselector Reference to the new multiselector widget, utility functions and more wrapped in a table
function wt.CreateMultiselector(t)

	--| Parameters

	--Optional parameters
	---@class multiselectorCreationData : togglableObject, settingsWidget # t
	---@field items? (selectorItem|toggle)[] Table containing subtables with data used to create item widgets, or already existing toggles
	---@field limits? limitValues Parameters to specify the limits of the number of selectable items
	---@field listeners? multiselectorEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): selections: boolean[] Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `selections` boolean[] | ***Default:*** *no selected items: `false[]`*</p>
	---@field saveData? fun(selections?: boolean[]) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `selections`? boolean[] | ***Default:*** *no selected items: `false[]`*</p>
	---@field value? boolean[] Ordered list of item states to set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid
	---@field default? boolean[] Default value of the widget | ***Default:*** *no selected items: `false[]`*

		---@class limitValues
		---@field min? integer The minimal number of items that need to be selected at all times | ***Default:*** 1
		---@field max? integer The maximal number of items that can be selected at once | ***Default:*** #**t.items** *(all items)*

		---@class multiselectorEventListeners
		---@field enabled? multiselectorEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **selector.setEnabled(...)** was called
		---@field loaded? multiselectorEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? multiselectorEventListener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field selected? multiselectorEventListener_selected[] Ordered list of functions to call when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared
		---@field updated? multiselectorEventListener_updated[] Ordered list of functions to call when an "updated" event is invoked after **selector.updatedItems(...)** was called
		---@field added? multiselectorEventListener_added[] Ordered list of functions to call when an "added" event is invoked when a new toggle item is added to the selector via **selector.updatedItems(...)**
		---@field min? multiselectorEventListener_limited[] Ordered list of functions to call when a "limited" event is invoked after a lower limit update occurs
		---@field [string]? multiselectorEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class multiselectorEventListener_enabled : eventHandlerIndex
			---@field handler MultiselectorEventHandler_enabled Handler function to register for call

				---@alias MultiselectorEventHandler_enabled
				---| fun(self: MultiselectorType, state: boolean) Called when an "enabled" event is invoked after **selector.setEnabled(...)** was called<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

					---@alias MultiselectorType
					---| multiselector
					---| checkgroup

			---@class multiselectorEventListener_loaded : eventHandlerIndex
			---@field handler MultiselectorEventHandler_loaded Handler function to register for call

				---@alias MultiselectorEventHandler_loaded
				---| fun(self: MultiselectorType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

			---@class multiselectorEventListener_saved : eventHandlerIndex
			---@field handler MultiselectorEventHandler_saved Handler function to register for call

				---@alias MultiselectorEventHandler_saved
				---| fun(self: MultiselectorType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

			---@class multiselectorEventListener_selected : eventHandlerIndex
			---@field handler MultiselectorEventHandler_selected Handler function to register for call

				---@alias MultiselectorEventHandler_selected
				---| fun(self: MultiselectorType, selections: boolean[], user: boolean) Called when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `selections` boolean[] ― Indexed list of the current item states</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class multiselectorEventListener_updated : eventHandlerIndex
			---@field handler MultiselectorEventHandler_updated Handler function to register for call

				---@alias MultiselectorEventHandler_updated
				---| fun(self: MultiselectorType) Called when an "updated" event is invoked after **selector.updatedItems(...)** was called<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p>

			---@class multiselectorEventListener_added : eventHandlerIndex
			---@field handler MultiselectorEventHandler_added Handler function to register for call

				---@alias MultiselectorEventHandler_added
				---| fun(self: MultiselectorType, toggle: toggle|selectorToggle) Called when a new toggle item is added to the selector via **selector.updatedItems(...)**<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `toggle` toggle|selectorToggle ― Reference to the toggle widget added to the selector</p>

			---@class multiselectorEventListener_limited : eventHandlerIndex
			---@field handler MultiselectorEventHandler_limited Handler function to register for call

				---@alias MultiselectorEventHandler_limited
				---| fun(self: MultiselectorType, min: boolean, max: boolean, passed: boolean) Called when a "limited" event is invoked after a limit update occurs<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `min` boolean ― True, if the number of selected items is equal to lower than the specified lower limit</p><p>@*param* `max` boolean ― True, if the number of selected items is equal to higher than the specified upper limit</p><p>@*param* `passed` boolean ― True, if the number of selected items is below or over the specified lower or upper limit</p>

			---@class multiselectorEventListener_any : eventTag, eventHandlerIndex
	---@field handler MultiselectorEventHandler_any Handler function to register for call

				---@alias MultiselectorEventHandler_any
				---| fun(self: MultiselectorType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` MultiselectorType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class multiselector
	---@field toggles (toggle|selectorToggle)[]
	---@field invoke multiselector_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener multiselector_setListener Hook a handler function as a listener for a custom widget event
	local _ = {}

		---Returns the type of this object
		---***
		---@return "Multiselector"
		---<p></p>
		function _.getType() return "Multiselector" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---@class multiselector_invoke
		local invoke = {}

			--Invoke an "enabled" event calling registered listeners
			function invoke.enabled() end

			---Invoke a "loaded" event calling registered listeners
			---@param success boolean
			function invoke.loaded(success) end

			---Invoke a "saved" event calling registered listeners
			---@param success boolean
			function invoke.saved(success) end

			---Invoke a "selected" event calling registered listeners
			---@param user boolean
			function invoke.selected(user) end

			--Invoke a "updated" event calling registered listeners
			function invoke.updated() end

			---Invoke an "added" event calling registered listeners
			---@param toggle toggle|selectorToggle
			function invoke.added(toggle) end

			---Invoke a "limited" event calling registered listeners
			---@param count integer
			function invoke.limited(count) end

			---Invoke a custom event calling registered listeners
			---@param event string Custom event tag
			---@param ... any Any number of leftover arguments passed to listeners
			function invoke._(event, ...) end

		---@class multiselector_setListener
		local setListener = {}

			---Register a listener for a "enabled" event trigger
			---@param listener MultiselectorEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---Register a listener for a "loaded" event trigger
			---@param listener MultiselectorEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---Register a listener for a "saved" event trigger
			---@param listener MultiselectorEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---Register a listener for a "selected" event trigger
			---@param listener MultiselectorEventHandler_selected Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.selected(listener, callIndex) end

			---Register a listener for a "updated" event trigger
			---@param listener MultiselectorEventHandler_updated Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.updated(listener, callIndex) end

			---Register a listener for a "added" event trigger
			---@param listener SelectorEventHandler_added Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.added(listener, callIndex) end

			---Register a listener for a "limited" event trigger
			---@param listener MultiselectorEventHandler_limited Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.limited(listener, callIndex) end

			---Register a listener for a custom event trigger
			---@param event string Custom event tag
			---@param listener SelectorEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Update the list of items currently set for the selector widget, updating its parameters and toggle widgets
		--- - ***Note:*** The size of the selector widget may change if the number of provided items differs from the number of currently set items. Make sure to rearrange and/or resize other relevant frames potentially impacted by this if needed!
		--- - ***Note:*** The currently selected item may not be the same after item were removed. In that case, the new item at the same index will be selected instead. If one or more items from the last indexes were removed, the new last item at the reduced count index will be selected. Make sure to use **selector.setSelected(...)** to correct the selection if needed!
		---***
		---@param newItems (selectorItem|toggle|selectorToggle)[] Table containing subtables with data used to update the toggle widgets, or already existing toggle widgets
		---@param silent? boolean If false, invoke "updated" or "added" events and call registered listeners | ***Default:*** `false`
		function _.updateItems(newItems, silent) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.saveData(data, silent) end

			---@class wrappedBooleanArray
			---@field states? boolean[] Indexed list of current item states in order | ***Default:*** `false`[] *(no selected items)*

		---Get the currently stored data via **t.getData()**
		---@return boolean[]|nil
		function _.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param data? wrappedBooleanArray If set, save the value wrapped in this table | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(data, handleChanges, silent) end

		---Get the currently set default value
		---@return boolean[] default
		function _.getDefault() return {} end

		---Set the default value
		---@param selections? boolean[] | ***Default:*** *no selected items: `false[]`*
		function _.setDefault(selections) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **selector.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **selector.revertData()**
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Returns the list of all items and their current states
		---***
		---@return boolean[] selections Indexed list of item states
		function _.getSelections() return {} end

		---Set the specified items as selected
		---***
		---@param selections? boolean[] Indexed list of item states | ***Default:*** *no selected items: `false[]`*
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
		function _.setSelections(selections, user, silent) end

		---Set the specified item as selected
		---***
		---@param index integer Index of the item | ***Range:*** (1, #selector.toggles)
		---@param selected? boolean If true, set the item at this index as selected | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke "selected" and "limited" events and call registered listeners | ***Default:*** `false`
		function _.setSelected(index, selected, user, silent) end

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--| Selector frames

---Create a radio button selector GUI frame to pick one out of multiple options with enhanced widget functionality
---***
---@param t? radiogroupCreationData Optional parameters
---@param selector? selector|specialSelector Reference to an already existing selector to mutate into a radio selector instead of creating a new base widget
---***
---@return radiogroup|specialRadiogroup|selector|specialSelector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
function wt.CreateRadiogroup(t, selector)

	--| Parameters

	---@class radiogroupCreationData : selectorCreationData, selectorFrameCreationData, radiogroupCreationData_base # t
	---@field width? number The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 180 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to **t.width** if **t.columns** is 1 and **t.width** is specified.</li></ul>
	---@field items? (selectorItem|selectorRadiobutton)[] Table containing subtables with data used to create item widgets, or already existing radio buttons
	---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1
	---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** `true`

		---@class selectorFrameCreationData : labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject
		---@field name? string Unique string used to set the frame name | ***Default:*** "Selector"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
		---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the selector frame and the functions to assign as event handlers called when they trigger

		---@class radiogroupCreationData_base : tooltipDescribableSettingsWidget
		---@field clearable? boolean If true, the selector input should be clearable by right clicking on its radio buttons, setting the selected value to nil | ***Default:*** `false`

	--| Returns

	---@class radiogroup : selector
	---@field frame Frame|table
	---@field label FontString|nil
	---@field toggles? selectorRadiobutton[] The list of radio button widgets linked together in this selector
	local _ = {}

		---@class selectorRadiobutton : selectorToggle, radiobutton

		---Returns all object types of this mutated widget
		---***
		---@return "Selector"
		---@return "Radiogroup"
		---<p></p>
		function _.getType() return "Selector", "Radiogroup" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end

---Create a dropdown radio button selector GUI frame to pick one out of multiple options with enhanced widget functionality
---***
---@param t? dropdownRadiogroupCreationData Optional parameters
---@param selector? selector Reference to an already existing selector to mutate into a radio selector instead of creating a new base widget
---***
---@return dropdownRadiogroup|selector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, a toggle [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
function wt.CreateDropdownRadiogroup(t, selector)

	--| Parameters

	---@class dropdownRadiogroupCreationData : radiogroupCreationData, widgetWidthValue, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** "Dropdown"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field width? number The width of the dropdown frame containing the toggle (and optionally) cycle buttons and the label (if **t.label** is true) | ***Default:*** 180
	---@field scrollThreshold? integer Number of items to show before changing the dropdown menu to be scrollable | ***Default:*** 15<ul><li>***Note:*** Scrollability does not change when the number of items change after the initial setup.</li></ul>
	---@field text? string The default text to display on the dropdown when no item is selected | ***Default:*** ""
	---@field clearable? boolean If true, the selector input should be clearable by right clicking on its radio buttons, or, if **t.utilityMenu** is false, the dropdown toggle button itself (if true, a clear selection option is added to the utility menu instead), setting the selected value to nil | ***Default:*** `false`
	---@field autoClose? boolean Close the dropdown menu after an item is selected by the user | ***Default:*** `true`
	---@field cycleButtons? boolean Add previous & next item buttons next to the dropdown | ***Default:*** `true`

		---@class widgetWidthValue
		---@field width? number ***Default:*** 180

	--| Returns

	---@class dropdownRadiogroup : radiogroup
	---@field holderFrame Frame Main holder frame for the dropdown toggle, buttons and title
	---@field menu panel Panel frame holding the dropdown selector widget
	---@field content panel
	---@field toggle customButton
	---@field previous customButton
	---@field next customButton
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "Selector"
		---@return "Radiogroup"
		---@return "DropdownRadiogroup"
		---<p></p>
		function _.getType() return "Selector", "Radiogroup", "DropdownRadiogroup" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---Set the text displayed on the label of the toggle button
		---***
		---@param text? string ***Default:*** **t.items[*index*].title** *(the title of the currently selected item)* or "…" *(if there is no selection)*
		---@param silent? boolean If false, invoke a "labeled" event and call registered listeners | ***Default:*** `false`
		function _.setText(text, silent) end

		---Toggle the dropdown menu
		---@param state? boolean ***Default:*** not **selector.list:IsVisible()**
		function _.toggleMenu(state) end

	return _
end

---Create a special radio button selector GUI frame to pick an Anchor Point, a horizontal or vertical text alignment or Frame Strata value with enhanced widget functionality
---***
---@param itemset SpecialSelectorItemset Specify what type of selector should be created
---@param t? specialRadiogroupCreationData Optional parameters
---@param selector? specialSelector|selector Reference to an already existing special selector widget to mutate into a special selector frame instead of creating a new base widget
---***
---@return specialSelector|specialRadiogroup # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
function wt.CreateSpecialRadiogroup(itemset, t, selector)

	--| Parameters

	---@class specialRadiogroupCreationData : specialSelectorCreationData, selectorFrameCreationData, radiogroupCreationData_base # t

	--| Returns

	---@class specialRadiogroup : specialSelector
	---@field frame Frame|table
	---@field label FontString|nil
	---@field toggles? selectorRadiobutton[] The list of radio button widgets linked together in this selector
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "SpecialSelector"
		---@return "SpecialRadiogroup"
		---<p></p>
		function _.getType() return "SpecialSelector", "SpecialRadiogroup" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end

---Create a checkbox selector GUI frame to pick multiple options out of a list with enhanced widget functionality
---***
---@param t? checkgroupCreationData Optional parameters
---@param selector? multiselector Reference to an already existing selector to mutate into a multiple selector instead of creating a new base widget
---***
---@return checkgroup|multiselector # References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, utility functions and more wrapped in a table
function wt.CreateCheckgroup(t, selector)

	--| Parameters

	---@class checkgroupCreationData : multiselectorCreationData, selectorFrameCreationData, tooltipDescribableSettingsWidget # t
	---@field width? number The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 160 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to **t.width** if **t.columns** is 1 and **t.width** is specified.</li></ul>
	---@field items? (selectorItem|selectorCheckbox)[] Table containing subtables with data used to create item widgets, or already existing checkboxes
	---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** `true`
	---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1

	--| Returns

	---@class checkgroup : multiselector
	---@field frame Frame|table
	---@field label FontString|nil
	---@field toggles? selectorCheckbox[] The list of checkbox widgets linked together in this selector
	local _ = {}

		---@class selectorCheckbox : selectorToggle, checkbox

		---Returns all object types of this mutated widget
		---***
		---@return "Multiselector"
		---@return "Checkgroup"
		---<p></p>
		function _.getType() return "Multiselector", "Checkgroup" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end


--[[ TEXTBOX ]]

---Create a non-GUI textbox widget with string data management logic
---***
---@param t? textboxCreationData Optional parameters
---***
---@return textbox textbox Reference to the new textbox widget, utility functions and more wrapped in a table
function wt.CreateTextbox(t)

	--| Parameters

	--Optional parameters
	---@class textboxCreationData : togglableObject, settingsWidget # t
	---@field color? color Apply the specified color to all text in the editbox (overriding all font objects set in **t.font**)
	---@field listeners? textboxEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): text: string|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `text` string|nil | ***Default:*** "" *(empty string)*</p>
	---@field saveData? fun(text: string) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `text` string</p>
	---@field value? string The starting text to be set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid
	---@field default? string Default value of the widget | ***Default:*** "" *(empty string)*

		---@class textboxEventListeners
		---@field enabled? textboxEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **textbox.setEnabled(...)** was called
		---@field loaded? textboxEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? textboxEventListener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? textboxEventListener_changed[] Ordered list of functions to call when a "changed" event is invoked after **textbox.setText(...)** was called
		---@field [string]? textboxEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class textboxEventListener_enabled : eventHandlerIndex
			---@field handler TextboxEventHandler_enabled Handler function to register for call

				---@alias TextboxEventHandler_enabled
				---| fun(self: TextboxType, state: boolean) Called when an "enabled" event is invoked after **textbox.setEnabled(...)** was called<hr><p>@*param* `self` TextboxType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

					---@alias TextboxType
					---| textbox
					---| customEditbox
					---| customEditbox
					---| multilineEditbox

			---@class textboxEventListener_loaded : eventHandlerIndex
			---@field handler TextboxEventHandler_loaded Handler function to register for call

				---@alias TextboxEventHandler_loaded
				---| fun(self: TextboxType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` TextboxType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

			---@class textboxEventListener_saved : eventHandlerIndex
			---@field handler TextboxEventHandler_saved Handler function to register for call

				---@alias TextboxEventHandler_saved
				---| fun(self: TextboxType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` TextboxType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

			---@class textboxEventListener_changed : eventHandlerIndex
			---@field handler TextboxEventHandler_changed Handler function to register for call

				---@alias TextboxEventHandler_changed
				---| fun(self: TextboxType, text: string, user: boolean) Called when an "changed" event is invoked after **textbox.setText(...)** was called<hr><p>@*param* `self` TextboxType ― Reference to the toggle widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class textboxEventListener_any : eventTag, eventHandlerIndex
			---@field handler TextboxEventHandler_any Handler function to register for call

				---@alias TextboxEventHandler_any
				---| fun(self: TextboxType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` TextboxType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class textbox
	---@field invoke textbox_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener textbox_setListener Hook a handler function as a listener for a custom widget event
	local _ = {}

		---Returns the type of this object
		---***
		---@return "Textbox"
		---<p></p>
		function _.getType() return "Textbox" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---@class textbox_invoke
		local invoke = {}

			--Invoke an "enabled" event calling registered listeners
			function invoke.enabled() end

			---Invoke a "loaded" event calling registered listeners
			---@param success boolean
			function invoke.loaded(success) end

			---Invoke a "saved" event calling registered listeners
			---@param success boolean
			function invoke.saved(success) end

			---Invoke a "changed" event calling registered listeners
			---@param user boolean
			function invoke.changed(user) end

			---Invoke a custom event calling registered listeners
			---@param event string Custom event tag
			---@param ... any Any number of leftover arguments passed to listeners
			function invoke._(event, ...) end

		---@class textbox_setListener
		local setListener = {}

			---Register a listener for a "enabled" event trigger
			---@param listener TextboxEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---Register a listener for a "loaded" event trigger
			---@param listener TextboxEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---Register a listener for a "saved" event trigger
			---@param listener TextboxEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---Register a listener for a "changed" event trigger
			---@param listener TextboxEventHandler_changed Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(listener, callIndex) end

			---Register a listener for a custom event trigger
			---@param event string Custom event tag
			---@param listener TextboxEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(text, silent) end

		---Get the currently stored data via **t.getData()**
		---@return string|nil
		function _.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param text? string Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(text, handleChanges, silent) end

		---Get the currently set default value
		---@return string default
		function _.getDefault() return "" end

		---Set the default value
		---@param text string | ***Default:*** `""`
		function _.setDefault(text) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **textbox.revertData()**
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **textbox.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Returns the current text value of the widget
		---@return string
		function _.getText() return "" end

		---Set the text value of the widget
		---***
		---@param text? string ***Default:*** ""
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _.setText(text, user, silent) end

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--| Editbox

---Create a default single-line Blizzard editbox GUI frame with enhanced widget functionality
---***
---@param t? editboxCreationData Optional parameters
---@param textbox? textbox Reference to an already existing textbox to mutate into an editbox instead of creating a new base widget
---***
---@return customEditbox|textbox # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateEditbox(t, textbox)

	--| Properties

	---@class editboxCreationData : textboxCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** "Textbox"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_editbox|sizeData
	---@field insets? insetData Table containing padding values by which to offset the position of the text in the editbox
	---@field font? labelFontOptions_editbox List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
	---@field justify? justifyData_left Set the justification of the text (overriding all font objects set in **t.font**)
	---@field charLimit? number The value to limit the character count by | ***Default:*** 0 (*no limit*)
	---@field readOnly? boolean The text will be uneditable if true | ***Default:*** `false`
	---@field focusOnShow? boolean Focus the editbox when its shown and highlight the text | ***Default:*** `false`
	---@field keepFocused? boolean Keep the editbox focused while its being shown | ***Default:*** `false`
	---@field unfocusOnEnter? boolean Whether to automatically clear the focus from the editbox when the ENTER key is pressed | ***Default:*** `true`
	---@field resetCursor? boolean If true, set the cursor position to the beginning of the string after setting the text via **textbox.setText(...)** | ***Default:*** `true`
	---@field events? table<ScriptEditBox, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the editbox frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnChar](https://warcraft.wiki.gg/wiki/UIHANDLER_OnChar)" will be called with custom parameters:<p>@*param* `self` AnyFrameObject ― Reference to the editbox frame</p><p>@*param* `char` string ― The UTF-8 character that was typed</p><p>@*param* `text` string ― The text typed into the editbox</p></li><li>***Note:*** "[OnTextChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:<p>@*param* `self` AnyFrameObject ― Reference to the editbox frame</p><p>@*param* `text` string ― The text typed into the editbox</p><p>@*param* `user` string ― True if the value was changed by the user, false if it was done programmatically</p></li><li>***Note:*** "[OnEnterPressed](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:<p>@*param* `self` AnyFrameObject ― Reference to the editbox frame</p><p>@*param* `text` string ― The text typed into the editbox</p></li></ul>

		---@class sizeData_editbox
		---@field w? number Width | ***Default:***  180
		---@field h? number Height | ***Default:*** 18

		---@class labelFontOptions_editbox
		---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** *default font based on the frame template*
		---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** *default font based on the frame template*
		---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** *default font based on the frame template*

		---@class justifyData_left
		---@field h? JustifyHorizontal Horizontal text alignment| ***Default:*** "LEFT"
		---@field v? JustifyVertical Vertical text alignment | ***Default:*** "MIDDLE"

	--| Returns

	---@class singlelineEditbox : textbox
	---@field frame Frame
	---@field widget EditBox
	---@field label FontString|nil
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "Textbox"
		---@return "Editbox"
		---<p></p>
		function _.getType() return "Textbox", "Editbox" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end

---Create a single-line Blizzard editbox frame with custom GUI and enhanced widget functionality
---***
---@param t? customEditboxCreationData Optional parameters
---@param textbox? textbox Reference to an already existing textbox to mutate into a customizable editbox instead of creating a new base widget
---***
---@return customEditbox|textbox # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateCustomEditbox(t, textbox)

	--| Properties

	---@class customEditboxCreationData : editboxCreationData, customizableObject # t

	--| Returns

	---@class customEditbox : textbox
	---@field frame Frame
	---@field widget EditBox|BackdropTemplate
	---@field label FontString|nil
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "Textbox"
		---@return "CustomEditbox"
		---<p></p>
		function _.getType() return "Textbox", "CustomEditbox" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end

---Create a default multiline Blizzard editbox GUI frame with enhanced widget functionality
---***
---@param t? multilineEditboxCreationData Optional parameters
---@param textbox? textbox Reference to an already existing textbox to mutate into a multiline editbox instead of creating a new base widget
---***
---@return multilineEditbox|textbox # Reference to the new [EditBox](hhttps://warcraft.wiki.gg/wiki/UIOBJECT_EditBox), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateMultilineEditbox(t, textbox)

	--| Parameters

	---@class multilineEditboxCreationData : editboxCreationData, scrollSpeedData # t
	---@field size? sizeData
	---@field charCount? boolean Show or hide the remaining number of characters | ***Default:*** **t.charLimit** > 0
	---@field scrollToTop? boolean Automatically scroll to the top when the text is loaded or changed while not being actively edited | ***Default:*** `false`
	---@field scrollEvents? table<ScriptScrollFrame, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the scroll frame of the editbox and the functions to assign as event handlers called when they trigger

	--| Returns

	---@class multilineEditbox : textbox
	---@field frame Frame
	---@field scrollframe InputScrollFrame
	---@field widget EditBox
	---@field label FontString|nil
	local _ = {}

		---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"InputScrollFrameTemplate"`
		---@class InputScrollFrame : ScrollFrame
		---@field ScrollBar ScrollController
		---@field EditBox EditBox
		---@field CharCount FontString

			---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"ScrollControllerMixin"`
			---@class ScrollController : Frame
			---@field panExtentPercentage number
			---@field SetPanExtentPercentage fun(panExtentPercentage: number)

		---Returns all object types of this mutated widget
		---***
		---@return "Textbox"
		---@return "MultilineEditbox"
		---<p></p>
		function _.getType() return "Textbox", "MultilineEditbox" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end

---Create a custom button with a toggled textline & editbox from which text can be copied
---***
---@param t? copyboxCreationData Optional parameters
---***
---@return copybox copybox References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), its child widgets & their custom values, utility functions and more wrapped in a table
function wt.CreateCopybox(t)

	--| Parameters

	---@class copyboxCreationData : labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject # t
	---@field name? string Unique string used to set the frame name | ***Default:*** "Copybox"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_editbox|sizeData
	---@field layer? DrawLayer
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormalSmall"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
	---@field color? color Apply the specified color to the text (overriding **t.font**)
	---@field justify? JustifyHorizontal Set the horizontal text alignment of the label (overriding **t.font**) | ***Default:*** "LEFT"
	---@field flipOnMouse? boolean Hide/Reveal the editbox on mouseover instead of after a click | ***Default:*** `false`
	---@field colorOnMouse? color If set, change the color of the text on mouseover to the specified color (if **t.flipOnMouse** is false) | ***Default:*** *no color change*
	---@field value? string The copyable text to be shown | ***Default:*** `""`

	--| Returns

	---@class copybox
	---@field frame Frame
	---@field label FontString|nil
	---@field textbox customEditbox|textbox

	return {}
end


--[[ NUMERIC ]]

---Create a non-GUI numeric widget with number data management logic
---***
---@param t? numericCreationData Optional parameters
---***
---@return numeric numeric Reference to the new numeric widget, utility functions and more wrapped in a table
function wt.CreateNumeric(t)

	--| Parameters

	--Optional parameters
	---@class numericCreationData : togglableObject, settingsWidget # t
	---@field fractional? integer If the value is fractional, display this many decimal digits | ***Default:*** *the most amount of digits present in the fractional part of* **t.min**, **t.max** *or* **t.step**
	---@field min? number Lower numeric value limit | ***Range:*** (any, **t.max**) | ***Default:*** 0
	---@field max? number Upper numeric value limit | ***Range:*** (**t.min**, any) | ***Default:*** 100
	---@field step? number Add/subtract this much when calling **numeric.increase(...)** or **numeric.decrease(...)** | ***Range:*** (> 0) | ***Default:*** 10% of range (**t.min**, **t.max**)
	---@field altStep? number If set, add/subtract this much when calling **numeric.increase(...)** or **numeric.decrease(...)** with **alt** == true | ***Range:*** (> 0) | ***Default:*** *no alternative step value*
	---@field hardStep? boolean Use **t.step** to force the slider jump to step values on drag | ***Default:*** `true`
	---@field listeners? numericEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): value: number|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `value` number|nil | ***Default:*** **t.min**</p>
	---@field saveData? fun(value: number) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `value` number</p>
	---@field value? number The starting value of the widget to set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid
	---@field default? number Default value of the widget | ***Default:*** **t.min**

		---@class numericEventListeners
		---@field enabled? numericEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **numeric.setEnabled(...)** was called
		---@field loaded? numericEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? numericEventListener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field changed? numericEventListener_changed[] Ordered list of functions to call when a "changed" event is invoked after **numeric.setNumber(...)** was called
		---@field min? numericEventListener_min[] Ordered list of functions to call when a "min" event is invoked after **numeric.setMin(...)** was called
		---@field max? numericEventListener_max[] Ordered list of functions to call when a "max" event is invoked after **numeric.setMax(...)** was called
		---@field [string]? numericEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class numericEventListener_enabled : eventHandlerIndex
			---@field handler NumericEventHandler_enabled Handler function to register for call

				---@alias NumericEventHandler_enabled
				---| fun(self: NumericType, state: boolean) Called when an "enabled" event is invoked after **numeric.setEnabled(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

					---@alias NumericType
				---| numeric
				---| customSlider

			---@class numericEventListener_loaded : eventHandlerIndex
			---@field handler NumericEventHandler_loaded Handler function to register for call

				---@alias NumericEventHandler_loaded
				---| fun(self: NumericType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` NumericType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

			---@class numericEventListener_saved : eventHandlerIndex
			---@field handler NumericEventHandler_saved Handler function to register for call

				---@alias NumericEventHandler_saved
				---| fun(self: NumericType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` NumericType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

			---@class numericEventListener_changed : eventHandlerIndex
			---@field handler NumericEventHandler_changed Handler function to register for call

				---@alias NumericEventHandler_changed
				---| fun(self: NumericType, number: number, user: boolean) Called when an "changed" event is invoked after **numeric.setNumber(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the toggle widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class numericEventListener_min : eventHandlerIndex
			---@field handler NumericEventHandler_min Handler function to register for call

				---@alias NumericEventHandler_min
				---| fun(self: NumericType, limitMin: number) Called when an "min" event is invoked after **numeric.setMin(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the toggle widget</p><p>@*param* `limitMin` number ― The current lower limit of the number value of the widget</p>

			---@class numericEventListener_max : eventHandlerIndex
			---@field handler NumericEventHandler_max Handler function to register for call

				---@alias NumericEventHandler_max
				---| fun(self: NumericType, limitMax: number) Called when an "max" event is invoked after **numeric.setMax(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the toggle widget</p><p>@*param* `limitMax` number ― The current upper limit of the number value of the widget</p>

			---@class numericEventListener_any : eventTag, eventHandlerIndex
			---@field handler NumericEventHandler_any Handler function to register for call

				---@alias NumericEventHandler_any
				---| fun(self: NumericType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` NumericType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class numeric
	---@field invoke numeric_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener numeric_setListener Hook a handler function as a listener for a custom widget event
	local _ = {}

		---Returns the type of this object
		---***
		---@return "Numeric"
		---<p></p>
		function _.getType() return "Numeric" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---@class numeric_invoke
		local invoke = {}

			--Invoke an "enabled" event calling registered listeners
			function invoke.enabled() end

			---Invoke a "loaded" event calling registered listeners
			---@param success boolean
			function invoke.loaded(success) end

			---Invoke a "saved" event calling registered listeners
			---@param success boolean
			function invoke.saved(success) end

			---Invoke a "changed" event calling registered listeners
			---@param user boolean
			function invoke.changed(user) end

			--Invoke a "min" event calling registered listeners
			function invoke.min() end

			--Invoke a "max" event calling registered listeners
			function invoke.max() end

			---Invoke a custom event calling registered listeners
			---@param event string Custom event tag
			---@param ... any Any number of leftover arguments passed to listeners
			function invoke._(event, ...) end

		---@class numeric_setListener
		local setListener = {}

			---Register a listener for a "enabled" event trigger
			---@param listener NumericEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---Register a listener for a "loaded" event trigger
			---@param listener NumericEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---Register a listener for a "saved" event trigger
			---@param listener NumericEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---Register a listener for a "changed" event trigger
			---@param listener NumericEventHandler_changed Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(listener, callIndex) end

			---Register a listener for a "min" event trigger
			---@param listener NumericEventHandler_min Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.min(listener, callIndex) end

			---Register a listener for a "max" event trigger
			---@param listener NumericEventHandler_max Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.max(listener, callIndex) end

			---Register a listener for a custom event trigger
			---@param event string Custom event tag
			---@param listener NumericEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(number, silent) end

		---Get the currently stored data via **t.getData()**
		---@return number|nil
		function _.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param number? number Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(number, handleChanges, silent) end

		---Get the currently set default value
		---@return number default
		function _.getDefault() return 0 end

		---Set the default value
		---@param number number | ***Default:*** *no change*
		function _.setDefault(number) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **numeric.revertData()**
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **numeric.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Returns the current value of the widget
		---@return number
		function _.getNumber() return 0 end

		---Set the value of the widget
		---***
		---@param number? number A valid number value within the specified **t.min**, **t.max** range | ***Default:*** **t.min**
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		function _.setNumber(number, user, silent) end

		---Decrease the value of the widget by the specified step or alt step amount
		---@param alt? boolean If true, use alt step instead of step to decrease the value by | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _.decrease(alt, user, silent) end

		---Increase the value of the widget by the specified step or alt step amount
		---@param alt? boolean If true, use alt step instead of step to increase the value by | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "changed" event and call registered listeners | ***Default:*** `false`
		function _.increase(alt, user, silent) end

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

		---Return the current lower value limit of the widget
		---@return number
		function _.getMin() return 0 end

		---Set the lower value limit of the widget
		---***
		---@param number number Updates the lower limit value | ***Range:*** (any, *current upper limit*) *capped automatically*
		---@param silent? boolean If false, invoke a "min" event and call registered listeners | ***Default:*** `false`
		function _.setMin(number, silent) end

		---Return the current upper value limit of the widget
		---@return number
		function _.getMax() return 0 end

		---Set the upper value limit of the widget
		---***
		---@param number number Updates the upper limit value | ***Range:*** (*current lower limit*, any) *floored automatically*
		---@param silent? boolean If false, invoke a "max" event and call registered listeners | ***Default:*** `false`
		function _.setMax(number, silent) end

		---Return the current value step of the widget
		---@return number
		function _.getStep() return 0 end

		---Return the current alternative value step of the widget
		---@return number|nil
		function _.getAltStep() end

	return _
end

--| Slider

---Create a Blizzard slider GUI frame with enhanced widget functionality
---***
---@param t? sliderCreationData Optional parameters
---@param numeric? numeric Reference to an already existing numeric widget to mutate into a slider instead of creating a new base widget
---***
---@return customSlider|numeric # References to the new [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), child widgets, utility functions and more wrapped in a table
function wt.CreateSlider(t, numeric)

	--| Parameters

	---@class sliderCreationData : numericCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, widgetWidthValue, visibleObject_base, liteObject, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** "Slider"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field valuebox? boolean Whether or not should the slider have an [EditBox](https://warcraft.wiki.gg/wiki/UIOBJECT_EditBox) as a child to manually enter a precise value to move the slider to | ***Default:*** `true`
	---@field events? table<ScriptSlider, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the slider frame and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnValueChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnValueChanged)" whenever the value in the slider widget is modified.</li></ul>

	--| Return

	---@class customSlider : numeric
	---@field frame Frame
	---@field widget MinimalSliderWithSteppers
	---@field valuebox customEditbox|textbox
	local _ = {}

		---NOTE: Incomplete Toolbox-relevant definition for a Frame of `"MinimalSliderWithSteppersTemplate"`
		---@class MinimalSliderWithSteppers : Slider
		---@field Slider Slider Main slider frame
		---@field Back Button Decrease value button
		---@field Forward Button Increase value button
		---@field TopText FontString Title text
		---@field MinText FontString Min value text
		---@field MaxText FontString Max value text

		---Returns all object types of this mutated widget
		---***
		---@return "Numeric"
		---@return "Slider"
		---<p></p>
		function _.getType() return "Numeric", "Slider" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end

---Create a classic Blizzard slider GUI frame with enhanced widget functionality
---***
---@param t? classicSliderCreationData Optional parameters
---@param numeric? numeric Reference to an already existing numeric widget to mutate into a slider instead of creating a new base widget
---***
---@return classicSlider|numeric # References to the new [Slider](https://warcraft.wiki.gg/wiki/UIOBJECT_Slider), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), child widgets, utility functions and more wrapped in a table
function wt.CreateClassicSlider(t, numeric)

	--| Parameters

	---@class classicSliderCreationData : sliderCreationData # t
	---@field sideButtons? boolean Whether or not to add increase/decrease buttons next to the slider to change the value by the increment set in **t.step** | ***Default:*** `true`

	--| Return

	---@class classicSlider : numeric
	---@field frame Frame
	---@field widget Slider
	---@field label FontString|nil
	---@field min FontString
	---@field max FontString
	---@field valuebox customEditbox|textbox
	---@field decreaseButton customButton|action
	---@field increaseButton customButton|action
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "Numeric"
		---@return "ClassicSlider"
		---<p></p>
		function _.getType() return "Numeric", "ClassicSlider" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end


--[[ COLOR DATA ]]

---Create a non-GUI color pick manager widget with color data management logic
---***
---@param t? colormanagerCreationData Optional parameters
---***
---@return colormanager colorer Reference to the new color pick manager widget, utility functions and more wrapped in a table
function wt.CreateColormanager(t)

	--| Parameters

	---@class colormanagerCreationData : togglableObject, settingsWidget # t
	---@field listeners? colormanagerEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field onCancel? function The function to be called when the color change is cancelled (after calling **t.onColorUpdate**)
	---@field getData? fun(): color: color|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `color` colorData|nil | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`</p>
	---@field saveData? fun(color: color) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `color` colorData</p>
	---@field value? colorData_whiteDefault Values to use as the starting color set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid<ul><li>***Note:*** If the alpha start value was not set, configure the color picker to handle RBG values exclusively instead of the full RGBA.</li></ul>
	---@field default? color Default value of the widget | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`

		---@class colormanagerEventListeners
		---@field enabled? colormanagerEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **colormanager.setEnabled(...)** was called
		---@field loaded? colormanagerEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? colormanagerEventListener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field colored? colormanagerEventListener_colored[] Ordered list of functions to call when a "colored" event is invoked after **colormanager.setColor(...)** was called
		---@field [string]? colormanagerEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class colormanagerEventListener_enabled : eventHandlerIndex
			---@field handler ColormanagerEventHandler_enabled Handler function to register for call

				---@alias ColormanagerEventHandler_enabled
				---| fun(self: ColormanagerType, state: boolean) Called when an "enabled" event is invoked after **colormanager.setEnabled(...)** was called<hr><p>@*param* `self` ColorPickerType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

					---@alias ColormanagerType
					---| colormanager
					---| colorpicker

			---@class colormanagerEventListener_loaded : eventHandlerIndex
			---@field handler ColormanagerEventHandler_loaded Handler function to register for call

				---@alias ColormanagerEventHandler_loaded
				---| fun(self: ColormanagerType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` ColorPickerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

			---@class colormanagerEventListener_saved : eventHandlerIndex
			---@field handler ColormanagerEventHandler_saved Handler function to register for call

				---@alias ColormanagerEventHandler_saved
				---| fun(self: ColormanagerType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` ColorPickerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

			---@class colormanagerEventListener_colored : eventHandlerIndex
			---@field handler ColormanagerEventHandler_colored Handler function to register for call

				---@alias ColormanagerEventHandler_colored
				---| fun(self: ColormanagerType, color: color, user: boolean) Called when an "colored" event is invoked after **colormanager.setColor(...)** was called<hr><p>@*param* `self` ColorPickerType ― Reference to the toggle widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class colormanagerEventListener_any : eventTag, eventHandlerIndex
			---@field handler ColormanagerEventHandler_any Handler function to register for call

				---@alias ColormanagerEventHandler_any
				---| fun(self: ColormanagerType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ColorPickerType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class colormanager
	---@field invoke colormanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener colormanager_setListener Hook a handler function as a listener for a custom widget event
	local _ = {}

		---Returns the type of this object
		---***
		---@return "Colormanager"
		---<p></p>
		function _.getType() return "Colormanager" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---@class colormanager_invoke
		local invoke = {}

			--Invoke an "enabled" event calling registered listeners
			function invoke.enabled() end

			---Invoke a "loaded" event calling registered listeners
			---@param success boolean
			function invoke.loaded(success) end

			---Invoke a "saved" event calling registered listeners
			---@param success boolean
			function invoke.saved(success) end

			---Invoke a "colored" event calling registered listeners
			---@param user boolean
			function invoke.colored(user) end

			---Invoke a custom event calling registered listeners
			---@param event string Custom event tag
			---@param ... any Any number of leftover arguments passed to listeners
			function invoke._(event, ...) end

		---@class colormanager_setListener
		local setListener = {}

			---Register a listener for a "enabled" event trigger
			---@param listener ColormanagerEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---Register a listener for a "loaded" event trigger
			---@param listener ColormanagerEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---Register a listener for a "saved" event trigger
			---@param listener ColormanagerEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---Register a listener for a "colored" event trigger
			---@param listener ColormanagerEventHandler_colored Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.colored(listener, callIndex) end

			---Register a listener for a custom event trigger
			---@param event string Custom event tag
			---@param listener ColormanagerEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param color? color Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(color, silent) end

		---Get the currently stored data via **t.getData()**
		---@return color|nil
		function _.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param color? color Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(color, handleChanges, silent) end

		---Get the currently set default value
		---@return color default
		function _.getDefault() return {} end

		---Set the default value
		---@param color? color | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
		function _.setDefault(color) end

		---Set and load the stored data managed by the widget to the last saved data snapshot set via **colormanager.snapshotData()**
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.revertData(handleChanges, silent) end

		---Set a data snapshot so any changes made to the widget and/or the stored data can be reverted to this value via **colormanager.revertData()**
		---@param stored? boolean If true, use the data from storage to create the snapshot instead of using the current widget value | ***Default:*** `false`
		function _.snapshotData(stored) end

		---Set and load the stored data managed by the widget to the default value specified via **t.default** at construction
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.resetData(handleChanges, silent) end

		---Returns the currently set channel values wrapped in a color table
		---@return color
		function _.getColor() return {} end

		---Set the managed color values
		---***
		---@param color? color ***Default:*** { r = 1, g = 1, b = 1, a = 1 } *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "colored" event and call registered listeners | ***Default:*** `false`
		function _.setColor(color, user, silent) end

		---Open the the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) for this color manager
		function _.openColorPicker() end

		---Return the active status of this color manager, whether the main color wheel window was opened for and is currently updating the color of this widget
		---@return boolean active True, if the color wheel has been opened for this color manager widget
		function _.isActive() return false end

		--| State

		---Return the current enabled state of the widget
		---@return boolean enabled True, if the widget is enabled
		function _.isEnabled() return false end

		---Enable or disable the widget based on the specified value
		---***
		---@param state? boolean Enable the input if true, disable if not | ***Default:*** `true`
		---@param silent? boolean If false, invoke an "enabled" event and call registered listeners | ***Default:*** `false`
		function _.setEnabled(state, silent) end

	return _
end

--| Color Picker

---Create a color picker GUI frame with HEX(A) & RGB(A) input while utilizing the [ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame) wheel
---***
---@param t? colorpickerCreationData Optional parameters
---@param colormanager? colormanager Reference to an already existing color data manager to mutate into a colorpicker instead of creating a new base widget
---***
---@return colorpicker|colormanager # Reference to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
function wt.CreateColorpicker(t, colormanager)

	--| Properties

	---@class colorpickerCreationData : colormanagerCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** "Colorpicker"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field width? number The height is defaulted to 36, the width may be specified | ***Default:*** 120
	---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the color picker frame and the functions to assign as event handlers called when they trigger

	--| Returns

	---@class colorpicker : colormanager
	---@field frame Frame
	---@field label FontString|nil
	---@field button colorpickerButton|customButton|action
	---@field hexBox customEditbox|textbox
	local _ = {}

		---Button to open the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) with
		---@class colorpickerButton : customButton
		---@field gradient Texture
		---@field checker Texture

		---Returns all object types of this mutated widget
		---***
		---@return "Colormanager"
		---@return "Colorpicker"
		---<p></p>
		function _.getType() return "Colormanager", "Colorpicker" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

	return _
end


--[[ POSITION DATA ]]

---Create and set up position management for a specified frame within a panel frame
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param frame AnyFrameObject Reference to the frame to create the settings for
---@param getData fun(): table: positionPresetData|table Return a reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to
---@param defaultData positionPresetData|table Reference to the table containing the default values<ul><li>***Note:*** The defaults table should contain values under matching keys to the values within *t.getData()*.</li></ul>
---@param settingsData positionOptionsSettingsData|table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>***Note:*** A boolean value will be created under the key **keepInPlace** if it didn't already exist in this table.</li></ul>
---@param t positionManagementCreationData Optional parameters
---***
---@return positionPanel? table Components of the settings panel wrapped in a table | ***Default:*** nil
function wt.CreatePositionOptions(addon, frame, getData, defaultData, settingsData, t)

	--| Parameters

	---@class positionPresetData # defaultData
	---@field position positionData Table of parameters to call **frame**:[SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
	---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** `false`
	---@field layer? widgetLayerOptions Table containing the screen layer parameters of the frame

		---@class widgetLayerOptions
		---@field strata? FrameStrata Strata to pin the frame to
		---@field level? integer The level of the frame to appear in within the specified strata
		---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** `false`

	---@class positionOptionsSettingsData # settingsData
	---@field keepInPlace boolean If true, don't move **frame** when changing the anchor, update the offset values instead.

	---@class positionManagementCreationData : settingsWidgetPanel_frame
	---@field presets? presetItemList Reference to the table containing **frame** position presets to be managed by settings widgets added when set
	---@field setMovable? movabilityData_position When specified, set **frame** as movable, dynamically updating the position settings widgets when it's moved by the user
	---@field dataManagement? settingsData_position Register the widgets to settings data management to be linked with the specified key under the specified category
	---@field onChangePosition? function Function to call after the value of **panel.widgets.position.anchor**, **panel.widgets.position.relativeTo**, **panel.widgets.position.relativePoint**, **panel.widgets.position.offset.x** or **panel.widgets.position.offset.y** was changed by the user or via settings data management before the base onChange handler is called built-in to the functionality of the settings panel template updating the position of **frame**
	---@field onChangeKeepInBounds? function Function to call after the value of **panel.widgets.position.keepInBounds** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **frame**
	---@field onChangeStrata? function Function to call after the value of **panel.widgets.layer.strata** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **frame**
	---@field onChangeLevel? function Function to call after the value of **panel.widgets.layer.level** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **frame**
	---@field onChangeKeepOnTop? function Function to call after the value of **panel.widgets.layer.keepOnTop** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **frame**

		---@class settingsWidgetPanel_frame : settingsWidgetPanel_base
		---@field name? string Refer to **frame** by this display name in the tooltips and descriptions of settings widgets | ***Default:*** **frame:GetName()**

			---@class settingsWidgetPanel_base
			---@field canvas Frame The canvas frame child item of an existing settings category page to add the panel to
			---@field dependencies? dependencyRule[] Automatically disable or enable all widgets in the new panel based on the rules described in subtables

		---@class presetItemList
		---@field items positionPresetItemData[] Table containing the dropdown items described within subtables
		---@field onPreset? fun(preset?: positionPresetItemData, index?: integer) Called after a preset is selected and applied via the dropdown widget or by calling **applyPreset**
		---@field custom? customPositionPresetData When set, add widgets to manage a user-modifiable custom preset

			---@class positionPresetItemData
			---@field title string Text to represent the item within the dropdown frame
			---@field tooltip? presetTooltipTextData List of text lines to be added to the tooltip of the item in the dropdown displayed when mousing over it or the menu toggle button
			---@field onSelect? function The function to be called when the dropdown item is selected before the specific preset is applied
			---@field data? positionPresetData|table Table containing the preset data to be modified by the position settings widgets and applied to **frame** on demand

				---@class presetTooltipTextData : tooltipTextData
				---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** **t.presets.items[*index*].title**

			---@class customPositionPresetData
			---@field index? integer Index of the custom preset modifiable by the user | ***Default:*** 1
			---@field getData fun(): positionPresetData|table Return a reference to the table within the SavedVariables(PerCharacter) addon database where the custom preset data is committed to when the custom preset is saved
			---@field defaultsTable positionPresetData|table Reference to the table containing the default custom preset values<ul>
			---@field onSave? function Called after saving the custom preset
			---@field onReset? function Called after resetting the custom preset before it is applied

		---@class movabilityData_position : movabilityData
		---@field modifier? ModifierKey|any The specific (or any) modifier key required to be pressed down to move **frame** (if **frame** has the "OnUpdate" script defined) | ***Default:*** "SHIFT"<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://warcraft.wiki.gg/wiki/API_IsModifierKeyDown) is used.</li></ul>

		---@class settingsData_position : settingsData_base
		---@field key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "Position"

	--| Returns

	---@class positionPanel
	---@field frame panel
	---@field widgets table
	---@field presets? table
	local _ = {}

		---Returns the type of this object
		---***
		---@return "PositionOptions" string
		---<p></p>
		function _.getType() return "PositionOptions" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---Apply a specific preset
		--- - ***Note:*** If the addon database position table doesn't contain relative frame and point key, value pairs, the position will be converted to absolute position after being applied.
		---***
		---@param i integer Index of the preset to be applied
		---***
		---@return boolean success Whether or not the preset under the specified index exists and it could be applied
		function _.applyPreset(i) return false end

		---Save the current position & visibility to the custom preset
		--- - ***Note:*** If the custom preset position data doesn't contain relative frame and point key, value pairs, the position will be converted to absolute position when saved.
		function _.saveCustomPreset() end

		--Reset the custom preset to its default state
		function _.resetCustomPreset() end
end


--[[ FONT DATA ]]

---Create and set up font management for a specified text object ([FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString)) including access to a font family selector dropdown to pick a custom font from the Widget Tools fonts list
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param textline FontString Reference to the text object to create font options for
---@param getData fun(): table: fontOptionsData Return a reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to
---@param defaultData fontOptionsData Reference to the table containing the default values
---@param t fontManagementCreationData Optional parameters
---***
---@return fontPanel? table References to the new [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), an array of its child [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton) widget items, a toggle [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table | ***Default:*** nil
function wt.CreateFontOptions(addon, textline, getData, defaultData, t)

	--| Parameters

	---@class fontOptionsData # defaultData
	---@field path string Path to the font file relative to the WoW client directory<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Fonts/Font.ttf), otherwise use `\\`.</li><li>***Note:*** **File format:** Font files must be in TTF or OTF format.</li></ul>
	---@field size number Font size
	---@field alignment JustifyHorizontal Horizontal text alignment
	---@field colors table<string, color>|textColorData_base List of named coloring options<ul><li>***Note:*** The default color of key "base" will be added if it's missing.</ul></li>

		---@class textColorData_base
		---@field base color

	---@class fontManagementCreationData : settingsWidgetPanel_text # t
	---@field colors? table<string, textColorInfo> Use this list of specifications to dictate what colors appear and how: their order and displayed name | ***Default:*** *none*<ul><li>***Note:*** If set, the default color of key "base" will be added if it's missing.</ul></li>
	---@field dataManagement? settingsData_font Register the widgets to settings data management to be linked with the specified key under the specified category
	---@field onChangeFont? function Function to call after the value of **panel.widgets.path** or **panel.widgets.size** was changed by the user or via settings data management before the base onChange handler is called built-in to the functionality of the settings panel template updating the position of **text**
	---@field onChangeSize? function Function to call after the value of **panel.widgets.position.keepInBounds** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **text**
	---@field onChangeAlignment? function Function to call after the value of **panel.widgets.layer.strata** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **text**
	---@field onChangeColor? fun(color: string) Function to call after the value of **panel.widgets.layer.level** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **text**

		---@class settingsWidgetPanel_text : settingsWidgetPanel_base
		---@field name? string Refer to **text** by this display name in the tooltips and descriptions of settings widgets | ***Default:*** **text:GetName()**

		---@class textColorInfo
		---@field index? integer Ordering index of the color | ***Default:*** *unspecified*
		---@field name? string Display name to set their widget and tooltip titles paired to their data management keys | ***Default:*** *data management key in Title case*
		---@field wrap? boolean If true, wrap the list of colors at this color (stasrting this one in a new row) | ***Default:*** **index** == 1

		---@class settingsData_font : settingsData_base
		---@field key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "Font"

	--| Returns

	---@class fontPanel
	---@field widgets table
	---@field frame Frame|panel
	local _ = {}

		---Returns the type of this object
		---***
		---@return "FontOptions" string
		---<p></p>
		function _.getType() return "FontOptions" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end
end


--[[ PROFILE DATA ]]

---Create a non-GUI profile data manager widget with live database management and profile selection logic
---***
---@param accountData profileStorage|table Reference to the account-bound SavedVariables addon database where profile data is to be stored<ul><li>***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).</li></ul>
---@param characterData characterProfileData|table Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified<ul><li>***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.</li></ul>
---@param defaultData table A static table containing all default settings values to be cloned when creating a new profile or resetting one
---@param t? profilemanagerCreationData Optional parameters
---***
---@return profilemanager? profilemanager Reference to the new profile data manager widget, utility functions and more wrapped in a table | ***Default:*** nil
function wt.CreateProfilemanager(accountData, characterData, defaultData, t)

	--| Parameters

	---@class profileStorage # accountData
	---@field profiles profile[] List of profiles

		---@class profile
		---@field title string Display name of the profile
		---@field data table Custom profile data

	---@class characterProfileData # characterData
	---@field activeProfile integer The index of the currently active profile | ***Default:*** 1

	---@class profilemanagerCreationData # t
	---@field category? string Category name to be used for identifying this group of profile data when modified in popups and chat messages | ***Default:*** `"Addon"`
	---@field valueChecker? fun(key: number|string, value: any): boolean Helper function for validating values when checking profile data, returning true if the value is to be accepted as valid
	---@field recoveryMap? table<string, recoveryData>|fun(tableToCheck: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>|nil Static map or function returning a dynamically creatable map for removed but recoverable data
	---@field onRecovery? fun(tableToCheck: table) Function called after the data has been has been recovered via the **recoveryMap**
	---@field listeners? profilemanagerEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class recoveryData
		---@field saveTo table List of references to the tables to save the recovered piece of data to
		---@field saveKey string|number Save the data under this kay within the specified recovery tables
		---@field convertSave? fun(recovered: any): converted: any Function to convert or modify the recovered old data before it is saved

			---@class recoveredData
			---@field keyChain string Chain of keys that used to point to the removed data<ul><li>***Example:*** `"keyOne[2].keyThree.keyFour[1]"`.</li></ul>
			---@field data any Recoverable piece of removed data

		---@class profilemanagerEventListeners
		---@field loaded? profilemanagerEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data profile list has been loaded and verified
		---@field activated? profilemanagerEventListener_activated[] Ordered list of functions to call when an "activated" event is invoked after a profile has been activated
		---@field created? profilemanagerEventListener_created[] Ordered list of functions to call when a "created" event is invoked after a new data profile has been initialized
		---@field renamed? profilemanagerEventListener_renamed[] Ordered list of functions to call when a "renamed" event is invoked after a data profile has been renamed
		---@field deleted? profilemanagerEventListener_deleted[] Ordered list of functions to call when a "deleted" event is invoked after a data profile has been removed from the database
		---@field reset? profilemanagerEventListener_reset[] Ordered list of functions to call when a "reset" event is invoked after a data profile has been reset to defaults
		---@field [string]? profilemanagerEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class profilemanagerEventListener_loaded : eventHandlerIndex
			---@field handler ProfilemanagerEventHandler_loaded Handler function to register for call

				---@alias ProfilemanagerEventHandler_loaded
				---| fun(self: ProfilemanagerType, user: boolean) Called when an "loaded" event is invoked after the data profile list has been loaded and verified<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

					---@alias ProfilemanagerType
					---| profilemanager
					---| profilesPage

			---@class profilemanagerEventListener_activated : eventHandlerIndex
			---@field handler ProfilemanagerEventHandler_activated Handler function to register for call

				---@alias ProfilemanagerEventHandler_activated
				---| fun(self: ProfilemanagerType, index: integer, title: string, success: boolean, user: boolean) Called when an "activated" event is invoked after a profile has been activated<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `index` integer — The index of the active profile</p><p>@*param* `title` string — The title of the active profile</p><p>@*param* `success` boolean ― True if the active profile was changed successfully</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanagerEventListener_created : eventHandlerIndex
			---@field handler ProfilemanagerEventHandler_created Handler function to register for call

				---@alias ProfilemanagerEventHandler_created
				---| fun(self: ProfilemanagerType, index: integer, title: string, user: boolean) Called when an "created" event is invoked after a new data profile has been initialized<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `index` integer — The index of the new profile</p><p>@*param* `title` string — The title of the new profile</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanagerEventListener_renamed : eventHandlerIndex
			---@field handler ProfilemanagerEventHandler_renamed Handler function to register for call

				---@alias ProfilemanagerEventHandler_renamed
				---| fun(self: ProfilemanagerType, success: boolean, index: any, title?: string, user: boolean) Called when an "renamed" event is invoked after a data profile has been renamed<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile was renamed successfully</p><p>@*param* `index` any — The index of the profile attempted to be renamed</p><p>@*param* `title`? string — The new title of the profile attempted to be renamed</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanagerEventListener_deleted : eventHandlerIndex
			---@field handler ProfilemanagerEventHandler_deleted Handler function to register for call

				---@alias ProfilemanagerEventHandler_deleted
				---| fun(self: ProfilemanagerType, success: boolean, index: any, title?: string, user: boolean) Called when an "deleted" event is invoked after a data profile has been removed from the database<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile was deleted successfully</p><p>@*param* `index` any — The original index of the profile attempted to be deleted</p><p>@*param* `title`? string — The title of the  profile attempted to be deleted</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanagerEventListener_reset : eventHandlerIndex
			---@field handler ProfilemanagerEventHandler_reset Handler function to register for call

				---@alias ProfilemanagerEventHandler_reset
				---| fun(self: ProfilemanagerType, success: boolean, index: any, title?: string, user: boolean) Called when an "reset" event is invoked after a data profile has been reset to defaults<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile data was reset successfully</p><p>@*param* `index` any — The index of the profile attempted to be reset</p><p>@*param* `title`? string — The title of the profile attempted to be reset</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

			---@class profilemanagerEventListener_any : eventTag, eventHandlerIndex
			---@field handler ProfilemanagerEventHandler_any Handler function to register for call

				---@alias ProfilemanagerEventHandler_any
				---| fun(self: ProfilemanagerType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

	--| Returns

	---@class profilemanager
	---@field data table Reference to live data table of the currently active profile
	---@field firstLoad boolean True, if the `accountData.profiles` table did not exist yet
	---@field newCharacter boolean True, if the `characterData.activeProfile` integer did not exist yet
	---@field invoke profilemanager_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener profilemanager_setListener Hook a handler function as a listener for a custom widget event
	local _ = {}

		---Returns the type of this object
		---***
		---@return "Profilemanager"
		---<p></p>
		function _.getType() return "Profilemanager" end

		---Checks and returns if the type of this object is equal to the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end

		---@class profilemanager_invoke
		local invoke = {}

			---Invoke a "loaded" event calling registered listeners
			---@param user boolean
			function invoke.loaded(user) end

			---Invoke an "activated" event calling registered listeners
			---@param success boolean
			---@param user boolean
			function invoke.activated(success, user) end

			---Invoke a "created" event calling registered listeners
			---@param index integer
			---@param title string
			---@param user boolean
			function invoke.created(index, title, user) end

			---Invoke a "renamed" event calling registered listeners
			---@param success boolean
			---@param user boolean
			---@param index any
			---@param title? string
			function invoke.renamed(success, user, index, title) end

			---Invoke a "deleted" event calling registered listeners
			---@param success boolean
			---@param user boolean
			---@param index any
			---@param title? string
			function invoke.deleted(success, user, index, title) end

			---Invoke a "reset" event calling registered listeners
			---@param success boolean
			---@param user boolean
			---@param index any
			---@param title? string
			function invoke.reset(success, user, index, title) end

			---Invoke a custom event calling registered listeners
			---@param event string Custom event tag
			---@param ... any Any number of leftover arguments passed to listeners
			function invoke._(event, ...) end

		---@class profilemanager_setListener
		local setListener = {}

			---Register a listener for a "loaded" event trigger
			---@param listener ProfilemanagerEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---Register a listener for an "activated" event trigger
			---@param listener ProfilemanagerEventHandler_activated Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.activated(listener, callIndex) end

			---Register a listener for a "created" event trigger
			---@param listener ProfilemanagerEventHandler_created Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.created(listener, callIndex) end

			---Register a listener for a "renamed" event trigger
			---@param listener ProfilemanagerEventHandler_renamed Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.renamed(listener, callIndex) end

			---Register a listener for a "deleted" event trigger
			---@param listener ProfilemanagerEventHandler_deleted Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.deleted(listener, callIndex) end

			---Register a listener for a "reset" event trigger
			---@param listener ProfilemanagerEventHandler_reset Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.reset(listener, callIndex) end

			---Register a listener for a custom event trigger
			---@param event string Custom event tag
			---@param listener ProfilemanagerEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Activate the specified settings profile
		---***
		---@param index? integer Index of the profile to set as the currently active settings profile | ***Default:*** *currently active profile index* or `1`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "applied" event and call registered listeners | ***Default:*** `false`
		---***
		---@return integer? index The index of the active profile | ***Default:*** `nil`
		function _.activate(index, user, silent) end

		---Find a profile by its display title and return its index
		---***
		---@param title string Name of the profile to find
		---@param skipFirst? boolean Set to `true` to find duplicate `title` | ***Default:*** `false`
		---@return integer? index
		function _.findIndex(title, skipFirst) end

		---Create a new settings profile
		---***
		---@param name? string Name tag to use when setting the display title of the new profile | ***Default:*** `duplicate` and **accountData.profiles[duplicate].title** or "Profile"
		---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** 2
		---@param duplicate? integer Index of the profile to create the new profile as a duplicate of instead of using default data values
		---@param apply? boolean Whether to immediately set the new profile as the active profile or not | ***Default:*** `true`
		---@param index? integer Place the new profile under this specified index in **accountData.profile** instead of the end of the list | ***Range:*** (1, #**accountData.profiles** + 1)
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "created" event and call registered listeners | ***Default:*** `false`
		function _.create(name, number, duplicate, index, apply, user, silent) end

		---Rename the specified profile
		---@param index? integer Index of the profile to rename | ***Default:*** *currently active profile index*
		---@param name? string The new title of the profile to set | ***Default:*** "Profile"
		---@param number? integer Starting value for the incremented number appended to `name` if it's used | ***Default:*** 2
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "renamed" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # True on success, false if the operation failed
		function _.rename(index, name, number, user, silent) return false end

		---Delete the specified profile
		---***
		---@param index? integer Index of the profile to delete | ***Default:*** *currently active profile index*
		---@param unsafe? boolean If false, show a popup confirmation before attempting to delete the specified profile | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "deleted" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # True on success, false if the operation failed
		function _.delete(index, unsafe, user, silent) return false end

		---Reset the specified profile data to default values
		---***
		---@param index? integer Index of the profile to restore to defaults | ***Default:*** *currently active profile index*
		---@param unsafe? boolean If false, show a popup confirmation before attempting to reset the specified profile | ***Default:*** `false`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "reset" event and call registered listeners | ***Default:*** `false`
		---***
		---@return boolean # True on success, false if the operation failed
		function _.reset(index, unsafe, user, silent) return false end

		---Check & fix a profile data table based on the specified sample profile
		---***
		---@param profileData table Profile data table to check
		---@param compareWith? table  Profile data table to sample | ***Default:*** `defaultData`
		---***
		---@return table profileData Reference to `profileData` (it was already updated during the operation, no need for setting it again)
		function _.validate(profileData, compareWith) return {} end

		---Load profiles data
		---***
		---@param p? profileStorage Table holding the list of profiles to store | ***Default:*** *validate* **accountData** *(if the data is missing or invalid, set up a default profile)*
		---@param activeProfile? integer Index of the active profile to set | ***Default:*** *currently active profile index*
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke an "loaded" event and call registered listeners | ***Default:*** `false`
		function _.load(p, activeProfile, user, silent) end

	return _
end

--| Profiles Page

---Create and set up a new settings page with profile data handling and advanced backup management options
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param accountData profileStorage|table Reference to the account-bound SavedVariables addon database where profile data is to be stored<ul><li>***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).</li></ul>
---@param characterData characterProfileData|table Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified<ul><li>***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.</li></ul>
---@param defaultData table A static table containing all default settings values to be cloned when creating a new profile or resetting one
---@param settingsData backupboxSettingsData|table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>***Note:*** A boolean value will be created under the key `compactBackup` if it didn't already exist in this table.</li></ul>
---@param t? profilesPageCreationData Optional parameters
---@param profilemanager? profilemanager Reference to an already existing profile data manager to mutate into a profile management settings page instead of creating a new base widget
---***
---@return profilemanager|profilesPage? profilesPage Table containing references to the settings page, settings widgets grouped in subtables and utility functions by category | ***Default:*** nil
function wt.CreateProfilesPage(addon, accountData, characterData, defaultData, settingsData, t, profilemanager)

	--| Parameters

	---@class backupboxSettingsData # settingsData
	---@field compactBackup boolean Whether to skip including additional white spaces to the backup string for more readability

	---@class profilesPageCreationData : profilemanagerCreationData, settingsPageCreationData_base, settingsPageEvents, liteObject # t
	---@field name? string Unique string used to set the name of the canvas frame | ***Default:*** "Profiles"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field title? string Text to be shown as the title of the settings page | ***Default:*** "Data Management"
	---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** *describing profiles & backup*
	---@field onImport? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for the currently active profile<hr><p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>
	---@field onImportAllProfiles? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for all profiles<p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>

	--| Returns

	---@class profilesPage : profilemanager
	---@field settings settingsPage
	---@field widgets? table Collection of profiles settings widgets
	---@field backup? table Collection of backup settings widgets
	---@field backupAll? table Collection of all profiles backup settings widgets
	local _ = {}

		---Returns all object types of this mutated widget
		---***
		---@return "Profilemanager"
		---@return "ProfilesPage"
		---<p></p>
		function _.getType() return "Profilemanager", "ProfilesPage" end

		---Checks and returns if the a type of this mutated widget matches the string provided
		---@param type string|AnyTypeName
		---@return boolean
		---<p></p>
		function _.isType(type) return false end
end


--[[ ADDON INFO ]]

---Create and set up a new settings page with about into for an addon
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param t? aboutPageCreationData Optional parameters
---***
---@return settingsPage|nil aboutPage Table containing references to the canvas [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), category page and utility functions | ***Default:*** nil
function wt.CreateAboutPage(addon, t)

	--| Parameters

	---@class aboutPageCreationData : settingsPageCreationData_base # t
	---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** [GetAddOnMetadata(**addon**, "Notes")](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata)
	---@field changelog? { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included<ul><li>***Note:*** The first line is expected to be the title containing the version number and/or the date of release.</li><li>***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).</li><li>***Examples:***<ul><li>**Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)</li><li>**Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
	---@field static? boolean If true, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** `true`
end