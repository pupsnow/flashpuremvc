package  org.puremvc.as3.demos.flex.login.controller
{
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

   
    public class ApplicationStartupCommand extends MacroCommand
    {
        
        override protected function initializeMacroCommand() :void
        {
            addSubCommand( ModelPrepCommand );
            addSubCommand( StartUpCommand );
        }
    }
}
