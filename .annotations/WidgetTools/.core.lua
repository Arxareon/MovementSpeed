--NOTE: Annotations are for development purposes only, providing documentation for use with LUA Language Server. This file does not need to be loaded by the game client.


--[[ LOCALIZATIONS ]]

---English
---@class widgetToolsStrings_enUS
local enUS = {
	about = {
		version = "Version: #VERSION",
		date = "Date: #DATE",
		author = "Author: #AUTHOR",
		license = "License: #LICENSE",
		toggle = {
			label = "Enabled",
			tooltip = "Uncheck to disable this addon.\n\nThis change will only take effect after the interface is reloaded. Once it has been disabled, this addon will not show up in this list until it's reenabled within the main AddOns menu.",
		},
	},
	specifications = {
		title = "Specifications",
		description = "Tune & toggle select optional features. Type /wt in chat to use chat commands.",
		general = {
			title = "General",
			description = "Options affecting all reliant addons.",
			lite = {
				label = "Lite Mode",
				tooltip = "Disable the settings of ALL addons using Widget Toolboxes to conserve resources and make the interface load faster.\nAddon settings data will still be saved & loaded in the background, and chat control will remain available for addons that use it.\n\nTo turn Lite Mode off and settings back on, use the #COMMAND chat command, or click on Widget Tools within the AddOns list under the calendar button in the header of the Minimap (not available in Classic)",
			},
			positioningAids = {
				label = "Positioning Visual Aids",
				tooltip = "Display visual aids when positioning frames wia settings widgets of addons which use Widget Toolboxes under the hood.",
			},
		},
		dev = {
			title = "Development Tools",
			debugging = {
				enabled = {
					label = "Debugging Mode",
					tooltip = "Toggle to create, save and print debugging log entries to the chat window.",
				},
			},
			frameAttributes = {
				enabled = {
					label = "Resize Frame Attributes",
					tooltip = "Customize the width of the table inside the Frame Attributes window (TableAttributeDisplay Frame).",
				},
				width = {
					label = "Frame Attributes Width",
					tooltip = "Specify the width of the scrollable content table in the Frame Attributes window.",
				},
			},
		},
	},
	addons = {
		title = "Toolboxes & Addons",
		description = "The list of currently loaded addons using specific versions of registered #ADDON toolboxes.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Click to open specific settings.",
		lite = "Lite mode is enabled. Click to disable.",
	},
	lite = {
		enable = {
			warning = "When #ADDON is in Lite Mode, the settings UI for dependant addons will not be loaded.\n\nAre you sure you want to turn on Lite Mode and disable full settings functionality?",
			accept = "Enable Lite Mode",
		},
		disable = {
			warning = "#ADDON is in Lite Mode, the settings UI for dependant addons have not been loaded.\n\nDo you wish to turn off Lite Mode to reenable settings with full functionality?",
			accept = "Disable Lite Mode",
		},
	},
	chat = {
		about = {
			description = "Open the Widget Tools about page",
		},
		lite = {
			description = "Toggle Lite Mode: to load dependant addon settings or not",
			response = "Lite Mode will be #STATE after the interface is reloaded.",
			reminder = "Lite Mode is enabled, settings for dependant addons have not been loaded.\n#HINT",
			hint = "Type #COMMAND to disable Lite Mode.",
		},
		debug = {
			description = "Toggle Debugging Mode: save and display debug logs in chat",
			response = "Debugging will be #STATE after the interface is reloaded.",
			hint = "Type #COMMAND to disable Debugging Mode.",
		},
	},
	separator = ",", --Thousand separator character
	decimal = ".", --Decimal character
}

---Portuguese (Brazil)
---@class widgetToolsStrings_ptBR
local ptBR = {
	about = {
		version = "Versão: #VERSION",
		date = "Data: #DATE",
		author = "Autor: #AUTHOR",
		license = "Licença: #LICENSE",
		toggle = {
			label = "Ativado",
			tooltip = "Desmarque para desativar este addon.\n\nEsta alteração só terá efeito após a interface ser recarregada. Uma vez desativado, este addon não aparecerá nesta lista até ser reativado no menu principal de AddOns.",
		},
	},
	specifications = {
		title = "Especificações",
		description = "Ajuste e ative/desative recursos opcionais. Digite /wt no chat para usar comandos.",
		general = {
			title = "Geral",
			description = "Opções que afetam todos os addons dependentes.",
			lite = {
				label = "Modo Lite",
				tooltip = "Desativa as configurações de TODOS os addons que usam Widget Toolboxes para economizar recursos e tornar o carregamento da interface mais rápido.\nOs dados das configurações dos addons ainda serão salvos e carregados em segundo plano, e o controle via chat permanecerá disponível para addons que o utilizam.\n\nPara desativar o Modo Lite e reativar as configurações, use o comando de chat #COMMAND ou clique em Widget Tools na lista de AddOns sob o botão de calendário no cabeçalho do Minimap (não disponível no Classic).",
			},
			positioningAids = {
				label = "Auxílios Visuais de Posicionamento",
				tooltip = "Exibe auxílios visuais ao posicionar quadros via widgets de configurações de addons que usam Widget Toolboxes.",
			},
		},
		dev = {
			title = "Ferramentas de Desenvolvimento",
			frameAttributes = {
				enabled = {
					label = "Redimensionar Atributos do Quadro",
					tooltip = "Personalize a largura da tabela dentro da janela de Atributos do Quadro (Frame TableAttributeDisplay).",
				},
				width = {
					label = "Largura dos Atributos do Quadro",
					tooltip = "Especifique a largura da tabela de conteúdo rolável na janela de Atributos do Quadro.",
				},
			},
		},
	},
	addons = {
		title = "Toolboxes & Addons",
		description = "Lista dos addons atualmente carregados usando versões específicas das toolboxes #ADDON registradas.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Clique para abrir configurações específicas.",
		lite = "Modo Lite está ativado. Clique para desativar.",
	},
	lite = {
		enable = {
			warning = "Quando #ADDON está no Modo Lite, a interface de configurações dos addons dependentes não será carregada.\n\nTem certeza de que deseja ativar o Modo Lite e desabilitar a funcionalidade completa das configurações?",
			accept = "Ativar Modo Lite",
		},
		disable = {
			warning = "#ADDON está no Modo Lite, a interface de configurações dos addons dependentes não foi carregada.\n\nDeseja desativar o Modo Lite para reativar as configurações com funcionalidade completa?",
			accept = "Desativar Modo Lite",
		},
	},
	chat = {
		about = {
			description = "Abrir a página sobre o Widget Tools",
		},
		lite = {
			description = "Alternar Modo Lite: carregar ou não as configurações dos addons dependentes",
			response = "O Modo Lite será #STATE após a interface ser recarregada.",
			reminder = "Modo Lite está ativado, as configurações dos addons dependentes não foram carregadas.\n#HINT",
			hint = "Digite #COMMAND para desativar o Modo Lite.",
		},
	},
	separator = ".", -- Separador de milhar
	decimal = ",", -- Caractere decimal
}

