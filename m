Return-Path: <live-patching+bounces-1987-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCCpDmGRg2lCpQMAu9opvQ
	(envelope-from <live-patching+bounces-1987-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 19:35:13 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C74EBB2B
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 19:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E376C3005AA1
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 18:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7225D3EDABE;
	Wed,  4 Feb 2026 18:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StesMV7o"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFD2232395
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 18:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770230110; cv=none; b=eA/M9ET92Ab1Ns/7iIbfnvY5OxG/twgObCwYKzgWtnRL0nQmWBYphx3aVuj+YUJ6dGlxAZz2jtsvyeLof+4oy3dkjpPjCzZ2ukTwVaSnHcU1WshFouRo79b4PuZGwLcyblZTMaqGf0kQ5pyj2tm3jBXiea34AIbDsevuS3Ag8m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770230110; c=relaxed/simple;
	bh=F/jivyDPgqOPGi3FR4ENZsvxnztaZqjsnB3iXXsdjxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h70EIahD+b/Dn/rOVJB6TJS7+pO4LPSfvbiBf+ckE1GTYa4qer71Oqd8ArRgkLJDXL8NdQjwasFQMnktcYS1n/4O39P20mK+3RpvAhYWbQyMtNHHSJgleFTo8xUl//4AXZbm93fz7zgIUaZUE3WWYev6ZPJ/RqJ4B3xfmEp92CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StesMV7o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8A3C4CEF7;
	Wed,  4 Feb 2026 18:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770230110;
	bh=F/jivyDPgqOPGi3FR4ENZsvxnztaZqjsnB3iXXsdjxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=StesMV7ooLv41lIwCXYyUWEpP+6RD4Xhu8aeE1u3EyJQ4GAmXE18+xPhZFn8OsVMw
	 FqnpsjyA23XZebvO7wleKg3wXDwgxpJttGsKkl9t79iNjZ2xW2ppPTdmubkbaZ6kBE
	 UWYE3qq1YY16qKQZrsOJGAGG1gyZhIbx3I6gC7+A4jlLsJdKYv08bewRal/nE5WYdQ
	 ri5CN9kY9JgtWAUU/zCM+3Px3K67kemDp5zw4+Tyov57d7d1bgTNDic+iPLXbR2gZ7
	 pHrx/wPzGaj7KGrgw6WJIxJedO5gdqKYAV1bKv4nz8znt8xF8ZsDALsUFvR3PUq5Lj
	 wH5RGx/KE1hUA==
Date: Wed, 4 Feb 2026 10:35:07 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 3/5] livepatch/klp-build: switch to GNU patch and
 recountdiff
Message-ID: <2j5d3dwa6jymmnte4gcykbm5pfzc36x7onn2ojgjliwkxnlcik@34hti52xld5m>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-4-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260204025140.2023382-4-joe.lawrence@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1987-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C9C74EBB2B
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 09:51:38PM -0500, Joe Lawrence wrote:
> I think this does simplify things, but:
> 
>   - introduces a dependency on patchutil's recountdiff

I was wondering if we could instead just update fix-patch-lines to fix
the line numbers/counts, but I get the feeling that would require
rewriting the whole script and may not be worth the complexity.  That
script is nice and simple and robust at the moment.

>   - requires goofy epoch timestamp filtering as `diff -N` doesn't use
>     the `git diff` /dev/null, but a localized beginining of time epoch
>     that may be 1969 or 1970 depending on the local timezone
>   - can be *really* chatty, for example:
> 
>   Validating patch(es)
>   patching file fs/proc/cmdline.c
>   Hunk #1 succeeded at 7 (offset 1 line).
>   Fixing patch(es)
>   patching file fs/proc/cmdline.c
>   Hunk #1 succeeded at 7 (offset 1 line).
>   patching file fs/proc/cmdline.c
>   patching file fs/proc/cmdline.c
>   Building patched kernel
>   Copying patched object files
>   Diffing objects
>   vmlinux.o: changed function: override_release
>   vmlinux.o: changed function: cmdline_proc_show
>   Building patch module: livepatch-cmdline-string.ko
>   SUCCESS
> 
>   My initial thought was that I'd only be interested in knowing about
>   patch offset/fuzz during the validation phase.  And in the interest of
>   clarifying some of the output messages, it would be nice to know the
>   patch it was referring to, so how about a follow up patch
>   pretty-formatting with some indentation like:
> 
>   Validating patch(es)
>     cmdline-string.patch
>       patching file fs/proc/cmdline.c
>       Hunk #1 succeeded at 7 (offset 1 line).
>   Fixing patch(es)
>   Building patched kernel
>   Copying patched object files
>   Diffing objects
>   vmlinux.o: changed function: override_release
>   vmlinux.o: changed function: cmdline_proc_show
>   Building patch module: livepatch-cmdline-string.ko
>   SUCCESS
> 
>   That said, Song suggested using --silent across the board, so maybe
>   tie that into the existing --verbose option?

Hm.  Currently we go to considerable effort to make klp-build's output
as concise as possible, which is good.  On the other hand, it might be
important to know the patch has fuzz.

I'm thinking I would agree that maybe it should be verbose when
validating patches and silent elsewhere.  And the pretty formatting is a
nice upgrade to that.

We might also consider indenting the outputs of the other steps.  For
example:

  Building patched kernel
    vmlinux.o: some warning
  Copying patched object files
  Diffing objects
    vmlinux.o: changed function: override_release
    vmlinux.o: changed function: cmdline_proc_show

Or alternatively, print the step names in ASCII bold or something.

>  apply_patch() {
>  	local patch="$1"
> -	shift
> -	local extra_args=("$@")
>  
>  	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
>  
>  	(
>  		cd "$SRC"
> -
> -		# The sed strips the version signature from 'git format-patch',
> -		# otherwise 'git apply --recount' warns.
> -		sed -n '/^-- /q;p' "$patch" |
> -			git apply "${extra_args[@]}"
> +		# The sed strips the version signature from 'git format-patch'.
> +		sed -n '/^-- /q;p' "$patch" | \
> +			patch -p1 --no-backup-if-mismatch -r /dev/null

Is this still needed now that we don't use git apply --recount?

> @@ -490,7 +468,7 @@ fix_patches() {
>  
>  		cp -f "$old_patch" "$tmp_patch"
>  		refresh_patch "$tmp_patch"
> -		"$FIX_PATCH_LINES" "$tmp_patch" > "$new_patch"
> +		"$FIX_PATCH_LINES" "$tmp_patch" | recountdiff > "$new_patch"
>  		refresh_patch "$new_patch"

Do we still need to refresh after the recountdiff?

-- 
Josh

