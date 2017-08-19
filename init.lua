local log = hs.logger.new('init.lua', 'debug')

-- TODO:
--
-- Next feature to add is the ability to use `s` as a `shift` key during
-- VIM mode. This is because physically hitting the `shift` key is hard while
-- holding down the `Caps Lock` key with your pinky.

keyUpDown = function(modifiers, key)
 -- log.d('Sending keystroke:', hs.inspect(modifiers), key)
  hs.eventtap.event.newKeyEvent(modifiers, key, true):post()
  -- hs.eventtap.event.newKeyEvent(modifiers, key, false):post()
end

local eventtap = hs.eventtap
local eventTypes = hs.eventtap.event.types
local eventProperties = hs.eventtap.event.properties

local vimMode = {
  reset = function(self)
    -- self.startTime = nil
    self.isActive = false
    -- if this is true then after the escape key is depressed, we want to
    -- have the real escape key press to go through. If it is is false, then
    -- it means that the escape should not go through.
    self.escapeOnKeyUp = false
    self.allowNextEscape = false
    self.timer = nil
  end
}
vimMode:reset()

activationListener = eventtap.new({eventTypes.keyDown}, function(event)

  local keyCode = event:getKeyCode()
  log.d('keyCode', keyCode)

  local isEscape = keyCode == 53

  -- If it's not the escape key, then do not handle.
  if not isEscape then
    return false
  end

  if vimMode.allowNextEscape then
    vimMode.allowNextEscape = false
    return false
  end

  local autorepeat = event:getProperty(eventProperties.keyboardEventAutorepeat)
  local isFirstEscape = autorepeat == 0
  -- log.d(keyboardEventAutorepeat, isFirstEscape)

  if isFirstEscape then
    -- log.d('time', os.time())
    -- vimMode.startTime = os.time()
    vimMode.escapeOnKeyUp = true
    vimMode.timer = hs.timer.doAfter(0.2, function()
      vimMode.escapeOnKeyUp = false
    end)
  end

  vimMode.isActive = true
  return true

end):start()

deactivationListener = eventtap.new({eventTypes.keyUp}, function(event)
  local keyCode = event:getKeyCode()
  local isEscape = keyCode == 53
  if isEscape then
    vimMode.isActive = false
    -- local ms = os.time() - vimMode.startTime
    -- log.d('ms', ms)
    -- vimMode.startTime = nil
    if vimMode.escapeOnKeyUp then
      -- log.d('escapeOnKeyUp')
      vimMode.timer:stop()
      vimMode.allowNextEscape = true
      keyUpDown({}, 'escape')
      return true
    end
  end

  return false

  -- local characters = event:getCharacters()
  -- if characters == 's' then
  --   log.d('KEYUP S')
  --   if vimMode.allowNextS then
  --     log.d('keyUp allowNextS end')
  --     return false
  --   else
  --     log.d('keyUp allowNextS trigger') --     vimMode.isActive = false
  --     vimMode.allowNextS = true
  --     keyUpDown({}, 's')
  --     return false
  --   end
  -- endk
end):start()

local keyCodeMap = {}
keyCodeMap[4] = {nil, 'left'}      -- h -> left
keyCodeMap[38] = {nil, 'down'}     -- j -> down
keyCodeMap[40] = {nil, 'up'}       -- k -> up
keyCodeMap[37] = {nil, 'right'}    -- l -> right
keyCodeMap[32] = {{'shift'}, '['}  -- u -> {
keyCodeMap[34] = {{'shift'}, ']'}  -- i -> }
keyCodeMap[43] = {{}, '['}         -- , -> [
keyCodeMap[47] = {{}, ']'}         -- . -> ]
keyCodeMap[39] = {nil, '`'}        -- ' -> `
-- keyCodeMap[29] = {{'ctrl'}, 'a'}   -- 0
-- keyCodeMap[21] = {{'ctrl'}, 'e'}   -- 4

navigationListener = eventtap.new({eventTypes.keyDown}, function (event)
  if not vimMode.isActive then
    return false
  end
  local keyCode = event:getKeyCode()
  local mappedKeyCode = keyCodeMap[keyCode]

  -- If it's not a mapped key, then just let the OS handle it
  if not mappedKeyCode then
    return false
  end

  if mappedKeyCode then
    vimMode.escapeOnKeyUp = false
    local flags = event:getFlags()
    local modifiers
    if mappedKeyCode[1] then
      modifiers = mappedKeyCode[1]
    else
      modifiers = {}
      if flags.cmd then
        table.insert(modifiers, 'cmd')
      end
      if flags.alt then
        table.insert(modifiers, 'alt')
      end
      if flags.shift then
        table.insert(modifiers, 'shift')
      end
      if flags.ctrl then
        table.insert(modifiers, 'ctrl')
      end
    end

    log.d("keyUpDown", modifiers, mappedKeyCode[2])
    keyUpDown(modifiers, mappedKeyCode[2])
    return true
  end
end):start()

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()
