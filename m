Return-Path: <live-patching+bounces-1940-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LXqABcPfWlvQAIAu9opvQ
	(envelope-from <live-patching+bounces-1940-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:05:43 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D492BE4E2
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8E075301CFCE
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5853930AD1C;
	Fri, 30 Jan 2026 20:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hP0WctEP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35620307AD6
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 20:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769803538; cv=none; b=pr0UEBPx3rEZg6yf8Y7DxL4KUZWLUFKvy0zD+dKAr7Nqc7uMmDsm8MTc4Xwgd984iJzOOENA2WScW2g9+1/CnkYESujPnN1R0kDl2PrTSe/Qek+/XP/3gWAfXH9dtLJla+WQ+57vnFv2qFQ6AyOgFFr7nNoxnCQtjjrSt0JtSX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769803538; c=relaxed/simple;
	bh=yMSpORqDDGeaAsOS2sl26tyceq+cPfRkRgXn9PU+Trw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bXRrlxIAAkXCQ+n1sz7FBMt8hIiB/T0bx8shHWWywzRwDERmqoupulhOKPY2xSKkWNs/o5kU6tC4Bz83oauoNXMqW0+d1GQuVbqeDKe6MgkxL+rTpuqgfT9y0/TT5dThwSBlnZNf6e9s+qlcwjxRQHIKbn3oaQVCVHDE9ihiQ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hP0WctEP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF80C4CEF7;
	Fri, 30 Jan 2026 20:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769803537;
	bh=yMSpORqDDGeaAsOS2sl26tyceq+cPfRkRgXn9PU+Trw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hP0WctEPWz+WTl/pBHVcPR0oJO4l+fDEAW/8tGBw2io+NCHK3oG8YcsfjM3YJ+fL9
	 7vA9ETEidUEjvb41Qel/7cvssgHTsYu+VGiUdHA7Vc+thBrQ7qc/Z1YfIHx1d7Jadw
	 o7w8RPpNOTWCz7hGHLCAUsyLHkVeB2d+U/BVsdQSGg6T4304E2QrvQXt52Y4nwTzy0
	 5SeEfCUFhaTKxbUe3rlfIGUPyYNaITsKE8+d1xA7Xrjx/FiFYD05yN6IT1R2nnTQqp
	 UAIa7ZPzx5m43EVZU+D9DuF7wFduXa9Affx7ZDixNfLHlr3b3VZK1W+kC07FC4eAPY
	 BFrLokFhWtAlg==
Date: Fri, 30 Jan 2026 12:05:35 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 3/5] objtool/klp: validate patches with git apply
 --recount
Message-ID: <lqchka76tcwjxitn5tm42keexglnac6iveb44ppgx4c425qsfg@sbcdkfgmebqu>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-4-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260130175950.1056961-4-joe.lawrence@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-1940-lists,live-patching=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5D492BE4E2
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 12:59:48PM -0500, Joe Lawrence wrote:
> Consider a patch offset by a line:
> 
>   $ cat combined.patch
>   --- src.orig/fs/proc/cmdline.c	2022-10-24 15:41:08.858760066 -0400
>   +++ src/fs/proc/cmdline.c	2022-10-24 15:41:11.698715352 -0400
>   @@ -6,8 +6,7 @@
>   
>    static int cmdline_proc_show(struct seq_file *m, void *v)
>    {
>   -	seq_puts(m, saved_command_line);
>   -	seq_putc(m, '\n');
>   +	seq_printf(m, "%s livepatch=1\n", saved_command_line);
>    	return 0;
>    }
>   
>   --- a/fs/proc/version.c
>   +++ b/fs/proc/version.c
>   @@ -9,6 +9,7 @@
>   
>    static int version_proc_show(struct seq_file *m, void *v)
>    {
>   +	seq_printf(m, "livepatch ");
>    	seq_printf(m, linux_proc_banner,
>    		utsname()->sysname,
>    		utsname()->release,
> 
> GNU patch reports the offset:
> 
>   $ patch --dry-run -p1 < combined.patch
>   checking file fs/proc/cmdline.c
>   Hunk #1 succeeded at 7 (offset 1 line).
>   checking file fs/proc/version.c
> 
> It would pass the initial check as per validate_patches():
> 
>   $ git apply --check < combined.patch && echo "ok"
>   ok
> 
> But later fail the patch application by refresh_patch():
> 
>   $ git apply --check --recount < combined.patch
>   error: patch failed: fs/proc/cmdline.c:6
>   error: fs/proc/cmdline.c: patch does not apply

Hm, isn't the whole point of --recount that it ignores the line numbers?
Or does it just ignore the numbers after the commas (the counts)?

-- 
Josh

