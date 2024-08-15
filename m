Return-Path: <live-patching+bounces-494-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB31952C87
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 12:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4C0FB29B16
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 10:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959F71D27A4;
	Thu, 15 Aug 2024 10:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eqcTj8du"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FAA1B4C44
	for <live-patching@vger.kernel.org>; Thu, 15 Aug 2024 10:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723716532; cv=none; b=KmDa0B1Rf6SdOlcgdBDRoE1ostsfZIH5at8tRLmnGtyGEGLqgTx4ACIQYobvduhOMdpCwZt8AWYUc1n/QOqzP3kvxwZGHyslorV5b1vWOziiuvj5xblx3XCBAQVFqEo9JQyhsgT3bOWBjp/AHnw4jIfDKdrV4x4aF119ImCK7k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723716532; c=relaxed/simple;
	bh=uTR97BbbQAWT+CeVZ0HO/QNDuU4jV4Y8/ioO9O/7x9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8VhydV/XtAK3QKwgdVDwo2Euc1a9PiqCKSZTxMtWJgsFFRUa6BFhmz31I+HGcxtgFcs3Vw6WwVZnQMyoP8YHJ7rl+0Drz2NHvxECdeH76CWmFMrvQmHetm99HDdqI0bByVDQnI4ivHlbwpWi9T3L1M4cEXg55YeKm6CziVfz54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eqcTj8du; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a7a94aa5080so94490666b.3
        for <live-patching@vger.kernel.org>; Thu, 15 Aug 2024 03:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723716528; x=1724321328; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fCLAa07FCy9T95j3A3Rtzd3uQ1vEFK007f3m2CuwX40=;
        b=eqcTj8dugIXp+Dh0ytfz6ivqpzTOssbmHuJ/cxbH8J3bQVroGlKoFatrrFGDm9gj4G
         V/N7s8khHIBVr90bE65/ZNmGdeF/wGwto8LgYWwCM4uAzsFXd6oxBEYimiv+oxLTRvIT
         4ir7Fhdl4Dq2xzQTIcKz7oOXuDVWDThAiR2J2bFPXVa4tm2JmG1pCCRFswyKc5YkM/6/
         oU21r7N0mllv937p9NbHf/Y4GGgmv3h1YCxxT2SvjpyNExROx+/LD1i9OKcV0xolKQn8
         0K05EZsjPA/R6tq33zpSykQOB9kRsDwFwLTjANCLZs3b1z0anxv0KCV7aw5iOXeEgEIo
         V2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723716528; x=1724321328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fCLAa07FCy9T95j3A3Rtzd3uQ1vEFK007f3m2CuwX40=;
        b=n+bTIhza+VqAOC3cfywa7bD3uPl6Rl82do047zT51/RWm5lAspw0MfiUtkUNh3/4z6
         IdiwuneWYFa0Ab0wdmtsDWli1CS8Jy5hB5VAa0FhtA8C/N0VgvMes7fCrsWdU2Hbp5hY
         X6IEg0eqAMEzRWxcvE6+EetK/3A8aHcTcpDwBPc8kv/UN33M+pvlBC9WJXmsd01eqBu0
         3hRo+gYLHIVRubqNrt694d46Bn6m0RXg8lp7YGjhwHzZ2j1XVtJFDZoqXnyScYBRnWy4
         MTuf0zDsXRSOhRrSvyWRvqpxrGFYRqIA0BHKdRBPVubhDpoyJh2BsBilc/SRPQeHAif6
         Sn2A==
X-Forwarded-Encrypted: i=1; AJvYcCVtQ23UURD1NbLRqveiknYVjynPy+WvFbLe+nG57zemwkTp1Kjp2mYkGct6yVKjtn8BbhQ/UAKrko7wz0LAW/y7YGIkWIMbLxy7t2pkZw==
X-Gm-Message-State: AOJu0YzPgM3QoWJQkUWbka92bnnkypaIcNC7uxQCrd6pAmqTd1nG1q9P
	b0qOZBbcr/BfldbzrNjWD8CNvXIuYS4KB3o+WgP1mFJi2/5YAOGzE75TGvy1iNo=
X-Google-Smtp-Source: AGHT+IEKQhQSqk73fX1nCH2OpoKfj2vRtk8iu7pihED4MbQNfL8ogsNZuSZH55WrUW7ceRlAcYseyA==
X-Received: by 2002:a17:907:e661:b0:a77:bfca:da53 with SMTP id a640c23a62f3a-a8366d5a3aemr390489566b.30.1723716528516;
        Thu, 15 Aug 2024 03:08:48 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838d023dsm77814866b.64.2024.08.15.03.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 03:08:48 -0700 (PDT)
Date: Thu, 15 Aug 2024 12:08:46 +0200
From: Petr Mladek <pmladek@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [POC 0/7] livepatch: Make livepatch states, callbacks, and
 shadow variables work together
Message-ID: <Zr3TrqIWrEvuj2-b@pathway.suse.cz>
References: <20231110170428.6664-1-pmladek@suse.com>
 <20231110213317.g4wz3j3flj7u2qg2@treble>
 <alpine.LSU.2.21.2407251618220.21729@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2407251618220.21729@pobox.suse.cz>

On Thu 2024-07-25 16:19:30, Miroslav Benes wrote:
> On Fri, 10 Nov 2023, Josh Poimboeuf wrote:
> 
> > On Fri, Nov 10, 2023 at 06:04:21PM +0100, Petr Mladek wrote:
> > > This POC is a material for the discussion "Simplify Livepatch Callbacks,
> > > Shadow Variables, and States handling" at LPC 2013, see
> > > https://lpc.events/event/17/contributions/1541/
> > > 
> > > It obsoletes the patchset adding the garbage collection of shadow
> > > variables. This new solution is based on ideas from Nicolai Stange.
> > > And it should also be in sync with Josh's ideas mentioned into
> > > the thread about the garbage collection, see
> > > https://lore.kernel.org/r/20230204235910.4j4ame5ntqogqi7m@treble
> > 
> > Nice!  I like how it brings the "features" together and makes them easy
> > to use.  This looks like a vast improvement.
> > 
> > Was there a reason to change the naming?  I'm thinking
> > 
> >   setup / enable / disable / release
> > 
> > is less precise than
> > 
> >   pre_patch / post_patch / pre_unpatch / post_unpatch.

I wanted to point out that the callbacks are called _only_ when
the states are added or removed. They are not called when the state
is preserved during the atomic replace.

The pre_patch... naming scheme might create an assumption that they
are _always_ called during the livepatch transition.

But I see that the new names might be misleading in other ways.

I am going to use the "pre_patch..." names in the next version of
the patchset.


> > Also, I'm thinking "replaced" instead of "obsolete" would be more
> > consistent with the existing terminology.
> > 
> > For example, in __klp_enable_patch():
> > 
> > 	ret = klp_setup_states(patch);
> > 	if (ret)
> > 		goto err;
> > 
> > 	if (patch->replace)
> > 		klp_disable_obsolete_states(patch);
> > 
> > it's not immediately clear why "disable obsolete" would be the "replace"
> > counterpart to "setup".
> > 
> > Similarly, in klp_complete_transition():
> > 
> > 	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
> > 		klp_unpatch_replaced_patches(klp_transition_patch);
> > 		klp_discard_nops(klp_transition_patch);
> > 		klp_release_obsolete_states(klp_transition_patch);
> > 	}
> > 
> > it's a little jarring to have "unpatch replaced" followed by "release
> > obsolete".

I see.

> I agree. I would also stick to the existing naming. It is clearer to me.

Fair enough.

Best Regards,
Petr

