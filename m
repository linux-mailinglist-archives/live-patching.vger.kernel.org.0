Return-Path: <live-patching+bounces-1108-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B817EA27322
	for <lists+live-patching@lfdr.de>; Tue,  4 Feb 2025 14:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38DA83A79A0
	for <lists+live-patching@lfdr.de>; Tue,  4 Feb 2025 13:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FCF218EA0;
	Tue,  4 Feb 2025 13:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="djLIrm1/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303B5218AD3
	for <live-patching@vger.kernel.org>; Tue,  4 Feb 2025 13:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738675319; cv=none; b=ZY4MuLDEO79TTOA0d5MixhR4tDqkRmKc3Qfa1TcYD+NSWSXiPqi0SWMBY4XuBlAreGKuEzSPaTrrAeRWx7f/ocEzxlJEJLdnCbzSsf13xu0P1jLV+xRlvn7YNrLLc+kurhGFcg8PpTb+w2lq1K7cFjn+x+thsC3dgJ+4W+ybo04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738675319; c=relaxed/simple;
	bh=IF1zXuefYm5EPoZt4v+gsQ9Z3bt9qz4rG91VgAFndqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCTPyEVatdKWI06YkN3vkipAgGJLfqC+giFi7SmtxPSP4krGdRGFMm830Svsn4rhSYD/XNZ5XeDk+WXAnHbMv5NUR8/JPwVo1PyfbAlIM+filfB+TuikjnuCGty7h+atH/90nykpZjwbCsA0OU+Um+pQIzxGV0LMubG4bM5E5p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=djLIrm1/; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5dcc38c7c6bso1463299a12.1
        for <live-patching@vger.kernel.org>; Tue, 04 Feb 2025 05:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1738675315; x=1739280115; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=19dcwyLK6HxBt3Sl1K7BYugVtKLA9XCCs/I2A977sT8=;
        b=djLIrm1/FQJS1ZQjK5e8+u/deqFLZcAE/ssEVSgRo5Y60LXlnjMIz2sOQvzdS0E7+y
         st0qDQhPFetgwdODpkFLCnGOZzSPI4yW4+u77NyUF68C7wSwPafzVGLjVLrbBrv0IuTQ
         DwTXr8Nb6w/wSrpda2WYMpW+VmgqKBEphrCIIs+E31wRwgc/nSSPISsv9uK+rdLwDGyf
         cWW+TkrQhbNybQcgKnRVZOqZDi5HzybP2tTFmDHvy2we34WfQNR1/KgtTwOacTqiG475
         4fPqQiOef8BG9FGI+prmgroIUcn2Id2iVZMEoUGghzZ0sUdDiWHDG20FKl+AXIduu83z
         /4dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738675315; x=1739280115;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=19dcwyLK6HxBt3Sl1K7BYugVtKLA9XCCs/I2A977sT8=;
        b=cLoigxALKkDRRXWBtKIL2imB5GkN8JO6KM5rxBV+btppkQ8+rDzZWTUljVqEgpyp/A
         9grGq/wTLm0yyRXODqI5zd0FviDB5+O9jn/KK1UoVqz6O9Nq+1GS3AQO/N9ZH6OYRsiU
         ddk7X8fmolnqSFIWhMdnjAGIKLT6bpXUlpxGa552rg9rusC6CbiD3v/yjdl0wsGARcHE
         SSK9evijVCNCdlU3Xbb73YGUG6rK/CQ3OhcAVjRwQRAkkbzgAybtsxik9AVVMxgAZy7/
         aKsNGJ0MoFV5MQfSL8kiGmu/IuWKkes8XAUkBzg4EjfB5wX7az4hjfzTjcAFK/+6Ucuj
         7Jzw==
X-Forwarded-Encrypted: i=1; AJvYcCW918/js+m95NPhYaSz3Jvg4c2fuEcqrimzs2M57icBOqB8d6EQBYuoTbfKsMbD7r/VI2HHqkvCu0UIWLdd@vger.kernel.org
X-Gm-Message-State: AOJu0YxUWEBodT6nzqYmIrYy8Y2b0CelTHaNuA9eKWErfMA84MAQCWcC
	4qSkfMr252zfpDDVpbiJumpnqtHqVH8khkZQeTikwEXp2LzUfxJbPhTvHLDSpR0=
X-Gm-Gg: ASbGncsqHK7CHU1/Y7lFzIoaBs9CNAHl79NlH/kOcQNFzBVD2v4/eHiyaQ3OpQYt9HL
	bZ6mFoQ3inSn5ZwOTHJ7WU8JFrLfijZQNN0KtKVyiapTzHJxruIV+HGZJMRmW5e68Oh5mDzZVag
	MSu8swcaW4YyCCo9h2rIYfeH0T6pt3VgwpbSy55juPcpa/2/eUpqgudwXM1kHYK9YrWyv8xGkk2
	u1hxK35ZINKL0e0dApT2zgyjppMgJyjO6diMCy1jUbtzRrOnoa/Xxa6aHa9VD3HPk2I5/A7qpAJ
	gf/31hPzvhuJ0y71yA==
X-Google-Smtp-Source: AGHT+IHo5NL/NiI3D81PFENm/glWsRlkC2C4A2oLyjusvgNEHIC8iCR7HCIqqnOROVR9nt6c7d2hQA==
X-Received: by 2002:a17:907:6096:b0:ab6:d79f:abe6 with SMTP id a640c23a62f3a-ab6d79faf7amr2766102566b.15.1738675315328;
        Tue, 04 Feb 2025 05:21:55 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab703fbcc0csm698691366b.53.2025.02.04.05.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 05:21:55 -0800 (PST)
