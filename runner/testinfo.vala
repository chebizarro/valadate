using GLib;
using Introspection;

struct FixturePointer {
	public Valadate.Fixture fixture;
}

class TestInfo {
	Type fx_type;
	ObjectInfo fx_info;
	FunctionInfo fn_info;
	Parameter[] parameters;

	// Interface for the GTestCase.
	private void set_up(void * data) {
		FixturePointer *fp = data;
		// FIMXE: The params will have to be here, but binding for g_object_newv is needed first...
		fp->fixture = Object.newv(fx_type, parameters) as Valadate.Fixture;
		fp->fixture.set_up();
	}

	private void tear_down(void * data) {
		FixturePointer *fp = data;
		fp->fixture.tear_down();
		fp->fixture = null; // Should delete the object.
	}

	private void run(void * data) {
		FixturePointer *fp = data;
		var in_args = new Argument[1];
		in_args[0].pointer = fp->fixture;
		try {
			fn_info.invoke(in_args, new Argument[0], null);
		} catch(InvokeError e) {
			stdout.printf("Invoke error: %s\n", e.message);
			assert_not_reached();
		}
	}
	// End Interface

	public TestInfo(ObjectInfo fx_info, FunctionInfo fn_info,
			owned Parameter[] parameters) {
		this.fx_info = fx_info;
		this.fn_info = fn_info;
		this.fx_type = fx_info.get_g_type();
		this.parameters = parameters;
	}

	public TestCase make_case(string name) throws RunnerError {
		if(fx_type == typeof(void))
			throw new RunnerError.TYPE_NOT_LOADED(
					"GType initialization function didn't load for %s.%s",
					fx_info.get_namespace(),
					fx_info.get_name());
		return new TestCase(name,
				sizeof(FixturePointer), this.set_up,
				this.run, this.tear_down);
	}
}
