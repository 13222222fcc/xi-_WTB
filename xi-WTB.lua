getfenv().ADittoKey="XiProFreeKey"

-- =============================================
-- 可开关的ROBLOX防踢出监控系统
-- =============================================
local RobloxAntiKick = {
    Hooks = {},
    OriginalFunctions = {},
    Protected = false,
    MonitorEnabled = true,
    UI = {},
    DetectedThreats = {}
}

-- 创建监控UI
function RobloxAntiKick:CreateMonitorUI()
    -- 创建主GUI
    self.UI.ScreenGui = Instance.new("ScreenGui")
    self.UI.ScreenGui.Name = "XiProAntiKickMonitor"
    self.UI.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.UI.ScreenGui.ResetOnSpawn = false
    self.UI.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- 主监控窗口
    self.UI.MainFrame = Instance.new("Frame")
    self.UI.MainFrame.Size = UDim2.new(0, 300, 0, 180)
    self.UI.MainFrame.Position = UDim2.new(1, -320, 0, 20)
    self.UI.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    self.UI.MainFrame.BorderSizePixel = 0
    self.UI.MainFrame.ZIndex = 10
    self.UI.MainFrame.Parent = self.UI.ScreenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = self.UI.MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Thickness = 2
    mainStroke.Color = Color3.fromRGB(70, 130, 200)
    mainStroke.Parent = self.UI.MainFrame
    
    -- 标题栏
    self.UI.TitleBar = Instance.new("Frame")
    self.UI.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.UI.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.UI.TitleBar.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    self.UI.TitleBar.BorderSizePixel = 0
    self.UI.TitleBar.ZIndex = 11
    self.UI.TitleBar.Parent = self.UI.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.UI.TitleBar
    
    -- 标题文字
    self.UI.TitleLabel = Instance.new("TextLabel")
    self.UI.TitleLabel.Size = UDim2.new(0, 150, 1, 0)
    self.UI.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.UI.TitleLabel.BackgroundTransparency = 1
    self.UI.TitleLabel.Text = "Xi Pro 安全监控"
    self.UI.TitleLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
    self.UI.TitleLabel.TextSize = 14
    self.UI.TitleLabel.Font = Enum.Font.GothamBold
    self.UI.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.UI.TitleLabel.ZIndex = 12
    self.UI.TitleLabel.Parent = self.UI.TitleBar
    
    -- 状态指示器
    self.UI.StatusIndicator = Instance.new("Frame")
    self.UI.StatusIndicator.Size = UDim2.new(0, 8, 0, 8)
    self.UI.StatusIndicator.Position = UDim2.new(0, 160, 0.5, -4)
    self.UI.StatusIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    self.UI.StatusIndicator.BorderSizePixel = 0
    self.UI.StatusIndicator.ZIndex = 12
    self.UI.StatusIndicator.Parent = self.UI.TitleBar
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0.5, 0)
    statusCorner.Parent = self.UI.StatusIndicator
    
    self.UI.StatusLabel = Instance.new("TextLabel")
    self.UI.StatusLabel.Size = UDim2.new(0, 60, 1, 0)
    self.UI.StatusLabel.Position = UDim2.new(0, 175, 0, 0)
    self.UI.StatusLabel.BackgroundTransparency = 1
    self.UI.StatusLabel.Text = "运行中"
    self.UI.StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    self.UI.StatusLabel.TextSize = 12
    self.UI.StatusLabel.Font = Enum.Font.GothamMedium
    self.UI.StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.UI.StatusLabel.ZIndex = 12
    self.UI.StatusLabel.Parent = self.UI.TitleBar
    
    -- 收起按钮（正方形）
    self.UI.ToggleButton = Instance.new("TextButton")
    self.UI.ToggleButton.Size = UDim2.new(0, 20, 0, 20)
    self.UI.ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    self.UI.ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    self.UI.ToggleButton.Text = "−"
    self.UI.ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.UI.ToggleButton.TextSize = 14
    self.UI.ToggleButton.Font = Enum.Font.GothamBold
    self.UI.ToggleButton.BorderSizePixel = 0
    self.UI.ToggleButton.ZIndex = 12
    self.UI.ToggleButton.Parent = self.UI.TitleBar
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = self.UI.ToggleButton
    
    -- 关闭按钮（叉）
    self.UI.CloseButton = Instance.new("TextButton")
    self.UI.CloseButton.Size = UDim2.new(0, 20, 0, 20)
    self.UI.CloseButton.Position = UDim2.new(1, -25, 0.5, -10)
    self.UI.CloseButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    self.UI.CloseButton.Text = "×"
    self.UI.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.UI.CloseButton.TextSize = 16
    self.UI.CloseButton.Font = Enum.Font.GothamBold
    self.UI.CloseButton.BorderSizePixel = 0
    self.UI.CloseButton.ZIndex = 12
    self.UI.CloseButton.Parent = self.UI.TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = self.UI.CloseButton
    
    -- 内容区域
    self.UI.ContentFrame = Instance.new("Frame")
    self.UI.ContentFrame.Size = UDim2.new(1, -20, 1, -40)
    self.UI.ContentFrame.Position = UDim2.new(0, 10, 0, 35)
    self.UI.ContentFrame.BackgroundTransparency = 1
    self.UI.ContentFrame.ZIndex = 11
    self.UI.ContentFrame.Parent = self.UI.MainFrame
    
    -- 威胁列表
    self.UI.ThreatList = Instance.new("ScrollingFrame")
    self.UI.ThreatList.Size = UDim2.new(1, 0, 1, 0)
    self.UI.ThreatList.Position = UDim2.new(0, 0, 0, 0)
    self.UI.ThreatList.BackgroundTransparency = 1
    self.UI.ThreatList.BorderSizePixel = 0
    self.UI.ThreatList.ScrollBarThickness = 4
    self.UI.ThreatList.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    self.UI.ThreatList.ZIndex = 11
    self.UI.ThreatList.Parent = self.UI.ContentFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = self.UI.ThreatList
    
    -- 控制按钮区域
    self.UI.ControlFrame = Instance.new("Frame")
    self.UI.ControlFrame.Size = UDim2.new(1, 0, 0, 30)
    self.UI.ControlFrame.Position = UDim2.new(0, 0, 1, -30)
    self.UI.ControlFrame.BackgroundTransparency = 1
    self.UI.ControlFrame.ZIndex = 11
    self.UI.ControlFrame.Parent = self.UI.ContentFrame
    
    -- 启用/禁用监控按钮
    self.UI.MonitorToggle = Instance.new("TextButton")
    self.UI.MonitorToggle.Size = UDim2.new(0.5, -5, 1, 0)
    self.UI.MonitorToggle.Position = UDim2.new(0, 0, 0, 0)
    self.UI.MonitorToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    self.UI.MonitorToggle.Text = "禁用监控"
    self.UI.MonitorToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.UI.MonitorToggle.TextSize = 12
    self.UI.MonitorToggle.Font = Enum.Font.GothamMedium
    self.UI.MonitorToggle.BorderSizePixel = 0
    self.UI.MonitorToggle.ZIndex = 12
    self.UI.MonitorToggle.Parent = self.UI.ControlFrame
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 6)
    toggleBtnCorner.Parent = self.UI.MonitorToggle
    
    -- 清除记录按钮
    self.UI.ClearButton = Instance.new("TextButton")
    self.UI.ClearButton.Size = UDim2.new(0.5, -5, 1, 0)
    self.UI.ClearButton.Position = UDim2.new(0.5, 5, 0, 0)
    self.UI.ClearButton.BackgroundColor3 = Color3.fromRGB(50, 60, 80)
    self.UI.ClearButton.Text = "清除记录"
    self.UI.ClearButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    self.UI.ClearButton.TextSize = 12
    self.UI.ClearButton.Font = Enum.Font.GothamMedium
    self.UI.ClearButton.BorderSizePixel = 0
    self.UI.ClearButton.ZIndex = 12
    self.UI.ClearButton.Parent = self.UI.ControlFrame
    
    local clearBtnCorner = Instance.new("UICorner")
    clearBtnCorner.CornerRadius = UDim.new(0, 6)
    clearBtnCorner.Parent = self.UI.ClearButton
    
    -- 设置按钮事件
    self:SetupUIEvents()
    
    -- 初始为展开状态
    self.UI.IsMinimized = false