Date: Tue, 4 Feb 2025 14:21:53 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
Message-ID: <Z6IUcbeCSAzlZEGP@pathway.suse.cz>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
 <20250127063526.76687-3-laoar.shao@gmail.com>
 <Z5eYzcF5JLR4o5Yl@pathway.suse.cz>
 <CALOAHbANtpY+ee9Wd+HV6-uPOw+Kq1JcU5UdOXjz8m_UJ_-XRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbANtpY+ee9Wd+HV6-uPOw+Kq1JcU5UdOXjz8m_UJ_-XRA@mail.gmail.com>

On Mon 2025-01-27 23:34:50, Yafang Shao wrote:
> On Mon, Jan 27, 2025 at 10:31 PM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Mon 2025-01-27 14:35:26, Yafang Shao wrote:
> > > The atomic replace livepatch mechanism was introduced to handle scenarios
> > > where we want to unload a specific livepatch without unloading others.
> > > However, its current implementation has significant shortcomings, making
> > > it less than ideal in practice. Below are the key downsides:
> >
> > [...]
> >
> > > In the hybrid mode:
> > >
> > > - Specific livepatches can be marked as "non-replaceable" to ensure they
> > >   remain active and unaffected during replacements.
> > >
> > > - Other livepatches can be marked as "replaceable," allowing targeted
> > >   replacements of only those patches.
> > >
> > > This selective approach would reduce unnecessary transitions, lower the
> > > risk of temporary patch loss, and mitigate performance issues during
> > > livepatch replacement.
> > >
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -658,6 +658,8 @@ static int klp_add_nops(struct klp_patch *patch)
> > >               klp_for_each_object(old_patch, old_obj) {
> > >                       int err;
> > >
> > > +                     if (!old_patch->replaceable)
> > > +                             continue;
> >
> > This is one example where things might get very complicated.
> 
> Why does this example even exist in the first place?
> If hybrid mode is enabled, this scenario could have been avoided entirely.

How exactly this scenario could be avoided, please?

In the real life, livepatches are used to fix many bugs.
And every bug is fixed by livepatching several functions.

Fix1 livepatches: funcA
Fix2 livepatches: funcA, funcB
Fix3 livepatches: funcB

How would you handle this with the hybrid model?

Which fix will be handled by livepatches installed in parallel?
Which fix will be handled by atomic replace?
How would you keep it consistent?

How would it work when there are hundreds of fixes and thousands
of livepatched functions?

Where exactly is the advantage of the hybrid model?

> >
> > The same function might be livepatched by more livepatches, see
> > ops->func_stack. For example, let's have funcA and three livepatches:
> > a
> >   + lp1:
> >         .replace = false,
> >         .non-replace = true,
> >         .func = {
> >                         .old_name = "funcA",
> >                         .new_func = lp1_funcA,
> >                 }, { }
> >
> >   + lp2:
> >         .replace = false,
> >         .non-replace = false,
> >         .func = {
> >                         .old_name = "funcA",
> >                         .new_func = lp2_funcA,
> >                 },{
> >                         .old_name = "funcB",
> >                         .new_func = lp2_funcB,
> >                 }, { }
> >
> >
> >   + lp3:
> >         .replace = true,
> >         .non-replace = false,
> >         .func = {
> >                         .old_name = "funcB",
> >                         .new_func = lp3_funcB,
> >                 }, { }
> >
> >
> > Now, apply lp1:
> >
> >       + funcA() gets redirected to lp1_funcA()
> >
> > Then, apply lp2
> >
> >       + funcA() gets redirected to lp2_funcA()
> >
> > Finally, apply lp3:
> >
> >       + The proposed code would add "nop()" for
> >         funcA() because it exists in lp2 and does not exist in lp3.
> >
> >       + funcA() will get redirected to the original code
> >         because of the nop() during transition
> >
> >       + nop() will get removed in klp_complete_transition() and
> >         funcA() will get suddenly redirected to lp1_funcA()
> >         because it will still be on ops->func_stack even
> >         after the "nop" and lp2_funcA() gets removed.
> >
> >            => The entire system will start using another funcA
> >               implementation at some random time
> >
> >            => this would violate the consistency model
> >
> >
> > The proper solution might be tricky:
> >
> > 1. We would need to detect this situation and do _not_ add
> >    the "nop" for lp3 and funcA().
> >
> > 2. We would need a more complicate code for handling the task states.
> >
> >    klp_update_patch_state() sets task->patch_state using
> >    the global "klp_target_state". But in the above example,
> >    when enabling lp3:
> >
> >     + funcA would need to get transitioned _backward_:
> >          KLP_TRANSITION_PATCHED -> KLP_TRANSITION_UNPATCHED
> >       , so that it goes on ops->func_stack:
> >          lp2_funcA -> lp1->funcA
> >
> >    while:
> >
> >     + funcA would need to get transitioned forward:
> >          KLP_TRANSITION_UNPATCHED -> KLP_TRANSITION_PATCHED
> >       , so that it goes on ops->func_stack:
> >          lp2_funcB -> lp3->funcB
> >
> >
> > => the hybrid mode would complicate the life for both livepatch
> >    creators/maintainers and kernel code developers/maintainers.
> >
> 
> I don’t believe they should be held responsible for poor
> configurations. These settings could have been avoided from the start.
> There are countless tunable knobs in the system—should we try to
> accommodate every possible combination? No, that’s not how systems are
> designed to operate. Instead, we should identify and follow best
> practices to ensure optimal functionality.

I am sorry but I do not understand the above paragraph at all.

Livepatches modify functions.
How is it related to system configuration or tunable knobs?
What best practices are you talking, please?

Best Regards,
Petr

