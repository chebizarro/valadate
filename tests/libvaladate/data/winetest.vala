public void main(string[] args) {

	SubprocessLauncher launcher = new SubprocessLauncher(
		GLib.SubprocessFlags.STDIN_PIPE |
		GLib.SubprocessFlags.STDOUT_PIPE |
		GLib.SubprocessFlags.STDERR_PIPE);
	foreach(var env in Environment.list_variables())
		launcher.setenv(env, Environment.get_variable(env),true);
	launcher.setenv("G_MESSAGES_DEBUG","all",true);
	launcher.setenv("G_DEBUG","fatal-criticals fatal-warnings gc-friendly",true);
	launcher.setenv("G_SLICE","always-malloc debug-blocks",true);

	var process = launcher.spawnv({ "/work/tests/libvaladate/data/helloworld.exe".escape(null) });
	var stdo = new DataInputStream (process.get_stdout_pipe());
	var stde = new DataInputStream (process.get_stderr_pipe());

	process.wait_check();

	var rline = stdo.read_line(null);

	while(rline != null) {
		stdout.printf("%s\n", rline);
		rline = stdo.read_line(null);
	}

}
