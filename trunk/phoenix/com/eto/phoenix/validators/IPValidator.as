package  com.eto.phoenix.validators
{
	import mx.validators.Validator;
	import mx.validators.ValidationResult;
	import mx.validators.StringValidator;
	import mx.controls.Alert;
	
	public class IPValidator extends StringValidator
	{
		public static const NORMAL:String="NORMAL";
		public static const YANCODE:String="YANCODE";
				
		public var ValidatorState:String=NORMAL;
		public var Validate:Boolean;
				
		function IPValidator():void
		{
		}
		
		 
		public static function validateIPString(validator:IPValidator,
										  value:Object,
										  baseField:String = null):Array
		{
			var results:Array = [];
			var ip:String=String(value);
			/**
			 * *一般IP验证
			 * */
			if(validator.ValidatorState==NORMAL)
			{				
				var reip:RegExp=/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/; 
				if(!reip.test(ip))
				{
					validator.Validate=false;
					results.push(new ValidationResult(true,baseField,
							"notip","您输入的IP不正确"));
				}					
			}
			else if(validator.ValidatorState==YANCODE)
			{
				var recode:RegExp=/^((255|0)\.(255|0)\.(255|0)\.(255|0))$/;
				if(!recode.test(ip))
				{
					validator.Validate=false;
					results.push(new ValidationResult(true,baseField,
							"notcode","您输入的子网掩码不正确！"));
				}				
			}
			return results;
		}
		
		override protected function doValidation(value:Object):Array
		{			
			var results:Array = [];//清空错误列表栈
			
			var val:String=String(value);//当前的字符串		
			
			this.Validate=true;			
			
			if ((val.length == 0) && !required) //当为空并允许为空时，设置validate为true
			{											
				
				return results;
			}
			else if((val.length == 0) && required )//当为空但不允许为空时，设置validate为false
			{
				this.Validate=false;
				results.push(new ValidationResult(true,null,
							"none","该项目为必填，并且不允许空值."));
				return results;
			}
			else //当不为空时							
			return validateIPString(this,value,null)
		}
		
	}
}