---German
---@class widgetToolsStrings_deDE
local deDE = {
	about = {
		version = "Version: #VERSION",
		date = "Datum: #DATE",
		author = "Autor: #AUTHOR",
		license = "Lizenz: #LICENSE",
		toggle = {
			label = "Aktiviert",
			tooltip = "Deaktivieren, um dieses Addon auszuschalten.\n\nDiese Änderung wird erst nach einem Neuladen der Benutzeroberfläche wirksam. Sobald es deaktiviert wurde, erscheint dieses Addon nicht mehr in dieser Liste, bis es im Haupt-AddOns-Menü wieder aktiviert wird.",
		},
	},
	specifications = {
		title = "Spezifikationen",
		description = "Wähle und passe optionale Funktionen an. Gib /wt im Chat ein, um Chatbefehle zu verwenden.",
		general = {
			title = "Allgemein",
			description = "Optionen, die alle abhängigen Addons betreffen.",
			lite = {
				label = "Lite-Modus",
				tooltip = "Deaktiviert die Einstellungen ALLER Addons, die Widget Toolboxes verwenden, um Ressourcen zu sparen und das Laden der Oberfläche zu beschleunigen.\nAddoneinstellungen werden weiterhin im Hintergrund gespeichert und geladen, und die Chatsteuerung bleibt für Addons verfügbar, die sie nutzen.\n\nUm den Lite-Modus zu deaktivieren und die Einstellungen wieder zu aktivieren, verwende den Chatbefehl #COMMAND oder klicke auf Widget Tools in der AddOns-Liste unter dem Kalender-Button im Minimap-Header (nicht verfügbar in Classic).",
			},
			positioningAids = {
				label = "Positionierungshilfen",
				tooltip = "Zeigt visuelle Hilfen beim Positionieren von Frames über Einstellungs-Widgets von Addons, die Widget Toolboxes verwenden.",
			},
		},
		dev = {
			title = "Entwicklertools",
			frameAttributes = {
				enabled = {
					label = "Frame-Attribute skalieren",
					tooltip = "Passe die Breite der Tabelle im Fenster Frame-Attribute (TableAttributeDisplay Frame) an.",
				},
				width = {
					label = "Breite der Frame-Attribute",
					tooltip = "Gib die Breite der scrollbaren Inhaltstabelle im Fenster Frame-Attribute an.",
				},
			},
		},
	},
	addons = {
		title = "Toolboxes & Addons",
		description = "Liste der aktuell geladenen Addons, die bestimmte Versionen registrierter #ADDON-Toolboxes verwenden.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Klicken, um spezifische Einstellungen zu öffnen.",
		lite = "Lite-Modus ist aktiviert. Klicken zum Deaktivieren.",
	},
	lite = {
		enable = {
			warning = "Wenn #ADDON im Lite-Modus ist, wird die Einstellungsoberfläche für abhängige Addons nicht geladen.\n\nBist du sicher, dass du den Lite-Modus aktivieren und die vollständige Einstellungsfunktionalität deaktivieren möchtest?",
			accept = "Lite-Modus aktivieren",
		},
		disable = {
			warning = "#ADDON ist im Lite-Modus, die Einstellungsoberfläche für abhängige Addons wurde nicht geladen.\n\nMöchtest du den Lite-Modus deaktivieren, um die Einstellungen mit voller Funktionalität wieder zu aktivieren?",
			accept = "Lite-Modus deaktivieren",
		},
	},
	chat = {
		about = {
			description = "Öffnet die Widget Tools Info-Seite",
		},
		lite = {
			description = "Lite-Modus umschalten: Einstellungen abhängiger Addons laden oder nicht",
			response = "Der Lite-Modus wird nach dem Neuladen der Oberfläche #STATE sein.",
			reminder = "Lite-Modus ist aktiviert, Einstellungen für abhängige Addons wurden nicht geladen.\n#HINT",
			hint = "Gib #COMMAND ein, um den Lite-Modus zu deaktivieren.",
		},
	},
	separator = ".", -- Tausendertrennzeichen
	decimal = ",", -- Dezimalzeichen
}

---French
---@class widgetToolsStrings_frFR
local frFR = {
	about = {
		version = "Version : #VERSION",
		date = "Date : #DATE",
		author = "Auteur : #AUTHOR",
		license = "Licence : #LICENSE",
		toggle = {
			label = "Activé",
			tooltip = "Décochez pour désactiver cet addon.\n\nCe changement ne prendra effet qu'après le rechargement de l'interface. Une fois désactivé, cet addon n'apparaîtra plus dans cette liste jusqu'à ce qu'il soit réactivé dans le menu principal des AddOns.",
		},
	},
	specifications = {
		title = "Spécifications",
		description = "Ajustez et activez/désactivez certaines fonctionnalités optionnelles. Tapez /wt dans le chat pour utiliser les commandes.",
		general = {
			title = "Général",
			description = "Options affectant tous les addons dépendants.",
			lite = {
				label = "Mode Léger",
				tooltip = "Désactive les paramètres de TOUS les addons utilisant Widget Toolboxes pour économiser des ressources et accélérer le chargement de l'interface.\nLes données de configuration des addons seront toujours sauvegardées et chargées en arrière-plan, et le contrôle par chat restera disponible pour les addons qui l'utilisent.\n\nPour désactiver le Mode Léger et réactiver les paramètres, utilisez la commande de chat #COMMAND ou cliquez sur Widget Tools dans la liste des AddOns sous le bouton calendrier dans l'en-tête de la Minicarte (non disponible en Classic).",
			},
			positioningAids = {
				label = "Aides Visuelles de Positionnement",
				tooltip = "Affiche des aides visuelles lors du positionnement des cadres via les widgets de configuration des addons utilisant Widget Toolboxes.",
			},
		},
		dev = {
			title = "Outils de Développement",
			frameAttributes = {
				enabled = {
					label = "Redimensionner les attributs du cadre",
					tooltip = "Personnalisez la largeur du tableau dans la fenêtre des Attributs du Cadre (TableAttributeDisplay Frame).",
				},
				width = {
					label = "Largeur des attributs du cadre",
					tooltip = "Spécifiez la largeur du tableau de contenu défilant dans la fenêtre des Attributs du Cadre.",
				},
			},
		},
	},
	addons = {
		title = "Toolboxes & Addons",
		description = "Liste des addons actuellement chargés utilisant des versions spécifiques des toolboxes #ADDON enregistrées.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Cliquez pour ouvrir les paramètres spécifiques.",
		lite = "Le mode Léger est activé. Cliquez pour désactiver.",
	},
	lite = {
		enable = {
			warning = "Lorsque #ADDON est en Mode Léger, l'interface des paramètres pour les addons dépendants ne sera pas chargée.\n\nÊtes-vous sûr de vouloir activer le Mode Léger et désactiver la fonctionnalité complète des paramètres ?",
			accept = "Activer le Mode Léger",
		},
		disable = {
			warning = "#ADDON est en Mode Léger, l'interface des paramètres pour les addons dépendants n'a pas été chargée.\n\nVoulez-vous désactiver le Mode Léger pour réactiver les paramètres avec toutes les fonctionnalités ?",
			accept = "Désactiver le Mode Léger",
		},
	},
	chat = {
		about = {
			description = "Ouvre la page À propos de Widget Tools",
		},
		lite = {
			description = "Activer/désactiver le Mode Léger : charger ou non les paramètres des addons dépendants",
			response = "Le Mode Léger sera #STATE après le rechargement de l'interface.",
			reminder = "Le Mode Léger est activé, les paramètres des addons dépendants n'ont pas été chargés.\n#HINT",
			hint = "Tapez #COMMAND pour désactiver le Mode Léger.",
		},
	},
	separator = " ", -- Séparateur de milliers
	decimal = ",", -- Caractère décimal
}

