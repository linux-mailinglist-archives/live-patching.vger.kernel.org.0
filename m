Return-Path: <live-patching+bounces-1954-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kB0vD4VAfWmoRAIAu9opvQ
	(envelope-from <live-patching+bounces-1954-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 00:36:37 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A84C3BF673
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 00:36:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A1FB930157E7
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 23:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BAF38A9AC;
	Fri, 30 Jan 2026 23:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UghUCq7B"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A125838A9C3
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 23:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769816191; cv=none; b=hGzik7kKUCCqBdUQ26NfgA+XadyMzInAQhVMqdA2wDz91vvXIkJUWvjiSXAfB8A7GVHkUfcgeZ+20roB1RbTXuJ+2Z6mxCso+5PiOExdicDEcc6fXsEl7JVjZF+1aj2EraVnlph9h9P8BzDZGfpmXxFqSraYfqQFW5S9B4N5Pdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769816191; c=relaxed/simple;
	bh=imb8rz3sVXAdB3Lgq0T9LLdTICuNaSSnZYRoOexEiS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVkJb3wiTb0wr5EPilbIOjKFJbyCC7gsE19UEtlOjXwjtYNfCT0XowTYN9dfdqi4KvfdjZL2kk82dFJcKRHy09unk4uDafS75T0EPBm9MyXLqSMzN6ime3kQLnWJfTQ2LSxZtRakcb3yY0an1g9uCqYAUkXuwtt46wdUtMUGV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UghUCq7B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14FFC4CEF7;
	Fri, 30 Jan 2026 23:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769816191;
	bh=imb8rz3sVXAdB3Lgq0T9LLdTICuNaSSnZYRoOexEiS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UghUCq7BOi6iSwXH/zPgaKyMkNnlcXBs4JUjl3DY8tut/Vts878+JE6n7S+07g6//
	 yWCTeDbKrOr6G7sDLjYlNgz9EDV9i3m8HY5ap6Tgnzr5jWq5H9Nt6uxe72Y2AFpeek
	 PWTTcOjmewAzHgufq1UG4D8eLFzTN2V9dT7l9t0wteAjq+JBUOoZa0qwppuiuQnVma
	 mkdpvb/W1raY2DTbrtPhUCKZSfs4xLSEOIKANLHMbZYmO7gYJz1p3bGGTNqOWCXmcu
	 NEibw7/mOgQCHZGBJjJguoX66SfTXw+s3xtSpk5EfF+cuYlTOOGJUYjZXWpGhnl7Wf
	 rZ+IY0uBFQVyw==
Date: Fri, 30 Jan 2026 15:36:29 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
Message-ID: <f623bca43a54hwvekrvtfiomganr3f7s5qbb267g5v6nbi5seu@weqva7qp3f2d>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-5-joe.lawrence@redhat.com>
 <CAPhsuW59dfVk0hVPFWjgvEifUwviFvnCcMZFGMeZfrw3LJaRZA@mail.gmail.com>
 <aX0RBzV5X1lgQ2ec@redhat.com>
 <CAPhsuW60Gqht9QUEvW1PyMOORM=oWrWiJmfFF8Q+aEgX0DqQXQ@mail.gmail.com>
 <47mvnqxh6mc6twwmkrcfmmhnyo3ujsab6tkotvuf2jmsupveib@sf65ms5pp4de>
 <CAPhsuW6UwF+JAUGHpokSJ=sMJzhxZixdPZHznfdpdWioH2+Cwg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6UwF+JAUGHpokSJ=sMJzhxZixdPZHznfdpdWioH2+Cwg@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1954-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A84C3BF673
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 03:20:22PM -0800, Song Liu wrote:
> On Fri, Jan 30, 2026 at 2:54 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > Something like this?
> >
> > if (( SHORT_CIRCUIT <= 2 )); then
> >         status "Validating patch(es)"
> >         validate_patches
> >         fix_patches     # including fixing fuzz???
> > fi
> 
> I was thinking to change the above as
>    if (( SHORT_CIRCUIT <= 0 ))
> 
> Then we can save the fixed version of all the patches.
> 
> But I think "SHORT_CIRCUIT <= 2" is cleaner, so this version is better.

Right.  Just to clarify, the point of doing --short-circuit=2 (from my
experience) is you want to use a new .patch file which is different from
the one used by the previous klp-build incantation, but you don't want
to wait for the original build again.  Putting that behind
"SHORT_CIRCUIT <= 0" would prevent the use of the new .patch file.

-- 
Josh

