return {
  id = "debug",
  version = "INDEV",
  config = {},
init = function(loaded, config)
  periphemu.create("minecraft:chest_4", "minecraft:chest")
  local c = peripheral.wrap("minecraft:chest_4")
  c.setItem(1, {name="minecraft:stone", count=10})
  periphemu.create("minecraft:chest_5", "minecraft:chest")
  periphemu.create("minecraft:chest_6", "minecraft:chest")
  periphemu.create("top", "modem")
  return {
    -- start = function()
    -- end
  }
end
}