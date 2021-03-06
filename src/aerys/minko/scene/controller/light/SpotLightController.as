package aerys.minko.scene.controller.light
{
	import aerys.minko.scene.data.LightDataProvider;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.scene.node.light.AbstractLight;
	import aerys.minko.scene.node.light.SpotLight;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;

	/**
	 * 
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public final class SpotLightController extends LightShadowController
	{
		private static const SCREEN_TO_UV	: Matrix4x4	= new Matrix4x4(
			.5,		.0,		.0,		.0,
			.0, 	-.5,	.0,		.0,
			.0,		.0,		1.,		.0,
			.5, 	.5,		.0, 	1.
		);
		
		private var _worldPosition	: Vector4;
		private var _worldDirection	: Vector4;
		private var _projection		: Matrix4x4;
		private var _worldToScreen	: Matrix4x4;
		private var _worldToUV		: Matrix4x4;
		
		public function SpotLightController()
		{
			super(SpotLight, ShadowMappingType.PCF | ShadowMappingType.VARIANCE | ShadowMappingType.EXPONENTIAL);
			
			initialize();
		}
		
		private function initialize() : void
		{
			_worldDirection = new Vector4();
			_worldPosition = new Vector4();
			_projection = new Matrix4x4();
			_worldToScreen = new Matrix4x4();
			_worldToUV = new Matrix4x4();
		}
		
		override protected function targetAddedHandler(ctrl	: LightController,
													  light	: AbstractLight) : void
		{
			super.targetAddedHandler(ctrl, light);
			
			lightData.setLightProperty('worldDirection', _worldDirection);
			lightData.setLightProperty('worldPosition', _worldPosition);
			lightData.setLightProperty('projection', _projection);
			lightData.setLightProperty('worldToScreen', _worldToScreen);
			lightData.setLightProperty('worldToUV', _worldToUV);
		}
		
		override protected function lightAddedToScene(scene : Scene) : void
		{
			super.lightAddedToScene(scene);
			
			updateProjectionMatrix();
			lightLocalToWorldChangedHandler(light, light.getLocalToWorldTransform());
			light.localToWorldTransformChanged.add(lightLocalToWorldChangedHandler);
		}
		
		override protected function lightRemovedFromScene(scene : Scene) : void
		{
			super.lightRemovedFromScene(scene);
			
			light.localToWorldTransformChanged.remove(lightLocalToWorldChangedHandler);
		}
		
		private function lightLocalToWorldChangedHandler(light			: AbstractLight,
														 localToWorld 	: Matrix4x4) : void
		{
			_worldPosition	= localToWorld.getTranslation(_worldPosition);
			
			_worldDirection.lock();
			_worldDirection	= localToWorld.deltaTransformVector(Vector4.Z_AXIS, _worldDirection);
			_worldDirection.normalize();
			_worldDirection.unlock();
			
			_worldToScreen.lock()
				.copyFrom(localToWorld)
				.invert()
				.append(_projection)
				.unlock();
			
			_worldToUV.lock()
				.copyFrom(_worldToScreen)
				.append(SCREEN_TO_UV)
				.unlock();
		}
		
		override protected function lightDataChangedHandler(lightData		: LightDataProvider,
															propertyName	: String,
															bindingName		: String,
															value			: Object) : void
		{
			super.lightDataChangedHandler(lightData, propertyName, bindingName, value);
			
			propertyName = LightDataProvider.getPropertyName(propertyName);
			
			if (propertyName == 'shadowZNear' || propertyName == 'shadowZFar'
			    || propertyName == 'outerRadius')
				updateProjectionMatrix();
		}
		
		private function updateProjectionMatrix() : void
		{
			var zNear		: Number 	= lightData.getLightProperty('shadowZNear');
			var zFar		: Number 	= lightData.getLightProperty('shadowZFar');
			var outerRadius	: Number	= lightData.getLightProperty('outerRadius');
			var fd			: Number 	= 1. / Math.tan(outerRadius * .5);
			var m33			: Number 	= 1. / (zFar - zNear);
			var m43			: Number 	= -zNear / (zFar - zNear);
			
			_projection.initialize(
				fd, 	0.,		0.,		0.,
				0.,		fd, 	0.,		0.,
				0.,		0.,		m33, 	1.,
				0.,		0.,		m43,	0.
			);
			
			_worldToScreen.lock()
                .copyFrom(light.getWorldToLocalTransform())
                .append(_projection)
                .unlock();
            
			_worldToUV.lock()
                .copyFrom(_worldToScreen)
                .append(SCREEN_TO_UV)
                .unlock();
		}
	}
}