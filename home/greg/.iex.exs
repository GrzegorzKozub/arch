Application.put_env(:elixir, :ansi_enabled, true)

IEx.configure(
  colors: [
    syntax_colors: [
      number: :magenta,
      string: :green,
      atom: :yellow,
      boolean: :blue,
      nil: :cyan
    ],
    doc_headings: :light_white,
    doc_title: :light_white,
    doc_code: :light_white,
    doc_inline_code: :light_white,
    ls_directory: :white,
    ls_device: :white
  ],
  history_size: 1024,
  inspect: [
    pretty: true,
    limit: :infinity
  ]
)
