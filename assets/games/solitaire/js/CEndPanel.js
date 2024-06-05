function CEndPanel(oSpriteBg){
    
    var _oBg;
    var _oGroup;
    
    var _oMsgTextBack;
    var _oMsgText;
    var _oScoreTextBack;
    var _oScoreText;
    var _oListener;
    
    this._init = function(oSpriteBg){
        _oGroup = new createjs.Container();
        _oGroup.alpha = 0;
        _oGroup.visible=false;
        s_oStage.addChild(_oGroup);
        
        _oBg = createBitmap(oSpriteBg);
        _oGroup.addChild(_oBg);
        
	_oMsgTextBack = new CTLText(_oGroup, 
                    CANVAS_WIDTH/2-298, (CANVAS_HEIGHT/2)-158, 600, 70, 
                    70, "center", "#000", PRIMARY_FONT, 1,
                    0, 0,
                    " ",
                    true, true, false,
                    false );
                    


        _oMsgText = new CTLText(_oGroup, 
                    CANVAS_WIDTH/2-300, (CANVAS_HEIGHT/2)-160, 600, 70, 
                    70, "center", "#ffffff", PRIMARY_FONT, 1,
                    0, 0,
                    " ",
                    true, true, false,
                    false );
                    

        
        _oScoreTextBack = new CTLText(_oGroup, 
                    CANVAS_WIDTH/2-298, (CANVAS_HEIGHT/2)+52, 600, 40, 
                    40, "center", "#000", PRIMARY_FONT, 1,
                    0, 0,
                    " ",
                    true, true, false,
                    false );
                    

        
        _oScoreText = new CTLText(_oGroup, 
                    CANVAS_WIDTH/2-300, (CANVAS_HEIGHT/2)+50, 600, 40, 
                    40, "center", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    " ",
                    true, true, false,
                    false );

        
    };
    
    this.unload = function(){
        _oGroup.off("mousedown",_oListener);
    };
    
    this._initListener = function(){
        _oListener = _oGroup.on("mousedown",this._onExit);
    };
    
    this.show = function(iScore){
        playSound("game_over", 1, false);
        
        _oMsgTextBack.refreshText(TEXT_GAMEOVER);
        _oMsgText.refreshText(TEXT_GAMEOVER);
        
        _oScoreTextBack.refreshText(TEXT_SCORE +": "+iScore);
        _oScoreText.refreshText(TEXT_SCORE +": "+iScore);
        
        _oGroup.visible = true;
        
        var oParent = this;
        createjs.Tween.get(_oGroup).to({alpha:1 }, 500).call(function() {oParent._initListener();});
        
        $(s_oMain).trigger("save_score",[iScore, s_bEasyMode]);        
        $(s_oMain).trigger("end_level",1);
        
        $(s_oMain).trigger("share_event",[iScore]);
        
    };
    
    this._onExit = function(){
        _oGroup.off("mousedown",_oListener);
        s_oStage.removeChild(_oGroup);
        
        $(s_oMain).trigger("end_session");
        
        s_oGame.onExit();
    };
    
    this._init(oSpriteBg);
    
    return this;
}
