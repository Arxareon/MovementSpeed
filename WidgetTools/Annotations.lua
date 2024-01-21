--[[ ALIASES ]]

---@alias WidgetType
---|"Toggle"
---|"Selector"
---|"Dropdown"
---|"Textbox"
---|"Numeric"
---|"ColorPicker"

---@alias ModifierKey
---|"CTRL"
---|"SHIFT"
---|"ALT"
---|"LCTRL"
---|"RCTRL"
---|"LSHIFT"
---|"RSHIFT"
---|"LALT"
---|"RALT"
---|"any"

---@alias AnyScriptType
---|"OnLoad"
---|"OnShow"
---|"OnHide"
---|"OnEnter"
---|"OnLeave"
---|"OnMouseDown"
---|"OnMouseUp"
---|"OnMouseWheel"
---|"OnAttributeChanged"
---|"OnSizeChanged"
---|"OnEvent"
---|"OnUpdate"
---|"OnDragStart"
---|"OnDragStop"
---|"OnReceiveDrag"
---|"PreClick"
---|"OnClick"
---|"PostClick"
---|"OnDoubleClick"
---|"OnValueChanged"
---|"OnMinMaxChanged"
---|"OnUpdateModel"
---|"OnModelCleared"
---|"OnModelLoaded"
---|"OnAnimStarted"
---|"OnAnimFinished"
---|"OnEnterPressed"
---|"OnEscapePressed"
---|"OnSpacePressed"
---|"OnTabPressed"
---|"OnTextChanged"
---|"OnTextSet"
---|"OnCursorChanged"
---|"OnInputLanguageChanged"
---|"OnEditFocusGained"
---|"OnEditFocusLost"
---|"OnHorizontalScroll"
---|"OnVerticalScroll"
---|"OnScrollRangeChanged"
---|"OnCharComposition"
---|"OnChar"
---|"OnKeyDown"
---|"OnKeyUp"
---|"OnGamePadButtonDown"
---|"OnGamePadButtonUp"
---|"OnGamePadStick"
---|"OnColorSelect"
---|"OnHyperlinkEnter"
---|"OnHyperlinkLeave"
---|"OnHyperlinkClick"
---|"OnMessageScrollChanged"
---|"OnMovieFinished"
---|"OnMovieShowSubtitle"
---|"OnMovieHideSubtitle"
---|"OnTooltipSetDefaultAnchor"
---|"OnTooltipCleared"
---|"OnTooltipAddMoney"
---|"OnTooltipSetUnit"
---|"OnTooltipSetItem"
---|"OnTooltipSetSpell"
---|"OnTooltipSetQuest"
---|"OnTooltipSetAchievement"
---|"OnTooltipSetFramestack"
---|"OnTooltipSetEquipmentSet"
---|"OnEnable"
---|"OnDisable"
---|"OnArrowPressed"
---|"OnExternalLink"
---|"OnButtonUpdate"
---|"OnError"
---|"OnDressModel"
---|"OnCooldownDone"
---|"OnPanFinished"
---|"OnUiMapChanged"
---|"OnRequestNewSize"

--[ Custom Widget Attributes ]

---@alias ButtonAttributes
---|"enabled"

---@alias ToggleAttributes
---|"enabled"
---|"loaded"
---|"toggled"

---@alias SelectorAttributes
---|"enabled"
---|"loaded"
---|"selected"

---@alias MultipleSelectorAttributes
---|"enabled"
---|"loaded"
---|"min"
---|"max"
---|"selected"

---@alias DropdownAttributes
---|"enabled"
---|"loaded"
---|"open"
---|"selected"

---@alias TextboxAttributes
---|"enabled"
---|"loaded"
---|"changed"

---@alias NumericAttributes
---|"enabled"
---|"loaded"
---|"changed"

---@alias ColorPickerAttributes
---|"enabled"
---|"loaded"
---|"active"
---|"colored"


--[[ CLASSES ]]

--[ Table Management ]

---@class recoveryData
---@field saveTo table List of references to the tables to save the recovered piece of data to
---@field saveKey string|number Save the data under this kay within the specified recovery tables
---@field convertSave? fun(recovered: any): converted: any Function to convert or modify the recovered old data before it is saved

--[ Chat Control ]

---@class chatCommandData
---@field command string Name of the slash command word (no spaces) to recognize after the keyword (separated by a space character)
---@field handler? fun(...: string): result: boolean|nil, ...: any Function to be called when the specific command was recognized after being typed into chat<hr><p>@*param* `...` string ― Payload of the command typed, any words following the command name separated by spaces split and returned one by one</p><hr><p>@*return* `result`? boolean|nil ― Whether to call **[*value*].onSuccess** or **[*value*].onError** after the operation | ***Default:*** nil *(no response)*</p><p>@*return* `...` any ― Any leftover arguments will be passed to the result handler script</p>
---@field onSuccess? fun(...: any) Function to call after **commands[*value*].handler** returns with true to handle a successful result<hr><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
---@field onError? fun(...: any) Function to call after **commands[*value*].handler** returns with false to handle a failed result<hr><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
---@field help? boolean If true, when typed, trigger a call for each command to execute their **commands[*value*].onHelp** handlers | ***Default:*** false
---@field onHelp? function Function to handle the calls initiated by the specified help command(s)

--[ UI Object ]

---@class childObject
---@field parent Frame Reference to the frame to set as the parent

---@class optionalChildObject
---@field parent? Frame Reference to the frame to set as the parent

---@class namedObject_base
---@field name? string Unique string used to set the frame name | ***Default:*** "Frame"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>

---@class namedChildObject : optionalChildObject, namedObject_base
---@field append? boolean Instead of setting the specified name by itself, append it to the name of the specified parent frame | ***Default:*** true

--[ Position & Dimensions ]

---@class axisData
---@field h? boolean Horizontal x axis | ***Default:*** false
---@field v? boolean Vertical y axis | ***Default:*** false

--| Positioning

---@class offsetData
---@field x? number Horizontal offset value | ***Default:*** 0
---@field y? number Vertical offset value | ***Default:*** 0

---@class positionData_base
---@field anchor? AnchorPoint ***Default:*** "TOPLEFT"
---@field relativeTo? Frame|string Frame reference or name, or "nil" to anchor relative to screen dimensions | ***Default:*** "nil"<ul><li>***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).</li><li>***Note:*** Default to "nil" when an invalid frame name is provided.</li></ul>
---@field relativePoint? AnchorPoint ***Default:*** **anchor**

---@class positionData : positionData_base
---@field offset? offsetData

---@class pointData
---@field relativeTo Frame
---@field relativePoint AnchorPoint
---@field offset? offsetData

---@class positionableObject
---@field position? positionData Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"

---@class positionableScreenObject : positionableObject
---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** false

--| Arrangement

