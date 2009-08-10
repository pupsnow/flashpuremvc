package basecom.sjd.validators
{   
	/*
	class MultipTipsValidationResult
	brief ValidationResult that uesd in MultipTipsValidation, returned in the result array of MultipTipsValidator.doValidation
	 */
	import mx.validators.ValidationResult;
	public class MultipTipsValidationResult extends ValidationResult{
		
		public var errorFieldId:String = "";
		
		public function MultipTipsValidationResult(fieldId:String, isError:Boolean, subField:String="", errorCode:String="", errorMessage:String=""){
			this.errorFieldId = fieldId;
			super(isError, subField, errorCode, errorMessage);
		}
	}
}