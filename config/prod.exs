import Config

config :xdeploy, XdeployWeb.Endpoint,
  http: [port: 4000],
  transport_options: [socket_opts: [:inet6]],
  server: true

config :logger, level: :info