---@class spacingData
---@field l? number Space to leave on the left side | ***Default:*** 12
---@field r? number Space to leave on the right side (doesn't need to be negated) | ***Default:*** 12
---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** 12
---@field b? number Space to leave at the bottom | ***Default:*** 12

---@class arrangementParameters
---@field margins? spacingData Inset the content inside the container frame by the specified amount on each side
---@field gaps? number The amount of space to leave between rows | ***Default:*** 8
---@field flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** false
---@field resize? boolean Set the height of the container frame to match the space taken up by the arranged content (including margins) | ***Default:*** true

---@class arrangementData
---@field parameters? arrangementParameters Set of parameters to arrange the frames by: spacing, direction & resizing
---@field order? { [table[]] : integer[] } If set, position the child frames by into columns within rows in the order specified in a nested structure, an array of subtables representing rows, and their values representing the index of a given child frame in { **container**:[GetChildren()](https://wowpedia.fandom.com/wiki/API_Frame_GetChildren) }<ul><li>***Note:*** If not set, assemble the arrangement from the individual arrangement descriptions of child frames stored in their **arrangementInfo** custom table property.</li></ul>

---@class initializableContainer
---@field initialize? fun(container?: Frame, width: number, height: number) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? Frame ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p>
---@field arrangement? arrangementData If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table

---@class arrangementRules
---@field newRow? boolean Place the frame into a new row within its container instead of adding it to a specified row | ***Default:*** true
---@field row? integer Place the frame in the specified existing row | ***Default:*** *last row*<ul><li>***Note:*** If the value provided is larger than the number current rows, it will be placed in the last row.</li></ul>
---@field column? integer Place the frame at this position within its row | ***Default:*** *new column at the end of the row* <ul><li>***Note:*** If the value provided is larger than the number of widgets assigned to the specified row, it will be placed at the end of the row.</li></ul>

---@class arrangeableObject
---@field arrange? arrangementRules When set, automatically position the frame in a columns within rows arrangement in its parent container via ***WidgetTools*.ArrangeContent(**t.parent**, ...)**

--| Size

---@class sizeData
---@field w number Width
---@field h number Height

---@class sizeData_zeroDefault
---@field w? number Width | ***Default:*** 0
---@field h? number Height | ***Default:*** 0

---@class sizeData_parentDefault
---@field w? number Width | ***Default:*** *width of the parent frame*
---@field h? number Height | ***Default:*** *height of the parent frame*

---@class widgetWidthValue
---@field width? number ***Default:*** 160

--| Movability

---@class movementEvents
---@field onStart? function Function to call when **frame** starts moving
---@field onMove? function Function to call every with frame update while **frame** is moving (if **frame** has the "OnUpdate" script defined)
---@field onStop? function Function to call when the movement of **frame** is stopped and the it was moved successfully
---@field onCancel? function Function to call when the movement of **frame** is cancelled (because the modifier key was released early as an example)

---@class movabilityData
---@field modifier? ModifierKey The specific (or any) modifier key required to be pressed down to move **frame** (if **frame** has the "OnUpdate" script defined) | ***Default:*** nil *(no modifier)*<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://wowpedia.fandom.com/wiki/API_IsModifierKeyDown) is used.</li></ul>
---@field triggers? Frame[] List of frames that should handle inputs to initiate or stop the movement when interacted with | ***Default:*** **t.frame**<ul><li>***Note:*** The [IsMouseEnabled](https://warcraft.wiki.gg/wiki/API_ScriptRegion_IsMouseEnabled) property and [OnUpdate](https://warcraft.wiki.gg/wiki/UIHANDLER_OnUpdate) script handlers of the trigger frames will be overwritten.</li></ul>
---@field events? movementEvents Table containing functions to call when certain movement events occur

--[ Visibility ]

--| Strata & Level

---@class visibleObject_base
---@field frameStrata? FrameStrata Pin the frame to the specified strata
---@field frameLevel? integer The ordering level of the frame within its strata to set
---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** false

--[ Color ]

---@class rgbData
---@field r number Red | ***Range:*** (0, 1)
---@field g number Green | ***Range:*** (0, 1)
---@field b number Blue | ***Range:*** (0, 1)

---@class colorData : rgbData
---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1

---@class colorData_whiteDefault : colorData
---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 1
---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 1
---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 1

---@class colorData_blackDefault : colorData
---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 1
---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 1
---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 1

--[ Backdrop ]

---@class insetData
---@field l? number Left side | ***Default:*** 0
---@field r? number Right side | ***Default:*** 0
---@field t? number Top | ***Default:*** 0
---@field b? number Bottom | ***Default:*** 0

---@class backdropBackgroundTextureData
---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/ChatFrame/ChatFrameBackground"<ul><li>***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga).</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li><ul>
---@field size number Size of a single background tile square
---@field tile? boolean Whether to repeat the texture to fill the entire size of the frame | ***Default:*** true
---@field insets? insetData Offset the position of the background texture from the edges of the frame inward

---@class backdropBackgroundData
---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture
---@field color? colorData Apply the specified color to the background texture

---@class backdropUpdateBackgroundData
---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture | ***Default:*** **backdrop.background.texture** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure))*
---@field color? colorData Apply the specified color to the background texture | ***Default:*** **backdrop.background.color** if **fill** == true *(if it's false, keep the currently set values of **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor))*

---@class backdropBorderTextureData
---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/Tooltips/UI-Tooltip-Border"<ul><li>***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga).</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li><ul>
---@field width number Width of the backdrop edge

---@class backdropBorderData
---@field texture? backdropBorderTextureData Parameters used for setting the border texture
---@field color? colorData Apply the specified color to the border texture

---@class backdropUpdateBorderData
---@field texture? backdropBorderTextureData Parameters used for setting the border texture | ***Default:*** **backdrop.border.texture** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure))*
---@field color? colorData Apply the specified color to the border texture | ***Default:*** **backdrop.border.color** if **fill** == true *(if it's false, keep the currently set values of **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor))*

---@class backdropData
---@field background? backdropBackgroundData Table containing the parameters used for the background
---@field border? backdropBorderData Table containing the parameters used for the border

---@class backdropUpdateData
---@field background? backdropBackgroundData Table containing the parameters used for the background | ***Default:*** **backdrop.background** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor))*
---@field border? backdropBorderData Table containing the parameters used for the border | ***Default:*** **backdrop** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor))*

---@class backdropUpdateRule
---@field trigger? Frame Reference to the frame to add the listener script to | ***Default:*** **frame**
---@field rule? fun(self: Frame, ...: any): backdropUpdate: backdropUpdateData|nil, fill: boolean|nil Evaluate the event and specify the backdrop updates to set, or, if nil, restore the base **backdrop** unconditionally on event trigger<ul><li>***Note:*** Return an empty table `{}` for **backdropUpdate** and true for **fill** in order to restore the base **backdrop** after evaluation.</li><li>***Note:*** Return an empty table `{}` for **backdropUpdate** and false or nil for **fill** to do nothing (keep the current backdrop).</li></ul><hr><p>@*param* `self` Frame ― Reference to **updates[*key*].frame**</p><p>@*param* `...` any ― Any leftover arguments will be passed from the handler script to **updates[*key*].rule**</p><hr><p>@*return* `backdropUpdate`? backdropUpdateData|nil ― Parameters to update the backdrop with | ***Default:*** nil *(remove the backdrop)*</p><p>@*return* `fill`? boolean|nil ― If true, fill the specified defaults for the unset values in **backdropUpdates** with the values provided in **backdrop** at matching keys, if false, fill them with their corresponding values from the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure), **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor) and **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor) | ***Default:*** false</p>

---@class customizableObject
---@field customizable? boolean Create the frame with `BackdropTemplateMixin and "BackdropTemplate"` to be easily customizable | ***Default:*** false<ul><li>***Note:*** You may use ***WidgetToolbox*.SetBackdrop(...)** to set up the backdrop quickly.</li></ul>

--[ Font & Text ]

---@class justifyData
---@field h? string Horizontal alignment: "LEFT"|"RIGHT"|"CENTER"
---@field v? string Vertical alignment: "TOP"|"BOTTOM"|"MIDDLE"

---@class justifyData_left
---@field h? string Horizontal alignment: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "LEFT"
---@field v? string Vertical alignment: "TOP"|"BOTTOM"|"MIDDLE" | ***Default:*** "MIDDLE"

---@class justifyData_centered : justifyData_left
---@field h? string Horizontal alignment: "LEFT"|"RIGHT"|"CENTER" | ***Default:*** "CENTER"

---@class fontData
---@field path string Path to the font file relative to the WoW client directory<ul><li>***Note:*** If a font object with that name already exists, it will *not* be overwritten and its reference key will be returned.</li><li>***Example:*** Access the reference to the font object created via the globals table: `local customFont = _G["CustomFontName"]`.</li></ul>
---@field size number The default display size of the new font object
---@field style? string Comma separated string of styling flags: "OUTLINE"|"THICKOUTLINE"|"THINOUTLINE"|"MONOCHROME" .. | ***Default:*** *style defined by the template*

