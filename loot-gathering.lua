LootGathering = {
    bodies = {}
}

function LootGathering.send_ob_ciala()
    if not LootGathering.gathering_mode then
        LootGathering.gathering_mode = true
        tempRegexTrigger("^.*Doliczyl.s sie ([a-z]+) sztuk(|i)\\.$", [[LootGathering.send_ob_cialo_by_one(matches[2]) ]], 1)
        local dead_body_trigger = tempRegexTrigger("^Jest to martwe cialo .*\\.$", function () deleteLine() end)
        send("policz ciala", false)
        tempTimer(2, function () LootGathering.show_loot() end)
        tempTimer(2, function () LootGathering.gathering_mode = false end)
        tempTimer(2, [[ killTrigger("]] .. dead_body_trigger .. [[")]])
    end
end

function LootGathering.send_ob_cialo_by_one(bodies_count)
    local bodies_number = scripts.counted_string_to_int[bodies_count]
    local body_loot_trigger = tempRegexTrigger("^.*Zauwazasz przy nim (.*)\\.$", [[LootGathering.add_body_to_list(matches[2]) ]])
    deleteLine()
    tempTimer(2, [[ killTrigger("]] .. body_loot_trigger .. [[")]])
    for i=1, bodies_number do
        send("ob " .. LootGathering.id_to_biernik[i] .. " cialo", false)
    end
end

function LootGathering.show_loot()
    local lootWithLinks = {}
    for body_index, body in pairs(LootGathering.bodies) do
        for _, loot in pairs(body) do
            local command = "wez " .. loot .. " z " .. LootGathering.id_to_string_biernik[body_index] .. " ciala"
            -- echoLink("[ " .. "WEZ" .. " ]", function () send(command) end, "wez")
            -- cecho(" " .. loot .. "\n")
            table.insert(lootWithLinks, {command=command, name=loot})
        end
    end
    LootGathering.do_show_loot(lootWithLinks)
    LootGathering.bodies = {}
end

function LootGathering.do_show_loot(lootWithLinks)
    local result = {}
    for _, group in ipairs(scripts.inv.pretty_containers.group_definitions) do
        result[group.name] = result[group.name] or {}
    end
    result["inne"] = {}

    for _, loot in ipairs(lootWithLinks) do
        local in_fixed_group = false
        for pattern, fixed_group in pairs(scripts.inv.pretty_containers.fixed_groups) do
            if rex.find(loot.name, pattern) then
                table.insert(result[fixed_group], loot)
                in_fixed_group = true
            end
        end
        if not in_fixed_group then
            local added
            for _, group in ipairs(scripts.inv.pretty_containers.group_definitions) do
                added = false
                if group.filter(loot) then
                    table.insert(result[group.name], loot)
                    added = true
                    break
                end
            end
            if not added then
                table.insert(result["inne"], loot)
            end
        end
    end
    echo("/---------------------------------------------------------\\\n")
    echo("|                       Z W Ł O K I                       |\n")
    echo("+---------------------------------------------------------+\n")
    local template = "|                                                         |\n"
    for k, v in pairs(result) do
        if next(v) then
            local labelLength = string.len(k)
            local label = "|   <slate_blue>" .. k .. "<reset>"
            cecho(label .. string.sub(template, labelLength + 5))
            echo("+---------------------------------------------------------+\n")
            for _, loot in pairs(v) do
                echo("|   ")
                cechoLink("<turquoise>[ " .. "WEZ" .. " ]<reset>", function () send(loot.command) end, "wez", true)
                cecho(" " .. loot.name .. string.sub(template, 13 + string.len(loot.name)))
            end
            echo("+---------------------------------------------------------+\n")  
        end
    end
end

function LootGathering.add_body_to_list(body_contents)
    local temp = {}
    local result = {}
    temp = string.split(body_contents, ", ")
    for _, value in pairs(temp) do
        if string.find(value, " i ") then
            table.insert(result, string.split(value, " i ")[1])
            table.insert(result, string.split(value, " i ")[2])
        else
            table.insert(result, value)
        end
    end
    table.insert(LootGathering.bodies, result)
    deleteLine()
end

function LootGathering.dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. LootGathering.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function LootGathering.flatten(input, accumulator)
    accumulator = accumulator or {}
    for _, element in ipairs(input) do
      if type(element) == 'table' then
        LootGathering.flatten(element, accumulator)
      else
        table.insert(accumulator, element)
      end
    end
    return accumulator
end

LootGathering.id_to_biernik = {
    [1] = "pierwsze",
    [2] = "drugie",
    [3] = "trzecie",
    [4] = "czwarte",
    [5] = "piate",
    [6] = "szoste",
    [7] = "siodme",
    [8] = "osme",
    [9] = "dziewiate",
    [10] = "dziesiate",
}

LootGathering.id_to_string_biernik = {
    [1] = "pierwszego",
    [2] = "drugiego",
    [3] = "trzeciego",
    [4] = "czwartego",
    [5] = "piatego",
    [6] = "szostego",
    [7] = "siodmego",
    [8] = "osmego",
    [9] = "dziewiatego",
    [10] = "dziesiatego",
    [11] = "jedenastego",
    [12] = "dwunastego",
    [13] = "trzynastego",
    [14] = "czternastego",
    [15] = "pietnastego",
    [16] = "szesnastego",
    [17] = "siedemnastego",
    [18] = "osiemnastego",
    [19] = "dziewietnastego",
    [20] = "dwudziestego",
    [21] = "dwudziestego pierwszego",
    [22] = "dwudziestego drugiego",
    [23] = "dwudziestego trzeciego",
    [24] = "dwudziestego czwartego",
    [25] = "dwudziestego piatego",
    [26] = "dwudziestego szostego",
    [27] = "dwudziestego siodmego",
    [28] = "dwudziestego osmego",
    [29] = "dwudziestego dziewiatego",
    [30] = "trzydziestego",
    [31] = "trzydziestego pierwszego",
    [32] = "trzydziestego drugiego",
    [33] = "trzydziestego trzeciego",
    [34] = "trzydziestego czwartego",
    [35] = "trzydziestego piatego",
    [36] = "trzydziestego szostego",
    [37] = "trzydziestego siodmego",
    [38] = "trzydziestego osmego",
    [39] = "trzydziestego dziewiatego",
    [40] = "czterdziestego",
}