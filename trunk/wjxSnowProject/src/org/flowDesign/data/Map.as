package  org.flowDesign.data
{
	public interface Map
	{
			/**
		 * 将指定的值与此映射中的指定键相关联.
		 * @param key 与指定值相关联的键.
		 * @param value 与指定键相关联的值.
		 */
		 function put(key:String,value:Object):*;
		
		/**
		 * 返回此映射中映射到指定键的值.
		 * @param key 与指定值相关联的键.
		 * @return 此映射中映射到指定值的键，如果此映射不包含该键的映射关系，则返回 null.
		 */
		 function getKey(key:String):*;
		
		/**
		 * 从此映射中移除所有映射关系
		 */
		 function clear():void;
		
		/**
		 * 如果存在此键的映射关系，则将其从映射中移除
		 * @param key 从映射中移除其映射关系的键
		 * @return 以前与指定键相关联的值，如果没有该键的映射关系，则返回 null
		 */
		 function remove(key:String):*;
		
		/**
		 * 返回此映射中的键-值映射关系数.
		 * @return 此映射中的键-值映射关系的个数.
		 */
		 function size():Number;
		
		/**
		 * 如果此映射未包含键-值映射关系，则返回 true.
		 * @return 如果此映射未包含键-值映射关系，则返回 true.
		 */
		 function isEmpty():Boolean;
		
		/**
		 * 如果此映射包含指定键的映射关系，则返回 true.
		 * @param key  测试在此映射中是否存在的键.
		 * @return 如果此映射包含指定键的映射关系，则返回 true.
		 */
		 function containsKey(key:String):Boolean;
		
		/**
		 * 如果该映射将一个或多个键映射到指定值，则返回 true.
		 * @param key 测试在该映射中是否存在的值
		 * @return 如果该映射将一个或多个键映射到指定值，则返回 true.
		 */
		 function containsValue(value:Object):Boolean;
		
		/**
		 * 返回此映射中包含的所有值.
		 * @return 包含所有值的数组
		 */
		 function values():Array;
		
		/**
		 * 返回此映射中包含的所有key值.
		 * @return 包含所有key的数组
		 */
		 function keys():Array;
		
		/**
		 * 返回此映射中包含的所有key值.
		 * @return 包含所有key的数组
		 */
		 function getKeyAndValues():Object;
		
	}
}