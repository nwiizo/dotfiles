# Local compatibility fixes for sponge 1.1.0 on fish 4.x.
# Fisher may rewrite the plugin files during updates, so keep the defensive
# definitions in conf.d and source this file again after `fisher update`.

function sponge_filter_failed \
  --argument-names command exit_code previously_in_history

  set --query previously_in_history[1]; or set previously_in_history false
  set --query sponge_allow_previously_successful[1]; or set sponge_allow_previously_successful true
  set --query exit_code[1]; or set exit_code 0
  set --query sponge_successful_exit_codes[1]; or set sponge_successful_exit_codes 0

  if test "$previously_in_history" = true; and test "$sponge_allow_previously_successful" = true
    return 1
  end

  if contains -- "$exit_code" $sponge_successful_exit_codes
    return 1
  end
end

function _sponge_on_postexec --on-event fish_postexec
  set --global _sponge_current_command_exit_code $status

  # Ignore empty commands. This can happen after plugin reloads during
  # `fisher update`, before fish_preexec has restored sponge's state.
  if test -n "$_sponge_current_command"
    # Remove command from the queue if it's been added previously
    if set --local index (contains --index -- "$_sponge_current_command" $_sponge_queue)
      set --erase _sponge_queue[$index]
    end

    set --local command ''
    # Run filters
    for filter in $sponge_filters
      if $filter \
          "$_sponge_current_command" \
          "$_sponge_current_command_exit_code" \
          "$_sponge_current_command_previously_in_history"
        set command $_sponge_current_command
        break
      end
    end
    set --prepend --global _sponge_queue $command
  end
end
