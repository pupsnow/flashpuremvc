package  basecom.sjd.validators
{
	import mx.validators.Validator;
     import mx.validators.ValidationResult;

	 public class AddressValidator extends Validator{
     private var results:Array;
      public function AddressValidator(){
        super();
        }
	
	   override protected function doValidation(value:Object):Array{
                 results = [];
                 results = super.doValidation(value);
                  if(value!=null){
                   var pattern:RegExp =/^\d{3}$|^\d{5}$|^\d{8}[xX]$/
                   //new RegExp("\\d{17}|\\d{15}|\\d{10}");
                  
                  // new RegExp("\\d+\\x20[A-Za-z]+", "");
                  trace(value.search(pattern));
                   if(value.search(pattern) == -1){
                    results.push(new ValidationResult (true, null, "notAddress", "This is not a valid US address"));
               }
            }
                    return results;
}



}
}
