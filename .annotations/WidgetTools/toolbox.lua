--NOTE: Annotations are for development purposes only, providing documentation for use with LUA Language Server. This file does not need to be loaded by the game client.


--[[ BLIZZARD ]]

---@class SettingsCheckboxTemplate
---@field HoverBackground Frame


--[[ MISC ]]

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

---@alias AnyFrameObject
---| Frame
---| Button
---| CheckButton
---| EditBox
---| Slider
---| Texture
---| FontString

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

---@alias ExtendedHyperlinkType
---| HyperlinkType
---| "addon"
---| "mawpower"

---@class attributeEventData
---@field name string
---@field handler fun(...: any)

---@alias AnyWidgetType
---| action
---| toggle
---| selector
---| specialSelector
---| multiselector
---| textbox
---| numeric
---| colormanager
---| profilemanager

---@alias AnyGUIWidgetType
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

---@alias AnyTypeName
---| WidgetTypeName
---| MutatedWidgetTypeName
---| SettingsPageTypeName
---| OptionsTemplateTypeName
---| "SettingsCategory"


--[[ TABLE MANAGEMENT ]]

---@class recoveredData
---@field keyChain string Chain of keys that used to point to the removed data<ul><li>***Example:*** `"keyOne[2].keyThree.keyFour[1]"`.</li></ul>
---@field data any Recoverable piece of removed data

---@class recoveryData
---@field saveTo table List of references to the tables to save the recovered piece of data to
---@field saveKey string|number Save the data under this kay within the specified recovery tables
---@field convertSave? fun(recovered: any): converted: any Function to convert or modify the recovered old data before it is saved


--[[ UI OBJECT ]]

---@class childObject
---@field parent? AnyFrameObject Reference to the frame to set as the parent

---@class namedObject_base
---@field name? string Unique string used to set the frame name | ***Default:*** "Frame"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>

---@class namedChildObject : childObject, namedObject_base
---@field append? boolean Instead of setting the specified name by itself, append it to the name of the specified parent frame | ***Default:*** `true` if t.parent ~= UIParent


--[[ LITE MODE ]]

---@class liteObject
---@field lite? boolean If false, overrule **WidgetToolsDB.lite** and use full GUI functionality | ***Default:*** `true`


--[[ POSITION & DIMENSIONS ]]

---@class axisData
---@field h? boolean Horizontal x axis | ***Default:*** `false`
---@field v? boolean Vertical y axis | ***Default:*** `false`

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
---@field position? positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"

---@class positionableScreenObject : positionableObject
---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** `false`

--| Arrangement

