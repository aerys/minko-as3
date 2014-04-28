package aerys.minko.render.shader.background
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.part.DiffuseShaderPart;
	
	public class BackgroundLayerShader extends BasicShader
	{
		private static const ZMAX	: Number	= 1. - 1e-7;
        
        private var _diffuse    : DiffuseShaderPart;
        private var _uv         : SFloat;
        
		public function BackgroundLayerShader(target : RenderTarget = null)
		{
			super(target, 0.);
            
            _diffuse = new DiffuseShaderPart(this);
		}
		
		override protected function getVertexPosition() : SFloat
		{
			_uv = multiply(add(vertexXYZ.xy, 0.5), float2(1, -1));
			return float4(sign(vertexXYZ.xy), ZMAX, 1);
		}
		
		override protected function getPixelColor() : SFloat
		{
            return _diffuse.getDiffuseColor(false, interpolate(_uv));
		}
	}
}
