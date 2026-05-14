Return-Path: <live-patching+bounces-2810-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFnCJrBxBWoTXAIAu9opvQ
	(envelope-from <live-patching+bounces-2810-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 08:54:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EE12C53E91E
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 08:54:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DCB693032CE3
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 06:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 242A13AC0C3;
	Thu, 14 May 2026 06:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NUvXZzla";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="16hymOgp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bl65tCx5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="80P4AnBr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC29374E41
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 06:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778741562; cv=none; b=iBxkCDLFqEegNEV8qn5OmPkCWuzo3s2r3tO9vddcjNG1aFqVu3VvJedwzw0aecJ3Kx5ZefMOJhMtFpcRrrivEAGgoBqbtAi582fzgYn03Xt0S97m3G8UKQld0YssrVtzTMmiKMDq5lgeMo9P+0cKvLLXIpi7o/AYh/6PrA/Qe+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778741562; c=relaxed/simple;
	bh=glKlBc0ZgBi5H8hcFtVlAXofmlY13G9Ny2cQ3HC8RPM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fDIbdChMBVhQ2XVZSbiIwDQrWdO98yo/MHxReuzBCYvJ18dIOKV8VgCxU+flooJsITIXflfENfQeCzGtw64U5K2d9Yw2mlz9lYl/OD9CaX2k+jQb42GX+rtxVrWdWdXhK+ZG45s7Z+t+MeZxyN45MPrpgOS5YQSRND6+2phwcIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NUvXZzla; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=16hymOgp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bl65tCx5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=80P4AnBr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F27695DE4F;
	Thu, 14 May 2026 06:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778741559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mtPkGLWG1cJUL/rygDHvprRtzxhrIhQjq/0wqQ2/Jqo=;
	b=NUvXZzlaK9dMZ8iewt9bfAchIC/adAMNW2ASb8n3tEy2V7lFXVOpnbFeUymDL/rTbjrWPM
	fm20qDEAcbZ8iGVElC6O+rjRNeheO79AR6KiyRn+0qm+z1nZ7aSpHmxGeIiI5VJoOAAsMR
	jE2/kD522kXI6OrGtzOoUS95Z4xCiFI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778741559;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mtPkGLWG1cJUL/rygDHvprRtzxhrIhQjq/0wqQ2/Jqo=;
	b=16hymOgpWhg+WQ+UAyVwwaIA0GWVtDwoABc2UTwEC8mducqMOMXxz+mKN27ky02t4yuDe3
	SwdrDq6WHJxZX+DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778741558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mtPkGLWG1cJUL/rygDHvprRtzxhrIhQjq/0wqQ2/Jqo=;
	b=bl65tCx5vA/MncCMn018wGYz24iEnkXXjbaXZK+y/Qr1Fh7A1ldqjjck8jEm6G+WBkyj7S
	lswMGIp883+uaHQC21QxT+TN+xC/YglJGiaETgt2KG2ANXhqAofIKbpLQyO0NIwyMCMNm9
	85Vt8QqCR3+J3PHxEkYPRmyHIn9S/24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778741558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mtPkGLWG1cJUL/rygDHvprRtzxhrIhQjq/0wqQ2/Jqo=;
	b=80P4AnBr8lekb4du+yy/8dsSxA7RxM24i6xvaFlot04eBogA9NTPH5kkgqNcEQIANukBmI
	KynLyQ7U3cB/toDg==
Date: Thu, 14 May 2026 08:52:38 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
cc: Song Liu <song@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
    live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>
Subject: Re: Sashiko patch review for live-patching?
In-Reply-To: <ju3k5mp22u37l4m27xygqce2sh2nczwckvmk3exkldk5365csx@q53zbumzj33t>
Message-ID: <alpine.LSU.2.21.2605140852001.19192@pobox.suse.cz>
References: <agSjM8dxgnV9QQaf@redhat.com> <CAPhsuW6CgBtEGAK+E0n7+tnLAWNPTEuvnAo0vtQsbMVBb6htFw@mail.gmail.com> <ju3k5mp22u37l4m27xygqce2sh2nczwckvmk3exkldk5365csx@q53zbumzj33t>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-2146828000-792648378-1778741558=:19192"
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 
X-Rspamd-Queue-Id: EE12C53E91E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUBJECT_ENDS_QUESTION(1.00)[];
	CTYPE_MIXED_BOGUS(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	MIME_TRACE(0.00)[0:+,1:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2810-lists,live-patching=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,sashiko.dev:url,pobox.suse.cz:mid]
X-Rspamd-Action: no action

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---2146828000-792648378-1778741558=:19192
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 13 May 2026, Josh Poimboeuf wrote:

> On Wed, May 13, 2026 at 10:17:51AM -0700, Song Liu wrote:
> > Hi Joe,
> > 
> > On Wed, May 13, 2026 at 9:13 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > >
> > > Hello live-patching maintainers,
> > >
> > > I've noticed several references to the Sashiko (https://sashiko.dev/)
> > > kernel review bot on this list and was wondering if there is interest in
> > > adding live-patching to the mailing lists Sashiko tracks.
> > 
> > I think it is a great idea. AFAICT, these bots add a lot of values in the
> > code reviews.
> 
> +1
> 
> > > Integration appears straightforward: we can submit an MR to add our
> > > entry to sashiko-k8s.yaml and customize the bot's email behavior in
> > > email_policy.toml.
> > >
> > > Full Sashiko Maintainer documentation is available here:
> > > https://github.com/sashiko-dev/sashiko/blob/main/MAINTAINERS_GUIDE.md
> > >
> > > Personally, I would vote to set reply_to_author.  I don't have a strong
> > > opinion on the other custom options, provided that the CC list is opt-in
> > > rather than simply mirrored from the MAINTAINERS::LIVE PATCHING file.
> > > Either way, I've found the Sashiko web interface very helpful in patch
> > > review.
> > 
> > Given the relatively low volume of patches to the livepatch mail list, I
> > think we can use reply_all. But if folks prefer reply_to_author instead,
> > we sure can use the cc list.
> 
> I would vote reply_all.  The signal/noise ratio isn't perfect, but it's
> high enough to be useful in many cases.  That way the
> maintainers/reviewers are aware of any potential issues, and it avoids
> duplicating review work and fragmenting conversations.

+1

Miroslav
---2146828000-792648378-1778741558=:19192--

