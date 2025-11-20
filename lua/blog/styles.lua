local text_mutted = "color-mix(in srgb, var(--text-color) 70%, var(--background-color))"

return {
  [":root"] = {
    ["--background-color"] = "#131418",
    ["--heading-color"] = "#eaeaea",
    ["--text-color"] = "#babdc4",
    ["--text-mutted"] = text_mutted,
    ["--link-color"] = "#82aee3",
    ["--code-background-color"] = "#2d2d2d",
  },

  ["[data-theme='light']"] = {
    ["--background-color"] = "#fff",
    ["--heading-color"] = "#0d122b",
    ["--text-color"] = "#434648",
    ["--text-mutted"] = text_mutted,
    ["--link-color"] = "#003fff",
    ["--code-background-color"] = "#d8dbe2",
  },

  ["#theme-toggle"] = {
    all = "unset",
    padding = "4px 8px",
    border_radius = "10px",
    cursor = "pointer",
    ["&:hover"] = { background = "rgba(0,0,0,0.09)" },
  },

  -- HEADER

  header = { padding_bottom = "0.3rem" },

  [".visual-hidden:not(:focus)"] = {
    position = "absolute",
    bottom = "100%",
  },

  ["nav a"] = { margin_right = "0.9rem" },
  ["nav p"] = { margin_bottom = "0px" },

  -- GENERAL

  body = {
    max_width = "66ch",
    margin = "0 auto",
    padding = "0.6rem 1.7rem 3.1rem",
    font_family = 'system-ui, -apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif',
    font_size = "1rem",
    background_color = "var(--background-color)",
    color = "var(--text-color)",
    line_height = "1.5",
    letter_spacing = "0.005em",
    overflow_wrap = "anywhere",
  },

  a = {
    color = "var(--link-color)",
    cursor = "pointer",
    text_decoration = "none",

    ["&:hover"] = { text_decoration = "underline" },
  },

  main = {
    padding_top = "1.3rem",
    line_height = "1.6",

    a = {
      color = "var(--text-color)",
      text_decoration = "underline",

      ["&:hover"] = { color = "var(--link-color)" },
    },
  },

  -- POSTS LIST

  [".recent-posts"] = {
    padding_top = "0.5rem",
    ["& span"] = {},
  },

  ["ul.blog-posts"] = {
    list_style_type = "none",
    padding = "unset",
    ["& li"] = { display = "flex" },
    ["& li span"] = { flex = "0 0 130px" },
    ["& a"] = {
      text_decoration = "none",
      color = "var(--link-color)",

      ["&:hover"] = { text_decoration = "underline" },
      ["&:visited"] = { color = "var(--link-color)" },
    },
  },

  time = {
    color = "var(--text-mutted)",
    font_family = "monospace",
    font_style = "normal",
    font_size = "0.95rem",
  },

  -- POST
  [".blog-title"] = {
    p = { margin_top = "0px" },
    h1 = {
      margin_top = "0px",
      margin_bottom = "0px",
    },
  },

  ["h1, h2, h3, h4, h5, h6"] = {
    font_family = "var(--font-main)",
    color = "var(--heading-color)",
  },

  i = { font_style = "italic" },
  img = {
    max_width = "100%",
    display = "block",
    justify_self = "center",
  },

  table = { width = "100%" },
  ["strong, b"] = { color = "var(--heading-color)" },

  button = {
    margin = "0",
    cursor = "pointer",
  },

  hr = {
    border = "0",
    border_top = "1px dashed",
  },

  pre = {
    padding = "10px",
    border_radius = "6px",
    code = {
      padding = "0",
      border_radius = "0",
    },
  },

  code = {
    font_family = "monospace",
    background_color = "var(--code-background-color)",
    white_space = "pre-wrap",
    padding = "0 0.3em",
  },
}
