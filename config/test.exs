import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :xdeploy, XdeployWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "lhAw3KLa7JfdRyxe0Gg0QMrV0C+4N/vl+2L3ags2z18A4iYErlhjfOPr1oPNw+XD",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
