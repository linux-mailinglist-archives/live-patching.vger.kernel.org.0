Return-Path: <live-patching+bounces-1996-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DcGHsTYhGlo5gMAu9opvQ
	(envelope-from <live-patching+bounces-1996-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 18:52:04 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 165B7F6333
	for <lists+live-patching@lfdr.de>; Thu, 05 Feb 2026 18:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 803C930022A4
	for <lists+live-patching@lfdr.de>; Thu,  5 Feb 2026 17:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44572FFDE3;
	Thu,  5 Feb 2026 17:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9YMp+JG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F3E19E968
	for <live-patching@vger.kernel.org>; Thu,  5 Feb 2026 17:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313794; cv=none; b=iuTf+/cWQj/c4DQ7ucDiG8bXhsxSS/b3EamszYUAspwP8be8LaC+ZSAdM//wE6aHWNdAT4kMenA1+wlnKW7w4y3IOiAmPqvMCE6I7ZoJt1fgkx0uXwsfVEzVMIuJErXaDSxd9ue5lbNBNeWCvwAYGB+u9s/c0FkM6NhkIFCEuQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313794; c=relaxed/simple;
	bh=Z062QCaE3HSKmQgrw+r55QCTiLd6ezOFn845cUupIWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eooFws3W7abHHtCJb8kwVTfj8JO+t0tbk6jPbddPkuyTKHGz+kLUf1zgUpnQirMJYqnldjXJQPHGbKJKFTvMbfmaxCUHhUzo+hhDwIpsFdf2B+M14NM4vG3GsXuTbx0SsOpp+vvBt87n5hOlGVjJRYxLISXHd6X08QYkCkGOiR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9YMp+JG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA80C4CEF7;
	Thu,  5 Feb 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770313794;
	bh=Z062QCaE3HSKmQgrw+r55QCTiLd6ezOFn845cUupIWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i9YMp+JGKZpOb0S8TXcf/80YKvoBhH2rlV6bIiSaZPrVQiSCvZUlg/dL1I0QLaWeQ
	 FKvWayLmYHr7fFMTZScOKvCk2M/nv/fXdPHWno39GCHTldMMRB9Y3BB7mHvYvY+aYy
	 G84z8dF4NgFGTkk9zvWKVUF3nmk/xRPesNyrpqOolAAx3JYQ29tlZJyfW0Wfw8XEPy
	 hlsCbWvQp8SCZWKfWfCbteJ+k7bvfypONtc+9hrXp1EgJCAb3pUCUGKWjbjzScz3ez
	 gSEm5XUvALBIU+5RK1twu6SrEl1atVYGv9WYkLBab4q8FumQzQyiLwNNzzzXf591Zg
	 0dzfFZVEt3Jcg==
Date: Thu, 5 Feb 2026 09:49:52 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v2 3/5] livepatch/klp-build: switch to GNU patch and
 recountdiff
Message-ID: <j7vzcanwaz3mi65pndh3ekpcmzkow4exz2ao7v35neoo5ctjpv@67n4wjlqftrq>
References: <20260204025140.2023382-1-joe.lawrence@redhat.com>
 <20260204025140.2023382-4-joe.lawrence@redhat.com>
 <2j5d3dwa6jymmnte4gcykbm5pfzc36x7onn2ojgjliwkxnlcik@34hti52xld5m>
 <aYTS_ZtgcnZP3UCm@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYTS_ZtgcnZP3UCm@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-1996-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 165B7F6333
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 12:27:25PM -0500, Joe Lawrence wrote:
> On Wed, Feb 04, 2026 at 10:35:07AM -0800, Josh Poimboeuf wrote:
> > On Tue, Feb 03, 2026 at 09:51:38PM -0500, Joe Lawrence wrote:
> > >   My initial thought was that I'd only be interested in knowing about
> > >   patch offset/fuzz during the validation phase.  And in the interest of
> > >   clarifying some of the output messages, it would be nice to know the
> > >   patch it was referring to, so how about a follow up patch
> > >   pretty-formatting with some indentation like:
> > > 
> > >   Validating patch(es)
> > >     cmdline-string.patch
> > >       patching file fs/proc/cmdline.c
> > >       Hunk #1 succeeded at 7 (offset 1 line).
> > >   Fixing patch(es)
> > >   Building patched kernel
> > >   Copying patched object files
> > >   Diffing objects
> > >   vmlinux.o: changed function: override_release
> > >   vmlinux.o: changed function: cmdline_proc_show
> > >   Building patch module: livepatch-cmdline-string.ko
> > >   SUCCESS
> > > 
> > >   That said, Song suggested using --silent across the board, so maybe
> > >   tie that into the existing --verbose option?
> > 
> > Hm.  Currently we go to considerable effort to make klp-build's output
> > as concise as possible, which is good.  On the other hand, it might be
> > important to know the patch has fuzz.
> > 
> 
> To keep it succinct, the script could check for offset/fuzz and only
> report it, including the "patching file ..." part, if there is any.

Maybe?  Only if it's not too complicated.

> > I'm thinking I would agree that maybe it should be verbose when
> > validating patches and silent elsewhere.  And the pretty formatting is a
> > nice upgrade to that.
> > 
> 
> In the past I've used a little function like:
> 
>   indent() {
>       local num="${1:-0}"
>       sed "s/^/$(printf '%*s' "$num" '')/"
>   }
> 
> so I could just pipe in echo or command output like: `./cmd | indent 2`.
> Good enough or maybe you have one?

Sounds good, it probably needs a "return true" at the end of the function.

> > We might also consider indenting the outputs of the other steps.  For
> > example:
> > 
> >   Building patched kernel
> >     vmlinux.o: some warning
> >   Copying patched object files
> >   Diffing objects
> >     vmlinux.o: changed function: override_release
> >     vmlinux.o: changed function: cmdline_proc_show
> > 
> > Or alternatively, print the step names in ASCII bold or something.
> > 
> 
> While I do kinda like the recent color coded output from the compilers,
> I don't know if I'm ready for a full-color livepatch build experience :D
> 
> I wouldn't be against it, but my vote leans towards the indentation
> since it leaves prettier log files, even if the color codes are filtered
> out.  Then again, the color scheme bikeshedding we could look forward
> to!

:-)

-- 
Josh

