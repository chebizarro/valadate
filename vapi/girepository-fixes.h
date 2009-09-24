/*
 * Valadate - Unit testing library for GObject-based libraries.
 * Copyright (C) 2009  Jan Hudec <bulb@ucw.cz>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <girepository.h>
#include <glib-object.h>

/* This define is here because I couldn't persuade vala to generate correct
 * name. */
#define G_IINVOKE_ERROR G_INVOKE_ERROR

/* Two wrappers because the g_base_info_ref/unref take a typed pointer, but
 * the subclass pointers obviously won't cast. */
#define g_base_info_ref(x) (g_base_info_ref((GIBaseInfo *)(x)), (x))
#define g_base_info_unref(x) g_base_info_unref((GIBaseInfo *)(x))