---@class spacingData
---@field l? number Space to leave on the left side | ***Default:*** 12
---@field r? number Space to leave on the right side (doesn't need to be negated) | ***Default:*** 12
---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** 12
---@field b? number Space to leave at the bottom | ***Default:*** 12

---@class arrangementRules
---@field margins? spacingData Inset the content inside the container frame by the specified amount on each side
---@field gaps? number The amount of space to leave between rows and items within rows | ***Default:*** 8
---@field flip? boolean Fill the rows from right to left instead of left to right | ***Default:*** `false`
---@field resize? boolean Set the height of the container frame to match the space taken up by the arranged content (including margins) | ***Default:*** `true`

---@class initializableContainer
---@field arrangement? arrangementRules If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table
---@field initialize? fun(container?: Frame, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

---@class initializableOptionsContainer : initializableContainer
---@field initialize? fun(container?: Frame, width: number, height: number, category?: string, keys?: string[], name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? AnyFrameObject ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `category`? string A unique string used for categorizing settings data management rules & change handler scripts</p><p>@*param* `keys`? string[] Reference to **t.dataManagement.keys**, a list of unique strings appended to **category** linking a subset of settings data rules to be handled together in the specified order</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

---@class arrangementDirective
---@field wrap? boolean Place the frame into a new row within its container instead of adding it to the current row being filled | ***Default:*** `true`<ul><li>***Note:*** If the item would not fit in the row with other items in there, it will automatically be placed in a new row.</li></ul>
---@field index? integer The ordering index of the frame by which to be placed during arrangement | ***Default:*** *use the ordering of the children of the parent container frame*

---@class arrangeableObject
---@field arrange? arrangementDirective When set, automatically position the frame in a columns within rows arrangement in its parent container via ***WidgetToolbox*.ArrangeContent(**t.parent**, ...)**

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
---@field width? number ***Default:*** 180

--| Movability

---@class movementEvents
---@field onStart? function Function to call when **frame** starts moving
---@field onMove? function Function to call every with frame update while **frame** is moving (if **frame** has the "OnUpdate" script defined)
---@field onStop? function Function to call when the movement of **frame** is stopped and the it was moved successfully
---@field onCancel? function Function to call when the movement of **frame** is cancelled (because the modifier key was released early as an example)

---@class movabilityData
---@field modifier? ModifierKey|any The specific (or any) modifier key required to be pressed down to move **t.frame** (if **t.frame** has the "OnUpdate" script defined) | ***Default:*** nil *(no modifier)*<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://warcraft.wiki.gg/wiki/API_IsModifierKeyDown) is used.</li></ul>
---@field triggers? Frame[] List of frames that should handle inputs to initiate or stop the movement when interacted with | ***Default:*** **t.frame**
---@field events? movementEvents Table containing functions to call when certain movement events occur
---@field cursor? boolean If true, change the cursor to a movement cross when mousing over **t.frame** and **t.modifier** is pressed down if set | ***Default:*** **t.modifier** ~= nil


--[[ VISIBILITY ]]

--| Strata & Level

---@class visibleObject_base
---@field visible? boolean Whether to make the frame visible during initialization or not | ***Default:*** `true`
---@field frameStrata? FrameStrata Pin the frame to the specified strata
---@field frameLevel? integer The ordering level of the frame within its strata to set
---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** `false`


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
---@field style TBFFlags Comma separated string of font styling flags

---@class fontCreationData
---@field template? FontObject An existing [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to copy as a baseline
---@field font? fontData Table containing font properties used for [FontInstance:SetFont(...)](https://warcraft.wiki.gg/wiki/API_FontInstance_SetFont) (overriding **t.template**)
---@field color? colorData_whiteDefault|colorData Apply the specified color to the font (overriding **t.template**)
---@field spacing? number Set the character spacing of the text using this font (overriding **t.template**)
---@field shadow? { offset: offsetData, color: colorData_blackDefault|colorData } Set a text shadow with the following parameters (overriding **t.template**)
---@field justify? justifyData_centered Set the justification of the text using font (overriding **t.template**)
---@field wrap? boolean Whether or not to allow the text lines using this font to wrap (overriding **t.template**)

---@class textCreationData : positionableObject
---@field parent? AnyFrameObject Reference to parent frame to create and assign the text to | ***Default:*** UIParent
---@field name? string String appended to the name of **t.parent** used to set the name of the new [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** "Text"
---@field width? number
---@field height? number
---@field layer? DrawLayer
---@field text? string Text to be shown
---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used | ***Default:*** "GameFontNormal"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
---@field color? colorData|colorRGBA Apply the specified color to the text (overriding **t.font**)
---@field justify? justifyData Set the justification of the text (overriding **t.font**)
---@field wrap? boolean Whether or not to allow the text lines to wrap (overriding **t.font**) | ***Default:*** `true`

---@class labelFontOptions
---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** "GameFontHighlight"
---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in a highlighted state | ***Default:*** "GameFontNormal"
---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** "GameFontDisable"

---@class labelFontOptions_highlight
---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** "GameFontNormal"
---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** "GameFontHighlight"
---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** "GameFontDisable"

---@class labelFontOptions_small
---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** "GameFontHighlightSmall"
---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** "GameFontDisableSmall"

---@class labelFontOptions_small_highlight
---@field normal? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is in its regular state | ***Default:*** "GameFontNormalSmall"
---@field highlight? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is being hovered | ***Default:*** "GameFontHighlightSmall"
---@field disabled? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to be used when the widget is disabled | ***Default:*** "GameFontDisableSmall"

---[ Title & Description ]

---@class descriptionColorData
---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** HIGHLIGHT_FONT_COLOR.r
---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** HIGHLIGHT_FONT_COLOR.g
---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** HIGHLIGHT_FONT_COLOR.b
---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 0.55

---@class titleCreationData
---@field anchor? FramePoint ***Default:*** "TOPLEFT"
---@field offset? offsetData The offset from the anchor point relative to the specified frame
---@field width? number ***Default:*** *width of the text*
---@field text? string Text to be shown as the main title of the frame
---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontHighlight"
---@field color? colorData Apply the specified color to the title (overriding **t.font**)
---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding **t.font**) | ***Default:*** "LEFT"

---@class descriptionCreationData
---@field offset? offsetData The offset from the default position (right side of the separator to the right of **t.title**)
---@field width? number ***Default:*** *width of the parent frame of **t.title** - width of **t.title** (& separator, offsets)*
---@field widthOffset? number Increase the calculated with by this amount | ***Default:*** 0
---@field spacer? number Space to leave between **t.title** & the separator and the separator & the description | ***Default:*** 5
---@field text? string Text to be shown as the description of the frame
---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontHighlightSmall2"
---@field color? descriptionColorData|colorData Apply the specified color to the description (overriding **t.font**)
---@field justify? JustifyHorizontal Set the horizontal text alignment (overriding **t.font**) | ***Default:*** "LEFT"

---@class titledObject_base
---@field title? string Text to be displayed as the title | ***Default:*** **t.name**

---@class labeledObject_base
---@field label? boolean Whether to show the title textline or not | ***Default:*** `true`

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
---@field h? boolean Horizontal | ***Default:*** `false`
---@field v? boolean Vertical | ***Default:*** `false`

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
---@field name? string String appended to the name of **t.parent** used to set the name of the new texture | ***Default:*** "Texture"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData ***Default:*** *size of* **parent**
---@field atlas? string Name of the texture atlas to use instead of creating a texture based on **t.path**<ul><li>***Note:*** Settings this will override whatever **t.path** is set to.</li></ul>
---@field layer? DrawLayer
---@field level? integer Sublevel to set within the specified draw layer | ***Range:*** (-8, 7)
---@field tile? tileData Set the tiling behaviour of the texture | ***Default:*** *no tiling*
---@field wrap? wrapData Set the warp mode for each axis
---@field filterMode? FilterMode | ***Default:*** "LINEAR"
---@field flip? axisData Mirror the texture on the horizontal and/or vertical axis
---@field color? colorData Apply the specified color to the texture
---@field edges? edgeCoordinates Edge coordinate offsets
---@field vertices? vertexCoordinates Vertex coordinate offsets<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, **t.edges** will be used first ignoring **t.vertices**.</li></ul>
---@field events? table<ScriptType, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the texture object and the functions to assign as event handlers called when they trigger

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
---@field color? colorData Apply the specified color to the texture | ***Default:*** **t.color**
---@field edges? edgeCoordinates Edge coordinate offsets ***Default:*** **t.edges**
---@field vertices? vertexCoordinates Vertex coordinate offsets ***Default:*** **t.vertices**<ul><li>***Note:*** Setting texture coordinate offsets is exclusive between edges and vertices. If set, **t.edges** will be used first ignoring **t.vertices**.</li></ul>

---@class textureUpdateRule
---@field frame? AnyFrameObject Reference to the frame to add the listener script to | ***Default:*** **t.parent**
---@field rule? fun(self: Frame, ...: any): data: textureUpdateData|nil Evaluate the event and specify the texture updates to set, or, if nil, restore the base values unconditionally on event trigger<hr><p>@*param* `self` AnyFrameObject — Reference to **updates[*key*].frame**</p><p>@*param* `...` any — Any leftover arguments will be passed from the handler script to **updates[*key*].rule**</p><hr><p>@*return* `data` textureUpdateData|nil — Parameters to update the texture with | ***Default:*** **t**</p>


--[[ LINE ]]

---@class lineCreationData
---@field name? string String appended to the name of **t.parent** used to set the name of the new line | ***Default:*** "Line"
---@field startPosition? pointData Parameters to call [Line:SetStartPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetStartPoint) with | ***Default:*** "TOPLEFT"
---@field endPosition? pointData Parameters to call [Line:SetEndPoint(...)](https://warcraft.wiki.gg/wiki/API_Line_SetEndPoint) with | ***Default:*** "TOPLEFT"
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
---@field tile? boolean Whether to repeat the texture to fill the entire size of the frame | ***Default:*** `true`
---@field insets? insetData Offset the position of the background texture from the edges of the frame inward

---@class backdropBackgroundData
---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture
---@field color? colorData Apply the specified color to the background texture

---@class backdropUpdateBackgroundData
---@field texture? backdropBackgroundTextureData Parameters used for setting the background texture | ***Default:*** **backdrop.background.texture** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure))*
---@field color? colorData Apply the specified color to the background texture | ***Default:*** **backdrop.background.color** if **fill** == true *(if it's false, keep the currently set values of **frame**:[GetBackdropColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

---@class backdropBorderTextureData
---@field path? string Path to the specific texture file relative to the root directory of the specific WoW client | ***Default:*** "Interface/Tooltips/UI-Tooltip-Border"<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Textures/TextureImage.tga), otherwise use `\\`.</li><li>***Note:*** **File format:** Texture files must be in JPEG (no transparency, not recommended), PNG, TGA or BLP format.</li><li>***Note:*** **Size:** Texture files must have powers of 2 dimensions to be handled by the WoW client.</li></ul>
---@field width number Width of the backdrop edge

---@class backdropBorderData
---@field texture? backdropBorderTextureData Parameters used for setting the border texture
---@field color? colorData Apply the specified color to the border texture

---@class backdropUpdateBorderData
---@field texture? backdropBorderTextureData Parameters used for setting the border texture | ***Default:*** **backdrop.border.texture** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure))*
---@field color? colorData Apply the specified color to the border texture | ***Default:*** **backdrop.border.color** if **fill** == true *(if it's false, keep the currently set values of **frame**:[GetBackdropBorderColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

---@class backdropData
---@field background? backdropBackgroundData Table containing the parameters used for the background
---@field border? backdropBorderData Table containing the parameters used for the border

---@class backdropUpdateData
---@field background? backdropBackgroundData Table containing the parameters used for the background | ***Default:*** **backdrop.background** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*
---@field border? backdropBorderData Table containing the parameters used for the border | ***Default:*** **backdrop** if **fill** == true *(if it's false, keep the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure) and **frame**:[GetBackdropBorderColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods))*

---@class backdropUpdateRule
---@field triggers? AnyFrameObject[] References to the frames to add the listener script to | ***Default:*** { **frame** }
---@field rules table<AnyScriptType, string|fun(frame: AnyFrameObject, self: AnyFrameObject, ...: any): backdropUpdate: backdropUpdateData|nil, fill: boolean|nil> List of events and update actions returning backdrop values to update the backdrop with, or, if they are set but not valid functions to call, restore the base **backdrop** unconditionally on event trigger<ul><li>***Note:*** Return an empty table `{}` for **backdropUpdate** and true for **fill** in order to restore the base **backdrop** after evaluation.</li><li>***Note:*** Return an empty table `{}` for **backdropUpdate** and false or nil for **fill** to do nothing (keep the current backdrop).</li></ul><hr><p>@*param* `frame` AnyFrameObject ― Reference to backdrop frame</p><p>@*param* `self` AnyFrameObject ― Reference to the specific trigger frame</p><p>@*param* `...` any ― Any leftover arguments will be passed from the handler script to **updates[*key*].rule**</p><hr><p>@*return* `backdropUpdate`? backdropUpdateData|nil ― Parameters to update the backdrop with | ***Default:*** nil *(remove the backdrop)*</p><p>@*return* `fill`? boolean|nil ― If true, fill the specified defaults for the unset values in **backdropUpdates** with the values provided in **backdrop** at matching keys, if false, fill them with their corresponding values from the currently set values of **frame**.[backdropInfo](https://warcraft.wiki.gg/wiki/BackdropTemplate#Table_structure), **frame**:[GetBackdropColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods) and **frame**:[GetBackdropBorderColor()](https://warcraft.wiki.gg/wiki/BackdropTemplate#Methods) | ***Default:*** `false`</p>

---@class customizableObject
---@field backdrop? backdropData Parameters to set the custom backdrop with
---@field backdropUpdates? backdropUpdateRule[] Table of key, value pairs containing the list of events to set listeners for assigned to **t.backdropUpdates[*key*].frame**, linking backdrop changes to it, modifying the specified parameters on trigger
--- - ***Note:*** All update rules are additive, calling ***WidgetToolbox*.SetBackdrop(...)** multiple times with **t.backdropUpdates** specified *will not* override previously set update rules. The base **backdrop** values used for these old rules *will not* change by setting a new backdrop via ***WidgetToolbox*.SetBackdrop(...)** either!

---@class backdropFrame : BackdropTemplate
---@field backdropInfo backdropInfo


--[[ CHAT CONTROL ]]

---@alias chatCommandColorNames
---| "title"
---| "content"
---| "command"
---| "description"

---@class chatCommandColors
---@field title? colorData Color for the addon title used for branding chat messages | ***Default:*** `YELLOW_FONT_COLOR`
---@field content? colorData Color for chat message contents appended after the title (used for success & error responses) | ***Default:*** `WHITE_FONT_COLOR`
---@field command? colorData Used to color the registered chat commands when they are being listed | ***Default:*** `LIGHTBLUE_FONT_COLOR`
---@field description? colorData Used to color the description of registered chat commands when they are being listed | ***Default:*** `LIGHTGRAY_FONT_COLOR`

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

---@class chatCommandManagerCreationData
---@field commands? chatCommandData[] Indexed table with the list of commands to register under the specified **keywords**
---@field colors? chatCommandColors Color palette used when printing out default-formatted chat messages
---@field defaultHandler? fun(commandManager: chatCommandManager, command: string, ...: string) Default handler function to call when an unrecognized command is typed, executed before a help command is triggered, listing all registered commands<hr><p>@*param* `commandManager` commandManager ― Reference to the command manager</p><p>@*param* `command` string ― The unrecognized command typed after the keyword (separated by a space character)</p><p>@*param* `...` string Payload of the command typed, any words following the command name separated by spaces (split, returned unpacked)</p>
---@field onWelcome? function Called when the welcome message with keyword hints is printed out


--[[ TOOLTIP ]]

---@class tooltipFrameData
---@field tooltip? GameTooltip Reference to the tooltip frame to set up | ***Default:*** *default WidgetTools custom tooltip*

---@class tooltipLineData
---@field text string Text to be displayed in the line
---@field font? string|FontObject The [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) to set for this line | ***Default:*** GameTooltipTextSmall
---@field color? rgbData_base Table containing the RGB values to color this line with (overriding **font**)
---@field wrap? boolean Allow the text in this line to be wrapped | ***Default:*** `true`

---@class tooltipTextData
---@field title? string String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR) | ***Default:*** **owner:GetName()** or **tostring(owner)**
---@field lines? tooltipLineData[] Table containing the lists of parameters for the text lines after the title

---@class tooltipData : tooltipFrameData, tooltipTextData
---@field anchor? TooltipAnchor ***Default:*** "ANCHOR_CURSOR"
---@field offset? offsetData Values to offset the position of ***tooltipData*.tooltip** by
---@field position? positionData_base|positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** "TOPLEFT" if ***tooltipData*.anchor** == "ANCHOR_NONE"<ul><li>***Note:*** **t.offset** will be used when calling [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) as well.</li></ul>
---@field flipColors? boolean Flip the default color values of the title and the text lines | ***Default:*** `false`

---@class tooltipUpdateData
---@field title? string String to be shown as the tooltip title (text color: NORMAL_FONT_COLOR) | ***Default:*** **owner.tooltipData.title**
---@field lines? tooltipLineData[] Table containing the lists of parameters for the text lines after the title | ***Default:*** **owner.tooltipData.lines**
---@field tooltip? GameTooltip Reference to the tooltip frame to set up | ***Default:*** **owner.tooltipData.tooltip**
---@field offset? offsetData Values to offset the position of ***tooltipData*.tooltip** by | ***Default:*** **owner.tooltipData.offset**
---@field position? positionData_base|positionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with when the tooltip is not automatically positioned via **t.anchor** | ***Default:*** **owner.tooltipData.position**
---@field flipColors? boolean Flip the default color values of the title and the text lines | ***Default:*** **owner.tooltipData.flipColors**
---@field anchor? TooltipAnchor [GameTooltip anchor](https://warcraft.wiki.gg/wiki/API_GameTooltip_SetOwner) | ***Default:*** **owner.tooltipData.anchor**

---@class tooltipToggleData
---@field triggers? Frame[] List of references to additional frames to add hover events to to toggle ***tooltipData*.tooltip** for **owner** besides **owner** itself
---@field checkParent? boolean Whether to check if **owner** is being hovered before hiding ***tooltipData*.tooltip** when triggers stop being hovered | ***Default:*** `true`
---@field replace? boolean If false, while ***tooltipData*.tooltip** is already visible for a different owner, don't change it | ***Default:*** `true`<ul><li>***Note:*** If ***tooltipData*.tooltip** is already shown for **owner**, ***WidgetToolbox*.UpdateTooltip(...)** will be called anyway.</li></ul>

---@class widgetTooltipTextData : tooltipTextData
---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** **t.title**

---@class itemTooltipTextData : tooltipTextData
---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** **t.items[*index*].title**

---@class presetTooltipTextData : tooltipTextData
---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** **t.presets.items[*index*].title**

---@class addonCompartmentTooltipData : tooltipFrameData, tooltipTextData
---@field title? string Text to be displayed in the title line of the tooltip | ***Default:*** [GetAddOnMetadata(**addon**, "title")](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata)

---@class tooltipDescribableWidget
---@field tooltip? widgetTooltipTextData List of text lines to be added to the tooltip of the widget displayed when mousing over the frame

--| Tooltip data

---@alias AnyTooltipData
---| tooltipData
---| widgetTooltipTextData
---| itemTooltipTextData
---| presetTooltipTextData
---| addonCompartmentTooltipData


--[[ DEPENDENCIES ]]

---@class dependencyRule
---@field frame AnyFrameObject|toggle|selector|multiselector|specialSelector|textbox|numeric Tie the state of the widget to the evaluation of the current value of the frame specified here
---@field evaluate? fun(value?: any): evaluation: boolean Call this function to evaluate the current value of the specified frame, enabling the dependant widget when true, or disabling it when false is returned | ***Default:*** *no evaluation, only for checkboxes*<ul><li>***Note:*** **evaluate** must be defined if the [FrameType](https://warcraft.wiki.gg/wiki/API_CreateFrame#Frame_types) if **frame** is not "CheckButton".</li><li>***Overloads:***</li><ul><li>function(`value`: boolean) -> `evaluation`: boolean — If **frame** is recognized as a checkbox</li><li>function(`value`: string) -> `evaluation`: boolean — If **frame** is recognized as an editbox</li><li>function(`value`: number) -> `evaluation`: boolean — If **frame** is recognized as a slider</li><li>function(`value`: integer) -> `evaluation`: boolean — If **frame** is recognized as a dropdown or selector</li><li>function(`value`: boolean[]) -> `evaluation`: boolean — If **frame** is recognized as multiselector</li><li>function(`value`: AnchorPoint|JustifyH|JustifyV|FrameStrata) -> `evaluation`: boolean — If **frame** is recognized as a special selector</li><li>function(`value`: nil) -> `evaluation`: boolean — In any other case *(could be used to add a unique rule tied to unrecognized frame types)*</li></ul></ul>

---@class togglableObject
---@field disabled? boolean If true, set the state of this widget to be disabled during initialization | ***Default:*** `false`<ul><li>***Note:*** Dependency rule evaluations may re-enable the widget after initialization.</li></ul>
---@field dependencies? dependencyRule[] Automatically enable or disable the widget based on the set of rules described in subtables


--[[ SETTINGS DATA MANAGEMENT ]]

---@class settingsRule
---@field widget AnyWidgetType|AnyGUIWidgetType Reference to the widget to be saved & loaded data to/from with defined **loadData** and **saveData** functions
---@field onChange? string[] List of keys referencing functions to be called after the value of **widget** was changed by the user or via settings data management

---@class settingsData_base
---@field category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** **addon**

---@class settingsData
---@field category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(register as a global rule)*
---@field key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
---@field index? integer Set when to place this widget in the execution order when saving or loading batched settings data | ***Default:*** *placed at the end of the current list*
---@field onChange? table<string|integer, function|string> table<string|integer, function|string> List of new or already defined functions to call after the value of the widget was changed by the user or via settings data management<ul><li>**[*key*]**? string|integer ― A unique string appended to **category** to point to a newly defined function to be added to settings data management or just the index of the next function name | ***Default:*** *next assigned index*</li><li>**[*value*]** function|string ― The new function to register under its unique key, or the key of an already existing function</li><ul><li>***Note:*** Function definitions will be replaced by key references when they are registered to settings data management. Functions registered under duplicate keys are overwritten.</li></ul></ul>

---@class settingsData_collection : settingsData_base
---@field keys? string[] An ordered list of unique strings appended to **category** linking a subset of settings data rules to be handled together in the specified order via this settings category page | ***Default:*** { **t.name** }

---@class settingsWidget
---@field dataManagement? settingsData If set, register this widget to settings data management for batched data saving & loading and handling data changes
---@field instantSave? boolean Immediately commit the data to storage whenever it's changed via the widget | ***Default:*** `true`<ul><li>***Note:*** Any unsaved data will be saved when ***WidgetToolbox*.SaveOptionsData(...)** is executed.</li></ul>

---@class settingsCategoryData
---@field dataManagement? settingsData_collection If set, register this settings page to settings data management for batched data saving & loading and handling data changes of all linked widgets

---@class tooltipDescribableSettingsWidget
---@field showDefault? boolean If true, show the default value of the widget in its tooltip and display the reset button its the utility menu | ***Default:*** `true`
---@field utilityMenu? boolean If true, assign a context menu to the settings widget frame to allow for quickly resetting changes or the default value | ***Default:*** `true`


--[[ Profiles ]]

---@class profile
---@field title string Display name of the profile
---@field data table Custom profile data

---@class profileStorage
---@field profiles profile[] List of profiles


--[[ ADDON COMPARTMENT ]]

---@class addonCompartmentFunctions
---@field onClick? fun(addon: string, button: string, frame: Button) Called when the **addon**'s compartment button is clicked<ul><li>***Note:*** `AddonCompartmentFunc`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>
---@field onEnter? fun(addon: string, frame: Button|Frame) Called when the **addon**'s compartment button is being hovered before the tooltip (if set) is shown<ul><li>***Note:*** `AddonCompartmentFuncOnEnter`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>
---@field onLeave? fun(addon: string, frame: Button|Frame) Called when the **addon**'s compartment button is stopped being hovered before the tooltip (if set) is hidden<ul><li>***Note:*** `AddonCompartmentFuncOnLeave`, must be set in the specified **addon**'s TOC file, defining the name of the global function to be set for call.</li></ul>


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

---@class popupInputBoxData : positionableObject, tooltipDescribableWidget
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
---@field position? reloadFramePositionData Table of parameters to call [Region:SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPRIGHT", -300, -80


--[[ CONTAINERS ]]

--[ Frame ]

---@class frameCreationData : positionableScreenObject, arrangeableObject, visibleObject_base, initializableContainer
---@field parent? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** nil *(parentless frame)*<ul><li>***Note:*** You may use [Region:SetParent(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
---@field name? string Unique string used to set the name of the new frame | ***Default:*** nil *(anonymous frame)*<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field append? boolean When setting the name, append **t.name** to the name of **t.parent** instead | ***Default:*** `true` if **t.name** ~= nil and **t.parent** ~= nil and **t.parent** ~= UIParent
---@field size? sizeData_zeroDefault|sizeData ***Default:*** *no size*<ul><li>***Note:*** Omitting or setting either value to 0 will result in the frame being invisible and not getting placed on the screen.</li></ul>
---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the **t.onEvent** table.</li></ul>
---@field onEvent? table<WowEvent, fun(self: Frame, ...: any)> Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame<ul><li>***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.</li><li>***Example:*** "[ADDON_LOADED](https://warcraft.wiki.gg/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.<pre>```function(self, addon)```<br>&#9;```if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch```<br>&#9;```self:UnregisterEvent("ADDON_LOADED")```<br>&#9;```--Do something```<br>```end```</pre></li></ul>

--[ ScrollFrame ]

---@class sizeData_scroll
---@field w? number Horizontal size of the scrollable child frame | ***Default:*** **t.size.width** - 16
---@field h? number Vertical size of the scrollable child frame | ***Default:*** 0 *(no height)*

---@class scrollSpeedData
---@field scrollSpeed? number Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25

---@class scrollframeCreationData : childObject, positionableObject, initializableContainer, scrollSpeedData
---@field name? string Unique string used to append to the name of **t.parent** when setting the names of the name of the scroll parent and its scrollable child frame | ***Default:*** "Scroller" *(for the scrollable child frame)*<ul><li>***Note:*** Space characters will be removed when used for setting the frame names.</li></ul>
---@field size? sizeData_parentDefault|sizeData ***Default:*** **t.parent** and *size of the parent frame* or *no size*
---@field scrollSize? sizeData_scroll|sizeData ***Default:*** *size of the parent frame*

--[ Panel ]

--| Parameters

---@class sizeData_panel
---@field w? number Width | ***Default:*** **t.parent** and *width of the parent frame* - 20 or 0
---@field h? number Height | ***Default:*** 0<ul><li>***Note:*** If content is added, arranged and **t.arrangeContent.resize** is true, the height will be set dynamically based on the calculated height of the content.</li></ul>

---@class backgroundColorData_panel
---@field r? number Red | ***Range:*** (0, 1) | ***Default:*** 0.175
---@field g? number Green | ***Range:*** (0, 1) | ***Default:*** 0.175
---@field b? number Blue | ***Range:*** (0, 1) | ***Default:*** 0.175
---@field a? number Opacity | ***Range:*** (0, 1) | ***Default:*** 0.65

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

--| Constructors

---@class panelCreationData : labeledChildObject, describableObject, positionableScreenObject, arrangeableObject, visibleObject_base, backdropData, initializableContainer, liteObject
---@field name? string Unique string used to set the frame name | ***Default:*** "Panel"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_panel|sizeData
---@field background? backdropBackgroundData_panel Table containing the parameters used for the background
---@field border? backdropBorderData_panel Table containing the parameters used for the border
---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the panel and the functions to assign as event handlers called when they trigger
---@field initialize? fun(container?: panel, width: number, height: number, name?: string) This function will be called while setting up the container frame to perform specific tasks like creating content child frames right away<hr><p>@*param* `container`? panel ― Reference to the frame to be set as the parent for child objects created during initialization (nil if **WidgetToolsDB.lite** is true)</p><p>@*param* `width` number The current width of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `height` number The current height of the container frame (0 if **WidgetToolsDB.lite** is true)</p><p>@*param* `name`? string The name parameter of the container specified at construction</p>

--[ Context Menu ]

--| Parameters

---@class queuedMenuItem
---@field queue? boolean If true, the item will only appear when additional items are added to the menu | ***Default:*** `false`

---@class sizeData_menuButton
---@field w? number Width | ***Default:*** 180
---@field h? number Height | ***Default:*** 26

---@class contextMenuTriggerData
---@field frame AnyFrameObject? Reference to the frame to set as a trigger | ***Default:*** UIParent *(opened at cursor position)*
---@field rightClick? boolean If true, create and open the context menu via a right-click mouse click event on **frame** | ***Default:*** `true`
---@field leftClick? boolean If true, create and open the context menu via a left-click mouse click event on **frame** | ***Default:*** `false`
---@field hover? boolean If true, create and open the context menu via a mouse hover event on **frame** | ***Default:*** `false`
---@field condition? fun(action: "click"|"hover"|nil): boolean Function to call and evaluate before creating and opening the menu: if the returned value is not true, don't open the menu

--| Constructors

---@class contextMenuCreationData_base
---@field initialize? fun(menu: contextMenu|contextSubmenu) This function will be called while setting up the menu to perform specific tasks like creating menu content items right away<hr><p>@*param* `menu` contextMenu|contextSubmenu ― Reference to the container of menu elements (such as titles, widgets, dividers or other frames) for menu items to be added to during initialization</p>

---@class contextMenuCreationData : contextMenuCreationData_base
---@field triggers? contextMenuTriggerData[] List of trigger frames and behavior to link to toggle the context menu | ***Default:*** *(no triggers)*

---@class contextSubmenuCreationData : contextMenuCreationData_base
---@field title? string Text to be shown on the opener button item representing the submenu within the parent menu | ***Default:*** "Submenu"

---@class menuTextlineCreationData : queuedMenuItem
---@field text? string Text to be shown on the textline item within the parent menu | ***Default:*** "Title"

---@class menuButtonCreationData
---@field title? string Text to be shown on the button item within the parent menu | ***Default:*** "Button"
---@field action? fun(...: any) Function to call when the button is clicked in the menu<hr><p>@*param* `...` any</p>

---@class popupMenuCreationData : labeledChildObject, tooltipDescribableWidget, positionableScreenObject, arrangeableObject, visibleObject_base, contextMenuCreationData_base
---@field parent? AnyFrameObject Reference to the frame to set as the parent of the new frame | ***Default:*** nil *(parentless frame)*<ul><li>***Note:*** You may use [Region:SetParent(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegion_SetParent) to set the parent frame later.</li></ul>
---@field name? string Unique string used to set the frame name | ***Default:*** "PopupMenu"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field size? sizeData_menuButton|sizeData
---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the frame and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnEvent](https://warcraft.wiki.gg/wiki/UIHANDLER_OnEvent)" handlers specified here will not be set. Handler functions for specific global events should be specified in the **t.onEvent** table.</li></ul>
---@field onEvent? table<WowEvent, fun(self: Frame, ...: any)> Table of key, value pairs that holds global event tags & their corresponding event handlers to be registered for the frame<ul><li>***Note:*** You may want to include [Frame:UnregisterEvent(...)](https://warcraft.wiki.gg/wiki/API_Frame_UnregisterEvent) to prevent the handler function to be executed again.</li><li>***Example:*** "[ADDON_LOADED](https://warcraft.wiki.gg/wiki/ADDON_LOADED)" is fired repeatedly after each addon. To call the handler only after one specified addon is loaded, you may check the parameter the handler is called with. It's a good idea to unregister the event to prevent repeated calling for every other addon after the specified one has been loaded already.<pre>```function(self, addon)```<br>&#9;```if addon ~= "AddonNameSpace" then return end --Replace "AddonNameSpace" with the namespace of the specific addon to watch```<br>&#9;```self:UnregisterEvent("ADDON_LOADED")```<br>&#9;```--Do something```<br>```end```</pre></li></ul>


--[[ SETTINGS ]]

---@class canvasFrame : Frame
---@field OnCommit function
---@field OnRefresh function
---@field OnDefault function

--[ Settings Page ]

---@class settingsPageScrollData : scrollSpeedData
---@field height? number Set the height of the scrollable child frame to the specified value | ***Default:*** 0 *(no height)*
---@field speed? number Percentage of one page of content to scroll at a time | ***Range:*** (0, 1) | ***Default:*** 0.25

---@class spacingData_settingsPage
---@field l? number Space to leave on the left side | 10
---@field r? number Space to leave on the right side (doesn't need to be negated) | ***Default:*** 10
---@field t? number Space to leave at the top (doesn't need to be negated) | ***Default:*** 44
---@field b? number Space to leave at the bottom | ***Default:*** 44

---@class arrangementData_settingsPage : arrangementRules
---@field margins? spacingData_settingsPage Inset the content inside the canvas frame by the specified amount on each side
---@field gaps? number The amount of space to leave between rows | ***Default:*** 44
---@field resize? boolean Set the height of the canvas frame to match the space taken up by the arranged content (including margins) | ***Default:*** **t.scroll** ~= nil

---@class settingsPageCreationData_base
---@field register? boolean|settingsPage If true, register the new page to the Settings panel as a parent category or a subcategory of an already registered parent category if a reference to an existing settings category parent page provided | ***Default:*** `false`<ul><li>***Note:*** The page can be registered later via ***WidgetToolbox*.RegisterSettingsPage(...)**.</li></ul>
---@field name? string Unique string used to set the name of the canvas frame | ***Default:*** **addon**<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field title? string Text to be shown as the title of the settings page | ***Default:*** [GetAddOnMetadata(**addon**, "title")](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata)
---@field static? boolean If true, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** `false`

---@class settingsPageEvents
---@field onLoad? fun(user: boolean) Called after the data of the settings widgets linked to this page has been loaded from storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
---@field onSave? fun(user: boolean) Called after the data of the settings widgets linked to this page has been committed to storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
---@field onApply? fun(user: boolean) Called after the data of the settings widgets linked to this page has been applied by calling change handlers<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
---@field onCancel? fun(user: boolean) Called after the changes are scrapped (for instance when the custom "Revert Changes" button is clicked)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
---@field onDefault? fun(user: boolean, category: boolean) Called after settings data handled by this settings page has been restored to default values (for example when the "Accept" or "These Settings" - affecting this settings category page only - is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p><p>@*param* `category` boolean — Marking whether the call is through **[*settingsCategory*].defaults(...)** or not (or example when "All Settings" have been clicked)</p>

---@class settingsPageCreationData : settingsPageCreationData_base, describableObject, settingsCategoryData, settingsPageEvents, initializableOptionsContainer, liteObject
---@field append? boolean When setting the name of the settings category page, append **t.name** after **addon** | ***Default:*** `true` if **t.name** ~= nil
---@field icon? string Path to the texture file to use as the icon of this settings page | ***Default:*** *the addon's logo specified in its TOC file with the "IconTexture" tag*
---@field titleIcon? boolean Append **t.icon** to the title of the button of the setting page in the AddOns list of the Settings window as well | ***Default:*** `true` if **t.register == true**
---@field scroll? settingsPageScrollData If set, make the canvas frame scrollable by creating a [ScrollFrame](https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame) as its child
---@field autoSave? boolean If true, automatically save the values of all widgets registered for settings data management under settings keys listed in **t.dataManagement.keys**, committing their data to storage via ***WidgetToolbox*.SaveOptionsData(...)** | ***Default:*** `true` if **t.dataManagement.keys** ~= nil<ul><li>***Note:*** If **t.dataManagement.keys** is not set, the automatic load will not be executed even if this is set to true.</li></ul>
---@field autoLoad? boolean If true, automatically load all data to the widgets registered for settings data management under settings keys listed in **t.dataManagement.keys** from storage via ***WidgetToolbox*.LoadOptionsData(...)** | ***Default:*** `true` if **t.dataManagement.keys** ~= nil<ul><li>***Note:*** If **t.dataManagement.keys** is not set, the automatic load will not be executed even if this is set to true.</li></ul>
---@field arrangement? arrangementData_settingsPage If set, arrange the content added to the container frame during initialization into stacked rows based on the specifications provided in this table

--[ Settings Category ]

---@class settingsCategoryCreationData
---@field onLoad? fun(user: boolean) Called after the data of the settings widgets linked to all pages of this settings category has been loaded from storage<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>
---@field onDefaults? fun(user: boolean) Called after settings data handled by all pages of this settings category has been restored to default values (for example when the "All Settings" option is clicked in the dialogue opened by clicking on the "Restore Defaults" button)<hr><p>@*param* `user` boolean — Marking whether the call is due to a user interaction or not</p>


--[[ WIDGETS ]]

--[ Events ]

---@class eventTag
---@field event string Custom event tag

---@class eventHandlerIndex
---@field callIndex? integer Set when to call **handler** in the execution order | ***Default:*** *placed at the end of the current list*

--[ Color Picker ]

---@alias ColorpickerType
---| colormanager
---| colorpicker

--| Events

---@alias ColorpickerEventHandler_enabled
---| fun(self: ColorpickerType, state: boolean) Called when an "enabled" event is invoked after **colorpicker.setEnabled(...)** was called<hr><p>@*param* `self` ColorPickerType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

---@alias ColorpickerEventHandler_loaded
---| fun(self: ColorpickerType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` ColorPickerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

---@alias ColorpickerEventHandler_saved
---| fun(self: ColorpickerType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` ColorPickerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

---@alias ColorpickerEventHandler_colored
---| fun(self: ColorpickerType, color: colorData, user: boolean) Called when an "colored" event is invoked after **colorpicker.setColor(...)** was called<hr><p>@*param* `self` ColorPickerType ― Reference to the toggle widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

---@alias ColorpickerEventHandler_any
---| fun(self: ColorpickerType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ColorPickerType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

--| Parameters

---@class colorpickerEventListener_enabled : eventHandlerIndex
---@field handler ColorpickerEventHandler_enabled Handler function to register for call

---@class colorpickerEventListener_loaded : eventHandlerIndex
---@field handler ColorpickerEventHandler_loaded Handler function to register for call

---@class colorpickerEventListener_saved : eventHandlerIndex
---@field handler ColorpickerEventHandler_saved Handler function to register for call

---@class colorpickerEventListener_colored : eventHandlerIndex
---@field handler ColorpickerEventHandler_colored Handler function to register for call

---@class colorpickerEventListener_any : eventTag, eventHandlerIndex
---@field handler ColorpickerEventHandler_any Handler function to register for call

---@class colorpickerEventListeners
---@field enabled? colorpickerEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **colorpicker.setEnabled(...)** was called
---@field loaded? colorpickerEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
---@field saved? colorpickerEventListener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
---@field colored? colorpickerEventListener_colored[] Ordered list of functions to call when a "colored" event is invoked after **colorpicker.setColor(...)** was called
---@field [string]? colorpickerEventListener_any[] Ordered list of functions to call when a custom event is invoked

--| Constructors

---@class colormanagerCreationData : togglableObject, settingsWidget
---@field listeners? colorpickerEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
---@field onCancel? function The function to be called when the color change is cancelled (after calling **t.onColorUpdate**)
---@field getData? fun(): color: colorData|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `color` colorData|nil | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`</p>
---@field saveData? fun(color: colorData) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `color` colorData</p>
---@field value? colorData_whiteDefault Values to use as the starting color set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid<ul><li>***Note:*** If the alpha start value was not set, configure the color picker to handle RBG values exclusively instead of the full RGBA.</li></ul>
---@field default? colorData Default value of the widget | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`

---@class colorpickerCreationData : colormanagerCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject, tooltipDescribableSettingsWidget
---@field name? string Unique string used to set the frame name | ***Default:*** "Colorpicker"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field width? number The height is defaulted to 36, the width may be specified | ***Default:*** 120
---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the color picker frame and the functions to assign as event handlers called when they trigger

--[ Data Profile Manager ]

---@alias ProfilemanagerType
---| profilemanager
---| profilesPage

--| Events

---@alias ProfilemanagerEventHandler_loaded
---| fun(self: ProfilemanagerType, user: boolean) Called when an "loaded" event is invoked after the data profile list has been loaded and verified<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

---@alias ProfilemanagerEventHandler_activated
---| fun(self: ProfilemanagerType, index: integer, title: string, success: boolean, user: boolean) Called when an "activated" event is invoked after a profile has been activated<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `index` integer — The index of the active profile</p><p>@*param* `title` string — The title of the active profile</p><p>@*param* `success` boolean ― True if the active profile was changed successfully</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

---@alias ProfilemanagerEventHandler_created
---| fun(self: ProfilemanagerType, index: integer, title: string, user: boolean) Called when an "created" event is invoked after a new data profile has been initialized<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `index` integer — The index of the new profile</p><p>@*param* `title` string — The title of the new profile</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

---@alias ProfilemanagerEventHandler_renamed
---| fun(self: ProfilemanagerType, success: boolean, index: any, title?: string, user: boolean) Called when an "renamed" event is invoked after a data profile has been renamed<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile was renamed successfully</p><p>@*param* `index` any — The index of the profile attempted to be renamed</p><p>@*param* `title`? string — The new title of the profile attempted to be renamed</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

---@alias ProfilemanagerEventHandler_deleted
---| fun(self: ProfilemanagerType, success: boolean, index: any, title?: string, user: boolean) Called when an "deleted" event is invoked after a data profile has been removed from the database<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile was deleted successfully</p><p>@*param* `index` any — The original index of the profile attempted to be deleted</p><p>@*param* `title`? string — The title of the  profile attempted to be deleted</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

---@alias ProfilemanagerEventHandler_reset
---| fun(self: ProfilemanagerType, success: boolean, index: any, title?: string, user: boolean) Called when an "reset" event is invoked after a data profile has been reset to defaults<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if the profile data was reset successfully</p><p>@*param* `index` any — The index of the profile attempted to be reset</p><p>@*param* `title`? string — The title of the profile attempted to be reset</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

---@alias ProfilemanagerEventHandler_any
---| fun(self: ProfilemanagerType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ProfilemanagerType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

--| Parameters

---@class profilemanagerEventListener_loaded : eventHandlerIndex
---@field handler ProfilemanagerEventHandler_loaded Handler function to register for call

---@class profilemanagerEventListener_activated : eventHandlerIndex
---@field handler ProfilemanagerEventHandler_activated Handler function to register for call

---@class profilemanagerEventListener_created : eventHandlerIndex
---@field handler ProfilemanagerEventHandler_created Handler function to register for call

---@class profilemanagerEventListener_renamed : eventHandlerIndex
---@field handler ProfilemanagerEventHandler_renamed Handler function to register for call

---@class profilemanagerEventListener_deleted : eventHandlerIndex
---@field handler ProfilemanagerEventHandler_deleted Handler function to register for call

---@class profilemanagerEventListener_reset : eventHandlerIndex
---@field handler ProfilemanagerEventHandler_reset Handler function to register for call

---@class profilemanagerEventListener_any : eventTag, eventHandlerIndex
---@field handler ProfilemanagerEventHandler_any Handler function to register for call

---@class profilemanagerEventListeners
---@field loaded? profilemanagerEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data profile list has been loaded and verified
---@field activated? profilemanagerEventListener_activated[] Ordered list of functions to call when an "activated" event is invoked after a profile has been activated
---@field created? profilemanagerEventListener_created[] Ordered list of functions to call when a "created" event is invoked after a new data profile has been initialized
---@field renamed? profilemanagerEventListener_renamed[] Ordered list of functions to call when a "renamed" event is invoked after a data profile has been renamed
---@field deleted? profilemanagerEventListener_deleted[] Ordered list of functions to call when a "deleted" event is invoked after a data profile has been removed from the database
---@field reset? profilemanagerEventListener_reset[] Ordered list of functions to call when a "reset" event is invoked after a data profile has been reset to defaults
---@field [string]? profilemanagerEventListener_any[] Ordered list of functions to call when a custom event is invoked


--| Parameters

---@class characterProfileData
---@field activeProfile integer The index of the currently active profile | ***Default:*** 1

---@class backupboxSettingsData
---@field compactBackup boolean Whether to skip including additional white spaces to the backup string for more readability

--| Constructors

---@class profilemanagerCreationData
---@field category? string Category name to be used for identifying this group of profile data when modified in popups and chat messages | ***Default:*** `"Addon"`
---@field valueChecker? fun(key: number|string, value: any): boolean Helper function for validating values when checking profile data, returning true if the value is to be accepted as valid
---@field recoveryMap? table<string, recoveryData>|fun(tableToCheck: table, recoveredData: recoveredData): recoveryMap: table<string, recoveryData>|nil Static map or function returning a dynamically creatable map for removed but recoverable data
---@field onRecovery? fun(tableToCheck: table) Function called after the data has been has been recovered via the **recoveryMap**
---@field listeners? profilemanagerEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

---@class profilesPageCreationData : profilemanagerCreationData, settingsPageCreationData_base, settingsPageEvents, liteObject
---@field name? string Unique string used to set the name of the canvas frame | ***Default:*** "Profiles"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
---@field title? string Text to be shown as the title of the settings page | ***Default:*** "Data Management"
---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** *describing profiles & backup*
---@field onImport? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for the currently active profile<hr><p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>
---@field onImportAllProfiles? fun(success: boolean, data: table) Called after a settings backup string import has been performed by the user loading data for all profiles<p>@*param* `success` boolean — Whether the imported string was successfully processed</p><p>@*param* `data` table — The table containing the imported backup data</p>

--[ About Page ]

---@class aboutPageCreationData : settingsPageCreationData_base
---@field description? string Text to be shown as the description below the title of the settings page | ***Default:*** [GetAddOnMetadata(**addon**, "Notes")](https://warcraft.wiki.gg/wiki/API_GetAddOnMetadata)
---@field changelog? { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included<ul><li>***Note:*** The first line is expected to be the title containing the version number and/or the date of release.</li><li>***Note:*** Version tables are expected to be listed in ascending order by date of release (latest release last).</li><li>***Examples:***<ul><li>**Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)</li><li>**Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
---@field static? boolean If true, disable the "Restore Defaults" & "Revert Changes" buttons | ***Default:*** `true`

--[ Settings Widget Panels ]

---@class settingsWidgetPanel_base
---@field canvas Frame The canvas frame child item of an existing settings category page to add the panel to
---@field dependencies? dependencyRule[] Automatically disable or enable all widgets in the new panel based on the rules described in subtables

---@class settingsWidgetPanel_frame : settingsWidgetPanel_base
---@field name? string Refer to **frame** by this display name in the tooltips and descriptions of settings widgets | ***Default:*** **frame:GetName()**

---@class settingsWidgetPanel_text : settingsWidgetPanel_base
---@field name? string Refer to **text** by this display name in the tooltips and descriptions of settings widgets | ***Default:*** **text:GetName()**

--| Position

---@class positionOptionsSettingsData
---@field keepInPlace boolean If true, don't move **frame** when changing the anchor, update the offset values instead.

---@class widgetLayerOptions
---@field strata? FrameStrata Strata to pin the frame to
---@field level? integer The level of the frame to appear in within the specified strata
---@field keepOnTop? boolean Whether to raise the frame level on mouse interaction | ***Default:*** `false`

---@class positionPresetData
---@field position positionData Table of parameters to call **frame**:[SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with
---@field keepInBounds? boolean Whether to keep the frame within screen bounds whenever it's moved | ***Default:*** `false`
---@field layer? widgetLayerOptions Table containing the screen layer parameters of the frame

---@class positionPresetItemData
---@field title string Text to represent the item within the dropdown frame
---@field tooltip? presetTooltipTextData List of text lines to be added to the tooltip of the item in the dropdown displayed when mousing over it or the menu toggle button
---@field onSelect? function The function to be called when the dropdown item is selected before the specific preset is applied
---@field data? positionPresetData Table containing the preset data to be modified by the position settings widgets and applied to **frame** on demand

---@class customPositionPresetData
---@field index? integer Index of the custom preset modifiable by the user | ***Default:*** 1
---@field getData fun(): positionPresetData Return a reference to the table within the SavedVariables(PerCharacter) addon database where the custom preset data is committed to when the custom preset is saved
---@field defaultsTable positionPresetData Reference to the table containing the default custom preset values<ul>
---@field onSave? function Called after saving the custom preset
---@field onReset? function Called after resetting the custom preset before it is applied

---@class presetItemList
---@field items positionPresetItemData[] Table containing the dropdown items described within subtables
---@field onPreset? fun(index?: integer) Called after a preset is selected and applied via the dropdown widget or by calling **applyPreset**
---@field custom? customPositionPresetData When set, add widgets to manage a user-modifiable custom preset

---@class movabilityData_positioning : movabilityData
---@field modifier? ModifierKey|any The specific (or any) modifier key required to be pressed down to move **frame** (if **frame** has the "OnUpdate" script defined) | ***Default:*** "SHIFT"<ul><li>***Note:*** Used to determine the specific modifier check to use. Example: when set to "any" [IsModifierKeyDown](https://warcraft.wiki.gg/wiki/API_IsModifierKeyDown) is used.</li></ul>

---@class settingsData_position : settingsData_base
---@field key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "Position"

---@class positionManagementCreationData : settingsWidgetPanel_frame
---@field presets? presetItemList Reference to the table containing **frame** position presets to be managed by settings widgets added when set
---@field setMovable? movabilityData_positioning When specified, set **frame** as movable, dynamically updating the position settings widgets when it's moved by the user
---@field dataManagement? settingsData_position Register the widgets to settings data management to be linked with the specified key under the specified category
---@field onChangePosition? function Function to call after the value of **panel.widgets.position.anchor**, **panel.widgets.position.relativeTo**, **panel.widgets.position.relativePoint**, **panel.widgets.position.offset.x** or **panel.widgets.position.offset.y** was changed by the user or via settings data management before the base onChange handler is called built-in to the functionality of the settings panel template updating the position of **frame**
---@field onChangeKeepInBounds? function Function to call after the value of **panel.widgets.position.keepInBounds** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **frame**
---@field onChangeStrata? function Function to call after the value of **panel.widgets.layer.strata** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **frame**
---@field onChangeLevel? function Function to call after the value of **panel.widgets.layer.level** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **frame**
---@field onChangeKeepOnTop? function Function to call after the value of **panel.widgets.layer.keepOnTop** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **frame**

--| Text font

---@class textColorInfo
---@field index? integer Ordering index of the color | ***Default:*** *unspecified*
---@field name? string Display name to set their widget and tooltip titles paired to their data management keys | ***Default:*** *data management key in Title case*

---@class textColorData_base
---@field base colorData

---@class fontOptionsData
---@field path string Path to the font file relative to the WoW client directory<ul><li>***Note:*** The use of `/` as separator is recommended (Example: Interface/AddOns/AddonNameKey/Fonts/Font.ttf), otherwise use `\\`.</li><li>***Note:*** **File format:** Font files must be in TTF or OTF format.</li></ul>
---@field size number Font size
---@field alignment JustifyHorizontal Horizontal text alignment
---@field colors table<string, colorData>|textColorData_base List of named coloring options

---@class settingsData_font : settingsData_base
---@field key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "Font"

---@class fontManagementCreationData : settingsWidgetPanel_text
---@field colors? table<string, textColorInfo> If set, use this list of specifications to set the order and displayed name of the colors | ***Default:*** *unspecified order; data management key in Title case*
---@field dataManagement? settingsData_font Register the widgets to settings data management to be linked with the specified key under the specified category
---@field onChangeFont? function Function to call after the value of **panel.widgets.path** or **panel.widgets.size** was changed by the user or via settings data management before the base onChange handler is called built-in to the functionality of the settings panel template updating the position of **text**
---@field onChangeSize? function Function to call after the value of **panel.widgets.position.keepInBounds** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **text**
---@field onChangeAlignment? function Function to call after the value of **panel.widgets.layer.strata** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **text**
---@field onChangeColor? fun(color: string) Function to call after the value of **panel.widgets.layer.level** was changed by the user or via settings data management before the base onChange handlers are called built-in to the functionality of the settings panel template updating **text**



--||| UTILITIES ||||


--[[ TABLE MANAGEMENT ]]

---Align all keys in a table to a reference table, filling missing values and removing mismatched or invalid pairs
---***
---@param targetTable table Reference to the table to get into alignment with the sample
---@param tableToSample table Reference to the table to sample keys & data from
---***
---@return table|any targetTable Reference to **targetTable** (it was already overwritten during the operation, no need for setting it again)
local function HarmonizeData(targetTable, tableToSample) end


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
local function PackPosition(anchor, relativeTo, relativePoint, offsetX, offsetY) return {} end

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
local function UnpackPosition(t) return "TOPLEFT" end

--[ Color ]

--| Verification

---Check if a variable is a valid color table
---@param t any
---@return boolean|colorData
local function IsColor(t) return false end

---Check & silently repair a color data table
---@param color any
---@return boolean|colorData
local function VerifyColor(color) return false end

--| Conversion

---Return a table constructed from color values
---***
---@param red? number Red | ***Range:*** (0, 1) | ***Default:*** 1
---@param green? number Green | ***Range:*** (0, 1) | ***Default:*** 1
---@param blue? number Blue | ***Range:*** (0, 1) | ***Default:*** 1
---@param alpha? number Opacity | ***Range:*** (0, 1) | ***Default:*** 1
---***
---@return colorData # Table containing the color values
local function PackColor(red, green, blue, alpha) return {} end

---Extract, verify and return the color values found in a table
---***
---@param color? colorData|colorRGBA Table containing the color values | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alpha? boolean Specify whether to return the full RGBA set or just the RGB values | ***Default:*** true
---***
---@return number r Red | ***Range:*** (0, 1) | ***Default:*** 1
---@return number g Green | ***Range:*** (0, 1) | ***Default:*** 1
---@return number b Blue | ***Range:*** (0, 1) | ***Default:*** 1
---@return number? a Opacity | ***Range:*** (0, 1)
local function UnpackColor(color, alpha) return 1, 1, 1 end

---Convert RGB(A) color values in Range: (0, 1) to HEX color code
---***
---@param color? colorData|colorRGBA The RGB(A) color data with all channels in Range: (0, 1) | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
---@param alphaFirst? boolean Put the alpha value first: ARGB output instead of RGBA | ***Default:*** false
---@param hashtag? boolean Whether to add a "#" to the beginning of the color description | ***Default:*** true
---***
---@return string hex Color code in HEX format<ul><li>***Examples:***<ul><li>**RGB:** "#2266BB"</li><li>**RGBA:** "#2266BBAA"</li></ul></li></ul>
local function ColorToHex(color, alphaFirst, hashtag) return "" end

---Convert a HEX color code into RGB or RGBA in Range: (0, 1)
---***
---@param hex string String in HEX color code format<ul><li>***Examples:***<ul><li>**RGB:** "#2266BB" (where the "#" is optional)</li><li>**RGBA:** "#2266BBAA" (where the "#" is optional)</li></ul></li></ul>
---***
---@return number r Red | ***Range:*** (0, 1) | ***Default:*** 1
---@return number g Green  | ***Range:*** (0, 1) | ***Default:*** 1
---@return number b Blue | ***Range:*** (0, 1) | ***Default:*** 1
---@return number? a Alpha | ***Range:*** (0, 1)
local function HexToColor(hex) return 1, 1, 1 end

---Brighten or darken the RGB values of a color by an exponent
---***
---@param color colorData|colorRGBA|any Table containing the color values
---@param exponent? number ***Default:*** 0.55<ul><li>***Note:*** Values greater than 1 darken, smaller than 1 brighten the color.</li></ul>
---***
---@return colorData|colorRGBA|any color Reference to **color** (it was already updated during the operation, no need for setting it again)
local function AdjustGamma(color, exponent) end


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
local function Texture(path, width, height, offsetX, offsetY, t) return "" end

---Remove most visual formatting (like coloring) & other (like hyperlink) [escape sequences](https://warcraft.wiki.gg/wiki/UI_escape_sequences) from a string
--- - ***Note:*** *Grammar* escape sequences are not yet supported, and will not be removed.
---@param s string
---@return string s
local function Clear(s) return "" end

---Get an assembled & fully formatted string of a specifically assembled changelog table
---***
---@param changelog { [table[]] : string[] } String arrays nested in subtables representing a version containing the raw changelog data, lines of text with formatting directives included<ul><li>***Note:*** The first line in version tables is expected to be the title containing the version number and/or the date of release.</li><li>***Note:*** Version tables are expected to be listed in descending order by date of release (latest release first).</li><li>***Examples:***<ul><li>**Title formatting - version title:** `#V_`*Title text*`_#` (*it will appear as:* • Title text)</li><li>**Color formatting - highlighted text:** `#H_`*text to be colored*`_#` (*it will be colored white*)</li><li>**Color formatting - new updates:** `#N_`*text to be colored*`_#` (*it will be colored with:* #FF66EE66)</li><li>**Color formatting - fixes:** `#F_`*text to be colored*`_#` (*it will be colored with:* #FFEE4444)</li><li>**Color formatting - changes:** `#C_`*text to be colored*`_#` (*it will be colored with:* #FF8888EE)</li><li>**Color formatting - note:** `#O_`*text to be colored*`_#` (*it will be colored with:* #FFEEEE66)</li></ul></li></ul>
---@param latest? boolean Whether to get the update notes of the latest version or the entire changelog | ***Default:*** false<ul><li>***Note:*** If true, the first line (expected to be the title containing the version number and/or release date) of the of the last version table will be omitted from the final formatted text returned, only including the update notes themselves.</li></ul>
---***
---@return string c # ***Default:*** ""
local function FormatChangelog(changelog, latest) return "" end

--[ Hyperlinks ]

---Format a clickable hyperlink text via escape sequences
---***
---@param linkType ExtendedHyperlinkType [Type of the hyperlink](https://warcraft.wiki.gg/wiki/Hyperlinks#Types) determining how it's being handled and what payload it carries
---@param content? string A colon-separated chain of parameters determined by **type** (Example: "content1:content2:content3") | ***Default:*** ""
---@param text string Clickable text to be displayed as the hyperlink
---***
---@return string # ***Default:*** ""
---<p></p>
local function Hyperlink(linkType, content, text) return "" end

---Format a custom clickable addon hyperlink text via escape sequences
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param type? string A unique key signifying the type of the hyperlink specific to the addon (if the addon handles multiple different custom types of hyperlinks) in order to be able to set unique hyperlink click handlers via ***WidgetToolbox*.SetHyperlinkHandler(...)** | ***Default:*** "-"
---@param content? string A colon-separated chain of data strings carried by the hyperlink to be provided to the handler function (Example: "content1:content2:content3") | ***Default:*** ""
---@param text string Clickable text to be displayed as the hyperlink
local function CustomHyperlink(addon, type, content, text) end

---Register a function to handle custom hyperlink clicks
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)<ul><li>***Note:*** Duplicate addon key that already had rules registered under will be overwritten.</li></ul>
---@param linkType? string Unique custom hyperlink type key used to identify the specific handler function | ***Default:*** "-"
---@param handler fun(...) Function to be called with the list of content data strings carried by the hyperlink returned one by one when clicking on a hyperlink text created via ***WidgetToolbox*.CustomHyperlink(...)**
local function SetHyperlinkHandler(addon, linkType, handler) end


--[[ WIDGET MANAGEMENT ]]

---Check if a variable is a recognizable WidgetTools custom table
---@param t any
---***
---@return boolean|AnyTypeName # Return the type name of the object if recognized, false if not
---<p></p>
local function IsWidget(t) return false end


--[[ FRAME MANAGEMENT ]]

--[ Position ]

---Set the position and anchoring of a frame when it is unknown which parameters will be nil
---***
---@param frame AnyFrameObject Reference to the frame to be moved
---@param position? positionData Table of parameters to call **frame**:[SetPoint(...)](https://warcraft.wiki.gg/wiki/API_ScriptRegionResizing_SetPoint) with | ***Default:*** "TOPLEFT"
---@param unlink? boolean If true, unlink the position of **frame** from **position.relativeTo** (preventing anchor family connections) by moving a positioning aid frame to **position** first, convert its position to absolute, breaking relative links (making it relative to screen points instead), then move **frame** to the position of the aid | ***Default:*** false
---@param userPlaced? boolean Remember the position if **frame**:[IsMovable()](https://warcraft.wiki.gg/wiki/API_Frame_IsMovable) | ***Default:*** true
local function SetPosition(frame, position, unlink, userPlaced) end

---Set the anchor of a frame while keeping its positioning by updating its relative offsets
---***
---@param frame AnyFrameObject Reference to the frame to be update
---@param anchor FramePoint New anchor point to set
---***
---@return number? offsetX The new horizontal offset value | ***Default:*** nil
---@return number? offsetY The new vertical offset value | ***Default:*** nil
---<p></p>
local function SetAnchor(frame, anchor) end

---Convert the position of a frame positioned relative to another to absolute position (making it relative to screen points, the UIParent instead)
---***
---@param frame AnyFrameObject Reference to the frame the position of which to be converted to absolute position
---@param keepAnchor? boolean If true, restore the original anchor of **frame** (as its closest anchor to the nearest screen point will be chosen after conversion) | ***Default:*** true
local function ConvertToAbsolutePosition(frame, keepAnchor) end

--| Arrangement

---Set the arrangement ordering description of a child frame by which to automatically position it in a columns within rows arrangement in its parent container via ***WidgetToolbox*.ArrangeContent(...)**
---@param frame AnyFrameObject Reference to the child frame to set the arrangement ordering description for
---@param index integer|nil If set, use this ordering index for **frame** by which to schedule placing it during arrangement (instead of relying on its child index), or if nil, delete the ordering directive set for **frame**
---@param wrap boolean|nil If true, place **frame** into a new row within its container instead of adding it to the current row being filled, or if nil, delete the wrapping directive set for **frame**<ul><li>***Note:*** If the item would not fit in the row with other items in there, it will automatically be placed in a new row.</li></ul>
---@param skip boolean|nil If true, ignore all other directives and don't include **frame** in the arrangement when positioning the children of the parent frame, or if nil, delete the skipping directive set for **frame**
local function SetArrangementDirective(frame, index, wrap, skip) end

---Arrange the child frames of a container frame into stacked rows based on the parameters provided
--- - ***Note:*** The frames will be arranged into columns based on the the number of child frames assigned to a given row, anchored to "TOPLEFT", "TOP" and "TOPRIGHT" in order (by default) up to 3 frames. Columns in rows with more frames will be attempted to be spaced out evenly between the frames placed at the main 3 anchors.
---***
---@param container Frame Reference to the parent container frame the child frames of which are to be arranged based on their arrangement descriptions
---@param t? arrangementRules Arrange the child frames of **container** based on the specifications provided in this table
local function ArrangeContent(container, t) end

--| Movability

---Set the movability of a frame based in the specified values
---***
---@param frame AnyFrameObject Reference to the frame to make movable/unmovable
---@param movable? boolean Whether to make the frame movable or unmovable | ***Default:*** false
---@param t? movabilityData When specified, set **frame** as movable, dynamically updating the position settings widgets when it's moved by the user
local function SetMovability(frame, movable, t) end

--[ Visibility ]

---Set the visibility of a frame based on the value provided
---***
---@param frame AnyFrameObject Reference to the frame to hide or show
---@param visible? boolean If false, hide the frame, show it if true | ***Default:*** false
local function SetVisibility(frame, visible) end

--[ Backdrop ]

---Set the backdrop of a frame with BackdropTemplate with the specified parameters
---***
---@param frame backdropFrame|AnyFrameObject Reference to the frame to set the backdrop of<ul><li>***Note:*** The template of **frame** must have been set as: `BackdropTemplateMixin and "BackdropTemplate"`.</li></ul>
---@param backdrop? backdropData Parameters to set the custom backdrop with | ***Default:*** nil *(remove the backdrop)*
---@param updates? backdropUpdateRule[] Table of backdrop update rules, modifying the specified parameters on trigger<ul><li>***Note:*** All update rules are additive, calling ***WidgetToolbox*.SetBackdrop(...)** multiple times with **updates** specified *will not* override previously set update rules. The base **backdrop** values used for these old rules *will not* change by setting a new backdrop via ***WidgetToolbox*.SetBackdrop(...)** either!</li></ul>
local function SetBackdrop(frame, backdrop, updates) end

--[ Dependencies ]

---Assign dependency rule listeners from a defined a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to add
---@param setState fun(state: boolean) Function to call to set the state of the frame, enabling it on a true, or disabling it on a false input
local function AddDependencies(rules, setState) end

---Check and evaluate all dependencies in a ruleset
---***
---@param rules dependencyRule[] Indexed table containing the dependency rules to check
---@return boolean? state
local function CheckDependencies(rules) end


--[[ TOOLTIP MANAGEMENT ]]

---Register tooltip data and set up a GameTooltip for a frame to be toggled on hover
---***
---@param frame AnyFrameObject Owner frame the tooltip to be registered for<ul><li>***Note:*** If tooltip data for **owner** has already been added to the registry, it will be fully overwritten with **t**.</li><ul><li>***Note:*** Duplicate triggers may still be added if **duplicate** is set to true.</li></ul></li></ul>
---@param t? tooltipData The tooltip parameters are to be provided in this table
---@param toggle? tooltipToggleData Additional toggle rule parameters are to be provided in this table
---@param duplicate? boolean If true, execute even if tooltip data has already been registered for **owner**, potentially adding duplicate toggle triggers, or, automatically call ***WidgetToolbox*.UpdateTooltipData(...)** instead to avoid this | ***Default:*** false
---***
---@return tooltipData|nil # Reference to the tooltip data table registered for **owner** to display the tooltip info by | ***Default:*** nil
local function AddTooltip(frame, t, toggle, duplicate) end

---Update and show a GameTooltip already set up to be toggled for a frame
---***
---@param frame AnyFrameObject Owner frame the tooltip to be updated for<ul><li>***Note:*** If no entry has been registered for **owner** in the tooltip data registry via ***WidgetToolbox*.AddTooltip(...)** yet, no tooltip will be shown.</li></ul>
---@param t? tooltipUpdateData|tooltipData Use this set of parameters to update the tooltip for **owner** with | ***Default:*** *(fill values from the data in the registry)*
local function UpdateTooltip(frame, t) end

---Verify and update the tooltip data values stored in the registry for a frame
---***
---@param frame AnyFrameObject Owner frame the tooltip data to be updated for<ul><li>***Note:*** If no entry has been registered for **owner** in the tooltip data registry via ***WidgetToolbox*.AddTooltip(...)** yet, no data will be changed.</li></ul>
---@param t? tooltipUpdateData|tooltipData The parameters to update the tooltip with are to be provided in this table | ***Default:*** *(fill values from the data in the registry or use default values for required values missing from the registry)*
---@param linesUpdate boolean|nil If true, replace the full set of lines in the registry with **t.lines**, or if explicitly false, append the lines to the current list of lines, or if nil or something else, adjust the values of existing lines at matching indexes instead without adding or removing lines | ***Default:*** `nil`
---***
---@return tooltipData|nil # Reference to the tooltip data table registered for **owner** to display the tooltip info by | ***Default:*** `nil`
local function UpdateTooltipData(frame, t, linesUpdate) end

---Add default value and utility menu hint tooltip lines to widget tooltip tables
---***
---@param frames AnyFrameObject[] List of reference to the frames to add the tooltip lines to<ul><li>***Note:*** If no entry has been registered for a frame in the list in the tooltip data registry via ***WidgetToolbox*.AddTooltip(...)** yet, no changes will be made for that frame.</li></ul>
---@param default? string Default value, formatted | ***Default:*** *(don't show default value)*
---@param utilityNote? boolean Is true, add a note for the utility context menu | ***Default:*** true
local function AddWidgetTooltipLines(frames, default, utilityNote) end


--[[ POPUP MANAGEMENT ]]

---Register the data for a Blizzard popup dialog for use
---***
---@param key? string Unique string to be used as the identifier key in the global `StaticPopupDialogs` table | ***Default:*** *table id of `t` or a random ID string*<ul><li>***Note:*** the default value will be appended to `key` even if its set and a valid string if that key already exist in the global `StaticPopupDialogs` table.
---@param t? popupDialogData Optional parameters
---***
---@return string key The unique identifier key the popup data was created under in the global `StaticPopupDialogs` table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
local function RegisterPopupDialog(key, t) return "" end

---Update already existing popup dialog data
---***
---@param key string The unique identifier key representing the defaults warning popup dialog in the global `StaticPopupDialogs` table, and used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide)
---@param t? popupDialogData Optional parameters
---***
---@return string? key The unique identifier key created for this popup in the global `StaticPopupDialogs` table used as the parameter when calling [StaticPopup_Show()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Show) or [StaticPopup_Hide()](https://warcraft.wiki.gg/wiki/API_StaticPopup_Hide) | ***Default:*** nil
local function UpdatePopupDialog(key, t) end


--[[ ADDON COMPARTMENT ]]

---Set up the [Addon Compartment](https://warcraft.wiki.gg/wiki/Addon_compartment#Automatic_registration) functionality by registering global functions for call
---***
---@param addon string The name of the addon's folder (the addon namespace, not its displayed title)
---@param calls? addonCompartmentFunctions Functions to call wrapped in a table<ul><li>***Note:*** `AddonCompartmentFunc`, `AddonCompartmentFuncOnEnter` and/or `AddonCompartmentFuncOnLeave` must be set in the specified **addon**'s TOC file to enable this functionality, defining the names of the global functions to be set for call.</li></ul>
---@param tooltip? addonCompartmentTooltipData|tooltipData List of text lines to be added to the tooltip of the addon compartment button displayed when mousing over it<ul><li>***Note:*** Both `AddonCompartmentFuncOnEnter` and `AddonCompartmentFuncOnLeave` must be set in the specified **addon**'s TOC file to enable this functionality, defining the names of the global functions to be overloaded.</li></ul>
local function SetUpAddonCompartment(addon, calls, tooltip) end


--[[ CHAT CONTROL ]]

---Register a list of chat keywords and related commands for use
---***
---@param addon string The name of the addon's folder (the addon namespace not the display title)
---@param keywords string[] List of addon-specific keywords to register to listen to when typed as slash commands<ul><li>***Note:*** A slash character (`/`) will appended before each keyword specified here during registration, it doesn't need to be included.</li></ul>
---@param t chatCommandManagerCreationData Optional parameters
---***
---@return chatCommandManager? manager Table containing command handler functions | ***Default:*** nil
local function RegisterChatCommands(addon, keywords, t) end


--[[ SETTINGS MANAGEMENT ]]

---Settings data management rule registry
---@class settingsRegistry
---@field rules table<string, settingsRule[]> Collection of rules describing where to save/load settings data to/from, and what change handlers to call in the process linked to each specific settings category under an addon
---@field changeHandlers table<string, function> List of pairs of addon-specific unique keys and change handler scripts

---Register the settings page to the Settings window if it wasn't already
--- - ***Note:*** No settings page will be registered if **WidgetToolsDB.lite** is true.
---@param page settingsPage Reference to the settings page to register to Settings
---@param parent? settingsPage Reference to the parent settings page to set **page** as a child category page of | ***Default:*** *set as a parent category page*
---@param icon? boolean If true, append the icon set for the settings page to its button title in the AddOns list of the Settings window as well | ***Default:*** true if **parent** == nil
local function RegisterSettingsPage(page, parent, icon) end

--| Settings data

---Register a settings data management entry for a settings widget to the settings data management registry for batched data handling
---***
---@param widget AnyWidgetType|AnyGUIWidgetType Reference to the widget to be saved & loaded data to/from with defined **widget.loadData()** & **widget.saveData()** functions
---@param t settingsData Optional parameters
---***
---@return integer|nil index The index for the new entry for **widget** where it ended up in the settings data management registry | ***Default:*** nil
local function AddSettingsDataManagementEntry(widget, t) end

---Load all data from storage to the widgets specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].loadData(...)** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
---@param handleChanges? boolean If true, also call all registered change handlers | ***Default:*** false
local function LoadSettingsData(category, key, handleChanges) end

---Save all data from the widgets to storage specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].saveData(...)** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
local function SaveSettingsData(category, key) end

---Call all **onChange** handlers registered in the settings data management registry in the specified **category** under the specified **key**
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
local function ApplySettingsData(category, key) end

---Set a data snapshot for each widget specified in the settings data management registry in the specified **category** under the specified **key** calling **[*widget*].revertData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
local function SnapshotSettingsData(category, key) end

---Set & load the stored data managed by each widget specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].revertData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
local function RevertSettingsData(category, key) end

---Set & load the default data managed by each widget specified in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].resetData()** for each
---***
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
local function ResetSettingsData(category, key) end

---Handle changes for widgets in the settings data management registry in the specified **category** under the specified **key** by calling **[*widget*].onChange()** for each
---@param index integer Filter the call of change handlers to only include the list under the specified index not each list in the specified **category** under the specified **key**
---@param category? string A unique string used for categorizing settings data management rules & change handler scripts | ***Default:*** "WidgetTools" *(global rule)*
---@param key? string A unique string appended to **category** linking a subset of settings data rules to be handled together | ***Default:*** "" *(category-wide rule)*
local function HandleWidgetChanges(index, category, key) end



--||| WIDGETS |||



--[[ ACTION ]]

---Create a non-GUI action widget
---***
---@param t? actionCreationData Optional parameters
---***
---@return action action Reference to the new action widget, utility functions and more wrapped in a table
local function CreateAction(t)

	--| Parameters

	---Optional parameters
	---@class actionCreationData : togglableObject # t
	---@field action? fun(self: action, user?: boolean) Function to call when the button is triggered (clicked by the user or triggered programmatically)<ul><li>***Note:*** This function will be called when an "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" script event happens, there's no need to register it again under **t.events.OnClick**.</li></ul><hr><p>@*param* `self` action — Reference to the widget table</p><p>@*param* `user`? boolean — Marking whether the call is due to a user interaction or not | ***Default:*** `false`</p>
	---@field listeners? actionEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger

		---@class actionEventListeners
		---@field enabled? actionEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **action.setEnabled(...)** was called
		---@field trigger? actionEventListener_trigger[] Ordered list of functions to call when a "trigger" event is invoked after **action.trigger(...)** was called
		---@field _? actionEventListener_any[] Ordered list of functions to call when a custom event is invoked

			---@class actionEventListener_enabled : eventHandlerIndex
			---@field handler ActionEventHandler_enabled Handler function to register for call

			---@class actionEventListener_trigger : eventHandlerIndex
			---@field handler ActionEventHandler_trigger Handler function to register for call

			---@class actionEventListener_any : eventTag, eventHandlerIndex
			---@field handler ActionEventHandler_any Handler function to register for call

				---@alias ActionEventHandler_enabled
				---| fun(self: ActionType, state: boolean) Called when an "enabled" event is invoked after **action.setEnabled(...)** was called<hr><p>@*param* `self` ActionType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

				---@alias ActionEventHandler_trigger
				---| fun(self: ActionType) Called when a "trigger" event is invoked after **action.trigger(...)** was called<hr><p>@*param* `self` ActionType ― Reference to the widget table</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

				---@alias ActionEventHandler_any
			---| fun(self: ActionType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ActionType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

					---@alias ActionType
					---| action
					---| actionButton
					---| customButton

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

			function invoke.enabled() end

			---@param user boolean
			function invoke.trigger(user) end

			---@param event string Custom event tag
			---@param ... any
			function invoke._(event, ...) end

		---@class action_setListener
		local setListener = {}

			---@param listener ActionEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---@param listener ActionEventHandler_trigger Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.trigger(listener, callIndex) end

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


--|| BUTTON

---Create a Blizzard button GUI frame with enhanced widget functionality
---***
---@param t? actionButtonCreationData Optional parameters
---@param action? action Reference to an already existing action manager to mutate into a button instead of creating a new base widget
---***
---@return actionButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button), utility functions and more wrapped in a table
local function CreateButton(t, action)

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


--|| CUSTOM BUTTON

---Create a Blizzard button GUI frame with customizable backdrop and enhanced widget functionality
---***
---@param t? customButtonCreationData Optional parameters
---@param action? action Reference to an already existing action button to mutate into a custom button instead of creating a new base widget
---***
---@return customButton|action # References to the new [Button](https://warcraft.wiki.gg/wiki/UIOBJECT_Button) (inheriting [BackdropTemplate](https://warcraft.wiki.gg/wiki/BackdropTemplate)), utility functions and more wrapped in a table
local function CreateCustomButton(t, action)

	--| Parameters

	--Optional parameters
	---@class customButtonCreationData : actionButtonCreationData, customizableObject # t
	---@field font? labelFontOptions_small_highlight Table of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *small default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>

	--| Returns

	---@class customButton : actionButton
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
local function CreateToggle(t)

	--| Parameters

	--Optional parameters
	---@class toggleCreationData : togglableObject, settingsWidget # t
	---@field listeners? toggleEventListeners Table of key, value pairs of custom widget event tags and functions to assign as event handlers to call on trigger
	---@field getData? fun(): state: boolean|nil Called to (if needed, modify and) load the widget data from storage<hr><p>@*return* `state` boolean|nil | ***Default:*** `false`</p>
	---@field saveData? fun(state: boolean) Called to (if needed, modify and) save the widget data to storage<hr><p>@*param* `state` boolean</p>
	---@field value? boolean The starting state of the widget to set during initialization | ***Default:*** **t.getData()** or **t.default** if invalid
	---@field default? boolean Default value of the widget | ***Default:*** `false`

		---@class toggleEventListeners
		---@field enabled? toggleEventListener_enabled[] Ordered list of functions to call when an "enabled" event is invoked after **toggle.setEnabled(...)** was called
		---@field loaded? toggleEventListener_loaded[] Ordered list of functions to call when an "loaded" event is invoked after the data of this widget has been loaded from storage
		---@field saved? toggleEventListener_saved[] Ordered list of functions to call when an "saved" event is invoked after the data of this widget has been saved to storage
		---@field toggled? toggleEventListener_toggled[] Ordered list of functions to call when an "toggled" event is invoked after **toggle.setState(...)** was called
		---@field [string]? toggleEventListener_any[] Ordered list of functions to call when a custom event is invoked

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

				---@alias ToggleEventHandler_enabled
				---| fun(self: ToggleType, state: boolean) Called when an "enabled" event is invoked after **toggle.setEnabled(...)** was called<hr><p>@*param* `self` ToggleType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

				---@alias ToggleEventHandler_loaded
				---| fun(self: ToggleType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` ToggleType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

				---@alias ToggleEventHandler_saved
				---| fun(self: ToggleType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` ToggleType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

				---@alias ToggleEventHandler_toggled
				---| fun(self: ToggleType, state: boolean, user: boolean) Called when an "toggled" event is invoked after **toggle.setState(...)** was called<hr><p>@*param* `self` ToggleType ― Reference to the toggle widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

				---@alias ToggleEventHandler_any
				---| fun(self: ToggleType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` ToggleType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

					---@alias ToggleType
					---| toggle
					---| checkbox
					---| radiobutton

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

			function invoke.enabled() end

			---@param success boolean
			function invoke.loaded(success) end

			---@param success boolean
			function invoke.saved(success) end

			---@param user boolean
			function invoke.toggled(user) end

			---@param event string Custom event tag
			---@param ... any
			function invoke._(event, ...) end

		---@class toggle_setListener
		local setListener = {}

			---@param listener ToggleEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---@param listener ToggleEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---@param listener ToggleEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---@param listener ToggleEventHandler_toggled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.toggled(listener, callIndex) end

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


--|| CHECKBOX

---Create a Blizzard checkbox GUI frame with enhanced widget functionality
---***
---@param t? checkboxCreationData Optional parameters
---@param toggle? toggle Reference to an already existing toggle to mutate into a checkbox instead of creating a new base widget
---***
---@return checkbox|toggle # References to the new [CheckButton](https://warcraft.wiki.gg/wiki/UIOBJECT_CheckButton), its holder [Frame](https://warcraft.wiki.gg/wiki/UIOBJECT_Frame), utility functions and more wrapped in a table
local function CreateCheckbox(t, toggle)

	--| Parameters

	--Optional parameters
	---@class checkboxCreationData : toggleCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject, tooltipDescribableSettingsWidget # t
	---@field name? string Unique string used to set the frame name | ***Default:*** "Toggle"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_checkbox|sizeData
	---@field font? labelFontOptions List of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object names to be used for the label | ***Default:*** *normal sized default Blizzard UI fonts*<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
	---@field events? table<ScriptButton, fun(self: checkbox, state: boolean, button?: string, down?: boolean)|fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the checkbox and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` AnyFrameObject ― Reference to the toggle frame</p><p>@*param* `state` boolean ― The checked state of the toggle frame</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** "LeftButton"</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** `false`</p></li></ul>

		---@class sizeData_checkbox
	---@field w? number Width | ***Default:*** **t.label** and 180 or **t.size.h**
	---@field h? number Height | ***Default:*** 26

	--| Returns

	---@class checkbox: toggle
	---@field frame Frame
	---@field button CheckButton|SettingsCheckboxTemplate
	---@field label FontString|nil
	local _ = {}

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


--|| CLASSIC CHECKBOX




--|| RADIO BUTTON


	--Optional parameters
	---@class radiobuttonCreationData : checkboxCreationData # t
	---@field size? sizeData_radiobutton|sizeData
	---@field clearable? boolean Whether this radio button should be clearable by right clicking on it or not | ***Default:*** `false`<ul><li>***Note:*** The radio button will be registered for "RightButtonUp" triggers to call "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" events with **button** = "RightButton".</li></ul>
	---@field events? table<ScriptButton, fun(self: radiobutton, state: boolean, button?: string, down?: boolean)|fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the radio button and the functions to assign as event handlers called when they trigger<ul><li>***Note:*** "[OnClick](https://warcraft.wiki.gg/wiki/UIHANDLER_OnClick)" will be called with custom parameters:<hr><p>@*param* `self` AnyFrameObject ― Reference to the toggle frame</p><p>@*param* `state` boolean ― The checked state of the toggle frame</p><p>@*param* `button`? string — Which button caused the click | ***Default:*** "LeftButton"</p><p>@*param* `down`? boolean — Whether the event happened on button press (down) or release (up) | ***Default:*** `false`</p></li></ul>

	---@class sizeData_radiobutton
	---@field w? number Width | ***Default:***  **t.label** and 180 or **t.size.h**
	---@field h? number Height | ***Default:*** 18



--[[ SELECTOR ]]

---Create a non-GUI selector widget (managing a collection of toggle widgets) with integer (selection index) data management logic
---***
---@param t? selectorCreationData Optional parameters
---***
---@return selector selector Reference to the new selector widget, utility functions and more wrapped in a table
local function CreateSelector(t)

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

			---@class selectorEventListener_loaded : eventHandlerIndex
			---@field handler SelectorEventHandler_loaded Handler function to register for call

			---@class selectorEventListener_saved : eventHandlerIndex
			---@field handler SelectorEventHandler_saved Handler function to register for call

			---@class selectorEventListener_selected : eventHandlerIndex
			---@field handler SelectorEventHandler_selected Handler function to register for call

			---@class selectorEventListener_updated : eventHandlerIndex
			---@field handler SelectorEventHandler_updated Handler function to register for call

			---@class selectorEventListener_added : eventHandlerIndex
			---@field handler SelectorEventHandler_updated Handler function to register for call

			---@class selectorEventListener_any : eventTag, eventHandlerIndex
			---@field handler SelectorEventHandler_any Handler function to register for call

				---@alias SelectorEventHandler_enabled
				---| fun(self: SelectorType, state: boolean) Called when an "enabled" event is invoked after **selector.setEnabled(...)** was called<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

				---@alias SelectorEventHandler_loaded
				---| fun(self: SelectorType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

				---@alias SelectorEventHandler_saved
				---| fun(self: SelectorType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

				---@alias SelectorEventHandler_selected
				---| fun(self: SelectorType, selected?: integer, user: boolean) Called when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `selected` integer ― The index of the currently selected item</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

				---@alias SelectorEventHandler_updated
				---| fun(self: SelectorType) Called when an "updated" event is invoked after **selector.updatedItems(...)** was called<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p>

				---@alias SelectorEventHandler_added
				---| fun(self: SelectorType, toggle: toggle) Called when a new toggle item is added to the selector via **selector.updatedItems(...)**<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `toggle` toggle ― Reference to the toggle widget added to the selector</p>

				---@alias SelectorEventHandler_any
				---| fun(self: SelectorType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` SelectorType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

					---@alias SelectorType
					---| selector
					---| radiogroup
					---| dropdownRadiogroup

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

			function invoke.enabled() end

			---@param success boolean
			function invoke.loaded(success) end

			---@param success boolean
			function invoke.saved(success) end

			---@param user boolean
			function invoke.selected(user) end

			function invoke.updated() end

			function invoke.added(toggle) end

			---@param event string Custom event tag
			---@param ... any
			function invoke._(event, ...) end

		---@class selector_setListener
		local setListener = {}

			---@param listener SelectorEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---@param listener SelectorEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---@param listener SelectorEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---@param listener SelectorEventHandler_selected Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.selected(listener, callIndex) end

			---@param listener SelectorEventHandler_updated Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.updated(listener, callIndex) end

			---@param listener SelectorEventHandler_added Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.added(listener, callIndex) end

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


--|| SPECIAL SELECTOR

---Create a non-GUI special selector widget (managing a collection of toggle widgets) with data management logic specific to the specified **itemset**
---***
---@param itemset SpecialSelectorItemset Specify what type of selector should be created
---@param t? specialSelectorCreationData Optional parameters
---***
---@return specialSelector specialSelector Reference to the new selector widget, utility functions and more wrapped in a table
local function CreateSpecialSelector(itemset, t)

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

			---@class specialSelectorEventListener_loaded : eventHandlerIndex
			---@field handler SpecialSelectorEventHandler_loaded Handler function to register for call

			---@class specialSelectorEventListener_saved : eventHandlerIndex
			---@field handler SpecialSelectorEventHandler_saved Handler function to register for call

			---@class specialSelectorEventListener_selected : eventHandlerIndex
			---@field handler SpecialSelectorEventHandler_selected Handler function to register for call

			---@class specialSelectorEventListener_any : eventTag, eventHandlerIndex
			---@field handler SpecialSelectorEventHandler_any Handler function to register for call

				---@alias SpecialSelectorEventHandler_enabled
				---| fun(self: SpecialSelectorType, state: boolean) Called when an "enabled" event is invoked after **selector.setEnabled(...)** was called<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

				---@alias SpecialSelectorEventHandler_loaded
				---| fun(self: SpecialSelectorType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

				---@alias SpecialSelectorEventHandler_saved
				---| fun(self: SpecialSelectorType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

				---@alias SpecialSelectorEventHandler_selected
				---| fun(self: SpecialSelectorType, selected?: FramePoint|JustifyHorizontal|JustifyVertical|FrameStrata, user: boolean) Called when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared<hr><p>@*param* `self` SelectorType ― Reference to the selector widget</p><p>@*param* `selected` AnchorPoint|JustifyH|JustifyV|FrameStrata ― The currently selected value</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

				---@alias SpecialSelectorEventHandler_any
				---| fun(self: SpecialSelectorType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` SpecialSelectorType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

					---@alias SpecialSelectorType
					---| selector
					---| specialSelector

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

			function invoke.enabled() end

			---@param success boolean
			function invoke.loaded(success) end

			---@param success boolean
			function invoke.saved(success) end

			---@param user boolean
			function invoke.selected(user) end

			---@param event string Custom event tag
			---@param ... any
			function invoke._(event, ...) end

		---@class specialSelector_setListener
		local setListener = {}

			---@param listener SpecialSelectorEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---@param listener SpecialSelectorEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---@param listener SpecialSelectorEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---@param listener SpecialSelectorEventHandler_selected Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.selected(listener, callIndex) end

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


--|| MULTISELECTOR

---Create a non-GUI multiselector widget (managing a collection of toggle widgets) with boolean mask data management logic
---***
---@param t? multiselectorCreationData Optional parameters
---***
---@return multiselector multiselector Reference to the new multiselector widget, utility functions and more wrapped in a table
local function CreateMultiselector(t)

	--| Parameters

	--Optional parameters
	---@class multiselectorCreationData : togglableObject, settingsWidget
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

			---@class multiselectorEventListener_loaded : eventHandlerIndex
			---@field handler MultiselectorEventHandler_loaded Handler function to register for call

			---@class multiselectorEventListener_saved : eventHandlerIndex
			---@field handler MultiselectorEventHandler_saved Handler function to register for call

			---@class multiselectorEventListener_selected : eventHandlerIndex
			---@field handler MultiselectorEventHandler_selected Handler function to register for call

			---@class multiselectorEventListener_updated : eventHandlerIndex
			---@field handler MultiselectorEventHandler_updated Handler function to register for call

			---@class multiselectorEventListener_added : eventHandlerIndex
			---@field handler MultiselectorEventHandler_added Handler function to register for call

			---@class multiselectorEventListener_limited : eventHandlerIndex
			---@field handler MultiselectorEventHandler_limited Handler function to register for call

			---@class multiselectorEventListener_any : eventTag, eventHandlerIndex
	---@field handler MultiselectorEventHandler_any Handler function to register for call

				---@alias MultiselectorEventHandler_enabled
				---| fun(self: MultiselectorType, state: boolean) Called when an "enabled" event is invoked after **selector.setEnabled(...)** was called<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

				---@alias MultiselectorEventHandler_loaded
				---| fun(self: MultiselectorType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

				---@alias MultiselectorEventHandler_saved
				---| fun(self: MultiselectorType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

				---@alias MultiselectorEventHandler_selected
				---| fun(self: MultiselectorType, selections: boolean[], user: boolean) Called when an "selected" event is invoked after **selector.setSelected(...)** was called or an option was clicked or cleared<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `selections` boolean[] ― Indexed list of the current item states</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

				---@alias MultiselectorEventHandler_updated
				---| fun(self: MultiselectorType) Called when an "updated" event is invoked after **selector.updatedItems(...)** was called<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p>

				---@alias MultiselectorEventHandler_added
				---| fun(self: MultiselectorType, toggle: toggle) Called when a new toggle item is added to the selector via **selector.updatedItems(...)**<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `toggle` toggle ― Reference to the toggle widget added to the selector</p>

				---@alias MultiselectorEventHandler_limited
				---| fun(self: MultiselectorType, min: boolean, max: boolean, passed: boolean) Called when a "limited" event is invoked after a limit update occurs<hr><p>@*param* `self` MultiselectorType ― Reference to the selector widget</p><p>@*param* `min` boolean ― True, if the number of selected items is equal to lower than the specified lower limit</p><p>@*param* `max` boolean ― True, if the number of selected items is equal to higher than the specified upper limit</p><p>@*param* `passed` boolean ― True, if the number of selected items is below or over the specified lower or upper limit</p>

				---@alias MultiselectorEventHandler_any
				---| fun(self: MultiselectorType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` MultiselectorType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

					---@alias MultiselectorType
					---| multiselector
					---| checkgroup

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

			function invoke.enabled() end

			---@param success boolean
			function invoke.loaded(success) end

			---@param success boolean
			function invoke.saved(success) end

			---@param user boolean
			function invoke.selected(user) end

			function invoke.updated() end

			function invoke.added(toggle) end

			---@param count integer
			function invoke.limited(count) end

			---@param event string Custom event tag
			---@param ... any
			function invoke._(event, ...) end

		---@class multiselector_setListener
		local setListener = {}

			---@param listener MultiselectorEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---@param listener MultiselectorEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---@param listener MultiselectorEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---@param listener MultiselectorEventHandler_selected Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.selected(listener, callIndex) end

			---@param listener MultiselectorEventHandler_updated Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.updated(listener, callIndex) end

			---@param listener SelectorEventHandler_added Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.added(listener, callIndex) end

			---@param listener MultiselectorEventHandler_limited Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.limited(listener, callIndex) end

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





	---@class selectorFrameCreationData : labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject
	---@field name? string Unique string used to set the frame name | ***Default:*** "Selector"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field events? table<ScriptFrame, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the selector frame and the functions to assign as event handlers called when they trigger

	---@class radiogroupCreationData_base : tooltipDescribableSettingsWidget
	---@field clearable? boolean If true, the selector input should be clearable by right clicking on its radio buttons, setting the selected value to nil | ***Default:*** `false`

	---@class radiogroupCreationData : selectorCreationData, selectorFrameCreationData, radiogroupCreationData_base
	---@field width? number The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 180 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to **t.width** if **t.columns** is 1 and **t.width** is specified.</li></ul>
	---@field items? (selectorItem|selectorRadiobutton)[] Table containing subtables with data used to create item widgets, or already existing radio buttons
	---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1
	---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** `true`

	---@class specialRadiogroupCreationData : specialSelectorCreationData, selectorFrameCreationData, radiogroupCreationData_base

	---@class checkgroupCreationData : multiselectorCreationData, selectorFrameCreationData, tooltipDescribableSettingsWidget
	---@field width? number The height is dynamically set to fit all items (and the title if set), the width may be specified | ***Default:*** *dynamically set to fit all columns of items* or **t.label** and 160 or 0 *(whichever is greater)*<ul><li>***Note:*** The width of each individual item will be set to **t.width** if **t.columns** is 1 and **t.width** is specified.</li></ul>
	---@field items? (selectorItem|selectorCheckbox)[] Table containing subtables with data used to create item widgets, or already existing checkboxes
	---@field labels? boolean Whether or not to add the labels to the right of each newly created widget item | ***Default:*** `true`
	---@field columns? integer Arrange the newly created widget items in a grid with the specified number of columns instead of a vertical list | ***Default:*** 1

	---@class dropdownRadiogroupCreationData : radiogroupCreationData, widgetWidthValue, tooltipDescribableSettingsWidget
	---@field name? string Unique string used to set the frame name | ***Default:*** "Dropdown"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field width? number The width of the dropdown frame containing the toggle (and optionally) cycle buttons and the label (if **t.label** is true) | ***Default:*** 180
	---@field scrollThreshold? integer Number of items to show before changing the dropdown menu to be scrollable | ***Default:*** 15<ul><li>***Note:*** Scrollability does not change when the number of items change after the initial setup.</li></ul>
	---@field text? string The default text to display on the dropdown when no item is selected | ***Default:*** ""
	---@field clearable? boolean If true, the selector input should be clearable by right clicking on its radio buttons, or, if **t.utilityMenu** is false, the dropdown toggle button itself (if true, a clear selection option is added to the utility menu instead), setting the selected value to nil | ***Default:*** `false`
	---@field autoClose? boolean Close the dropdown menu after an item is selected by the user | ***Default:*** `true`
	---@field cycleButtons? boolean Add previous & next item buttons next to the dropdown | ***Default:*** `true`





--[[ TEXTBOX ]]

---Create a non-GUI textbox widget with string data management logic
---***
---@param t? textboxCreationData Optional parameters
---***
---@return textbox textbox Reference to the new textbox widget, utility functions and more wrapped in a table
local function CreateTextbox(t)

	--| Parameters

	--Optional parameters
	---@class textboxCreationData : togglableObject, settingsWidget
	---@field color? colorData Apply the specified color to all text in the editbox (overriding all font objects set in **t.font**)
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

			---@class textboxEventListener_loaded : eventHandlerIndex
			---@field handler TextboxEventHandler_loaded Handler function to register for call

			---@class textboxEventListener_saved : eventHandlerIndex
			---@field handler TextboxEventHandler_saved Handler function to register for call

			---@class textboxEventListener_changed : eventHandlerIndex
			---@field handler TextboxEventHandler_changed Handler function to register for call

			---@class textboxEventListener_any : eventTag, eventHandlerIndex
			---@field handler TextboxEventHandler_any Handler function to register for call

				---@alias TextboxEventHandler_enabled
				---| fun(self: TextboxType, state: boolean) Called when an "enabled" event is invoked after **textbox.setEnabled(...)** was called<hr><p>@*param* `self` TextboxType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

				---@alias TextboxEventHandler_loaded
				---| fun(self: TextboxType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` TextboxType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

				---@alias TextboxEventHandler_saved
				---| fun(self: TextboxType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` TextboxType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

				---@alias TextboxEventHandler_changed
				---| fun(self: TextboxType, text: string, user: boolean) Called when an "changed" event is invoked after **textbox.setText(...)** was called<hr><p>@*param* `self` TextboxType ― Reference to the toggle widget</p><p>@*param* `text` string ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

				---@alias TextboxEventHandler_any
				---| fun(self: TextboxType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` TextboxType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

					---@alias TextboxType
					---| textbox
					---| customEditbox
					---| customEditbox
					---| multilineEditbox

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

			function invoke.enabled() end

			---@param success boolean
			function invoke.loaded(success) end

			---@param success boolean
			function invoke.saved(success) end

			---@param user boolean
			function invoke.changed(user) end

			---@param event string Custom event tag
			---@param ... any
			function invoke._(event, ...) end

		---@class textbox_setListener
		local setListener = {}

			---@param listener TextboxEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---@param listener TextboxEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---@param listener TextboxEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---@param listener TextboxEventHandler_changed Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(listener, callIndex) end

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



	---@class editboxCreationData : textboxCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject, tooltipDescribableSettingsWidget
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

	---@class customEditboxCreationData : editboxCreationData, customizableObject

	---@class multilineEditboxCreationData : editboxCreationData, scrollSpeedData
	---@field size? sizeData
	---@field charCount? boolean Show or hide the remaining number of characters | ***Default:*** **t.charLimit** > 0
	---@field scrollToTop? boolean Automatically scroll to the top when the text is loaded or changed while not being actively edited | ***Default:*** `false`
	---@field scrollEvents? table<ScriptScrollFrame, fun(...: any)> Table of key, value pairs of the names of script event handlers to be set for the scroll frame of the editbox and the functions to assign as event handlers called when they trigger

	---@class copyboxCreationData : labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, visibleObject_base, liteObject
	---@field name? string Unique string used to set the frame name | ***Default:*** "Copybox"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field size? sizeData_editbox|sizeData
	---@field layer? DrawLayer
	---@field font? string Name of the [FontObject](https://warcraft.wiki.gg/wiki/UIOBJECT_Font#List_of_Font_Objects) object to be used for the [FontString](https://warcraft.wiki.gg/wiki/UIOBJECT_FontString) | ***Default:*** "GameFontNormalSmall"<ul><li>***Note:*** A new font object (or a modified copy of an existing one) can be created via ***WidgetToolbox*.CreateFont(...)** (even within this table definition).</li></ul>
	---@field color? colorData Apply the specified color to the text (overriding **t.font**)
	---@field justify? JustifyHorizontal Set the horizontal text alignment of the label (overriding **t.font**) | ***Default:*** "LEFT"
	---@field flipOnMouse? boolean Hide/Reveal the editbox on mouseover instead of after a click | ***Default:*** `false`
	---@field colorOnMouse? colorData If set, change the color of the text on mouseover to the specified color (if **t.flipOnMouse** is false) | ***Default:*** *no color change*
	---@field value? string The copyable text to be shown | ***Default:*** `""`




--[[ NUMERIC ]]

--[ Constructor ]

---Create a non-GUI numeric widget with number data management logic
---***
---@param t? numericCreationData Optional parameters
---***
---@return numeric numeric Reference to the new numeric widget, utility functions and more wrapped in a table
local function CreateNumeric(t)

	--| Parameters

	--Optional parameters
	---@class numericCreationData : togglableObject, settingsWidget
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

				---@alias NumericEventHandler_enabled
				---| fun(self: NumericType, state: boolean) Called when an "enabled" event is invoked after **numeric.setEnabled(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the widget table</p><p>@*param* `state` boolean ― True if the widget is enabled</p>

				---@alias NumericEventHandler_loaded
				---| fun(self: NumericType, success: boolean) Called when an "loaded" event is invoked after the data of this widget has been loaded from storage<hr><p>@*param* `self` NumericType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was returned by **t.getData()** and it was loaded to the widget</p>

				---@alias NumericEventHandler_saved
				---| fun(self: NumericType, success: boolean) Called when an "saved" event is invoked after the data of this widget has been saved to storage<hr><p>@*param* `self` NumericType ― Reference to the widget table</p><p>@*param* `success` boolean ― True if data was committed successfully via **t.saveData(...)**</p>

				---@alias NumericEventHandler_changed
				---| fun(self: NumericType, number: number, user: boolean) Called when an "changed" event is invoked after **numeric.setNumber(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the toggle widget</p><p>@*param* `number` number ― The current value of the widget</p><p>@*param* `user` boolean ― True if the event was flagged as invoked by an action taken by the user</p>

				---@alias NumericEventHandler_min
				---| fun(self: NumericType, limitMin: number) Called when an "min" event is invoked after **numeric.setMin(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the toggle widget</p><p>@*param* `limitMin` number ― The current lower limit of the number value of the widget</p>

				---@alias NumericEventHandler_max
				---| fun(self: NumericType, limitMax: number) Called when an "max" event is invoked after **numeric.setMax(...)** was called<hr><p>@*param* `self` NumericType ― Reference to the toggle widget</p><p>@*param* `limitMax` number ― The current upper limit of the number value of the widget</p>

				---@alias NumericEventHandler_any
				---| fun(self: NumericType, ...: any) Called when a custom event is invoked<hr><p>@*param* `self` NumericType ― Reference to the widget table</p><p>@*param* `...` any — Any leftover arguments</p>

					---@alias NumericType
				---| numeric
				---| customSlider

	--| Returns

	---@class numeric
	---@field invoke textbox_invoke Get a trigger function to call all registered listeners for the specified custom widget event with
	---@field setListener textbox_setListener Hook a handler function as a listener for a custom widget event
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

		---@class textbox_invoke
		local invoke = {}

			function invoke.enabled()  end

			---@param success boolean
			function invoke.loaded(success) end

			---@param success boolean
			function invoke.saved(success) end

			---@param user boolean
			function invoke.changed(user) end

			function invoke.min() end

			function invoke.max() end

			---@param event string Custom event tag
			---@param ... any
			function invoke._(event, ...) end

		---@class textbox_setListener
		local setListener = {}

			---@param listener NumericEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---@param listener NumericEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---@param listener NumericEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---@param listener NumericEventHandler_changed Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.changed(listener, callIndex) end

			---@param listener NumericEventHandler_min Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.min(listener, callIndex) end

			---@param listener NumericEventHandler_max Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.max(listener, callIndex) end

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


	---@class sliderCreationData : numericCreationData, labeledChildObject, tooltipDescribableWidget, arrangeableObject, positionableObject, widgetWidthValue, visibleObject_base, liteObject, tooltipDescribableSettingsWidget
	---@field name? string Unique string used to set the frame name | ***Default:*** "Slider"<ul><li>***Note:*** Space characters will be removed when used for setting the frame name.</li></ul>
	---@field valuebox? boolean Whether or not should the slider have an [EditBox](https://warcraft.wiki.gg/wiki/UIOBJECT_EditBox) as a child to manually enter a precise value to move the slider to | ***Default:*** `true`
	---@field events? table<ScriptSlider, fun(...: any)|attributeEventData> Table of key, value pairs of the names of script event handlers to be set for the slider frame and the functions to assign as event handlers called when they trigger<ul><li>***Example:*** "[OnValueChanged](https://warcraft.wiki.gg/wiki/UIHANDLER_OnValueChanged)" whenever the value in the slider widget is modified.</li></ul>

	---@class classicSliderCreationData : sliderCreationData
	---@field sideButtons? boolean Whether or not to add increase/decrease buttons next to the slider to change the value by the increment set in **t.step** | ***Default:*** `true`



--[[ COLOR DATA ]]

--[ Constructor ]

---Create a non-GUI color pick manager widget with color data management logic
---***
---@param t? colormanagerCreationData Optional parameters
---***
---@return colormanager colorer Reference to the new color pick manager widget, utility functions and more wrapped in a table
local function CreateColormanager(t)

	--| Parameters



	--| Returns

	---@class colormanager
	---@field button action Trigger to open the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) with
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

			function invoke.enabled() end

			---@param success boolean
			function invoke.loaded(success) end

			---@param success boolean
			function invoke.saved(success) end

			---@param user boolean
			function invoke.colored(user) end

			---@param event string Custom event tag
			---@param ... any
			function invoke._(event, ...) end

		---@class colormanager_setListener
		local setListener = {}

			---@param listener ColorpickerEventHandler_enabled Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.enabled(listener, callIndex) end

			---@param listener ColorpickerEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---@param listener ColorpickerEventHandler_saved Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.saved(listener, callIndex) end

			---@param listener ColorpickerEventHandler_colored Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.colored(listener, callIndex) end

			---@param event string Custom event tag
			---@param listener ColorpickerEventHandler_any Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener._(event, listener, callIndex) end

		---Read the data from storage then verify and load it to the widget
		---***
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke a "loaded" event and call registered listeners | ***Default:*** `false`
		function _.loadData(handleChanges, silent) end

		---Verify and save the provided data or the current value of the widget to storage via **t.saveData(...)**
		---***
		---@param color? colorData|colorRGBA Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param silent? boolean If false, invoke a "saved" event and call registered listeners | ***Default:*** `false`
		function _.saveData(color, silent) end

		---Get the currently stored data via **t.getData()**
		---@return colorData|nil
		function _.getData() end

		---Verify and save the provided data to storage via **t.saveData(...)** then load it to the widget via **t.loadData()**
		---***
		---@param color? colorData|colorRGBA Data to be saved | ***Default:*** *the currently set value of the widget*
		---@param handleChanges? boolean If true, call the specified **t.onChange** handlers | ***Default:*** `true`
		---@param silent? boolean If false, invoke "loaded" and "saved" events and call registered listeners | ***Default:*** `false`
		function _.setData(color, handleChanges, silent) end

		---Get the currently set default value
		---@return colorData default
		function _.getDefault() return {} end

		---Set the default value
		---@param color? colorData | ***Default:*** *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
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
		---@return colorData
		function _.getColor() return {} end

		---Set the managed color values
		---***
		---@param color? colorData|colorRGBA ***Default:*** { r = 1, g = 1, b = 1, a = 1 } *opaque white:* `{ r = 1, g = 1, b = 1, a = 1 }`
		---@param user? boolean If true, mark the call as being the result of a user interaction | ***Default:*** `false`
		---@param silent? boolean If false, invoke a "colored" event and call registered listeners | ***Default:*** `false`
		function _.setColor(color, user, silent) end

		---Open the the default Blizzard Color Picker wheel ([ColorPickerFrame](https://warcraft.wiki.gg/wiki/Using_the_ColorPickerFrame)) for this color picker
		function _.openColorPicker() end

		---Return the active status of this color picker, whether the main color wheel window was opened for and is currently updating the color of this widget
		---@return boolean active True, if the color wheel has been opened for this color picker widget
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


--[[ PROFILE DATA ]]

--[ Constructor ]

---Create a non-GUI profile data manager widget with live database management and profile selection logic
---***
---@param accountData profileStorage|table Reference to the account-bound SavedVariables addon database where profile data is to be stored<ul><li>***Note:*** A subtable will be created under the key `profiles` if it doesn't already exist, any other keys will be removed (any possible old data will be recovered and incorporated into the active profile data).</li></ul>
---@param characterData characterProfileData|table Reference to the character-specific SavedVariablesPerCharacter addon database where selected profiles are to be specified<ul><li>***Note:*** An integer value will be created under the key `activeProfile` if it doesn't already exist in this table.</li></ul>
---@param defaultData table A static table containing all default settings values to be cloned when creating a new profile or resetting one
---@param t? profilemanagerCreationData Optional parameters
---***
---@return profilemanager? profilemanager Reference to the new profile data manager widget, utility functions and more wrapped in a table | ***Default:*** nil
local function CreateProfilemanager(accountData, characterData, defaultData, t)

	--| Parameters



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

			---@param user boolean
			function invoke.loaded(user) end

			---@param success boolean
			---@param user boolean
			function invoke.activated(success, user) end

			---@param index integer
			---@param title string
			---@param user boolean
			function invoke.created(index, title, user) end

			---@param success boolean
			---@param user boolean
			---@param index any
			---@param title? string
			function invoke.renamed(success, user, index, title) end

			---@param success boolean
			---@param user boolean
			---@param index any
			---@param title? string
			function invoke.deleted(success, user, index, title) end

			---@param success boolean
			---@param user boolean
			---@param index any
			---@param title? string
			function invoke.reset(success, user, index, title) end

			---@param event string Custom event tag
			---@param ... any
			function invoke._(event, ...) end

		---@class profilemanager_setListener
		local setListener = {}

			---@param listener ProfilemanagerEventHandler_loaded Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.loaded(listener, callIndex) end

			---@param listener ProfilemanagerEventHandler_activated Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.activated(listener, callIndex) end

			---@param listener ProfilemanagerEventHandler_created Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.created(listener, callIndex) end

			---@param listener ProfilemanagerEventHandler_renamed Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.renamed(listener, callIndex) end

			---@param listener ProfilemanagerEventHandler_deleted Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.deleted(listener, callIndex) end

			---@param listener ProfilemanagerEventHandler_reset Handler function to set
			---@param callIndex? integer Set when to call **listener** in the execution order | ***Default:*** *placed at the end of the current list*
			function setListener.reset(listener, callIndex) end

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


--||| TOOLBOX |||


---Read-only reference to the Widget Toolbox table
---@class widgetToolbox
---@field clipboard clipboard Value clipboard
local toolbox = {

	--[ Utilities ]

	HarmonizeData = HarmonizeData,
	PackPosition = PackPosition,
	UnpackPosition = UnpackPosition,
	IsColor = IsColor,
	VerifyColor = VerifyColor,
	PackColor = PackColor,
	UnpackColor = UnpackColor,
	ColorToHex = ColorToHex,
	HexToColor = HexToColor,
	AdjustGamma = AdjustGamma,
	Texture = Texture,
	Clear = Clear,
	FormatChangelog = FormatChangelog,
	Hyperlink = Hyperlink,
	CustomHyperlink = CustomHyperlink,
	SetHyperlinkHandler = SetHyperlinkHandler,
	IsWidget = IsWidget,
	SetPosition = SetPosition,
	SetAnchor = SetAnchor,
	ConvertToAbsolutePosition = ConvertToAbsolutePosition,
	SetArrangementDirective = SetArrangementDirective,
	ArrangeContent = ArrangeContent,
	SetMovability = SetMovability,
	SetVisibility = SetVisibility,
	SetBackdrop = SetBackdrop,
	AddDependencies = AddDependencies,
	CheckDependencies = CheckDependencies,
	AddTooltip = AddTooltip,
	UpdateTooltip = UpdateTooltip,
	UpdateTooltipData = UpdateTooltipData,
	AddWidgetTooltipLines = AddWidgetTooltipLines,
	RegisterPopupDialog = RegisterPopupDialog,
	UpdatePopupDialog = UpdatePopupDialog,
	SetUpAddonCompartment = SetUpAddonCompartment,
	RegisterChatCommands = RegisterChatCommands,
	RegisterSettingsPage = RegisterSettingsPage,
	AddSettingsDataManagementEntry = AddSettingsDataManagementEntry,
	LoadSettingsData = LoadSettingsData,
	SaveSettingsData = SaveSettingsData,
	ApplySettingsData = ApplySettingsData,
	SnapshotSettingsData = SnapshotSettingsData,
	RevertSettingsData = RevertSettingsData,
	ResetSettingsData = ResetSettingsData,
	HandleWidgetChanges = HandleWidgetChanges,

	--[ Widgets ]

	CreateAction = CreateAction,
	CreateToggle = CreateToggle,
	CreateSelector = CreateSelector,
	CreateSpecialSelector = CreateSpecialSelector,
	CreateMultiselector = CreateMultiselector,
	CreateTextbox = CreateTextbox,
	CreateNumeric = CreateNumeric,
	CreateColormanager = CreateColormanager,
	CreateProfilemanager = CreateProfilemanager,

	--[ Frames ]

	CreateButton = CreateButton,
	CreateCustomButton = CreateCustomButton,
	CreateCheckbox = CreateCheckbox,
}

	--Widget data clipboard
	---@class clipboard
	---@field toggle boolean|nil Toggle value
	---@field selection wrappedInteger|nil Selector index
	---@field selections wrappedBooleanArray|nil Multiselector data
	---@field anchor wrappedAnchor|nil Frame Anchor Point
	---@field justifyH wrappedJustifyH|nil Horizontal text alignment value
	---@field justifyV wrappedJustifyV|nil Vertical text alignment value
	---@field strata wrappedStrata|nil Frame Strata value
	---@field text string|nil Text value
	---@field numeric number|nil Number value
	---@field color colorData|nil RGB(A) color value
