local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 5)
local tbl = {}
local tbl2 = {}
local tbl3 = {}
local obj = setmetatable({}, { __mode = "k" })
local v = nil
local flag = false
local str = "EN"
local flag2 = false
local str2 = nil

local tbl4 = {
	EN = {
		SelectLang = "Select Language",
		Se = "Selected: ",
		NS = "SAVED",
		NL = "LOADED",
		NR = "RESET",
		NN = "NO DATA",
		Title = "AXIN",
		Author = "REGRET",
		Tab = "Editor",
		Section = "Editor",
		EditMode = "EDIT MODE",
		EditModeDesc = "Click & drag any button to move it",
		Language = "Language",
		Up = "UP",
		Down = "DOWN",
		Left = "LEFT",
		Right = "RIGHT",
		Size = "Element Size",
		SizeDesc = "Adjust selected element size (pixels)",
		Big = "BIG",
		Small = "SMALL",
		Save = "SAVE",
		Load = "LOAD",
		Reset = "RESET",
		NotifyTitle = "AXIN",
	},
	ZH = {
		SelectLang = "请选择语言",
		Se = "选中: ",
		NS = "已保存",
		NL = "已读取",
		NR = "已重置",
		NN = "无数据",
		Title = "AXIN",
		Author = "REGRET",
		Tab = "编辑器",
		Section = "编辑器",
		EditMode = "编辑模式",
		EditModeDesc = "点击并拖动任意按钮移动",
		Language = "语言",
		Up = "上",
		Down = "下",
		Left = "左",
		Right = "右",
		Size = "元素大小",
		SizeDesc = "",
		Big = "放大",
		Small = "缩小",
		Save = "保存",
		Load = "读取",
		Reset = "重置",
		NotifyTitle = "AXIN",
	},
}

local function fn(arg)
	return tbl4[str][arg]
end

local function fn2()
	if not isfile or not isfile("AX.json") then
		return false
	end
	local ok, result = pcall(readfile, "AX.json")
	if not ok or not result or result == "" then
		return false
	end
	local ok2, result2 = pcall(HttpService.JSONDecode, HttpService, result)
	if ok2 and result2 then
		tbl = result2
		return true
	end
	return false
end

local function fn3()
	if not writefile then
		return
	end
	local ok, result = pcall(HttpService.JSONEncode, HttpService, tbl)

	if ok then
		pcall(writefile, "AX.json", result)
	end
end

local function fn4(arg)
	local parent = arg.Parent
	local n = 0

	if parent then
		for _, child in ipairs(parent:GetChildren()) do
			if child ~= arg then
				if child.Name == arg.Name then
					n += 1
				end

				continue
			end

			break
		end
	end

	return (parent and parent.Name or "X") .. "_" .. arg.Name .. "_" .. n
end

local function fn5(arg, arg2)
	local udim2 = UDim2.new(arg2.Pos[1], arg2.Pos[2], arg2.Pos[3], arg2.Pos[4])
	local udim22 = UDim2.new(arg2.Size[1], arg2.Size[2], arg2.Size[3], arg2.Size[4])

	if arg.Position ~= udim2 then
		arg.Position = udim2
	end

	if arg.Size ~= udim22 then
		arg.Size = udim22
	end
end

local function fn6()
	if not v then
		return
	end

	local tbl5 = {
		Pos = { v.Position.X.Scale, v.Position.X.Offset, v.Position.Y.Scale, v.Position.Y.Offset },
		Size = { v.Size.X.Scale, v.Size.X.Offset, v.Size.Y.Scale, v.Size.Y.Offset },
	}

	tbl[fn4(v)] = tbl5
end

local v2 = nil
local mouseLocation = nil
local position = nil
local connection = nil

local function fn7()
	if not v2 then
		return
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	fn6()
	v2.Active = true
	v2 = nil
	mouseLocation = nil
	position = nil
end

