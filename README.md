# Xeno Library

```
local xenolib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Xeno9995/Xeno-hub/refs/heads/main/XENOHUB"))()
```
# Window

```
local Window = xenolib:MakeWindow({
  Title = "XENO HUB V2 | GROW A GARDEN",
  SubTitle = "by xeno999",
  SaveFolder = "test | xeno lib v1.json"
})
```
# Toggle Image

```
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://7072719587", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(15, 1) },
})
```
# Tab

```
local Tab1 = Window:MakeTab({"Welcome to xeno lib", "Home"})
```
# Discord Invite

```
Tab1:AddDiscordInvite({
    Name = "Your Server Name",
    Description = "Join server",
    Logo = "rbxassetid://18751483361",
    Invite = "Your Discord Invite",
})
```
# Section

```
local Section = Tab1:AddSection({"Section"})
```
# Dropdown

```
Tab1:AddDropdown({
    Name = "Dropdown",
    Options = {"Player 1", "Player 2", "Player 3"},
    Default = "Player 1",
    Callback = function(selected)
        print("Selected option:", selected)
    end
})
```
# Toggle 1

```
Tab1:AddToggle({
    Name = "Toggle",
    Desc = "This is a Toggle",
    Default = false,
    Callback = function(state)
        print("Toggle state:", state)
    end
})
```
# Toggle 2

```
Tab1:AddToggle({
    Name = "Toggle",
    Default = false,
    Callback = function(v)
    end
})
```
# Slider

```
Tab1:AddSlider({
    Name = "Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(v)
    end
})
```
# Paragraph

```
Tab1:AddParagraph({
    Title = "Paragraph",
    Text = "This is a exaple paragraph."
})
```