---Spanish (Spain)
---@class widgetToolsStrings_esES
local esES = {
	about = {
		version = "Versión: #VERSION",
		date = "Fecha: #DATE",
		author = "Autor: #AUTHOR",
		license = "Licencia: #LICENSE",
		toggle = {
			label = "Activado",
			tooltip = "Desmarca para desactivar este addon.\n\nEste cambio solo tendrá efecto después de recargar la interfaz. Una vez desactivado, este addon no aparecerá en esta lista hasta que se vuelva a activar en el menú principal de AddOns.",
		},
	},
	specifications = {
		title = "Especificaciones",
		description = "Ajusta y activa/desactiva funciones opcionales. Escribe /wt en el chat para usar comandos.",
		general = {
			title = "General",
			description = "Opciones que afectan a todos los addons dependientes.",
			lite = {
				label = "Modo Lite",
				tooltip = "Desactiva la configuración de TODOS los addons que usan Widget Toolboxes para ahorrar recursos y hacer que la interfaz cargue más rápido.\nLos datos de configuración de los addons seguirán guardándose y cargándose en segundo plano, y el control por chat seguirá disponible para los addons que lo usen.\n\nPara desactivar el Modo Lite y volver a activar la configuración, usa el comando de chat #COMMAND o haz clic en Widget Tools en la lista de AddOns bajo el botón del calendario en la cabecera del Minimapa (no disponible en Classic).",
			},
			positioningAids = {
				label = "Ayudas Visuales de Posicionamiento",
				tooltip = "Muestra ayudas visuales al posicionar marcos mediante los widgets de configuración de addons que usan Widget Toolboxes.",
			},
		},
		dev = {
			title = "Herramientas de Desarrollo",
			frameAttributes = {
				enabled = {
					label = "Redimensionar atributos del marco",
					tooltip = "Personaliza el ancho de la tabla dentro de la ventana de Atributos del Marco (TableAttributeDisplay Frame).",
				},
				width = {
					label = "Ancho de los atributos del marco",
					tooltip = "Especifica el ancho de la tabla de contenido desplazable en la ventana de Atributos del Marco.",
				},
			},
		},
	},
	addons = {
		title = "Toolboxes y Addons",
		description = "Lista de los addons actualmente cargados que usan versiones específicas de las toolboxes #ADDON registradas.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Haz clic para abrir configuraciones específicas.",
		lite = "El modo Lite está activado. Haz clic para desactivar.",
	},
	lite = {
		enable = {
			warning = "Cuando #ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se cargará.\n\n¿Seguro que quieres activar el Modo Lite y desactivar la funcionalidad completa de la configuración?",
			accept = "Activar Modo Lite",
		},
		disable = {
			warning = "#ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se ha cargado.\n\n¿Deseas desactivar el Modo Lite para volver a activar la configuración con funcionalidad completa?",
			accept = "Desactivar Modo Lite",
		},
	},
	chat = {
		about = {
			description = "Abre la página de información de Widget Tools",
		},
		lite = {
			description = "Alternar Modo Lite: cargar o no la configuración de los addons dependientes",
			response = "El Modo Lite estará #STATE después de recargar la interfaz.",
			reminder = "El Modo Lite está activado, la configuración de los addons dependientes no se ha cargado.\n#HINT",
			hint = "Escribe #COMMAND para desactivar el Modo Lite.",
		},
	},
	separator = ".", -- Separador de miles
	decimal = ",", -- Carácter decimal
}

---Spanish (Mexico)
---@class widgetToolsStrings_esMX
local esMX = {
	about = {
		version = "Versión: #VERSION",
		date = "Fecha: #DATE",
		author = "Autor: #AUTHOR",
		license = "Licencia: #LICENSE",
		toggle = {
			label = "Activado",
			tooltip = "Desmarca para desactivar este addon.\n\nEste cambio solo tendrá efecto después de recargar la interfaz. Una vez desactivado, este addon no aparecerá en esta lista hasta que se vuelva a activar en el menú principal de AddOns.",
		},
	},
	specifications = {
		title = "Especificaciones",
		description = "Ajusta y activa/desactiva funciones opcionales. Escribe /wt en el chat para usar comandos.",
		general = {
			title = "General",
			description = "Opciones que afectan a todos los addons dependientes.",
			lite = {
				label = "Modo Lite",
				tooltip = "Desactiva la configuración de TODOS los addons que usan Widget Toolboxes para ahorrar recursos y hacer que la interfaz cargue más rápido.\nLos datos de configuración de los addons seguirán guardándose y cargándose en segundo plano, y el control por chat seguirá disponible para los addons que lo usen.\n\nPara desactivar el Modo Lite y volver a activar la configuración, usa el comando de chat #COMMAND o haz clic en Widget Tools en la lista de AddOns bajo el botón del calendario en la cabecera del Minimapa (no disponible en Classic).",
			},
			positioningAids = {
				label = "Ayudas Visuales de Posicionamiento",
				tooltip = "Muestra ayudas visuales al posicionar marcos mediante los widgets de configuración de addons que usan Widget Toolboxes.",
			},
		},
		dev = {
			title = "Herramientas de Desarrollo",
			frameAttributes = {
				enabled = {
					label = "Redimensionar atributos del marco",
					tooltip = "Configura el ancho de la tabla dentro de la ventana de Atributos del Marco (TableAttributeDisplay Frame).",
				},
				width = {
					label = "Ancho de los atributos del marco",
					tooltip = "Especifica el ancho de la tabla de contenido desplazable en la ventana de Atributos del Marco.",
				},
			},
		},
	},
	addons = {
		title = "Toolboxes y Addons",
		description = "Lista de los addons actualmente cargados que usan versiones específicas de las toolboxes #ADDON registradas.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Haz clic para abrir configuraciones específicas.",
		lite = "El modo Lite está activado. Haz clic para desactivar.",
	},
	lite = {
		enable = {
			warning = "Cuando #ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se cargará.\n\n¿Seguro que quieres activar el Modo Lite y desactivar la funcionalidad completa de la configuración?",
			accept = "Activar Modo Lite",
		},
		disable = {
			warning = "#ADDON está en Modo Lite, la interfaz de configuración de los addons dependientes no se ha cargado.\n\n¿Deseas desactivar el Modo Lite para volver a activar la configuración con funcionalidad completa?",
			accept = "Desactivar Modo Lite",
		},
	},
	chat = {
		about = {
			description = "Abre la página de información de Widget Tools",
		},
		lite = {
			description = "Alternar Modo Lite: cargar o no la configuración de los addons dependientes",
			response = "El Modo Lite estará #STATE después de recargar la interfaz.",
			reminder = "El Modo Lite está activado, la configuración de los addons dependientes no se ha cargado.\n#HINT",
			hint = "Escribe #COMMAND para desactivar el Modo Lite.",
		},
	},
	separator = ".", -- Separador de miles
	decimal = ",", -- Carácter decimal
}

---Italian
---@class widgetToolsStrings_itIT
local itIT = {
	about = {
		version = "Versione: #VERSION",
		date = "Data: #DATE",
		author = "Autore: #AUTHOR",
		license = "Licenza: #LICENSE",
		toggle = {
			label = "Abilitato",
			tooltip = "Deseleziona per disabilitare questo addon.\n\nQuesta modifica avrà effetto solo dopo il ricaricamento dell'interfaccia. Una volta disabilitato, questo addon non apparirà in questo elenco finché non verrà riabilitato dal menu principale AddOns.",
		},
	},
	specifications = {
		title = "Specifiche",
		description = "Regola e attiva/disattiva funzionalità opzionali. Digita /wt in chat per usare i comandi.",
		general = {
			title = "Generale",
			description = "Opzioni che influenzano tutti gli addon dipendenti.",
			lite = {
				label = "Modalità Lite",
				tooltip = "Disabilita le impostazioni di TUTTI gli addon che usano Widget Toolboxes per risparmiare risorse e velocizzare il caricamento dell'interfaccia.\nI dati delle impostazioni degli addon saranno comunque salvati e caricati in background, e il controllo tramite chat rimarrà disponibile per gli addon che lo utilizzano.\n\nPer disattivare la Modalità Lite e riattivare le impostazioni, usa il comando chat #COMMAND o clicca su Widget Tools nell'elenco AddOns sotto il pulsante calendario nell'intestazione della Minimap (non disponibile in Classic).",
			},
			positioningAids = {
				label = "Aiuti Visivi di Posizionamento",
				tooltip = "Mostra aiuti visivi quando si posizionano i frame tramite i widget delle impostazioni degli addon che usano Widget Toolboxes.",
			},
		},
		dev = {
			title = "Strumenti di Sviluppo",
			frameAttributes = {
				enabled = {
					label = "Ridimensiona Attributi del Frame",
					tooltip = "Personalizza la larghezza della tabella nella finestra Attributi del Frame (Frame TableAttributeDisplay).",
				},
				width = {
					label = "Larghezza Attributi del Frame",
					tooltip = "Specifica la larghezza della tabella di contenuto scorrevole nella finestra Attributi del Frame.",
				},
			},
		},
	},
	addons = {
		title = "Toolboxes & Addon",
		description = "Elenco degli addon attualmente caricati che usano versioni specifiche delle toolboxes #ADDON registrate.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Clicca per aprire impostazioni specifiche.",
		lite = "Modalità Lite abilitata. Clicca per disabilitare.",
	},
	lite = {
		enable = {
			warning = "Quando #ADDON è in Modalità Lite, l'interfaccia delle impostazioni per gli addon dipendenti non verrà caricata.\n\nSei sicuro di voler attivare la Modalità Lite e disabilitare la piena funzionalità delle impostazioni?",
			accept = "Abilita Modalità Lite",
		},
		disable = {
			warning = "#ADDON è in Modalità Lite, l'interfaccia delle impostazioni per gli addon dipendenti non è stata caricata.\n\nVuoi disattivare la Modalità Lite per riabilitare le impostazioni con piena funzionalità?",
			accept = "Disabilita Modalità Lite",
		},
	},
	chat = {
		about = {
			description = "Apri la pagina informazioni di Widget Tools",
		},
		lite = {
			description = "Attiva/disattiva Modalità Lite: caricare o meno le impostazioni degli addon dipendenti",
			response = "La Modalità Lite sarà #STATE dopo il ricaricamento dell'interfaccia.",
			reminder = "La Modalità Lite è abilitata, le impostazioni per gli addon dipendenti non sono state caricate.\n#HINT",
			hint = "Digita #COMMAND per disabilitare la Modalità Lite.",
		},
	},
	separator = ".", -- Separatore delle migliaia
	decimal = ",", -- Carattere decimale
}

