#!/usr/bin/env ruby
# frozen_string_literal: true

# Gemfile内の重複gem（同じgem名で複数のエントリ）を検出し、
# 最後のエントリのみを残して重複を削除するスクリプト

GEMFILE_PATH = 'Gemfile'

unless File.exist?(GEMFILE_PATH)
  puts "❌ Gemfile が見つかりません"
  exit 1
end

# Gemfile を読み込む
lines = File.readlines(GEMFILE_PATH)

# gem名とその行番号を記録
gem_entries = {}
lines.each_with_index do |line, index|
  # gem 'name' または gem "name" の形式を検出
  if line =~ /^\s*gem\s+['"]([^'"]+)['"]/
    gem_name = Regexp.last_match(1)
    gem_entries[gem_name] ||= []
    gem_entries[gem_name] << index
  end
end

# 重複しているgemを検出
duplicates = gem_entries.select { |_name, indices| indices.length > 1 }

if duplicates.empty?
  puts "✅ 重複するgemはありません"
  exit 0
end

puts "🔍 重複するgemを検出しました:"
duplicates.each do |name, indices|
  puts "  - #{name} (#{indices.length}箇所)"
end

# 削除する行のインデックスを収集（最後のエントリ以外）
lines_to_remove = []
duplicates.each do |name, indices|
  # 最後のエントリを残し、それ以前を削除対象にする
  lines_to_remove.concat(indices[0..-2])
  puts "  ✓ #{name}: #{indices.length - 1}件の重複を削除します（最後のエントリを保持）"
end

# 削除対象の行を除外して新しい内容を作成
new_lines = lines.each_with_index.reject { |_line, index| lines_to_remove.include?(index) }.map(&:first)

# Gemfile に書き戻す
File.write(GEMFILE_PATH, new_lines.join)

puts "✅ Gemfileを更新しました（#{lines_to_remove.length}行削除）"
puts "💡 次のコマンドを実行してください: bundle install"
