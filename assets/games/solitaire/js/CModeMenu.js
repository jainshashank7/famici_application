function CModeMenu(){
    var _oBg;
    var _oContainerEasy;
    var _oContainerNormal;
    var _oBorder1;
    var _oMode1;
    var _oTextModeBack1;
    var _oTextMode1;
    var _oTextEasyBack;
    var _oTextEasy;
    var _oBorder3;
    var _oMode3;
    var _oTextModeBack3;
    var _oTextMode3;
    var _oTextNormalBack;
    var _oTextNormal;
    
    var _oTextTopBack;
    var _oTextTop;
    
    var _oParent;
    
    var _oFade;
    var _oAudioToggle;
    var _oButExit;
    var _oButFullscreen;
    
    var _fRequestFullScreen = null;
    var _fCancelFullScreen = null;
    
    var _pStartPosAudio; 
    var _pStartPosExit;
    var _pStartPosFullscreen;
    
    this._init = function(){
        _oBg = createBitmap(s_oSpriteLibrary.getSprite('bg_difficulty'));
        s_oStage.addChild(_oBg);
        
        var oTable = s_oSpriteLibrary.getSprite('layout_panel');
        
        var oTablePos = {x: CANVAS_WIDTH/4, y: 374};//Set symmetrical position of the modality buttons
        
        _oContainerEasy = new createjs.Container();
        _oContainerEasy.x = oTablePos.x;
        _oContainerEasy.y = oTablePos.y;
        if (!s_bMobile){
            _oContainerEasy.cursor = "pointer";
	}
        
        _oContainerNormal = new createjs.Container();
        _oContainerNormal.x = CANVAS_WIDTH - oTablePos.x - oTable.width;
        _oContainerNormal.y = oTablePos.y; 
        if (!s_bMobile){
            _oContainerNormal.cursor = "pointer";
	}
        
        var oTable1 = s_oSpriteLibrary.getSprite('layout_panel');
        _oBorder1 = createBitmap(oTable1);
        _oContainerEasy.addChild(_oBorder1);
        
        _oMode1 = createBitmap(s_oSpriteLibrary.getSprite('layout_1_card'));
        _oMode1.x = 35;
        _oMode1.y = 115;        
        _oContainerEasy.addChild(_oMode1);

        _oTextModeBack1 = new CTLText(_oContainerEasy, 
                    11, 66, 226, 28, 
                    28, "center", "#000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_MODE_1,
                    true, true, false,
                    false );
                    


        _oTextMode1 = new CTLText(_oContainerEasy, 
                    10, 65, 226, 28, 
                    28, "center", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_MODE_1,
                    true, true, false,
                    false );
                    
       

        _oTextEasyBack = new CTLText(_oContainerEasy, 
                    11, 8, 226, 34, 
                    34, "center", "#000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_EASY,
                    true, true, false,
                    false );


        _oTextEasy = new CTLText(_oContainerEasy, 
                    10, 7, 226, 34, 
                    34, "center", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_EASY,
                    true, true, false,
                    false );

        
        

        oTable = s_oSpriteLibrary.getSprite('layout_panel');
        _oBorder3 = createBitmap(oTable);       
        _oContainerNormal.addChild(_oBorder3);        
        
        _oMode3 = createBitmap(s_oSpriteLibrary.getSprite('layout_3_card'));
        _oMode3.x =22;
        _oMode3.y =115;        
        _oContainerNormal.addChild(_oMode3);
        
        _oTextModeBack3 = new CTLText(_oContainerNormal, 
                    11, 66, 226, 28, 
                    28, "center", "#000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_MODE_3,
                    true, true, false,
                    false );
                    

        
        _oTextMode3 = new CTLText(_oContainerNormal, 
                    10, 65, 226, 28, 
                    28, "center", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_MODE_3,
                    true, true, false,
                    false );
        
        _oTextNormalBack = new CTLText(_oContainerNormal, 
                    11, 8, 226, 34, 
                    34, "center", "#000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_NORMAL,
                    true, true, false,
                    false );
                    

        
        _oTextNormal = new CTLText(_oContainerNormal, 
                    11, 8, 226, 34, 
                    34, "center", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_NORMAL,
                    true, true, false,
                    false );
                    

        
        _oTextTopBack = new CTLText(s_oStage, 
                    CANVAS_WIDTH/2-398, (CANVAS_HEIGHT/2)-94, 800, 52, 
                    52, "center", "#000", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_TOP_MODE,
                    true, true, false,
                    false );

        
        _oTextTop = new CTLText(s_oStage, 
                    CANVAS_WIDTH/2-400, (CANVAS_HEIGHT/2)-96, 800, 52, 
                    52, "center", "#fff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_TOP_MODE,
                    true, true, false,
                    false );

        s_oStage.addChild(_oContainerEasy);
        s_oStage.addChild(_oContainerNormal);
        
        var graphics = new createjs.Graphics().beginFill("rgba(158,158,158,0.01)").drawRect(4, 0, 240, 250);
        var _oTargetDebug = new createjs.Shape(graphics);
        _oContainerEasy.addChild(_oTargetDebug);
        _oTargetDebug.on("mousedown", this._resizeEasy);
        _oTargetDebug.on("pressup", this._selectEasy);
        
        var _oNormalButton = new createjs.Shape(graphics);
        _oContainerNormal.addChild(_oNormalButton);
        _oNormalButton.on("mousedown", this._resizeNormal);
        _oNormalButton.on("pressup", this._selectNormal);        
       
        var oSprite = s_oSpriteLibrary.getSprite('but_exit');
        _pStartPosExit = {x: CANVAS_WIDTH - (oSprite.width/2)- 10, y: (oSprite.height/2) + 14};
        _oButExit = new CGfxButton(_pStartPosExit.x,_pStartPosExit.y,oSprite,s_oStage);
        _oButExit.addEventListener(ON_MOUSE_UP, this._onExit, this);
        
        var oExitX = _pStartPosExit.x - (oSprite.width)- 10;

        if(DISABLE_SOUND_MOBILE === false || s_bMobile === false){
            var oSprite = s_oSpriteLibrary.getSprite('audio_icon');
            _pStartPosAudio = {x: oExitX, y: (oSprite.height/2) + 14};
            _oAudioToggle = new CToggle(_pStartPosAudio.x,_pStartPosAudio.y,oSprite,s_bAudioActive, s_oStage);
            _oAudioToggle.addEventListener(ON_MOUSE_UP, this._onAudioToggle, this);          
        }

        var doc = window.document;
        var docEl = doc.documentElement;
        _fRequestFullScreen = docEl.requestFullscreen || docEl.mozRequestFullScreen || docEl.webkitRequestFullScreen || docEl.msRequestFullscreen;
        _fCancelFullScreen = doc.exitFullscreen || doc.mozCancelFullScreen || doc.webkitExitFullscreen || doc.msExitFullscreen;

        if(ENABLE_FULLSCREEN === false){
            _fRequestFullScreen = false;
        }

        if (_fRequestFullScreen && screenfull.isEnabled){
            oSprite = s_oSpriteLibrary.getSprite("but_fullscreen");
            _pStartPosFullscreen = {x: (oSprite.width/4) + 10, y: (oSprite.height/2) + 14};            
            _oButFullscreen = new CToggle(_pStartPosFullscreen.x,_pStartPosFullscreen.y,oSprite,s_bFullscreen, s_oStage);
            _oButFullscreen.addEventListener(ON_MOUSE_UP,this._onFullscreenRelease,this);
        }

        _oFade = new createjs.Shape();
        _oFade.graphics.beginFill("black").drawRect(0,0,CANVAS_WIDTH,CANVAS_HEIGHT);
        
        s_oStage.addChild(_oFade);
        
        createjs.Tween.get(_oFade).to({alpha:0}, 1000).call(function(){_oFade.visible = false;});  
        
        this.refreshButtonPos(s_iOffsetX, s_iOffsetY);
    };
    
    this.refreshButtonPos = function(iNewX,iNewY){
        _oButExit.setPosition(_pStartPosExit.x - iNewX,iNewY + _pStartPosExit.y);
        if(DISABLE_SOUND_MOBILE === false || s_bMobile === false){
            _oAudioToggle.setPosition(_pStartPosAudio.x - iNewX,_pStartPosAudio.y);
        }
        if (_fRequestFullScreen && screenfull.isEnabled){
                _oButFullscreen.setPosition(_pStartPosFullscreen.x + iNewX, _pStartPosFullscreen.y + iNewY);
        }
       
    };
    
    this._resizeEasy = function(){
        _oContainerEasy.x=_oContainerEasy.x +10;
        _oContainerEasy.y=_oContainerEasy.y +10;
        _oContainerEasy.scaleX=0.9;
        _oContainerEasy.scaleY=0.9;
        
    };
    
    this._selectEasy = function(){
        
        playSound("click", 1, false);
        
        _oParent.unload();
        s_oMain.gotoGame(true);
    };
    
    this._resizeNormal = function(){
        _oContainerNormal.x=_oContainerNormal.x +10;
        _oContainerNormal.y=_oContainerNormal.y +10;
        _oContainerNormal.scaleX=0.9;
        _oContainerNormal.scaleY=0.9;
        
    };
    
    this._selectNormal = function(){
        
        playSound("click", 1, false);
        _oParent.unload();
        s_oMain.gotoGame(false);
    };
    
    this.unload = function(){
        _oButExit.unload();
        if(DISABLE_SOUND_MOBILE === false || s_bMobile === false){
            _oAudioToggle.unload();
            _oAudioToggle = null;
        }
        
        if (_fRequestFullScreen && screenfull.isEnabled){
                _oButFullscreen.unload();
        }
        
        s_oStage.removeChild(_oBg, _oContainerEasy, _oContainerNormal);
        _oBg = null;
        
        s_oModeMenu = null;
    };
    
    this.resetFullscreenBut = function(){
        if (_fRequestFullScreen && screenfull.isEnabled){
            _oButFullscreen.setActive(s_bFullscreen);
        }
    };
        
    this._onFullscreenRelease = function(){
	if(s_bFullscreen) { 
		_fCancelFullScreen.call(window.document);
	}else{
		_fRequestFullScreen.call(window.document.documentElement);
	}
	
	sizeHandler();
    };
    
    this._onAudioToggle = function(){
        Howler.mute(s_bAudioActive);
        s_bAudioActive = !s_bAudioActive;
    };

    this._onExit = function(){
        s_oModeMenu.unload();
        s_oMain.gotoMenu();
    };

    _oParent=this;
    s_oModeMenu = this;
    this._init();
}

var s_oModeMenu = null;