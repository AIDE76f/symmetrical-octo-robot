--[[ 
    ULTIMATE DEEP SCRAPER & SPEED BYPASS
    هذا السكربت يبحث في "أحشاء" اللعبة عن أي قيمة مرتبطة بالمال أو السرعة
]]

local TARGET_SPEED = 0.1
local KEYWORDS = {"$", "Money", "Cash", "Rate", "Speed", "Production", "Income"}

local function applyPower(object)
    -- محاولة تعديل القيمة مهما كان نوعها (رقم أو نص يحتوي على رقم)
    if object:IsA("NumberValue") or object:IsA("IntValue") then
        object.Value = TARGET_SPEED
        print(`[🔥] FOUND & MODIFIED: {object:GetFullName()} to {TARGET_SPEED}`)
    end
end

local function deepSearch(parent)
    for _, child in ipairs(parent:GetChildren()) do
        local found = false
        
        -- البحث عن الكلمات المفتاحية في اسم الكائن
        for _, word in ipairs(KEYWORDS) do
            if string.find(child.Name, word) or string.find(child.Name, "%$") then
                found = true
                break
            end
        end
        
        if found then
            applyPower(child)
        end
        
        -- الدخول لعمق أكبر (Recursive Search)
        deepSearch(child)
    end
end

-- المسح الشامل لكل المجلدات الحساسة
local foldersToSearch = {
    workspace,
    game:GetService("ReplicatedStorage"),
    game:GetService("SharedTableRegistry"), -- أماكن متقدمة لتخزين البيانات
    game:GetService("Teams")
}

print("--- STARTING DEEP SCAN ---")
for _, folder in ipairs(foldersToSearch) do
    pcall(function() -- استخدام pcall لتجنب توقف السكربت إذا كان المجلد محمياً
        deepSearch(folder)
    end)
end
print("--- SCAN COMPLETE ---")

-- الاستمرار في المراقبة لأي موظف جديد يدخل السيرفر
game.DescendantAdded:Connect(function(desc)
    for _, word in ipairs(KEYWORDS) do
        if string.find(desc.Name, word) or string.find(desc.Name, "%$") then
            task.wait(0.1)
            applyPower(desc)
        end
    end
end)
