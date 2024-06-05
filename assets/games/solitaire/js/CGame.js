function CGame(oData){
    var _bInitGame=true;
    var _bStartGame;
    var _bTouchActive;
    var _bBlock = true;
    var _bBoardSnapped=false;
    var _bSecondStage;
    
    var _iScore;
    var _iTimer;
    var _iTimeElaps;
    var _iCardPoints;
    var _iStackOffsetBack;
    var _iStartCont;
    var _iDepth;
    var _iCurDepth;
    var _iCurMaxCardDepth;
    var _iCont;
    var _iTurnCardCont;
    var _iCurPos;
    var _iMouseOffset;
    var _iStackCard;
    var _iCurActiveCard;
    var _iDeck3Cont;
   
    var _aCard;
    var _aStackCard;
    var _aDeckCard;
    var _aCardStartPos;
    var _aSuitPos;
    var _aDeckPos;
    var _aGridMatrix;
    var _aBackCard;
    var _aSnapKing;
    var _aSuitRect;
    var _aCurRank;
    var _aCardDeck3Index;
    var _aScoreSuit;
    
    var _oInterface;
    var _oEndPanel = null;
    var _oCardContainer;
    var _oContainerDeckArea;
    var _oParent;
    var _oDeckArea;
    var _oSuitCard;
    var _oDeckCard;
    var _oStartLogicCardPos;
    var _oAudioCard;
    
    this._init = function(){
        
        _bInitGame=true;
        _bBlock = true;
        _bBoardSnapped=false;
        _bStartGame=false;
        _bSecondStage=false;
        

        playSound("card_dealing", 1, true);
        
       
        _aCard = new Array();
        _aDeckCard = new Array();
        _aStackCard = new Array();
        _aCardDeck3Index = new Array();
        
        _aScoreSuit = new Array();
        for(var i=0; i<4; i++){
            _aScoreSuit[i]=1;
        }
        
        _aCurRank = new Array();
        for(var i=0; i<4; i++){
            _aCurRank[i]=1;
        }
        
        _aSnapKing = new Array();
        for(var i=0; i<7; i++){
            _aSnapKing[i]=null;
        }
        
        _aBackCard = new Array();
        for(var i=0; i<7; i++){
            _aBackCard[i]=i;
        }
        
        _iScore=0;
        _iTimer=0;
        _iTimeElaps=0;
        _iCardPoints=10;
        _iDepth=0;
        _iStackOffsetBack = 11;
        _iStackCard = 26;
        _iCont=0;
        _iTurnCardCont=-1;
        _iDeck3Cont=-1;
        _iCurActiveCard=2;
        
        _iStartCont = 0;
        _aCardStartPos = new Array();
        for (var i=0; i<7; i++){
            for (var j=i; j<7; j++){                
                _aCardStartPos[_iStartCont]={x: 624+j*111, y:230+i*_iStackOffsetBack};
                _iStartCont++;
            }            
        }        
        
        _aSuitPos = new Array();        
        _aSuitPos[0]={x: 312, y:453};
        _aSuitPos[1]={x: 423, y:453};
        _aSuitPos[2]={x: 312, y:610};
        _aSuitPos[3]={x: 423, y:610};
        
        _aSuitRect = new Array();
        for(var i=0; i<_aSuitPos.length; i++){
            _aSuitRect[i] = new createjs.Rectangle(
                        _aSuitPos[i].x - CARD_WIDTH/2,_aSuitPos[i].y - CARD_HEIGHT/2,
                        CARD_WIDTH,CARD_HEIGHT);
        }
        
        _aDeckPos = new Array();
        _aDeckPos[0] = {x: 312, y:231};
        _aDeckPos[1] = {x: 423, y:231};
        _aDeckPos[2] = {x: 443, y:241};
        _aDeckPos[3] = {x: 463, y:251};
        
        
        _aGridMatrix = new Array();
        for (var i=0; i<19; i++){
            _aGridMatrix[i]= new Array();
            for (var j=0; j<7; j++){
                _aGridMatrix[i][j]= {status:LABEL_EMPTY, oCard:null};
            }
        }
        
        _bTouchActive=false;
        
        var oBg = createBitmap(s_oSpriteLibrary.getSprite('bg_game'));
        s_oStage.addChild(oBg); //Draws on canvas
        
        var oButRetCard = createBitmap(s_oSpriteLibrary.getSprite('but_return_cards'));
        oButRetCard.x = 275;
        oButRetCard.y = 194;
        s_oStage.addChild(oButRetCard);

        _oCardContainer = new createjs.Container();
        s_oStage.addChild(_oCardContainer);
        
	_oDeckContainer = new createjs.Container();
        s_oStage.addChild(_oDeckContainer);

        _oContainerDeckArea = new createjs.Container();
        var graphics = new createjs.Graphics().beginFill("rgba(158,158,158,0.01)").drawRect(267, 159, 90, 140);
        _oDeckArea = new createjs.Shape(graphics);
        
        if(s_bEasyMode){

            _oDeckArea.on("click", this._turnCard);
        }else {

            _oDeckArea.on("click", this._turn3Card);
        }
        
        _oContainerDeckArea.addChild(_oDeckArea);
        s_oStage.addChild(_oContainerDeckArea);

        this._shuffleCard();        
        this._setBoard();
        
        _iCurMaxCardDepth=52;
        
        _oInterface = new CInterface();
    
        //TOUCH EVENTS
        s_oStage.addEventListener( 'stagemousemove', this.dragCard, false );
        s_oStage.addEventListener( 'stagemouseup', this.releaseCard, false );

        $(s_oMain).trigger("start_level",1);
    };
    
    this._calculateScore = function(oCard, iPoint){
        this.updateScore(iPoint);
        
        var oScore = new CScore();
        oScore.showScore(oCard.getPos(), iPoint);
    };
    
    this._calculateScoreOnDeck = function(oCard, iPoint){
        if(_aScoreSuit[oCard.getSuit()]===oCard.getRank()){
            
            playSound("snap", 1, false);
            
            this.updateScore(iPoint);
            var oScore = new CScore();
            oScore.showScore(oCard.getPos(), iPoint);
            _aScoreSuit[oCard.getSuit()]++;
        }
        
 
    };

    this.updateScore = function(iPoint){
        _iScore+=iPoint;
        if(_iScore<0){
            _iScore=0;
        }
    };
    
    this.updateVisualScore = function(){
        _oInterface.refreshScore(_iScore);
    };
    
    this._shuffleCard = function(){
        
        var iSuit = -1;
        var aCardDeck=new Array();
        for(var j=0;j<52;j++){
            var iRest=(j+1)%13;
            if(iRest === 1){
                iSuit++;
            }else if(iRest === 0){
                iRest = 13;
            }
            aCardDeck.push({fotogram:j,rank:iRest,suit:iSuit});
        }
        
        
        var aTmpDeck=new Array();

        for(var i=0;i<aCardDeck.length;i++){
                aTmpDeck[i]=aCardDeck[i];
        }

        var aShuffledCardDecks = new Array();
        while (aTmpDeck.length > 0) {
                aShuffledCardDecks.push(aTmpDeck.splice(Math.round(Math.random() * (aTmpDeck.length - 1)), 1)[0]);
        }
        
        for(var i=0; i<aShuffledCardDecks.length; i++){
            _aCard[i] = new CCard(_aDeckPos[0].x-(i/DECK_CARD_OFFSET),_aDeckPos[0].y-(i/DECK_CARD_OFFSET),_oCardContainer,
                                                aShuffledCardDecks[i].fotogram,aShuffledCardDecks[i].rank,aShuffledCardDecks[i].suit);            
        }
    };
    
    this.blockGame = function(bBlock){
        _bBlock = bBlock;
    };
    
    
    this._setBoard = function(){
        var iDelay=0;
        var iTimeMove = 100;
        var iDelayIncr = 100;
        var iCont=_aCard.length-1;
        
        for(var i=0; i<28; i++){
            _aCard[51-i].moveCard(_aCardStartPos[i].x, _aCardStartPos[i].y, iTimeMove,iDelay);    
            _aCard[51-i].setType("board");
            iDelay+=iDelayIncr;            
        }
        
        
        for (var i=0; i<7; i++){
            for (var j=i; j<7; j++){                
                _aGridMatrix[i][j].oCard = _aCard[iCont];
                _aGridMatrix[i][j].status = LABEL_HIDDEN;               
                iCont--;               
            }            
        }        
        
        for(var i=28; i<52; i++){
            _aDeckCard[51-i] = _aCard[51-i];
            
        }

    };
    
    this.pickCard = function(oCard, event){

        if(_bBlock){ //do not allow more then one pick on mobile.
            return;
        }
        _bBlock=true;        

        _iCurPos = {x: oCard.getPos().x, y: oCard.getPos().y };
        _iCurDepth = _oCardContainer.getChildIndex(oCard.getSprite());
        _iMouseOffset = {x : event.stageX/s_iScaleFactor - _iCurPos.x, y : event.stageY/s_iScaleFactor - _iCurPos.y};
        
        if(oCard.checkType()==="deck"){
            var oInfo = oCard.saveInfo();
            _aStackCard[0] = new CCard(_iCurPos.x, _iCurPos.y, _oCardContainer, oInfo.szFotogram, oInfo.iRank, oInfo.iSuit);
            _aStackCard[0].setPointValue(oCard.saveInfo().bValue);
            _aStackCard[0].instantShow();
            _oDeckCard = oCard;
            oCard.setVisible(false);
            
        } else if(oCard.checkType()==="board") {
            //Check all card stack under picked one.                                  
            for(var j=0; j<7; j++){
                for(var i=_aGridMatrix.length-1; i>=0; i--){
                    if(_aGridMatrix[i][j].oCard===oCard){
                        _oStartLogicCardPos = {row: i, column: j};
                    }                
                }
            }    

            var iCont=0;
            for (var i=_oStartLogicCardPos.row; i<_aGridMatrix.length; i++){
                if(_aGridMatrix[i][_oStartLogicCardPos.column].status === LABEL_SHOWN){
                    iCont++;
                }
            }

            var aInfo = new Array();
            for (var i=0; i<iCont; i++){
                aInfo[i] = _aGridMatrix[_oStartLogicCardPos.row + i][_oStartLogicCardPos.column].oCard.saveInfo();
                _aStackCard[i] = new CCard(_iCurPos.x, _iCurPos.y + i*_iStackCard, _oCardContainer, aInfo[i].szFotogram, aInfo[i].iRank, aInfo[i].iSuit);
                _aStackCard[i].setPointValue(aInfo[i].bValue);
                _aGridMatrix[_oStartLogicCardPos.row + i][_oStartLogicCardPos.column].oCard.unload();
                _aStackCard[i].setType("board");
                _aStackCard[i].instantShow();
            }
            ////////////////////////////////////////
        
        } else {
            
            var oInfo = oCard.saveInfo();
            _aStackCard[0] = new CCard(_iCurPos.x, _iCurPos.y, _oCardContainer, oInfo.szFotogram, oInfo.iRank, oInfo.iSuit);
            _aStackCard[0].setPointValue(oCard.saveInfo().bValue);
            _aStackCard[0].setType("suit");
            _aStackCard[0].instantShow();
            _oSuitCard = oCard;
            oCard.setVisible(false);
           
        }
       
    };
    
    this.dragCard = function(event){
	
        if(!_bInitGame && _aStackCard.length > 0){
           for(var i=0; i<_aStackCard.length; i++){
               _aStackCard[i].setPos(event.localX - _iMouseOffset.x , event.localY - _iMouseOffset.y +i*_iStackCard);
           }
          
        }     
    };
    
    this.setPreviousCardVisible = function(oCard, szType){//To make ease in deck's cards too
        oCard.unload();

        if(szType === "suit"){
            _oSuitCard.setVisible(true);
        }else {
            _oDeckCard.setVisible(true);
        }
    };
    
    
    this.releaseCard = function(event){
        if(_bInitGame === false && _aStackCard.length > 0){
            _bBlock=false;
        }else{
            return;
        }
        
        if(_aStackCard.length ===1){
            _oParent._snapOnSuit(_aStackCard);
        }
        
        if(_aStackCard[0].getRank()===13){
            _oParent._snapOnBoardKing(_aStackCard);
        }
        
        if(!_bBoardSnapped){
            _oParent._checkCardCollision(_aStackCard);
        }

        _aStackCard = [];
        
        _bBoardSnapped=false;
    };    
    
    this._snapOnSuit = function(oCard){
        
        var iMaxArea=0;
        var iColIntersect=-1;
        var rCurRect = oCard[0].getLogicRect();        
        
        for (var i=0; i<_aSuitRect.length; i++){
            var rAppRect = rCurRect.intersection(_aSuitRect[i]);
            if(rAppRect!== null){
                if(iMaxArea < (rAppRect.width*rAppRect.height)){                    
                    iMaxArea = (rAppRect.width*rAppRect.height);                    
                    iColIntersect = i;
                }              
            }                                                
        }
        
        if(iColIntersect<0){
            return;
        }
        
        
        if(oCard[0].getRank() === _aCurRank[oCard[0].getSuit()] && iColIntersect === oCard[0].getSuit() && oCard[0].checkType()!== "suit"){
            oCard[0].stackInPlace(_aSuitPos[iColIntersect].x, _aSuitPos[iColIntersect].y);
            _bBoardSnapped = true;
            _aCurRank[oCard[0].getSuit()]++;
            
            
            if(oCard[0].checkType()==="deck"){
                
                _aDeckCard[_iTurnCardCont].unload();
                _aDeckCard.splice(_iTurnCardCont,1);
                oCard[0].setType("suit");
                if(!s_bEasyMode){
                    this._setActiveCard();
                    this._calculateScoreOnDeck(oCard[0], POINTS_TO_SUIT*2);
                } else {
                    this._calculateScoreOnDeck(oCard[0], POINTS_TO_SUIT);
                }
                
                
                oCard[0].setPointValue(false);
                
            } else if(oCard[0].checkType()==="board"){
                    
                    _aGridMatrix[_oStartLogicCardPos.row][_oStartLogicCardPos.column].status=LABEL_EMPTY;
                    oCard[0].setType("suit");
                    this._checkBoard(oCard);
                    if(s_bEasyMode){
                        this._calculateScoreOnDeck(oCard[0], POINTS_TO_SUIT);
                    }else {
                        this._calculateScoreOnDeck(oCard[0], POINTS_TO_SUIT*2);
                    }
                    
                    oCard[0].setPointValue(false);
            } 
            
        }
             
        if(_aCurRank[0]===14 && _aCurRank[1]===14 && _aCurRank[2]===14 && _aCurRank[3]===14){
            s_oGame.gameOver();
        }
        
    };
    
    this._snapOnBoardKing = function(oCard){
        var iMaxArea=0;
        var iColIntersect=-1;
        var rCurRect = oCard[0].getLogicRect();        
        
        for (var i=0; i<_aSnapKing.length; i++){
            if(_aSnapKing[i]!==null){
                var rAppRect = rCurRect.intersection(_aSnapKing[i]);
                if(rAppRect!== null){
                    if(iMaxArea < (rAppRect.width*rAppRect.height)){

                        iMaxArea = (rAppRect.width*rAppRect.height);
                        iColIntersect = i;
                    }              
                }     
            }                                           
        }
        
        if(iColIntersect<0){
            return;
        }        
                
        
        if(oCard[0].checkType()==="deck"){
            oCard[0].stackInPlace(_aCardStartPos[iColIntersect].x, _aCardStartPos[iColIntersect].y);
            _aGridMatrix[0][iColIntersect].status=LABEL_SHOWN;
            _aGridMatrix[0][iColIntersect].oCard=oCard[0];
            _aGridMatrix[0][iColIntersect].oCard.setType("board");
            
            _aDeckCard[_iTurnCardCont].unload();
            _aDeckCard.splice(_iTurnCardCont,1);
            if(!s_bEasyMode){
                this._setActiveCard();
                this._calculateScore(oCard[0], POINTS_TO_BOARD*2);
            } else {
                this._calculateScore(oCard[0], POINTS_TO_BOARD);
            }
            playSound("snap", 1, false);
            
            _bBoardSnapped = true;
            
        } else if(oCard[0].checkType()==="board"){
            var iParScore=0;
            for(var i=0; i<oCard.length; i++){
                oCard[i].stackInPlace(_aCardStartPos[iColIntersect].x, _aCardStartPos[iColIntersect].y + i*_iStackCard);
                _aGridMatrix[i][iColIntersect].status=LABEL_SHOWN;
                _aGridMatrix[i][iColIntersect].oCard=oCard[i];
                _aGridMatrix[i][iColIntersect].oCard.setType("board");
                _aGridMatrix[_oStartLogicCardPos.row +i][_oStartLogicCardPos.column].status=LABEL_EMPTY;
                _bBoardSnapped = true;
                if(oCard[i].getPointValue()===true){
                        oCard[i].setPointValue(false);
                        
                        if(!s_bEasyMode){
                            iParScore += POINTS_TO_BOARD*2;
                        } else {
                            iParScore += POINTS_TO_BOARD;
                        }
                    }                
            }
                if(iParScore>0){
                    this._calculateScore(oCard[0], iParScore);
                    playSound("snap", 1, false);
                }
            
            
        } else {
            oCard[0].stackInPlace(_aCardStartPos[iColIntersect].x, _aCardStartPos[iColIntersect].y);
            _aGridMatrix[0][iColIntersect].status=LABEL_SHOWN;
            _aGridMatrix[0][iColIntersect].oCard=oCard[0];
            _aGridMatrix[0][iColIntersect].oCard.setType("board");
            _aCurRank[oCard[0].getSuit()]--;
            
        }
        
        if ( _aGridMatrix[0][_oStartLogicCardPos.column].status===LABEL_EMPTY){ 
            _aSnapKing[_oStartLogicCardPos.column] = new createjs.Rectangle(
                    _aCardStartPos[_oStartLogicCardPos.column].x - CARD_WIDTH/2,_aCardStartPos[_oStartLogicCardPos.column].y - CARD_HEIGHT/2,
                    CARD_WIDTH,CARD_HEIGHT);                              
        }   
        
        this._checkBoard(oCard);
        
        _aSnapKing[iColIntersect] = null;
        
        
        
    };
    
    this._checkCardCollision = function(oCard){
        
        var iCont=0;
        var aRect = new Array();
        var oLastCard = new Array();        
        
        for(var j=0; j<7; j++){
            for(var i=_aGridMatrix.length-1; i>=0; i--){
                if(_aGridMatrix[i][j].status===LABEL_SHOWN){
                    aRect[iCont] = _aGridMatrix[i][j].oCard.getLogicRect();
                    oLastCard[iCont] = {oCard:_aGridMatrix[i][j].oCard,
                                        x: _aGridMatrix[i][j].oCard.getPos().x, y: _aGridMatrix[i][j].oCard.getPos().y, 
                                        row: i, column: j};
                    iCont++;                    
                    break;
                }                                     
            }
        }
        
        var iMaxArea=0;
        var iColIntersect=-1;
        var rCurRect = oCard[0].getLogicRect();
        
        
        
        for (var i=0; i<aRect.length; i++){
            var rAppRect = rCurRect.intersection(aRect[i]);
            if(rAppRect!== null){
                if(iMaxArea < (rAppRect.width*rAppRect.height)){
                   
                    iMaxArea = (rAppRect.width*rAppRect.height);
                    iColIntersect = i;
                }              
            }                                    
        }
        
        if(iColIntersect<0){//Not collide
            
            if(oCard[0].checkType()==="deck"){
                oCard[0].returnInPlace(_iCurPos.x, _iCurPos.y);
                
                
            } else if (oCard[0].checkType()==="board") { 
                for(var i=0; i<oCard.length; i++){
                    oCard[i].stackInPlace(_iCurPos.x, _iCurPos.y + i*_iStackCard);
                    _aGridMatrix[_oStartLogicCardPos.row +i][_oStartLogicCardPos.column].oCard=oCard[i];
               
                }
            } else {
                oCard[0].returnInPlace(_iCurPos.x, _iCurPos.y);
                return;
            }
            
         //Collide and match   
        }else if(oLastCard[iColIntersect].oCard.getRank()- oCard[0].getRank() === 1 && oLastCard[iColIntersect].oCard.getColor() !== oCard[0].getColor()){
            
            
            if(oCard[0].checkType()==="deck"){
                oCard[0].stackInPlace(oLastCard[iColIntersect].x, oLastCard[iColIntersect].y + _iStackCard);
                _aGridMatrix[oLastCard[iColIntersect].row+1][oLastCard[iColIntersect].column].status=LABEL_SHOWN;
                _aGridMatrix[oLastCard[iColIntersect].row+1][oLastCard[iColIntersect].column].oCard=oCard[0];
                _aGridMatrix[oLastCard[iColIntersect].row+1][oLastCard[iColIntersect].column].oCard.setType("board");
                
                _aDeckCard[_iTurnCardCont].unload();
                _aDeckCard.splice(_iTurnCardCont,1);
                if(!s_bEasyMode){
                    this._setActiveCard();
                    this._calculateScore(oCard[0], POINTS_TO_BOARD*2);
                } else {
                    this._calculateScore(oCard[0], POINTS_TO_BOARD);
                }
                playSound("snap", 1, false);              
                
                oCard[0].setPointValue(false);                
               
                return;
                
            }else if (oCard[0].checkType()==="board"){
                var iParScore=0;
                for(var i=0; i<oCard.length; i++){
                    oCard[i].stackInPlace(oLastCard[iColIntersect].x, oLastCard[iColIntersect].y + _iStackCard + i*_iStackCard);
                    _aGridMatrix[oLastCard[iColIntersect].row+1+i][oLastCard[iColIntersect].column].status=LABEL_SHOWN;
                    _aGridMatrix[_oStartLogicCardPos.row +i][_oStartLogicCardPos.column].status=LABEL_EMPTY;
                    _aGridMatrix[oLastCard[iColIntersect].row+1+i][oLastCard[iColIntersect].column].oCard=oCard[i];
                    if(oCard[i].getPointValue()===true){
                        oCard[i].setPointValue(false);
                        if(!s_bEasyMode){
                            iParScore += POINTS_TO_BOARD*2;
                        } else {
                            iParScore += POINTS_TO_BOARD;
                        }                     
                    }
                    
                }
                
                if(iParScore>0){
                    this._calculateScore(oCard[0], iParScore);
                    playSound("snap", 1, false);
                }
                
            } else {
                oCard[0].stackInPlace(oLastCard[iColIntersect].x, oLastCard[iColIntersect].y + _iStackCard);
                _aGridMatrix[oLastCard[iColIntersect].row+1][oLastCard[iColIntersect].column].status=LABEL_SHOWN;
                _aGridMatrix[oLastCard[iColIntersect].row+1][oLastCard[iColIntersect].column].oCard=oCard[0];
                _aGridMatrix[oLastCard[iColIntersect].row+1][oLastCard[iColIntersect].column].oCard.setType("board");
                _aCurRank[oCard[0].getSuit()]--;
                return;
            }
                       
        } else {//case that collide with a rect, but not match
            if(oCard[0].checkType()!=="board"){
                oCard[0].returnInPlace(_iCurPos.x, _iCurPos.y);
                return;
            } else { 
                for(var i=0; i<oCard.length; i++){
                    oCard[i].stackInPlace(_iCurPos.x, _iCurPos.y + i*_iStackCard);
                    _aGridMatrix[_oStartLogicCardPos.row +i][_oStartLogicCardPos.column].oCard=oCard[i];
               
                }
            }                        
        }

        this._checkBoard(oCard);


    };
    
    
    
    this._checkBoard = function(oCard){
        
        if (oCard[0].checkType()!=="deck"){
        
            var iCol = _oStartLogicCardPos.column;
                     
            //Turn a card in stack
            for(var i=_aGridMatrix.length-1; i>=0; i--){
                if ( _aGridMatrix[i][iCol].status===LABEL_SHOWN){

                    break;

                } else if ( _aGridMatrix[i][iCol].status===LABEL_HIDDEN){

                    _aGridMatrix[i][iCol].oCard.showCard();
                    _aGridMatrix[i][iCol].status = LABEL_SHOWN;

                    break;
                }           
            }

            //Set snap spot for King             
            if ( _aGridMatrix[0][iCol].status===LABEL_EMPTY){ 
                _aSnapKing[iCol] = new createjs.Rectangle(
                        _aCardStartPos[iCol].x - CARD_WIDTH/2,_aCardStartPos[iCol].y - CARD_HEIGHT/2,
                        CARD_WIDTH,CARD_HEIGHT);                             
            }     
        } 
        
    };
    
    this.autoMoveAce = function(oCard){
        
        var oCardA = new Array();
        oCardA[0] = oCard;
        if(oCardA[0].getRank()===_aCurRank[oCard.getSuit()] && oCardA[0].checkType()==="board"){
            oCardA[0].stackInPlace(_aSuitPos[oCardA[0].getSuit()].x, _aSuitPos[oCardA[0].getSuit()].y);
       
            for(var j=0; j<7; j++){
                for(var i=_aGridMatrix.length-1; i>=0; i--){
                    if(_aGridMatrix[i][j].oCard===oCard){
                        _oStartLogicCardPos = {row: i, column: j};
                    }                
                }
            }    
            
            _aGridMatrix[_oStartLogicCardPos.row][_oStartLogicCardPos.column].status=LABEL_EMPTY;
            oCardA[0].setType("suit");            
            this._checkBoard(oCardA);
            _aCurRank[oCard.getSuit()]++;
            
            playSound("snap", 1, false);
            
            if(!s_bEasyMode){
                this._calculateScoreOnDeck(oCard, POINTS_TO_SUIT*2);
            } else {
                this._calculateScoreOnDeck(oCard, POINTS_TO_SUIT);
            }
            
            oCard.setPointValue(false);
            
        } else if (oCard.getRank()===_aCurRank[oCard.getSuit()] && oCard.checkType()==="deck" && _aDeckCard[_iTurnCardCont].getRank()===1){
            
            oCardA[0].stackInPlace(_aSuitPos[oCard.getSuit()].x, _aSuitPos[oCard.getSuit()].y);
            oCardA[0].setType("suit");
            _aDeckCard.splice(_iTurnCardCont,1);
            
            _aCurRank[oCard.getSuit()]++;
            if(!s_bEasyMode){
                this._setActiveCard();
                this._calculateScoreOnDeck(oCard, POINTS_TO_SUIT*2);
            } else {
                this._calculateScoreOnDeck(oCard, POINTS_TO_SUIT);
            }
            
            playSound("snap", 1, false);
            
            oCard.setPointValue(false);
        }       
        _bBlock = false;
    };

    this.scaleDepth = function(oCard){     
        _oCardContainer.setChildIndex(oCard,_iDepth);
        _iDepth++;     
    };    
    
    this.scaleDepthWithIndex = function(oCard, iIndex){     
        _oCardContainer.setChildIndex(oCard,iIndex);   
    };    
    
    this._turn3Card = function(){
        if(_bInitGame ||_aDeckCard.length===0 || _bBlock || (_aDeckCard.length<=3 && s_oGame.deckCardsAllTurned() && !s_oGame.thereAreUsableDeckCards()) ){
            return;
        }

        if (_iDeck3Cont < 0){
            _iDepth=0;

            for(var i=0; i<_aDeckCard.length; i++){
                _aDeckCard[i].setBack();
                _aDeckCard[i].setPlaced();
                _aDeckCard[i].setVisible(true);
                _aDeckCard[i].setPos(_aDeckPos[0].x-(i/DECK_CARD_OFFSET),_aDeckPos[0].y-(i/DECK_CARD_OFFSET));
            }
            
            _aCardDeck3Index = [];
            for(var i=0; i<(_aDeckCard.length)/3; i++){
                _aCardDeck3Index[i] = _aDeckCard.length - 1 - i*3;
            }

           _iDeck3Cont = _aCardDeck3Index.length-1;           
           bubbleSort(_aCardDeck3Index);
        }
        
        _iTurnCardCont=_aCardDeck3Index[_iDeck3Cont] - 2;
        if(_aDeckCard.length<3){
            _iTurnCardCont=_aCardDeck3Index[_iDeck3Cont];
        }
        
        
        _bBlock=true;
        
        if (_iDeck3Cont === _aCardDeck3Index.length-1){
            if(_aDeckCard.length<4){
                for (var i=_aDeckCard.length-1; i>=0; i--){     
                    var iDepthCount = 3;
                    _aDeckCard[_aCardDeck3Index[_iDeck3Cont]-i].moveCardWithIndex(_aDeckPos[i+1].x, _aDeckPos[i+1].y, 150,20*i, iDepthCount);
                    _aDeckCard[_aCardDeck3Index[_iDeck3Cont]-i].showCard();
                    _aDeckCard[_aCardDeck3Index[_iDeck3Cont]-i].setActive(false);
                    iDepthCount--;
                }
                _iTurnCardCont = 0
                _aDeckCard[_iTurnCardCont].setActive(true);
                return;
            }else {
                var iDepthCount = 3;
                for (var i=2; i>=0; i--){
                    _aDeckCard[_aCardDeck3Index[_iDeck3Cont]-i].moveCardWithIndex(_aDeckPos[i+1].x, _aDeckPos[i+1].y, 150,20*i, iDepthCount);
                    _aDeckCard[_aCardDeck3Index[_iDeck3Cont]-i].showCard();
                    _aDeckCard[_aCardDeck3Index[_iDeck3Cont]-i].setActive(false);
                    iDepthCount--;
                }
            }
            
            
        } else {
            
            var iQt = _iCurActiveCard+1;
            

            for (var i=0; i<iQt; i++){
                _aDeckCard[_aCardDeck3Index[_iDeck3Cont] + i+1].setVisible(false);                
            }
            
            var iMaxCont;
            if(_iDeck3Cont===0){
                iMaxCont = _aCardDeck3Index[_iDeck3Cont] +1;
                _iTurnCardCont = 0;
            } else {
                iMaxCont = 3;
            }
            var iDepthCount = 3;
            for (var i=iMaxCont-1; i>=0; i--){  
                _aDeckCard[_aCardDeck3Index[_iDeck3Cont]-i].moveCardWithIndex(_aDeckPos[i+1].x, _aDeckPos[i+1].y, 150,20*i, iDepthCount);
                _aDeckCard[_aCardDeck3Index[_iDeck3Cont]-i].showCard();
                _aDeckCard[_aCardDeck3Index[_iDeck3Cont]-i].setActive(false);  
                iDepthCount--;
            }
        }
        
        _iCurActiveCard=2;
        _aDeckCard[_iTurnCardCont].setActive(true);
        
        _iDeck3Cont--;
     
    };
    
    this.deckCardsAllTurned = function(){
        for(var i=0; i<_aDeckCard.length; i++){
            if(!_aDeckCard[i].getTurnedValue()){
                return false;
            }
        }
        return true;
    };
    
    this.thereAreUsableDeckCards = function(){
        for(var i=0; i<_aDeckCard.length; i++){
            if(!_aDeckCard[i].getVisible()){
                return true;
            }
        }
        return false;
    };
    
    this._setActiveCard = function(){        
        _iCurActiveCard--;
        
        if(_aDeckCard.length===_iTurnCardCont){
            return;
        }

        _aDeckCard[_iTurnCardCont].setActive(true);

        if(_aDeckCard[_iTurnCardCont].getRank()===1){
            this.autoMoveAce(_aDeckCard[_iTurnCardCont]);
        }        
    };
    
    this._turnCard = function(){
        if(_aDeckCard.length===0 || _bBlock){
            return;
        }

        _iTurnCardCont--;
        if (_iTurnCardCont < 0){
            
            _iTurnCardCont=_aDeckCard.length-1;
            for(var i=0; i<_aDeckCard.length; i++){
                _aDeckCard[i].setBack();
                _aDeckCard[i].setPlaced();
                _aDeckCard[i].setPos(_aDeckPos[0].x-(i/DECK_CARD_OFFSET),_aDeckPos[0].y-(i/DECK_CARD_OFFSET));
            }
            
        }
        
        if (_iTurnCardCont === _aDeckCard.length-1){
            _iDepth=0;
        }
        _bBlock=true;


        _aDeckCard[_iTurnCardCont].moveCard(_aDeckPos[1].x, _aDeckPos[1].y, 150,0);
        _aDeckCard[_iTurnCardCont].showCard();
        
        
    };

    this.unload = function(){
        _bInitGame = false;
        
        stopSound("card_dealing");
        
        for(var i=0; i<_aCard.length; i++){
            _aCard[i].unload();
        }
        

        _oInterface.unload();
        if(_oEndPanel !== null){
            _oEndPanel.unload();
        }
        createjs.Tween.removeAllTweens();
        s_oStage.removeAllChildren();
           
    };
         
    this.restartGame = function () {
        $(s_oMain).trigger("show_interlevel_ad");
        this.unload();
        this._init();
    };
    
    this.pauseGame = function (){
        _bStartGame = !_bStartGame;                              
    };
    
    this.onExit = function(){
        this.unload();
        s_oMain.gotoMenu();
    };
    
    this._onExitHelp = function () {
        this.pauseGame(); 
        $(s_oMain).trigger("show_interlevel_ad");
    };
    
    this.gameOver = function(){        
        playSound("game_over", 1, false);
        
        _oEndPanel = CEndPanel(s_oSpriteLibrary.getSprite('msg_box'));
        _oEndPanel.show(_iScore);
        
        _bStartGame = false;
    };
    
    this.update = function(){
        if(_bInitGame){

            if(_aCard[51-27].getPlaced()){ 
				
                stopSound("card_dealing");
                                
                _iCont++;
                var iDelay=10;

                if(_iCont===1){
                    _aCard[51].showCard();
                    _aGridMatrix[0][0].status=LABEL_SHOWN;
                } else if(_iCont===iDelay){
                    _aCard[51-7].showCard();
                    _aGridMatrix[1][1].status=LABEL_SHOWN;
                } else if(_iCont===2*iDelay){
                    _aCard[51-13].showCard();
                    _aGridMatrix[2][2].status=LABEL_SHOWN;
                } else if(_iCont===3*iDelay){
                    _aCard[51-18].showCard();
                    _aGridMatrix[3][3].status=LABEL_SHOWN;
                } else if(_iCont===4*iDelay){
                    _aCard[51-22].showCard();
                    _aGridMatrix[4][4].status=LABEL_SHOWN;
                } else if(_iCont===5*iDelay){
                    _aCard[51-25].showCard();
                    _aGridMatrix[5][5].status=LABEL_SHOWN;
                } else if(_iCont===6*iDelay){
                    _aCard[51-27].showCard();
                    _aGridMatrix[6][6].status=LABEL_SHOWN;
                    _bInitGame=false;
                    _bBlock = false;
                    _bStartGame=true;
                    _oInterface.setVisibleButHelp();
                    
                    s_iTimeElaps = 0;                    
                }

            }
            
        }
        
        if(_bStartGame){
            _iTimeElaps += s_iTimeElaps;
            if(_iTimeElaps > 5999000){
                _iTimeElaps = 5999000;
            }
                
            _oInterface.refreshTime(formatTime(_iTimeElaps));
            
            _iTimer += s_iTimeElaps;            
            if(_iTimer>LOSEPOINTS_TIMER){
                _iTimer=0;
                var oScore = new CScore();
                oScore.removeScore(POINTS_TO_LOSE);
            }            
        }
    };

    s_oGame=this;
    
    LOSEPOINTS_TIMER = oData.timer_losepoint;
    POINTS_TO_LOSE = oData.points_to_lose;
    POINTS_TO_SUIT = oData.points_to_suit;
    POINTS_TO_BOARD = oData.points_to_board;
    
    _oParent=this;
    this._init();
}

var s_oGame;