end

-- 设置UI事件
function RobloxAntiKick:SetupUIEvents()
    -- 拖动功能
    self:MakeDraggable(self.UI.TitleBar, self.UI.MainFrame)
    
    -- 收起/展开按钮
    self.UI.ToggleButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- 关闭按钮
    self.UI.CloseButton.MouseButton1Click:Connect(function()
        self:ToggleMonitorVisibility()
    end)
    
    -- 监控开关按钮
    self.UI.MonitorToggle.MouseButton1Click:Connect(function()
        self:ToggleMonitoring()
    end)
    
    -- 清除记录按钮
    self.UI.ClearButton.MouseButton1Click:Connect(function()
        self:ClearThreats()
    end)
end

-- 拖动功能
function RobloxAntiKick:MakeDraggable(dragFrame, mainFrame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- 收起/展开窗口
function RobloxAntiKick:ToggleMinimize()
    if self.UI.IsMinimized then
        -- 展开
        self.UI.MainFrame:TweenSize(UDim2.new(0, 300, 0, 180), "Out", "Quad", 0.3)
        self.UI.ToggleButton.Text = "−"
        self.UI.IsMinimized = false
    else
        -- 收起
        self.UI.MainFrame:TweenSize(UDim2.new(0, 300, 0, 30), "Out", "Quad", 0.3)
        self.UI.ToggleButton.Text = "+"
        self.UI.IsMinimized = true
    end
end

-- 显示/隐藏监控窗口
function RobloxAntiKick:ToggleMonitorVisibility()
    if self.UI.MainFrame.Visible then
        self.UI.MainFrame.Visible = false
    else
        self.UI.MainFrame.Visible = true
    end
end

-- 启用/禁用监控
function RobloxAntiKick:ToggleMonitoring()
    if self.MonitorEnabled then
        self.MonitorEnabled = false
        self.UI.MonitorToggle.Text = "启用监控"
        self.UI.StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        self.UI.StatusLabel.Text = "已暂停"
        self.UI.StatusLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
    else
        self.MonitorEnabled = true
        self.UI.MonitorToggle.Text = "禁用监控"
        self.UI.StatusIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        self.UI.StatusLabel.Text = "运行中"
        self.UI.StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end

-- 清除威胁记录
function RobloxAntiKick:ClearThreats()
    self.DetectedThreats = {}
    for _, child in ipairs(self.UI.ThreatList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- 添加威胁记录
function RobloxAntiKick:AddThreat(threatType, description)
    if not self.MonitorEnabled then return end
    
    local threatId = #self.DetectedThreats + 1
    self.DetectedThreats[threatId] = {
        type = threatType,
        description = description,
        time = os.date("%H:%M:%S")
    }
    
    -- 在UI中添加威胁项
    local threatItem = Instance.new("Frame")
    threatItem.Size = UDim2.new(1, 0, 0, 40)
    threatItem.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    threatItem.BorderSizePixel = 0
    threatItem.ZIndex = 11
    threatItem.Parent = self.UI.ThreatList
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 6)
    itemCorner.Parent = threatItem
    
    local threatIcon = Instance.new("TextLabel")
    threatIcon.Size = UDim2.new(0, 30, 1, 0)
    threatIcon.Position = UDim2.new(0, 5, 0, 0)
    threatIcon.BackgroundTransparency = 1
    threatIcon.Text = "⚠"
    threatIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
    threatIcon.TextSize = 16
    threatIcon.Font = Enum.Font.GothamBold
    threatIcon.ZIndex = 12
    threatIcon.Parent = threatItem
    
    local threatText = Instance.new("TextLabel")
    threatText.Size = UDim2.new(1, -40, 0.6, 0)
    threatText.Position = UDim2.new(0, 40, 0, 5)
    threatText.BackgroundTransparency = 1
    threatText.Text = description
    threatText.TextColor3 = Color3.fromRGB(220, 220, 220)
    threatText.TextSize = 12
    threatText.Font = Enum.Font.GothamMedium
    threatText.TextXAlignment = Enum.TextXAlignment.Left
    threatText.ZIndex = 12
    threatText.Parent = threatItem
    
    local timeText = Instance.new("TextLabel")
    timeText.Size = UDim2.new(1, -40, 0.4, 0)
    timeText.Position = UDim2.new(0, 40, 0.6, 0)
    timeText.BackgroundTransparency = 1
    timeText.Text = "时间: " .. os.date("%H:%M:%S")
    timeText.TextColor3 = Color3.fromRGB(150, 150, 150)
    timeText.TextSize = 10
    timeText.Font = Enum.Font.Gotham
    timeText.TextXAlignment = Enum.TextXAlignment.Left
    timeText.ZIndex = 12
    timeText.Parent = threatItem
    
    -- 在右下角显示警告
    self:ShowWarningNotification(threatType, description)
    
    -- 自动滚动到底部
    self.UI.ThreatList.CanvasSize = UDim2.new(0, 0, 0, (#self.UI.ThreatList:GetChildren() - 1) * 45)
    self.UI.ThreatList.CanvasPosition = Vector2.new(0, self.UI.ThreatList.CanvasSize.Y.Offset)
end

-- 在右下角显示警告通知
function RobloxAntiKick:ShowWarningNotification(threatType, description)
    if not self.MonitorEnabled then return end
    
    -- 创建通知GUI
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, -320, 1, -100)
    notification.BackgroundColor3 = Color3.fromRGB(40, 30, 35)
    notification.BorderSizePixel = 0
    notification.ZIndex = 20
    notification.Parent = self.UI.ScreenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Thickness = 2
    notifStroke.Color = Color3.fromRGB(255, 100, 100)
    notifStroke.Parent = notification
    
    local warningIcon = Instance.new("TextLabel")
    warningIcon.Size = UDim2.new(0, 40, 1, 0)
    warningIcon.Position = UDim2.new(0, 10, 0, 0)
    warningIcon.BackgroundTransparency = 1
    warningIcon.Text = "⚠"
    warningIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
    warningIcon.TextSize = 24
    warningIcon.Font = Enum.Font.GothamBold
    warningIcon.ZIndex = 21
    warningIcon.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Position = UDim2.new(0, 50, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "安全警告: " .. threatType
    titleLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 21
    titleLabel.Parent = notification
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -60, 0, 40)
    descLabel.Position = UDim2.new(0, 50, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.ZIndex = 21
    descLabel.Parent = notification
    
    -- 自动关闭通知
    spawn(function()
        wait(5)
        notification:TweenPosition(UDim2.new(1, -320, 1, 100), "Out", "Quad", 0.5)
        wait(0.5)
        notification:Destroy()
    end)
end

-- 核心保护功能
function RobloxAntiKick:Initialize()
    if self.Protected then return end
    
    -- 创建UI
    self:CreateMonitorUI()
    
    -- 保存原始函数
    self:BackupOriginalFunctions()
    
    -- 应用保护措施
    self:ApplyKickProtection()
    self:ApplyRemoteProtection()
    self:ApplyCharacterProtection()
    
    self.Protected = true
    self:AddThreat("系统启动", "防踢出监控系统已激活")
end

-- 备份原始函数
function RobloxAntiKick:BackupOriginalFunctions()
    self.OriginalFunctions.Kick = game.Players.LocalPlayer.Kick
end

-- 应用踢出保护
function RobloxAntiKick:ApplyKickProtection()
    -- 重写Kick方法
    game.Players.LocalPlayer.Kick = function(player, reason)
        self:AddThreat("踢出尝试", "检测到踢出尝试: " .. tostring(reason))
        return nil
    end
    
    -- 元表保护
    self:HookMetatable()
end

-- 钩住元表进行深层保护
function RobloxAntiKick:HookMetatable()
    local success, mt = pcall(getrawmetatable, game)
    if not success or not mt then return end
    
    setreadonly(mt, false)
    
    self.OriginalFunctions.Namecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        
        -- 拦截踢出调用
        if method == "Kick" and self == game.Players.LocalPlayer then
            self:AddThreat("元表踢出", "通过元表的踢出尝试被阻止")
            return nil
        end
        
        return self.OriginalFunctions.Namecall(self, ...)
    end)
    
    setreadonly(mt, true)
end

-- 防止通过远程事件踢出
function RobloxAntiKick:ApplyRemoteProtection()
    self.Hooks.DescendantAdded = game.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            local name = descendant.Name:lower()
            if string.find(name, "kick") or string.find(name, "ban") or 
               string.find(name, "anticheat") then
                self:AddThreat("可疑远程对象", "检测到可疑远程对象: " .. descendant.Name)
            end
        end
    end)
end

-- 角色相关保护
function RobloxAntiKick:ApplyCharacterProtection()
    if game.Players.LocalPlayer.Character then
        self:SetupCharacterProtection(game.Players.LocalPlayer.Character)
    end
    
    self.Hooks.CharacterAdded = game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
        wait(0.5)
        self:SetupCharacterProtection(character)
    end)