---@class fontCreationData
---@field name string A unique identifier name to set for the hew font object to be accessed by and referred to later<ul><li>***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Fonts/Font.ttf).</li><li>***Note*** **File format:** Font files must be in TTF or OTF format.</li></ul>
---@field template? Font An existing [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to copy as a baseline
---@field font? fontData Table containing font properties used for [SetFont](https://wowpedia.fandom.com/wiki/API_FontInstance_SetFont) (overriding **t.template**)
---@field color? colorData_whiteDefault Apply the specified color to the font (overriding **t.template**)
---@field spacing? number Set the character spacing of the text using this font (overriding **t.template**) | ***Default:*** 0
---@field shadow? { offset: offsetData, color: colorData_blackDefault} Set a text shadow with the following parameters (overriding **t.template**)
---@field justify? justifyData_centered Set the justification of the text using font (overriding **t.template**)
---@field wrap? boolean Whether or not to allow the text lines using this font to wrap (overriding **t.template**) | ***Default:*** true

---@class textCreationData : positionableObject
---@field parent Frame he frame to create the text in
---@field name? string String appended to the name of **t.parent** used to set the name of the new [FontString](https://wowpedia.fandom.com/wiki/) | ***Default:*** "Text"
---@field width? number
---@field layer? DrawLayer
---@field text? string Text to be shown
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used | ***Default:*** "GameFontNormal"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field color? colorData Apply the specified color to the text (overriding **t.font**)
---@field justify? justifyData Set the justification of the text (overriding **t.font**)
---@field wrap? boolean Whether or not to allow the text lines to wrap (overriding **t.font**) | ***Default:*** true

---@class labelFontOptions
---@field normal? string Name of the font to be used when the widget is in its regular state | ***Default:*** "GameFontNormal"
---@field highlight? string Name of the font to be used when the widget is being hovered | ***Default:*** "GameFontHighlight"
---@field disabled? string Name of the font to be used when the widget is disabled | ***Default:*** "GameFontDisable"

---@class labelFontOptions_small
---@field normal? string Name of the font to be used when the widget is in its regular state | ***Default:*** "GameFontNormalSmall"
---@field highlight? string Name of the font to be used when the widget is being hovered | ***Default:*** "GameFontHighlightSmall"
---@field disabled? string Name of the font to be used when the widget is disabled | ***Default:*** "GameFontDisableSmall"

---| Title & Description

---@class titleData
---@field anchor? AnchorPoint ***Default:*** "TOPLEFT"
---@field offset? offsetData The offset from the anchor point relative to the specified frame
---@field width? number ***Default:*** *width of the parent frame*
---@field text string Text to be shown as the main title of the frame
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormal"
---@field color? colorData Apply the specified color to the title (overriding **t.title.font**)
---@field justify? string Set the horizontal alignment of the text: "LEFT"|"RIGHT"|"CENTER" (overriding **t.title.font**) | ***Default:*** "LEFT"

---@class descriptionData
---@field offset? offsetData The offset from the "BOTTOMLEFT" point of the main title
---@field width? number ***Default:*** *width of the parent frame*
---@field text string Text to be shown as the description of the frame
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontHighlightSmall"
---@field color? colorData Apply the specified color to the description (overriding **t.description.font**)
---@field justify? string Set the horizontal alignment of the text: "LEFT"|"RIGHT"|"CENTER" (overriding **t.description.font**) | ***Default:*** "LEFT"

---@class titleCreationData
---@field parent Frame The frame panel to add the title & description to
---@field title? titleData
---@field description? descriptionData

---@class contextLabelData
---@field text string Text to be shown as the main title of the frame
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormalSmall"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field color? colorData Apply the specified color to the title (overriding **t.font**)
---@field justify? string Set the horizontal alignment of the text: "LEFT"|"RIGHT"|"CENTER" (overriding **t.font**) | ***Default:*** "LEFT"

---@class titledObject_base
---@field title? string Text to be displayed as the title | ***Default:*** **t.name**

---@class labeledObject_base
---@field label? boolean Whether to show the title textline or not | ***Default:*** true

---@class titledObject : namedObject_base, titledObject_base

---@class labeledObject : titledObject, labeledObject_base

---@class titledChildObject : namedChildObject, titledObject_base

---@class labeledChildObject : titledChildObject, labeledObject_base

---@class describableObject
---@field description? string Text to be displayed as the subtitle or description | ***Default:*** *no description textline shown*

--[ Texture ]

---@class wrapData
---@field h? WrapMode|boolean Horizontal | ***Value:*** true = "REPEAT" | ***Default:*** "CLAMP"
---@field v? WrapMode|boolean Vertical | ***Value:*** true = "REPEAT" | ***Default:*** "CLAMP"

---@class tileData
---@field h? boolean Horizontal | ***Default:*** false
---@field v? boolean Vertical | ***Default:*** false

---@class edgeCoordinates
---@field l number Left | ***Reference Range:*** (0, 1) | ***Default:*** 0
---@field r number Right | ***Reference Range:*** (0, 1) | ***Default:*** 1
---@field t number Top ***Value:*** *using canvas coordinates (inverted y axis)* | | ***Reference Range:*** (0, 1) | ***Default:*** 0
---@field b number Bottom ***Value:*** *using canvas coordinates (inverted y axis)* | | ***Reference Range:*** (0, 1) | ***Default:*** 1

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

---@class vertexCoordinates
---@field topLeft vertexCoordinates_topLeft
---@field topRight vertexCoordinates_topRight
---@field bottomLeft vertexCoordinates_bottomLeft
---@field bottomRight vertexCoordinates_bottomRight

---@class textureCreationData : positionableObject
---@field parent Frame Reference to the frame to set as the parent of the new texture
---@field name? string String appended to the name of **t.parent** used to set the name of the new texture | ***Default:*** "Texture"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData ***Default:*** *size of* **parent**
---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/ChatFrame/ChatFrameBackground"<ul><li>***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga).</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li><ul>
---@field layer? DrawLayer
---@field level? integer Sublevel to set within the specified draw layer | ***Range:*** (-8, 7)
---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** *no tiling*
---@field wrap? wrapData Set the warp mode for each axis
---@field filterMode? FilterMode | ***Default:*** "LINEAR"
---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis
---@field color? colorData Apply the specified color to the texture
---@field edges? edgeCoordinates Edge coordinate offsets
---@field vertices? vertexCoordinates Vertex coordinate offsets<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, **t.edges** will be used first ignoring **t.vertices**.</li></ul>
---@field events? table<ScriptRegion, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the texture object and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged)" whenever the value in the slider widget is modified.</li></ul>

---@class textureUpdateData
---@field position? positionData Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** **t.position**
---@field size? sizeData | ***Default:*** **t.size**
---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** **t.path**<ul><li>***Note:*** The use of "/" as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga).</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li><ul>
---@field layer? DrawLayer | ***Default:*** **t.layer**
---@field level? integer Sublevel to set within the specified draw layer | ***Range:*** (-8, 7) | ***Default:*** **t.level**
---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** **t.tile**
---@field wrap? wrapData Set the warp mode for each axis | ***Default:*** **t.wrap**
---@field filterMode? FilterMode | ***Default:*** **t.filterMode**
---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis | ***Default:*** **t.flip**
---@field color? colorData Apply the specified color to the texture | ***Default:*** **t.color**
---@field edges? edgeCoordinates Edge coordinate offsets ***Default:*** **t.edges**
---@field vertices? vertexCoordinates Vertex coordinate offsets ***Default:*** **t.vertices**<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, **t.edges** will be used first ignoring **t.vertices**.</li></ul>

---@class textureUpdateRule
---@field frame? Frame Reference to the frame to add the listener script to | ***Default:*** **t.parent**
---@field rule? fun(self: Frame, ...: any): data: textureUpdateData|nil Evaluate the event and specify the texture updates to set, or, if nil, restore the base values unconditionally on event trigger<hr><p>@*param* `self` Frame — Reference to **updates[*key*].frame**</p><p>@*param* `...` any — Any leftover arguments will be passed from the handler script to **updates[*key*].rule**</p><hr><p>@*return* `data` textureUpdateData|nil — Parameters to update the texture with | ***Default:*** **t**</p>

--[ Line ]

---@class lineCreationData
---@field parent Frame Reference to the frame to set as the parent of the new line
---@field name? string String appended to the name of **t.parent** used to set the name of the new line | ***Default:*** "Line"
---@field startPosition pointData Parameters to call [Line:SetStartPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetStartPoint) with
---@field endPosition pointData Parameters to call [Line:SetEndPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetEndPoint) with
---@field thickness? number ***Default:*** 4
---@field layer? DrawLayer 
---@field level? integer Sublevel to set within the draw layer specified with **t.layer** | ***Range:*** (-8, 7)
---@field color? colorData Apply the specified color to the line

--[ Tooltip ]

---@class tooltipLineData
---@field text string Text to be displayed in the line
---@field font? string|FontObject The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
---@field color? rgbData Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
---@field wrap? boolean Allow the text in this line to be wrapped | ***Default:*** true

---@class tooltipTextData
---@field title string String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR)
---@field lines? tooltipLineData[] Table containing the lists of parameters for the text lines after the title

---@class tooltipData : tooltipTextData
---@field tooltip? GameTooltip Reference to the tooltip frame to set up | ***Default:*** *default WidgetTools custom tooltip*
---@field anchor TooltipAnchor [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner#Arguments)
---@field offset? offsetData Values to offset the position of **tooltipData.tooltip** by
---@field position? positionData_base Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** "TOPLEFT" if **tooltipData.anchor** == "ANCHOR_NONE"<ul><li>***Note:*** **t.offset** will be used when calling [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) as well.</li></ul>
---@field flipColors? boolean Flip the default color values of the title and the text lines | ***Default:*** false

---@class tooltipUpdateData : tooltipData
---@field anchor? TooltipAnchor [GameTooltip anchor](https://wowpedia.fandom.com/wiki/API_GameTooltip_SetOwner#Arguments) | ***Default:*** **owner.tooltipData.anchor**

---@class tooltipToggleData
---@field triggers? Frame[] List of references to additional frames to add hover events to to toggle **tooltipData.tooltip** for **owner** besides **owner** itself
---@field checkParent? boolean Whether to check if **owner** is being hovered before hiding **tooltipData.tooltip** when triggers stop being hovered | ***Default:*** true
---@field replace? boolean If false, while **tooltipData.tooltip** is already visible for a different owner, don't change it | ***Default:*** true<ul><li>***Note:*** If **tooltipData.tooltip** is already shown for **owner**, ***WidgetToolbox*.UpdateTooltip(...)** will be called anyway.</li></ul>

---@class widgetTooltipTextData : tooltipTextData
---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**

---@class itemTooltipTextData : tooltipTextData
---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** **t.items[*index*].title**

---@class presetTooltipTextData : tooltipTextData
---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** **t.presets.items[*index*].title**

---@class addonCompartmentTooltipData : tooltipTextData
---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** [GetAddOnMetadata(**addon**, "title")](https://wowpedia.fandom.com/wiki/API_GetAddOnMetadata)

---@class tooltipDescribableObject
---@field tooltip? widgetTooltipTextData List of text lines to be added to the tooltip of the widget displayed when mousing over the frame

--[ Dependencies ]

---@class dependencyRule
---@field frame Frame|checkbox|radioButton|selector|multiSelector|specialSelector|dropdownSelector|textbox|multilineTextbox Tie the state of the widget to the evaluation of the current value of the frame specified here
---@field evaluate? fun(value?: any): evaluation: boolean Call this function to evaluate the current value of the specified frame, enabling the dependant widget when true, or disabling it when false is returned | ***Default:*** *no evaluation, only for checkboxes*<ul><li>***Note:*** **evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) if **frame** is not "CheckButton".</li><li>***Overloads:***</li><ul><li>function(`value`: boolean) -> `evaluation`: boolean — If **frame** is recognized as a checkbox</li><li>function(`value`: string) -> `evaluation`: boolean — If **frame** is recognized as an editbox</li><li>function(`value`: number) -> `evaluation`: boolean — If **frame** is recognized as a slider</li><li>function(`value`: integer) -> `evaluation`: boolean — If **frame** is recognized as a dropdown or selector</li><li>function(`value`: nil) -> `evaluation`: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*</li></ul></ul>

---@class togglableObject
---@field disabled? boolean If true, set the state of this widget to be disabled on load | ***Default:*** false<ul><<li>***Note:*** Dependency rule evaluations may re-enable the widget.</li></ul>
---@field dependencies? dependencyRule[] Automatically enable or disable the widget based on the set of rules described in subtables

--[ Options Data ]

---@class optionsData_base
---@field optionsKey string A unique key referencing a collection of options data management rules to handle together
---@field storageKey? string The key pointing to the variable inside both the working & the storage table
---@field workingTable? table Reference to an operational data table where the value modified live by the widget is being saved to as changes are made
---@field storageTable? table Reference to a storage data table where the option data is being committed to and loaded back from when settings are saved, loaded or updated
---@field autoCommit? boolean Immediately commit the data to the storage table whenever it's changed via the widget | ***Default:*** false<ul><li>***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(optionsKey)** is executed.</li></ul>
---@field onChange? table<string|integer, function|string> List of new or already defined functions to call after the value of the widget was changed by the user or via options data management<ul><li>**[*key*]**? string|integer ― A unique key to point to a newly defined function to be added to options data management or just the index of the next function name to be linked to **t.optionsData.optionsKey** | ***Default:*** *next assigned index*</li><li>**[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function linked to **t.optionsData.optionsKey**</li><ul><li>***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Duplicate functions are overwritten.</li></ul></ul>

---| Toggle

---@class booleanOptionsData: optionsData_base
---@field convertSave? fun(value: boolean): data: any|nil Function to convert or modify the data before it is saved<hr><p>@*param* `value` boolean ― The current value of the widget</p><hr><p>@*return* `data` any|nil ― The converted value</p>
---@field convertLoad? fun(data?: any): value: boolean|nil Function to convert or modify the data before it is loaded<hr><p>@*param* `data`? any ― The data in the working table to be converted</p><hr><p>@*return* `value` boolean ― The converted value | ***Default:*** false</p>
---@field onLoad? fun(self: checkbox|radioButton, value: boolean) Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)<hr><p>@*param* `self` checkbox|radioButton ― Reference to the widget</p><hr><p>@*param* `value` boolean ― The loaded value</p>
---@field onSave? fun(self: checkbox|radioButton, data?: any) Function to be be called on options data update (after the data of this widget has been saved to the working table)<hr><p>@*param* `self` checkbox|radioButton ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>
---@field onCommit? fun(self: checkbox|radioButton, data?: any) Function to be be called on options data commit (after the data of this widget has been committed to the storage table)<hr><p>@*param* `self` checkbox|radioButton ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>

---| Textbox

---@class stringOptionsData: optionsData_base
---@field convertSave? fun(value: string): data: any|nil Function to convert or modify the data before it is saved<hr><p>@*param* `value` string ― The current value of the widget</p><hr><p>@*return* `data` any|nil ― The converted value</p>
---@field convertLoad? fun(data?: any): value: string Function to convert or modify the data before it is loaded<hr><p>@*param* `data`? any ― The data in the working table to be converted</p><hr><p>@*return* `value` string ― The converted value</p>
---@field onLoad? fun(self: textbox|multilineTextbox, value: string) Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)<hr><p>@*param* `self` textbox|multilineTextbox ― Reference to the widget</p><hr><p>@*param* `value` string ― The loaded value</p>
---@field onSave? fun(self: textbox|multilineTextbox, data?: any) Function to be be called on options data update (after the data of this widget has been saved to the working table)<hr><p>@*param* `self` textbox|multilineTextbox ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>
---@field onCommit? fun(self: textbox|multilineTextbox, data?: any) Function to be be called on options data commit (after the data of this widget has been committed to the storage table)<hr><p>@*param* `self` textbox|multilineTextbox ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>

---| Numeric

---@class numberOptionsData: optionsData_base
---@field convertSave? fun(value: number): data: any|nil Function to convert or modify the data before it is saved<hr><p>@*param* `value` number ― The current value of the widget</p><hr><p>@*return* `data` any|nil ― The converted value</p>
---@field convertLoad? fun(data?: any): value: number Function to convert or modify the data before it is loaded<hr><p>@*param* `data`? any ― The data in the working table to be converted</p><hr><p>@*return* `value` number ― The converted value</p>
---@field onLoad? fun(self: numericSlider, value: number) Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)<hr><p>@*param* `self` numericSlider ― Reference to the widget</p><hr><p>@*param* `value` number ― The loaded value</p>
---@field onSave? fun(self: numericSlider, data?: any) Function to be be called on options data update (after the data of this widget has been saved to the working table)<hr><p>@*param* `self` numericSlider ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>
---@field onCommit? fun(self: numericSlider, data?: any) Function to be be called on options data commit (after the data of this widget has been committed to the storage table)<hr><p>@*param* `self` numericSlider ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>