UserInputService.InputEnded:Connect(function(input)
	if not v2 then
		return
	end
	local userInputType = input.UserInputType

	if userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.Touch then
		fn7()
	end
end)

local function fn8(arg)
	if not arg:IsA("GuiButton") or obj[arg] then
		return
	end
	local pos = arg.Name:find("AXIN") or arg.Parent and arg.Parent.Name:find("AXIN")
	if arg:IsDescendantOf(CoreGui) or pos then
		obj[arg] = true
		return
	end
	local v3 = fn4(arg)
	if tbl3[v3] == arg then
		return
	end

	if not tbl2[v3] then
		tbl2[v3] = {
			Pos = { arg.Position.X.Scale, arg.Position.X.Offset, arg.Position.Y.Scale, arg.Position.Y.Offset },
			Size = { arg.Size.X.Scale, arg.Size.X.Offset, arg.Size.Y.Scale, arg.Size.Y.Offset },
		}
	end

	tbl3[v3] = arg

	if tbl[v3] then
		fn5(arg, tbl[v3])
	end

	arg.MouseButton1Down:Connect(function()
		if not flag then
			return
		end
		v2 = arg
		v = arg
		v2.Active = false
		mouseLocation = UserInputService:GetMouseLocation()
		position = arg.Position
		local name = arg.Name
		WindUI:Notify({ Title = fn("NotifyTitle"), Content = fn("Se") .. name, Icon = "mouse", Duration = 2 })

		if connection then
			connection:Disconnect()
		end

		connection = RunService.RenderStepped:Connect(function()
			if not v2 then
				return
			end
			local n = UserInputService:GetMouseLocation() - mouseLocation
			v2.Position = UDim2.new(position.X.Scale, position.X.Offset + n.X, position.Y.Scale, position.Y.Offset + n.Y)
		end)
	end)
end

local function fn9()
	for _, descendant in ipairs(playerGui:GetDescendants()) do
		if not obj[descendant] then
			fn8(descendant)
		end
	end
end

playerGui.DescendantAdded:Connect(function(descendant)
	task.defer(fn8, descendant)
end)

local n = 0

RunService.RenderStepped:Connect(function()
	local now = os.clock()

	if now - n >= 0.2 and not flag then
		n = now

		for k, v3 in pairs(tbl3) do
			if v3 and v3.Parent and tbl[k] and not obj[v3] then
				fn5(v3, tbl[k])
			end
		end
	end
end)

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ererlong0/LS/refs/heads/main/windui%E7%BE%8E%E5%8C%96.lua"))()

lib:Popup({
	Title = "AXIN",
	IconThemed = true,
	Content = tbl4.ZH.SelectLang .. " / " .. tbl4.EN.SelectLang,
	Buttons = {
		{
			Title = "Chinese",
			Callback = function()
				str2 = "ZH"
				flag2 = true
			end,
			Variant = "Secondary",
		},
		{
			Title = "English",
			Icon = "arrow-right",
			Callback = function()
				str2 = "EN"
				flag2 = true
			end,
			Variant = "Primary",
		},
	},
	Background = "https://raw.githubusercontent.com/ererlong0/LS/refs/heads/main/be1eb7f2c3d5aa36ef2ebe733347bb68.jpg",
	BackgroundImageTransparency = 0.35,
})

repeat
	task.wait(0.1)
until flag2

str = str2

local v3 = lib:CreateWindow({
	Title = fn("Title"),
	Author = fn("Author"),
	Icon = "https://raw.githubusercontent.com/ererlong0/LS/refs/heads/main/1104845819.jpg",
	IconSize = 24,
	IconThemed = true,
	Folder = "CloudHub",
	Size = UDim2.fromOffset(560, 390),
	Transparent = true,
	NewElements = false,
	Theme = "Dark",
	Background = "https://raw.githubusercontent.com/ererlong0/LS/refs/heads/main/be1eb7f2c3d5aa36ef2ebe733347bb68.jpg",
	User = {
		Enabled = false,
		Callback = function()
			lib:Notify({ Title = fn("NotifyTitle"), Content = game.Players.LocalPlayer.Name, Duration = 1 })
		end,
		Anonymous = false,
	},
	SideBarWidth = 200,
	ScrollBarEnabled = true,
})

