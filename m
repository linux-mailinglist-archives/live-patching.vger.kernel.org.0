Return-Path: <live-patching+bounces-2365-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBpUK6nk4GlhnAAAu9opvQ
	(envelope-from <live-patching+bounces-2365-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 15:31:21 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB8040EDA3
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 15:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7E2A300E38D
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 13:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 558243803C4;
	Thu, 16 Apr 2026 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="j0bZ8nFH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LxNn6Biv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="j0bZ8nFH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LxNn6Biv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F327637F8AF
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345859; cv=none; b=cPz26CO7ezscA1EwwcfAYFLlshB6BzMOpPTOUnGwkR4QOc+ele2MuJ1TBPYZBhQ9RuRvLwMTvhY8rfvJhNLdwba+P3lygHtaxwphmtpoGLBNsmHjZCY/XDQx2GYLewkSY8NGEzWtwo5ZH5h06BvF7KP6Ovj5B1VApQ51xHpIxFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345859; c=relaxed/simple;
	bh=LSQ309ZyhRYApe/OUUxt4UG9UndSDX1k4N06FDImwRc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jVF8y6R5Xv8t6L7tQ9fVqD9FmRNQziQlV/kjJAQDQM/ZV4rrB7ok70QZpAvokhkWg6yEeEOHam71PHU1EvPGOWPu1c+apWe5611SW+likQinJAziQ/9OJg62HlGMArVTEj2FIYssssHS4Rz/1nLeC7K+5CMDN7f+SWlrDyEZ4Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=j0bZ8nFH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LxNn6Biv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=j0bZ8nFH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LxNn6Biv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B24B6A7EC;
	Thu, 16 Apr 2026 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776345856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dn0YSAI8OUP/RSoT1dekWzWWqb33qqX1G9UyUae0VrE=;
	b=j0bZ8nFH3/Uy0ILmeHh32hFb2hXB/84NAMuXundgYuc1B0otTTZVGULF/90ruNdtNl3Gnp
	/h4V7sYH4/2is7kS2dfh0WMvYSIRxHvZHBsXMg0E03MDwawjWrTBb1+QMHYT+GO/ND5W8F
	G7Xc03UzWrpmrmTpOvxmefAhnvhWJbw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776345856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dn0YSAI8OUP/RSoT1dekWzWWqb33qqX1G9UyUae0VrE=;
	b=LxNn6BivO31HGQVA+rRZhfHp85/b2YlXv3rG6pan5zmfKcVyp21qMlxV2ILnTQ8xlZADNo
	LrUMLWbBc761xjDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776345856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dn0YSAI8OUP/RSoT1dekWzWWqb33qqX1G9UyUae0VrE=;
	b=j0bZ8nFH3/Uy0ILmeHh32hFb2hXB/84NAMuXundgYuc1B0otTTZVGULF/90ruNdtNl3Gnp
	/h4V7sYH4/2is7kS2dfh0WMvYSIRxHvZHBsXMg0E03MDwawjWrTBb1+QMHYT+GO/ND5W8F
	G7Xc03UzWrpmrmTpOvxmefAhnvhWJbw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776345856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dn0YSAI8OUP/RSoT1dekWzWWqb33qqX1G9UyUae0VrE=;
	b=LxNn6BivO31HGQVA+rRZhfHp85/b2YlXv3rG6pan5zmfKcVyp21qMlxV2ILnTQ8xlZADNo
	LrUMLWbBc761xjDw==
Date: Thu, 16 Apr 2026 15:24:16 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
    Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] kselftests: livepatch: Adapt tests to be executed
 on 4.12 kernels
In-Reply-To: <847de72350a1fe8bd765f2e5493b13e8bf7b2966.camel@suse.com>
Message-ID: <alpine.LSU.2.21.2604161524010.10044@pobox.suse.cz>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>  <alpine.LSU.2.21.2604151357350.1967@pobox.suse.cz> <847de72350a1fe8bd765f2e5493b13e8bf7b2966.camel@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2365-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:dkim,suse.com:email,pobox.suse.cz:mid]
X-Rspamd-Queue-Id: 0FB8040EDA3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 15 Apr 2026, Marcos Paulo de Souza wrote:

> On Wed, 2026-04-15 at 14:01 +0200, Miroslav Benes wrote:
> > On Mon, 13 Apr 2026, Marcos Paulo de Souza wrote:
> > 
> > > A new version of the patchset, with fewer patches now. Please take
> > > a look!
> > > 
> > > Original cover-letter:
> > > These patches don't really change how the patches are run, just
> > > skip
> > > some tests on kernels that don't support a feature (like kprobe and
> > > livepatched living together) or when a livepatch sysfs attribute is
> > > missing.
> > > 
> > > The last patch slightly adjusts check_result function to skip dmesg
> > > messages on SLE kernels when a livepatch is removed.
> > > 
> > > These patches are based on printk/for-next branch.
> > > 
> > > Please review! Thanks!
> > > 
> > > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > 
> > Besides my comment for 1/6 and what Sashiko discovered, it looks good
> > to 
> > me.
> > 
> > However, please also take a look at brand new 
> > test_modules/test_klp_mod_target.c. It does not build on old kernels
> > since 
> > they lack proc_create_single(). I think it should be covered in this
> > patch 
> > set too.
> 
> I saw that yesterday as well, but I wanted to merge this series first.
> I have plans to create a way to unregister the livepatches if something
> fails, so we can continue to run the other tests. I was planning to fix
> the test_klp_mod_target.c in the same patchset.

Fair enough.

Miroslav

