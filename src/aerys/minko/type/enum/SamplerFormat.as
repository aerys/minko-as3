package aerys.minko.type.enum
{
	import aerys.minko.ns.minko_shader;
	
    public final class SamplerFormat
    {
        public static const RGBA                : uint  = 0;
        public static const COMPRESSED          : uint  = 1;
        public static const COMPRESSED_ALPHA    : uint  = 2;
        
        minko_shader static const STRINGS : Vector.<String> = new <String>['rgba', 'dxt1','dxt5'];
        
    }
}