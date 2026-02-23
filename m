Return-Path: <live-patching+bounces-2071-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHDmF5HGnGnJKAQAu9opvQ
	(envelope-from <live-patching+bounces-2071-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:28:49 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4479017D977
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:28:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9E016301DD52
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 21:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735E2378822;
	Mon, 23 Feb 2026 21:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G43gKM1t"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5027C33C52A
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 21:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771882125; cv=none; b=YTby2sU3NyKHeBc2n8LVrrdfSrTfZm40XKynxjof3Fig6Ryc/ahqpmml7lqSfLZXRKMeGAf8TuZX67M48/5TKbtvQJuuKx+i3zbH/HWT7nLR3daO/03SbBSaSUazDGTECXXFkSbAGJoc07eqOx+0n+Hy/Ol6mYlwjPscdwDBp8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771882125; c=relaxed/simple;
	bh=cwwWIjL4pP3EvBincnlkKGiQ9ksSYkkG3VYeo39hKy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Phv3/uLm6vqwMUIS+50K4/Eaw1pFsdOtWY4YFHc2ngx8CMwKBv4N8w9TteB296Qsl798wHtGVsToQJeaLgKAoIDhj3bobE34djJ8Ar6p9APYv0Q1Zt+G7NYK+W5kCrLoN/O0kOGt9Jpi7hgM9VBE98R+6BFjv6a9QDNYbZ4m63k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G43gKM1t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AC1C116C6;
	Mon, 23 Feb 2026 21:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771882124;
	bh=cwwWIjL4pP3EvBincnlkKGiQ9ksSYkkG3VYeo39hKy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G43gKM1tvHvlJPldulV6EJOMonyTQAZ4khhnwbxKw8uuxedwAxb0KUpec1Sl6JD12
	 DXUWJ2MyqXfSMyCRFj8pXWDqwLYJAiE9N+KidWagbGvhwaaq6ZhmFjhfqA88o6NLi8
	 BRmVqDX/5eRZEM6mbHRk7dSBAYZ3uLs9kzAJNo4pj55WMT6QkeG0CsiRtAlzbB8que
	 wxrVsGK1OnHXVBA8IE4JYpYlf0LFZc22LygWrkM1fKn/z6OG5ERG3xpNcztj9oGDDB
	 M0bEGNinQ9C3MxY10tHLMGq+AJMHzbiWpfuNtMkvB2avGcqnbV/F272qr8XzhcNGDh
	 oEQ2mVEgUN+AQ==
Date: Mon, 23 Feb 2026 13:28:42 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 11/13] livepatch/klp-build: add terminal color output
Message-ID: <7lykwpkqigzixza3xqhg7yqfhydcdim6dmzf2e5lembxjim6zb@z6y5n6qpb4xs>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-12-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260217160645.3434685-12-joe.lawrence@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-2071-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4479017D977
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:06:42AM -0500, Joe Lawrence wrote:
> Improve the readability of klp-build output by implementing a basic
> color scheme.  When the standard output and error are connected to a
> terminal, highlight status messages in bold, warnings in yellow, and
> errors in red.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  scripts/livepatch/klp-build | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 80703ec4d775..fd104ace29e6 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -52,6 +52,15 @@ PATCH_TMP_DIR="$TMP_DIR/tmp"
>  
>  KLP_DIFF_LOG="$DIFF_DIR/diff.log"
>  
> +# Terminal output colors
> +read -r COLOR_RESET COLOR_BOLD COLOR_ERROR COLOR_WARN <<< ""
> +if [[ -t 1 && -t 2 ]]; then
> +	COLOR_RESET="\033[0m"
> +	COLOR_BOLD="\033[1m"
> +	COLOR_ERROR="\033[0;31m"
> +	COLOR_WARN="\033[0;33m"
> +fi
> +
>  grep0() {
>  	# shellcheck disable=SC2317
>  	command grep "$@" || true
> @@ -65,15 +74,15 @@ grep() {
>  }
>  
>  status() {
> -	echo "$*"
> +	echo -e "${COLOR_BOLD}$*${COLOR_RESET}"
>  }
>  
>  warn() {
> -	echo "error: $SCRIPT: $*" >&2
> +	echo -e "${COLOR_WARN}warn${COLOR_RESET}: $SCRIPT: $*" >&2

Shouldn't this reset the colors *after* printing out the whole message?

Also, while it does make sense for warn() to print "warn:" rather than
"error:", note its called by trap_err(), which should print the latter.

So we may need a new function -- error() or so.  Or even better, name
them print_error() and print_warning() to clarify that they don't exit
directly, as opposed to die().

-- 
Josh

