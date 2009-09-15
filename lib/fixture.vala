using GLib;

namespace Valadate {
	/**
	 * Marker interface for unit tests.
	 *
	 * To define a test suite, imlement this interface.
	 * The runner will execute all methods whose names begin with "test_"
	 * in that class, each on a separate instance.
	 *
	 * The set_up() method will be called before each test and
	 * tear_down() will be called after. Since each test is run on
	 * a separate instance, you can use construct block and destructor
	 * with the same effect.
	 *
	 * [[warning:
	 *   The constructor will ++not++ be called, because the object will
	 *   be constructed using GLib.Object.newv. You have to use the
	 *   //construct// block.
	 * ]]
	 *
	 * Example:
	 * {{{
	 * class Test1 : Object, Valadate.Fixture {
	 *     construct {
	 *         stdout.printf ("Constructing fixture");
	 *     }
	 *     ~Test1 {
	 *         stdout.printf ("Destroying fixture");
	 *     }
	 *     public void test_1 () {
	 *         assert (0 != 1);
	 *     }
	 * }
	 * }}}
	 *
	 * If you define some public constructible properties and for each
	 * property define a static method named
	 * "generate_"//property-name// returning a ValueArray, each test
	 * will be called once for each value in the returned array. If you
	 * define multiple property-generator pairs, the tests will be run
	 * for each combination.
	 */
	public interface Fixture : Object {
		/**
		 * Called after construction before a test is run.
		 *
		 * You can use construct block (but not constructor) to the
		 * same effect.
		 */
		public virtual void set_up() {}

		/**
		 * Called after a test is run before the object is destroyed.
		 *
		 * You can use destructor to the same effect.
		 */
		public virtual void tear_down() {}
	}
}
