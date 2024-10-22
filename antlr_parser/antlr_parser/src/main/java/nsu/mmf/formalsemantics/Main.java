package nsu.mmf.formalsemantics;

import nsu.mmf.formalsemantics.antlr.Python3Lexer;
import nsu.mmf.formalsemantics.antlr.Python3Parser;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

public class Main {

    public static void main(String[] args) {
        Python3Lexer lexer = new Python3Lexer(CharStreams.fromString("a = 23\n"));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        Python3Parser parser = new Python3Parser(tokens);
        ParseTree tree = parser.single_input();
        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(new PythonWalker(), tree);
    }
}