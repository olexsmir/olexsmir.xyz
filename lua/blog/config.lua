local config = {}

config.name = "olexsmir"
config.title = "olexsmir's blog"
config.email = "olexsmir@gmail.com"
config.cname = "olexsmir.xyz"
config.url = "https://" .. config.cname
config.feed = {
  url = config.url .. "/feed.xml",
  subtitle = "olexsmir's blog feed, also hi rss reader!",
}

config.build = {
  chroma_theme = "tokyonight-night",
  output = "build",
  static = "static",
  posts = "posts",
}

return config
