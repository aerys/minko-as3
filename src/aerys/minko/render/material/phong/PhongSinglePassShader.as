package aerys.minko.render.material.phong
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.ShaderOptimization;
	import aerys.minko.render.shader.part.phong.LightAwareDiffuseShaderPart;
	import aerys.minko.render.shader.part.phong.PhongShaderPart;
	
	public class PhongSinglePassShader extends BasicShader
	{
		private var _diffuse	: LightAwareDiffuseShaderPart;
		private var _phong		: PhongShaderPart;

		public function PhongSinglePassShader(renderTarget	: RenderTarget		= null,
                                              priority		: Number			= 0.)
		{
			super(renderTarget, priority);
			
			optimization |= ShaderOptimization.RESOLVED_PARAMETRIZATION;
			
			// init shader parts
			_diffuse	= new LightAwareDiffuseShaderPart(this);
			_phong		= new PhongShaderPart(this);
		}

		override protected function getPixelColor() : SFloat
		{
            var materialDiffuse : SFloat = _diffuse.getDiffuseColor();
			var staticLighting 	: SFloat = _phong.getStaticLighting();
			var dynamicLighting	: SFloat = _phong.getDynamicLighting(-1, true, true, true);			
			var shading 		: SFloat = add(staticLighting, dynamicLighting);

			return multiply(shading, materialDiffuse);
		}
	}
}
