Return-Path: <live-patching+bounces-2886-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHgrHJZ4FWrHVAcAu9opvQ
	(envelope-from <live-patching+bounces-2886-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 12:40:22 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B81835D449A
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 12:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E9FF300148E
	for <lists+live-patching@lfdr.de>; Tue, 26 May 2026 10:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35813D75C0;
	Tue, 26 May 2026 10:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bXxnmaZv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467573D9DDB
	for <live-patching@vger.kernel.org>; Tue, 26 May 2026 10:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779791737; cv=none; b=i1bFWeKU5LBV7SWyy7D7qxEoYN9UP/WuCbv6G1PPBbaza7sJuGbj7EivG1oCoA30bLZtDTUxJP+/oH6iuMAYK7zGN0tjTn2v8VNVf3/rG0YgLaAsT9zautjwZh7k3rZQbZo9T/GzRPTIKJ7sI1LOZxOIo9vRhARYJIFjaaWJUeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779791737; c=relaxed/simple;
	bh=omVCGqTjJYWKHINfp6Rl/opx4JL6HqR2mmeOfMomXr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSs507kgAor/jlD1ez75ImcBC56hL7lrR/3WGlDfaOeRv/VA+/VcxUoFH4LJP7HvVDdb1H9+pMgJCd04JqibFHQj7u1puv8VJCxR1+eTg3zyIwbJpWQfDYr4FYtB8E8lmh3gt+191uN7RfzZ4mA8Q1feWE9nfV8pKzdqvaogxkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bXxnmaZv; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso88542875e9.0
        for <live-patching@vger.kernel.org>; Tue, 26 May 2026 03:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779791734; x=1780396534; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I2ZjtYCpvIl7x3VSdPyRJueYa6xBhoHYIaIGseCAUfc=;
        b=bXxnmaZvNQAWwTpr/b1ZL8htk9eUJ/Z9dyzv7XGFMTItFdUyKvbdCIm/Fiyo3SFPhN
         e+8RKbiCD8ZTrkLSzK0SQxzHAaC7wqBdYvP3JOfSswXNEDUbVwvOG/Kmt8BKDbpky0WN
         5bEIqhxOaW/KHdnOP599OGD2yAdUiiinz90zyfdf/BcIQb2PBG9tApx/rxNwwy33Hqri
         d7kMNQ7nC90nrIyriwgumsxFPgdgLxaSQN22mOO9A5jVOmfZl82YKDMtQCHE4RI/COVd
         qZgTY35L4nJNIEtDfFT0DBMYOd7xZNFNa45Zkf277V9qssLJNVnoyRIkxmdBww6lKtdz
         oRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779791734; x=1780396534;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2ZjtYCpvIl7x3VSdPyRJueYa6xBhoHYIaIGseCAUfc=;
        b=LhbrUsxl+xNBb8h0MJbw9RkF+zCU5kjnIlKPHQ8hexo6vC+mcHtAtqNmT3x6446okx
         TxkHvCtq5+LIbRqkQuKC95AX9HOiFrXvfxev483fSyrxoG4PQaSS1vrQvprVhErfQ//f
         7Kt34/gYHSK6ZJ4UizD9SrvsIxZ02JyYWQwKNcMIJCe0sFkh23ThlOApd7lsRpigHYC/
         PlX5o+tA5jAQbGefV0T/Ko1/0pxeRHcjcI+twpycMzSI1vevO3Uk+dJMQ9IZwoXnECV5
         bYpKlSoGPy5esj0IWvy+Bemk37r6RKZ1VBwnDuyHOebCg0gLeWUzJpuoxQz4vsIYXcXr
         BAZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9wsUVBVNbXaxRn74hsXPtcbW8CU8DfXfCZNOpl59EuLEDE5z8dCi/h5mCrKDPpLJ3FJS/ph7Y6Im8Z4Goz@vger.kernel.org
X-Gm-Message-State: AOJu0YzOY1zQblIKQRLTY2UCV9ACuMuy8/XhtzASw45NCijvbRTLS635
	+KUN3GOjQHYbp9lQ2HmFqUY/R//PygDSuTf0hMjHE+fjiO3PBICRAY5RUOWOZQfb9fU=
X-Gm-Gg: Acq92OEhFrQkeTefH8noD6ryiJ4y53xSR/mOSHE5XubX8+QFqAcmloQMkDvVC0Wh82v
	E19xMMyfX9AVu+ceP68umDru2dQ6yk530QMqYU0YamTGuRyLdge/JrxHcPuur2BnR9PNzlTIj6p
	O25Vg9LjRxO8lI4zqO7BY7bwC95WaBSh93iaufB8BIbBmTYRcJfCs/5gCcKDMYk/guELLJnIQoU
	vPxwfmUw3NTkUmGgDXzvlb7lshsWwsYGq70TQFDf3t6IdzesZxb+OvKU+zXx7f0yRgYtVM9J3mO
	so2Mij5fQKa0WGgmlM/baIuVqF4F3MCZAPsV8KYYTZzlIcxMzVliNpxsS4UUNU+DKQJ8MDHtcwi
	6/9Dypefj/+jdHW8N0x3mbXDN6tSOgIdgx1/iAPtfMtOlJbY7u1o+lbgbHC9gigIQPWH9ULbh5R
	kRxtUM5ORNvkwgbLD1rh6C1ph3lA==
X-Received: by 2002:a05:600c:5298:b0:48f:e230:1d12 with SMTP id 5b1f17b1804b1-490428dd63emr315243305e9.31.1779791734358;
        Tue, 26 May 2026 03:35:34 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49041781fc4sm153287245e9.1.2026.05.26.03.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 03:35:34 -0700 (PDT)
Date: Tue, 26 May 2026 12:35:32 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <song@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
	live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] livepatch: Support scoped atomic replace using
 replace set
