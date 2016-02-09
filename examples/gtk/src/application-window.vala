namespace Example {

    [GtkTemplate (ui = "/org/gtk/exampleapp/window.ui")]
    public class ApplicationWindow : Gtk.ApplicationWindow {

        [GtkChild]
        private Gtk.Stack stack;
        [GtkChild]
        Gtk.MenuButton gears;
        [GtkChild]
        private Gtk.ToggleButton search;
        [GtkChild]
        private Gtk.SearchBar searchbar;
        [GtkChild]
        private Gtk.SearchEntry searchentry;
        [GtkChild]
        private Gtk.Revealer sidebar;
        [GtkChild]
        private Gtk.ListBox words;
        [GtkChild]
        private Gtk.Label lines_label;
        [GtkChild]
        private Gtk.Label lines;

        private GLib.Settings settings;

        public ApplicationWindow (Gtk.Application application) {
            GLib.Object (application: application);

            settings = new GLib.Settings ("org.gtk.exampleapp");

            settings.bind ("transition", stack, "transition-type",
                           GLib.SettingsBindFlags.DEFAULT);

            search.bind_property ("active", searchbar, "search-mode-enabled",
                                  GLib.BindingFlags.BIDIRECTIONAL);

            settings.bind ("show-words", sidebar, "reveal-child",
                           GLib.SettingsBindFlags.DEFAULT);

            sidebar.notify["reveal-child"].connect (update_words);

            var builder = new Gtk.Builder.from_resource ("/org/gtk/exampleapp/gears-menu.ui");
            var menu = builder.get_object ("menu") as GLib.MenuModel;
            gears.set_menu_model (menu);

            var action = settings.create_action ("show-words");
            add_action (action);

            action = new GLib.PropertyAction ("show-lines", lines, "visible");
            add_action (action);

            lines.bind_property ("visible", lines_label, "visible",
                                 GLib.BindingFlags.DEFAULT);

            settings.changed["font"].connect (update_font);
        }

        public void open (GLib.File file) {
            var basename = file.get_basename ();
            var font_name = settings.get_string ("font");
            var font = Pango.FontDescription.from_string (font_name);

            var scrolled = new Gtk.ScrolledWindow (null, null);
            scrolled.show ();
            scrolled.hexpand = true;
            scrolled.vexpand = true;

            var view = new Gtk.TextView ();
            view.editable = false;
            view.cursor_visible = false;
            view.override_font (font);
            view.show ();

            scrolled.add (view);
            stack.add_titled (scrolled, basename, basename);

            try {
                uint8[] contents;
                if (file.load_contents (null, out contents, null)) {
                    var buffer = view.get_buffer ();
                    buffer.set_text ((string)contents);
                }
            } catch (GLib.Error e) {
                GLib.warning ("There was an error loading '%s': %s",
                              basename, e.message);
            }

            search.sensitive = true;
            update_words ();
            update_lines ();
        }

        [GtkCallback]
        public void visible_child_changed () {
            if (stack.in_destruction ())
                return;

            searchbar.set_search_mode (false);
            update_words ();
            update_lines ();
        }

        [GtkCallback]
        public void search_text_changed () {
            var text = searchentry.get_text ();

            if (text == "")
                return;

            var tab = stack.get_visible_child () as Gtk.Bin;
            var view = tab.get_child () as Gtk.TextView;
            var buffer = view.get_buffer ();

            /* Very simple-minded search implementation */
            Gtk.TextIter start, match_start, match_end;
            buffer.get_start_iter (out start);
            if (start.forward_search (text, Gtk.TextSearchFlags.CASE_INSENSITIVE,
                                      out match_start, out match_end, null)) {
                buffer.select_range (match_start, match_end);
                view.scroll_to_iter (match_start, 0.0, false, 0.0, 0.0);
            }
        }

        private void find_word (Gtk.Button button) {
            var word = button.get_label ();
            searchentry.set_text (word);
        }

        private void update_words () {
            var tab = stack.get_visible_child () as Gtk.Bin;
            if (tab == null)
                return;

            var view = tab.get_child () as Gtk.TextView;
            var buffer = view.get_buffer ();

            var strings = new Gee.HashMap<string, string> ();

            Gtk.TextIter start, end;
            buffer.get_start_iter (out start);
            while (!start.is_end ()) {
                bool done = false;
                while (!start.starts_word ()) {
                    if (!start.forward_char ()) {
                        done = true;
                        break;
                    }
                }
                if (done)
                    break;
                end = start;
                if (!end.forward_word_end ())
                    break;
                var word = buffer.get_text (start, end, false);
                var key = word.down ();
                strings.set (key, key);
                start = end;
            }

            var children = words.get_children ();
            foreach (var child in children)
                words.remove (child);

            foreach (var key in strings.keys) {
                var row = new Gtk.Button.with_label (key);
                row.clicked.connect ((b) => find_word (b));
                row.show ();
                words.add (row);
            }
        }

        public void update_lines () {
            var tab = stack.get_visible_child () as Gtk.Bin;
            if (tab == null)
                return;

            var view = tab.get_child () as Gtk.TextView;
            var buffer = view.get_buffer ();

            int count = 0;

            Gtk.TextIter iter;
            buffer.get_start_iter (out iter);
            while (!iter.is_end ()) {
                count++;
                if (!iter.forward_line ())
                    break;
            }

            string lns = "%d".printf (count);
            lines.set_text (lns);
        }

        private void update_font () {
            var font_name = settings.get_string ("font");
            foreach (var t in stack.get_children ()) {
                var tab = t as Gtk.Bin;
                var view = tab.get_child () as Gtk.TextView;
                var font = Pango.FontDescription.from_string (font_name);
                view.override_font (font);
            }
        }
        
    }
}
