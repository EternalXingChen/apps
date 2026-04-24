#!/bin/bash

# 批量修复 Dart 文件语法错误

echo "修复语法错误..."

# 修复常见的语法错误
find lib -name "*.dart" -exec sed -i \
    -e 's/State State</State</g' \
    -e 's/Consumer Consumer</Consumer</g' \
    -e 's/context\.read\.read</context.read</g' \
    -e 's/List List</List</g' \
    -e 's/SetSet</Set</g' \
    -e 's/SegmentedButtonButton</SegmentedButton</g' \
    -e 's/Consumer22</Consumer</g' \
    -e 's/LocalizationsDelegateDelegate</LocalizationsDelegate</g' \
    -e 's/TableCalendarCalendar</TableCalendar</g' \
    -e 's/GlobalKeyKey</GlobalKey</g' \
    {} \;

echo "语法错误修复完成！"
