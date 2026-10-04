# rlimgui

- `rlimgui-cmdlists-size.patch`: rlImGui tag `Raylib_6_0` iterates `draw_data->CmdListsCount`.
  Dear ImGui 1.92.9 marked it obsolete and no longer fills it (it stays 0), so the code compiled,
  linked and drew nothing. Upstream `main` already uses `CmdLists.Size`; the patch is that one line.
- Symptom without the patch: window opens, only the clear colour is visible, no ImGui widgets.
