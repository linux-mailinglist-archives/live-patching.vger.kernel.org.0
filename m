Return-Path: <live-patching+bounces-1986-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8IJaD8+Jg2lWpAMAu9opvQ
	(envelope-from <live-patching+bounces-1986-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 19:02:55 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C45EB534
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 19:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 21DC630156E8
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 18:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8C1421EE2;
	Wed,  4 Feb 2026 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7CtaZB8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAA0421EF2
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770228160; cv=none; b=mVmE6+VI4IY0d3a69TAH6yC4u6j47AGNGqUnJZ+n6Nz96gjKrqHOKkQxBs7eNl/TPTtPe8bF7M5zZb5IWCG6XYlh1CTobclrNYNFQ4+qVIFog6WhHPySsoY3NGbJAB0pesL78XYEzSjCMJHGhGHH5EMaZ6lgX4W6tKQOb2LgYz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770228160; c=relaxed/simple;
	bh=8JQlvZtib4n8VpbSZ3TGkKumrwXyUja9GfjI50xO/Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ftlsRRHa9QVLZRqHiks3OoKx7oFvxQa2O10jSNR8qshl/mWj2LCRPEWLn+ZW0oIFO4rkfWcwNqwMObWh2Pdb7J+qgr021ltlPoYQ+bPYyCZClLFQmRapmhfvNYmB4BnrnL0M6aeNt3J3ar+qmPy2belB6LUqBfXi8jgtYdWKOcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7CtaZB8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC499C4CEF7;
	Wed,  4 Feb 2026 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770228160;
	bh=8JQlvZtib4n8VpbSZ3TGkKumrwXyUja9GfjI50xO/Ug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k7CtaZB8gJ99x66C9ea1ukOytZt+3N0NeMqonC98CI1EAzbxQqghkJZLzb2DLaPwD
	 32GsuWHmUOI2fmjqHuLhIOowAzK6Jmj2StarcMLBCM7PsexaEOO9pI4Z/2bnShnRIz
	 Zy5gH2kd0JY8ZlMgK7wwBJ5rQN9sm12QD++KmY4MaOCTIjKj2Zzn/rprusAYrSTtj4
	 pD902hS56KFzGLj++PeiCAcS5AaTjFKHxacjpWf5SZ+T5zi9ODqC7jovT6KCE3L1By
	 svRoDxymHBJt8cp3I9k1ap84zGxAQ5bGEiWUAGBZHIycXWmHb07X8kpMncunIUIrVq
	 QTwq+F3dfltKw==
Date: Wed, 4 Feb 2026 10:02:38 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 2/5] livepatch/klp-build: handle patches that
 add/remove files
Message-ID: <ywooax5vfkh7k7h4mjpxfhtbkr3rdcvi5sjqmnjgcmxrc4ykwa@mk6z5zosbuvz>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-3-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260204025140.2023382-3-joe.lawrence@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1986-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 92C45EB534
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 09:51:37PM -0500, Joe Lawrence wrote:
> The klp-build script prepares a clean patch by populating two temporary
> directories ('a' and 'b') with source files and diffing the result.
> However, this process currently fails when a patch introduces a new
> source file as the script attempts to copy files that do not yet exist
> in the original source tree.  Likewise, there is a similar limitation
> when a patch removes a source file and the script tries to copy files
> that no longer exist.
> 
> Refactor the file-gathering logic to distinguish between original input
> files and patched output files:
> 
> - Split get_patch_files() into get_patch_input_files() and
>   get_patch_output_files() to identify which files exist before and
>   after patch application.
> - Filter out "/dev/null" from both to handle file creation/deletion
> - Update refresh_patch() to only copy existing input files to the 'a'
>   directory and the resulting output files to the 'b' directory.
> 
> This allows klp-build to successfully process patches that add or remove
> source files.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  scripts/livepatch/klp-build | 34 +++++++++++++++++++++++++++-------
>  1 file changed, 27 insertions(+), 7 deletions(-)
> 
> Lightly tested with patches that added or removed a source file, as
> generated by `git diff`, `git format-patch`, and `diff -Nupr`.
> 
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 9f1b77c2b2b7..5a99ff4c4729 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -299,15 +299,33 @@ set_kernelversion() {
>  	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
>  }
>  
> -get_patch_files() {
> +get_patch_input_files() {
> +	local patch="$1"
> +
> +	grep0 -E '^--- ' "$patch"				\
> +		| gawk '{print $2}'				\
> +		| grep -v '^/dev/null$'				\

Because pipefail is enabled, the grep0 helper should be used instead of
grep, otherwise a failed match can propagate to an error.  Maybe we need
a "make check" or something which enforces that and runs shellcheck.

-- 
Josh