v3:SetBackgroundImageTransparency(0.2)
local editOpenButton = v3.EditOpenButton

local tbl5 = {
	Title = fn("Title"),
	Icon = "https://raw.githubusercontent.com/ererlong0/LS/refs/heads/main/1104845819.jpg",
	CornerRadius = UDim.new(0, 20),
	StrokeThickness = 1.9,
}

local colorSequence = ColorSequence.new
local tbl6 = {}
local v4 = ColorSequenceKeypoint.new(0, Color3.fromHex("7FFF7F"))
local v5 = ColorSequenceKeypoint.new(0.5, Color3.fromHex("BFFFBF"))
local new = ColorSequenceKeypoint.new
local color = Color3.fromHex
tbl6[1] = v4
tbl6[2] = v5

do
	local values = table.pack(new(1, color("FFFFFF")))
	table.move(values, 1, values.n, 3, tbl6)
end

tbl5.Color = colorSequence(tbl6)
tbl5.Draggable = true
tbl5.OnlyMobile = false
editOpenButton(v3, tbl5)

task.spawn(function()
	local v6 = nil

	while not v6 do
		local ok, result = pcall(function()
			return v3.OpenButtonMain.Button.UIStroke.UIGradient
		end)

		if ok and result then
			v6 = result
		else
			task.wait(0.3)
		end
	end

	game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
		v6.Rotation = (v6.Rotation + deltaTime * 90) % 360
	end)
end)

local flag3 = true
local n2 = 1

local tbl7 = {
	PurpleBlue = { type = "duo", color1 = Color3.fromHex("#5A38FF"), color2 = Color3.fromHex("#36D1FF") },
}

local function fn10()
	local main = v3.UIElements and v3.UIElements.Main
	if not main then
		return
	end
	local blur = main:FindFirstChild("Blur")

	if not blur then
		blur = Instance.new("ImageLabel")
		blur.Name = "Blur"
		blur.Size = UDim2.new(1, 0, 1, 0)
		blur.Position = UDim2.new(0, 0, 0, 0)
		blur.BackgroundTransparency = 1
		blur.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
		blur.ImageTransparency = 0.2
		blur.ZIndex = 0
		blur.Parent = main
	end

	return blur
end

local function fn11(arg, arg2)
	local v6 = tbl7[arg]
	if v6.type == "rainbow" then
		return Color3.fromHSV(arg2 * 0.5 % 1, 1, 1)
	end

	if v6.type == "duo" then
		return v6.color1:Lerp(v6.color2, (math.sin(arg2 * 2) + 1) / 2)
	end
	return Color3.new(1, 1, 1)
end

local function fn12(arg, imageColor3, imageTransparency)
	imageColor3 = imageColor3 or Color3.fromRGB(100, 150, 255)
	imageTransparency = imageTransparency or 0.2
	local main = arg.UIElements and arg.UIElements.Main or arg.Frame or arg.Gui or arg
	if not main then
		return false
	end
	local blur = main:FindFirstChild("Blur", true)

	if blur and blur:IsA("ImageLabel") then
		blur.ImageColor3 = imageColor3
		blur.ImageTransparency = imageTransparency
		return true
	end

	local shadow = main:FindFirstChild("Shadow", true)

	if shadow and shadow:IsA("ImageLabel") then
		shadow.ImageColor3 = imageColor3
		shadow.ImageTransparency = imageTransparency
		return true
	end

	return false
end

local connection2 = nil

local function fn13()
	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if not flag3 then
		return
	end
	fn10()

	connection2 = RunService.Heartbeat:Connect(function()
		local main = v3.UIElements and v3.UIElements.Main
		if not main or not main.Visible then
			return
		end
		fn12(v3, fn11("PurpleBlue", tick() * n2), 0.2)
	end)
