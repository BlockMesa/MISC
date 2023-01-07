return {
id="interface",
version="INDEV",
init=function (loaded,config)
  local genericInterface = {}
  ---Push items to an inventory
  ---@param async boolean
  ---@param targetInventory string
  ---@param name string|number
  ---@param amount nil|number
  ---@param toSlot nil|number
  ---@param nbt nil|string
  ---@param options nil|TransferOptions
  ---@return string transferId
  function genericInterface.pushItems(async,targetInventory, name, amount, toSlot, nbt, options)
    return loaded.inventory.interface.pushItems(async,targetInventory,name,amount,toSlot,nbt,options)
  end

  ---Pull items from an inventory
  ---@param async boolean
  ---@param fromInventory string|AbstractInventory
  ---@param fromSlot string|number
  ---@param amount nil|number
  ---@param toSlot nil|number
  ---@param nbt nil|string
  ---@param options nil|TransferOptions
  ---@return string transferId
  function genericInterface.pullItems(async,fromInventory, fromSlot, amount, toSlot, nbt, options)
    return loaded.inventory.interface.pullItems(async, fromInventory, fromSlot, amount, toSlot, nbt, options)
  end

  ---List the items in this storage
  function genericInterface.list()
    local list = {}
    local names = loaded.inventory.interface.listNames()
    for _,name in pairs(names) do
      local nbts = loaded.inventory.interface.listNBT(name)
      for _,nbt in pairs(nbts) do
        local item = loaded.inventory.interface.getItem(name,nbt)
        if item then
          item = item.item
          local item_clone = {}
          for k,v in pairs(item) do
            item_clone[k] = v
          end
          item_clone.name = name
          item_clone.nbt = nbt
          item_clone.count = loaded.inventory.interface.getCount(name,nbt)
          table.insert(list,item_clone)
        end
      end
    end
    return list
  end

  ---Flush the transfer queue immediately
  function genericInterface.performTransfer()
    loaded.inventory.interface.performTransfer()
  end

  function genericInterface.listCraftables()
    if not loaded.crafting then
      return {}
    end
    return loaded.crafting.interface.list_craftables()
  end

  function genericInterface.requestCraft(name, count)
    return loaded.crafting.interface.request_craft(name,count)
  end

  function genericInterface.startCraft(jobID)
    return loaded.crafting.interface.start_craft(jobID)
  end

  function genericInterface.cancelCraft(jobID)
    return loaded.crafting.interface.cancel_craft(jobID)
  end

  local interface = {}
  local inventoryUpdateHandlers = {}
  ---Add a handler for the inventoryUpdate event
  ---@param handler fun(list: table)
  function interface.addInventoryUpdateHandler(handler)
    table.insert(inventoryUpdateHandlers, handler)
  end

  local function inventoryUpdateHandler()
    while true do
      os.pullEvent("inventoryUpdate")
      local list = genericInterface.list()
      for _, f in pairs(inventoryUpdateHandlers) do
        f(list)
      end
    end
  end
  function interface.callMethod(method, args)
    local desiredMethod = genericInterface[method]
    assert(desiredMethod, method.." is not a valid method")
    return desiredMethod(table.unpack(args, 1, args.n))
  end
  function interface.start()
    inventoryUpdateHandler()
  end
  return interface
end
}