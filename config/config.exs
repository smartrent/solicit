use Mix.Config

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

if Mix.env() != :prod do
  config :git_hooks,
    auto_install: true,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix format"},
          {:cmd, "mix lint"},
          {:cmd, "mix compile --warnings-as-errors"}
        ]
      ],
      pre_push: [
        verbose: false,
        tasks: [
          {:cmd, "mix format"},
          {:cmd, "mix lint"},
          {:cmd, "mix test"},
          {:cmd, "mix compile --warnings-as-errors"},
          {:cmd, "mix dialyzer"},
          {:cmd, "echo 'success!'"}
        ]
      ]
    ]
end
