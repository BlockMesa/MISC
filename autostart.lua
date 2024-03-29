while true do
    pcall(function()
        shell.run("misc.lua")
    end)
    term.setTextColour(colours.white)
    print("Exited... Starting in 3")
    sleep(1)
    print("Starting in 2")
    sleep(1)
    print("Starting in 1")
    sleep(1)
    print("Starting...")
end
