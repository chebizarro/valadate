namespace Valadate {

	public abstract class GdbTestCase : TestCase {

		// prologue.py sets a breakpoint on this function;
		// test functions can call it to easily return control to GDB where desired.
		public void breakpoint() {
			// If we leave this function empty, the linker will unify it with other
			// empty functions. If we then set a GDB breakpoint on it,
			// that breakpoint will hit at all sorts of random
			// times. So make it perform a distinctive side effect.
			stderr.printf("Called %s :breakpoint\n", GLib.Log.FILE);
		}

	}

}
