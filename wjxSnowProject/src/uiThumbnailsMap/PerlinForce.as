package  uiThumbnailsMap
{
	import flash.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.filters.*;
	import mx.core.UIComponent;
	import flash.text.TextField;
	
	public class PerlinForce extends Sprite
	{
		private const origin: Point = new Point();
		
		private var w: int = 256;
		private var h: int = 256;
		
		private const x1: Matrix = new Matrix( 1, 0, 0, 1, 0, 0 );
		private const x2: Matrix = new Matrix( 2, 0, 0, 2, 0, 0 );
		
		//-- fps
		private var fpsText : TextField;
		private var fr: int;
		private var ms: int;
		
		private var force_s: BitmapData;
		private var force_b: BitmapData;
		
		private var forceOffsets: Array;
		private var points: Array;
		private var forceRand: uint;
		
		private var buffer: BitmapData;
		private var output: BitmapData;
		private var damp: ColorTransform;
		private var fxm: Matrix;
		
		private var Stage : UIComponent;
		
		public function PerlinForce( Stage : UIComponent )
		{
			this.Stage = Stage;
			w = Stage.width;
			h = Stage.height;
			
			if ( w > 500 ) w = 500;
			if ( h > 250 ) h = 250;
			
			init();
			fpsText = new TextField();
			fpsText.autoSize = 'left';
			fpsText.textColor = 0xefefef;
			addChild( fpsText );
			ms = getTimer();
			fr = 0;
		}
		
		private function init(): void
		{
			output = new BitmapData( w, h, false, 0 );
			buffer = new BitmapData( w, h, false, 0 );
			
			var scl: Number = .25;
			
			fxm = new Matrix();
			fxm.a = ( w + scl ) / w;
			fxm.d = ( h + scl ) / h;
			fxm.tx = -scl / 1;
			damp = new ColorTransform(1,1,1,1,0,0,0,0 );//1, 1, 1, 1, -2, -2, -2, 0 );
			
			force_s = new BitmapData( w/2, w/2, false, 0 );
			force_b = new BitmapData( w, h, false, 0 );
			
			addChild( new Bitmap( output ) );
			
			points = new Array();
		
			var point: Object;
			var i: Number = 500;
			while( --i > -1 )
			{
				point = { sx: w / 4 + Math.random() * w / 2, sy: h / 4 + Math.random() * h / 2, vx: 0, vy: 0, bounce: 0 };
				
				points.push( point );
			}
			
			forceOffsets = [ new Point() ];
			forceOffsets.x = Math.random()*2000;
			forceOffsets.y = Math.random()*2000;
			
			forceRand = Math.floor(Math.random()*1000);
			
			Stage.addEventListener( 'enterFrame', run );
		}
		
		private function run( event: Event ): void
		{
			forceOffsets[0].x+=2;
			forceOffsets[0].y+=(Math.random()*2);
			
			force_s.perlinNoise( 100, 100, 1, forceRand, true, true, 6, false, forceOffsets );
			force_b.draw( force_s, x2, null, null, null, true );
			
			//blur previous
			var bf:BlurFilter = new BlurFilter(2,2,1);
			buffer.applyFilter(buffer,buffer.rect, origin, bf);
			
			
			//-- move points with respect to force
			var point: Object;
			
			var sx: Number;
			var sy: Number;
			var vx: Number;
			var vy: Number;
			
			var c: int;
			var i: Number = points.length;
			while( --i > -1 )
			{
			point = points[i];
			
			sx = point.sx;
			sy = point.sy;
			vx = point.vx;
			vy = point.vy;
			
			c = force_b.getPixel( sx | 0, sy | 0 );
			
			vx += ( ( ( c >> 8 ) & 0xff ) - 0x80 ) / 256;
			vy += ( ( c & 0xff ) - 0x70 ) / 256;
			
			vx *= .9;
			vy *= .9;
			
			sx += vx;
			sy += vy;
			
			if (point.bounce++>3) {
				//simple wrap
				point.bounce = 0;
				if (sx<0) sx += w;
				if (sx>w) sx -= w;
				if (sy<0) sy += h;
				if (sy>h) sy -= h;
			}
			else {
			//bounce
				if( sx < 0 )
				{
					sx = 0;
					vx *= -( Math.random() * 10 );
				}
				if( sx > w )
				{
					sx = w;
					vx *= -( Math.random() * 10 );
				}
				if( sy < 0 )
				{
					sy = 0;
					vy *= -( Math.random() * 10 );
				}
				if( sy > h )
				{
					sy = h;
					vy *= -( Math.random() * 10 );
				}
			}
				point.sx = sx;
				point.sy = sy;
				point.vx = vx;
				point.vy = vy;
				
				buffer.setPixel( sx | 0, sy | 0, 0xffffff - c + (Math.floor(vx*vy)<<4) );
			}
			
			buffer.draw( buffer, fxm, damp, BlendMode.DARKEN, null, true );
			
			output.copyPixels( buffer, buffer.rect, origin );
			
			//-- fps
			fr++;
			if( ms + 1000 < getTimer() )
			{
				fpsText.text = fr.toString();
				fr = 0;
				ms = getTimer();
			}
		}
	}
}