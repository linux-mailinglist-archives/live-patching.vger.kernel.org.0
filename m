Return-Path: <live-patching+bounces-1951-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WICkD3c4fWlMQwIAu9opvQ
	(envelope-from <live-patching+bounces-1951-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 00:02:15 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A367BBF4BB
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 00:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 96B60300A4F4
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 23:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68BFC35CBD2;
	Fri, 30 Jan 2026 23:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSkmx3Ln"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461BF2D191C
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 23:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769814131; cv=none; b=atTcoc243R/SXbYr59xcYj5vg4cYqkZsF8Big6GXMdNcVot/I9uG4PK8ZA5vZqnAtSWmLoaOZ17okVMyEYWgKDDURYuocxQ84XmEPuOVNWwSuzsgTlTiD7cRAWlFBOwLWRB8w35Qok44aTzDzYQ6U4KquLtzKp/OLYyFM844M3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769814131; c=relaxed/simple;
	bh=vXBNQx/zo/VPjFFWz1WfqvCqDmbCxT9qbaRUFTOdM5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTiuw06HnxK8PV6QIlGvyT/P7QLEQU7CDWphn+8wEWRXNG2MT9WhXGZNzYjOMr+twyMorsDrds65k/pRGPpmXmLo8CEtZEjIT2IbD+XegmhpFlUv4ckarb3tLkNLM6+B3PmetmDZrAjZkAyiBI/XJBAGdHSIXJAucgi4rl+k++M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSkmx3Ln; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46029C4CEF7;
	Fri, 30 Jan 2026 23:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769814130;
	bh=vXBNQx/zo/VPjFFWz1WfqvCqDmbCxT9qbaRUFTOdM5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SSkmx3LnXbTLX8Q1OX/VPBac2j+tDeI0a4KdAaD56lTPt+Wlu2gkt3Wz2/cplv8oM
	 eF44wdJ4EljRYhnpskFwZljp0Vm16w7ToODN94W7yWhyF0xw9jjFUDOY1QFbvd9wGl
	 5MVPDGJCFx8gkJ/BhOykp0rzO5PFtPbbdz6HvoE56K6eUDdvGBPVViGRyMYmyzEQbA
	 oihtezCbpZPfV1YWgmoi+t+TiG+IICn84bzgTdcMgDD7mFErCG79Y8NVBqbG8W+Q7h
	 8kv+lRf1HHubB9Kc1g+sgv4NkXXui56n0i4eL9oaezWqY85/ZMDYIWLHNNqti6Khzr
	 kM9u3MCO2+khA==
Date: Fri, 30 Jan 2026 15:02:08 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 3/5] objtool/klp: validate patches with git apply
 --recount
Message-ID: <72pzjkj4vnp2vp4ekbj3wnjr62yuywk67tavzn27zetmkg2tjh@nkpihey5cc3g>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-4-joe.lawrence@redhat.com>
 <lqchka76tcwjxitn5tm42keexglnac6iveb44ppgx4c425qsfg@sbcdkfgmebqu>
 <aX0W0JWRkLbuQpGY@redhat.com>
 <omt3bm5upud3sywupr3g3evxqs437x5f5wcxlnba2j5u4rtle2@b62zb4hfydby>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <omt3bm5upud3sywupr3g3evxqs437x5f5wcxlnba2j5u4rtle2@b62zb4hfydby>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1951-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: A367BBF4BB
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 02:59:53PM -0800, Josh Poimboeuf wrote:
> On Fri, Jan 30, 2026 at 03:38:40PM -0500, Joe Lawrence wrote:
> > On Fri, Jan 30, 2026 at 12:05:35PM -0800, Josh Poimboeuf wrote:
> > > Hm, isn't the whole point of --recount that it ignores the line numbers?
> > > Or does it just ignore the numbers after the commas (the counts)?
> > > 
> > 
> > I don't know exactly.  As I continue digging into the test that sent me
> > down this path, I just found that `git apply --recount` doesn't like
> > some output generated by `combinediff -q --combine` even with NO line
> > drift... then if I manually added in corresponding diff command lines
> > (to make it look more like a .patch file generated by `diff -Nu`), ie:
> > 
> >   diff -Nu src.orig/fs/proc/array.c src/fs/proc/array.c     <---
> >   --- src.orig/fs/proc/array.c
> >   +++ src/fs/proc/array.c
> > 
> > Suddenly `git apply --recount` is happy with the patch.
> > 
> > So I suspect that I started with git not liking the hunks generated by
> > combinediff and drove it to the rebase feature, which solves a more
> > interesting problem, but by side effect smoothed over this format
> > issue when it recreated the patch with git.
> > 
> > Anyway, I think this patch still stands on it's own: perform the same
> > apply/revert check as what would happen in the fixup steps to fail
> > faster for the user?
> 
> If we just run fix_patches() at the beginning then can we just get rid
> of validate_patches() altogether?

Or at least validate_patches() could be replaced with
check_unsupported_patches(), as the apply/revert test wouldn't be needed
since the actual apply/revert would happen immediately after that in
fix_patches().

-- 
Josh

