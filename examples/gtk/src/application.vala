namespace Example {

    public class Application : Gtk.Application {

        private ApplicationWindow window;

        public Application () {
            application_id = "org.gtk.exampleapp";
            flags |= GLib.ApplicationFlags.HANDLES_OPEN;
        }

        public override void activate () {
            window = new ApplicationWindow (this);
            window.present ();
        }

        public override void open (GLib.File[] files,
                                   string      hint) {
            if (window == null)
                window = new ApplicationWindow (this);

            foreach (var file in files)
                window.open (file);

            window.present ();
        }

        private void preferences () {
            var prefs = new ApplicationPreferences (window);
            prefs.present ();
        }

        public override void startup () {
            base.startup ();

            var action = new GLib.SimpleAction ("preferences", null);
            action.activate.connect (preferences);
            add_action (action);

            action = new GLib.SimpleAction ("quit", null);
            action.activate.connect (quit);
            add_action (action);
            add_accelerator ("<Ctrl>Q", "app.quit", null);

            var builder = new Gtk.Builder.from_resource ("/org/gtk/exampleapp/app-menu.ui");
            var app_menu = builder.get_object ("appmenu") as GLib.MenuModel;

            set_app_menu (app_menu);
        }
    }
}
