Return-Path: <live-patching+bounces-371-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB3091A740
	for <lists+live-patching@lfdr.de>; Thu, 27 Jun 2024 15:02:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC6E3281EDC
	for <lists+live-patching@lfdr.de>; Thu, 27 Jun 2024 13:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F3F16191E;
	Thu, 27 Jun 2024 13:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F1wX0EfF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BUkFSU/T";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F1wX0EfF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BUkFSU/T"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC1D24B5B
	for <live-patching@vger.kernel.org>; Thu, 27 Jun 2024 13:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493347; cv=none; b=eoL2BwG0HKjxkZ47QajnMfGVSIXe6l1Z1ypeFJCF5pyZBejjg4++6d4+Vr58i/EtycT6UZwNHfLSIyAqf9WpxVH3wXGtvZmJxlUELdcZUv++LKXgV43xPN7Dhr9KyYKv5anoM2Ft7PHTtQ1BmSQZSWQk+hZP8Hg2H0UxBGpTkUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493347; c=relaxed/simple;
	bh=8CpFV/Uoga1R3DvQHH5/37LtNehlou38zVAI8Y0OdAM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=r7EFPEBcJpRQ62RvdPzeQ8EWNMmV5JJft6VTH20hZLsoS/LYCbJbR6/u4aJcJhVUsboAo6OK8i4YQCx/SmVSqtu/0uMb5p4UxJZcTZzMdf6oMeBmvyB3GSnWBoJ41PxPWHIrWy08pppz+woFvL6VXghRurhy4Ttz8G1EhxHK0N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F1wX0EfF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BUkFSU/T; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F1wX0EfF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BUkFSU/T; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1A07521B92;
	Thu, 27 Jun 2024 13:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719493344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ewtD9B6YeQ56yde6ypTPT0plYWmftccyGuW+SS7TNcM=;
	b=F1wX0EfFhp4hbAjElFei/pIZz5ESUogXZ1ApQqAbIWc4V6AYV9VadVTtKFASruCOVZ+D01
	4Ky8e2NYwgGbrhhEXw530runvEpRph2uiR71CcSCmZU/d+V8g/uBt84h5+fMa0RXBpJGnE
	byn4o3GVslDpYtqtPHJg0lmpN8T2YNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719493344;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ewtD9B6YeQ56yde6ypTPT0plYWmftccyGuW+SS7TNcM=;
	b=BUkFSU/TSzZJ42gFl51QEzUU1MgVc/lfUn/HN5m7pAOHGQs7C3b9uOi7rgjKFw3XJjUsJ3
	3bDnU3/AHFJc9MAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1719493344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ewtD9B6YeQ56yde6ypTPT0plYWmftccyGuW+SS7TNcM=;
	b=F1wX0EfFhp4hbAjElFei/pIZz5ESUogXZ1ApQqAbIWc4V6AYV9VadVTtKFASruCOVZ+D01
	4Ky8e2NYwgGbrhhEXw530runvEpRph2uiR71CcSCmZU/d+V8g/uBt84h5+fMa0RXBpJGnE
	byn4o3GVslDpYtqtPHJg0lmpN8T2YNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1719493344;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ewtD9B6YeQ56yde6ypTPT0plYWmftccyGuW+SS7TNcM=;
	b=BUkFSU/TSzZJ42gFl51QEzUU1MgVc/lfUn/HN5m7pAOHGQs7C3b9uOi7rgjKFw3XJjUsJ3
	3bDnU3/AHFJc9MAA==
Date: Thu, 27 Jun 2024 15:02:24 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Yafang Shao <laoar.shao@gmail.com>
cc: Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, 
    jpoimboe@kernel.org, jikos@kernel.org, joe.lawrence@redhat.com, 
    live-patching@vger.kernel.org
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
In-Reply-To: <CALOAHbALyUdQqvjEiZ+2=3HaAyY94UL5ZTLT0ZzNPJH-vv=3GQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2406271459050.4654@pobox.suse.cz>
References: <20240610013237.92646-1-laoar.shao@gmail.com> <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com> <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com> <ZnUsYf1-Ue59Fjru@pathway.suse.cz>
 <CALOAHbByr3UMy=xzP82LA=D3rW-uw+s3XfzHQMVYxu4RomAANg@mail.gmail.com> <ZnVQJEoXpaONuTNE@pathway.suse.cz> <CALOAHbALyUdQqvjEiZ+2=3HaAyY94UL5ZTLT0ZzNPJH-vv=3GQ@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Hi,

> > > Additionally, in our production environment, we need to ensure that
> > > there are no non atomic replace livepatches in use. For instance, some
> > > system administrators might still build livepatches outside of our CI
> > > system. Detecting whether a single livepatch is atomic replace or not
> > > is not easy. To simplify this, we propose adding a new sysfs attribute
> > > to facilitate this check.
> > >
> > > BTW, perhaps we could introduce a new sysctl setting to forcefully
> > > forbid all non atomic replace livepatches?
> >
> > I like it. This looks like the most reliable solution. Would it
> > solve your problem.
> >
> > Alternative solution would be to forbid installing non-replace
> > livepatches when there is already installed a livepatch with
> > the atomic replace. I could imagine that we enforce this for
> > everyone (without sysctl knob). Would this work for you?
> 
> Perhaps we can add this sysctl knob as follows?
> 
> kernel.livepatch.forbid_non_atomic_replace:
>     0 - Allow non atomic replace livepatch. (Default behavior)
>     1 - Completely forbid non atomic replace livepatch.
>     2 - Forbid non atomic replace livepatch only if there is already
> an atomic replace livepatch running.

I would be more comfortable if such policies were implemented in the 
userspace. It would allow for more flexibility when it comes to different 
use cases. The kernel may provide necessary information (sysfs attributes, 
modinfo flag) for that of course.

Miroslav

