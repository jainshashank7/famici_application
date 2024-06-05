function CHelpPanel(){
    var _oText1;
    var _oText1Back;
    var _oText2;
    var _oText2Back;
    var _oText1BackPage2;
    var _oText1Page2;
    var _oText2BackPage2;
    var _oText2Page2;
    
    var _oTextWinPage2;
    var _oTextWinPage2Back;
    var _oTextWin2Page2;
    var _oTextWin2Page2Back;
    var _oTextLosePage2;
    var _oTextLosePage2Back;
    

    var _oHelpBg;
    var _oHelpBgPage2;
    var _oArrow;
    var _oArrowPage2;
    var _oGroup;
    var _oGroupPage2;
    var _oParent;
    var _oListener;

    this._init = function(){
        _oGroup = new createjs.Container();
        _oGroup.alpha=0;
        s_oStage.addChild(_oGroup);
        
        var oParent = this;
        _oHelpBg = createBitmap(s_oSpriteLibrary.getSprite('bg_help'));
         _oGroup.addChild(_oHelpBg);
         
        _oText1Back = new CTLText(_oGroup, 
                    CANVAS_WIDTH/2-348, (CANVAS_HEIGHT/2)-178, 400, 150, 
                    30, "center", "#000000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_HELP1,
                    true, true, true,
                    false );
                    

  
        _oText1 = new CTLText(_oGroup, 
                    CANVAS_WIDTH/2-350, (CANVAS_HEIGHT/2)-180, 400, 150, 
                    30, "center", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_HELP1,
                    true, true, true,
                    false );
                    
            
  
        _oText2Back = new CTLText(_oGroup, 
                    CANVAS_WIDTH/2-348, (CANVAS_HEIGHT/2)+52, 400, 150, 
                    30, "center", "#000000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_HELP2,
                    true, true, true,
                    false );
                    
  
        _oText2 = new CTLText(_oGroup, 
                    CANVAS_WIDTH/2-350, (CANVAS_HEIGHT/2)+50, 400, 150, 
                    30, "center", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_HELP2,
                    true, true, true,
                    false );

        createjs.Tween.get(_oGroup).to({alpha:1}, 700).call(function(){s_oGame.pauseGame()});        
        
        _oListener = _oGroup.on("pressup",function(){oParent._onExitHelp()});
        
        
        _oGroupPage2 = new createjs.Container();
        _oGroupPage2.visible=0;
        s_oStage.addChild(_oGroupPage2);
        
        _oGroupPage2.on("pressup",function(){oParent._onExitHelp()});
        
        _oHelpBgPage2 = createBitmap(s_oSpriteLibrary.getSprite('msg_box'));
        _oGroupPage2.addChild(_oHelpBgPage2);
                            
        _oText1BackPage2 = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2 -248, (CANVAS_HEIGHT/2)-198, 500, 30, 
                    30, "center", "#000000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_HELP1_PAGE2,
                    true, true, false,
                    false );
                    
        
  
        _oText1Page2 = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2-250 , (CANVAS_HEIGHT/2)-200, 500, 30, 
                    30, "center", "#ffffff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_HELP1_PAGE2,
                    true, true, false,
                    false );
                    
            
  
        _oText2BackPage2 = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2 -328, (CANVAS_HEIGHT/2)-98, 660, 28, 
                    28, "center", "#000000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_HELP2_PAGE2,
                    true, true, false,
                    false );
                    
  
        _oText2Page2 = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2 -330, (CANVAS_HEIGHT/2)-100, 660, 28, 
                    28, "center", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_HELP2_PAGE2,
                    true, true, false,
                    false );
                    


        _oTextWinPage2Back = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2 -329, (CANVAS_HEIGHT/2)-19, 660, 28, 
                    28, "left", "#000000", PRIMARY_FONT, 1,
                    0, 0,
                    "+" +POINTS_TO_SUIT + TEXT_WIN_PAGE2,
                    true, true, false,
                    false );
                    
        


        _oTextWinPage2 = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2 -330, (CANVAS_HEIGHT/2)-20, 660, 28, 
                    28, "left", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    "+" +POINTS_TO_SUIT + TEXT_WIN_PAGE2,
                    true, true, false,
                    false );
                    

        _oTextWin2Page2Back = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2 -329, (CANVAS_HEIGHT/2)+31, 660, 28, 
                    28, "left", "#000000", PRIMARY_FONT, 1,
                    0, 0,
                    "+" +POINTS_TO_BOARD + TEXT_WIN2_PAGE2,
                    true, true, false,
                    false );
                    
        


        _oTextWin2Page2 = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2 -329, (CANVAS_HEIGHT/2)+30, 660, 28, 
                    28, "left", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    "+" +POINTS_TO_BOARD + TEXT_WIN2_PAGE2,
                    true, true, false,
                    false );
                    

        
        var _oTimeFormat = formatTime(LOSEPOINTS_TIMER);
        
        _oTextLosePage2Back = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2 -329, (CANVAS_HEIGHT/2)+81, 660, 28, 
                    28, "left", "#000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_LOSE1_PAGE2 + POINTS_TO_LOSE + TEXT_LOSE2_PAGE2 + _oTimeFormat + TEXT_LOSE3_PAGE2,
                    true, true, false,
                    false );
                    


        _oTextLosePage2 = new CTLText(_oGroupPage2, 
                    CANVAS_WIDTH/2 -330, (CANVAS_HEIGHT/2)+80, 660, 28, 
                    28, "left", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_LOSE1_PAGE2 + POINTS_TO_LOSE + TEXT_LOSE2_PAGE2 + _oTimeFormat + TEXT_LOSE3_PAGE2,
                    true, true, false,
                    false );
        
        

        createjs.Tween.get(_oGroupPage2).to({alpha:1}, 700);
        
        _oArrow = createBitmap(s_oSpriteLibrary.getSprite('arrow'));
        _oArrow.x = 1200;
        _oArrow.y = 500 ;
        _oArrow.alpha=0;
        _oArrow.on("click", oParent._changePageTo2);
        s_oStage.addChild(_oArrow);
        
        _oArrowPage2 = createBitmap(s_oSpriteLibrary.getSprite('arrow'));
        _oArrowPage2.scaleX = -1;
        _oArrowPage2.x = 400;
        _oArrowPage2.y = 500;
        _oArrowPage2.visible=false;
        _oArrowPage2.on("click", oParent._changePageTo1);
        s_oStage.addChild(_oArrowPage2);
        
        createjs.Tween.get(_oArrow).to({alpha:1}, 700);
        
    };

    this.unload = function(){
        s_oStage.removeChild(_oGroup, _oGroupPage2, _oArrow, _oArrowPage2);

        var oParent = this;
        _oGroup.off("pressup",_oListener);
    };

    this._changePageTo1 = function(){ 
        _oGroupPage2.visible=false;
        _oArrowPage2.visible=false;

        _oGroup.visible=true;
        _oArrow.visible=true;

    };

    this._changePageTo2 = function(){        
        _oGroup.visible=false;
        _oArrow.visible=false;

        _oGroupPage2.visible=true;
        _oArrowPage2.visible=true;
        
    };

    this._onExitHelp = function(){
        _oParent.unload();
        $(s_oMain).trigger("show_interlevel_ad");
        s_oGame._onExitHelp();
    };

    _oParent=this;
    this._init();

}
