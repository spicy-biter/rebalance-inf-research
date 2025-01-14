function add_ingredient(tech_name, science_pack)
    local technology = data.raw["technology"][tech_name]

    -- Ingredient count might be > 1, so can't use table.find() sadly

    for _, ingredient in pairs(technology.unit.ingredients) do
        if ingredient[1] == science_pack then
            return
        end
    end

    table.insert(
        technology.unit.ingredients,
        {
            science_pack,
            1
        }
    )
end


local inf_mining_prod = "mining-productivity-3"
local inf_bullet_dmg = "physical-projectile-damage-7"


-- Add util and space science to recipe
local prod_techs = {
    "low-density-structure-productivity",
    "plastic-bar-productivity",
    "processing-unit-productivity",
    "rocket-fuel-productivity",
    "rocket-part-productivity",
    "scrap-recycling-productivity",
}

local prod_sci = "production-science-pack"
local space_sci = "space-science-pack"
local util_sci = "utility-science-pack"


--[[
Adjust infinite mining productivity to:
1. Require utility science to be researched
2. Require utility science as an ingredient
3. Scale exponentially
]]

local scaling = tostring(
    1.0 + settings.startup["inf-mining-prod-scaling-percentage"].value / 100
)

data.raw["technology"][inf_mining_prod].unit.count_formula = scaling .. "^(L-2)*1000"

table.insert(
    data.raw["technology"][inf_mining_prod].prerequisites,
    util_sci
)
add_ingredient(inf_mining_prod, util_sci)

-- Make infinite bullet damage require production science

add_ingredient(inf_bullet_dmg, prod_sci)

-- Make other infinite sciences require utility and space science

for idx, tech_name in pairs(prod_techs) do

    table.insert(
        data.raw["technology"][tech_name].prerequisites,
        util_sci
    )

    add_ingredient(tech_name, util_sci)
    add_ingredient(tech_name, space_sci)

end
