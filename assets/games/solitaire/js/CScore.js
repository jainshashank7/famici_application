function CScore() {
    
    this.showScore = function(oPos, iPoint){
        var iTime=1000;
		
		var oScoreMoveBack = new createjs.Text("+"+iPoint,"bold 24px "+PRIMARY_FONT, "#000000");
        oScoreMoveBack.x = oPos.x;
        oScoreMoveBack.y = oPos.y;
        oScoreMoveBack.scaleX=2;
        oScoreMoveBack.scaleY=2;
        oScoreMoveBack.textAlign = "right";
        oScoreMoveBack.textBaseline = "alphabetic";
		oScoreMoveBack.outline = 4;
        s_oStage.addChild(oScoreMoveBack);
		
        var oScoreMove = new createjs.Text("+"+iPoint,"bold 24px "+PRIMARY_FONT, "#fff");
        oScoreMove.x = oPos.x;
        oScoreMove.y = oPos.y;
        oScoreMove.scaleX=2;
        oScoreMove.scaleY=2;
        oScoreMove.textAlign = "right";
        oScoreMove.textBaseline = "alphabetic";
        
        s_oStage.addChild(oScoreMove);
		
                
        createjs.Tween.get(oScoreMove).to({x:595 , y:119}, iTime, createjs.Ease.cubicIn).call(function(){s_oGame.updateVisualScore(); s_oStage.removeChild(oScoreMove); });
        createjs.Tween.get(oScoreMove).to({scaleX:1 , scaleY:1}, iTime, createjs.Ease.linear);
		
	createjs.Tween.get(oScoreMoveBack).to({x:595 , y:119}, iTime, createjs.Ease.cubicIn).call(function(){ s_oStage.removeChild(oScoreMoveBack); });
        createjs.Tween.get(oScoreMoveBack).to({scaleX:1 , scaleY:1}, iTime, createjs.Ease.linear);

    };
    
    this.removeScore = function(iPoint){
        s_oGame.updateScore(iPoint); 
        s_oGame.updateVisualScore(); 
        
        var iTime = 2000;
        var oScoreDel = new createjs.Text(iPoint,"bold 24px "+PRIMARY_FONT, "#ffffff");
        oScoreDel.x = 595;
        oScoreDel.y = 119;
        oScoreDel.textAlign = "right";
        oScoreDel.textBaseline = "alphabetic";
        s_oStage.addChild(oScoreDel);
  
        createjs.Tween.get(oScoreDel).to({x:oScoreDel.x + 40}, iTime, createjs.Ease.cubicOut).call(function(){s_oStage.removeChild(oScoreDel); });
        createjs.Tween.get(oScoreDel).to({alpha:0}, 2*iTime, createjs.Ease.linear)
    };

}