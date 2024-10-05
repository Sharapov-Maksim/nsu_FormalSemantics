// Generated from C:/projects/nsu_FormalSemantics/antlr_parser/antlr_parser/Python.g4 by ANTLR 4.13.1
package nsu.mmf.formalsemantics.antlr;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link PythonParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface PythonVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link PythonParser#r}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitR(PythonParser.RContext ctx);
}