package nsu.mmf.formalsemantics;

import nsu.mmf.formalsemantics.antlr.Python3Parser.Single_inputContext;
import nsu.mmf.formalsemantics.antlr.Python3ParserBaseListener;
import nsu.mmf.formalsemantics.antlr.Python3Parser;

public class PythonWalker extends Python3ParserBaseListener {

    @Override
    public void enterSingle_input(Single_inputContext ctx) {
        System.out.println("Entering single_input: " + ctx.simple_stmts().getText());
    }

//    public void enterR(Python3Parser.RContext ctx ) {
//        System.out.println( "Entering R : " + ctx.ID().getText() );
//    }
//
//    public void exitR(PythonParser.RContext ctx ) {
//        System.out.println( "Exiting R" );
//    }

}
