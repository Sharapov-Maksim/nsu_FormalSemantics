// Generated from C:/projects/nsu_FormalSemantics/antlr_parser/antlr_parser/Python.g4 by ANTLR 4.13.1
package nsu.mmf.formalsemantics.antlr;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;

/**
 * This class provides an empty implementation of {@link PythonVisitor},
 * which can be extended to create a visitor which only needs to handle a subset
 * of the available methods.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
@SuppressWarnings("CheckReturnValue")
public class PythonBaseVisitor<T> extends AbstractParseTreeVisitor<T> implements PythonVisitor<T> {
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public T visitR(PythonParser.RContext ctx) { return visitChildren(ctx); }
}