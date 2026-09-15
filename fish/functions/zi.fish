function zi -d "Select a frequent directory with Television"
    set -l selected (__tv_zoxide -- $argv | string collect)
    test $pipestatus[1] -eq 0; and test -n "$selected"; or return 0
    __zoxide_cd -- "$selected"
end
