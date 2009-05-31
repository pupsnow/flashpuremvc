package com.eto.phoenix.validators
{
	import mx.validators.Validator;
	import mx.validators.ValidationResult;
	import mx.validators.StringValidator;
	
	public class SamePassWordValidator extends StringValidator
	{
		public static const SOURCE:String="SOURCE";
		public static const TARGET:String="TARGET";
		
		public var ValidatorState:String=SOURCE
		function SamePassWordValidator():void
		{
			this.requiredFieldError="该项目为必填，并且不允许空值."
		}
		private var _OtherData:Object
		
		public function set otherData(arr:Object):void
		{
			_OtherData=arr;
		}
		
		public function get otherData():Object
		{
			return _OtherData;
		}
		
		public static function validateString(validator:SamePassWordValidator,
										  value:Object,
										  baseField:String = null):Array
		{
			var results:Array = [];
			if((validator.source.text!=validator._OtherData.text)&&(validator.ValidatorState==TARGET))
			{
				results.push(new ValidationResult(true,baseField,
							"notsame","您输入的密码不相同！"));
			}
			return results;
		}
		
		override protected function doValidation(value:Object):Array
		{
			var results:Array=super.doValidation(value);
			var val:String=String(value);
			if (results.length > 0 || ((val.length == 0) && !required))
			return results
			else
			return validateString(this,value,null);
		}		
	}
}