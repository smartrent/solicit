import Config

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

if Mix.env() == :dev do
  config :git_hooks,
    auto_install: true,
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
      ],
      commit_msg: [
        tasks: [
          {:cmd, "mix git_ops.check_message", include_hook_args: true}
        ]
      ]
    ]

  config :git_ops,
    mix_project: Mix.Project.get!(),
    changelog_file: "CHANGELOG.md",
    repository_url: "https://github.com/smartrent/solicit",
    manage_mix_version?: true
end
