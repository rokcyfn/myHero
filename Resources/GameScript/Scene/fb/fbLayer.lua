local taskinfo = require(SRC.."Scene/roost/taskInfo")
local PATH = IMG_SCENE .. "fb/"
local M = {
}
function M:new( params )
  params = params or {}
  local data = DATA_Fb:get()
	local this = {}
	setmetatable(this,self)
	self.__index  = self
  
  this.baseLayer = CCLayer:create()
  this.viewLayer = CCLayer:create()
  
  
  
	local bg = newSprite(IMG_COMMON.."main.png")
	setAnchPos(bg,0,85)
	this.baseLayer:addChild(bg)
	
	local bsv 
  bsv = ScrollView:new( 4 , 102 , 476 , 586 , 12 , false , 0 )
	for i = 1 , #data.baseList do
	   bsv:addChild( this:createCell( {data = data.baseList[i] , index = i } ) )
	end
	this.viewLayer:addChild( bsv:getLayer() )

	this.baseLayer:addChild( this.viewLayer )
	
	this.baseLayer:addChild( InfoLayer:create("fb"):getLayer()  )
	
return this
end
--创建单个宝塔
function M:createCell( params )
  params = params or {}
  local data = params.data or {}
  
  local layer = display.newLayer()
  local tower = nil              
  local cellBg = display.newSprite( PATH .. "frame_bg.png" , 0 ,0 , 0 , 0 ) 
  layer:addChild( cellBg )
  local strElement = {
                       { data.name , ccc3(0x00, 0x9c, 0x00) }, 
                       { "最好成绩：" .. data.max_layer , ccc3(0xff, 0xff, 0x00) },
                       { "昨日成绩：" .. data.old_layer , ccc3(0xff, 0xff, 0x00) },
                       { "当前成绩：" .. data.new_layer , ccc3(0xff, 0xff, 0x00) },
                       { "今日免费重置次数：" .. data.num  , ccc3(255, 255, 255) },
                       { "掉落："  , ccc3(255, 255, 255) },
                       { data.desc , ccc3(255, 255, 255) },
                      }
  for i = 1 , #strElement do
      local addY = i == 1 and 230 or ( 196 - ( i - 2 ) * 24 )
      layer:addChild( newLabel( strElement[i][1] , 20 , { x = 230, y = addY , color = strElement[i][2] } ) )
  end
  --重置
  local resetBtn = Btn:new( IMG_BTN , { "reset.png", "reset_pre.png"}, 380, 227, { 
    callback = function()
        MsgBox.create():flashShow("今日剩余免费重置次数为1，是否确认重置？" , { isConfirm = true , isCancel = true , confirmFun = function() dump("执行重置")end})
    end})
  layer:addChild(resetBtn:getLayer()) 
  --闯关
  local sprintBtn = Btn:new( IMG_BTN , { "sprint.png", "sprint_pre.png"}, 272, 12, { 
    callback = function()
        if tower then
          tower:removeFromParentAndCleanup( true )
          tower = nil
        end
        local scene = display.getRunningScene()
        tower = display.newSprite( PATH .. "tower_" .. data.type_id .. ".png"  , 22+90 , 15 + 125 , 0.5 , 0.5 )
        scene:addChild( tower )
        
        local spawnActionAry = CCArray:create()
        spawnActionAry:addObject( CCScaleTo:create(0.3, 3 ) )
        spawnActionAry:addObject( CCFadeOut:create( 0.3 ) )
        spawnActionAry:addObject( CCMoveTo:create( 0.3, ccp(display.cx , display.cy ) ) )
        local actionAry = CCArray:create()
        actionAry:addObject(  CCSpawn:create( spawnActionAry ) )
        actionAry:addObject(  CCCallFunc:create( function() self:createTower( { data = data } ) end ) )
        tower:runAction( CCSequence:create( actionAry ) )
       
    end})
  layer:addChild(sprintBtn:getLayer()) 
  
  --塔icon
  tower = display.newSprite( PATH .. "tower_" .. data.type_id .. ".png"  , 22+90 , 15 + 125 , 0.5 , 0.5 )
  layer:addChild( tower ) 
  
  layer:setContentSize( cellBg:getContentSize() )
  return layer
end
function M:createTower()
    if self.viewLayer then
      self.viewLayer:removeFromParentAndCleanup( true )
      self.viewLayer = nil 
      self.viewLayer = CCLayer:create()
      self.baseLayer:addChild( self.viewLayer )
    end
    
end
function M:getLayer()
	return self.baseLayer
end

return M
