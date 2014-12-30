package aerys.minko.render.material.basic
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.type.binding.IDataProvider;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	public class BasicMaterial extends Material
	{
		public static const DEFAULT_NAME			: String		= 'BasicMaterial';
		public static const DEFAULT_BASIC_SHADER	: BasicShader	= new BasicShader();
		public static const DEFAULT_EFFECT			: Effect		= new Effect(DEFAULT_BASIC_SHADER);
		
		public function get blending() : uint
		{
			return getProperty(BasicProperties.BLENDING);
		}
		public function set blending(value : uint) : void
		{
			setProperty(BasicProperties.BLENDING, value);
		}
		
		public function get triangleCulling() : uint
		{
			return getProperty(BasicProperties.TRIANGLE_CULLING);
		}
		public function set triangleCulling(value : uint) : void
		{
			setProperty(BasicProperties.TRIANGLE_CULLING, value);
		}
		
		public function get diffuseColor() : Object
		{
			return getProperty(BasicProperties.DIFFUSE_COLOR);
		}
		public function set diffuseColor(value : Object) : void
		{
			setProperty(BasicProperties.DIFFUSE_COLOR, value);
		}
		
		public function get diffuseMap() : TextureResource
		{
			return getProperty(BasicProperties.DIFFUSE_MAP);
		}
		public function set diffuseMap(value : TextureResource) : void
		{
			setProperty(BasicProperties.DIFFUSE_MAP, value);
		}
        
        public function get diffuseMapFiltering() : uint
        {
            return getProperty(BasicProperties.DIFFUSE_MAP_FILTERING);
        }
        public function set diffuseMapFiltering(value : uint) : void
        {
            setProperty(BasicProperties.DIFFUSE_MAP_FILTERING, value);
        }
        
        public function get diffuseMapMipMapping() : uint
        {
            return getProperty(BasicProperties.DIFFUSE_MAP_MIPMAPPING);
        }
        public function set diffuseMapMipMapping(value : uint) : void
        {
            setProperty(BasicProperties.DIFFUSE_MAP_MIPMAPPING, value);
        }
        
        public function get diffuseMapWrapping() : uint
        {
            return getProperty(BasicProperties.DIFFUSE_MAP_WRAPPING);
        }
        public function set diffuseMapWrapping(value : uint) : void
        {
            setProperty(BasicProperties.DIFFUSE_MAP_WRAPPING, value);
        }
		
        public function get diffuseMapFormat() : uint
        {
            return getProperty(BasicProperties.DIFFUSE_MAP_FORMAT);
        }
        public function set diffuseMapFormat(value : uint) : void
        {
            setProperty(BasicProperties.DIFFUSE_MAP_FORMAT, value);
        }
        
		public function get alphaMap() : TextureResource
		{
			return getProperty(BasicProperties.ALPHA_MAP) as TextureResource;
		}
		public function set alphaMap(value : TextureResource) : void
		{
			setProperty(BasicProperties.ALPHA_MAP, value);
		}
		
		public function get alphaThreshold() : Number
		{
			return getProperty(BasicProperties.ALPHA_THRESHOLD);
		}
		public function set alphaThreshold(value : Number) : void
		{
			setProperty(BasicProperties.ALPHA_THRESHOLD, value);
		}
		
		public function get depthTest() : uint
		{
			return getProperty(BasicProperties.DEPTH_TEST);
		}
		public function set depthTest(value : uint) : void
		{
			setProperty(BasicProperties.DEPTH_TEST, value);
		}
		
		public function get depthWriteEnabled() : Boolean
		{
			return getProperty(BasicProperties.DEPTH_WRITE_ENABLED);
		}
		public function set depthWriteEnabled(value : Boolean) : void
		{
			setProperty(BasicProperties.DEPTH_WRITE_ENABLED, value);
		}
		
		public function get stencilTriangleFace() : uint
		{
			return getProperty(BasicProperties.STENCIL_TRIANGLE_FACE);
		}
		public function set stencilTriangleFace(value : uint) : void
		{
			setProperty(BasicProperties.STENCIL_TRIANGLE_FACE, value);
		}
		
		public function get stencilCompareMode() : uint
		{
			return getProperty(BasicProperties.STENCIL_COMPARE_MODE);
		}
		public function set stencilCompareMode(value : uint) : void
		{
			setProperty(BasicProperties.STENCIL_COMPARE_MODE, value);
		}
		
		public function get stencilActionBothPass() : uint
		{
			return getProperty(BasicProperties.STENCIL_ACTION_BOTH_PASS);
		}
		public function set stencilActionBothPass(value : uint) : void
		{
			setProperty(BasicProperties.STENCIL_ACTION_BOTH_PASS, value);
		}
		
		public function get stencilActionDepthFail() : uint
		{
			return getProperty(BasicProperties.STENCIL_ACTION_DEPTH_FAIL);
		}
		public function set stencilActionDepthFail(value : uint) : void
		{
			setProperty(BasicProperties.STENCIL_ACTION_DEPTH_FAIL, value);
		}
		
		public function get stencilActionDepthPassStencilFail() : uint
		{
			return getProperty(BasicProperties.STENCIL_ACTION_DEPTH_PASS_STENCIL_FAIL);
		}
		public function set stencilActionDepthPassStencilFail(value : uint) : void
		{
			setProperty(BasicProperties.STENCIL_ACTION_DEPTH_PASS_STENCIL_FAIL, value);
		}
		
		public function get stencilReferenceValue() : Number
		{
			return getProperty(BasicProperties.STENCIL_REFERENCE_VALUE);
		}
		public function set stencilReferenceValue(value : Number) : void
		{
			setProperty(BasicProperties.STENCIL_REFERENCE_VALUE, value);
		}
		
		public function get stencilReadMask() : uint
		{
			return getProperty(BasicProperties.STENCIL_READ_MASK);
		}
		public function set stencilReadMask(value : uint) : void
		{
			setProperty(BasicProperties.STENCIL_READ_MASK, value);
		}
		
		public function get stencilWriteMask() : uint
		{
			return getProperty(BasicProperties.STENCIL_WRITE_MASK);
		}
		public function set stencilWriteMask(value : uint) : void
		{
			setProperty(BasicProperties.STENCIL_WRITE_MASK, value);
		}
		
		public function get diffuseTransform() : Matrix4x4
		{
			return getProperty(BasicProperties.DIFFUSE_TRANSFORM);
		}
		public function set diffuseTransform(value : Matrix4x4) : void
		{
			setProperty(BasicProperties.DIFFUSE_TRANSFORM, value);
		}
        
        public function get uvOffset() : Vector4
        {
            return getProperty(BasicProperties.UV_OFFSET);
        }
        public function set uvOffset(value : Vector4) : void
        {
            setProperty(BasicProperties.UV_OFFSET, value);
        }
        
        public function get uvScale() : Vector4
        {
            return getProperty(BasicProperties.UV_SCALE);
        }
        public function set uvScale(value : Vector4) : void
        {
            setProperty(BasicProperties.UV_SCALE, value);
        }

		public function get alphaMapChannel() : Matrix4x4
		{
			return getProperty(BasicProperties.ALPHA_MAP_CHANNEL);
		}
		public function set alphaMapChannel(value : Matrix4x4) : void
		{
			setProperty(BasicProperties.ALPHA_MAP_CHANNEL, value);
		}

		
		public function BasicMaterial(properties : Object = null, effect : Effect = null, name : String = DEFAULT_NAME)
		{
			super(effect || DEFAULT_EFFECT, properties, name);
		}
		
		override public function clone() : IDataProvider
		{
			var mat : BasicMaterial	= new BasicMaterial(this, effect, name);
			
			return mat;
		}
	}
}