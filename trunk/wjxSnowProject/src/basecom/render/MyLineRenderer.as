package basecom.render
{
	 import mx.charts.renderers.LineRenderer;
    import mx.charts.series.items.LineSeriesItem;   
    import mx.charts.series.renderData.LineSeriesRenderData;
    import mx.charts.series.items.LineSeriesSegment;    
    import mx.charts.renderers.CircleItemRenderer;  
    import flash.display.Graphics;
    import flash.geom.Rectangle;
    import mx.charts.ChartItem;
    import mx.charts.chartClasses.GraphicsUtilities;
    import mx.core.IDataRenderer;
    import mx.graphics.IFill;
    import mx.graphics.IStroke; 

    public class MyLineRenderer extends LineRenderer
    {
        private static var rcFill:Rectangle = new Rectangle();      
        
        public function MyLineRenderer()
        {
            super();
        }
        
        override protected function updateDisplayList(unscaledWidth:Number,
                                                      unscaledHeight:Number):void
        {
            var l:int=(data as LineSeriesSegment).items.length;
            if(l==1){           
                var item:LineSeriesItem=((data as LineSeriesSegment).items[0] as LineSeriesItem)
                var fill:IFill = GraphicsUtilities.fillFromStyle(getStyle("fill"));
                var stroke:IStroke = getStyle("stroke");
                        
                var w:Number = stroke ? stroke.weight / 2 : 0;
        
                rcFill.right = 2;
                rcFill.bottom = 2;
        
                var g:Graphics = graphics;
                g.clear();      
                if (stroke)
                    stroke.apply(g);
                if (fill)
                    fill.begin(g, rcFill);
                g.drawCircle(item.x, item.y, 3);
                if (fill)
                    fill.end(g);
            }
            else{
                super.updateDisplayList(unscaledWidth, unscaledHeight);         
            }   
        }       
    }
}