Message-ID: <ahV3dBovdQZoF__j@pathway.suse.cz>
References: <20260513143321.26185-1-laoar.shao@gmail.com>
 <20260513143321.26185-2-laoar.shao@gmail.com>
 <CAPhsuW6Aa8Tu5aWGVYzRVVNEnJiHrNzsa4aKXoOEa_gwhp3XfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6Aa8Tu5aWGVYzRVVNEnJiHrNzsa4aKXoOEa_gwhp3XfQ@mail.gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,suse.cz,redhat.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2886-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: B81835D449A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon 2026-05-18 14:25:04, Song Liu wrote:
> On Wed, May 13, 2026 at 7:34 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > Convert the replace attribute from a boolean to a u32 to function as a
> > "replace set." A newly loaded livepatch will now atomically replace
> > existing patches that belong to the same set.
> >
> > This change currently supports function replacement only; support for
> > state and shadow variables will be introduced in subsequent patches.
> >
> > Suggested-by: Song Liu <song@kernel.org>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  .../livepatch/cumulative-patches.rst          | 17 ++++++++------
> >  Documentation/livepatch/livepatch.rst         | 23 +++++++++++--------
> >  include/linux/livepatch.h                     |  5 ++--
> >  kernel/livepatch/core.c                       | 16 ++++++++-----
> >  kernel/livepatch/state.c                      | 17 +++++++-------
> >  kernel/livepatch/transition.c                 | 10 ++++----
> >  scripts/livepatch/init.c                      |  7 +-----
> >  scripts/livepatch/klp-build                   | 14 +++++------
> >  8 files changed, 59 insertions(+), 50 deletions(-)
> >
> > diff --git a/Documentation/livepatch/cumulative-patches.rst b/Documentation/livepatch/cumulative-patches.rst
> > index 1931f318976a..6ef49748110e 100644
> > --- a/Documentation/livepatch/cumulative-patches.rst
> > +++ b/Documentation/livepatch/cumulative-patches.rst
> > @@ -17,18 +17,20 @@ from all older livepatches and completely replace them in one transition.
> >  Usage
> >  -----
> >
> > -The atomic replace can be enabled by setting "replace" flag in struct klp_patch,
> > -for example::
> > +The "replace_set" attribute in ``struct klp_patch`` acts as a **replace set**,
> > +defining the scope of the replacement. By default, the replace set is 1.
> > +
> > +For example::
> >
> >         static struct klp_patch patch = {
> >                 .mod = THIS_MODULE,
> >                 .objs = objs,
> > -               .replace = true,
> > +               .replace_set = 1,
> >         };
> 
> I wonder whether we should have "replace_set = 0" means no replace.
> This will simplify the transition for users of the existing replace=false
> option. I would like to hear other folks' thoughts on this.

I would find this confusing. Also it would complicate the code.

I always considered the "replace" and "no replace" mode as two
separate worlds:

    + people using many "no replace" livepatches
    + people always using atomic replace

But the code had to handle also the world where:

    + people might combine "no replace" and "replace all" livepatches

which looked like a clash of the two worlds. And different people might
have different expectations about the behavior.

The "replace_set" allows to remove this clash. It looks like a win-win.
And it makes the change acceptable for me.

Best Regards,
Petr

