#!/usr/bin/env python
#
# -*- encoding: utf-8 -*-
#
# generated by wxGlade HG on Wed Jul 18 14:54:33 2012
#

# This is an automatically generated file.
# Manual changes will be overwritten without warning!

import wx
from pvsmainframe import PVSMainFrame

class PVSEditorApp(wx.App):
    def OnInit(self):
        wx.InitAllImageHandlers()
        self.mainFrame = PVSMainFrame(None, wx.ID_ANY, "")
        self.SetTopWindow(self.mainFrame)
        self.mainFrame.Show()
        return 1

# end of class PVSEditorApp

if __name__ == "__main__":
    global editor
    editor = PVSEditorApp(0)
    editor.MainLoop()
