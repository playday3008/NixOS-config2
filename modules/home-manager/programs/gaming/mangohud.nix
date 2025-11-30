# modules/home-manager/programs/gaming/mangohud.nix
# MangoHud performance overlay configuration
{
  ...
}:
{
  programs.mangohud = {
    enable = true;

    settings = {
      # Performance metrics
      fps = true;
      fps_color_change = true;
      fps_metrics = "avg,0.01";
      frametime = true;
      frame_timing = true;
      dynamic_frame_timing = true;
      histogram = true;

      # GPU stats
      gpu_stats = true;
      gpu_temp = true;
      gpu_junction_temp = true;
      gpu_core_clock = true;
      gpu_mem_temp = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_load_change = true;
      gpu_efficiency = true;
      flip_efficiency = true;

      # CPU stats
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;
      cpu_mhz = true;
      cpu_load_change = true;

      # Memory
      vram = true;
      ram = true;
      swap = true;

      # IO
      io_read = true;
      io_write = true;

      # Battery
      battery = true;
      battery_watt = true;
      battery_time = true;
      device_battery = "gamepad,mouse";

      # System info
      time = true;
      engine_version = true;
      gpu_name = true;
      present_mode = true;
      resolution = true;
      network = true;

      # Throttling
      throttling_status = true;
      throttling_status_graph = true;

      # GameMode/vkBasalt
      gamemode = true;
      vkbasalt = true;

      # Appearance
      round_corners = 10;
      text_outline = true;
      font_glyph_ranges = "korean,chinese,chinese_simplified,japanese,cyrillic,thai,vietnamese,latin_ext_a,latin_ext_b";

      # Default hidden (toggle with keybind)
      no_display = true;

      # Keybinds
      toggle_hud = "Shift_R+F12";
      toggle_hud_position = "Shift_R+F11";
      toggle_logging = "Shift_R+F2";
      reload_cfg = "Shift_R+F4";
    };
  };
}
