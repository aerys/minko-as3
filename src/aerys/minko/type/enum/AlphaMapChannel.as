package aerys.minko.type.enum
{
	import aerys.minko.type.math.Matrix4x4;
	
	public class AlphaMapChannel
	{
		public static const RED		: Matrix4x4		= new Matrix4x4( 1,0,0,0, 0,0,0,0, 0,0,0,0,	0,0,0,0	);
		public static const GREEN	: Matrix4x4		= new Matrix4x4( 0,0,0,0, 1,0,0,0, 0,0,0,0,	0,0,0,0	);
		public static const BLUE	: Matrix4x4		= new Matrix4x4( 0,0,0,0, 0,0,0,0, 1,0,0,0,	0,0,0,0	);
		public static const ALPHA	: Matrix4x4		= new Matrix4x4( 0,0,0,0, 0,0,0,0, 0,0,0,0,	1,0,0,0	);
	}
}
