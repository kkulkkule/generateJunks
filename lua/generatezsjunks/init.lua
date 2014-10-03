GenerateZSJunks = {}

local this = GenerateZSJunks
this.MinSearchRange = 120
this.MaxSearchRange = 1000
this.SearchRange = this.MinSearchRange
this.maxRepeat = 30

function this.RandomizeDirection(dir)
    local ang = dir:Angle()
    ang.pitch = math.Rand(ang.pitch - 45, ang.pitch + 90)
    ang.yaw = math.Rand(ang.yaw - 90, ang.yaw + 90)
    return ang:Forward()
end

function this.Init()
    this.created = {}
    for _, v in pairs(team.GetSpawnPoint(TEAM_HUMAN)) do 
        -- local start = (istable(team.GetSpawnPoint(TEAM_HUMAN)) and table.Random(team.GetSpawnPoint(TEAM_HUMAN)):GetPos() + Vector(0, 0, 20)) // 추적 시작 지점은 스폰지점에서 위로 20만큼 떨어진 지점
        local start = v:GetPos() + Vector(0, 0, 20) // 추적 시작 지점은 스폰지점에서 위로 20만큼 떨어진 지점
        local td = {}
        td.start = start
        td.filter = {}
        local dir = Angle(math.Rand(-30, 30), math.Rand(-90, 90), 0):Forward()
        for i = 1, 80 do
            local repeated = 0
            repeat
                dir = this.RandomizeDirection(dir)
                td.endpos = td.start + dir * this.SearchRange
                tr = util.TraceLine(td)
                this.SearchRange = math.Clamp(this.SearchRange + (this.MaxSearchRange * (tr.HitPos - tr.StartPos):Length()), this.MinSearchRange, this.MaxSearchRange)
                repeated = repeated + 1
            until !tr.Hit or repeated >= this.maxRepeat
            td.start = tr.HitPos
            this.SpawnJunkBox(tr.HitPos)
        end
    end
end

// 위치에 정크박스 생성
function this.SpawnJunkBox(pos)
    local num = math.random(1000)
    if num < 500 or num >= 505 then
        return
    end
    local ent = ents.Create("prop_physics")
    for _, items in pairs(GAMEMODE.Crafts) do
        ent:SetModel(
            table.Random({
                "models/props_combine/breenbust.mdl",
                "models/props_combine/breenbust.mdl",
                "models/props_combine/breenbust.mdl",
                "models/props_junk/sawblade001a.mdl",
                "models/props_junk/sawblade001a.mdl",
                "models/props_junk/sawblade001a.mdl",
                "models/props_junk/sawblade001a.mdl",
                "models/props_junk/sawblade001a.mdl",
                "models/props_c17/oildrum001_explosive.mdl",
                "models/props_c17/oildrum001_explosive.mdl",
                "models/props_c17/oildrum001_explosive.mdl",
                "models/items/car_battery01.mdl",
                "models/items/car_battery01.mdl",
                "models/items/car_battery01.mdl",
                "models/items/car_battery01.mdl",
                "models/props_junk/wood_crate001a.mdl",
                "models/props_junk/wood_crate001a_damaged.mdl",
                "models/props_junk/wood_crate001a_damagedmax.mdl",
                "models/props_junk/wood_crate001a.mdl",
                "models/props_junk/wood_crate001a_damaged.mdl",
                "models/props_junk/wood_crate001a_damagedmax.mdl"
            })
        )
    end
    ent:SetPos(pos + Vector(0, 0, 30))
    ent:Spawn()
    table.insert(this.created, ent)
    return ent
end

hook.Add("SetupProps", "GenerateZSJunks", GenerateZSJunks.Init)