---| Selector

---@class integerOptionsData: optionsData_base
---@field convertSave? fun(value?: integer): data: any|nil Function to convert or modify the data before it is saved<hr><p>@*param* `value`? integer ― The current value of the widget</p><hr><p>@*return* `data` any|nil ― The converted value</p>
---@field convertLoad? fun(data?: any): value: integer|nil Function to convert or modify the data before it is loaded<hr><p>@*param* `data`? any ― The data in the working table to be converted</p><hr><p>@*return* `value` integer|nil ― The converted value</p>
---@field onLoad? fun(self: selector|dropdownSelector, value?: integer) Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)<hr><p>@*param* `self` selector|dropdown ― Reference to the widget</p><hr><p>@*param* `value`? integer ― The loaded value</p>
---@field onSave? fun(self: selector|dropdownSelector, data?: any) Function to be be called on options data update (after the data of this widget has been saved to the working table)<hr><p>@*param* `self` selector|dropdown ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>
---@field onCommit? fun(self: selector|dropdownSelector, data?: any) Function to be be called on options data commit (after the data of this widget has been committed to the storage table)<hr><p>@*param* `self` selector|dropdown ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>

---@class booleanArrayOptionsData: optionsData_base
---@field convertSave? fun(value?: boolean[]): data: any|nil Function to convert or modify the data before it is saved<hr><p>@*param* `value`? boolean[] ― The current value of the widget</p><hr><p>@*return* `data` any|nil ― The converted value</p>
---@field convertLoad? fun(data?: any): value: boolean[]|nil Function to convert or modify the data before it is loaded<hr><p>@*param* `data`? any ― The data in the working table to be converted</p><hr><p>@*return* `value` boolean[]|nil ― The converted value</p>
---@field onLoad? fun(self: multiSelector, value?: boolean[]) Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)<hr><p>@*param* `self` multiSelector ― Reference to the widget</p><hr><p>@*param* `value`? boolean[] ― The loaded value</p>
---@field onSave? fun(self: multiSelector, data?: any) Function to be be called on options data update (after the data of this widget has been saved to the working table)<hr><p>@*param* `self` multiSelector ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>
---@field onCommit? fun(self: multiSelector, data?: any) Function to be be called on options data commit (after the data of this widget has been committed to the storage table)<hr><p>@*param* `self` multiSelector ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>

---@class specialOptionsData: optionsData_base
---@field convertSave? fun(value?: AnchorPoint|JustifyH|JustifyV|FrameStrata): data: any|nil Function to convert or modify the data before it is saved<hr><p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata ― The current value of the widget</p><hr><p>@*return* `data` any|nil ― The converted value</p>
---@field convertLoad? fun(data?: any): value: AnchorPoint|JustifyH|JustifyV|FrameStrata|nil Function to convert or modify the data before it is loaded<hr><p>@*param* `data`? any ― The data in the working table to be converted</p><hr><p>@*return* `value` AnchorPoint|JustifyH|JustifyV|FrameStrata|nil ― The converted value</p>
---@field onLoad? fun(self: specialSelector, value?: AnchorPoint|JustifyH|JustifyV|FrameStrata) Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)<hr><p>@*param* `self` specialSelector ― Reference to the widget</p><hr><p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata ― The loaded value</p>
---@field onSave? fun(self: specialSelector, data?: any) Function to be be called on options data update (after the data of this widget has been saved to the working table)<hr><p>@*param* `self` specialSelector ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>
---@field onCommit? fun(self: specialSelector, data?: any) Function to be be called on options data commit (after the data of this widget has been committed to the storage table)<hr><p>@*param* `self` specialSelector ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>

---@class wrappedIntegerValue
---@field index? integer ***Default:*** nil *(no selection)*

---@class wrappedBooleanArrayData
---@field selections? boolean[] List of current item states in order | ***Default:*** nil *(no selected items)*<ul><li>**[*index*]** boolean? — Whether this item should be set as selected or not | ***Default:*** false</li></ul>

---@class wrappedSpecialData
---@field value? integer|AnchorPoint|JustifyH|JustifyV|FrameStrata ***Default:*** nil *(no selection)*

---| Color Picker

---@class colorOptionsData: optionsData_base
---@field convertSave? fun(value: colorData): data: any|nil Function to convert or modify the data before it is saved<hr><p>@*param* `value` colorData ― The current value of the widget</p><hr><p>@*return* `data` any|nil ― The converted value</p>
---@field convertLoad? fun(data?: any): value: colorData Function to convert or modify the data before it is loaded<hr><p>@*param* `data`? any ― The data in the working table to be converted</p><hr><p>@*return* `value` colorData ― The converted value</p>
---@field onLoad? fun(self: colorPicker, value: colorData) Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)<hr><p>@*param* `self` colorPicker ― Reference to the widget</p><hr><p>@*param* `value` colorData ― The loaded value</p>
---@field onSave? fun(self: colorPicker, data?: any) Function to be be called on options data update (after the data of this widget has been saved to the working table)<hr><p>@*param* `self` colorPicker ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>
---@field onCommit? fun(self: colorPicker, data?: any) Function to be be called on options data commit (after the data of this widget has been committed to the storage table)<hr><p>@*param* `self` colorPicker ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>

--[ Popup ]

---@class popupData
---@field name string Appended to **addon** as a unique identifier key in the global **StaticPopupDialogs** table
---@field text string The text to display as the message in the popup window
---@field accept? string The text to display on the label of the accept button | ***Default:*** ***WidgetToolbox*.strings.misc.accept**
---@field cancel? string The text to display on the label of the cancel button | ***Default:*** ***WidgetToolbox*.strings.misc.cancel**
---@field alt? string The text to display on the label of the third alternative button
---@field onAccept? function Called when the accept button is pressed and an OnAccept event happens
---@field onCancel? function Called when the cancel button is pressed, the popup is overwritten (by another popup for instance) or the popup expires and an OnCancel event happens
---@field onAlt? function Called when the alternative button is pressed and an OnAlt event happens

--[ Reload Notice ]

---@class reloadFrameOffsetData
---@field x? number Horizontal offset value | ***Default:*** -300
---@field y? number Vertical offset value | ***Default:*** -80

---@class reloadFramePositionData : positionData_base
---@field anchor? AnchorPoint ***Default:*** "TOPRIGHT"
---@field offset? offsetData