end

function RobloxAntiKick:SetupCharacterProtection(character)
    local humanoid = character:WaitForChild("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then
                self:AddThreat("角色死亡", "角色死亡事件被监控")
            end
        end)
    end
    
    self.Hooks.CharacterDescendantAdded = character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Script") or descendant:IsA("LocalScript") then
            local scriptName = descendant.Name:lower()
            if string.find(scriptName, "anti") or string.find(scriptName, "cheat") then
                self:AddThreat("可疑脚本", "检测到可疑脚本: " .. descendant.Name)
            end
        end
    end)
end

-- 清理函数
function RobloxAntiKick:Cleanup()
    if not self.Protected then return end
    
    -- 恢复原始函数
    if self.OriginalFunctions.Kick then
        game.Players.LocalPlayer.Kick = self.OriginalFunctions.Kick
    end
    
    -- 恢复元表
    local success, mt = pcall(getrawmetatable, game)
    if success and mt and self.OriginalFunctions.Namecall then
        setreadonly(mt, false)
        mt.__namecall = self.OriginalFunctions.Namecall
        setreadonly(mt, true)
    end
    
    -- 断开所有连接
    for _, connection in pairs(self.Hooks) do
        pcall(function() connection:Disconnect() end)
    end
    self.Hooks = {}
    
    -- 清理UI
    if self.UI.ScreenGui then
        self.UI.ScreenGui:Destroy()
    end
    
    self.Protected = false
end

-- 安全执行包装
local function SafeExecute(func, errorMsg)
    local success, err = pcall(func)
    if not success then
        warn("[Xi Pro] 错误: " .. errorMsg .. " - " .. tostring(err))
    end
    return success
end

-- 初始化防踢出系统
SafeExecute(function()
   
