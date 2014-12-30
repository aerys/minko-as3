package aerys.minko.render.shader.part
{
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerFormat;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	
	public class DiffuseShaderPart extends ShaderPart
	{
		/**
		 * The shader part to use a diffuse map or fallback and use a solid color.
		 *  
		 * @param main
		 * 
		 */
		public function DiffuseShaderPart(main : Shader)
		{
			super(main);
		}
		
		public function getDiffuseColor(killOnAlphaThreshold : Boolean = true, uv : SFloat = null) : SFloat
		{
			var diffuseColor : SFloat	= null;
			var useVertexUv  : Boolean  = uv == null;

			if (meshBindings.propertyExists(VertexComponent.UV.toString()))
			{
            	uv ||= vertexUV.xy;
			
				if (meshBindings.propertyExists(BasicProperties.UV_SCALE))
					uv.scaleBy(meshBindings.getParameter(BasicProperties.UV_SCALE, 2));
			
				if (meshBindings.propertyExists(BasicProperties.UV_OFFSET))
					uv.incrementBy(meshBindings.getParameter(BasicProperties.UV_OFFSET, 2));

				if (useVertexUv)
					uv = interpolate(uv);
			}
			if (meshBindings.propertyExists(BasicProperties.DIFFUSE_MAP) && 
				(meshBindings.propertyExists(VertexComponent.UV.toString()) || meshBindings.propertyExists(VertexComponent.XY.toString()))) // mesh or sprite
			{
				var diffuseMap	: SFloat	= meshBindings.getTextureParameter(
					BasicProperties.DIFFUSE_MAP,
					meshBindings.getProperty(BasicProperties.DIFFUSE_MAP_FILTERING, SamplerFiltering.LINEAR),
					meshBindings.getProperty(BasicProperties.DIFFUSE_MAP_MIPMAPPING, SamplerMipMapping.LINEAR),
					meshBindings.getProperty(BasicProperties.DIFFUSE_MAP_WRAPPING, SamplerWrapping.REPEAT),
					0,
                    meshBindings.getProperty(BasicProperties.DIFFUSE_MAP_FORMAT, SamplerFormat.RGBA)
				);
				
				diffuseColor = sampleTexture(diffuseMap, uv);
			}
			else if (meshBindings.propertyExists(BasicProperties.DIFFUSE_COLOR))
			{
				diffuseColor = meshBindings.getParameter(BasicProperties.DIFFUSE_COLOR, 4);
			}
			else
			{
				diffuseColor = float4(0., 0., 0., 1.);
			}
			
			if (meshBindings.propertyExists(BasicProperties.ALPHA_MAP))
			{	
				var alphaMap 	: SFloat 	= meshBindings.getTextureParameter(
					BasicProperties.ALPHA_MAP,
					meshBindings.getProperty(BasicProperties.ALPHA_MAP_FILTERING, SamplerFiltering.LINEAR),
					meshBindings.getProperty(BasicProperties.ALPHA_MAP_MIPMAPPING, SamplerMipMapping.LINEAR),
					meshBindings.getProperty(BasicProperties.ALPHA_MAP_WRAPPING, SamplerWrapping.REPEAT),
					0,
					meshBindings.getProperty(BasicProperties.ALPHA_MAP_FORMAT, SamplerFormat.RGBA));

				if (meshBindings.propertyExists(BasicProperties.ALPHA_MAP_UV_SCALE))
				{
					uv = vertexUV.xy;
					uv.scaleBy(meshBindings.getParameter(BasicProperties.ALPHA_MAP_UV_SCALE, 2));
				}
			
				if (meshBindings.propertyExists(BasicProperties.ALPHA_MAP_UV_OFFSET))
					uv.incrementBy(meshBindings.getParameter(BasicProperties.ALPHA_MAP_UV_OFFSET, 2));
					
				uv = interpolate(uv);
				
				var alphaSample	: SFloat	= sampleTexture(alphaMap, uv);

				// Optionally, select alpha channel
				if (meshBindings.propertyExists(BasicProperties.ALPHA_MAP_CHANNEL))
				{
					alphaSample = multiply4x4(
						alphaSample,
						meshBindings.getParameter(BasicProperties.ALPHA_MAP_CHANNEL, 16)
					);
				}
				
				diffuseColor = float4(diffuseColor.rgb, alphaSample.r);
			}
			
			if (meshBindings.propertyExists(BasicProperties.DIFFUSE_TRANSFORM))
			{
				diffuseColor = multiply4x4(
					diffuseColor,
					meshBindings.getParameter(BasicProperties.DIFFUSE_TRANSFORM, 16)
				);
			}
			
			if (killOnAlphaThreshold && meshBindings.propertyExists(BasicProperties.ALPHA_THRESHOLD))
			{
				var alphaThreshold : SFloat = meshBindings.getParameter(
					BasicProperties.ALPHA_THRESHOLD, 1
				);
				
				kill(subtract(0.5, lessThan(diffuseColor.w, alphaThreshold)));
			}
			
			return diffuseColor;
		}
	}
}