Return-Path: <live-patching+bounces-1419-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 365B4AB1E46
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:30:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 929DD1C600E6
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C7C429ACED;
	Fri,  9 May 2025 20:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ugik8eIG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645F429ACE7;
	Fri,  9 May 2025 20:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821907; cv=none; b=Q/URXEzWLmDZ9xyrfjUb0leXwm9RLMU7vuVUJCdedJ8IVLdK8j+WZjPW0QsbT1QRZfc7ijfKmpEp7cmui4cwBMYDRU7TYZoqlctLuQaSxABwVjXzcSv3Y3G25ZGep2I8hrmDbbhArvI0NAH3BAFmI+TDu4f+NsSCt+5rTe2OVkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821907; c=relaxed/simple;
	bh=ljV5bbNA0/17MC5i4FU8MNYIoVsgg5cRUxmLhI5HQRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7ZtOqS3SR9dTPZuZDjntn0io+CwGgbjsK0YqbGO7lYwf2tajHOFXbVkWvf4nHEA6SLlHVZmus0T8D3BC9Skn+XSKOD09YVTGI7M52lV5CfBedK51doX1tIV0vqJW60FqPdLxN7CwCH0FlI66fu6IZ2/+HhMD+YAfp8fUEYjPfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ugik8eIG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA82BC4CEF0;
	Fri,  9 May 2025 20:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821907;
	bh=ljV5bbNA0/17MC5i4FU8MNYIoVsgg5cRUxmLhI5HQRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ugik8eIG9SiuFoULrpiPA6HiSQIU5S+zZ39CrDqKo8R04BwEB789vJEGi8guzlH+Z
	 Z+s5bmgBAhxpj395wZYS0aVdMZr2+w4kwOeROXt9tnrWVIYn/qmxFnjJ7dL9ZTtAUm
	 4/79F7MQLOTREj8dikoY/Og8Tg+8XyKaYje9mMMxJ6f6ycX95ZQZGU4wnMz0sRZk32
	 LwicUAjWTBcn1pyUQHLenmh5FUSY1UDYVO7RX6pnxTua/i3DW64XJM4tOzrt0Z4mEG
	 7dhrFMVlGaKkE2Ok2+op/vYQb6J7lHjnKK8bErW85pXOOMAIntCMY6d2/lVLIOvkUj
	 3k/SfDEkkhNGA==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 60/62] livepatch/klp-build: Add --debug option to show cloning decisions
Date: Fri,  9 May 2025 13:17:24 -0700
Message-ID: <8dbc3602712d9f0481023895c37f9ed7ee44a735.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
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
index ebbece6f6b8d..08ef903d4090 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -21,7 +21,7 @@ set -o nounset
 # This helps keep execution in pipes so pipefail+errexit can catch errors.
 shopt -s lastpipe
 
-unset SKIP_CLEANUP XTRACE
+unset DEBUG_CLONE SKIP_CLEANUP XTRACE
 REPLACE=1
 SHORT_CIRCUIT=0
 shopt -o xtrace | grep -q 'on' && XTRACE=1
@@ -120,6 +120,7 @@ Options:
    -v, --verbose		Pass V=1 to kernel/module builds
 
 Advanced Options:
+   -D, --debug			Show symbol/reloc cloning decisions
    -S, --short-circuit=STEP	Start at build step (requires prior --keep-tmp)
 				   1|orig	Build original kernel (default)
 				   2|patched	Build patched kernel
@@ -140,8 +141,8 @@ process_args() {
 	local long
 	local args
 
-	short="ho:vS:T"
-	long="help,output:,no-replace,verbose,short-circuit:,keep-tmp"
+	short="ho:vDS:T"
+	long="help,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
 
 	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
 		echo; usage; exit
@@ -170,6 +171,11 @@ process_args() {
 				VERBOSE="V=1"
 				shift
 				;;
+			-D | --debug)
+				DEBUG_CLONE=1
+				keep_tmp=1
+				shift
+				;;
 			-S | --short-circuit)
 				[[ ! -d "$TMP_DIR" ]] && die "--short-circuit requires preserved klp-tmp dir"
 				keep_tmp=1
@@ -559,6 +565,7 @@ copy_patched_objects() {
 diff_objects() {
 	local log="$KLP_DIFF_LOG"
 	local files=()
+	local opts=()
 
 	rm -rf "$DIFF_DIR"
 	mkdir -p "$DIFF_DIR"
@@ -566,6 +573,8 @@ diff_objects() {
 	find "$PATCHED_DIR" -type f -name "*.o" | mapfile -t files
 	[[ ${#files[@]} -eq 0 ]] && die "no changes detected"
 
+	[[ -v DEBUG_CLONE ]] && opts=("--debug")
+
 	# Diff all changed objects
 	for file in "${files[@]}"; do
 		local rel_file="${file#"$PATCHED_DIR"/}"
@@ -579,6 +588,7 @@ diff_objects() {
 		cmd=("$SRC/tools/objtool/objtool")
 		cmd+=("klp")
 		cmd+=("diff")
+		(( ${#opts[@]} > 0 )) && cmd+=("${opts[@]}")
 		cmd+=("$orig_file")
 		cmd+=("$patched_file")
 		cmd+=("$out_file")
-- 
2.49.0


