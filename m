Return-Path: <live-patching+bounces-374-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AF991B9AC
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2024 10:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6585A1C22DDA
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2024 08:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F384D14532C;
	Fri, 28 Jun 2024 08:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mLWdPqf4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4JEz6nj8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mLWdPqf4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4JEz6nj8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3484F14262C
	for <live-patching@vger.kernel.org>; Fri, 28 Jun 2024 08:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719562831; cv=none; b=DGnXMS8+ItDgk7/2NEfdCHkIlHvT4RrMutCRNRzq1zjrC5U/LX54JpQetdYtIB//Y75QMLxLsQ2H5gm8zeTdcZnGuHJLG3FleanAeFgRD7zajM+upoyUqnr/pypC0X2sIxhbEUfR6Q+6lh2CYAizLa1RuZ9gGA/okQzVP9JRpbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719562831; c=relaxed/simple;
	bh=u0Yes6UU8n8GPjYcKdoUVlRWpPVS4VhvjRgJgJ/iyqQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tXc/NsdTSa9jjvdpeEBpLvdhxGfKM3mBSqwwKhOpmBNY1mzuwqDrbJqQyZOMNBJBgE+cK0MoT6XWUWSmSQckLQhtBzJc+D5ia7Awf7C8oc279Gxxs9vS0vyfoQcGoeJMh2uWO8ooTk2aEHzTtc2H3uygh9RHOzsEwBjr+YQuybQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mLWdPqf4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4JEz6nj8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mLWdPqf4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4JEz6nj8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E76B21BBA;
	Fri, 28 Jun 2024 08:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719562828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kjRH3jpy5BYx50KsT2oeC+Wt+tsCFvWwdXl+3nWoOA=;
	b=mLWdPqf4QV2OaRiI+7vbrrzvuk8gF2Jyl3+zK2U8vLGam+z4lWoZDzHaTylLO7y6tOX2OW
	YqAaocjqV0eBKp86U0VPsZJot7Nf5sE+KVATapVqNgtGTAF+9gaggm9yXbkUNbLTmAeY+G
	c4IUsYHIPsBvpxbgaPgvRMjnzuGw90o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719562828;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kjRH3jpy5BYx50KsT2oeC+Wt+tsCFvWwdXl+3nWoOA=;
	b=4JEz6nj87ZZokhrROouydUzp23q0UUkIHAIAZxIqq+meyCCpht6SB3kDr20b0RM6lNN3if
	hgJr5kYGmwhQo7Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719562828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kjRH3jpy5BYx50KsT2oeC+Wt+tsCFvWwdXl+3nWoOA=;
	b=mLWdPqf4QV2OaRiI+7vbrrzvuk8gF2Jyl3+zK2U8vLGam+z4lWoZDzHaTylLO7y6tOX2OW
	YqAaocjqV0eBKp86U0VPsZJot7Nf5sE+KVATapVqNgtGTAF+9gaggm9yXbkUNbLTmAeY+G
	c4IUsYHIPsBvpxbgaPgvRMjnzuGw90o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719562828;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kjRH3jpy5BYx50KsT2oeC+Wt+tsCFvWwdXl+3nWoOA=;
	b=4JEz6nj87ZZokhrROouydUzp23q0UUkIHAIAZxIqq+meyCCpht6SB3kDr20b0RM6lNN3if
	hgJr5kYGmwhQo7Cw==
Date: Fri, 28 Jun 2024 10:20:28 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Yafang Shao <laoar.shao@gmail.com>
cc: Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, 
    jpoimboe@kernel.org, jikos@kernel.org, joe.lawrence@redhat.com, 
    live-patching@vger.kernel.org
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
In-Reply-To: <CALOAHbDJRGD9XBORx2OSN=KRc=aACPLXn1TG3KsYE+M3U261sw@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2406281016070.15826@pobox.suse.cz>
References: <20240610013237.92646-1-laoar.shao@gmail.com> <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com> <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com> <ZnUsYf1-Ue59Fjru@pathway.suse.cz>
 <CALOAHbByr3UMy=xzP82LA=D3rW-uw+s3XfzHQMVYxu4RomAANg@mail.gmail.com> <ZnVQJEoXpaONuTNE@pathway.suse.cz> <CALOAHbALyUdQqvjEiZ+2=3HaAyY94UL5ZTLT0ZzNPJH-vv=3GQ@mail.gmail.com> <alpine.LSU.2.21.2406271459050.4654@pobox.suse.cz>
 <CALOAHbDJRGD9XBORx2OSN=KRc=aACPLXn1TG3KsYE+M3U261sw@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-1884355524-1719562828=:15826"
X-Spam-Score: -1.54
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.54 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	CTYPE_MIXED_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-0.75)[-0.748];
	NEURAL_HAM_SHORT(-0.19)[-0.962];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-1884355524-1719562828=:15826
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 27 Jun 2024, Yafang Shao wrote:

> On Thu, Jun 27, 2024 at 9:02 PM Miroslav Benes <mbenes@suse.cz> wrote:
> >
> > Hi,
> >
> > > > > Additionally, in our production environment, we need to ensure that
> > > > > there are no non atomic replace livepatches in use. For instance, some
> > > > > system administrators might still build livepatches outside of our CI
> > > > > system. Detecting whether a single livepatch is atomic replace or not
> > > > > is not easy. To simplify this, we propose adding a new sysfs attribute
> > > > > to facilitate this check.
> > > > >
> > > > > BTW, perhaps we could introduce a new sysctl setting to forcefully
> > > > > forbid all non atomic replace livepatches?
> > > >
> > > > I like it. This looks like the most reliable solution. Would it
> > > > solve your problem.
> > > >
> > > > Alternative solution would be to forbid installing non-replace
> > > > livepatches when there is already installed a livepatch with
> > > > the atomic replace. I could imagine that we enforce this for
> > > > everyone (without sysctl knob). Would this work for you?
> > >
> > > Perhaps we can add this sysctl knob as follows?
> > >
> > > kernel.livepatch.forbid_non_atomic_replace:
> > >     0 - Allow non atomic replace livepatch. (Default behavior)
> > >     1 - Completely forbid non atomic replace livepatch.
> > >     2 - Forbid non atomic replace livepatch only if there is already
> > > an atomic replace livepatch running.
> >
> > I would be more comfortable if such policies were implemented in the
> > userspace. It would allow for more flexibility when it comes to different
> > use cases. The kernel may provide necessary information (sysfs attributes,
> > modinfo flag) for that of course.
> 
> The sysfs attributes serve as a valuable tool for monitoring and
> identifying system occurrences, but they are unable to preempt
> unexpected behaviors such as the occurrence of mixed atomic replace
> livepatch and non atomic replace livepatch.

True, but when you have sysfs attributes and eventually modinfo, you can 
easily write a wrapper around modprobe which would implement any policy 
that you need. For example, you would see which live patches are 
installed, which live patches you want to install and decide based on that 
what to do. You can bail out, install only a subset...

You can also integrate the wrapper to your "DevOps" system or so.

> If the flexibility of the sysctl knob is limited, then perhaps we
> could explore utilizing BPF LSM or fmod_ret as an alternative
> implementation? We would simply define the necessary interfaces within
> the kernel, and users would have the capability to define their own
> policies through bpf programs.

It sounds like a big hammer to me. If something like this happens, it 
might be better to implement it on the module loader level.

Anyway, others may feel differently about it.

Miroslav
--1678380546-1884355524-1719562828=:15826--

