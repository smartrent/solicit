import Config

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

if Mix.env() == :dev do
  config :git_hooks,
    auto_install: false,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix compile --warnings-as-errors"},
          {:mix_task, :format, ["--check-formatted"]},
          {:mix_task, :lint}
        ]
      ],
      pre_push: [
        verbose: false,
        tasks: [
          {:cmd, "mix compile --warnings-as-errors"},
          {:mix_task, :format, ["--check-formatted"]},
          {:mix_task, :lint},
          {:mix_task, :test},
          {:mix_task, :dialyzer}
        ]
      ]
    ]
end