---Korean
---@class widgetToolsStrings_koKR
local koKR = {
	about = {
		version = "버전: #VERSION",
		date = "날짜: #DATE",
		author = "작성자: #AUTHOR",
		license = "라이선스: #LICENSE",
		toggle = {
			label = "사용함",
			tooltip = "이 애드온을 비활성화하려면 체크를 해제하세요.\n\n이 변경 사항은 인터페이스를 다시 불러온 후에만 적용됩니다. 비활성화되면, 이 애드온은 메인 AddOns 메뉴에서 다시 활성화하기 전까지 이 목록에 표시되지 않습니다.",
		},
	},
	specifications = {
		title = "사양",
		description = "선택적 기능을 조정 및 전환합니다. 채팅창에 /wt를 입력하여 명령어를 사용할 수 있습니다.",
		general = {
			title = "일반",
			description = "모든 의존 애드온에 영향을 주는 옵션입니다.",
			lite = {
				label = "라이트 모드",
				tooltip = "모든 Widget Toolboxes를 사용하는 애드온의 설정을 비활성화하여 리소스를 절약하고 인터페이스 로딩 속도를 높입니다.\n애드온 설정 데이터는 백그라운드에서 계속 저장 및 불러오며, 채팅 제어는 해당 기능을 사용하는 애드온에서 계속 사용할 수 있습니다.\n\n라이트 모드를 끄고 설정을 다시 활성화하려면 #COMMAND 채팅 명령어를 사용하거나, 미니맵 헤더의 달력 버튼 아래 AddOns 목록에서 Widget Tools를 클릭하세요(클래식에서는 사용 불가).",
			},
			positioningAids = {
				label = "위치 시각 보조",
				tooltip = "Widget Toolboxes를 사용하는 애드온의 설정 위젯을 통해 프레임을 배치할 때 시각적 보조 도구를 표시합니다.",
			},
		},
		dev = {
			title = "개발 도구",
			frameAttributes = {
				enabled = {
					label = "프레임 속성 크기 조절",
					tooltip = "프레임 속성 창(TableAttributeDisplay Frame) 내부의 테이블 너비를 사용자 지정합니다.",
				},
				width = {
					label = "프레임 속성 너비",
					tooltip = "프레임 속성 창의 스크롤 가능한 콘텐츠 테이블의 너비를 지정하세요.",
				},
			},
		},
	},
	addons = {
		title = "툴박스 & 애드온",
		description = "등록된 #ADDON 툴박스의 특정 버전을 사용하는 현재 로드된 애드온 목록입니다.",
		toolbox = "툴박스 (#VERSION)",
	},
	compartment = {
		open = "클릭하여 특정 설정을 엽니다.",
		lite = "라이트 모드가 활성화됨. 클릭하여 비활성화.",
	},
	lite = {
		enable = {
			warning = "#ADDON이 라이트 모드일 때, 의존 애드온의 설정 UI가 로드되지 않습니다.\n\n정말로 라이트 모드를 켜고 전체 설정 기능을 비활성화하시겠습니까?",
			accept = "라이트 모드 활성화",
		},
		disable = {
			warning = "#ADDON이 라이트 모드이며, 의존 애드온의 설정 UI가 로드되지 않았습니다.\n\n라이트 모드를 꺼서 전체 기능의 설정을 다시 활성화하시겠습니까?",
			accept = "라이트 모드 비활성화",
		},
	},
	chat = {
		about = {
			description = "Widget Tools 정보 페이지 열기",
		},
		lite = {
			description = "라이트 모드 전환: 의존 애드온 설정을 불러올지 여부",
			response = "인터페이스를 다시 불러온 후 라이트 모드는 #STATE 상태가 됩니다.",
			reminder = "라이트 모드가 활성화되어 의존 애드온의 설정이 로드되지 않았습니다.\n#HINT",
			hint = "#COMMAND를 입력하여 라이트 모드를 비활성화하세요.",
		},
	},
	separator = ",", -- 천 단위 구분자
	decimal = ".", -- 소수점 문자
}

---Chinese (traditional, Taiwan)
---@class widgetToolsStrings_zhTW
local zhTW = {
	about = {
		version = "版本：#VERSION",
		date = "日期：#DATE",
		author = "作者：#AUTHOR",
		license = "授權：#LICENSE",
		toggle = {
			label = "已啟用",
			tooltip = "取消勾選以停用此插件。\n\n此變更僅會在重新載入介面後生效。一旦停用，此插件將不會出現在此清單中，直到在主插件選單中重新啟用為止。",
		},
	},
	specifications = {
		title = "規格",
		description = "調整並切換選用功能。輸入 /wt 於聊天中以使用指令。",
		general = {
			title = "一般",
			description = "影響所有相依插件的選項。",
			lite = {
				label = "精簡模式",
				tooltip = "停用所有使用 Widget Toolboxes 插件的設定，以節省資源並加快介面載入速度。\n插件設定資料仍會在背景儲存與載入，且使用聊天控制的插件仍可使用該功能。\n\n若要關閉精簡模式並重新啟用設定，請使用 #COMMAND 聊天指令，或點擊小地圖標頭下方日曆按鈕旁的 AddOns 清單中的 Widget Tools（經典版無法使用）。",
			},
			positioningAids = {
				label = "定位視覺輔助",
				tooltip = "當使用採用 Widget Toolboxes 的插件設定元件定位框架時，顯示視覺輔助工具。",
			},
		},
		dev = {
			title = "開發工具",
			frameAttributes = {
				enabled = {
					label = "調整框架屬性大小",
					tooltip = "自訂框架屬性視窗（TableAttributeDisplay Frame）內表格的寬度。",
				},
				width = {
					label = "框架屬性寬度",
					tooltip = "指定框架屬性視窗中可捲動內容表格的寬度。",
				},
			},
		},
	},
	addons = {
		title = "工具箱與插件",
		description = "目前已載入並使用已註冊 #ADDON 工具箱特定版本的插件清單。",
		toolbox = "工具箱（#VERSION）",
	},
	compartment = {
		open = "點擊以開啟特定設定。",
		lite = "精簡模式已啟用。點擊以停用。",
	},
	lite = {
		enable = {
			warning = "當 #ADDON 處於精簡模式時，相依插件的設定介面將不會載入。\n\n確定要啟用精簡模式並停用完整設定功能嗎？",
			accept = "啟用精簡模式",
		},
		disable = {
			warning = "#ADDON 處於精簡模式，相依插件的設定介面尚未載入。\n\n是否要關閉精簡模式並重新啟用完整設定功能？",
			accept = "停用精簡模式",
		},
	},
	chat = {
		about = {
			description = "開啟 Widget Tools 關於頁面",
		},
		lite = {
			description = "切換精簡模式：是否載入相依插件設定",
			response = "介面重新載入後，精簡模式將會是 #STATE。",
			reminder = "精簡模式已啟用，相依插件設定尚未載入。\n#HINT",
			hint = "輸入 #COMMAND 以停用精簡模式。",
		},
	},
	separator = ",", -- 千分位分隔符號
	decimal = ".", -- 小數點符號
}

