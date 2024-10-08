require "/scripts/util.lua"

function init()
    message.setHandler("cf_learncodex", learnCodexHandler)
    message.setHandler("cf_getcodices", getCodices)

    self.knownCodices = player.getProperty("cf_knownCodices") or {}

    local cfg = root.assetJson("/player.config")
    local defaultCodices = cfg.defaultCodexes[player.species()] or {}

    for _, codex in pairs(defaultCodices) do
        learnCodex(root.itemConfig(codex .. "-codex").directory .. codex .. ".codex")
    end

    removeInvalidCodices()
end

function getCodices()
    return self.knownCodices
end

function learnCodexHandler(_, _, name)
    learnCodex(name)
end

function learnCodex(name)
    if not contains(self.knownCodices, name) then
        table.insert(self.knownCodices, name)
    end
end

function removeInvalidCodices()
    for c, codex in pairs(self.knownCodices) do
        if not pcall(function()
          local codex = root.assetJson(codex)
        end) or not codex then
          table.remove(self.knownCodices, c)
        end
    end
end

function uninit()
    player.setProperty("cf_knownCodices", self.knownCodices)
end