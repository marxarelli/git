#!/bin/sh

test_description='stateless upload-pack gently handles EOF just after want/shallow/depth/flush'

. ./test-lib.sh

D=$(pwd)

test_expect_success 'upload-pack outputs flush and exits ok' '
	test_commit initial &&
	head=$(git rev-parse HEAD) &&
	hexsz=$(test_oid hexsz) &&

	printf "%04xwant %s\n%04xshallow %s\n000ddeepen 1\n0000" \
		$(($hexsz + 10)) $head $(($hexsz + 13)) $head >request &&

	git upload-pack --stateless-rpc "$(pwd)" <request >actual &&

	printf "0000" >expect &&

	test_cmp expect actual
'

test_done
