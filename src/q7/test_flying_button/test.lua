-- Q7
-- We add a module "test_flying_button" that must be added to the client, we added it in 
-- client-entergame load-later clause to have it presented on the client startup, we also add
-- a scheduled focus to make it visible after gui loading.
-- It uses a sheduleEvent loop to update the button position by changing its right margin
-- , increasing it until amounts the window width, where it is reset to 0, and randomizes its top
-- margin. The same reset fn is called at the beginning to position the button.
-- The handler resetButtonTravel is binded to the onClick event to provide the amusing jumping 
-- functionallity.
-- Finally we take care of removing the created "test" component on the terminate() fn binded to
-- the unLoad module event.

-- we could randomise the seed but probably the engine does it already.
-- math.randomseed(os.time()) 

-- we make them local as this is just a test and the component will not be used outside here
local testWindow       = nil
local flying_button  = nil

-- I prefer to use self-contained structs to ease the usage of pure functions and make the code 
-- more transparent.
local anim = {
    pos = {x = 0, y = 0},
    pos_delta = 8,
    width = nil,
    height = nil,
    time_delta = 80}

function init()

  testWindow = g_ui.displayUI('test')
  flying_button = testWindow:getChildById('button_test')

  window_inner_size = testWindow:getPaddingRect()
  button_size = flying_button:getSize()

  anim.width = window_inner_size.width - button_size.width
  anim.height = window_inner_size.height - button_size.height

  resetButtonTravel(anim) -- start of animation

  scheduleEvent(updateAnim, anim.time_delta) -- we start the schedule loop

  scheduleEvent(focusWindow, 500) -- focus window after load, shoud use hook instead of event
end

function focusWindow() 
  testWindow:focus()
end

function resetButtonTravel() 
  anim.pos.x = 0
  flying_button:setMarginRight(0)
  flying_button:setMarginTop(anim.height * math.random())
end

-- If schedule loop allowed callback arguments, we could pass anim as arg to improve 
-- code transparency
function updateAnim() 
  if anim.pos.x > anim.width then
    resetButtonTravel()
  end

  flying_button:setMarginRight(anim.pos.x)
  anim.pos.x = anim.pos.x + anim.pos_delta

  scheduleEvent(updateAnim, anim.time_delta) -- continue schedule loop
end

function terminate()
  testWindow:destroy()
end

