Return-Path: <live-patching+bounces-1953-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMLdH1w/fWmoRAIAu9opvQ
	(envelope-from <live-patching+bounces-1953-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 00:31:40 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEEF7BF60E
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 00:31:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61A11303661D
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 23:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77C42D248D;
	Fri, 30 Jan 2026 23:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rf7nID7b"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5063211A09
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 23:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769815862; cv=none; b=GjnYbJ06RlvNEVrYlGEwuiOWfD+dELI/OtEyxBUp28e3TYAgcL8rTVNvHbi2W9t5T9yv0P+GTnCbamXXbiMq85Pr1qbmd1YmSeGgmPd3HoF1OT7/lOJab3ceVOhb+t0Qm4C8tjeLIHfEsVCgkKjfzmR1Ksx0pk7k1ybC1iyb9tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769815862; c=relaxed/simple;
	bh=vALVnJxqO8CX5ZF0XXtDLs9IN20udKHMdInbx5/vnQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyuVwGyy7WP83oGXV9E7dxjZZUFzABdYR2IPM6clQqst7/nZRJ9v9r4TysB6JTcCUBe+eIw6/g//mFT3ywHNHZBBMWAttEsqxBCR6/DkDFEUArDGVDl+I2BqGuiCf2cGWNNOHkgai5AEbOmnujPQcp1kQueV/uWck22ILvfnKxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rf7nID7b; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8603C4CEF7;
	Fri, 30 Jan 2026 23:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769815862;
	bh=vALVnJxqO8CX5ZF0XXtDLs9IN20udKHMdInbx5/vnQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rf7nID7b32M/rM3z9pIBKbNWQIEMW+NXct9D+QO2LfzJ0DXi1Qg1GhXep5c3Y7aBw
	 gaQb0qX761UuZLM66tFMsem5VCHD9Pcu5Vt2t46eXkO4Asb33AA4qqxFAAmoGsG+eO
	 Dw8TrI95R5sl9DKidPMTu4Fro6YIQPrfcSE1ObduCilbIikUr5wVAuq+HdGVJ/7LqO
	 W51u7FZ+GTWS1Gs5LR1ZueDUtLe5YM6N9k10FRCC1jrAPPbAiss7b46mrC0EiKG6tS
	 FHL2VJ8k+TwmaUZM85KitQVgZO8e+JhVFB5jLVnpO5wey4UOxmwQ6S6UmNNXX0vTYi
	 fsIBCL6WheMWw==
Date: Fri, 30 Jan 2026 15:31:00 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
Message-ID: <zapd3snm5ijxfmry3ja4hiczoiviwfrijggvldjorrd7zcfd72@3c5ztpwk7gvw>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-5-joe.lawrence@redhat.com>
 <fayrtgx5l5wvcwkuxqc4it3t4ft3o7rbn4uojtmzjxq66nniw7@v6om4zyepshh>
 <aX0Xe8ERVjPeu24j@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aX0Xe8ERVjPeu24j@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1953-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EEEF7BF60E
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 03:41:31PM -0500, Joe Lawrence wrote:
> On Fri, Jan 30, 2026 at 12:09:35PM -0800, Josh Poimboeuf wrote:
> > On Fri, Jan 30, 2026 at 12:59:49PM -0500, Joe Lawrence wrote:
> > > @@ -131,6 +133,7 @@ Advanced Options:
> > >  				   3|diff	Diff objects
> > >  				   4|kmod	Build patch module
> > >     -T, --keep-tmp		Preserve tmp dir on exit
> > > +   -z, --fuzz[=NUM]		Rebase patches using fuzzy matching [default: 2]
> > 
> > Ideally I think klp-build should accept a patch level fuzz of 2 by
> > default.  If we just made that the default then maybe we don't need this
> > option?
> > 
> 
> Do you mean to drop the optional level value, or to just perform level-2
> fuzz rebasing as a matter of course (so no -z option altogether)?

Sorry, I was a bit confused by the previous patch.  I was thinking "git
apply" already has a default fuzz level of 2, and that --recount made it
stricter somehow.  But now I see that the "git apply" default is *no*
fuzz, as opposed to GNU patch which defaults to fuzz 2.

For kpatch-build we used GNU patch, should we just change klp-build to
use that as well?  It worked well for 10+ years and the defaults were
fine.  We could maybe use patchutils to fix up the line numbers/counts.

Then we presumably wouldn't need the --fuzz option as there would be
sane defaults already.  I think some fuzz is acceptable, especially
since patch shows a warning message when it happens.

-- 
Josh

