function CCard(iX,iY,oParentContainer,szFotogram,iRank,iSuit){
    var _bPlaced=false;
    var _bValue=true;        
    var _bTurned;
    
    var _szType;
    var _szColor;
    var _szFotogram;
    var _iRank;
    var _iScaleOrig = 0.6;
    
    var _iSuit;
    var _iFirstDrag;
    var _iDepth;
    
      
    var _aCbCompleted;
    var _aCbOwner;
    
    var _oCardSprite;
    var _oHitArea;
    var _oContainer;
    var _oParentContainer;   
    var _oThisCard;
    var _oParent;
    var _oOldPos;
    var _oListener;

    
    this._init = function(iX,iY,oParentContainer,szFotogram,iRank,iSuit){
        _oParentContainer = oParentContainer;
        _szFotogram = szFotogram;
        _iRank = iRank;
        _iSuit = iSuit;
        _iFirstDrag = 0;
        _bTurned = false;
        _szType = "deck";
        
        if(_iSuit===0 || _iSuit=== 2){
            _szColor = "red";
        } else {
            _szColor = "black";
        }
        
        _oContainer = new createjs.Container();
        _oContainer.x = iX;
        _oContainer.y = iY;
        _oContainer.scaleX = _oContainer.scaleY=_iScaleOrig;
        _oParentContainer.addChild(_oContainer);
        
        
        var oSprite = s_oSpriteLibrary.getSprite('card_spritesheet');
        var aSprites = new Array();
        for(var k=0;k<53;k++){
            aSprites[k] = s_oSpriteLibrary.getSprite("card_"+k);
        }
        var oData = {   // image to use
                        images: aSprites, 
                        // width, height & registration point of each sprite
                        frames: {width: CARD_WIDTH, height: CARD_HEIGHT,regX:CARD_WIDTH/2,regY:CARD_HEIGHT/2}, 
                        animations: {  card_1_1: [0],card_1_2:[1],card_1_3:[2],card_1_4:[3],card_1_5:[4],card_1_6:[5],card_1_7:[6],card_1_8:[7],
                                       card_1_9:[8],card_1_10:[9],card_1_J:[10],card_1_Q:[11],card_1_K:[12],
                                       card_2_1: [13],card_2_2:[14],card_2_3:[15],card_2_4:[16],card_2_5:[17],card_2_6:[18],card_2_7:[19],
                                       card_2_8:[20], card_2_9:[21],card_2_10:[22],card_2_J:[23],card_2_Q:[24],card_2_K:[25],
                                       card_3_1: [26],card_3_2:[27],card_3_3:[28],card_3_4:[29],card_3_5:[30],card_3_6:[31],card_3_7:[32],
                                       card_3_8:[33], card_3_9:[34],card_3_10:[35],card_3_J:[36],card_3_Q:[37],card_3_K:[38],
                                       card_4_1: [39],card_4_2:[40],card_4_3:[41],card_4_4:[42],card_4_5:[43],card_4_6:[44],card_4_7:[45],
                                       card_4_8:[46], card_4_9:[47],card_4_10:[48],card_4_J:[49],card_4_Q:[50],card_4_K:[51],back:[52]}
                        
        };

        var oSpriteSheet = new createjs.SpriteSheet(oData);
        
        _oCardSprite = createSprite(oSpriteSheet,"back",0,0,CARD_WIDTH,CARD_HEIGHT);
        _oCardSprite.stop();
        _oContainer.addChild(_oCardSprite);
        
        _oHitArea = new createjs.Shape();
        _oHitArea.graphics.beginFill("rgba(255,255,255,0.01)").drawRect(-CARD_WIDTH/2, -CARD_HEIGHT/2, CARD_WIDTH, CARD_HEIGHT);
        _oListener = _oHitArea.on("mousedown",this._mouseDown);
        _oContainer.addChild(_oHitArea);
       
        _aCbCompleted=new Array();
        _aCbOwner =new Array();
        
    };
    
    this.unload = function(){
        _oHitArea.off("mousedown",_oListener);
        _oParentContainer.removeChild(_oContainer);
        
    };
    
    this.addEventListener = function( iEvent,cbCompleted, cbOwner ){
        _aCbCompleted[iEvent]=cbCompleted;
        _aCbOwner[iEvent] = cbOwner; 
    };
    
    this.saveInfo = function(){
        return {szFotogram : _szFotogram, iRank: _iRank, iSuit: _iSuit, bValue:_bValue}; 
    };
    
    this.changeInfo = function(szFotogram,iRank,iSuit){
        _szFotogram = szFotogram;
        _iRank = iRank;
        _iSuit = iSuit;
    };
    
    this.instantShow = function (){
        _oCardSprite.gotoAndStop(_szFotogram);
        //this.cardShown();
    };
    
    this.setValue = function(){
        _oCardSprite.gotoAndStop(_szFotogram);
        
        playSound("card", 1, false);
        
        var oParent = this;
        createjs.Tween.get(_oContainer).to({scaleX:_iScaleOrig}, 200).call(function(){oParent.cardShown();_oParent._aceInPlace()})
    };
    
    this._aceInPlace = function(){
        if(_iRank===1){
            s_oGame.autoMoveAce(this);
        }
    };
    
    this.setType = function (szType){
        _szType=szType;
    };
    
    this.checkType = function(){
        return _szType;
    };
    
    this.setActive = function(bVar){
        if(bVar){
            _oContainer.addChild(_oHitArea);
        } else {
            _oContainer.removeChild(_oHitArea);
        }
    };
    
    this._void = function(){
        return;
    };
    
    this.setVisible = function(bVar){
        if(bVar===true){
            _oContainer.visible=true;
        } else {
            _oContainer.visible=false;
        }
        
    };
    
    this.moveCard = function(iX, iY, iTime,iDelay){        
        createjs.Tween.get(_oContainer).wait(iDelay).to({x:iX, y:iY}, iTime, createjs.Ease.linear).call(function(){_oParent.setPlaced()});
    };

    this.moveCardWithIndex = function(iX, iY, iTime,iDelay, iIndex){  
        
        createjs.Tween.get(_oContainer).wait(iDelay).to({x:iX, y:iY}, iTime, createjs.Ease.linear).call(function(){
            _oParent.setPlacedWithIndex(iIndex);
        });
    };


    this.returnInPlace = function (iX, iY){
        if(_szType!=="deck"){
            createjs.Tween.get(_oContainer).to({x:iX, y:iY}, 150, createjs.Ease.cubicOut).call(function(){_bTurned=true});
        } else  {
            createjs.Tween.get(_oContainer).to({x:iX, y:iY}, 150, createjs.Ease.cubicOut).call(function(){_bTurned=true}).call(function(){s_oGame.setPreviousCardVisible(_oParent, _szType)});
        }
    };

    this.stackInPlace = function (iX, iY){
        createjs.Tween.get(_oContainer).to({x:iX, y:iY}, 150, createjs.Ease.cubicOut).call(function(){_bTurned=true});       
    };


    this.setPlaced = function(){
        _bPlaced=true;
        s_oGame.scaleDepth(this.getSprite());
    };

    this.setPlacedWithIndex = function(iIndex){
        _bPlaced=true;
        s_oGame.scaleDepthWithIndex(this.getSprite(), iIndex);
    };


    this._mouseDown = function(event){
        if(_bTurned=== false){
            return;
        }
        _oOldPos = {x: _oContainer.x , y: _oContainer.y };
        _iDepth = _oParentContainer.getChildIndex(_oContainer);
        s_oGame.pickCard(_oParent,event);
    };
    
    this.getPlaced = function(){
        return _bPlaced;
    };
        
    this.showCard = function(){
        s_oGame.blockGame(true);
        var oParent = this;
        createjs.Tween.get(_oContainer ).to({scaleX:0.1}, 200).call(function(){oParent.setValue()}).call(function(){_bTurned=true});
    };
		
    this.hideCard = function(){
        var oParent = this;
        createjs.Tween.get(_oContainer).to({scaleX:0.1}, 200).call(function(){oParent.setBack()});
    };
    
    this.setOldPos = function(iX, iY, iDepth){
        _oOldPos.x = iX;
        _oOldPos.y = iY;
        _iDepth = iDepth;
    };
    
    this.setPos = function(iX, iY){
        _oContainer.x = iX;
        _oContainer.y = iY;
    };
    
    this.setBack = function(){
        _bTurned=false;
        _oCardSprite.gotoAndStop("back");
        var oParent = this;
        //this.removeDrag();
        createjs.Tween.get(_oContainer).to({scaleX:_iScaleOrig}, 200).call(function(){oParent.cardHidden()});
    };
		
    this.cardShown = function(){
        s_oGame.blockGame(false);
		//alert("CARD SHOWN");
    };
    
    this.cardHidden = function(){
        if(_aCbCompleted[ON_CARD_HIDE]){
            _aCbCompleted[ON_CARD_HIDE].call(_aCbOwner[ON_CARD_HIDE],this);
        }
    };


    this._onSelected = function(){
        s_oGame.onCardSelected(_oThisCard);
    };
    
    this.getPointValue = function(){
        return _bValue;
    };
    
    this.setPointValue = function(bValue){
        _bValue = bValue;
    };
    
    this.getRank = function(){
        return _iRank;
    };
		
    this.getSuit = function(){
        return _iSuit;
    };

    this.getColor = function(){
        return _szColor;
    };
    
    this.getFotogram = function(){
        return _szFotogram;
    };
    
    this.getPos = function(){
        return {x: _oContainer.x, y: _oContainer.y};
    };
    
    this.getSprite = function(){
        return _oContainer;
    };
    
    this.getLogicRect = function(){
        return new createjs.Rectangle(_oContainer.x - CARD_WIDTH/2,_oContainer.y - CARD_HEIGHT/2,CARD_WIDTH,CARD_HEIGHT);
    };
    
    this.getTurnedValue = function(){
        return _bTurned;
    };
    
    this.getVisible = function(){
        return _oContainer.visible;
    };
    
    _oThisCard = this;
    
    _oParent=this;
    this._init(iX,iY,oParentContainer,szFotogram,iRank,iSuit);
                
}