---Chinese (simplified, PRC)
---@class widgetToolsStrings_zhCN
local zhCN = {
	about = {
		version = "版本：#VERSION",
		date = "日期：#DATE",
		author = "作者：#AUTHOR",
		license = "许可证：#LICENSE",
		toggle = {
			label = "已启用",
			tooltip = "取消勾选以禁用此插件。\n\n此更改仅在重新加载界面后生效。禁用后，此插件将不会出现在此列表中，直到在主插件菜单中重新启用。",
		},
	},
	specifications = {
		title = "规格",
		description = "调整并切换可选功能。在聊天中输入 /wt 使用聊天命令。",
		general = {
			title = "通用",
			description = "影响所有依赖插件的选项。",
			lite = {
				label = "精简模式",
				tooltip = "禁用所有使用 Widget Toolboxes 的插件设置，以节省资源并加快界面加载速度。\n插件设置数据仍会在后台保存和加载，使用聊天控制的插件依然可用。\n\n要关闭精简模式并重新启用设置，请使用 #COMMAND 聊天命令，或点击小地图标题栏日历按钮下方的 AddOns 列表中的 Widget Tools（经典服不可用）。",
			},
			positioningAids = {
				label = "定位视觉辅助",
				tooltip = "在通过使用 Widget Toolboxes 的插件设置组件定位框体时显示视觉辅助。",
			},
		},
		dev = {
			title = "开发工具",
			frameAttributes = {
				enabled = {
					label = "调整框体属性大小",
					tooltip = "自定义框体属性窗口（TableAttributeDisplay Frame）内表格的宽度。",
				},
				width = {
					label = "框体属性宽度",
					tooltip = "指定框体属性窗口中可滚动内容表格的宽度。",
				},
			},
		},
	},
	addons = {
		title = "工具箱与插件",
		description = "当前已加载并使用已注册 #ADDON 工具箱特定版本的插件列表。",
		toolbox = "工具箱（#VERSION）",
	},
	compartment = {
		open = "点击以打开特定设置。",
		lite = "精简模式已启用。点击以禁用。",
	},
	lite = {
		enable = {
			warning = "当 #ADDON 处于精简模式时，依赖插件的设置界面将不会加载。\n\n确定要启用精简模式并禁用完整设置功能吗？",
			accept = "启用精简模式",
		},
		disable = {
			warning = "#ADDON 处于精简模式，依赖插件的设置界面尚未加载。\n\n是否要关闭精简模式并重新启用完整设置功能？",
			accept = "禁用精简模式",
		},
	},
	chat = {
		about = {
			description = "打开 Widget Tools 关于页面",
		},
		lite = {
			description = "切换精简模式：是否加载依赖插件设置",
			response = "界面重新加载后，精简模式将为 #STATE。",
			reminder = "精简模式已启用，依赖插件设置尚未加载。\n#HINT",
			hint = "输入 #COMMAND 以禁用精简模式。",
		},
	},
	separator = ",", -- 千位分隔符
	decimal = ".", -- 小数点符号
}

---Russian
---@class widgetToolsStrings_ruRU
local ruRU = {
	about = {
		version = "Версия: #VERSION",
		date = "Дата: #DATE",
		author = "Автор: #AUTHOR",
		license = "Лицензия: #LICENSE",
		toggle = {
			label = "Включено",
			tooltip = "Снимите галочку, чтобы отключить этот аддон.\n\nИзменения вступят в силу только после перезагрузки интерфейса. После отключения этот аддон не будет отображаться в этом списке, пока вы не включите его снова в главном меню AddOns.",
		},
	},
	specifications = {
		title = "Спецификации",
		description = "Настройте и включайте/отключайте дополнительные функции. Введите /wt в чате для использования команд.",
		general = {
			title = "Общие",
			description = "Опции, влияющие на все зависимые аддоны.",
			lite = {
				label = "Лёгкий режим",
				tooltip = "Отключает настройки ВСЕХ аддонов, использующих Widget Toolboxes, чтобы сэкономить ресурсы и ускорить загрузку интерфейса.\nДанные настроек аддонов всё равно будут сохраняться и загружаться в фоновом режиме, а управление через чат останется доступным для аддонов, которые его используют.\n\nЧтобы отключить Лёгкий режим и вернуть настройки, используйте команду чата #COMMAND или кликните по Widget Tools в списке AddOns под кнопкой календаря в заголовке миникарты (недоступно в Classic).",
			},
			positioningAids = {
				label = "Визуальные помощники позиционирования",
				tooltip = "Показывать визуальные подсказки при позиционировании фреймов через виджеты настроек аддонов, использующих Widget Toolboxes.",
			},
		},
		dev = {
			title = "Инструменты разработчика",
			frameAttributes = {
				enabled = {
					label = "Изменить размер атрибутов фрейма",
					tooltip = "Настройте ширину таблицы внутри окна атрибутов фрейма (TableAttributeDisplay Frame).",
				},
				width = {
					label = "Ширина атрибутов фрейма",
					tooltip = "Укажите ширину прокручиваемой таблицы содержимого в окне атрибутов фрейма.",
				},
			},
		},
	},
	addons = {
		title = "Toolboxes и Аддоны",
		description = "Список загруженных аддонов, использующих определённые версии зарегистрированных #ADDON toolboxes.",
		toolbox = "Toolbox (#VERSION)",
	},
	compartment = {
		open = "Нажмите, чтобы открыть определённые настройки.",
		lite = "Лёгкий режим включён. Нажмите, чтобы отключить.",
	},
	lite = {
		enable = {
			warning = "Когда #ADDON в Лёгком режиме, интерфейс настроек для зависимых аддонов не будет загружен.\n\nВы уверены, что хотите включить Лёгкий режим и отключить полную функциональность настроек?",
			accept = "Включить Лёгкий режим",
		},
		disable = {
			warning = "#ADDON в Лёгком режиме, интерфейс настроек для зависимых аддонов не был загружен.\n\nХотите отключить Лёгкий режим и вернуть полную функциональность настроек?",
			accept = "Отключить Лёгкий режим",
		},
	},
	chat = {
		about = {
			description = "Открыть страницу о Widget Tools",
		},
		lite = {
			description = "Переключить Лёгкий режим: загружать ли настройки зависимых аддонов",
			response = "Лёгкий режим будет #STATE после перезагрузки интерфейса.",
			reminder = "Лёгкий режим включён, настройки зависимых аддонов не были загружены.\n#HINT",
			hint = "Введите #COMMAND, чтобы отключить Лёгкий режим.",
		},
	},
	separator = " ", -- Разделитель тысяч
	decimal = ",", -- Десятичный разделитель
}


--[[ NAMESPACE ]]

---Addon namespace table
---@class addonNamespace
local ns = select(2, ...)


--[[ GLOBAL TOOLS ]]

---Global read-only Widget Tools table
---@class widgetTools
---@field resources widgetToolsResources
---@field utilities widgetToolsUtilities
---@field debugging widgetToolsDebugging
---@field toolboxes widgetToolsToolboxes
WidgetTools = {}

	---Shared resources
	---@class widgetToolsResources
	---@field addon string Addon namespace name: `"WidgetTools"`
	---@field title string Addon display title: `"Widget Tools"`
	---@field root string Addon root folder path
	---@field chat table List of chat keywords and commands
	---@field changelog string[][]
	---@field strings widgetToolsStrings
	---@field colors table
	---@field textures table
	---@field fonts table

		---Localized strings
		---@alias widgetToolsStrings
		---| widgetToolsStrings_enUS
		---| widgetToolsStrings_ptBR
		---| widgetToolsStrings_deDE
		---| widgetToolsStrings_frFR
		---| widgetToolsStrings_esES
		---| widgetToolsStrings_esMX
		---| widgetToolsStrings_itIT
		---| widgetToolsStrings_koKR
		---| widgetToolsStrings_zhTW
		---| widgetToolsStrings_zhCN
		---| widgetToolsStrings_ruRU

	---Core utility collection
	---@class widgetToolsUtilities
	---@field isKeyDown table<ModifierKey|any, fun(): down: boolean> Access a Blizzard modifier key down checking function via a modifier key string
	local utilities = {}

		---@alias ModifierKey
				---| "CTRL"
				---| "SHIFT"
				---| "ALT"
				---| "LCTRL"
				---| "RCTRL"
				---| "LSHIFT"
				---| "RSHIFT"
				---| "LALT"
				---| "RALT"

	---Debugging tools
	---@class widgetToolsDebugging
	---@field history table Log history for the current session
	local debugging = {}

	---Toolbox registration
	---@class widgetToolsToolboxes
	---@field initialization table<string, widgetToolbox|table> List of temporary toolbox initialization tables under version keys where a toolbox can assembled to be registered once the addon requesting it finishes loading
	local toolboxes = {}

		---@class widgetToolbox
		---@field name? string Display name of the toolbox
		---@field changelog? string[][] 


