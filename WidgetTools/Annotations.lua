--[[ MISC ]]

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

---@alias FontFlags
---|"MONOCHROME"
---|"OUTLINE"
---|"THICK"

---@alias AnyFrameObject
---|Frame
---|Button
---|CheckButton
---|EditBox
---|Slider
---|Texture
---|FontString

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

---@alias ExtendedHyperlinkType
---|HyperlinkType
---|"addon"
---|"mawpower"

---@class attributeEventData
---@field name string
---@field handler fun(...: any)

---@alias WidgetTypeName
---|"SettingsPage"
---|"DataManagementPage"
---|"ActionButton"
---|"Toggle"
---|"Selector"
---|"Multiselector"
---|"Textbox"
---|"Numeric"
---|"ColorPicker"

---@alias AnyWidgetType
---|actionButton
---|toggle
---|selector
---|textbox
---|numeric
---|colorPicker


--[[ TABLE MANAGEMENT ]]

---@class recoveryData
---@field saveTo table List of references to the tables to save the recovered piece of data to
---@field saveKey string|number Save the data under this kay within the specified recovery tables
---@field convertSave? fun(recovered: any): converted: any Function to convert or modify the recovered old data before it is saved


--[[ UI OBJECT ]]

---@class childObject
---@field parent AnyFrameObject Reference to the frame to set as the parent

---@class optionalChildObject
---@field parent? AnyFrameObject Reference to the frame to set as the parent

---@class namedObject_base
---@field name? string Unique string used to set the frame name | ***Default:*** "Frame"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>

---@class namedChildObject : optionalChildObject, namedObject_base
---@field append? boolean Instead of setting the specified name by itself, append it to the name of the specified parent frame | ***Default:*** true if t.parent ~= UIParent


--[[ POSITION & DIMENSIONS ]]

---@class axisData
---@field h? boolean Horizontal x axis | ***Default:*** false
---@field v? boolean Vertical y axis | ***Default:*** false

--| Positioning

---@class offsetData
---@field x? number Horizontal offset value | ***Default:*** 0
---@field y? number Vertical offset value | ***Default:*** 0

---@class positionData_base
---@field anchor? FramePoint ***Default:*** "TOPLEFT"
---@field relativeTo? AnyFrameObject|string Frame reference or name, or "nil" to anchor relative to screen dimensions | ***Default:*** "nil"<ul><li>***Note:*** When omitting the value by providing nil, instead of the string "nil", anchoring will use the parent region (if possible, otherwise the default behavior of anchoring relative to the screen dimensions will be used).</li><li>***Note:*** Default to "nil" when an invalid frame name is provided.</li></ul>
---@field relativePoint? FramePoint ***Default:*** **anchor**

---@class positionData : positionData_base
---@field offset? offsetData

