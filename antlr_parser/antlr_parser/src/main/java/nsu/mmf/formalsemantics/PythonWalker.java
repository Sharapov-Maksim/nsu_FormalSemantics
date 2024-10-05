package nsu.mmf.formalsemantics;

import nsu.mmf.formalsemantics.antlr.PythonBaseListener;
import nsu.mmf.formalsemantics.antlr.PythonParser;

public class PythonWalker extends PythonBaseListener {

    public void enterR(PythonParser.RContext ctx ) {
        System.out.println( "Entering R : " + ctx.ID().getText() );
    }

    public void exitR(PythonParser.RContext ctx ) {
        System.out.println( "Exiting R" );
    }

}