--[[ UTILITIES ]]

--[ General ]

---Get the sorted key, value pairs of a table ([Documentation: Sort](https://www.lua.org/pil/19.3.html))
---***
---@param t SortedPairs_param Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
---***
---@return function iterator Function returning the key, value pairs of the table in order
function utilities.SortedPairs(t)

	--| Parameters

	---Table to be sorted (in an ascending order and/or alphabetically, based on the `<` operator)
	---@alias SortedPairs_param # t
	---| table 

	return function() end
end

--[ Math ]

---Round a decimal fraction to the specified number of digits
---***
---@param number? Round_param1 A fractional number value to round | ***Default:*** `0`
---@param decimals? Round_param2 Specify the number of decimal places to round the number to | ***Default:*** `0`
---@return number
function utilities.Round(number, decimals)

	--| Parameters

	---A fractional number value to round | ***Default:*** `0`
	---@alias Round_param1 # number
	---| number

	---Specify the number of decimal places to round the number to | ***Default:*** `0`
	---@alias Round_param2 # decimals
	---| integer

	return 0
end

--[ Validation ]

---Check if a variable is a frame (or a backdrop object)
---@param t Frame|any
---***
---@return boolean|string # If `t` is recognized as a [`FrameScriptObject`](https://warcraft.wiki.gg/wiki/UIOBJECT_FrameScriptObject), return `true`, or, return the frame name if named or the debug name if unnamed but recognized as a UI [Object](https://warcraft.wiki.gg/wiki/UIOBJECT_Object) with a parent, otherwise, return false
function utilities.IsFrame(t) return false end

---Find a frame or region by its name (or a subregion if a key is included in the input string) and get a reference to it if it exists
---***
---@param s ToFrame_param Name of the frame to find (and the key of its child region appended to it after a period character)
---***
---@return AnyFrameObject|nil frame Reference to the object | ***Default:*** `nil`
function utilities.ToFrame(s)

	--| Parameters

	---Name of the frame to find (and the key of its child region appended to it after a period character)
	---@alias ToFrame_param # s
	---| string

	--| Returns

	---@alias AnyFrameObject # frame
	---| Frame
	---| Button
	---| CheckButton
	---| EditBox
	---| Slider
	---| Texture
	---| FontString
end

--[ Formatting ]

---Format a number string with thousands separation and optional value rounding
---***
---@param value Thousands_param1 Number value to turn into a string with thousand separation
---@param decimals? Thousands_param2 Specify the number of decimal places to display if the number is a fractional value | ***Default:*** `0`
---@param round? Thousands_param3 Round the number value to the specified number of decimal places | ***Default:*** `true`
---@param trim? Thousands_param4 Trim trailing zeros in decimal places | ***Default:*** `true`
---***
---@return string # ***Default:*** `""`
function utilities.Thousands(value, decimals, round, trim)

	--| Parameters

	---Number value to turn into a string with thousand separation
	---@alias Thousands_param1 # value
	---| number

	---Specify the number of decimal places to display if the number is a fractional value | ***Default:*** `0`
	---@alias Thousands_param2 # decimals
	---| number

	---Round the number value to the specified number of decimal places | ***Default:*** `true`
	---@alias Thousands_param3 # round
	---| boolean

	---Trim trailing zeros in decimal places | ***Default:*** `true`
	---@alias Thousands_param4 # trim
	---| boolean

	return ""
end

---Convert the object to an appropriately formatted and colored string based on its type
---***
---@param object ToString_param Object to convert to a formatted text
---***
---@return string s Formatted output string
---@return "Frame"|"FrameScriptObject"|"table"|"boolean"|"number"|"string"|"any" t Recognized object type
---***
---<p></p>
function utilities.ToString(object)

	--| Parameters

	---Object to convert to a formatted text
	---@alias ToString_param # object
	---| any

	return "", "any"
end

---Convert a table into a formatted and colored string (appearing as a functional LUA code chunk but including coloring escape sequences)
--- - ***Example:*** Turning back into a loadable code chunk to then be useable as a table:
--- 	```
--- 	local success, loadedTable = pcall(loadstring("return " .. ns.ut.Clear(tableAsString)))
--- 	```
---***
---@param table TableToString_param1 Reference to the table to convert
---@param compact? TableToString_param2 Whether spaces and indentations should be trimmed or not | ***Default:*** `false`
---***
---@return string # ***Default:*** `(WidgetTools.utilities.ToString(table))`
function utilities.TableToString(table, compact)

	--| Parameters

	---Reference to the table to convert
	---@alias TableToString_param1 # table
	---| table

	---Whether spaces and indentations should be trimmed or not | ***Default:*** `false`
	---@alias TableToString_param2 # compact
	---| boolean

	return ""
end

---Get an assembled & fully formatted string of a specifically assembled changelog table
---***
---@param changelog FormatChangelog_param1 Ordered (descending) list of update note subtables of textlines with formatting directives<ul><li>***Note:*** The first line in version tables is expected to be the title containing the version number and/or the date of release.</li><li>***Note:*** Version tables are expected to be listed in descending order by date of release (latest release first).</li><li>***Examples:***<ul><li>**Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)</li><li>**Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
---@param latest? FormatChangelog_param2 If true, get the update notes (withouth the first title line) of only the latest version instead of the entire changelog | ***Default:*** false
---***
---@return string c # ***Default:*** ""
function utilities.FormatChangelog(changelog, latest)

	--| Parameters

	---Ordered (descending) list of update note subtables of textlines with formatting directives
	---***Note:*** The first line in version tables is expected to be the title containing the version number and/or the date of release.
	---***Note:*** Version tables are expected to be listed in descending order by date of release (latest release first).
	---***Examples:***
	--- - **Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)
	--- **Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
	---@alias FormatChangelog_param1 # changelog
	---| string[][]

	---If true, get the update notes (withouth the first title line) of only the latest version instead of the entire changelog | ***Default:*** false
	---@alias FormatChangelog_param2 # latest
	---| boolean

	return ""
end


--[ Table Management ]

---Shield a table by creating a deep proxy through which value access will be read-only via a protective metatable ruleset
--- - ***Note:*** The protection will "infect" any and all subtables when they are indexed through a proxy, meaning the read-only protection will be extended at any depth, including new subtables added to the original table structure of `t` after it was protected.
--- - ***Note:*** Tables for which `getmetatable(t)` returns "public" or "protected", will not be wrapped behind a new proxy.
---   - ***Example:*** Use `setmetatable(t, { __metatable = "public" })` to whitelist any table from getting read-only protection.
---***
---@param t Protect_param Reference to the table to create the proxy for
---***
---@return any # Reference to the new proxy table or `t` itself
function utilities.Protect(t)

	--| Parameters

	---Reference to the table to create the proxy for
	---@alias Protect_param # t
	---| any
end

--| Search

---Find the index of the first matching value in the array provided while also checking subtable branches via a deep search if no match was found at the first level
---***
---@param array FindIndex_param1 Array to search
---@param value FindIndex_param2 The value to find
---***
---@return integer|nil index ***Default:*** `nil`
function utilities.FindIndex(array, value)

	--| Parameters

	---Array to search
	---@alias FindIndex_param1 # array
	---| any[]

	---The value to find
	---@alias FindIndex_param2 # value
	---| any
end

---Find the first matching value and return its key via a deep search
---***
---@param t FindKey_param1 Reference to the table to find a value at a certain key in
---@param value FindKey_param2 Value to look for in `t` (including all subtables, recursively)
---***
---@return any match The first match of the key `value` was found paired to | ***Default:*** `nil`
function utilities.FindKey(t, value)

	--| Parameters

	---Reference to the table to find a value at a certain key in
	---@alias FindKey_param1 # t
	---| table

	---Value to look for in `t` (including all subtables, recursively)
	---@alias FindKey_param2 # value
	---| any
