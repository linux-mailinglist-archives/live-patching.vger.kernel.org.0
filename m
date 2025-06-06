Return-Path: <live-patching+bounces-1500-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF33AD0990
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 23:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1AB47A8EE8
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 21:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC2021885A;
	Fri,  6 Jun 2025 21:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5k2leHc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340D61A76BC;
	Fri,  6 Jun 2025 21:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749245732; cv=none; b=sveaNQ2zdq4EeGdUhvcZeaYL/5zegNkLT+HMNWVNNQYE+ymKqMV22soALCQyOiosTIGHIcEXhYOz5pDLTsUtJJ43wpTS0rEFUvTmZmWXnEGFPe9JVo4La466EJpzfjwb0CxAuTHDARGFB+Ug/WsjQcmrRhDCt/uSfCPsQGjxUCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749245732; c=relaxed/simple;
	bh=CAdhtjT8y7b+vAf2yOZS0uA+0eCZUhLx9Z0B2yr4rPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvxyewSo9Sg8s4LE7bSpvd6PbEgm1AekMgewJ1CT3L7EKMmWc9+uxALAt0hHEDQ2AwqJu7d+bcAmmPvSDM8yql+3KlIOC1MGQOKhymljafhdGLM2u8xEjzZ00FiSP5BM0L5+l3E9T9ZRGHd7o/r8fZlIUW3G2/1xHj4ARWQijZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5k2leHc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB05C4CEEB;
	Fri,  6 Jun 2025 21:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749245731;
	bh=CAdhtjT8y7b+vAf2yOZS0uA+0eCZUhLx9Z0B2yr4rPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l5k2leHcV3h2hOkXYrEwrXBKyrk9Zs93invo6dL39uMVuGDkeHePjMV0qwYEZ8ubM
	 E4asyzAFJa1vqCE1w1mYOwCJwpAVdui6QoVpnHPE6T+j6LcS3rVLUDjFmZcgCVHQUN
	 2+5oJe6+NJs9DElc9IFBt8PDCdjtM75vsWE9kTfdIhJTxxR5s9UzPr/Y7vTr1f9jvV
	 dLZ/i2rIaHxBLK7YnBxSE2dlRNjTq3zMMoNaCzBUI8bX0WY1JwFwEfRAeykVrI5Mvj
	 Qs/g2nO471i2XkJ/IEaQ2gAWJMt/im49jKxVQ46sPXB+in/losonhXVRhi3Kv/iiDr
	 HtiYBrzWoolgQ==
Date: Fri, 6 Jun 2025 14:35:29 -0700
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
Message-ID: <uxlfn7pqanownop5vbie23np3nxtcr42cxbmczhirjlxiujtdp@dpr7mwr5e3dg>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <07252044-070f-405e-b1fe-ea27da7746e6@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <07252044-070f-405e-b1fe-ea27da7746e6@redhat.com>

On Fri, Jun 06, 2025 at 04:58:35PM -0400, Joe Lawrence wrote:
> On 5/9/25 4:17 PM, Josh Poimboeuf wrote:
> > +copy_patched_objects() {
> > +	local found
> > +	local files=()
> > +	local opts=()
> > +
> > +	rm -rf "$PATCHED_DIR"
> > +	mkdir -p "$PATCHED_DIR"
> > +
> > +	# Note this doesn't work with some configs, thus the 'cmp' below.
> > +	opts=("-newer")
> > +	opts+=("$TIMESTAMP")
> > +
> > +	find_objects "${opts[@]}" | mapfile -t files
> > +
> > +	xtrace_save "processing all objects"
> > +	for _file in "${files[@]}"; do
> > +		local rel_file="${_file/.ko/.o}"
> > +		local file="$OBJ/$rel_file"
> > +		local orig_file="$ORIG_DIR/$rel_file"
> > +		local patched_file="$PATCHED_DIR/$rel_file"
> > +
> > +		[[ ! -f "$file" ]] && die "missing $(basename "$file") for $_file"
> > +
> > +		cmp -s "$orig_file" "$file" && continue
> > +
> > +		mkdir -p "$(dirname "$patched_file")"
> > +		cp -f "$file" "$patched_file"
> > +		found=1
> > +	done
> > +	xtrace_restore
> > +
> > +	[[ -n "$found" ]] || die "no changes detected"
> > +
> 
> Minor nit here, I gave it a patch for files that didn't compile and
> because because files() was presumably empty:
> 
>   ./scripts/livepatch/klp-build: line 564: found: unbound variable
> 
> since found was only declared local, but never set inside the loop.

Thanks, I'm adding the following:

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 9927d06dfdab..f689a4d143c6 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -563,7 +563,7 @@ copy_orig_objects() {
 copy_patched_objects() {
 	local files=()
 	local opts=()
-	local found
+	local found=0
 
 	rm -rf "$PATCHED_DIR"
 	mkdir -p "$PATCHED_DIR"
@@ -592,7 +592,7 @@ copy_patched_objects() {
 	done
 	xtrace_restore
 
-	[[ -n "$found" ]] || die "no changes detected"
+	(( found == 0 )) && die "no changes detected"
 
 	mv -f "$TMP_DIR/build.log" "$PATCHED_DIR"
 }

