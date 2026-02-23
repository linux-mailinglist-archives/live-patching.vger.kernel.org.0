Return-Path: <live-patching+bounces-2073-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLFBNlrJnGkwKQQAu9opvQ
	(envelope-from <live-patching+bounces-2073-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:40:42 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF9417DAA6
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 22:40:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 98678300F289
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 21:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC8B378D96;
	Mon, 23 Feb 2026 21:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwIUnWCn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7F9377543
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 21:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771882817; cv=none; b=EoNyC5M8rBKlGNl84+PaknS7X9MF7RHTH+vpBCpIRjw88Ur1p5H3LsLiwbl1x3MS7gT0c5+bEe987y6Zt6WrFY7+ITRy7dvZ1FEovXfyPjlYg9lJ+mjyTejMUcukig/eQpcUTxO1FWik4hn9Bb8rZzrOGfY/9fPOE+mZrVFYKuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771882817; c=relaxed/simple;
	bh=zF74N69ts4tQKlXd398w5q4hVQHGwPFRRezuaR1V8i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzNfTppAP7vhIBc0aLkJRLSflsU1f6YZn5e6xB96Vg4QZjWZKA/eE/7pIU4cYdcfqTxahMSKGff5mUMiGPE3Uv+v0P4QPvUt/hPNta0X8X8i3+Vf2k0Hz8xdUfhk9RJUymoSEJZAgR1CInFWAfS4A6EpDju02+Ixjss67nfX+fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwIUnWCn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F230C116C6;
	Mon, 23 Feb 2026 21:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771882816;
	bh=zF74N69ts4tQKlXd398w5q4hVQHGwPFRRezuaR1V8i0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RwIUnWCnCQoMfwDUCR1hn/Cv6Ns3NtaVAJwkId/qZ670uYlHuZV9jiEZ6TvvAfbyc
	 DGqrH4FHiAJHp9/dIgHo273dIYdAItSy8fZN5whe0pGyw3UuGuO1tfpS0+Q/vGyHoO
	 1rdta556XORodv1yB229982MDiUx8JJ4og9WdcUQPZzi/ts1+yvv6zwFyESCxyK4yD
	 SRvYr6NcoAehRgONxFeIDkCbqINCi8J6AiGNHQSYXVws9KoWbDwNSxwAbldVH7WN/R
	 vtOeVtuHWiQ9LhGWlp+6t6hloXr8xr1J04pWwtoFWS9m9sw5SKf/D0ahbi8Hnux/gn
	 NhcJsGe4ECRAQ==
Date: Mon, 23 Feb 2026 13:40:14 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 12/13] livepatch/klp-build: report patch validation
 drift
Message-ID: <7iqwondhaweraszxu2xyjbz7lq6ttdd3yvg3erzuurboo757ov@4b5h7apjdarm>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-13-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260217160645.3434685-13-joe.lawrence@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2073-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0EF9417DAA6
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:06:43AM -0500, Joe Lawrence wrote:
> Capture the output of the patch command to detect when a patch applies
> with fuzz or line offsets.
> 
> If such "drift" is detected during the validation phase, warn the user
> and display the details.  This helps identify input patches that may need
> refreshing against the target source tree.
> 
> Ensure that internal patch operations (such as those in refresh_patch or
> during the final build phase) can still run quietly.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  scripts/livepatch/klp-build | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index fd104ace29e6..5367d573b94b 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -369,11 +369,24 @@ check_unsupported_patches() {
>  
>  apply_patch() {
>  	local patch="$1"
> +	shift
> +	local extra_args=("$@")
> +	local drift_regex="with fuzz|offset [0-9]+ line"
> +	local output
> +	local status
>  
>  	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
> -	patch -d "$SRC" -p1 --dry-run --silent --no-backup-if-mismatch -r /dev/null < "$patch"
> -	patch -d "$SRC" -p1 --silent --no-backup-if-mismatch -r /dev/null < "$patch"
> +	status=0
> +	output=$(patch -d "$SRC" -p1 --dry-run --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" < "$patch" 2>&1) || status=$?
> +	if [[ "$status" -ne 0 ]]; then
> +		echo "$output"
> +		die "$patch did not apply"
> +	elif [[ "$output" =~ $drift_regex ]]; then
> +		warn "$patch applied with drift"
> +		echo "$output"

Just for consistency with the output ordering of the "patch did not
apply" error, I think the "$output" should be printed *before* the
"$patch applied with drift".

Also, should $output be printed to stderr?

Also, I've not heard of patch "drift", is "fuzz" better?

-- 
Josh

