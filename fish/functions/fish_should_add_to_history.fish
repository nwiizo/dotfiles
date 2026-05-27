function fish_should_add_to_history
    set -l cmd (string trim -- $argv)

    test -z "$cmd"; and return 1
    string match -qr '^\s' -- $argv; and return 1
    string match -qr '^(export|set).*(TOKEN|SECRET|PASSWORD|KEY|PASS)' -- $cmd; and return 1
    string match -qr '(password|secret|token|api.?key)=' -- $cmd; and return 1
    string match -qr '^(curl|wget|http).+(-H|--header).*(auth|bearer|token)' -i -- $cmd; and return 1
    string match -qr '(AWS_SECRET|GITHUB_TOKEN|OPENAI_API_KEY|ANTHROPIC_API_KEY)' -- $cmd; and return 1
    string match -qr '^vault ' -- $cmd; and return 1
    string match -qr '^(claude|aider|gemini|codex|llm|goose|opencode)\s*$' -- $cmd; and return 1
    test (string length -- $cmd) -le 2; and return 1

    return 0
end
