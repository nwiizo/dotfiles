#!/usr/bin/env fish
# Fish設定を段階的にテストするスクリプト

echo "🧪 Fish設定の段階的テスト"
echo "========================="
echo ""

set -l config_dir ~/.config/fish
set -l test_config /tmp/fish_test_config.fish

# ステップ1: バックアップ
echo "📦 ステップ1: 現在の設定をバックアップ"
set -l backup_file $config_dir/config.fish.backup.(date +%Y%m%d_%H%M%S)
if test -f $config_dir/config.fish
    cp $config_dir/config.fish $backup_file
    echo "✓ バックアップ: $backup_file"
else
    echo "⚠ config.fishが存在しません"
end
echo ""

# ステップ2: 問題ファイルのチェック
echo "🔍 ステップ2: 問題となるファイルをチェック"
set -l found_issues 0

if test -f $config_dir/functions/fish_prompt.fish
    echo "⚠️  問題: functions/fish_prompt.fish が存在します"
    echo "   → 削除しますか? (y/n)"
    read -l response
    if test "$response" = "y"
        rm $config_dir/functions/fish_prompt.fish
        echo "   ✓ 削除しました"
    end
    set found_issues 1
end

if test -f $config_dir/functions/fish_right_prompt.fish
    echo "⚠️  問題: functions/fish_right_prompt.fish が存在します"
    echo "   → 削除しますか? (y/n)"
    read -l response
    if test "$response" = "y"
        rm $config_dir/functions/fish_right_prompt.fish
        echo "   ✓ 削除しました"
    end
    set found_issues 1
end

if test $found_issues -eq 0
    echo "✓ 問題ファイルは見つかりませんでした"
end
echo ""

# ステップ3: conf.d/ のチェック
echo "🔍 ステップ3: conf.d/ の内容をチェック"
if test -d $config_dir/conf.d
    set -l conf_files (count $config_dir/conf.d/*.fish 2>/dev/null)
    if test $conf_files -gt 0
        echo "以下のファイルが見つかりました："
        for file in $config_dir/conf.d/*.fish
            echo "  - "(basename $file)
        end
        echo ""
        echo "これらのファイルを確認しますか? (y/n)"
        read -l response
        if test "$response" = "y"
            for file in $config_dir/conf.d/*.fish
                echo ""
                echo "=== "(basename $file)" ==="
                cat $file
                echo ""
            end
        end
    else
        echo "✓ conf.d/ にファイルはありません"
    end
else
    echo "✓ conf.d/ ディレクトリは存在しません"
end
echo ""

# ステップ4: local.fish のチェック
echo "🔍 ステップ4: local.fish の内容をチェック"
if test -f $config_dir/local.fish
    echo "⚠️  local.fish が存在します"
    echo ""
    echo "=== local.fish の内容 ==="
    cat $config_dir/local.fish
    echo ""

    # fish_promptを定義しているかチェック
    if grep -q "fish_prompt" $config_dir/local.fish
        echo "⚠️  警告: local.fish に 'fish_prompt' が含まれています"
        echo "   これが問題の原因の可能性があります"
    end
else
    echo "✓ local.fish は存在しません"
end
echo ""

# ステップ5: 推奨事項
echo "📋 ステップ5: 推奨事項"
echo "===================="
echo ""
echo "問題を解決するには："
echo ""
echo "1. 以下のファイルを削除："
echo "   rm ~/.config/fish/functions/fish_prompt.fish"
echo "   rm ~/.config/fish/functions/fish_right_prompt.fish"
echo ""
echo "2. local.fish または conf.d/ 内のファイルで"
echo "   'fish_prompt' を定義している場合は削除"
echo ""
echo "3. 新しい config_fixed.fish を使用："
echo "   cp config_fixed.fish ~/.config/fish/config.fish"
echo ""
echo "4. Fish を再起動："
echo "   exec fish"
echo ""

# ステップ6: 自動修復オプション
echo "🔧 自動修復を実行しますか? (y/n)"
read -l auto_fix

if test "$auto_fix" = "y"
    echo ""
    echo "🔧 自動修復を開始..."

    # 問題のあるファイルを削除
    rm -f $config_dir/functions/fish_prompt.fish
    rm -f $config_dir/functions/fish_right_prompt.fish

    # 関数をクリア
    functions -e fish_prompt fish_right_prompt 2>/dev/null

    echo "✓ 修復完了"
    echo ""
    echo "次のステップ:"
    echo "1. 新しい config_fixed.fish をコピー"
    echo "2. exec fish を実行"
end
