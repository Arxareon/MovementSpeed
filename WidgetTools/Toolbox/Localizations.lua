--[[ NAMESPACE ]]

---@class WidgetToolsNamespace
local ns = select(2, ...)


--[[ INITIALIZATION ]]

if not ns.WidgetToolboxInitialization then return end

---@class wt
local wt = ns.WidgetToolbox


--[[ LOCALIZATIONS (WoW locales: https://warcraft.wiki.gg/wiki/API_GetLocale#Values) ]]

wt.localizations = {}

--TODO: verity AI translations (from enUS)
--TODO: adjust the date formats for the translated languages

--# flags will be replaced by text or number values via code
--\n represents the newline character

--[ English ]

---@class toolboxStrings
wt.localizations.enUS = {
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
		revert = "Revert Changes",
		restore = "Restore Default",
		note = "Right-click to reset or revert changes.",
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
	date = "#MONTH/#DAY/#YEAR",
	override = "Override",
	example = "Example",
	separator = ",", --Thousand separator character
	decimal = ".", --Decimal character
}

--[ Portuguese (Brazil) ]

---@class toolboxStrings
wt.localizations.ptBR = {
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
		revert = "Reverter Alterações",
		restore = "Restaurar Padrão",
		note = "Clique com o botão direito para redefinir ou reverter alterações.",
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
	date = "#DAY/#MONTH/#YEAR",
	override = "Sobrescrever",
	example = "Exemplo",
	separator = ".", -- Separador de milhar
	decimal = ",", -- Caractere decimal
}

--[ German ]

---@class toolboxStrings
wt.localizations.deDE = {
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
		revert = "Änderungen verwerfen",
		restore = "Standard wiederherstellen",
		note = "Rechtsklick zum Zurücksetzen oder Verwerfen von Änderungen.",
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
	date = "#DAY.#MONTH.#YEAR",
	override = "Überschreiben",
	example = "Beispiel",
	separator = ".", -- Tausendertrennzeichen
	decimal = ",", -- Dezimalzeichen
}

--[ French ]

---@class toolboxStrings
wt.localizations.frFR = {
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
		revert = "Annuler les modifications",
		restore = "Restaurer la valeur par défaut",
		note = "Clic droit pour réinitialiser ou annuler les modifications.",
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
	date = "#DAY/#MONTH/#YEAR",
	override = "Écraser",
	example = "Exemple",
	separator = " ", -- Séparateur de milliers
	decimal = ",", -- Caractère décimal
}

--[ Spanish (Spain) ]

---@class toolboxStrings
wt.localizations.esES = {
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
		revert = "Revertir Cambios",
		restore = "Restaurar Predeterminado",
		note = "Haz clic derecho para restablecer o revertir cambios.",
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
	date = "#DAY/#MONTH/#YEAR",
	override = "Sobrescribir",
	example = "Ejemplo",
	separator = ".", -- Separador de miles
	decimal = ",", -- Carácter decimal
}

--[ Spanish (Mexico) ]

---@class toolboxStrings
wt.localizations.esMX = {
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
		revert = "Revertir Cambios",
		restore = "Restaurar Predeterminado",
		note = "Haz clic derecho para restablecer o revertir cambios.",
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
	date = "#DAY/#MONTH/#YEAR",
	override = "Sobrescribir",
	example = "Ejemplo",
	separator = ".", -- Separador de miles
	decimal = ",", -- Carácter decimal
}

--[ Italian ]

---@class toolboxStrings
wt.localizations.itIT = {
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
		revert = "Annulla modifiche",
		restore = "Ripristina predefinito",
		note = "Clic destro per reimpostare o annullare le modifiche.",
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
	date = "#DAY/#MONTH/#YEAR",
	override = "Sovrascrivi",
	example = "Esempio",
	separator = ".", -- Separatore delle migliaia
	decimal = ",", -- Carattere decimale
}

--[ Korean ]

---@class toolboxStrings
wt.localizations.koKR = {
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
		revert = "변경 사항 되돌리기",
		restore = "기본값 복원",
		note = "오른쪽 클릭으로 초기화 또는 변경 사항 되돌리기.",
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
	date = "#YEAR년 #MONTH월 #DAY일",
	override = "덮어쓰기",
	example = "예시",
	separator = ",", -- 천 단위 구분자
	decimal = ".", -- 소수점 문자
}

--[ Chinese (traditional, Taiwan) ]

---@class toolboxStrings
wt.localizations.zhTW = {
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
		revert = "還原變更",
		restore = "恢復預設",
		note = "右鍵點擊可重設或還原變更。",
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
	date = "#YEAR/#MONTH/#DAY",
	override = "覆蓋",
	example = "範例",
	separator = ",", -- 千分位分隔符號
	decimal = ".", -- 小數點符號
}

--[ Chinese (simplified, PRC) ]

---@class toolboxStrings
wt.localizations.zhCN = {
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
		revert = "撤销更改",
		restore = "恢复默认",
		note = "右键点击以重置或撤销更改。",
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
	date = "#YEAR/#MONTH/#DAY",
	override = "覆盖",
	example = "示例",
	separator = ",", -- 千位分隔符
	decimal = ".", -- 小数点符号
}

--[ Russian ]

---@class toolboxStrings
wt.localizations.ruRU = {
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
		revert = "Отменить изменения",
		restore = "Восстановить по умолчанию",
		note = "Щёлкните правой кнопкой мыши для сброса или отмены изменений.",
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
	date = "#DAY.#MONTH.#YEAR",
	override = "Перезаписать",
	example = "Пример",
	separator = " ", -- Разделитель тысяч
	decimal = ",", -- Десятичный разделитель
}