// Copyright (C) 2022 Rob Caelers <rob.caelers@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#ifndef AUTO_UPDATE_DIALOG_HH
#define AUTO_UPDATE_DIALOG_HH

#include <string>

#include <gtkmm.h>

#include "unfold/Unfold.hh"

#if defined(PLATFORM_OS_WINDOWS)
#  include "Edge.hh"
#endif

class AutoUpdateDialog : public Gtk::Dialog
{
public:
  explicit AutoUpdateDialog(std::shared_ptr<unfold::UpdateInfo> info);
  ~AutoUpdateDialog() override = default;

private:
  void on_auto_toggled();

private:
  Gtk::TextView *text_view{nullptr};
  Gtk::ScrolledWindow scrolled_window;
  Glib::RefPtr<Gtk::TextBuffer> text_buffer;
#if defined(PLATFORM_OS_WINDOWS)
  Edge *web{nullptr};
#endif
};

#endif // AUTO_UPDATE_DIALOG_HH
