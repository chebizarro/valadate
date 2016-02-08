namespace Example {

    [GtkTemplate (ui = "/org/gtk/exampleapp/prefs.ui")]
    public class ApplicationPreferences : Gtk.Dialog {

        private GLib.Settings settings;

        [GtkChild]
        private Gtk.FontButton font;

        [GtkChild]
        private Gtk.ComboBoxText transition;

        public ApplicationPreferences (ApplicationWindow window) {
            GLib.Object (transient_for: window,
                         use_header_bar: 1);

            settings = new GLib.Settings ("org.gtk.exampleapp");
            settings.bind ("font", font, "font",
                           GLib.SettingsBindFlags.DEFAULT);
            settings.bind ("transition", transition, "active-id",
                           GLib.SettingsBindFlags.DEFAULT);
        }
    }
}