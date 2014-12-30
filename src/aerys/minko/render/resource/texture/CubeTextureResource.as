package aerys.minko.render.resource.texture
{
	import aerys.minko.render.resource.Context3DResource;
	import aerys.minko.type.Signal;
	import aerys.minko.type.enum.SamplerFormat;

	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	/**
	 * @inheritdoc
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public final class CubeTextureResource implements ITextureResource
	{
		private static const SIDE_X : Vector.<Number> = new <Number>[2, 0, 1, 1, 1, 3];
		private static const SIDE_Y : Vector.<Number> = new <Number>[1, 1, 0, 2, 1, 1];

		private static const FORMAT_BGRA				: String	= 'bgra';
		private static const FORMAT_COMPRESSED			: String	= 'compressed';
		private static const FORMAT_COMPRESSED_ALPHA 	: String 	= 'compressedAlpha';

		private static const TEXTURE_FORMAT_TO_SAMPLER	: Array 	= []
		{
			TEXTURE_FORMAT_TO_SAMPLER[FORMAT_BGRA] 				= SamplerFormat.RGBA;
			TEXTURE_FORMAT_TO_SAMPLER[FORMAT_COMPRESSED] 		= SamplerFormat.COMPRESSED;
			TEXTURE_FORMAT_TO_SAMPLER[FORMAT_COMPRESSED_ALPHA] 	= SamplerFormat.COMPRESSED_ALPHA;
		}

		private var _bitmapDatas				: Vector.<BitmapData>;
		private var _texture					: CubeTexture;
		private var _size						: uint;
        private var _mipMapping					: Boolean;
		private var _atf						: ByteArray;
		private var _atfFormat					: uint;
		private var _format 					: String = FORMAT_BGRA;

		private var _update						: Boolean;
		private var _disposed					: Boolean;
		
		private var _contextLost				: Signal		= new Signal("TextureResource.contextLost");
		private var _contextLostHandlerAdded	: Boolean		= false;
		
        public function get format() : uint
        {
	        return TEXTURE_FORMAT_TO_SAMPLER[_format];
        }
        
        public function get mipMapping() : Boolean
        {
            return _mipMapping;
        }
		
		public function get width() : uint
		{
			return size;
		}
		
		public function get height() : uint
		{
			return size;
		}
		
		public function get size() : uint
		{
			return _size;
		}

		public function CubeTextureResource(size : uint)
		{
			_size = size;
		}

		public function setContentFromBitmapData(bitmapData	: BitmapData,
												 mipmap		: Boolean,
												 downSample	: Boolean	= false) : void
		{
			_bitmapDatas = new <BitmapData>[];
            _mipMapping = mipmap;
			_format = FORMAT_BGRA;
			_update	= true;

			var width	: Number = bitmapData.width / 4;
			var height	: Number = bitmapData.height / 3;
			
			var tmpMatrix		: Matrix		= new Matrix(1, 0, 0, 1);
			for (var side : uint = 0; side < 6; ++side)
			{
				var sideBitmapData	: BitmapData	= new BitmapData(width, height, false, 0);
                
				tmpMatrix.tx	= - SIDE_X[side] * width;
				tmpMatrix.ty	= - SIDE_Y[side] * height;
				
				sideBitmapData.draw(bitmapData, tmpMatrix);
				_bitmapDatas.push(sideBitmapData);
			}
		}
		
		public function setSize(w : uint, h : uint) : void
		{
			_size = w;
		}
		
		public function setContentFromBitmapDatas(right 	: BitmapData,
												  left		: BitmapData,
												  top		: BitmapData,
												  bottom	: BitmapData,
												  front		: BitmapData,
												  back		: BitmapData,
												  mipmap	: Boolean) : void
		{

			_bitmapDatas = new <BitmapData>[right, left, top, bottom, front, back];
            _mipMapping = mipmap;
			_format = FORMAT_BGRA;
			_update	= true;

		}
		
		public function setContentFromATF(atf : ByteArray) : void
		{
			_atf			= atf;
			_bitmapDatas    = null;
			_update			= true;


			var oldSize 	: uint = _size;
			var oldFormat	: String = _format;

			if (atf[6] == 0xFF)
				atf.position 	= 12;
			else
				atf.position 	= 6;

			var formatByte 	: uint = atf.readUnsignedByte();
			
			_atfFormat 		= formatByte & 0x7F;
			_size 			= 1 << atf.readUnsignedByte();

			atf.position 	= 0;

			switch(_atfFormat)
			{
				case 0:
				case 1: 
					_format = FORMAT_BGRA;
					break;
				case 2:
				case 3:
					_format = FORMAT_COMPRESSED;
					break;
				case 4:
				case 5:
					_format = FORMAT_COMPRESSED_ALPHA;
					break;
				default:
					throw new Error("Invalid ATF format");
			}

			if (_texture
					&& (oldFormat != _format
					|| oldSize != _size
					))
			{
				_texture.dispose();
				_texture = null;
			}
			
		}

		private function contextLostHandler(context : Context3DResource) : void
		{
			if (_disposed)
				return;
			_texture = null;
			_contextLost.execute(this);
		}
		
		public function getTexture(context : Context3DResource) : TextureBase
		{

			if (!_contextLostHandlerAdded)
			{
				context.contextChanged.add(contextLostHandler);
				_contextLostHandlerAdded = true;
			}

			if (!_texture && _size)
			{
				if (_texture)
					_texture.dispose();
					
				_texture = context.createCubeTexture(
					_size,
					_format,
					_bitmapDatas != null && _atf == null
				);
				
			}

			if (_update)
			{
				_update = false;
				uploadBitmapDataWithMipMaps();
			}
			
			return _texture;
			
		}
				
		private function uploadBitmapDataWithMipMaps() : void
		{
			
			if (_bitmapDatas != null)
			{
				for (var side : uint = 0; side < 6; ++side)
				{
					var mipmapId	: uint			= 0;
					var mySize		: uint			= _size;
					var bitmapData	: BitmapData	= _bitmapDatas[side];
                    
                    if (!_mipMapping)
                        _texture.uploadFromBitmapData(bitmapData, side);
                    else
                    {
                        while (mySize >= 1)
    					{
    						var tmpMatrix		: Matrix		= new Matrix();
    						var tmpBitmapData	: BitmapData	= new BitmapData(
                                mySize, mySize, false, 0x005500
                            );
    						
    						tmpMatrix.a		= mySize / bitmapData.width;
    						tmpMatrix.d		= mySize / bitmapData.height;
    						
    						tmpBitmapData.draw(bitmapData, tmpMatrix);
    						_texture.uploadFromBitmapData(tmpBitmapData, side, mipmapId);
    						
    						++mipmapId;
    						mySize /= 2;
    						tmpBitmapData.dispose()
    					}
                    }
                    
					bitmapData.dispose();
					
				}
				
				_bitmapDatas = null;
			}
			else if (_atf)
			{
				_texture.uploadCompressedTextureFromByteArray(_atf, 0);
				
				_atf.clear();
				_atf = null;
			}
			
		}
		
		public function dispose() : void
		{
			_disposed = true;
			if (_texture)
			{
				_texture.dispose();
				_texture = null;
			}
		}
		
	}
	
}