---@class pointData
---@field relativeTo AnyFrameObject
---@field relativePoint FramePoint
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
---@field initialize? fun(container?: Frame, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>
---@field arrangement? arrangementData If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table

---@class initializableOptionsContainer : initializableContainer
---@field initialize? fun(container?: Frame, width: number, height: number, category?: string, keys?: string[], name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `category`? string A unique string used for categorizing options data management rules & change handler scripts</p><p>@*param* `keys`? string[] A list of unique strings appended to **category** linking a subset of options data rules to be handled together in the specified order</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

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
---@field modifier? ModifierKey The specific (or any) modifier key required to be pressed down to move **t.frame** (if **t.frame** has the "OnUpdate" script defined) | ***Default:*** nil *(no modifier)*<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://wowpedia.fandom.com/wiki/API_IsModifierKeyDown) is used.</li></ul>
---@field triggers? Frame[] List of frames that should handle inputs to initiate or stop the movement when interacted with | ***Default:*** **t.frame**
---@field events? movementEvents Table containing functions to call when certain movement events occur
---@field cursor? boolean If true, change the cursor to a movement cross when mousing over **t.frame** and **t.modifier** is pressed down if set | ***Default:*** **t.modifier** ~= nil


--[[ VISIBILITY ]]

--| Strata & Level

---@class visibleObject_base
---@field visible? boolean Whether to make the frame visible during initialization or not | ***Default:*** true
---@field frameStrata? FrameStrata Pin the frame to the specified strata
---@field frameLevel? integer The ordering level of the frame within its strata to set
---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** false


--[[ COLOR ]]

---@class rgbData_base
---@field r number Red | ***Range:*** (0, 1)
---@field g number Green | ***Range:*** (0, 1)
---@field b number Blue | ***Range:*** (0, 1)

---@class rgbData_optional
---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 1
---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 1
---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 1

---@class alpha_opaqueDefault
---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1

---@class colorData : rgbData_base, alpha_opaqueDefault

---@class optionalColorData : rgbData_base, alpha_opaqueDefault

---@class colorData_whiteDefault : colorData
---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 1
---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 1
---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 1

---@class colorData_blackDefault : colorData
---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 1
---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 1
---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 1


--[[ FONT & TEXT ]]

---@class justifyData
---@field h? JustifyHorizontal Horizontal text alignment
---@field v? JustifyVertical Vertical text alignment

---@class justifyData_left
---@field h? JustifyHorizontal Horizontal text alignment| ***Default:*** "LEFT"
---@field v? JustifyVertical Vertical text alignment | ***Default:*** "MIDDLE"

---@class justifyData_centered : justifyData_left
---@field h? JustifyHorizontal Horizontal text alignment| ***Default:*** "CENTER"

---@class fontData
---@field path string Path to the font file relative to the WoW client directory<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Fonts/Font.ttf), otherwise use `\\`.</li><li>***Note:*** **File format:** Font files must be in TTF or OTF format.</li></ul>
---@field size number The default display size of the new font object
---@field style TBFFlags|FontFlags Comma separated string of font styling flags

---@class fontCreationData
---@field name string A unique identifier name to set for the hew font object to be accessed by and referred to later<ul><li>***Note:*** If a font object with that name already exists, it will *not* be overwritten and its reference key will be returned.</li><li>***Example:*** Access the reference to the font object created via the globals table: `local customFont = _G["CustomFontName"]`.</li></ul>
---@field template? FontObject An existing [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to copy as a baseline
---@field font? fontData Table containing font properties used for [SetFont](https://wowpedia.fandom.com/wiki/API_FontInstance_SetFont) (overriding **t.template**)
---@field color? colorData_whiteDefault Apply the specified color to the font (overriding **t.template**)
---@field spacing? number Set the character spacing of the text using this font (overriding **t.template**) | ***Default:*** 0
---@field shadow? { offset: offsetData, color: colorData_blackDefault} Set a text shadow with the following parameters (overriding **t.template**)
---@field justify? justifyData_centered Set the justification of the text using font (overriding **t.template**)
---@field wrap? boolean Whether or not to allow the text lines using this font to wrap (overriding **t.template**) | ***Default:*** true

---@class textCreationData : positionableObject
---@field parent AnyFrameObject he frame to create the text in
---@field name? string String appended to the name of **t.parent** used to set the name of the new [FontString](https://wowpedia.fandom.com/wiki/) | ***Default:*** "Text"
---@field width? number
---@field layer? DrawLayer
---@field text? string Text to be shown
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used | ***Default:*** "GameFontNormal"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field color? colorData Apply the specified color to the text (overriding **t.font**)
---@field justify? justifyData Set the justification of the text (overriding **t.font**)
---@field wrap? boolean Whether or not to allow the text lines to wrap (overriding **t.font**) | ***Default:*** true

---@class labelFontOptions
---@field normal? string Name of the font to be used when the widget is in its regular state | ***Default:*** "GameFontHighlight"
---@field disabled? string Name of the font to be used when the widget is disabled | ***Default:*** "GameFontDisable"

---@class labelFontOptions_highlight
---@field normal? string Name of the font to be used when the widget is in its regular state | ***Default:*** "GameFontNormal"
---@field highlight? string Name of the font to be used when the widget is being hovered | ***Default:*** "GameFontHighlight"
---@field disabled? string Name of the font to be used when the widget is disabled | ***Default:*** "GameFontDisable"

---@class labelFontOptions_small
---@field normal? string Name of the font to be used when the widget is in its regular state | ***Default:*** "GameFontHighlightSmall"
---@field disabled? string Name of the font to be used when the widget is disabled | ***Default:*** "GameFontDisableSmall"

---@class labelFontOptions_small_highlight
---@field normal? string Name of the font to be used when the widget is in its regular state | ***Default:*** "GameFontNormalSmall"
---@field highlight? string Name of the font to be used when the widget is being hovered | ***Default:*** "GameFontHighlightSmall"
---@field disabled? string Name of the font to be used when the widget is disabled | ***Default:*** "GameFontDisableSmall"

---[ Title & Description ]

---@class titleData
---@field anchor? FramePoint ***Default:*** "TOPLEFT"
---@field offset? offsetData The offset from the anchor point relative to the specified frame
---@field width? number ***Default:*** *width of the parent frame*
---@field text string Text to be shown as the main title of the frame
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormal"
---@field color? colorData Apply the specified color to the title (overriding **t.title.font**)
---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding **t.title.font**) | ***Default:*** "LEFT"

---@class descriptionData
---@field offset? offsetData The offset from the "BOTTOMLEFT" point of the main title
---@field width? number ***Default:*** *width of the parent frame*
---@field text string Text to be shown as the description of the frame
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontHighlightSmall"
---@field color? colorData Apply the specified color to the description (overriding **t.description.font**)
---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding **t.description.font**) | ***Default:*** "LEFT"

---@class titleCreationData
---@field parent AnyFrameObject The frame panel to add the title & description to
---@field title? titleData
---@field description? descriptionData

---@class titledObject_base
---@field title? string Text to be displayed as the title | ***Default:*** **t.name**

---@class labeledObject_base
---@field label? boolean Whether to show the title textline or not | ***Default:*** true

---@class titledChildObject : namedChildObject, titledObject_base

---@class labeledChildObject : titledChildObject, labeledObject_base

---@class describableObject
---@field description? string Text to be displayed as the subtitle or description | ***Default:*** *no description textline shown*


--[[ TEXTURE ]]

---@class pathData_ChatFrameDefault
---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/ChatFrame/ChatFrameBackground"<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>

---@class wrapData
---@field h? WrapMode|boolean Horizontal | ***Value:*** true = "REPEAT" | ***Default:*** "CLAMP"
---@field v? WrapMode|boolean Vertical | ***Value:*** true = "REPEAT" | ***Default:*** "CLAMP"

---@class tileData
---@field h? boolean Horizontal | ***Default:*** false
---@field v? boolean Vertical | ***Default:*** false

---@class edgeCoordinates
---@field l number Left | ***Reference Range:*** (0, 1) | ***Default:*** 0
---@field r number Right | ***Reference Range:*** (0, 1) | ***Default:*** 1
---@field t number Top | ***Value:*** *using canvas coordinates (inverted y axis)* | | ***Reference Range:*** (0, 1) | ***Default:*** 0
---@field b number Bottom | ***Value:*** *using canvas coordinates (inverted y axis)* | | ***Reference Range:*** (0, 1) | ***Default:*** 1

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

---@class textureCreationData : positionableObject, pathData_ChatFrameDefault
---@field parent AnyFrameObject Reference to the frame to set as the parent of the new texture
---@field name? string String appended to the name of **t.parent** used to set the name of the new texture | ***Default:*** "Texture"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData ***Default:*** *size of* **parent**
---@field layer? DrawLayer
---@field level? integer Sublevel to set within the specified draw layer | ***Range:*** (-8, 7)
---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** *no tiling*
---@field wrap? wrapData Set the warp mode for each axis
---@field filterMode? FilterMode | ***Default:*** "LINEAR"
---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis
---@field color? colorData Apply the specified color to the texture
---@field edges? edgeCoordinates Edge coordinate offsets
---@field vertices? vertexCoordinates Vertex coordinate offsets<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, **t.edges** will be used first ignoring **t.vertices**.</li></ul>
---@field events? table<ScriptRegion, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the texture object and the functions to assign as event handlers called when they trigger

---@class textureUpdateData
---@field position? positionData Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** **t.position**
---@field size? sizeData | ***Default:*** **t.size**
---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** **t.path**<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
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
---@field frame? AnyFrameObject Reference to the frame to add the listener script to | ***Default:*** **t.parent**
---@field rule? fun(self: Frame, ...: any): data: textureUpdateData|nil Evaluate the event and specify the texture updates to set, or, if nil, restore the base values unconditionally on event trigger<hr><p>@*param* `self` AnyFrameObject — Reference to **updates[*key*].frame**</p><p>@*param* `...` any — Any leftover arguments will be passed from the handler script to **updates[*key*].rule**</p><hr><p>@*return* `data` textureUpdateData|nil — Parameters to update the texture with | ***Default:*** **t**</p>


--[[ LINE ]]

---@class lineCreationData
---@field parent AnyFrameObject Reference to the frame to set as the parent of the new line
---@field name? string String appended to the name of **t.parent** used to set the name of the new line | ***Default:*** "Line"
---@field startPosition pointData Parameters to call [Line:SetStartPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetStartPoint) with
---@field endPosition pointData Parameters to call [Line:SetEndPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetEndPoint) with
---@field thickness? number ***Default:*** 4
---@field layer? DrawLayer 
---@field level? integer Sublevel to set within the draw layer specified with **t.layer** | ***Range:*** (-8, 7)
---@field color? colorData Apply the specified color to the line


--[[ BACKDROP ]]

---@class insetData
---@field l? number Left side | ***Default:*** 0
---@field r? number Right side | ***Default:*** 0
---@field t? number Top | ***Default:*** 0
---@field b? number Bottom | ***Default:*** 0

---@class backdropBackgroundTextureData : pathData_ChatFrameDefault
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
---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/Tooltips/UI-Tooltip-Border"<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
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
---@field trigger? AnyFrameObject Reference to the frame to add the listener script to | ***Default:*** **frame**
---@field rule? fun(self: Frame, ...: any): backdropUpdate: backdropUpdateData|nil, fill: boolean|nil Evaluate the event and specify the backdrop updates to set, or, if nil, restore the base **backdrop** unconditionally on event trigger<ul><li>***Note:*** Return an empty table `{}` for **backdropUpdate** and true for **fill** in order to restore the base **backdrop** after evaluation.</li><li>***Note:*** Return an empty table `{}` for **backdropUpdate** and false or nil for **fill** to do nothing (keep the current backdrop).</li></ul><hr><p>@*param* `self` AnyFrameObject ― Reference to **updates[*key*].frame**</p><p>@*param* `...` any ― Any leftover arguments will be passed from the handler script to **updates[*key*].rule**</p><hr><p>@*return* `backdropUpdate`? backdropUpdateData|nil ― Parameters to update the backdrop with | ***Default:*** nil *(remove the backdrop)*</p><p>@*return* `fill`? boolean|nil ― If true, fill the specified defaults for the unset values in **backdropUpdates** with the values provided in **backdrop** at matching keys, if false, fill them with their corresponding values from the currently set values of **frame**.[backdropInfo](https://wowpedia.fandom.com/wiki/BackdropTemplate#Table_structure), **frame**:[GetBackdropColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropColor) and **frame**:[GetBackdropBorderColor()](https://wowpedia.fandom.com/wiki/API_Frame_GetBackdropBorderColor) | ***Default:*** false</p>

---@class customizableObject
---@field backdrop? backdropData Parameters to set the custom backdrop with
---@field backdropUpdates? table<AnyScriptType, backdropUpdateRule> Table of key, value pairs containing the list of events to set listeners for assigned to **t.backdropUpdates[*key*].frame**, linking backdrop changes to it, modifying the specified parameters on trigger
--- - ***Note:*** All update rules are additive, calling ***WidgetToolbox*.SetBackdrop(...)** multiple times with **t.backdropUpdates** specified *will not* override previously set update rules. The base **backdrop** values used for these old rules *will not* change by setting a new backdrop via ***WidgetToolbox*.SetBackdrop(...)** either!


--[[ CHAT CONTROL ]]

---@alias chatCommandColorNames
---|"title"
---|"content"
---|"command"
---|"description"

---@class chatCommandColors
---@field title colorData Color for the addon title used for branding chat messages
---@field content colorData Color for chat message contents appended after the title (used for success & error responses)
---@field command colorData Used to color the registered chat commands when they are being listed
---@field description colorData Used to color the description of registered chat commands when they are being listed

---@class chatCommandData
---@field command string Name of the slash command word (no spaces) to recognize after the keyword (separated by a space character)
---@field description? string|fun(): string Note to append to the first specified keyword and **command** in this command's line in the list printed out via the help command(s)
---@field handler? fun(manager: chatCommandManager, ...: string): result: boolean|nil, ...: any Function to be called when the specific command was recognized after being typed into chat<hr><p>@*param* `...` string ― Payload of the command typed, any words following the command name separated by spaces split and returned one by one</p><hr><p>@*return* `result`? boolean|nil ― Call **[*value*].onSuccess** if true or **[*value*].onError** if false (not nil) after the operation | ***Default:*** nil *(no response)*</p><p>@*return* `...` any ― Leftover arguments to be passed over to response handler scripts</p>
---@field success? string|fun(...: any): string Response message (or a function returning the message string) to print out on success after **commands[*value*].handler** returns with true<p>@*param* `...` any ― Leftover arguments passed over by the handler script</p>
---@field error? string|fun(...: any): string Response message (or a function returning the message string) to print out on error after **commands[*value*].handler** returns with false (not nil)<hr><p>@*param* `...` any ― Any leftover arguments passed over by the handler script</p>
---@field onSuccess? fun(manager: chatCommandManager, ...: any) Function to call after **commands[*value*].handler** returns with true to handle a successful result (after **success** is printed)<hr><p>@*param* `manager` chatCommandManager ― Reference to this chat command manager</p><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
---@field onError? fun(manager: chatCommandManager, ...: any) Function to call after **commands[*value*].handler** returns with false (not nil) to handle a failed result (after **error** is printed)<hr><p>@*param* `manager` chatCommandManager ― Reference to this chat command manager</p><p>@*param* `...` any ― Any leftover arguments returned by the handler script will be passed over</p>
---@field hidden? boolean Skip printing this command when listing out chat commands on help | ***Default:*** false<ul><li>***Note:*** If **onHelp** is specified, it will still be called even if the command is hidden.</li></ul>
---@field onHelp? function Function to call after a specified help command has been triggered or an invalid command is typed with the specified keywords

---@class chatCommandManagerCreationData
---@field commands chatCommandData[] Indexed table with the list of commands to register under the specified **keywords**
---@field colors chatCommandColors Color palette used when printing out default-formatted chat messages
---@field defaultHandler? fun(commandManager: chatCommandManager, command: string, ...: string) Default handler function to call when an unrecognized command is typed, executed before a help command is triggered, listing all registered commands<hr><p>@*param* `commandManager` commandManager ― Reference to the command manager</p><p>@*param* `command` string ― The unrecognized command typed after the keyword (separated by a space character)</p><p>@*param* `...` string Payload of the command typed, any words following the command name separated by spaces (split, returned unpacked)</p>
---@field onWelcome? function Called when the welcome message with keyword hints is printed out


--[[ TOOLTIP ]]

---@class tooltipLineData
---@field text string Text to be displayed in the line
---@field font? string|FontObject The FontObject to set for this line | ***Default:*** GameTooltipTextSmall
---@field color? rgbData_base Table containing the RGB values to color this line with | ***Default:*** HIGHLIGHT_FONT_COLOR (white)
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

---@class tooltipUpdateData
---@field title? string String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR) | ***Default:*** **owner.tooltipData.title**
---@field lines? tooltipLineData[] Table containing the lists of parameters for the text lines after the title | ***Default:*** **owner.tooltipData.lines**
---@field tooltip? GameTooltip Reference to the tooltip frame to set up | ***Default:*** **owner.tooltipData.tooltip**
---@field offset? offsetData Values to offset the position of **tooltipData.tooltip** by | ***Default:*** **owner.tooltipData.offset**
---@field position? positionData_base Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** **owner.tooltipData.position**
---@field flipColors? boolean Flip the default color values of the title and the text lines | ***Default:*** **owner.tooltipData.flipColors**
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


--[[ DEPENDENCIES ]]

---@class dependencyRule
---@field frame AnyFrameObject|toggle|selector|multiselector|specialSelector|textbox|numeric Tie the state of the widget to the evaluation of the current value of the frame specified here
---@field evaluate? fun(value?: any): evaluation: boolean Call this function to evaluate the current value of the specified frame, enabling the dependant widget when true, or disabling it when false is returned | ***Default:*** *no evaluation, only for checkboxes*<ul><li>***Note:*** **evaluate** must be defined if the [FrameType](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types) if **frame** is not "CheckButton".</li><li>***Overloads:***</li><ul><li>function(`value`: boolean) -> `evaluation`: boolean — If **frame** is recognized as a checkbox</li><li>function(`value`: string) -> `evaluation`: boolean — If **frame** is recognized as an editbox</li><li>function(`value`: number) -> `evaluation`: boolean — If **frame** is recognized as a slider</li><li>function(`value`: integer) -> `evaluation`: boolean — If **frame** is recognized as a dropdown or selector</li><li>function(`value`: boolean[]) -> `evaluation`: boolean — If **frame** is recognized as multiselector</li><li>function(`value`: AnchorPoint|JustifyH|JustifyV|FrameStrata) -> `evaluation`: boolean — If **frame** is recognized as a special selector</li><li>function(`value`: nil) -> `evaluation`: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*</li></ul></ul>

---@class togglableObject
---@field disabled? boolean If true, set the state of this widget to be disabled during initialization | ***Default:*** false<ul><li>***Note:*** Dependency rule evaluations may re-enable the widget after initialization.</li></ul>
---@field dependencies? dependencyRule[] Automatically enable or disable the widget based on the set of rules described in subtables


--[[ OPTIONS DATA MANAGEMENT ]]

---@class optionsRule
---@field widget checkbox|radioButton|radioSelector|checkboxSelector|specialSelector|dropdownSelector|textbox|multilineEditbox|numericSlider|colorPicker Reference to the widget to be saved & loaded data to/from with defined **loadData** and **saveData** functions
---@field onChange? string[] List of keys referencing functions to be called after the value of **widget** was changed by the user or via options data management

---@class optionsData
---@field category? string A unique string used for categorizing options data management rules & change handler scripts | ***Default:*** "WidgetTools" *(register as a global rule)*
---@field key? string A unique string appended to **category** linking a subset of options data rules to be handled together | ***Default:*** "" *(category-wide rule)*
---@field index? integer Set when to place this widget in the execution order when saving or loading batched options data | ***Default:*** *placed at the end of the current list*
---@field onChange? table<string|integer, function|string> table<string|integer, function|string> List of new or already defined functions to call after the value of the widget was changed by the user or via options data management<ul><li>**[*key*]**? string|integer ― A unique string appended to **category** to point to a newly defined function to be added to options data management or just the index of the next function name | ***Default:*** *next assigned index*</li><li>**[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function</li><ul><li>***Note:*** Function definitions will be replaced by key references when they are registered to options data management. Functions registered under duplicate keys are overwritten.</li></ul></ul>

---@class optionsData_collection
---@field category? string A unique string used for categorizing options data management rules & change handler scripts | ***Default:*** **addon**
---@field keys? string[] An ordered list of unique strings appended to **category** linking a subset of options data rules to be handled together in the specified order via this settings category page | ***Default:*** { **t.name** or "" }

---@class optionsWidget
---@field dataManagement? optionsData If set, register this widget to options data management for batched data saving & loading and handling data changes
---@field instantSave? boolean Immediately commit the data to storage whenever it's changed via the widget | ***Default:*** true<ul><li>***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.</li></ul>

---@class optionsCategory
---@field dataManagement? optionsData_collection If set, register this settings page to options data management for batched data saving & loading and handling data changes of all linked widgets

---@class optionsFrame
---@field showDefault? boolean If true, show the default value of the widget in its tooltip | ***Default:*** true
---@field utilityMenu? boolean If true, assign a context menu to the options widget frame to allow for quickly resetting changes or the default value | ***Default:*** true


--[[ POPUP ]]

--| Dialogue

---@class popupDialogData
---@field text? string The text to display as the message in the popup window
---@field accept? string The text to display on the label of the accept button | ***Default:*** ***WidgetToolbox*.strings.misc.accept**
---@field cancel? string The text to display on the label of the cancel button | ***Default:*** ***WidgetToolbox*.strings.misc.cancel**
---@field alt? string The text to display on the label of the third alternative button
---@field onAccept? function Called when the accept button is pressed and an OnAccept event happens
---@field onCancel? function Called when the cancel button is pressed, the popup is overwritten (by another popup for instance) or the popup expires and an OnCancel event happens
---@field onAlt? function Called when the alternative button is pressed and an OnAlt event happens

--| Input Box

---@class popupInputBoxData : positionableObject, tooltipDescribableObject
---@field title? string Text to be displayed as the title | ***Default:*** *(no title)*
---@field text? string Text to set as the starting text inside the input editbox | ***Default:*** ""
---@field accept? fun(text: string) Function to call when the inputted text is accepted
---@field cancel? function Function to call when the inputted text is dismissed

--| Reload Notice

---@class reloadFrameOffsetData
---@field x? number Horizontal offset value | ***Default:*** -300
---@field y? number Vertical offset value | ***Default:*** -80

---@class reloadFramePositionData : positionData_base
---@field anchor? FramePoint ***Default:*** "TOPRIGHT"
---@field offset? offsetData

---@class reloadFrameData
---@field title? string Text to be shown as the title of the reload notice | ***Default:*** "Pending Changes" *(when the language is set to English)*
---@field message? string Text to be shown as the message of the reload notice | ***Default:*** "Reload the interface to apply the pending changes." *(when the language is set to English)*
---@field position? reloadFramePositionData Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPRIGHT", -300, -80


--[[ LITE MODE ]]

---@class liteObject
---@field lite? boolean If false, overrule **WidgetToolsDB.lite** and use full GUI functionality | ***Default:*** true


--[[ CONTAINERS ]]

--[ Frame ]

---@class frameCreationData : positionableScreenObject, arrangeableObject, visibleObject_base, initializableContainer
---@field parent? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** nil *(parentless frame)*<ul><li>***Note:*** You may use [Region:SetParent(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
---@field name? string Unique string used to set the name of the new frame | ***Default:*** nil *(anonymous frame)*<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field append? boolean When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** true if **t.name** ~= nil and **t.parent** ~= nil and **t.parent** ~= UIParent
---@field customizable? boolean Create the frame with `BackdropTemplateMixin and "BackdropTemplate"` to be easily customizable | ***Default:*** false<ul><li>***Note:*** You may use ***WidgetToolbox*.SetBackdrop(...)** to set up the backdrop quickly.</li></ul>
---@field size? sizeData_zeroDefault ***Default:*** *no size*<ul><li>***Note:*** Omitting or setting either value to 0 will result in the frame being invisible and not getting placed on the screen.</li></ul>
---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnEvent](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the **t.onEvent** table.</li></ul>
---@field onEvent? table<WowEvent, fun(self: Frame, ...: any)> Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame<ul><li>***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://wowpedia.fandom.com/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.</li><li>***Example:*** "[ADDON_LOADED](https://wowpedia.fandom.com/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.<pre>```function(self, addon)```<br>&#9;```if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch```<br>&#9;```self:UnregisterEvent("ADDON_LOADED")```<br>&#9;```--Do something```<br>```end```</pre></li></ul>

--[ ScrollFrame ]

---@class sizeData_scroll
---@field w? number Horizontal size of the scrollable child frame | ***Default:*** **t.size.width** - 16
---@field h? number Vertical size of the scrollable child frame | ***Default:*** 0 *(no height)*

---@class scrollSpeedData
---@field scrollSpeed? number Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25

---@class scrollFrameCreationData : optionalChildObject, positionableObject, initializableContainer, scrollSpeedData
---@field name? string Unique string used to append to the name of **t.parent** when setting the names of the name of the scroll parent and its scrollable child frame | ***Default:*** "Scroller" *(for the scrollable child frame)*<ul><li>***Note:*** Space characters will be removed when used for setting the frame names.</li></ul>
---@field size? sizeData_parentDefault ***Default:*** **t.parent** and *size of the parent frame* or *no size*
---@field scrollSize? sizeData_scroll ***Default:*** *size of the parent frame*

--[ Panel ]

--| Parameters

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

--| Constructors

---@class panelCreationData : labeledChildObject, describableObject, positionableScreenObject, arrangeableObject, visibleObject_base, backdropData, initializableContainer, liteObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Panel"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_panel
---@field background? backdropBackgroundData_panel Table containing the parameters used for the background
---@field border? backdropBorderData_panel Table containing the parameters used for the border
---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the panel and the functions to assign as event handlers called when they trigger
---@field initialize? fun(container?: panel, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? panel ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

--[ Context Menu ]

---@class rootDescription

--| Parameters

---@class queuedMenuItem
---@field queue? boolean If true, the item will only appear when additional items are added to the menu | ***Default:*** false

---@class sizeData_menuButton
---@field w? number Width | ***Default:*** 180
---@field h? number Height | ***Default:*** 26

--| Constructors

---@class contextMenuCreationData_base
---@field initialize? fun(menu: rootDescription) This function will be called while setting up the menu to perform specific tasks like creating menu content items right away<hr><p>@*param* `menu` rootDescription ― Reference to the container of menu elements (such as titles, widgets, dividers or other frames) for menu items to be added to during initialization</p>

---@class contextMenuCreationData : contextMenuCreationData_base
---@field parent AnyFrameObject? Reference to the frame to set as the parent | ***Default:*** UIParent *(opened at cursor position)*
---@field rightClickMenu? boolean If true, create and open the context menu via a right-click mouse click event on **parent** | ***Default:*** true
---@field leftClickMenu? boolean If true, create and open the context menu via a left-click mouse click event on **parent** | ***Default:*** false
---@field hoverMenu? boolean If true, create and open the context menu via a mouse hover event on **parent** | ***Default:*** false
---@field condition? fun(): boolean Function to call and evaluate before creating and opening the menu: if the returned value is not true, don't open the menu

---@class contextSubmenuCreationData : contextMenuCreationData_base
---@field title? string Text to be shown on the opener button item representing the submenu within the parent menu | ***Default:*** "Submenu"

---@class menuTextlineCreationData : queuedMenuItem
---@field text? string Text to be shown on the textline item within the parent menu | ***Default:*** "Title"

---@class menuButtonCreationData
---@field title? string Text to be shown on the button item within the parent menu | ***Default:*** "Button"
---@field action? fun(...: any) Function to call when the button is clicked in the menu<hr><p>@*param* `...` any</p>

---@class popupMenuCreationData : labeledChildObject, tooltipDescribableObject, positionableScreenObject, arrangeableObject, visibleObject_base, contextMenuCreationData_base
---@field parent? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** nil *(parentless frame)*<ul><li>***Note:*** You may use [Region:SetParent(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
---@field name? string Unique string used to set the frame name | ***Default:*** "PopupMenu"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_menuButton
---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnEvent](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the **t.onEvent** table.</li></ul>
---@field onEvent? table<WowEvent, fun(self: Frame, ...: any)> Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame<ul><li>***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://wowpedia.fandom.com/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.</li><li>***Example:*** "[ADDON_LOADED](https://wowpedia.fandom.com/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.<pre>```function(self, addon)```<br>&#9;```if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch```<br>&#9;```self:UnregisterEvent("ADDON_LOADED")```<br>&#9;```--Do something```<br>```end```</pre></li></ul>

--[[ SETTINGS ]]

--[ Settings Page ]

--| Constructors

---@class settingsPageScrollData : scrollSpeedData
---@field height? number Set the height of the scrollable child frame to the specified value | ***Default:*** 0 *(no height)*
---@field speed? number Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25

---@class spacingData_settingsPage
---@field l? number Space to leave on the left side | 10
---@field r? number Space to leave on the right side (doesn't need to be negated) | ***Default:*** 10
---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** **t.scroll** and 78 or 82
---@field b? number Space to leave at the bottom | ***Default:*** **t.scroll** and 10 or 22

---@class arrangementParameters_settingsPage : arrangementParameters
---@field margins? spacingData_settingsPage Inset the content inside the canvas frame by the specified amount on each side
---@field gaps? number The amount of space to leave between rows | ***Default:*** 32
---@field resize? boolean Set the height of the canvas frame to match the space taken up by the arranged content (including margins) | ***Default:*** **t.scroll** ~= nil

---@class arrangementData_settingsPage
---@field parameters? arrangementParameters_settingsPage Set of parameters to arrange the frames by: spacing, direction & resizing

---@class settingsPageCreationData_base
---@field register? boolean|settingsPage If true, register the new page to the Settings panel as a parent category or a subcategory of an already registered parent category if a reference to an existing settings category parent page provided | ***Default:*** false<ul><li>***Note:*** The page can be registered later via ***WidgetToolbox*.RegisterSettingsPage(...)**.</li></ul>
---@field name? string Unique string used to set the name of the canvas frame | ***Default:*** **addon**<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field title? string Text to be shown as the title of the settings page | ***Default:*** [GetAddOnMetadata(**addon**, "title")](https://wowpedia.fandom.com/wiki/API_GetAddOnMetadata)
---@field static? boolean If true, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** false

---@class settingsPageEvents
---@field onLoad? fun(user: boolean) Called after the data of the options widgets linked to this page has been loaded from storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
---@field onSave? fun(user: boolean) Called after the data of the options widgets linked to this page has been committed to storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
---@field onCancel? fun(user: boolean) Called after the changes are scrapped (for instance when the custom "Revert Changes" button is clicked)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
---@field onDefault? fun(user: boolean, category: boolean) Called after options data handled by this settings page has been restored to default values (for example when the "Accept" or "These Settings" - affecting this settings category page only - is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p><p>@*param* `category` boolean — Marking whether the call is through **[*optionsCategory*].defaults(...)** or not (or example when "All Settings" have been clicked)</p>

---@class settingsPageCreationData : settingsPageCreationData_base, describableObject, optionsCategory, settingsPageEvents, initializableOptionsContainer, liteObject
---@field append? boolean When setting the name of the settings category page, append **t.name** after **addon** | ***Default:*** true if **t.name** ~= nil
---@field appendOptions? boolean When setting the name of the canvas frame, append "Options" at the end as well | ***Default:*** true
---@field icon? string Path to the texture file to use as the icon of this settings page | ***Default:*** *the addon's logo specified in its TOC file with the "IconTexture" tag*
---@field titleIcon? boolean Append **t.icon** to the title of the button of the setting page in the AddOns list of the Settings window as well | ***Default:*** true if **t.register == true**
---@field scroll? settingsPageScrollData If set, make the canvas frame scrollable by creating a [ScrollFrame](https://wowpedia.fandom.com/wiki/UIOBJECT_ScrollFrame) as its child
---@field autoSave? boolean If true, automatically save the values of all widgets registered for options data management under options keys listed in **t.dataManagement.keys**, committing their data to storage via ***WidgetToolbox*.SaveOptionsData(...)** | ***Default:*** true if **t.dataManagement.keys** ~= nil<ul><li>***Note:*** If **t.dataManagement.keys** is not set, the automatic load will not be executed even if this is set to true.</li></ul>
---@field autoLoad? boolean If true, automatically load all data to the widgets registered for options data management under options keys listed in **t.dataManagement.keys** from storage via ***WidgetToolbox*.LoadOptionsData(...)** | ***Default:*** true if **t.dataManagement.keys** ~= nil<ul><li>***Note:*** If **t.dataManagement.keys** is not set, the automatic load will not be executed even if this is set to true.</li></ul>

---@class aboutPageCreationData : settingsPageCreationData_base
---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** [GetAddOnMetadata(**addon**, "Notes")](https://wowpedia.fandom.com/wiki/API_GetAddOnMetadata)
---@field changelog? { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included<ul><li>***Note:*** The first line is expected to be the title containing the version number and/or the date of release.</li><li>***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).</li><li>***Examples:***<ul><li>**Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)</li><li>**Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
---@field static? boolean If true, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** true

---@class dataManagementPageCreationData : settingsPageCreationData_base, settingsPageEvents, liteObject
---@field name? string Unique string used to set the name of the canvas frame | ***Default:*** "Profiles"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field title? string Text to be shown as the title of the settings page | ***Default:*** "Data Management"
---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** *describing profiles & backup*
---@field accountData profileStorage|table Reference to the account-bound SavedVariables addon database where profile data is to be stored<ul><li>***Note:*** A subtable will be created under the key **profiles** if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).</li></ul>
---@field characterData table Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified<ul><li>***Note:*** An integer value will be created under the key **activeProfile** if it doesn't already exist.</li></ul>
---@field settingsData table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>***Note:*** The following key, value pairs will be used for storing settings data within this table:<ul><li>**compactBackup** boolean — Whether to skip including additional white spaces to the backup string for more readability</li></li></ul></ul>
---@field defaultsTable table A static table containing all default settings values to be cloned when creating a new profile
---@field onProfilesLoaded? function Called during profiles initialization after the active profile has been loaded and profiles data is validated (with **t.onImportAllProfiles(...)** also being called later when profiles data is imported via user interaction through the backup all profiles box)
---@field onProfileActivated? fun(title: string, index: integer) Called after a profile was activated<hr><p>@*param* `title` string — The title of the profile</p><p>@*param* `index` integer — The index of the profile that was activated</p>
---@field onProfileCreated? fun(title: string, index: integer) Called after a new profile was created<hr><p>@*param* `title` string — The title of the new profile</p><p>@*param* `index` integer — The index of the new profile</p>
---@field onProfileDeleted? fun(title: string, index: integer) Called after the active profile was deleted<hr><p>@*param* `title` string — The old title of the deleted profile</p><p>@*param* `index` integer — The old index of the deleted profile</p>
---@field onProfileReset? fun(title: string, index: integer) Called after the data of a profile was reset to defaults<hr><p>@*param* `title` string — The title of the profile</p><p>@*param* `index` integer — The index of the profile that was reset</p>
---@field onImport? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for the currently active profile<hr><p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>
---@field onImportAllProfiles? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for all profiles<ul><li>***Note:*** *t.onProfilesLoaded will also be called if the import was successful.</li></ul><hr><p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>
---@field valueChecker? fun(k: number|string, v: any): boolean Helper function for validating values when checking profile data, returning true if the value is to be accepted as valid
---@field onRecovery? fun(profileData: table, recoveredData: table): recoveryMap: table<string, recoveryData>|nil Function to call when removed data is to be recovered when checking profile data, providing a way to dynamically create a recovery map based on the recovered data<hr><p>@*param* `profileData` table — Reference to the profile data table being checked</p><p>@*param* `recoveredData` table — All removed recoverable data packed in a table</p><hr><p>@*return* `recoveryMap` table<string, recoveryData>|nil — Save removed profile data from matching key chains under the specified key when checking profile data<ul><li>***Example:*** String chain of keys pointing to the removed old data to be recovered from **profileData**: `"keyOne[2].keyThree.keyFour[1]"`.</li><li>***Note:*** Using the reference of **profileData** as the root table for **saveTo** in the recovery data specifications is recommended.</li></ul></p><p>@*param* `recoveredData` table — All removed recoverable data packed in a table</p>

--[ Settings Category ]

---@class settingsCategoryCreationData
---@field onLoad? fun(user: boolean) Called after the data of the options widgets linked to all pages of this settings category has been loaded from storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
---@field onDefaults? fun(user: boolean) Called after options data handled by all pages of this settings category has been restored to default values (for example when the "All Settings" option is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>


--[[ WIDGETS ]]

---@class eventTag
---@field event string Custom event tag

---@class eventHandlerIndex
---@field callIndex? integer Set when to call **handler** in the execution order | ***Default:*** *placed at the end of the current list*

--[ Button ]

---@alias ButtonType
---|actionButton
---|simpleButton
---|customButton

---@alias ButtonEventTag
---|"enabled"
---|"trigger"
---|string

--| Event handlers

---@alias ButtonEventHandler_enabled
---|fun(self: ButtonType, state: boolean) Called when an "enabled" event is invoked after **button.setEnabled(...)** was called<hr><p>@*param* `self` ButtonType ― Reference to the widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

---@alias ButtonEventHandler_trigger
---|fun(self: ButtonType) Called when a "trigger" event is invoked after **button.trigger(...)** was called<hr><p>@*param* `self` ButtonType ― Reference to the widget</p><p>@*param* `user` boolean ― True if the event was invoked by an action taken by the user</p>

---@alias ButtonEventHandler_any
---|fun(self: ButtonType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ButtonType ― Reference to the widget</p><p>@*param* `...` any — Any leftover arguments</p>

--| Parameters

---@class buttonEventListener_enabled : eventHandlerIndex
---@field handler ButtonEventHandler_enabled Handler function to register for call

---@class buttonEventListener_trigger : eventHandlerIndex
---@field handler ButtonEventHandler_trigger Handler function to register for call

---@class buttonEventListener_any : eventTag, eventHandlerIndex
---@field handler ButtonEventHandler_any Handler function to register for call

---@class buttonEventListeners
---@field enabled? buttonEventListener_enabled[] List of functions to call in order when an "enabled" event is invoked after **button.setEnabled(...)** was called
---@field trigger? buttonEventListener_trigger[] List of functions to call in order when a "trigger" event is invoked after **button.trigger(...)** was called
---@field _? buttonEventListener_any[] List of functions to call in order when a custom event is invoked

---@class sizeData_button
---@field w? number Width | ***Default:*** 80
---@field h? number Height | ***Default:*** 22

---@class buttonScriptEvents
---@field events? table<ScriptButton, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the button and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" when the button is clicked.</li><li>***Note:*** **t.action** will automatically be called when an "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" event triggers, there is no need to register it here as well.</li></ul>

--| Constructors

---@class actionButtonCreationData : togglableObject
---@field action? fun(self: actionButton, user?: boolean) Function to call when the button is triggered (clicked by the user or triggered programmatically)<ul><li>***Note:*** This function will be called when an "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" script event happens, there's no need to register it again under **t.events.OnClick**.</li></ul><hr><p>@*param* `self` actionButton — Reference to the button widget</p><p>@*param* `user`? boolean — Marking whether the call is due to a user interaction or not | ***Default:*** false</p>
---@field listeners? buttonEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

---@class simpleButtonCreationData : actionButtonCreationData, labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base, buttonScriptEvents, liteObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Button"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field titleOffset? offsetData Offset the position of the label of the button
---@field size? sizeData_button
---@field font? labelFontOptions_highlight List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>

---@class customButtonCreationData : simpleButtonCreationData, customizableObject
---@field font? labelFontOptions_small_highlight Table of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label | ***Default:*** *small default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>

--[ Toggle ]

---@alias ToggleType
---|toggle
---|checkbox
---|radioButton

---@alias ToggleEventTag
---|"enabled"
---|"loaded"
---|"toggled"
---|string

--| Event handlers

---@alias ToggleEventHandler_enabled
---|fun(self: ToggleType, state: boolean) Called when an "enabled" event is invoked after **toggle.setEnabled(...)** was called<hr><p>@*param* `self` ToggleType ― Reference to the button widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

---@alias ToggleEventHandler_loaded
---|fun(self: ToggleType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` ToggleType ― Reference to the widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

---@alias ToggleEventHandler_saved
---|fun(self: ToggleType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` ToggleType ― Reference to the widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

---@alias ToggleEventHandler_toggled
---|fun(self: ToggleType, state: boolean, user: boolean) Called when an "toggled" event is invoked after **toggle.setState(...)** was called<hr><p>@*param* `self` ToggleType ― Reference to the toggle widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p><p>@*param* `user` boolean ― True if the event was invoked by an action taken by the user</p>

---@alias ToggleEventHandler_any
---|fun(self: ToggleType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ToggleType ― Reference to the widget</p><p>@*param* `...` any — Any leftover arguments</p>

--| Parameters

---@class toggleEventListener_enabled : eventHandlerIndex
---@field handler ToggleEventHandler_enabled Handler function to register for call

---@class toggleEventListener_loaded : eventHandlerIndex
---@field handler ToggleEventHandler_loaded Handler function to register for call

---@class toggleEventListener_saved : eventHandlerIndex
---@field handler ToggleEventHandler_saved Handler function to register for call

---@class toggleEventListener_toggled : eventHandlerIndex
---@field handler ToggleEventHandler_toggled Handler function to register for call

---@class toggleEventListener_any : eventTag, eventHandlerIndex
---@field handler ToggleEventHandler_any Handler function to register for call

---@class toggleEventListeners
---@field enabled? toggleEventListener_enabled[] List of functions to call in order when an "enabled" event is invoked after **toggle.setEnabled(...)** was called
---@field loaded? toggleEventListener_loaded[] List of functions to call in order when an "loaded" event is invoked after the data of this widget has been loaded from storage
---@field saved? toggleEventListener_saved[] List of functions to call in order when an "saved" event is invoked after the data of this widget has been saved to storage
---@field toggled? toggleEventListener_toggled[] List of functions to call in order when an "toggled" event is invoked after **toggle.setState(...)** was called
---@field [string]? toggleEventListener_any[] List of functions to call in order when a custom event is invoked

---@class sizeData_checkbox
---@field w? number Width | ***Default:*** **t.label** and 180 or **t.size.h**
---@field h? number Height | ***Default:*** 26

---@class sizeData_radioButton
---@field w? number Width | ***Default:***  **t.label** and 160 or **t.size.h**
---@field h? number Height | ***Default:*** 16

--| Constructors

---@class toggleCreationData : togglableObject, optionsWidget
---@field listeners? toggleEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
---@field getData? fun(): state: boolean|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `state` boolean|nil | ***Default:*** false</p>
---@field saveData? fun(state: boolean) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `state` boolean</p>
---@field value? boolean The starting state of the widget to set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid
---@field default? boolean Default value of the widget | ***Default:*** false

---@class checkboxCreationData : toggleCreationData, labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base, liteObject, optionsFrame
---@field name? string Unique string used to set the frame name | ***Default:*** "Toggle"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_checkbox
---@field font? labelFontOptions List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field events? table<ScriptButton, fun(self: checkbox, state: boolean, button?: string, down?: boolean)|fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the checkbox and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` AnyFrameObject ― Reference to the toggle frame</p><p>@*param* `state` boolean ― The checked state of the toggle frame</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** "LeftButton"</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** false</p></li></ul>

---@class radioButtonCreationData : checkboxCreationData
---@field size? sizeData_radioButton
---@field clearable? boolean Whether this radio button should be clearable by right clicking on it or not | ***Default:*** false<ul><li>***Note:*** The radio button will be registered for "RightButtonUp" triggers to call "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" events with **button** = "RightButton".</li></ul>
---@field events? table<ScriptButton, fun(self: radioButton, state: boolean, button?: string, down?: boolean)|fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the radio button and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://wowpedia.fandom.com/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` AnyFrameObject ― Reference to the toggle frame</p><p>@*param* `state` boolean ― The checked state of the toggle frame</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** "LeftButton"</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** false</p></li></ul>

--[ Selector ]

---@alias SelectorType
---|selector
---|radioSelector
---|dropdownSelector

---@alias SpecialSelectorType
---|selector
---|specialSelector

---@alias SpecialSelectorEventTag
---|"enabled"
---|"loaded"
---|"selected"
---|string

---@alias MultiselectorType
---|multiselector
---|checkboxSelector

---@alias SelectorEventTag
---|SpecialSelectorEventTag
---|"updated"

---@alias MultiselectorEventTag
---|SelectorEventTag
---|"limited"

---@alias DropdownSelectorEventTag
---|SelectorEventTag
---|"open"

---@alias SpecialSelectorItemset
---|"anchor" Using the set of [AnchorPoint](https://warcraft.wiki.gg/wiki/Anchors) items
---|"justifyH" Using the set of horizontal text alignment items (JustifyH)
---|"justifyV" Using the set of vertical text alignment items (JustifyV)
---|"frameStrata" Using the set of [FrameStrata](https://warcraft.wiki.gg/wiki/Frame_Strata) items (excluding "WORLD")

--| Event handlers

---@alias SelectorEventHandler_enabled
---|fun(self: SelectorType, state: boolean) Called when an "enabled" event is invoked after **selector.setEnabled(...)** was called<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

---@alias SelectorEventHandler_loaded
---|fun(self: SelectorType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

---@alias SelectorEventHandler_saved
---|fun(self: SelectorType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

---@alias SelectorEventHandler_selected
---|fun(self: SelectorType, selected?: integer, user: boolean) Called when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `selected` integer ― The index of the currently selected item</p><p>@*param* `user` boolean ― True if the event was invoked by an action taken by the user</p>

---@alias SelectorEventHandler_updated
---|fun(self: SelectorType) Called when an "updated" event is invoked after **selector.updatedItems(...)** was called<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p>

---@alias SelectorEventHandler_added
---|fun(self: SelectorType, toggle: toggle) Called when a new toggle item is added to the selector via **selector.updatedItems(...)**<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `toggle` toggle ― Reference to the toggle widget added to the selector</p>

---@alias SelectorEventHandler_any
---|fun(self: SelectorType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` SelectorType ― Reference to the widget</p><p>@*param* `...` any — Any leftover arguments</p>

---@alias SpecialSelectorEventHandler_enabled
---|fun(self: SpecialSelectorType, state: boolean) Called when an "enabled" event is invoked after **selector.setEnabled(...)** was called<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

---@alias SpecialSelectorEventHandler_loaded
---|fun(self: SpecialSelectorType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

---@alias SpecialSelectorEventHandler_saved
---|fun(self: SpecialSelectorType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

---@alias SpecialSelectorEventHandler_selected
---|fun(self: SpecialSelectorType, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― True if the event was invoked by an action taken by the user</p>

---@alias SpecialSelectorEventHandler_any
---|fun(self: SpecialSelectorType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` SpecialSelectorType ― Reference to the widget</p><p>@*param* `...` any — Any leftover arguments</p>

---@alias MultiselectorEventHandler_enabled
---|fun(self: MultiselectorType, state: boolean) Called when an "enabled" event is invoked after **selector.setEnabled(...)** was called<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

---@alias MultiselectorEventHandler_loaded
---|fun(self: MultiselectorType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

---@alias MultiselectorEventHandler_saved
---|fun(self: MultiselectorType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

---@alias MultiselectorEventHandler_selected
---|fun(self: MultiselectorType, selections: boolean[], user: boolean) Called when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `selections` boolean[] ― Indexed list of the current item states</p><p>@*param* `user` boolean ― True if the event was invoked by an action taken by the user</p>

---@alias MultiselectorEventHandler_updated
---|fun(self: MultiselectorType) Called when an "updated" event is invoked after **selector.updatedItems(...)** was called<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p>

---@alias MultiselectorEventHandler_added
---|fun(self: MultiselectorType, toggle: toggle) Called when a new toggle item is added to the selector via **selector.updatedItems(...)**<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `toggle` toggle ― Reference to the toggle widget added to the selector</p>

---@alias MultiselectorEventHandler_limited
---|fun(self: MultiselectorType, min: boolean, max: boolean, passed: boolean) Called when a "limited" event is invoked after a limit update occurs<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `min` boolean ― True, if the number of selected items is equal to lower than the specified lower limit</p><p>@*param* `max` boolean ― True, if the number of selected items is equal to higher than the specified upper limit</p><p>@*param* `passed` boolean ― True, if the number of selected items is below or over the specified lower or upper limit</p>

---@alias MultiselectorEventHandler_any
---|fun(self: MultiselectorType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` MultiselectorType ― Reference to the widget</p><p>@*param* `...` any — Any leftover arguments</p>

--| Data value types

---@class wrappedIntegerValue
---@field index? integer ***Default:*** nil *(no selection)*

---@class wrappedSpecialData
---@field value? integer|FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata ***Default:*** nil *(no selection)*

---@class wrappedBooleanArrayData
---@field selections? boolean[] Indexed list of current item states in order | ***Default:*** false[] *(no selected items)*

--| Parameters

---@class selectorItem
---@field title? string Text to be shown on the right of the item to represent the item within the selector frame (if **t.labels** is true)
---@field tooltip? itemTooltipTextData List of text lines to be added to the tooltip of the item displayed when mousing over the frame
---@field onSelect? function The function to be called when the item is selected by the user

---@class limitValues
---@field min? integer The minimal number of items that need to be selected at all times | ***Default:*** 1
---@field max? integer The maximal number of items that can be selected at once | ***Default:*** #**t.items** *(all items)*

---@class selectorEventListener_enabled : eventHandlerIndex
---@field handler SelectorEventHandler_enabled Handler function to register for call

---@class selectorEventListener_loaded : eventHandlerIndex
---@field handler SelectorEventHandler_loaded Handler function to register for call

---@class selectorEventListener_saved : eventHandlerIndex
---@field handler SelectorEventHandler_saved Handler function to register for call

---@class selectorEventListener_selected : eventHandlerIndex
---@field handler SelectorEventHandler_selected Handler function to register for call

---@class selectorEventListener_updated : eventHandlerIndex
---@field handler SelectorEventHandler_updated Handler function to register for call

---@class selectorEventListener_any : eventTag, eventHandlerIndex
---@field handler SelectorEventHandler_any Handler function to register for call

---@class specialSelectorEventListener_enabled : eventHandlerIndex
---@field handler SpecialSelectorEventHandler_enabled Handler function to register for call

---@class specialSelectorEventListener_loaded : eventHandlerIndex
---@field handler SpecialSelectorEventHandler_loaded Handler function to register for call

---@class specialSelectorEventListener_saved : eventHandlerIndex
---@field handler SpecialSelectorEventHandler_saved Handler function to register for call

---@class specialSelectorEventListener_selected : eventHandlerIndex
---@field handler SpecialSelectorEventHandler_selected Handler function to register for call

---@class specialSelectorEventListener_any : eventTag, eventHandlerIndex
---@field handler SpecialSelectorEventHandler_any Handler function to register for call

---@class selectorEventListeners
---@field enabled? selectorEventListener_enabled[] List of functions to call in order when an "enabled" event is invoked after **selector.setEnabled(...)** was called
---@field loaded? selectorEventListener_loaded[] List of functions to call in order when an "loaded" event is invoked after the data of this widget has been loaded from storage
---@field saved? selectorEventListener_saved[] List of functions to call in order when an "saved" event is invoked after the data of this widget has been saved to storage
---@field selected? selectorEventListener_selected[] List of functions to call in order when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared
---@field updated? selectorEventListener_updated[] List of functions to call in order when an "updated" events are invoked after **selector.updatedItems(...)** was called
---@field [string]? selectorEventListener_any[] List of functions to call in order when a custom event is invoked

---@class multiselectorEventListeners
---@field enabled? multiselectorEventListener_enabled[] List of functions to call in order when an "enabled" event is invoked after **selector.setEnabled(...)** was called
---@field loaded? multiselectorEventListener_loaded[] List of functions to call in order when an "loaded" event is invoked after the data of this widget has been loaded from storage
---@field saved? multiselectorEventListener_saved[] List of functions to call in order when an "saved" event is invoked after the data of this widget has been saved to storage
---@field selected? multiselectorEventListener_selected[] List of functions to call in order when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared
---@field updated? multiselectorEventListener_updated[] List of functions to call in order when an "updated" events are invoked after **selector.updatedItems(...)** was called
---@field min? multiselectorEventListener_limited[] List of functions to call in order when a "limited" event is invoked after a lower limit update occurs
---@field [string]? multiselectorEventListener_any[] List of functions to call in order when a custom event is invoked

---@class specialSelectorEventListeners
---@field enabled? specialSelectorEventListener_enabled[] List of functions to call in order when an "enabled" event is invoked after **selector.setEnabled(...)** was called
---@field loaded? specialSelectorEventListener_loaded[] List of functions to call in order when an "loaded" event is invoked after the data of this widget has been loaded from storage
---@field saved? specialSelectorEventListener_saved[] List of functions to call in order when an "saved" event is invoked after the data of this widget has been saved to storage
---@field selected? specialSelectorEventListener_selected[] List of functions to call in order when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared
---@field [string]? specialSelectorEventListener_any[] List of functions to call in order when a custom event is invoked

---@class multiselectorEventListener_enabled : eventHandlerIndex
---@field handler MultiselectorEventHandler_enabled Handler function to register for call

---@class multiselectorEventListener_loaded : eventHandlerIndex
---@field handler MultiselectorEventHandler_loaded Handler function to register for call

---@class multiselectorEventListener_saved : eventHandlerIndex
---@field handler MultiselectorEventHandler_saved Handler function to register for call

---@class multiselectorEventListener_selected : eventHandlerIndex
---@field handler MultiselectorEventHandler_selected Handler function to register for call

---@class multiselectorEventListener_updated : eventHandlerIndex
---@field handler MultiselectorEventHandler_updated Handler function to register for call

---@class multiselectorEventListener_limited : eventHandlerIndex
---@field handler MultiselectorEventHandler_limited Handler function to register for call

---@class multiselectorEventListener_any : eventTag, eventHandlerIndex
---@field handler MultiselectorEventHandler_any Handler function to register for call

--| Constructors

---@class selectorCreationData_base
---@field clearable? boolean If true, the value of the selector input should be clearable and allowed to be set to nil | ***Default:*** false

---@class selectorCreationData : togglableObject, optionsWidget, selectorCreationData_base
---@field items? (selectorItem|toggle)[] Table containing subtables with data used to create item widgets, or already existing toggles
---@field listeners? selectorEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
---@field getData? fun(): selected: integer|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `selected` integer|nil | ***Default:*** nil *(no selection)*</p>
---@field saveData? fun(selected?: integer) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `selected`? integer</p>
---@field value? integer The index of the item to be set as selected during initialization | ***Default:*** **t.getData()** or **t.default** if invalid or 1 if **t.clearable** is false
---@field default? integer Default value of the widget | ***Default:*** 1 or nil *(no selection)* if **t.clearable** is true

---@class specialSelectorCreationData : togglableObject, optionsWidget, selectorCreationData_base
---@field listeners? specialSelectorEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
---@field getData? fun(): value: integer|FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `value` integer|AnchorPoint|JustifyH|JustifyV|FrameStrata|nil — The index or the value of the item to be set as selected ***Default:*** nil *(no selection)*</p>
---@field saveData? fun(value?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `value`? AnchorPoint|JustifyH|JustifyV|FrameStrata</p>
---@field value? integer|FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata The item to be set as selected during initialization | ***Default:*** **t.getData()** or **t.default** if invalid or *option 1* if **t.clearable** is false
---@field default? integer|FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata Default value of the widget | ***Default:*** *option 1* or nil *(no selection)* if **t.clearable** is true

---@class multiselectorCreationData : togglableObject, optionsWidget
---@field items? (selectorItem|toggle)[] Table containing subtables with data used to create item widgets, or already existing toggles
---@field limits? limitValues Parameters to specify the limits of the number of selectable items
---@field listeners? multiselectorEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
---@field getData? fun(): selections: boolean[]|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `selections` boolean[]|nil | ***Default:*** false[] *(no selected items)*</p>
---@field saveData? fun(selections?: boolean[]) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `selections`? boolean[]</p>
---@field value? boolean[] Ordered list of item states to set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid
---@field default? boolean[] Default value of the widget | ***Default:*** false[] *(no selected items)*

---@class selectorFrameCreationData : labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base, liteObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Selector"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the selector frame and the functions to assign as event handlers called when they trigger

---@class radioSelectorCreationData_base : optionsFrame
---@field clearable? boolean If true, the selector input should be clearable by right clicking on its radio buttons, setting the selected value to nil | ***Default:*** false

---@class radioSelectorCreationData : selectorCreationData, selectorFrameCreationData, radioSelectorCreationData_base
---@field width? number The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 160 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to **t.width** if **t.columns** is 1 and **t.width** is specified.</li></ul>
---@field items? (selectorItem|selectorRadioButton)[] Table containing subtables with data used to create item widgets, or already existing radio buttons
---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1
---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** true

---@class specialRadioSelectorCreationData : specialSelectorCreationData, selectorFrameCreationData, radioSelectorCreationData_base

---@class checkboxSelectorCreationData : multiselectorCreationData, selectorFrameCreationData, optionsFrame
---@field width? number The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 160 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to **t.width** if **t.columns** is 1 and **t.width** is specified.</li></ul>
---@field items? (selectorItem|selectorCheckbox)[] Table containing subtables with data used to create item widgets, or already existing checkboxes
---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** true
---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1

---@class dropdownSelectorCreationData : radioSelectorCreationData, widgetWidthValue, optionsFrame
---@field name? string Unique string used to set the frame name | ***Default:*** "Dropdown"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field text? string The default text to display on the dropdown when no item is selected | ***Default:*** ""
---@field autoClose? boolean Close the dropdown menu after an item is selected by the user | ***Default:*** true
---@field cycleButtons? boolean Add previous & next item buttons next to the dropdown | ***Default:*** true

--[ Textbox ]

---@alias TextboxType
---|textbox
---|singleLineEditbox
---|customSingleLineEditbox
---|multilineEditbox

---@alias TextboxEventTag
---|"enabled"
---|"loaded"
---|"changed"
---|string

--| Event handlers

---@alias TextboxEventHandler_enabled
---|fun(self: TextboxType, state: boolean) Called when an "enabled" event is invoked after **textbox.setEnabled(...)** was called<hr><p>@*param* `self` TextboxType ― Reference to the button widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

---@alias TextboxEventHandler_loaded
---|fun(self: TextboxType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` TextboxType ― Reference to the widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

---@alias TextboxEventHandler_saved
---|fun(self: TextboxType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` TextboxType ― Reference to the widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

---@alias TextboxEventHandler_changed
---|fun(self: TextboxType, text: string, user: boolean) Called when an "changed" event is invoked after **textbox.setText(...)** was called<hr><p>@*param* `self` TextboxType ― Reference to the toggle widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was invoked by an action taken by the user</p>

---@alias TextboxEventHandler_any
---|fun(self: TextboxType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` TextboxType ― Reference to the widget</p><p>@*param* `...` any — Any leftover arguments</p>

--| Parameters

---@class textboxEventListener_enabled : eventHandlerIndex
---@field handler TextboxEventHandler_enabled Handler function to register for call

---@class textboxEventListener_loaded : eventHandlerIndex
---@field handler TextboxEventHandler_loaded Handler function to register for call

---@class textboxEventListener_saved : eventHandlerIndex
---@field handler TextboxEventHandler_saved Handler function to register for call

---@class textboxEventListener_changed : eventHandlerIndex
---@field handler TextboxEventHandler_changed Handler function to register for call

---@class textboxEventListener_any : eventTag, eventHandlerIndex
---@field handler TextboxEventHandler_any Handler function to register for call

---@class textboxEventListeners
---@field enabled? textboxEventListener_enabled[] List of functions to call in order when an "enabled" event is invoked after **textbox.setEnabled(...)** was called
---@field loaded? textboxEventListener_loaded[] List of functions to call in order when an "loaded" event is invoked after the data of this widget has been loaded from storage
---@field saved? textboxEventListener_saved[] List of functions to call in order when an "saved" event is invoked after the data of this widget has been saved to storage
---@field changed? textboxEventListener_changed[] List of functions to call in order when a "changed" event is invoked after **textbox.setText(...)** was called
---@field [string]? textboxEventListener_any[] List of functions to call in order when a custom event is invoked

---@class labelFontOptions_editbox
---@field normal? string Name of the font to be used when the widget is in its regular state | ***Default:*** *default font based on the frame template*
---@field disabled? string Name of the font to be used when the widget is disabled | ***Default:*** *default font based on the frame template*

---@class sizeData_editbox
---@field w? number Width | ***Default:***  180
---@field h? number Height | ***Default:*** 18

--| Constructors

---@class textboxCreationData : togglableObject, optionsWidget
---@field color? colorData Apply the specified color to all text in the editbox (overriding all font objects set in **t.font**)
---@field listeners? textboxEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
---@field getData? fun(): text: string|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `text` string|nil | ***Default:*** "" *(empty string)*</p>
---@field saveData? fun(text: string) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `text` string</p>
---@field value? string The starting text to be set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid
---@field default? string Default value of the widget | ***Default:*** "" *(empty string)*

---@class editboxCreationData : textboxCreationData, labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base, liteObject, optionsFrame
---@field name? string Unique string used to set the frame name | ***Default:*** "Textbox"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_editbox
---@field insets? insetData Table containing padding values by which to offset the position of the text in the editbox
---@field font? labelFontOptions_editbox List of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object names to be used for the label<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field justify? justifyData_left Set the justification of the text (overriding all font objects set in **t.font**)
---@field charLimit? number The value to set by [EditBox:SetMaxLetters()](https://wowpedia.fandom.com/wiki/API_EditBox_SetMaxLetters) | ***Default:*** 0 (*no limit*)
---@field readOnly? boolean The text will be uneditable if true | ***Default:*** false
---@field focusOnShow? boolean Focus the editbox when its shown and highlight the text | ***Default:*** false
---@field keepFocused? boolean Keep the editbox focused while its being shown | ***Default:*** false
---@field unfocusOnEnter? boolean Whether to automatically clear the focus from the editbox when the ENTER key is pressed | ***Default:*** true
---@field resetCursor? boolean If true, set the cursor position to the beginning of the string after setting the text via **textbox.setText(...)** | ***Default:*** true
---@field events? table<ScriptEditBox, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the editbox frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnChar](https://wowpedia.fandom.com/wiki/UIHANDLER_OnChar)" will be called with custom parameters:<p>@*param* `self` AnyFrameObject ― Reference to the editbox frame</p><p>@*param* `char` string ― The UTF-8 character that was typed</p><p>@*param* `text` string ― The text typed into the editbox</p></li><li>***Note:*** "[OnTextChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnTextChanged)" will be called with custom parameters:<p>@*param* `self` AnyFrameObject ― Reference to the editbox frame</p><p>@*param* `text` string ― The text typed into the editbox</p><p>@*param* `user` string ― True if the value was changed by the user, false if it was done programmatically</p></li><li>***Note:*** "[OnEnterPressed](https://wowpedia.fandom.com/wiki/UIHANDLER_OnEnterPressed)" will be called with custom parameters:<p>@*param* `self` AnyFrameObject ― Reference to the editbox frame</p><p>@*param* `text` string ― The text typed into the editbox</p></li></ul>
---@field onLoad? fun(self: textbox|multilineEditbox, text?: string) Function to be be called after the data of this widget has been loaded (when settings are opened or changes/defaults are reset)<hr><p>@*param* `self` textbox|multilineTextbox ― Reference to the widget</p><hr><p>@*param* `text`? string ― The loaded value</p>
---@field onSave? fun(self: textbox|multilineEditbox, data?: any) Function to be be called on options data update (after the data of this widget has been saved to storage)<hr><p>@*param* `self` textbox|multilineTextbox ― Reference to the widget</p><hr><p>@*param* `data`? any ― The saved value | ***Default:*** *the current value of the widget*</p>

---@class customEditboxCreationData : editboxCreationData, customizableObject

---@class multilineEditboxCreationData : editboxCreationData, scrollSpeedData
---@field size? sizeData
---@field charCount? boolean Show or hide the remaining number of characters | ***Default:*** **t.charLimit** > 0
---@field scrollToTop? boolean Automatically scroll to the top when the text is loaded or changed while not being actively edited | ***Default:*** false
---@field scrollEvents? table<ScriptScrollFrame, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the scroll frame of the editbox and the functions to assign as event handlers called when they trigger

---@class copyboxCreationData : labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base, liteObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Copybox"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_editbox
---@field layer? DrawLayer
---@field font? string Name of the [Font](https://wowpedia.fandom.com/wiki/UIOBJECT_Font) object to be used for the [FontString](https://wowpedia.fandom.com/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormalSmall"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field color? colorData Apply the specified color to the text (overriding **t.font**)
---@field justify? JustifyHorizontal Set the horizontal text alignment of the label (overriding **t.font**) | ***Default:*** "LEFT"
---@field flipOnMouse? boolean Hide/Reveal the editbox on mouseover instead of after a click | ***Default:*** false
---@field colorOnMouse? colorData If set, change the color of the text on mouseover to the specified color (if **t.flipOnMouse** is false) | ***Default:*** *no color change*
---@field value string The copyable text to be shown

--[ Numeric ]

---@alias NumericType
---|numeric
---|numericSlider

---@alias NumericEventTag
---|"enabled"
---|"loaded"
---|"changed"
---|"min"
---|"max"
---|string

--| Event handlers

---@alias NumericEventHandler_enabled
---|fun(self: NumericType, state: boolean) Called when an "enabled" event is invoked after **numeric.setEnabled(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the button widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

---@alias NumericEventHandler_loaded
---|fun(self: NumericType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` NumericType ― Reference to the widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

---@alias NumericEventHandler_saved
---|fun(self: NumericType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` NumericType ― Reference to the widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

---@alias NumericEventHandler_changed
---|fun(self: NumericType, number: number, user: boolean) Called when an "changed" event is invoked after **numeric.setNumber(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the toggle widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was invoked by an action taken by the user</p>

---@alias NumericEventHandler_min
---|fun(self: NumericType, limitMin: number) Called when an "min" event is invoked after **numeric.setMin(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the toggle widget</p><p>@*param* `limitMin` number ― The current lower limit of the number value of the widget</p>

---@alias NumericEventHandler_max
---|fun(self: NumericType, limitMax: number) Called when an "max" event is invoked after **numeric.setMax(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the toggle widget</p><p>@*param* `limitMax` number ― The current upper limit of the number value of the widget</p>

---@alias NumericEventHandler_any
---|fun(self: NumericType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` NumericType ― Reference to the widget</p><p>@*param* `...` any — Any leftover arguments</p>

--| Parameters

---@class numericEventListener_enabled : eventHandlerIndex
---@field handler NumericEventHandler_enabled Handler function to register for call

---@class numericEventListener_loaded : eventHandlerIndex
---@field handler NumericEventHandler_loaded Handler function to register for call

---@class numericEventListener_saved : eventHandlerIndex
---@field handler NumericEventHandler_saved Handler function to register for call

---@class numericEventListener_changed : eventHandlerIndex
---@field handler NumericEventHandler_changed Handler function to register for call

---@class numericEventListener_min : eventHandlerIndex
---@field handler NumericEventHandler_min Handler function to register for call

---@class numericEventListener_max : eventHandlerIndex
---@field handler NumericEventHandler_max Handler function to register for call

---@class numericEventListener_any : eventTag, eventHandlerIndex
---@field handler NumericEventHandler_any Handler function to register for call

---@class numericEventListeners
---@field enabled? numericEventListener_enabled[] List of functions to call in order when an "enabled" event is invoked after **numeric.setEnabled(...)** was called
---@field loaded? numericEventListener_loaded[] List of functions to call in order when an "loaded" event is invoked after the data of this widget has been loaded from storage
---@field saved? numericEventListener_saved[] List of functions to call in order when an "saved" event is invoked after the data of this widget has been saved to storage
---@field changed? numericEventListener_changed[] List of functions to call in order when a "changed" event is invoked after **numeric.setNumber(...)** was called
---@field min? numericEventListener_min[] List of functions to call in order when a "min" event is invoked after **numeric.setMin(...)** was called
---@field max? numericEventListener_max[] List of functions to call in order when a "max" event is invoked after **numeric.setMax(...)** was called
---@field [string]? numericEventListener_any[] List of functions to call in order when a custom event is invoked

--| Constructors

---@class numericCreationData : togglableObject, optionsWidget
---@field fractional? integer If the value is fractional, display this many decimal digits | ***Default:*** *the most amount of digits present in the fractional part of* **t.min**, **t.max** *or* **t.increment**
---@field min? number Lower numeric value limit | ***Range:*** (any, **t.max**) | ***Default:*** 0
---@field max? number Upper numeric value limit | ***Range:*** (**t.min**, any) | ***Default:*** 100
---@field increment? number Size of value increment | ***Range:*** (> 0) | ***Default:*** *the value can be freely changed within range*
---@field step? number Add/subtract this much when calling **numeric.increase(...)** or **numeric.decrease(...)** | ***Default:*** 10% of range (**t.min**, **t.max**)
---@field altStep? number If set, add/subtract this much when calling **numeric.increase(...)** or **numeric.decrease(...)** with **alt** == true | ***Default:*** *no alternative step value*
---@field listeners? numericEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
---@field getData? fun(): value: number|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `value` number|nil | ***Default:*** **t.min**</p>
---@field saveData? fun(value: number) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `value` number</p>
---@field value? number The starting value of the widget to set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid
---@field default? number Default value of the widget | ***Default:*** **t.min**

---@class numericSliderCreationData : numericCreationData, labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, widgetWidthValue, visibleObject_base, liteObject, optionsFrame
---@field name? string Unique string used to set the frame name | ***Default:*** "Slider"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field valueBox? boolean Whether or not should the slider have an [EditBox](https://wowpedia.fandom.com/wiki/UIOBJECT_EditBox) as a child to manually enter a precise value to move the slider to | ***Default:*** true
---@field sideButtons? boolean Whether or not to add increase/decrease buttons next to the slider to change the value by the increment set in **t.step** | ***Default:*** true
---@field events? table<ScriptSlider, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the slider frame and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnValueChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnValueChanged)" whenever the value in the slider widget is modified.</li></ul>

--[ Color Picker ]

---@alias ColorPickerType
---|colorPicker
---|colorPickerFrame

---@alias ColorPickerEventTag
---|"enabled"
---|"loaded"
---|"saved"
---|"colored"
---|string

--| Event handlers

---@alias ColorPickerEventHandler_enabled
---|fun(self: ColorPickerType, state: boolean) Called when an "enabled" event is invoked after **colorPicker.setEnabled(...)** was called<hr><p>@*param* `self` ColorPickerType ― Reference to the button widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

---@alias ColorPickerEventHandler_loaded
---|fun(self: ColorPickerType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` ColorPickerType ― Reference to the widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

---@alias ColorPickerEventHandler_saved
---|fun(self: ColorPickerType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` ColorPickerType ― Reference to the widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

---@alias ColorPickerEventHandler_colored
---|fun(self: ColorPickerType, color: colorData, user: boolean) Called when an "colored" event is invoked after **colorPicker.setColor(...)** was called<hr><p>@*param* `self` ColorPickerType ― Reference to the toggle widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was invoked by an action taken by the user</p>

---@alias ColorPickerEventHandler_any
---|fun(self: ColorPickerType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ColorPickerType ― Reference to the widget</p><p>@*param* `...` any — Any leftover arguments</p>

--| Parameters

---@class colorPickerEventListener_enabled : eventHandlerIndex
---@field handler ColorPickerEventHandler_enabled Handler function to register for call

---@class colorPickerEventListener_loaded : eventHandlerIndex
---@field handler ColorPickerEventHandler_loaded Handler function to register for call

---@class colorPickerEventListener_saved : eventHandlerIndex
---@field handler ColorPickerEventHandler_saved Handler function to register for call

---@class colorPickerEventListener_colored : eventHandlerIndex
---@field handler ColorPickerEventHandler_colored Handler function to register for call

---@class colorPickerEventListener_any : eventTag, eventHandlerIndex
---@field handler ColorPickerEventHandler_any Handler function to register for call

---@class colorPickerEventListeners
---@field enabled? colorPickerEventListener_enabled[] List of functions to call in order when an "enabled" event is invoked after **colorPicker.setEnabled(...)** was called
---@field loaded? colorPickerEventListener_loaded[] List of functions to call in order when an "loaded" event is invoked after the data of this widget has been loaded from storage
---@field saved? colorPickerEventListener_saved[] List of functions to call in order when an "saved" event is invoked after the data of this widget has been saved to storage
---@field colored? colorPickerEventListener_colored[] List of functions to call in order when a "colored" event is invoked after **colorPicker.setColor(...)** was called
---@field [string]? colorPickerEventListener_any[] List of functions to call in order when a custom event is invoked

--| Constructors

---@class colorPickerCreationData : togglableObject, optionsWidget
---@field listeners? colorPickerEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
---@field onCancel? function The function to be called when the color change is cancelled (after calling **t.onColorUpdate**)
---@field getData? fun(): color: optionalColorData|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `color` optionalColorData|nil | ***Default:*** { r = 1, g = 1, b = 1, a = 1 } *(white)*</p>
---@field saveData? fun(color: colorData) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `color` colorData</p>
---@field value? colorData_whiteDefault Values to use as the starting color set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid<ul><li>***Note:*** If the alpha start value was not set, configure the color picker to handle RBG values exclusively instead of the full RGBA.</li></ul>
---@field default? colorData Default value of the widget | ***Default:*** { r = 1, g = 1, b = 1, a = 1 } *(white)*

---@class colorPickerFrameCreationData : colorPickerCreationData, labeledChildObject, tooltipDescribableObject, arrangeableObject, positionableObject, visibleObject_base, liteObject, optionsFrame
---@field name? string Unique string used to set the frame name | ***Default:*** "Color Picker"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field width? number The height is defaulted to 36, the width may be specified | ***Default:*** 120
---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the color picker frame and the functions to assign as event handlers called when they trigger


--[[ POSITION OPTIONS ]]

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
---@field getData fun(): table Return a reference to the table within the SavedVariables(PerCharacter) addon database where the custom preset data is committed to when the custom preset is saved
---@field defaultsTable table Reference to the table containing the default custom preset values<ul><li>***Note:*** The defaults table should contain values under matching keys to the values within *t.presets.custom.getData()*.</li></ul>
---@field onSave? function Called after saving the custom preset
---@field onReset? function Called after resetting the custom preset before it is applied

---@class presetItemList
---@field items presetItemData[] Table containing the dropdown items described within subtables
---@field onPreset? fun(index?: integer) Called after a preset is selected and applied via the dropdown widget or by calling **applyPreset**<hr><p>@*param* `index`? integer — The index of the currently selected item</p><hr><ul><li>***Note:*** A custom [OnAttributeChanged](https://wowpedia.fandom.com/wiki/UIHANDLER_OnAttributeChanged) event will also be invoked whenever an item is selected *(see* ***WidgetToolbox*.CreateDropdown(...)***)*.</li></ul>
---@field custom? customPresetData When set, add widgets to manage a user-modifiable custom preset

---@class movabilityData_positioning : movabilityData
---@field modifier? ModifierKey The specific (or any) modifier key required to be pressed down to move **frame** (if **frame** has the "OnUpdate" script defined) | ***Default:*** "SHIFT"<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://wowpedia.fandom.com/wiki/API_IsModifierKeyDown) is used.</li></ul>

---@class optionsData_position
---@field category? string A unique string used for categorizing options data management rules & change handler scripts | ***Default:*** **addon**
---@field key? string A unique string appended to **category** linking a subset of options data rules to be handled together | ***Default:*** "Position"

---@class positionOptionsCreationData
---@field canvas Frame The canvas frame child item of an existing settings category page to add the position panel to
---@field frame AnyFrameObject Reference to the frame to create the position options for
---@field frameName string Include this string in the tooltips and descriptions of options widgets when referring to **t.frame**
---@field presets? presetItemList Reference to the table containing **t.frame** position presets to be managed by options widgets added when set
---@field setMovable? movabilityData_positioning When specified, set **t.frame** as movable, dynamically updating the position options widgets when it's moved by the user
---@field dependencies? dependencyRule[] Automatically disable or enable all widgets in the new panel based on the rules described in subtables
---@field getData fun(): table Return a reference to the table within a SavedVariables(PerCharacter) addon database where data is committed to when **t.frame** was successfully moved<ul><li>**position** table — Parameters to call [Region:SetPoint(...)](https://wowpedia.fandom.com/wiki/API_ScriptRegionResizing_SetPoint) with<ul><li>**anchor** [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)</li><li>**relativeTo**? [Frame](https://wowpedia.fandom.com/wiki/API_CreateFrame#Frame_types)</li><li>**relativePoint**? [AnchorPoint](https://wowpedia.fandom.com/wiki/Anchors)</li><li>**offset** table<ul><li>**x** number</li><li>**y** number</li></ul></li></ul></li><li>**keepInBounds**? boolean — When set, add a toggle for a value used for **t.frame**:[SetClampedToScreen(...)](https://wowpedia.fandom.com/wiki/API_Frame_SetClampedToScreen)</li><li>**layer**? boolean — When set, add screen layer options<ul><li>**strata**? [FrameStrata](https://wowpedia.fandom.com/wiki/Frame_Strata) — Used for **t.frame**:[SetFrameStrata(...)](https://wowpedia.fandom.com/wiki/API_Frame_SetFrameStrata)</li><li>**keepOnTop**? boolean — When set, add a toggle for a value used for **t.frame**:[SetToplevel(...)](https://wowpedia.fandom.com/wiki/API_Frame_SetToplevel)</li></ul>
---@field defaultsTable table Reference to the table containing the default values<ul><li>***Note:*** The defaults table should contain values under matching keys to the values within *t.getData()*.</li></ul>
---@field settingsData table Reference to the SavedVariables or SavedVariablesPerCharacter table where settings specifications are to be stored and loaded from<ul><li>***Note:*** The following key, value pairs will be used for storing settings data within this table:<ul><li>**keepInPlace** — If true, don't move **frame** when changing the anchor, update the offset values instead.</li></li></ul></ul>
---@field dataManagement? optionsData_position Register the positioning widgets to options data management linked with the specified key under the specified category
---@field onChangePosition? function Function to call after the value of **panel.position.anchor**, **panel.position.relativeTo**, **panel.position.relativePoint**, **panel.position.offset.x** or **panel.position.offset.y** was changed by the user or via options data management before the base onChange handler is called built-in to the functionality of the position options panel template updating the position of **t.frame**
---@field onChangeKeepInBounds? function Function to call after the value of **panel.position.keepInBounds** was changed by the user or via options data management before the base onChange handlers are called built-in to the functionality of the position options panel template updating **t.frame**
---@field onChangeStrata? function Function to call after the value of **panel.layer.strata** was changed by the user or via options data management before the base onChange handlers are called built-in to the functionality of the position options panel template updating **t.frame**
---@field onChangeLevel? function Function to call after the value of **panel.layer.level** was changed by the user or via options data management before the base onChange handlers are called built-in to the functionality of the position options panel template updating **t.frame**
---@field onChangeKeepOnTop? function Function to call after the value of **panel.layer.keepOnTop** was changed by the user or via options data management before the base onChange handlers are called built-in to the functionality of the position options panel template updating **t.frame**


--[[ ADDON COMPARTMENT ]]

---@class addonCompartmentFunctions
---@field onClick? fun(addon: string, button: string, frame: Button) Called when the **addon**'s compartment button is clicked<ul><li>***Note:*** `AddonCompartmentFunc`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>
---@field onEnter? fun(addon: string, frame: Button) Called when the **addon**'s compartment button is being hovered before the tooltip (if set) is shown<ul><li>***Note:*** `AddonCompartmentFuncOnEnter`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>
---@field onLeave? fun(addon: string, frame: Button) Called when the **addon**'s compartment button is stopped being hovered before the tooltip (if set) is hidden<ul><li>***Note:*** `AddonCompartmentFuncOnLeave`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>


--[[ Profiles ]]

---@class profile
---@field title string Display name of the profile
---@field data table Custom profile data

---@class profileStorage
---@field profiles profile[] List of profiles