end

local function fn14()
	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end
end

local fn15 = nil

fn15 = function()
	local main = v3.UIElements and v3.UIElements.Main

	if not main then
		task.spawn(function()
			while true do
				task.wait()
				if not (v3.UIElements and v3.UIElements.Main) then
					continue
				end
				break
			end

			fn15()
		end)

		return
	end

	if main.Visible then
		fn13()
	elseif not main.Visible then
		fn14()
	end

	main:GetPropertyChangedSignal("Visible"):Connect(function()
		if main.Visible then
			fn13()
		else
			fn14()
		end
	end)
end

fn15()

v3:OnClose(function()
	fn14()
end)

local main = v3.UIElements.Main

if main then
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Name = "BaconStroke"
	uiStroke.Thickness = 1.5
	uiStroke.Color = Color3.new(1, 1, 1)
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local uiGradient = Instance.new("UIGradient")
	uiGradient.Name = "BaconGradient"
	local colorSequence2 = ColorSequence.new
	local tbl8 = {}
	local v6 = ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 200, 170))
	local v7 = ColorSequenceKeypoint.new(0.3, Color3.fromRGB(215, 160, 120))
	local v8 = ColorSequenceKeypoint.new(0.6, Color3.fromRGB(190, 110, 80))
	local v9 = ColorSequenceKeypoint.new(0.8, Color3.fromRGB(140, 70, 45))
	local new2 = ColorSequenceKeypoint.new
	local color2 = Color3.fromRGB
	tbl8[1] = v6
	tbl8[2] = v7
	tbl8[3] = v8
	tbl8[4] = v9

	do
		local values = table.pack(new2(1, color2(220, 180, 150)))
		table.move(values, 1, values.n, 5, tbl8)
	end

	uiGradient.Color = colorSequence2(tbl8)
	uiGradient.Enabled = true
	uiGradient.Offset = Vector2.new(0, 0)
	uiStroke.Parent = main
	uiGradient.Parent = uiStroke

	task.spawn(function()
		while main and main.Parent do
			task.wait(0.01)
			uiGradient.Rotation = (uiGradient.Rotation + 4) % 360
		end
	end)
end

pcall(function()
	lib:SetFont("rbxassetid://12187376739")
end)

local font = nil

