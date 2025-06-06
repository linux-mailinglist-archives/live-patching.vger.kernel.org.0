Return-Path: <live-patching+bounces-1496-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EFE9AD0874
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 21:03:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF999162F97
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 19:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7461E833D;
	Fri,  6 Jun 2025 19:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ipm8VRWa"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FBB2746A;
	Fri,  6 Jun 2025 19:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749236625; cv=none; b=Y6gkQNsapXPivurT+ppAjUfScaK/LfnE36bzPlU9oHI2bbHyjHv7tcsc0Xx/L4AQx0VvkX83egt4dZR+adNowFcFOkOAmGINPtNo1BiXaeoFuiU3v9/m9GT/xAY90NWEmW8Qa/SSFOPTXuWBneOeFz4+7eenjtktI5HmsornFCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749236625; c=relaxed/simple;
	bh=9tgAyBkUtSwD9VozH5RNCCXHKjCQ8YY2mL/VrG7xqko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X5WQ421M95dp8joa9BcEP9iHJZalNOSX+4tSCRFkc2bAaSlRTyiVCPiQmBZU7d/6dF0aeO1oC0KbV79fJwUlEdvDrb4P96Z6WASb26nvs61/0OriuJTXYt5+j0oZEpkFrW12PrKlvqPcrPRqdYTL46/XQ3iThrvlqs6gjmNnOg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ipm8VRWa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EF6C4CEEB;
	Fri,  6 Jun 2025 19:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749236625;
	bh=9tgAyBkUtSwD9VozH5RNCCXHKjCQ8YY2mL/VrG7xqko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ipm8VRWanv8Dxdj800NzO4oHpDbwo8z1MfcU7ESgGA3/yMTJBl6hk17WXR7zSxC0G
	 Aq2VYWwwnlO8NcJJSK48JQnsqakMuqRCindHES170F1AgfXnR6qs2Jxd2AXYsiAoxZ
	 PExWPTBqHTj3VjlOjLCdUCetB0/47MkuESDHyYLZmNzYjqqmsKLasiLJbxNcAWSXEM
	 6scNqSeD5YnrFPPpX1LgMyQtZ1f3gFLV1i+XcYAk4nA/hfeuAwrMvLS+tCCbdX1aBt
	 V6LfICXhSieRscJMr46/diDBsYlh4pXv8OAEktxcyxr+bh4P4S/v0cwpcvImM8Fuws
	 eevQnA3cns2hQ==
Date: Fri, 6 Jun 2025 12:03:42 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <27bkpjpv4lklcxafb4yifrbdjmfxn2sh67lckom2w7hpmgdyxr@zgty22rlp62q>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <f97a2e18-d672-41b1-ac26-4d1201528ed7@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f97a2e18-d672-41b1-ac26-4d1201528ed7@redhat.com>

On Fri, Jun 06, 2025 at 09:05:59AM -0400, Joe Lawrence wrote:
> Should the .cmd file copy come from the reference SRC and not original
> ORIG directory?
> 
>   cmd_file="$SRC/$(dirname "$rel_file")/.$(basename "$rel_file").cmd"
> 
> because I don't see any .cmd files in klp-tmp/orig/
> 
> FWIW, I only noticed this after backporting the series to
> centos-stream-10.  There, I got this build error:
> 
>   Building original kernel
>   Copying original object files
>   Fixing patches
>   Building patched kernel
>   Copying patched object files
>   Diffing objects
>   vmlinux.o: changed function: cmdline_proc_show
>   Building patch module: livepatch-test.ko
>   <...>/klp-tmp/kmod/.vmlinux.o.cmd: No such file or directory
>   make[2]: *** [scripts/Makefile.modpost:145:
> <...>/klp-tmp/kmod/Module.symvers] Error 1
>  make[1]: *** [<...>/Makefile:1936: modpost] Error 2
>  make: *** [Makefile:236: __sub-make] Error 2
> 
> The above edit worked for both your upstream branch and my downstream
> backport.

Hm, I broke this in one of my refactorings before posting.

Is this with CONFIG_MODVERSIONS?

If you get a chance to test, here's a fix (currently untested):

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 277fbe948730..cd6e118da275 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -517,16 +517,29 @@ find_objects() {
 
 # Copy all objects (.o archives) to $ORIG_DIR
 copy_orig_objects() {
+	local files=()
 
 	rm -rf "$ORIG_DIR"
 	mkdir -p "$ORIG_DIR"
 
-	(
-		cd "$OBJ"
-		find_objects						\
-			| sed 's/\.ko$/.o/'				\
-			| xargs cp --parents --target-directory="$ORIG_DIR"
-	)
+	find_objects | mapfile -t files
+
+	xtrace_save "copying orig objects"
+	for _file in "${files[@]}"; do
+		local rel_file="${_file/.ko/.o}"
+		local file="$OBJ/$rel_file"
+		local file_dir="$(dirname "$file")"
+		local orig_file="$ORIG_DIR/$rel_file"
+		local orig_dir="$(dirname "$orig_file")"
+		local cmd_file="$file_dir/.$(basename "$file").cmd"
+
+		[[ ! -f "$file" ]] && die "missing $(basename "$file") for $_file"
+
+		mkdir -p "$orig_dir"
+		cp -f "$file" "$orig_dir"
+		[[ -e "$cmd_file" ]] && cp -f "$cmd_file" "$orig_dir"
+	done
+	xtrace_restore
 
 	mv -f "$TMP_DIR/build.log" "$ORIG_DIR"
 	touch "$TIMESTAMP"