end

---Find and return the value at the first matching key via a deep search
---***
---@param t FindValue_param1 Reference to the table to find a value at a certain key in
---@param key FindValue_param2 Key to look for in `t` (including all subtables, recursively)
---***
---@return any match The first match of the value found at `key` | ***Default:*** `nil`
function utilities.FindValue(t, key)

	--| Parameters

	---Reference to the table to find a value at a certain key in
	---@alias FindValue_param1 # t
	---| table

	---Key to look for in `t` (including all subtables, recursively)
	---@alias FindValue_param2 # key
	---| any
end

--| Sort

---Reorder select elements in an array based on a list of directives
---***
---@param t Reorder_param1 Reference to the array to reorder the elements of
---@param directives Reorder_param2 List of directives: value, index pairs to reorder select elements by (placing matching values at the specified new index)
---***
---@return any t Reference to `t` (it was already overwritten during the operation, no need for setting it again)
function utilities.Reorder(t, directives)

	--| Parameters

	---Reference to the array to reorder the elements of
	---@alias Reorder_param1 # t
	---| table

	---List of directives: value, index pairs to reorder select elements by (placing matching values at the specified new index)
	---@alias Reorder_param2 # t
	---| table<any, integer>
end

--| Data management

---Make a new deep copy of a non-frame table
---***
---@param object Clone_param Reference to the object to create a copy of
---***
---@return any copy Returns `object` itself if it's a frame or not a table
function utilities.Clone(object)

	--| Parameters

	---Reference to the object to create a copy of
	---@alias Clone_param # object
	---| any
end

---Merge a table into an array, deep copying all its values over under new integer keys
---***
---@param target Merge_param1 Table to add the values to
---@param source Merge_param2 Table to copy all values from
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function utilities.Merge(target, source)

	--| Parameters

	---Reference to table to add the values to
	---@alias Merge_param1 # target
	---| table

	---Reference to table to copy all values from
	---@alias Merge_param2 # source
	---| table
end

---Copy all values at matching keys from a sample table to another table while preserving all table references
---***
---@param target CopyValues_param1 Reference to the table to copy the values to
---@param source CopyValues_param2 Reference to the table to copy the values from
---***
---@return any target Reference to `target` (the values were already overwritten during the operation, no need to set it again)
function utilities.CopyValues(target, source)

	--| Parameters

	---Reference to the table to copy the values to
	---@alias CopyValues_param1 # target
	---| table

	---Reference to the table to copy the values from
	---@alias CopyValues_param2 # source
	---| table
end

---Compare two tables and clone any missing data from one to the other
---***
---@param target Fill_param1 Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already `"table"`)
---@param source Fill_param2 Reference to the table to sample data from
---***
---@return any target Reference to `target` (it was already updated during the operation, no need for setting it again)
function utilities.Fill(target, source)

	--| Parameters

	---Reference to the table to fill in missing data to (it will be turned into an empty table first if its type is not already `"table"`)
	---@alias Fill_param1 # target
	---| table

	---Reference to the table to sample data from
	---@alias Fill_param2 # source
	---| table
end

---Copy all values at matching keys and clone any missing data from a reference to the target table
---***
---@param target Pull_param1 Reference to the table to copy the values to
---@param source Pull_param2 Reference to the table to sample data from
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function utilities.Pull(target, source)

	--| Parameters

	---Reference to the table to copy the values to
	---@alias Pull_param1 # target
	---| table

	---Reference to the table to sample data from
	---@alias Pull_param2 # source
	---| table
end

---Remove all nil, empty or otherwise invalid items from a data table
---***
---@param target Prune_param1 Reference to the table to prune
---@param validate? Prune_param2 Helper function for validating values, returning true if the value is to be accepted as valid
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function utilities.Prune(target, validate)

	--| Parameters

	---Reference to the table to prune
	---@alias Prune_param1 # target
	---| table

	---Helper function for validating values, returning true if the value is to be accepted as valid
	---@alias Prune_param2 # validate
	---| fun(k: number|string, v: any): boolean
end

