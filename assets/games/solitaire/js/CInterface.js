function CInterface(){
    var _oAudioToggle;
    var _oButExit;
    var _oButHelp;
    var _oButRestart;
    var _oHelpPanel=null;
    var _oTimeText;
    var _oTimeDisplay;
    var _oTimeNum;
    var _oScoreDisplay;
    var _oScoreText;
    var _oScoreNum;
    var _oButFullscreen;
    var _oAreYouSurePanel;
    
    var _fRequestFullScreen = null;
    var _fCancelFullScreen = null;
    
    var _pStartPosExit;
    var _pStartPosAudio;
    var _pStartPosHelp;
    var _pStartPosRestart;
    var _pStartPosFullscreen;
    
    this._init = function(){                
        var oExitX;

        var oSprite = s_oSpriteLibrary.getSprite('but_exit');
        _pStartPosExit = {x: CANVAS_WIDTH - (oSprite.width/2)- 10, y: (oSprite.height/2) + 14};
        _oButExit = new CGfxButton(_pStartPosExit.x,_pStartPosExit.y,oSprite,s_oStage);
        _oButExit.addEventListener(ON_MOUSE_UP, this._onExit, this);
        
        oExitX = _pStartPosExit.x - (oSprite.width) - 10;
        
        if(DISABLE_SOUND_MOBILE === false || s_bMobile === false){

            var oSprite = s_oSpriteLibrary.getSprite('audio_icon');
            _pStartPosAudio = {x: oExitX, y: (oSprite.height/2) + 14};
            _oAudioToggle = new CToggle(_pStartPosAudio.x,_pStartPosAudio.y,oSprite,s_bAudioActive, s_oStage);
            _oAudioToggle.addEventListener(ON_MOUSE_UP, this._onAudioToggle, this);
            
            oExitX = oExitX - (oSprite.width/2) - 10;
            
        }

        var oSprite = s_oSpriteLibrary.getSprite('but_help');
        _pStartPosHelp = {x: oExitX, y: (oSprite.height/2) + 14};
        _oButHelp = new CGfxButton(_pStartPosHelp.x,_pStartPosHelp.y,oSprite,s_oStage);
        _oButHelp.addEventListener(ON_MOUSE_UP, this._onButHelpRelease, this);
        _oButHelp.setVisible(false);
        
        oExitX = oExitX - (oSprite.width) - 10;
        
        var oSprite = s_oSpriteLibrary.getSprite('but_restart');
        _pStartPosRestart = {x: oExitX, y: (oSprite.height/2) + 14};
        _oButRestart = new CGfxButton(_pStartPosRestart.x,_pStartPosRestart.y,oSprite,s_oStage);
        _oButRestart.addEventListener(ON_MOUSE_UP, this._onButRestartRelease, this);
        
        oExitX = oExitX - (oSprite.width) - 10;
        
        var doc = window.document;
        var docEl = doc.documentElement;
        _fRequestFullScreen = docEl.requestFullscreen || docEl.mozRequestFullScreen || docEl.webkitRequestFullScreen || docEl.msRequestFullscreen;
        _fCancelFullScreen = doc.exitFullscreen || doc.mozCancelFullScreen || doc.webkitExitFullscreen || doc.msExitFullscreen;

        if(ENABLE_FULLSCREEN === false){
            _fRequestFullScreen = false;
        }

        if (_fRequestFullScreen && screenfull.isEnabled){
            oSprite = s_oSpriteLibrary.getSprite("but_fullscreen");
            _pStartPosFullscreen = {x:oExitX,y:(oSprite.height/2) + 14};
            _oButFullscreen = new CToggle(_pStartPosFullscreen.x,_pStartPosFullscreen.y,oSprite,s_bFullscreen, s_oStage);
            _oButFullscreen.addEventListener(ON_MOUSE_UP,this._onFullscreenRelease,this);
        }
        
        _oTimeText = new CTLText(s_oStage, 
                    250, 98, 80, 28, 
                    24, "right", "#ffffff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_TIME,
                    true, true, false,
                    false );
                    

        
        var oSprite = s_oSpriteLibrary.getSprite('time_display');
        _oTimeDisplay = createBitmap(oSprite);
        _oTimeDisplay.scaleX=1.4;
        _oTimeDisplay.x = 332;
        _oTimeDisplay.y = 89;       
        s_oStage.addChild(_oTimeDisplay);
        
        _oTimeNum = new CTLText(s_oStage, 
                    342, 98, 70, 28, 
                    24, "center", "#ffffff", PRIMARY_FONT, 1,
                    0, 0,
                    "00:00",
                    true, true, false,
                    false );

        
        _oScoreText = new CTLText(s_oStage, 
                    440, 98, 80, 28, 
                    24, "right", "#ffffff", PRIMARY_FONT, 1,
                    0, 0,
                    TEXT_SCORE,
                    true, true, false,
                    false );

        
        var oSprite = s_oSpriteLibrary.getSprite('score_display');
        _oScoreDisplay = createBitmap(oSprite);
        _oScoreDisplay.x = 522;
        _oScoreDisplay.y = 89;       
        s_oStage.addChild(_oScoreDisplay);
        
        _oScoreNum = new CTLText(s_oStage, 
                    530, 98, 66, 28, 
                    24, "right", "#ffffff", PRIMARY_FONT, 1,
                    0, 0,
                    "0",
                    true, true, false,
                    false );
                    

        
        _oAreYouSurePanel = new CAreYouSurePanel(s_oStage);
        _oAreYouSurePanel.addEventListener(ON_BUT_YES_DOWN, this._onConfirmExit);
        
        this.refreshButtonPos(s_iOffsetX, s_iOffsetY);
    };
    
    this.refreshButtonPos = function(iNewX,iNewY){

        _oButExit.setPosition(_pStartPosExit.x - iNewX,_pStartPosExit.y);
        _oButHelp.setPosition(_pStartPosHelp.x - iNewX,_pStartPosHelp.y);
        _oButRestart.setPosition(_pStartPosRestart.x - iNewX,_pStartPosRestart.y);        
        if(DISABLE_SOUND_MOBILE === false || s_bMobile === false){
            _oAudioToggle.setPosition(_pStartPosAudio.x - iNewX,_pStartPosAudio.y);
        }
        if (_fRequestFullScreen && screenfull.isEnabled){
            
                _oButFullscreen.setPosition(_pStartPosFullscreen.x - iNewX, _pStartPosFullscreen.y + iNewY);
        }
       
    };
    
    this.unload = function(){
        if(DISABLE_SOUND_MOBILE === false || s_bMobile === false){
            _oAudioToggle.unload();
            _oAudioToggle = null;
        }
        if (_fRequestFullScreen && screenfull.isEnabled){
                _oButFullscreen.unload();
        }
        _oButExit.unload();
        _oButHelp.unload();
        _oButRestart.unload();
        if(_oHelpPanel!==null){
            _oHelpPanel.unload();
        }
        
        _oAreYouSurePanel = null;
        s_oInterface = null;
    };

    this.refreshScore = function(iValue){
        _oScoreNum.refreshText(iValue);
    };

    this.refreshTime = function(iValue){
        _oTimeNum.refreshText(iValue);
    };

    this.setVisibleButHelp = function(){
        _oButHelp.setVisible(true);
    };

    this._onButHelpRelease = function(){
        _oHelpPanel = new CHelpPanel();
    };
    
    this._onButRestartRelease = function(){
        s_oGame.restartGame();
        $(s_oMain).trigger("restart_level", 1);
        $(s_oMain).trigger("show_interlevel_ad");
    };
    
    this.onExitFromHelp = function(){
        _oHelpPanel.unload();
    };
    
    this._onAudioToggle = function(){
        Howler.mute(s_bAudioActive);
        s_bAudioActive = !s_bAudioActive;
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
    
    this._onExit = function(){
        _oAreYouSurePanel.show();
    };
    
    this._onConfirmExit = function(){
        s_oGame.onExit();
        $(s_oMain).trigger("end_level", 1);
        $(s_oMain).trigger("end_session");
        $(s_oMain).trigger("show_interlevel_ad");
    };
    
    s_oInterface = this;
    this._init();
    
	
    return this;
}

var s_oInterface = null;
