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
          {:mix_task, :format},
          {:mix_task, :lint},
          {:mix_task, :compile, ["--warnings-as-errors"]}
        ]
      ],
      pre_push: [
        verbose: false,
        tasks: [
          {:mix_task, :format},
          {:mix_task, :lint},
          {:mix_task, :test},
          {:mix_task, :compile, ["--warnings-as-errors"]},
          {:mix_task, :dialyzer}
        ]
      ]
    ]
end
