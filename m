Return-Path: <live-patching+bounces-2589-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mMTDL7bm8GmoagEAu9opvQ
	(envelope-from <live-patching+bounces-2589-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:56:22 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB12848970E
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F8C230F06F3
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 16:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983A5328B71;
	Tue, 28 Apr 2026 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sNVE5Mub"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7455E3264E3;
	Tue, 28 Apr 2026 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393844; cv=none; b=GYHqUDrscy+yJPLwn/mNYyASx7AH1sbQpr5pcovB+buLw5ibftH9SHYUVQGTTMNCL7DQGnDDa4nmEVoolgvqAGUzlyP6VyMhdZZ2n9/x0w7obWMlT/Xmo4tApyR5nMw6MpKUhQ/UJ+6XexgYitKgnRwv5H9HoI05e+J5mWxoi0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393844; c=relaxed/simple;
	bh=LweoMYq7cpWCw9PRPjqV5qSqzuFr9dit04z5VuXKECk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZVc+iImdFFBH9U1VOxVq0r/VW0Ldt94PaW+cu10kawaBN5DzMtnjHalHO+/c9jfV0FgY3ZM5vvUXC+Ctj7GF64XL+4809aENttUoKMG/jHq2jgLYBBRuvPjodgsZe0w/QVCH29/WoN9353PPsVbMpC7B82NY3k/Chzhk4RqVKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sNVE5Mub; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F21C2BCAF;
	Tue, 28 Apr 2026 16:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777393844;
	bh=LweoMYq7cpWCw9PRPjqV5qSqzuFr9dit04z5VuXKECk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sNVE5MubwwF2vFSvV2XyV4N8gzwwpJNvdhJ5vpWzV60xMV2aF/rIWY7mDi5KTiLdm
	 tGMtkYs+znZXUopowcC72jieRMIQ4BrXlgX/G4wTIaPG2KJQ4JUJb/GnYEI+nPa6CA
	 XKTB0i/E7vK8KzJm0waqNwE7WCrkLrxOxoXkzxQ4TNKYDxRztQasGsoMHo4LmVahhE
	 OJhFw3qZu87h/5wMM4YslWmHtoU7nCF0jDbi2JRlAFS2mfK+oL+qRbZ3R7DGlX8Mpz
	 5RyD7Aap/cNJwhEe8WBSCLfxclEXtnHfekDDHwQyewGoGVzkY+3Rlh/SI0+U/s8BfA
	 oNPwKgh8FqC1A==
Date: Tue, 28 Apr 2026 09:30:41 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 10/48] objtool/klp: Fix --debug-checksum for duplicate
 symbol names
Message-ID: <jvpxi22gmw73dwrj45ie7itlsul4qjzgydkla2mbx7xbsp7i3d@52kapw55mk4l>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <7fd49264db4f5a9c654ad162cca96ce575e77ae4.1776916871.git.jpoimboe@kernel.org>
 <177737835356.11371.5834023067101378921.b4-review@b4>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <177737835356.11371.5834023067101378921.b4-review@b4>
X-Rspamd-Queue-Id: EB12848970E
X-Rspamd-Action: no action
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
	TAGGED_FROM(0.00)[bounces-2589-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Tue, Apr 28, 2026 at 02:12:33PM +0200, Miroslav Benes wrote:
> On Wed, 22 Apr 2026 21:03:38 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > find_symbol_by_name() only returns the first match, so
> > --debug-checksum=<func> silently ignores any subsequent duplicately
> > named functions after the first.
> > 
> > Add a new iterate_sym_by_name() to fix that.
> 
> The patch is ok but is it worth it when you remove it again in 39/48
> with a better implementation? Can 39/48 be moved here in the series
> instead?

Indeed...

-- 
Josh