pcall(function()
	font = Font.new("rbxassetid://12187374765", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
end)

local function fn16()
	pcall(function()
		local topbar = v3.UIElements.Main.Main:WaitForChild("Topbar", 3)

		for _, descendant in ipairs(topbar:GetDescendants()) do
			pcall(function()
				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
					if font then
						descendant.FontFace = font
					end
				end
			end)
		end

		topbar.DescendantAdded:Connect(function(descendant)
			pcall(function()
				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
					if font then
						descendant.FontFace = font
					end
				end
			end)
		end)
	end)
end

local function fn17()
	task.spawn(function()
		while true do
			task.wait(0.1)
			if not (v3.OpenButtonMain and v3.OpenButtonMain.Button) then
				continue
			end
			break
		end

		local button = v3.OpenButtonMain.Button

		for _, descendant in ipairs(button:GetDescendants()) do
			pcall(function()
				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
					if font then
						descendant.FontFace = font
					end
				end
			end)
		end

		button.DescendantAdded:Connect(function(descendant)
			pcall(function()
				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
					if font then
						descendant.FontFace = font
					end
				end
			end)
		end)
	end)
end

fn16()
fn17()
local v6 = v3:Tab({ Title = fn("Tab"), Icon = "solar:cursor-square-bold", IconShape = "Square", Border = true }):Section({ Title = fn("Section") })

v6:Toggle({
	Title = fn("EditMode"),
	Desc = fn("EditModeDesc"),
	Default = false,
	Callback = function(arg)
		flag = arg

		if not arg and v2 then
			fn7()
		end
	end,
})

v6:Dropdown({
	Title = fn("Language"),
	Values = { "EN", "ZH" },
	Value = str == "ZH" and 2 or 1,
	Callback = function(arg)
		if type(arg) == "table" then
			arg = arg.Title or arg[1] or arg.Value
		end

		str = arg == "ZH" and "ZH" or "EN"
		lib:Notify({ Title = fn("NotifyTitle"), Content = fn("Se") .. str, Icon = "language", Duration = 2 })
	end,
})

v6:Button({
	Title = fn("Up"),
	Icon = "",
	Callback = function()
		if v then
			v.Position = v.Position + UDim2.new(0, 0, 0, -3)
			fn6()
		end
	end,
})

v6:Button({
	Title = fn("Down"),
	Icon = "",
	Callback = function()
		if v then
			v.Position = v.Position + UDim2.new(0, 0, 0, 3)
			fn6()
		end
	end,
})

v6:Button({
	Title = fn("Left"),
	Icon = "",
	Callback = function()
		if v then
			v.Position = v.Position + UDim2.new(0, -3, 0, 0)
			fn6()
		end
	end,
})

v6:Button({
	Title = fn("Right"),
	Icon = "",
	Callback = function()
		if v then
			v.Position = v.Position + UDim2.new(0, 3, 0, 0)
			fn6()
		end
	end,
})

v6:Slider({
	Title = fn("Size"),
	Desc = fn("SizeDesc"),
	Step = 1,
	Value = { Min = 10, Max = 600, Default = 100 },
	Callback = function(arg)
		if v then
			local size = v.Size
			v.Size = UDim2.new(size.X.Scale, arg, size.Y.Scale, arg)
			fn6()
		end
	end,
})

v6:Button({
	Title = fn("Big"),
	Icon = "",
	Callback = function()
		if v then
			v.Size = v.Size + UDim2.new(0, 8, 0, 8)
			fn6()
		end
	end,
})

v6:Button({
	Title = fn("Small"),
	Icon = "",
	Callback = function()
		if v then
			v.Size = v.Size + UDim2.new(0, -8, 0, -8)
			fn6()
		end
	end,
})

v6:Button({
	Title = fn("Save"),
	Icon = "floppy",
	Callback = function()
		if v then
			fn6()
		end

		fn3()
		lib:Notify({ Title = fn("NotifyTitle"), Content = fn("NS"), Icon = "checkmark", Duration = 2 })
	end,
})

v6:Button({
	Title = fn("Load"),
	Icon = "folder",
	Callback = function()
		if fn2() then
			for k, v7 in pairs(tbl3) do
				if v7 and v7.Parent and tbl[k] then
					fn5(v7, tbl[k])
				end
			end

			lib:Notify({ Title = fn("NotifyTitle"), Content = fn("NL"), Icon = "download", Duration = 2 })
		else
			lib:Notify({ Title = fn("NotifyTitle"), Content = fn("NN"), Icon = "x", Duration = 2 })
		end
	end,
})

v6:Button({
	Title = fn("Reset"),
	Icon = "trash",
	Callback = function()
		tbl = {}

		if delfile and isfile("AX.json") then
			pcall(delfile, "AX.json")
		end

		if writefile then
			pcall(writefile, "AX.json", "{}")
		end

		for k, v7 in pairs(tbl3) do
			if v7 and v7.Parent and tbl2[k] then
				local v8 = tbl2[k]
				v7.Position = UDim2.new(v8.Pos[1], v8.Pos[2], v8.Pos[3], v8.Pos[4])
				v7.Size = UDim2.new(v8.Size[1], v8.Size[2], v8.Size[3], v8.Size[4])
			end
		end

		v = nil
		lib:Notify({ Title = fn("NotifyTitle"), Content = fn("NR"), Icon = "refresh", Duration = 2 })
	end,
})

fn2()
fn9()

for _, v7 in pairs(tbl3) do
	local v8 = fn4(v7)

	if v7 and v7.Parent and tbl[v8] then
		fn5(v7, tbl[v8])
	end
end