---Remove unused or outdated data from a table while comparing it to another table while restoring any removed values
---***
---@param target Filter_param1 Reference to the table to remove unused key, value pairs from
---@param sample Filter_param2 Reference to the table to sample data from
---@param recoveryMap? Filter_param3 Static map or function returning a dynamically creatable map for removed but recoverable data
---@param onRecovery? Filter_param4 Function called after the data has been has been recovered via the `recoveryMap`
---***
---@return any target Reference to `target` (it was already overwritten during the operation, no need for setting it again)
function utilities.Filter(target, sample, recoveryMap, onRecovery)

	--| Parameters

	---Reference to the table to remove unused key, value pairs from
	---@alias Filter_param1 # target
	---| table

	---Reference to the table to sample data from
	---@alias Filter_param2 # sample
	---| table

	---Static map or function returning a dynamically creatable map for removed but recoverable data
	---@alias Filter_param3 # recoveryMap
	---| table<string, recoveryData>
	---| fun(tableToCheck: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>
	---| nil

	---Function called after the data has been has been recovered via the `recoveryMap`
	---@alias Filter_param4 # onRecovery
	---| fun(tableToCheck: table)
end

---Verify data in a table and harmonize it with a sample table, removing invalid data & filling defaults
---@param target VerifyData_param1 Reference to the table to verify
---@param source VerifyData_param2 Reference to the table to sample
---@return any target Reference to `target` (it was already mutated during the operation)
function utilities.VerifyData(target, source)

	--| Parameters

	---Reference to the table to verify
	---@alias VerifyData_param1 # target
	---| table

	---Reference to the table to sample
	---@alias VerifyData_param2 # source
	---| table
end

--[ Events ]

---Set, unset or replace a event handler
---***
---@param parent SetListener_param1 Reference to the event frame or event handler collection key to assign the handler to
---@param event SetListener_param2 Global Blizzard or custom event tag to modify the handler for
---@param handler SetListener_param3 Reference to the function to set as the handler for `event`, or `nil` to unset it
---@param registration? SetListener_param4 If true and `parent` is a Frame and `event` is a valid Blizzard event tag, also call [`parent:RegisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_RegisterEvent) or [`parent:UnregisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) and [`parent:SetScript("OnEvent", WidgetTools.utilities.CallListener)`](https://warcraft.wiki.gg/wiki/UIOBJECT_ScriptObject) of it was not already set set to `WidgetTools.utilities.CallListener` (replacing all currently set and hooked scripts for the [OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) trigger) | ***Default:*** `true`
---***
---<p></p>
function utilities.SetListener(parent, event, handler, registration)

	--| Parameters

	---Reference to the event frame or event handler collection key to assign the handler to
	---@alias SetListener_param1 # parent
	---| AnyFrameObject
	---| any

	---Global Blizzard or custom event tag to modify the handler for
	---@alias SetListener_param2 # event
	---| WowEvent
	---| string

	---Reference to the function to set as the handler for `event`, or `nil` to unset it
	---@alias SetListener_param3 # handler
	---| fun(parent: AnyFrameObject|any, ...: any): ...:any
	---| nil

	---If true and `parent` is a Frame and `event` is a valid Blizzard event tag, also call [`parent:RegisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_RegisterEvent) or [`parent:UnregisterEvent(...)`](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) and [`parent:SetScript("OnEvent", WidgetTools.utilities.CallListener)`](https://warcraft.wiki.gg/wiki/UIOBJECT_ScriptObject) of it was not already set set to `WidgetTools.utilities.CallListener` (replacing all currently set and hooked scripts for the [OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent) trigger) | ***Default:*** `true`
	---@alias SetListener_param4 # registration
	---| boolean
end

---Call a registered event handler
---***
---@param parent CallListener_param1 Reference to the event frame or event handler collection key the handler has been assigned to
---@param event CallListener_param2 Global Blizzard or custom event tag to call the handler for
---@param ... any Additional payload to pass to the handler
---***
---@return any ... Handler return values
---***
---<p></p>
function utilities.CallListener(parent, event, ...)

	--| Parameters

	---Reference to the event frame or event handler collection key the handler has been assigned to
	---@alias CallListener_param1 # parent
	---| AnyFrameObject
	---| any

	---Global Blizzard or custom event tag to call the handler for
	---@alias CallListener_param2 # event
	---| WowEvent
	---| string
end


--[[ DATA ]]

---WidgetTools main database table
---@class widgetToolsData
---@field lite boolean
---@field debugging boolean
---@field positioningAids boolean
---@field frameAttributes { enabled: boolean, width: number }
---@field customFonts string[]


--[[ DEBUGGING TOOLS ]]

---Save a tab-separated debug log entry to the log history and print out a formatted chat message
---***
---@param message? LogRaw_param1 Included in the log entry as a string
---@param trace? LogRaw_param2 Custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"(source not traced)"`
function debugging.LogRaw(message, trace)

	--| Parameters

	---Included in the log entry as a string
	---@alias LogRaw_param1 # message
	---| any

	---Custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"(source not traced)"`
	---@alias LogRaw_param2 # trace
	---| any
end

---Save a tab-separated debug log entry to the log history and print out a formatted chat message
---***
---@param passer? Log_param1 Included in the log entry as a string
function debugging.Log(passer)

	--| Parameters

	---Passer function returning the logged message and a custom log trace to help identify the exact log source included in the entry as a string | ***Default:*** `"nil", "(source not traced)"`
	---@alias Log_param1 # passer
	---| fun(): message: any, trace: any
end

---Dump an object and its contents to the in-game chat
---***
---@param object Dump_param1 Object to dump out
---@param name? Dump_param2 A name to print out | ***Default:*** *the dumped object will not be named*
---@param blockrule? Dump_param3 Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
--- - ***Example:*** **Match:** Skip a specific matching key
--- 	```
--- 	function(key) return key == "skip_key" end
--- 	```
--- - ***Example:*** **Comparison:** Skip an index key based the result of a comparison
--- 	```
--- 	function(key)
--- 		if type(key) == "number" then --check if the key is an index to avoid issues with mixed tables
--- 			return key < 10
--- 		end
--- 		return true --or false whether to allow string keys in mixed tables
--- 	end
--- 	```
--- - ***Example:*** **Blocklist:** Iterate through an array (indexed table) containing keys, the values of which are to be skipped
--- 	```
--- 	function(key)
--- 		local blocklist = {
--- 			"skip_key",
--- 			1,
--- 		}
--- 		for i = 1, #blocklist do
--- 			if key == blocklist[i] then
--- 			return true --or false to invert the functionality and treat the blocklist as an allowlist
--- 		end
--- 	end
--- 		return false --or true to invert the functionality and treat the blocklist as an allowlist
--- 	end
--- 	```
---@param depth? Dump_param4 How many levels of subtables to print out (root level: `0`) | ***Default:*** *full depth*
---@param digTables? Dump_param5 If `true`, explore and dump the non-subtable values of table objects | ***Default:*** `true`
---@param digFrames? Dump_param6 If `true`, explore and dump the insides of objects recognized as frames | ***Default:*** `false`
---@param linesPerMessage? Dump_param7 Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** `2`
--- - ***Note:*** Set to `0` to print all lines in a single message.
function debugging.Dump(object, name, blockrule, depth, digTables, digFrames, linesPerMessage)

	--| Parameters

	---Object to dump out
	---@alias Dump_param1 # object
	---| any

	---A name to print out | ***Default:*** *the dumped object will not be named*
	---@alias Dump_param2 # name
	---| string

	---Manually filter further exploring subtables under specific keys, skipping it if the value returned is true
	--- - ***Example:*** **Match:** Skip a specific matching key
	--- 	```
	--- 	function(key) return key == "skip_key" end
	--- 	```
	--- - ***Example:*** **Comparison:** Skip an index key based the result of a comparison
	--- 	```
	--- 	function(key)
	--- 		if type(key) == "number" then --check if the key is an index to avoid issues with mixed tables
	--- 			return key < 10
	--- 		end
	--- 		return true --or false whether to allow string keys in mixed tables
	--- 	end
	--- 	```
	--- - ***Example:*** **Blocklist:** Iterate through an array (indexed table) containing keys, the values of which are to be skipped
	--- 	```
	--- 	function(key)
	--- 		local blocklist = {
	--- 			"skip_key",
	--- 			1,
	--- 		}
	--- 		for i = 1, #blocklist do
	--- 			if key == blocklist[i] then
	--- 			return true --or false to invert the functionality and treat the blocklist as an allowlist
	--- 		end
	--- 	end
	--- 		return false --or true to invert the functionality and treat the blocklist as an allowlist
	--- 	end
	--- 	```
	---@alias Dump_param3 # blockrule
	---| fun(key: integer|string): boolean

	---How many levels of subtables to print out (root level: `0`) | ***Default:*** *full depth*
	---@alias Dump_param4 # depth
	---| integer

	---If `true`, explore and dump the non-subtable values of table objects | ***Default:*** `true`
	---@alias Dump_param5 # digTables
	---| boolean

	---If `true`, explore and dump the insides of objects recognized as frames | ***Default:*** `false`
	---@alias Dump_param6 # digFrames
	---| boolean

	---Print the specified number of output lines in a single chat message to be able to display more message history and allow faster scrolling | ***Default:*** `2`
	--- - ***Note:*** Set to `0` to print all lines in a single message.
	---@alias Dump_param7 # linesPerMessage
	---| integer
end


--[[ TOOLBOX REGISTRY ]]

---@class widgetToolboxEntry
---@field toolbox widgetToolbox|table Read-only proxy reference to the registered toolbox table
---@field addons string[] List of addons registered for using this toolbox (represented by their namespace names)

--| Registration

---Get a read-only reference to the toolbox of the specified version from the registry, register an already assembled one as a new entry, or start initializing a new toolbox table, linked to the specified addon for use
--- - ***Note:*** If a toolbox of `version` already exists in the registry, get a read-only reference to it and register `addon` for use, `callback` will not be called.
--- - ***Note:*** If no existing toolbox entry was found, and `toolbox` is not provided or it's not a valid table, start the initialization of a new toolbox in the a readable table accessible via `WidgetTools.toolboxes.initialization[version]`, and call `callback` when `toolboxAddon` finished loading, returning a read-only reference to the newly initialized toolbox bundled from this initialization table which itself will be cleared.
---***
---@param addon Register_param1 Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
---@param version Register_param2 Version key the `toolbox` should be registered under (always converted to string)
---@param callback? Register_param3 Function to be called after a new toolbox initialization has finished when `toolboxAddon` loaded, returning a read-only reference to the new toolbox table
---@param toolboxAddon? Register_param4 Namespace name of the **LoadOnDemand** toolbox initializer addon to load to start initializing a new toolbox | ***Default:*** `"WidgetToolbox_" .. version`
---@param toolbox? Register_param5 Reference to an existing toolbox table to register as a new entry
---***
---@return widgetToolbox|table|boolean? toolbox Read-only reference to the registered toolbox table, or `false` if the toolbox construction addon named `"WidgetToolbox_" .. version` could not be loaded while attempting the initialization of a new toolbox | ***Default:*** *nil*
function toolboxes.Register(addon, version, callback, toolboxAddon, toolbox)

	--| Parameters

	---Addon namespace (the name of the addon's folder, not its display title) to register for WidgetTools usage
	---@alias Register_param1 # addon
	---| string

	---Version key the `toolbox` should be registered under (always converted to string)
	---@alias Register_param2 # version
	---| string
	---| number

	---Function to be called after a new toolbox initialization has finished when `addon` loaded, returning a read-only reference to the new toolbox table
	---@alias Register_param3 # callback
	---| fun(toolbox: widgetToolbox|table?)

	---Namespace name of the **LoadOnDemand** toolbox initializer addon to load | ***Default:*** `"WidgetToolbox_" .. version`
	---@alias Register_param4 # toolboxAddon
	---| string

	---Reference to an existing toolbox table to register
	---@alias Register_param5 # toolbox
	---| table
end


--[[ BLIZZARD TOOLS ]]

---Clamp a number between two limits
---@param value number
---@param min number
---@param max number
---@return number
function Clamp(value, min, max) return 0 end