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
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;
	

	public class Main extends Sprite 
	{
		private var loader:URLLoader;
		private var tuoxiaourl:String;
		private var tuoliuurl:String;
		private var s:SoundFacade;
		
		public function Main():void 
		{
			
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
			mainyuanjian.width=stage.stageWidth - 50;
			mainyuanjian.height=stage.stageHeight - 100;

			removeEventListener(Event.ADDED_TO_STAGE, init);
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadDataBefore);
			loader.load(new URLRequest(loaderInfo.parameters.filename || "js.xml"));
			
		}

		private function onStageResize(e:Event):void {
  			var w:int=stage.stageWidth;
  			var h:int=stage.stageHeight;
  			background.width=w;
  			background.height=h;
			mainyuanjian.width=w - 50;
			mainyuanjian.height=h - 100;
		}
		
		private function onLoadDataBefore(e:Event):void{
			
			var datas:XML = new XML(loader.data);
			tuoxiaourl = datas.url.tuoxiaourl;
			tuoliuurl = datas.url.tuoliuurl;
			var componsList:XMLList = new XMLList(datas.item);
			
			//如果存在底图设置就更换头部底图
			if(datas.ditu){
				var loadimg:Loader = new Loader;
				background.topBack.addChild(loadimg);
				loadimg.load(new URLRequest(datas.ditu));
				loadimg.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(){});
					
			}
			
			//定义头部标题样式
			var ttf:TextFormat = new TextFormat();
			ttf.color = datas.title.@foreColor;
			ttf.font = datas.title.@fontFamily;
			ttf.size = datas.title.@fontSize;
			if(datas.title.@fontStyle == 'bold'){
				ttf.bold = true;
			}else if(datas.title.@fontStyle == 'italic'){
				ttf.italic = true;
			}
			//定义头部标题显示
			background.title.text = datas.title;
			background.title.setTextFormat(ttf);
			
			//定义两个按钮链接
			mainyuanjian.btn_tuoxiao.addEventListener(MouseEvent.CLICK, onclick);
			mainyuanjian.btn_tuoliu.addEventListener(MouseEvent.CLICK, onclick);
			
			//定义组件名称显示
			for(var j:int = 0;j<componsList.length();j++){
				var componCon:Sprite = new Sprite();
				mainyuanjian.addChild(componCon);
				var componI:TextField = new TextField();
				componCon.addChild(componI);
				
				//开启按钮模式，同时阻止子文本域改变按钮模式
				componCon.buttonMode = true;
				componCon.mouseChildren = false;
				
				componI.x = componsList[j].X0;
				componI.y = componsList[j].Y0;
				componI.width = componsList[j].X1 - componsList[j].X0;
				componI.height = componsList[j].Y1 - componsList[j].Y0;
				componI.text = componsList[j].MC;
				componI.selectable = false;
				
				var cTF:TextFormat = new TextFormat();
				cTF.color = componsList[j].MC.@foreColor;
				cTF.font = componsList[j].MC.@fontFamily;
				cTF.size = componsList[j].MC.@fontSize;
				if(componsList[j].MC.@fontStyle == 'bold'){
					cTF.bold = true;
				}else if(componsList[j].MC.@fontStyle == 'italic'){
					cTF.italic = true;
				}
				componI.setTextFormat(cTF);
				
				//以供鼠标点击事件使用
				componCon.tabIndex = j;

				//定义点击事件
				componCon.addEventListener(MouseEvent.CLICK, resp);
				stage.addEventListener(MouseEvent.CLICK, resp2);
				
				var intro:TextField = new TextField();
				var introTf:TextFormat = new TextFormat();
				introTf.size = 14;
				
				function resp(e:MouseEvent):void {
					mainyuanjian.addChild(intro);
					intro.x = Number(componsList[e.target.tabIndex].X0) + 110;
					intro.y = Number(componsList[e.target.tabIndex].Y0) - 30;
					intro.autoSize = TextFieldAutoSize.LEFT;
					intro.wordWrap = true;
					intro.width = 190;
					intro.border = true;
					intro.background = true;
					intro.backgroundColor = 0x0000FF;
					
					if(Number(componsList[e.target.tabIndex].X0) > 700){
						intro.x = Number(componsList[e.target.tabIndex].X0);
						intro.y = Number(componsList[e.target.tabIndex].Y0) + 25;
						intro.width = 220;
					}else if(Number(componsList[e.target.tabIndex].X0) < 120 && Number(componsList[e.target.tabIndex].Y0) > 600){
						intro.x = Number(componsList[e.target.tabIndex].X0) + 200;
						intro.y = Number(componsList[e.target.tabIndex].Y0) - 280;
					}
						
					intro.text = componsList[e.target.tabIndex].MEMO;
					introTf.color = componsList[e.target.tabIndex].MEMO.@foreColor;
					introTf.font = componsList[e.target.tabIndex].MEMO.@fontFamily;
					introTf.size = componsList[e.target.tabIndex].MEMO.@fontSize;
					if(componsList[e.target.tabIndex].MEMO.@fontStyle == 'bold'){
						introTf.bold = true;
					}else if(componsList[e.target.tabIndex].MEMO.@fontStyle == 'italic'){
						introTf.italic = true;
					}
					intro.setTextFormat(introTf);
					
					// Play music
					if(componsList[e.target.tabIndex].WAV != undefined && componsList[e.target.tabIndex].WAV != ''){
						s = new SoundFacade(componsList[e.target.tabIndex].WAV, true, true, true, 100000);
						s.play();
					}
                    e.stopPropagation();
                }
				
				function resp2(e:MouseEvent):void{
					if(mainyuanjian.contains(intro)){
						if(s){
							s.stop();
						}
                        mainyuanjian.removeChild(intro);
                    }
				}
				
				
			}
			
		}
		
		private function onclick(e:MouseEvent):void{
			if(e.target.name == 'btn_tuoxiao'){
				navigateToURL(new URLRequest(tuoxiaourl));
			}else{
				navigateToURL(new URLRequest(tuoliuurl));
			}
		}
		
	}
	
}