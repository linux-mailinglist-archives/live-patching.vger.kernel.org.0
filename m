Return-Path: <live-patching+bounces-1592-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4834BAEAB86
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E664A3AC6F7
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F702EF653;
	Thu, 26 Jun 2025 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMpor2XT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C4A23B63F;
	Thu, 26 Jun 2025 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982215; cv=none; b=KazlzfPgZUCS3emRNve6mSvNMA7jo2lrUpPTcbELMikF6RXPJ4uI+1KKB15/DFV2FPPrKxoTOHfDW2msSj6xBmGBQhwFMispTjBFHpMvycGPyZIeCcZvjjbaE2Ri+vFnc+89Gw3Gwv8MxILvIb7BIApW2GTpLDwloDY+1YOxvZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982215; c=relaxed/simple;
	bh=ym0NbDSX4B/iZLtsv9TDPNK9Jc/XifRA2u0nHW7RXVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hi6tzngoI3bHQGYlJ7h6+4+NfeLZvtlXSvdFEgEkeRuJ47tN2f196wJXkzp24ckZetjdnz0lSJ4xMWoxcOSFf/+LPSLksLhLAfvR5WORAyMe8udJi5Ja2R8ACvrqtRoiz0f0rHuXRwMz/AHxaBKbMohmf/Bwin3L4M3jLaEJmb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMpor2XT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FA3C4CEF4;
	Thu, 26 Jun 2025 23:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982215;
	bh=ym0NbDSX4B/iZLtsv9TDPNK9Jc/XifRA2u0nHW7RXVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMpor2XTgilsifBNbVKxsV07JD8LI/fjizLLk1aGLd8+lwsbDMDrjKYGqvRD2PdKV
	 Qq3Uau4zPjRU6to+BDeQDFeenMgiBv8j2U4E6T/Iw7ZKql74TuuONI9iI+5yn5zODP
	 DRrXAV9Du9Qv0bBFbCCkh6ErOPcjGvoOnjsaFWrDjXvrW2+wYko9jorBaq9jOAGFWQ
	 ql84WQLitY6s/RDx2KwjBAqgAeoNXvCjFCK9Fua5UZqO6xNE7t2dhXT9ZUox5mJlqK
	 716LlC7l28+OLGjJdzQH+QO9UjVEYbGgKtgWDshx7Fddm1Q8VD5yOeh3ccWEJ0LsII
	 Hl30hCv5HRaYA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 62/64] livepatch/klp-build: Add --debug option to show cloning decisions
Date: Thu, 26 Jun 2025 16:55:49 -0700
Message-ID: <3cd69269e164baa39e3eb3dfb5294ddaf22858cc.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a --debug option which gets passed to "objtool klp diff" to enable
debug output related to cloning decisions.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index b54776fe3161..fe9af53a8476 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -20,7 +20,7 @@ set -o nounset
 # This helps keep execution in pipes so pipefail+errexit can catch errors.
 shopt -s lastpipe
 
-unset SKIP_CLEANUP XTRACE
+unset DEBUG_CLONE SKIP_CLEANUP XTRACE
 
 REPLACE=1
 SHORT_CIRCUIT=0
@@ -120,6 +120,7 @@ Options:
    -v, --verbose		Pass V=1 to kernel/module builds
 
 Advanced Options:
+   -d, --debug			Show symbol/reloc cloning decisions
    -S, --short-circuit=STEP	Start at build step (requires prior --keep-tmp)
 				   1|orig	Build original kernel (default)
 				   2|patched	Build patched kernel
@@ -140,8 +141,8 @@ process_args() {
 	local long
 	local args
 
-	short="hj:o:vS:T"
-	long="help,jobs:,output:,no-replace,verbose,short-circuit:,keep-tmp"
+	short="hj:o:vdS:T"
+	long="help,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
 
 	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
 		echo; usage; exit
@@ -174,6 +175,11 @@ process_args() {
 				VERBOSE="V=1"
 				shift
 				;;
+			-d | --debug)
+				DEBUG_CLONE=1
+				keep_tmp=1
+				shift
+				;;
 			-S | --short-circuit)
 				[[ ! -d "$TMP_DIR" ]] && die "--short-circuit requires preserved klp-tmp dir"
 				keep_tmp=1
@@ -600,6 +606,7 @@ copy_patched_objects() {
 diff_objects() {
 	local log="$KLP_DIFF_LOG"
 	local files=()
+	local opts=()
 
 	rm -rf "$DIFF_DIR"
 	mkdir -p "$DIFF_DIR"
@@ -607,6 +614,8 @@ diff_objects() {
 	find "$PATCHED_DIR" -type f -name "*.o" | mapfile -t files
 	[[ ${#files[@]} -eq 0 ]] && die "no changes detected"
 
+	[[ -v DEBUG_CLONE ]] && opts=("--debug")
+
 	# Diff all changed objects
 	for file in "${files[@]}"; do
 		local rel_file="${file#"$PATCHED_DIR"/}"
@@ -620,6 +629,7 @@ diff_objects() {
 		cmd=("$SRC/tools/objtool/objtool")
 		cmd+=("klp")
 		cmd+=("diff")
+		(( ${#opts[@]} > 0 )) && cmd+=("${opts[@]}")
 		cmd+=("$orig_file")
 		cmd+=("$patched_file")
 		cmd+=("$out_file")
-- 
2.49.0