---@class reloadFrameData
---@field title? string Text to be shown as the title of the reload notice | ***Default:*** "Pending Changes" *(when the language is set to English)*
---@field message? string Text to be shown as the message of the reload notice | ***Default:*** "Reload the interface to apply the pending changes." *(when the language is set to English)*
---@field position? reloadFramePositionData Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPRIGHT", -300, -80

--[ Containers ]

--| Frame

---@class frameCreationData : positionableScreenObject, customizableObject, visibleObject_base, initializableContainer
---@field parent? Frame Reference to the frame to set as the parent of the new frame | ***Default:*** nil *(parentless frame)*<ul><li>***Note:*** You may use [Region:SetParent(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
---@field name? string Unique string used to set the name of the new frame | ***Default:*** nil *(anonymous frame)*<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field append? boolean When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true if **t.name** ~= nil and **t.parent** ~= nil and **t.parent** ~= UIParent
---@field container? boolean Whether or not to add child frame arrangement support to the frame turning it to a container | ***Default:*** false
---@field size? sizeData_zeroDefault ***Default:*** *no size*<ul><li>***Note:*** Omitting or setting either value to 0 will result in the frame being invisible and not getting placed on the screen.</li></ul>
---@field events? table<ScriptFrame, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnEvent](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the **t.onEvent** table.</li></ul>
---@field onEvent? table<WowEvent, fun(self: Frame, ...: any)> Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame<ul><li>***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://wowpedia.fandom.com/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.</li><li>***Example:*** "[ADDON_LOADED](https://wowpedia.fandom.com/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.<pre>```function(self, addon)```<br>&#9;```if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch```<br>&#9;```self:UnregisterEvent("ADDON_LOADED")```<br>&#9;```--Do something```<br>```end```</pre></li></ul>

--| ScrollFrame

---@class sizeData_scroll
---@field w? number Horizontal size of the scrollable child frame | ***Default:*** **t.size.width** - 16
---@field h? number Vertical size of the scrollable child frame | ***Default:*** 0 *(no height)*

---@class scrollSpeedData
---@field scrollSpeed? number Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25

---@class scrollFrameCreationData : childObject, positionableObject, initializableContainer, scrollSpeedData
---@field name? string Unique string to append to the name of **t.parent** when setting the name of the new scroll frame | ***Default:*** "ScrollFrame"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field scrollName? string Unique string used to set the name of the scrolling child frame | ***Default:*** "ScrollChild"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_parentDefault ***Default:*** **t.parent** and *size of the parent frame* or *no size*
---@field scrollSize? sizeData_scroll ***Default:*** *size of the parent frame*

--| Panel

---@class sizeData_panel
---@field w? number Width | ***Default:*** **t.parent** and *width of the parent frame* - 32 or 0
---@field h? number Height | ***Default:*** 0<ul><li>***Note:*** If content is added, arranged and **t.arrangeContent.resize** is true, the height will be set dynamically based on the calculated height of the content.</li></ul>

---@class backgroundColorData_panel
---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 0.175
---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 0.175
---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 0.175
---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 0.45

---@class insetData_panel
---@field l? number Left side | ***Default:*** 4
---@field r? number Right side | ***Default:*** 4
---@field t? number Top | ***Default:*** 4
---@field b? number Bottom | ***Default:*** 4

---@class backdropBackgroundTextureData_panel : backdropBackgroundTextureData
---@field size? number Size of a single background tile square | ***Default:*** 5
---@field insets? insetData_panel Offset the position of the background texture from the edges of the frame inward

---@class backdropBackgroundData_panel
---@field texture? backdropBackgroundTextureData_panel Parameters used for setting the background texture
---@field color? backgroundColorData_panel Apply the specified color to the background texture

---@class borderColorData_panel
---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 0.75
---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 0.75
---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 0.75
---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 0.5

---@class backdropBorderTextureData_panel : backdropBorderTextureData
---@field width? number Width of the backdrop edge | ***Default:*** 16

---@class backdropBorderData_panel
---@field texture? backdropBorderTextureData_panel Parameters used for setting the border texture
---@field color? borderColorData_panel Apply the specified color to the border texture

---@class spacingData_panel : spacingData
---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** **t.description** and 30 or 12

---@class arrangementParameters_panel : arrangementParameters
---@field margins? spacingData_panel Inset the content inside the container frame by the specified amount on each side

---@class arrangementData_panel
---@field parameters? arrangementParameters_panel Set of parameters to arrange the frames by: spacing, direction & resizing

---@class panelCreationData : labeledChildObject, describableObject, positionableScreenObject, arrangeableObject, visibleObject_base, backdropData, initializableContainer
---@field name? string Unique string used to set the frame name | ***Default:*** "Panel"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_panel
---@field background? backdropBackgroundData_panel Table containing the parameters used for the background
---@field border? backdropBorderData_panel Table containing the parameters used for the border
---@field events? table<ScriptFrame, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the panel and the functions to assign as event handlers called when they trigger
---@field initialize? fun(container?: panel, width: number, height: number) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? panel ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p>

--| Context Menu

---@class togglableObject_contextMenu
---@field disabled? boolean If true, deactivate the context menu on load | ***Default:*** false<ul><<li>***Note:*** Dependency rule evaluations may re-enable the widget.</li></ul>
---@field dependencies? dependencyRule[] Automatically activate or deactivate the context menu based on the set of rules described in subtables

---@class contextMenuCreationData : namedChildObject, togglableObject_contextMenu
---@field name? string Unique string used to set the frame name | ***Default:*** "ContextMenu"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field position? positionData Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT" if **t.cursor** is false
---@field cursor? boolean Open the context menu at the current cursor position instead of the specified frame position | ***Default:*** true
---@field width? number ***Default:*** 140

---@class contextMenuItem
---@field name? string Unique string to append this to the name of **contextMenu** when setting the name | ***Default:*** "Item" *followed by the the increment of the last index of* **contextMenu.items**<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>

---@class contextItemLabelJustify
---@field justify? string Set the horizontal alignment of the label: "LEFT"|"RIGHT"|"CENTER" (overriding **t.font**) | ***Default:*** "LEFT"

---@class contextSubmenuCreationData : contextMenuItem, contextItemLabelJustify
---@field title? string Text to be shown on the label on the toggle item representing the submenu in the **contextMenu** list | ***Default:*** **t.name**
---@field tooltip? widgetTooltipTextData List of text lines to be added to the tooltip of the toggle button acting as the trigger item for the submenu displayed when mousing over the frame
---@field width? number ***Default:*** 140
---@field hover? boolean If true, open the submenu when its trigger item is being hovered, or if false, open only when it's clicked instead | ***Default:*** true
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for label of the submenu toggle button | ***Default:*** "GameFontHighlightSmall"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field leftSide? boolean Open the submenu on the left instead of the right | ***Default:*** true if **t.justify** is "RIGHT"

---@class classicContextMenuCreationData : namedChildObject
---@field name? string Unique string used to set the frame name | ***Default:*** "ContextMenu"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field anchor? string|Region The current cursor position or a region or frame reference | ***Default:*** "cursor"
---@field offset? offsetData
---@field width? number ***Default:*** 115
---@field menu table[] Table of nested subtables for the context menu items containing their attributes<ul><li>***Note:*** See the [full list of attributes](https://www.townlong-yak.com/framexml/5.4.7/UIDropDownMenu.lua#139) that can be set for menu items.<ul><li>***Examples:***<ul><li>**text** string — Text to be displayed on the button within the context menu</li><li>**isTitle**? boolean — Set the item as a title instead of a clickable button | ***Default:*** false (*not title*)</li><li>**disabled**? number — Disable the button if set to 1 | ***Range:*** (nil, 1) | ***Default:*** nil or 1 if **t.isTitle** == true</li><li>**checked**? boolean — Whether the button is currently checked or not | ***Default:*** false (*not checked*)</li><li>**notCheckable**? number — Make the item a simple button instead of a checkbox if set to 1 | ***Range:*** (nil, 1) | ***Default:*** nil</li><li>**func** function — The function to be called the button is clicked</li><li>**hasArrow** boolean — Show the arrow to open the submenu specified in t.menuList</li><li>**menuList** table — A table of subtables containing submenu items</li></ul></li></ul></li></ul>

--[ Options Page ]

---@class optionsPageScrollData : scrollSpeedData
---@field height? number Set the height of the scrollable child frame to the specified value | ***Default:*** 0 *(no height)*
---@field speed? number Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25

---@class storageData
---@field workingTable table Reference to an operational options data table where values modified live by widgets are to be saved as changes are being made or loaded back from when settings are loaded or updated<ul><li>***Note:*** A reference to a clone created via **WidgetToolbox*.Clone(...)** of an account-bound SavedVariables or character-specific SavedVariablesPerCharacter addon database can be used here.</li></ul>
---@field storageTable table Reference to a storage database table where data is committed to only when settings are saved, allowing for changes to be reverted from as widget value changes are not saved here directly<ul><li>***Note:*** A direct reference to an account-bound SavedVariables or character-specific SavedVariablesPerCharacter addon database can be used here.</li></ul>
---@field defaultsTable table A static table containing all default settings values at matching keys to the storage and working tables to be restored on demand

---@class spacingData_optionsPage
---@field l? number Space to leave on the left side | 10
---@field r? number Space to leave on the right side (doesn't need to be negated) | ***Default:*** 10
---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** **t.scroll** and 78 or 82
---@field b? number Space to leave at the bottom | ***Default:*** **t.scroll** and 10 or 22

---@class arrangementParameters_optionsPage : arrangementParameters
---@field margins? spacingData_optionsPage Inset the content inside the options panel by the specified amount on each side
---@field gaps? number The amount of space to leave between rows | ***Default:*** 32
---@field resize? boolean Set the height of the options panel to match the space taken up by the arranged content (including margins) | ***Default:*** **t.scroll** ~= nil

---@class arrangementData_optionsPage
---@field parameters? arrangementParameters_optionsPage Set of parameters to arrange the frames by: spacing, direction & resizing

---@class optionsPageCreationData_base
---@field parent? optionsPage The options category page to be set as the parent category page, making this its subcategory | ***Default:*** nil *(set as a main category)*
---@field name? string Unique string used to set the name of the options frame | ***Default:*** **addon**<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field title? string Text to be shown as the title of the options page | ***Default:*** [GetAddOnMetadata(**addon**, "title")](https://wowpedia.fandom.com/wiki/API_GetAddOnMetadata)
---@field register? boolean Whether to register the options category page to the settings panel upon creation | ***Default:*** true<ul><li>***Note:*** The page can be registered later via **optionsPage.register()**.</li></ul>

---@class optionsPageEvents
---@field onLoad? fun(user: boolean) Function called after the settings linked to this page have been loaded<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not | ***Default:*** false</p>
---@field onSave? fun(user: boolean) Function called after the settings linked to this page have been committed to the storage tables after being updated in the working tables<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not | ***Default:*** false</p>
---@field onCancel? fun(user: boolean) Function called after the changes are scrapped (for instance when the custom "Revert Changes" button is clicked)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not | ***Default:*** false</p>
---@field onDefault? fun(user: boolean) Function called after settings are restored to their default values (for example when the "These Settings" - affecting this options category page only, or the "All Settings" - affecting all options category pages within the **addon** namespace option is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not | ***Default:*** false</p>

---@class optionsPageCreationData : optionsPageCreationData_base, describableObject, optionsPageEvents, initializableContainer
---@field append? boolean When setting the name of the options category page, append **t.name** after **addon** | ***Default:*** true if **t.name** ~= nil
---@field appendOptions? boolean When setting the name of the canvas frame, append "Options" at the end as well | ***Default:*** true
---@field logo? string Path to the texture file, the logo of the addon to be added as to the top right corner of the panel
---@field titleLogo? boolean Append the texture specified as **t.logo** to the title of the Settings button as well | ***Default:*** false
---@field scroll? optionsPageScrollData If set, make the options canvas scrollable by creating a [ScrollFrame](https://wowpedia.fandom.com/wiki/UIOBJECT_ScrollFrame) as its child
---@field optionsKeys? string[] A list of unique keys linking collections of widget options data to be saved & loaded with this options category page
---@field storage? storageData[] Array of subtables containing settings data storage table references to move data between when saving, loading or modifying setting data
---@field autoSave? boolean If true, automatically save the values of all widgets registered for options data management under options keys listed in **t.optionsKeys** to their specified working tables via ***WidgetToolbox*.SaveOptionsData(...)** before committing data to the corresponding storage tables | ***Default:*** true if **t.optionsKeys** ~= nil<ul><li>***Note:*** If **t.optionsKeys** is not set, the automatic load will not be executed even if this is set to true.</li></ul>
---@field autoLoad? boolean If true, automatically load all data to the widgets registered for options data management under options keys listed in **t.optionsKeys** from their specified working tables via ***WidgetToolbox*.LoadOptionsData(...)** | ***Default:*** true if **t.optionsKeys** ~= nil<ul><li>***Note:*** If **t.optionsKeys** is not set, the automatic load will not be executed even if this is set to true.</li></ul>

---@class aboutPageCreationData : optionsPageCreationData_base
---@field description? string Text to be shown as the description below the title of the options page | ***Default:*** [GetAddOnMetadata(**addon**, "Notes")](https://wowpedia.fandom.com/wiki/API_GetAddOnMetadata)
---@field changelog? { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included<ul><li>***Note:*** The first line is expected to be the title containing the version number and/or the date of release.</li><li>***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).</li><li>***Examples:***<ul><li>**Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)</li><li>**Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>

---@class dataManagementPageCreationData : optionsPageCreationData_base, optionsPageEvents
---@field name? string Unique string used to set the name of the options frame | ***Default:*** "Profiles"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field title? string Text to be shown as the title of the options page | ***Default:*** "Data Management"
---@field description? string Text to be shown as the description below the title of the options page | ***Default:*** *describing profiles & backup*
---@field accountData profileStorage|table Reference to the account-bound SavedVariables addon database where profile data is to be stored<ul><li>***Note:*** A subtable will be created under the key **profiles** if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).</li></ul>
---@field characterData table Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified<ul><li>***Note:*** An integer value will be created under the key **activeProfile** if it doesn't already exist.</li></ul>
---@field settingsData table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>***Note:*** The following key, value pairs will are used for storing settings data within this table:<ul><li>**compactBackup** boolean — Whether to skip including additional white spaces to the backup string for more readability</li><li>**backupDataScope** boolean — Whether to include only the current profile or all profiles in the backup string</li></li></ul>
---@field workingTable? table Reference to the operational options table where the data of the current profile is to be copied to to be modified live by the options widgets instead of the storage profile subtable inside **t.accountData.profiles** so changes may be reverted before being committed to storage
---@field defaultsTable table A static table containing all default settings values to be cloned when creating a new profile
---@field onProfilesLoaded? function Called during profiles initialization after the active profile has been loaded and profiles data is validated (with **t.onImportAllProfiles(...)** also being called later when profiles data is imported via user interaction through the backup all profiles box)
---@field onProfileActivated? fun(index: integer) Called after a profile was set as the currently activate profile<hr><p>@*param* `index` integer — The index of the activated profile</p>
---@field onImport? fun(success: boolean, data: table) Function called after a settings backup string import has been performed by the user loading data for the currently active profile<hr><p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>
---@field onImportAllProfiles? fun(success: boolean, data: table) Function called after a settings backup string import has been performed by the user loading data for all profiles<ul><li>***Note:*** *t.onProfilesLoaded will also be called if the import was successful.</li></ul><hr><p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>
---@field valueChecker? fun(k: number|string, v: any): boolean Helper function for validating values when checking profile data, returning true if the value is to be accepted as valid
---@field onRecovery? fun(profileData: table, recoveredData: table): recoveryMap: table<string, recoveryData>|nil Function to call when removed data is to be recovered when checking profile data, providing a way to dynamically create a recovery map based on the recovered data<hr><p>@*param* `profileData` table — Reference to the profile data table being checked</p><p>@*param* `recoveredData` table — All removed recoverable data packed in a table</p><hr><p>@*return* `recoveryMap` table<string, recoveryData>|nil — Save removed profile data from matching key chains under the specified key when checking profile data<ul><li>***Example:*** String chain of keys pointing to the removed old data to be recovered from **profileData**: `"keyOne[2].keyThree.keyFour[1]"`.</li><li>***Note:*** Using the reference of **profileData** as the root table for **saveTo** in the recovery data specifications is recommended.</li></ul></p>

--[ Attribute Value Data ]

---@class attributeValueData_base
---@field user boolean Whether the event was invoked by an action taken by the user

---@class toggleAttributeValueData : attributeValueData_base
---@field toggled boolean Whether the toggle is checked or not

---@class selectorAttributeValueData : attributeValueData_base
---@field selected? integer The index of the currently selected item

---@class multiSelectorAttributeValueData : attributeValueData_base
---@field selected? boolean[] List of item states in order<ul><li>**[*index*]** boolean? — Whether this item is currently selected or not | ***Default:*** false</li></ul>

---@class specialSelectorAttributeValueData : attributeValueData_base
---@field selected? AnchorPoint|JustifyH|JustifyV|FrameStrata The currently selected value

---@class textboxAttributeValueData : attributeValueData_base
---@field text string

---@class numericAttributeValueData : attributeValueData_base
---@field value number

---@class colorPickerAttributeValueData : attributeValueData_base
---@field color colorData Table containing the applied color values

--[ Widgets ]

--| Button

---@class sizeData_button
---@field w? number Width | ***Default:*** 80
---@field h? number Height | ***Default:*** 22

---@class buttonEventList
---@field events? table<ScriptButton, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the button and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" when the button is clicked.</li><li>***Note:*** **t.action** will automatically be called when an "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" event triggers, there is no need to register it here as well.</li></ul>

---@class buttonCreationData : labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, customizableObject, visibleObject_base, buttonEventList, togglableObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Button"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field titleOffset? offsetData Offset the position of the label of the button
---@field size? sizeData_button
---@field font? labelFontOptions List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field action? fun(self: actionButton, user: boolean) Function to call when the button is triggered (clicked by the user or triggered programmatically)<ul><li>***Note:*** This function will be called when an "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" script event happens, there's no need to register it again under **t.events.OnClick**.</li></ul><hr><p>@*param* `self` actionButton — Reference to the button widget</p><p>@*param* `user`? boolean — Marking whether the call is due to a user interaction or not | ***Default:*** false</p>
---@field attributeEvents? table<string|ButtonAttributes, fun(...: any)> Table of key, value pairs of the names of custom widget attributes and the functions to assign as event handlers called when [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) events trigger for specific custom widget attributes

---@class contextButtonCreationData : contextMenuItem, titledObject_base, tooltipDescribableObject, contextItemLabelJustify, buttonEventList, togglableObject
---@field name? string Unique string to append this to the name of **contextMenu** when setting the name | ***Default:*** "Item" *followed by the the increment of the last index of* **contextMenu.items**<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field font? labelFontOptions_small List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label | ***Default:*** *small default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>

--| Toggle

---@class sizeData_toggle
---@field w? number Width | ***Default:*** **t.label** and 180 or **t.size.h**
---@field h? number Height | ***Default:*** 26

---@class toggleCreationData : labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base, togglableObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Toggle"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_toggle
---@field events? table<ScriptButton, fun(self: checkbox, state: boolean, button?: string, down?: boolean)> Table of key, value pairs of the names of script event handlers to be set for the checkbox and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` Frame ― Reference to the toggle frame</p><p>@*param* `state` boolean ― The checked state of the toggle frame</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** "LeftButton"</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** false</p></li></ul>
---@field attributeEvents? table<string|ToggleAttributes, fun(...: any)> Table of key, value pairs of the names of custom widget attributes and the functions to assign as event handlers called when [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) events trigger for specific custom widget attributes
---@field optionsData? booleanOptionsData If set, add the checkbox to the options data table to save & load its value automatically to/from the specified workingTable

---@class sizeData_radioButton
---@field w? number Width | ***Default:***  **t.label** and 160 or **t.size.h**
---@field h? number Height | ***Default:*** 16

---@class radioButtonCreationData : toggleCreationData
---@field size? sizeData_radioButton
---@field clearable? boolean Whether this radio button should be clearable by right clicking on it or not | ***Default:*** false<ul><li>***Note:*** The radio button will be registered for "RightButtonUp" triggers to call "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" events with **button** = "RightButton".</li></ul>
---@field events? table<ScriptButton, fun(self: radioButton, state: boolean, button?: string, down?: boolean)> Table of key, value pairs of the names of script event handlers to be set for the radio button and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` Frame ― Reference to the toggle frame</p><p>@*param* `state` boolean ― The checked state of the toggle frame</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** "LeftButton"</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** false</p></li></ul>

--| Selector

---@class selectorItem
---@field title? string Text to be shown on the right of the item to represent the item within the selector frame (if **t.labels** is true)
---@field tooltip? itemTooltipTextData List of text lines to be added to the tooltip of the item displayed when mousing over the frame<ul><li>***Note:*** Item tooltips are not available for classic dropdowns.</li></ul>
---@field onSelect? function The function to be called when the item is selected by the user

---@class selectorCreationData_base : labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base, togglableObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Selector"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field width? number The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 160 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to **t.width** if **t.columns** is 1 and **t.width** is specified.</li></ul>
---@field items (selectorItem|radioButton)[] Table containing subtables with data used to create item widgets, or already existing radio buttons
---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** true
---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1
---@field events? table<ScriptFrame, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the selector frame and the functions to assign as event handlers called when they trigger
---@field attributeEvents? table<string|SelectorAttributes, fun(...: any)> Table of key, value pairs of the names of custom widget attributes and the functions to assign as event handlers called when [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) events trigger for specific custom widget attributes
---@field onItemsUpdated? function Function to call when the list of selector items have been updated

---@class clearableSelector
---@field clearable? boolean Whether the selector input should be clearable by right clicking on its radio buttons or not (the functionality of **setSelected** called with nil to clear the input will not be affected) | ***Default:*** false

---@class selectorCreationData : selectorCreationData_base, clearableSelector
---@field selected? integer The index of the item to be set as selected on load | ***Default:*** nil *(no selection)*
---@field onSelection? fun(index?: integer) The function to be called after a radio button was clicked and an item was selected, or the input was cleared by the user<hr><p>@*param* `index`? integer — The index of the currently selected item</p><ul><li>***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be invoked whenever an item is selected *(see below)*.</li></ul>
---@field optionsData? integerOptionsData If set, add the selector to the options data table to save & load its value automatically to/from the specified workingTable

---@class limitValues
---@field min? integer The minimal number of items that need to be selected at all times | ***Default:*** 1
---@field max? integer The maximal number of items that can be selected at once | ***Default:*** #**t.items** *(all items)*

---@class multiSelectorCreationData : selectorCreationData_base
---@field limits? limitValues Parameters to specify the limits of the number of selectable items
---@field items (selectorItem|checkbox)[] Table containing subtables with data used to create item widgets, or already existing checkboxes
---@field selections? boolean[] List of item states to set in order | ***Default:*** nil *(no selected items)*<ul><li>**[*index*]** boolean? — Whether this item should be set as selected or not | ***Default:*** false</li></ul>
---@field onSelection? fun(selections?: boolean[]) The function to be called after a checkbox was clicked and an item was selected, or the input was cleared by the user<hr><p>@*param* `selections`? boolean[] — List of current item states in order</p><ul><li>***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be invoked whenever an item is selected *(see below)*.</li></ul>
---@field optionsData? booleanArrayOptionsData If set, add the selector to the options data table to save & load its value automatically to/from the specified workingTable

---@class specialSelectorCreationData : selectorCreationData_base, clearableSelector
---@field itemset string Specify what type of selector should be created | ***Value:*** "anchor"|"justifyH"|"justifyV"|"frameStrata"<ul><li>***Note:*** Setting this to "anchor" will use the set of [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors) items.</li><li>***Note:*** Setting this to "justifyH" will use the set of horizontal text alignment items (JustifyH).</li><li>***Note:*** Setting this to "justifyV" will use the set of vertical text alignment items (JustifyV).</li><li>***Note:*** Setting this to "frameStrata" will use the set of [FrameStrata](https://wowpedia.fandom.com/wiki/Frame_Strata) items (excluding "WORLD").</li></ul>
---@field selected? integer The item to be set as selected on load | ***Default:*** 0
---@field onSelection? fun(selected?: AnchorPoint|JustifyH|JustifyV|FrameStrata) The function to be called after a radio button was clicked and an item was selected, or the input was cleared by the user<hr><p>@*param* `selected`? AnchorPoint|JustifyH|JustifyV|FrameStrata — The currently selected item</p><ul><li>***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be invoked whenever an item is selected *(see below)*.</li></ul>
---@field optionsData? specialOptionsData If set, add the selector to the options data table to save & load its value automatically to/from the specified workingTable

---@class dropdownSelectorCreationData : selectorCreationData, widgetWidthValue
---@field name? string Unique string used to set the frame name | ***Default:*** "Dropdown"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field autoClose? boolean Close the dropdown menu after an item is selected by the user | ***Default:*** true
---@field cycleButtons? boolean Add previous & next item buttons next to the dropdown | ***Default:*** true
---@field attributeEvents? table<string|DropdownAttributes, fun(...: any)> Table of key, value pairs of the names of custom widget attributes and the functions to assign as event handlers called when [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) events trigger for specific custom widget attributes

--| Textbox

---@class labelFontOptions_editbox
---@field normal? string Name of the font to be used when the widget is in its regular state | ***Default:*** "*default font based on the frame template*
---@field disabled? string Name of the font to be used when the widget is disabled | ***Default:*** *default font based on the frame template*

---@class sizeData_editbox
---@field w? number Width | ***Default:***  180
---@field h? number Height | ***Default:*** 17

---@class textboxCreationData : labeledObject, tooltipDescribableObject, arrangeableObject, positionableObject, customizableObject, visibleObject_base, togglableObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Text Box"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field text? string Text to be shown inside editbox, loaded whenever the text box is shown
---@field size? sizeData_editbox
---@field insets? insetData Table containing padding values by which to offset the position of the text in the editbox
---@field font? labelFontOptions_editbox List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field color? colorData Apply the specified color to all text in the editbox (overriding all font objects set in **t.font**)
---@field justify? justifyData_left Set the justification of the text (overriding all font objects set in **t.font**)
---@field maxLetters? number The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) | ***Default:*** 0 (*no limit*)
---@field readOnly? boolean The text will be uneditable if true | ***Default:*** false
---@field unfocusOnEnter? boolean Whether to automatically clear the focus from the editbox when the ENTER key is pressed | ***Default:*** true
---@field events? table<ScriptEditBox, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the editbox frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnChar](https://wowpedia.fandom.com/wiki/UIHANDLER_OnChar)" will be called with custom parameters:<p>@*param* `self` Frame ― Reference to the editbox frame</p><p>@*param* `char` string ― The UTF-8 character that was typed</p><p>@*param* `text` string ― The text typed into the editbox</p></li><li>***Note:*** "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:<p>@*param* `self` Frame ― Reference to the editbox frame</p><p>@*param* `user` string ― True if the value was changed by the user, false if it was done programmatically</p><p>@*param* `text` string ― The text typed into the editbox</p></li><li>***Note:*** "[OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:<p>@*param* `self` Frame ― Reference to the editbox frame</p><p>@*param* `text` string ― The text typed into the editbox</p></li></ul>
---@field attributeEvents? table<string|TextboxAttributes, fun(...: any)> Table of key, value pairs of the names of custom widget attributes and the functions to assign as event handlers called when [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) events trigger for specific custom widget attributes
---@field optionsData? stringOptionsData If set, add the editbox to the options data table to save & load its value automatically to/from the specified workingTable

---@class multilineTextboxCreationData : textboxCreationData, scrollSpeedData
---@field size? sizeData
---@field charCount? boolean Show or hide the remaining number of characters | ***Default:*** **t.maxLetters** > 0
---@field scrollToTop? boolean Automatically scroll to the top when the text is loaded or changed while not being actively edited | ***Default:*** false
---@field scrollEvents? table<ScriptScrollFrame, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the scroll frame of the editbox and the functions to assign as event handlers called when they trigger

---@class copyboxCreationData : labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base
---@field name? string Unique string used to set the frame name | ***Default:*** "Copy Box"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_editbox
---@field layer? DrawLayer
---@field text string The copyable text to be shown
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormal"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field color? colorData Apply the specified color to the text (overriding **t.font**)
---@field justify? string Set the horizontal alignment of the label: "LEFT"|"RIGHT"|"CENTER" (overriding **t.font**) | ***Default:*** "LEFT"
---@field flipOnMouse? boolean Hide/Reveal the editbox on mouseover instead of after a click | ***Default:*** false
---@field colorOnMouse? colorData If set, change the color of the text on mouseover to the specified color (if **t.flipOnMouse** is false) | ***Default:*** *no color change*

--| Numeric

---@class numericValueData
---@field min number Lower numeric value limit | ***Range:*** (any, **t.value.max**)
---@field max number Upper numeric value limit | ***Range:*** (**t.value.min**, any)
---@field increment? number Size of value increment | ***Default:*** *the value can be freely changed (within range)*
---@field fractional? integer If the value is fractional, display this many decimal digits | ***Default:*** *the most amount of digits present in the fractional part of* **t.value.min**, **t.value.max** *or* **t.value.increment**

---@class numericSliderCreationData : labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, widgetWidthValue, visibleObject_base, togglableObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Slider"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field value numericValueData
---@field valueBox? boolean Whether or not should the slider have an [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) as a child to manually enter a precise value to move the slider to | ***Default:*** true
---@field sideButtons? boolean Whether or not to add increase/decrease buttons next to the slider to change the value by the increment set in **t.step** | ***Default:*** true
---@field step? number Add/subtract this much when clicking the increase/decrease buttons | ***Default:*** **t.value.increment** or (t.value.max - t.value.min) / 10
---@field altStep? number If set, add/subtract this much when clicking the increase/decrease buttons while holding ALT | ***Default:*** *no alternative step value*
---@field events? table<ScriptSlider, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the slider frame and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged)" whenever the value in the slider widget is modified.</li></ul>
---@field attributeEvents? table<string|NumericAttributes, fun(...: any)> Table of key, value pairs of the names of custom widget attributes and the functions to assign as event handlers called when [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) events trigger for specific custom widget attributes
---@field optionsData? numberOptionsData If set, add the slider to the options data table to save & load its value automatically to/from the specified workingTable

--| Color Picker

---@class colorPickerCreationData : labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base, togglableObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Color Picker"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field width? number The height is defaulted to 36, the width may be specified | ***Default:*** 120
---@field startColor? colorData_whiteDefault Values to use as the starting color | ***Default:*** **t.optionsData[t.optionsData.workingTable][t.optionsData.storageKey]**<ul><li>***Note:*** If the alpha start value was not set, configure the color picker to handle RBG values exclusively instead of the full RGBA.</li></ul>
---@field onColorUpdate? fun(r: number, g: number, b: number, a?: number) The function to be called when the color is changed by user interaction<hr><p>@*param* `r` number ― Red | ***Range:*** (0, 1)</p><p>@*param* `g` number ― Green | ***Range:*** (0, 1)</p><p>@*param* `b` number ― Blue | ***Range:*** (0, 1)</p><p>@*param* `a`? number ― Opacity | ***Range:*** (0, 1) | ***Default:*** 1</p>
---@field onCancel? function The function to be called when the color change is cancelled (after calling **t.onColorUpdate**)
---@field events? table<ScriptFrame, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the color picker frame and the functions to assign as event handlers called when they trigger
---@field attributeEvents? table<string|ColorPickerAttributes, fun(...: any)> Table of key, value pairs of the names of custom widget attributes and the functions to assign as event handlers called when [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) events trigger for specific custom widget attributes
---@field optionsData? colorOptionsData If set, add the color picker to the options data table to save & load its value automatically to/from the specified workingTable

--[ Position Options ]

---@class widgetLayerOptions
---@field strata? FrameStrata Strata to pin the frame to
---@field level? integer The level of the frame to appear in within the specified strata
---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** false

---@class presetData
---@field position positionData Table of parameters to call **frame**:[SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with
---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** false
---@field layer? widgetLayerOptions Table containing the screen layer parameters of the frame

---@class presetItemData
---@field title string Text to represent the item within the dropdown frame
---@field tooltip? presetTooltipTextData List of text lines to be added to the tooltip of the item in the dropdown displayed when mousing over it or the menu toggle button
---@field onSelect? function The function to be called when the dropdown item is selected before the specific preset is applied<ul><li>***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will be invoked whenever an item is selected *(see* ***WidgetToolbox*.CreateDropdown(...)***)*.</li></ul>
---@field data? presetData Table containing the preset data to be modified by the position options widgets and applied to **frame** on demand

---@class customPresetData
---@field index? integer Index of the custom preset modifiable by the user | ***Default:*** 1
---@field workingTable table Reference to the operational table containing the custom preset data to be modified live by preset management widgets<ul><li>***Note:*** The working table specified here will be used as **t.presets.items[t.presets.custom.index].data** instead of the data table defined for the specific preset.</li></ul>
---@field storageTable table Reference to the table within the SavedVariables(PerCharacter) addon database where the custom preset data is committed to when the custom preset is saved<ul><li>***Note:*** The storage table is expected to mirror *t.presets.custom.workingTable*.</li></ul>
---@field defaultsTable table Reference to the table containing the default custom preset values<ul><li>***Note:*** The defaults table should contain values under matching keys to the values within *t.presets.custom.workingTable*.</li></ul>
---@field onSave? function Called when the accept button is pressed when saving the custom preset or by calling **saveCustomPreset** *(see below)*
---@field onReset? function Called when the accept button is pressed when resetting the custom preset or by calling **resetCustomPreset** *(see below)*

---@class presetItemList
---@field items presetItemData[] Table containing the dropdown items described within subtables
---@field onPreset? fun(index?: integer) Called after a preset is selected and applied via the dropdown widget or by calling **applyPreset**<hr><p>@*param* `index`? integer — The index of the currently selected item</p><hr><ul><li>***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be invoked whenever an item is selected *(see* ***WidgetToolbox*.CreateDropdown(...)***)*.</li></ul>
---@field custom? customPresetData When set, add widgets to manage a user-modifiable custom preset

---@class movabilityData_positioning : movabilityData
---@field modifier? ModifierKey The specific (or any) modifier key required to be pressed down to move **frame** (if **frame** has the "OnUpdate" script defined) | ***Default:*** "SHIFT"<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://wowpedia.fandom.com/wiki/API_IsModifierKeyDown) is used.</li></ul>

---@class positionOptionsCreationData
---@field canvas Frame The canvas frame child item of an existing options category page to add the position panel to
---@field frame Frame Reference to the frame to create the position options for
---@field frameName string Include this string in the tooltips and descriptions of options widgets when referring to **t.frame**
---@field presets? presetItemList Reference to the table containing **t.frame** position presets to be managed by options widgets added when set
---@field setMovable? movabilityData_positioning When specified, set **t.frame** as movable, dynamically updating the position options widgets when it's moved by the user
---@field dependencies? dependencyRule[] Automatically disable or enable all widgets in the new panel based on the rules described in subtables
---@field optionsKey string A unique key referencing a collection of options data management rules to handle together
---@field workingTable table Reference to the operational options table containing the values modified live by the position options widgets<ul><li>**position** table — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with<ul><li>**anchor** [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)</li><li>**relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)</li><li>**relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)</li><li>**offset** table<ul><li>**x** number</li><li>**y** number</li></ul></li></ul></li><li>**keepInBounds**? boolean — When set, add a toggle for a value used for **t.frame**:[SetClampedToScreen(...)](https://wowpedia.fandom.com/wiki/API_Frame_SetClampedToScreen)</li><li>**layer**? boolean — When set, add screen layer options<ul><li>**strata**? [FrameStrata](https://wowpedia.fandom.com/wiki/Frame_Strata) — Used for **t.frame**:[SetFrameStrata(...)](https://wowpedia.fandom.com/wiki/API_Frame_SetFrameStrata)</li><li>**keepOnTop**? boolean — When set, add a toggle for a value used for **t.frame**:[SetToplevel(...)](https://wowpedia.fandom.com/wiki/API_Frame_SetToplevel)</li><li>**level**? boolean — When set, add a slider for a value used for **t.frame**:[SetFrameLevel](https://wowpedia.fandom.com/wiki/API_Frame_SetFrameLevel)</li></ul></li><p></p><li>***Note:*** When **t.workingTable.position.relativeTo** or **t.workingTable.position.relativePoint** is nil, the option of setting **t.settingsData.absolutePosition** will be locked at true.</li></ul>
---@field storageTable? table Reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to when **t.frame** was successfully moved<ul><li>***Note:*** The storage table is expected to mirror **t.workingTable**.</li></ul>
---@field settingsData table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>**absolutePosition** — Whether to manage the position of **t.frame** as absolute only, disabling relative position options and converting preset data when applied</li></ul>
---@field onChangePosition? function Function to call after the value of **panel.position.anchor**, **panel.position.relativeTo**, **panel.position.relativePoint**, **panel.position.offset.x** or **panel.position.offset.y** was changed by the user or via options data management before the base onChange handler is called built-in to the functionality of the position options panel template updating the position of **t.frame**
---@field onChangeKeepInBounds? function Function to call after the value of **panel.position.keepInBounds** was changed by the user or via options data management before the base onChange handlers are called built-in to the functionality of the position options panel template updating **t.frame**
---@field onChangeStrata? function Function to call after the value of **panel.layer.strata** was changed by the user or via options data management before the base onChange handlers are called built-in to the functionality of the position options panel template updating **t.frame**
---@field onChangeLevel? function Function to call after the value of **panel.layer.level** widgets was changed by the user or via options data management before the base onChange handlers are called built-in to the functionality of the position options panel template updating **t.frame**
---@field onChangeKeepOnTop? function Function to call after the value of **panel.layer.keepOnTop** widgets was changed by the user or via options data management before the base onChange handlers are called built-in to the functionality of the position options panel template updating **t.frame**

--[ Addon Compartment ]

---@class addonCompartmentFunctions
---@field onClick? fun(addon: string, button: string, frame: Button) Called when the **addon**'s compartment button is clicked<ul><li>***Note:*** `AddonCompartmentFunc`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>
---@field onEnter? fun(addon: string, frame: Button) Called when the **addon**'s compartment button is being hovered<ul><li>***Note:*** `AddonCompartmentFuncOnEnter`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>
---@field onLeave? fun(addon: string, frame: Button) Called when the **addon**'s compartment button is stopped being hovered<ul><li>***Note:*** `AddonCompartmentFuncOnLeave`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>

--[ Profiles ]

---@class profile
---@field title string Display name of the profile
---@field data table Custom profile data

---@class profileStorage
---@field profiles profile[] List of profiles