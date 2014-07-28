package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	

	public class Main extends Sprite 
	{
		private var loader:URLLoader;
		private var refTime:int;
		private var myTimer:Timer;
		
		public function Main():void 
		{
			//分配定时刷新事件
			myTimer = new Timer(1000);
			myTimer.addEventListener(TimerEvent.TIMER, setXML);
			myTimer.start();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			//自适应屏幕
			stage.scaleMode = StageScaleMode.NO_SCALE ;
			stage.align = "TL";
			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.addEventListener (Event.FULLSCREEN, onStageResize);
			background.width=stage.stageWidth;
  			background.height=stage.stageHeight;
			mainyuanjian.width=stage.stageWidth - 58;
			mainyuanjian.height=stage.stageHeight;
			

			removeEventListener(Event.ADDED_TO_STAGE, init);
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadDataBefore);
			loader.load(new URLRequest(loaderInfo.parameters.filename || "scr.xml"));
			
		}

		private function onStageResize(e:Event):void {
  			var w:int=stage.stageWidth;
  			var h:int=stage.stageHeight;
  			background.width=w;
  			background.height=h;
			mainyuanjian.width=stage.stageWidth;
			mainyuanjian.height=stage.stageHeight;
		}
		
		private function onLoadDataBefore(e:Event):void{
			
			var datas:XML = new XML(loader.data);
			var componsList:XMLList = new XMLList(datas.shebeiwenzi.item);
			var paramsList:XMLList = new XMLList(datas.shishishuju.item);
			var lightList:XMLList = new XMLList(datas.zhishideng.item);
			
			//定义刷新时间样式
			var tf:TextFormat = new TextFormat();
			tf.color = datas.reftime.@foreColor;
			tf.font = datas.reftime.@fontFamily;
			tf.size = datas.reftime.@fontSize;
			if(datas.reftime.@fontStyle == 'bold'){
				tf.bold = true;
			}else if(datas.reftime.@fontStyle == 'italic'){
				tf.italic = true;
			}
			//定义刷新时间
			refTime = datas.reftime;
			mainyuanjian.lefttime.setTextFormat(tf);
			
			//如果存在底图设置就更换当前底图
			if(datas.ditu){
				var loadimg:Loader = new Loader;
				background.addChild(loadimg);
				loadimg.load(new URLRequest(datas.ditu));
				loadimg.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(){});
					
			}
			
			//定义标题样式
			var ttf:TextFormat = new TextFormat();
			ttf.color = datas.title.@foreColor;
			ttf.font = datas.title.@fontFamily;
			ttf.size = datas.title.@fontSize;
			if(datas.title.@fontStyle == 'bold'){
				ttf.bold = true;
			}else if(datas.title.@fontStyle == 'italic'){
				ttf.italic = true;
			}
			mainyuanjian.title.text = datas.title;
			mainyuanjian.title.setTextFormat(ttf);
			
			//定义时间显示样式
			var timetf:TextFormat = new TextFormat();
			timetf.color = datas.time.@foreColor;
			timetf.font = datas.time.@fontFamily;
			timetf.size = datas.time.@fontSize;
			if(datas.time.@fontStyle == 'bold'){
				timetf.bold = true;
			}else if(datas.time.@fontStyle == 'italic'){
				timetf.italic = true;
			}
			//定义时间显示
			mainyuanjian.time.text = datas.time;
			mainyuanjian.time.setTextFormat(timetf);
			
			//定义组件名称显示
			for(var j:int = 0;j<componsList.length();j++){
				var componI:TextField = new TextField();
				mainyuanjian.dongtai.addChild(componI);
				
				componI.x = componsList[j].x_pos;
				componI.y = componsList[j].y_pos;
				componI.text = componsList[j].name;
				componI.selectable = false;
				componI.width = 130;
				
				var cTF:TextFormat = new TextFormat();
				cTF.color = componsList[j].name.@foreColor;
				cTF.font = componsList[j].name.@fontFamily;
				//cTF.size = componsList[j].name.@fontSize;
				if(componsList[j].name.@fontStyle == 'bold'){
					cTF.bold = true;
				}else if(componsList[j].name.@fontStyle == 'italic'){
					cTF.italic = true;
				}
				componI.setTextFormat(cTF);
			}
			
			//定义一些参数信息显示
			for(var i:int = 0; i < paramsList.length();i++){
				var paramICon:Sprite = new Sprite();
				mainyuanjian.dongtai.addChild(paramICon);
				var paramI:TextField = new TextField();
				paramICon.addChild(paramI);
				
				paramICon.x = paramsList[i].x_pos;
				paramICon.y = Number(paramsList[i].y_pos) + 20;
				paramI.width = 180;
				paramI.height = 30;
				//开启按钮模式，同时阻止子文本域改变按钮模式
				paramICon.buttonMode = true;
				paramICon.mouseChildren = false;
				
				paramI.text = paramsList[i].name;
				paramI.selectable = false;
				
				var paraTf:TextFormat = new TextFormat();
				paraTf.color = paramsList[i].name.@foreColor;
				paraTf.font = paramsList[i].name.@fontFamily;
				paraTf.size = paramsList[i].name.@fontSize;
				if(paramsList[i].name.@fontStyle == 'bold'){
					paraTf.bold = true;
				}else if(paramsList[i].name.@fontStyle == 'italic'){
					paraTf.italic = true;
				}
				if(paramsList[i].over_std == 1){
					paraTf.color = 0xFF0000;
				}
				paramI.setTextFormat(paraTf);
				
				//以供鼠标点击事件使用
				paramICon.tabIndex = i;
				
				//定义点击事件
				paramICon.addEventListener(MouseEvent.CLICK, resp);
			}
			
			
			//定义指示灯显示
			for(var l:int = 0;l < lightList.length();l++){
				var light:Sprite = new Sprite();
				mainyuanjian.dongtai.addChild(light);
				
				if(lightList[l].state == 0){
					light.graphics.beginFill(0xFF0000);
				}else{
					light.graphics.beginFill(0x0000FF);
				}
				light.graphics.drawCircle(0,0,lightList[l].data_precision /2);
				light.x = lightList[l].x_pos;
				light.y = lightList[l].y_pos;
			}
			
			
		}
		
		private function resp(e:MouseEvent):void{
			if (ExternalInterface.available){
				var dats:XML = new XML(loader.data);
				var shujus:XMLList = new XMLList(dats.shishishuju.item);
				ExternalInterface.call('test', String(shujus[e.target.tabIndex].url));
				//navigateToURL(new URLRequest('/flash/'+shujus[e.target.tabIndex].url), '_top');
			}
		}
		
		
		//定时更新数据文件函数
		private function setXML(e:TimerEvent):void{
			refTime--;
			
			//显示剩余刷新时间
			if(refTime < 10){
				mainyuanjian.lefttime.text = "0" + String(refTime);
			}else{
				mainyuanjian.lefttime.text = String(refTime);
			}
			
			if(refTime == 0){
				loader = new URLLoader();
				removeEventListener(Event.COMPLETE, onLoadDataBefore);
				
				//移除之前添加的对象
				for (var i:int = mainyuanjian.dongtai.numChildren-1; i >= 0; i--) {
 	  				mainyuanjian.dongtai.removeChildAt (i);
				}
				
				loader.addEventListener(Event.COMPLETE, onLoadDataBefore);
				loader.load(new URLRequest(loaderInfo.parameters.filename || "scr.xml"));
			}
		}

		
	}
	
}