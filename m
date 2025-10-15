Return-Path: <live-patching+bounces-1752-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA99BDE582
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 13:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEAB3189A2EA
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 11:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C46324B11;
	Wed, 15 Oct 2025 11:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HmbiQwxx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9FF322A24
	for <live-patching@vger.kernel.org>; Wed, 15 Oct 2025 11:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760529207; cv=none; b=XW9mBWnIy9exXlh7Z8unoMOvFwSZLWx+9poanuaIUePaNxwX4DLZ+NF2WR3JnLBD3L8Ytawz7pPVRSm/tyhOaHNKZTDM5MirGYLuQI9JWUxAxC0ExDY8KxZK2SNg0NNbFTdR/aV58X+fyH66OQ0UJwRujG2FUvSrIafPltFX73w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760529207; c=relaxed/simple;
	bh=vyQlz+x4VKemUng/LZKh8fmxEPEH6ABEEK4HphUX/go=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbW5OszjzmUYM4uClKPiAXAkcwmYtQy0U/v2EfaW7pCXqx67aKvAHLGM1GhYjeL6oJ6GNBk8J3rV9hIr1rNybUFSwxagMh9NKAaeZA3Zd/UHoivw0Dxs9RJcHoP6RnmdXO7HgACPSfauS5dyOQ5I9m0MiEZvlozCMf6srYeC0Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HmbiQwxx; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e42fa08e4so52536865e9.3
        for <live-patching@vger.kernel.org>; Wed, 15 Oct 2025 04:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760529203; x=1761134003; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HlSDbzOXXwNPPr7hEmuYHQp36lIJ8BB8J23GCAg13K4=;
        b=HmbiQwxxTWtRNLYOpYL0l7BsLN9nJR4RHFmAE7epeuZzFBbAkvanhwKgG2TiPH+jW9
         WtUShJCoPzTyiYYNsrhuwpi0uYNOEDQIewrn9BryM/K/21V6Ohnw6zWrW2lt7Y0r/Ql7
         HuMTncXrqWuipMBEcFWinIFzdNkTvmnx4MAPvAwUKKJej5REkkymZsuulnIj/jFR3bff
         +t2mpggT3RtDtBnfi1LWA2E69EtYzYe87P+vHSCpyonllCO/MvyoamPyvdgTihOE2CM4
         AYsN18V9D9rD/tyP9XFk+AbeDamfMXrDPGsy+eNAKFXIDy0MRAUUymN5vfRFlbCERht7
         FwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760529203; x=1761134003;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HlSDbzOXXwNPPr7hEmuYHQp36lIJ8BB8J23GCAg13K4=;
        b=Ivs1MlnIRAcjJH0aHwH67S6zG9VKC4n3ofsw7xAr7uRhKrAlHbCQLN52SNfNo1qg5z
         eKxOJ1YXxEKnwkMJSAypYfn9/e0aleSTvxfnBf2ShLDdDDMkSjg4V5HHCkrNsOwGp+jF
         5ne9a73YpY0I3/tkNgkKiDG85wBWy5F8Ow1DzOz6L8PvvtO/oLW/OxNEZkuEOFT08LGG
         Jp3it9EWlOI2kp43ql71FYKtz/3etJ6Z+bIMQd/f/FPgT6LyxFX7igMPwCrJPu2KDrDt
         gElK2BKkIw7t8LGOh+jZnT7aOQlfln4qxAEDf5QEJoED8jo3EBiqUi+2Wt5QVhRMmg2b
         k6NQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEaLwjXabPHynqLfsrlGWt5zbsjOg+tOF+Fu2oP9qAPLOPCrIws0xPqOhcQt6VQHpo0vDJPv54Sl9SqGMC@vger.kernel.org
X-Gm-Message-State: AOJu0YyxwUYUz/8QfrfVO6X1PjG/9cu1BlXihQWfIUzLOCWH2Ka+UXzn
	OW1/5mdQyZT1f1Tb6K5z+/wGi87KiHRbyUv1d8v2AQjCYZAqYCCQ4e/4DuLXX6iYBANweI5o+eb
	ADO5a
X-Gm-Gg: ASbGncttiTZD1TkXZVE4WiwnaP9PGPlKzDbZih2cZ+dbGXmZjVlH37L6PsajV/tmQJY
	M66GKG6uSK4kC7UBTAwkRPgfJ1SuVGLtuiZP2iXgjumLt3CAb2SxFoU3IeC3k3ZBpFFJlqp1BAj
	H5nJE6VaVRbLXtVpyJoefXuvk+nkOam6GDwkJPI5OPq2u2aVE8sRt1g0LKAjISj5TvKmtXqxEOT
	lKsmSQAhbovbtVTBELQb/bvFFOhDR+tVlxZFYzj5wRvDZlA3HQvaMb0VbQiQrNhBQCxbxssQe0A
	xCX1zdsA+xVkoXcYpQbQY1aYE5Sp1Xbhg0R3sLTy0Y707bp604SNVobhhR02ooRaYNz3ofbln3v
	615PG8bzJ1cKJ5rM9iw9xddT6DAMvPq2pBcw/G2ryZJphdqz2JyKwO54=
X-Google-Smtp-Source: AGHT+IG7J54y/yCRUwFYlCbMKLqhxWTx9pd8IvnSx79C24wTiao6kvd/Y8/5RlPXV4BDxf1i/p8dfw==
X-Received: by 2002:a05:600c:6304:b0:46f:b42e:e38c with SMTP id 5b1f17b1804b1-46fb42ee457mr136612015e9.39.1760529203319;
        Wed, 15 Oct 2025 04:53:23 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fc1c5227fsm246940325e9.9.2025.10.15.04.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 04:53:22 -0700 (PDT)
Date: Wed, 15 Oct 2025 13:53:21 +0200
From: Petr Mladek <pmladek@suse.com>
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: Question - Livepatch/Kprobe Coexistence on Ftrace-enabled
 Functions (Ubuntu kernel based on Linux  stable 5.15.30)
Message-ID: <aO-LMaY-os44cEJP@pathway.suse.cz>
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5058315a39d4615b333e485893345be@crowdstrike.com>

On Tue 2025-10-14 21:37:49, Andrey Grodzovsky wrote:
> Dear Upstream Livepatch  team and Ubuntu Kernel team - I included you both in this since the issue lies on the boundary between Ubuntu kernel and upstream. 
> 
> According to official kernel documentation  - https://docs.kernel.org/livepatch/livepatch.html#livepatch, section 7, Limitations - 
> 1 - Kretprobes using the ftrace framework conflict with the patched functions.
> 2 - Kprobes in the original function are ignored when the code is redirected to the new implementation.
> 
> Yet, when testing on my Ubuntu 5.15.0-1005.7-aws (based on 5.15.30 stable kernel) machine, I have no problem applying Livepatch and then setting krpobes and kretprobes on a patched function using bpftrace (or directly by coding a BPF program with kprobe/kretprobe attachment)and can confirm both execute without issues. Also the opposite works fine, running my krpobe and kretprobe hooks doesn't prevent from livepatch to be applied successfully. 
> 
> fentry/fexit probes do fail in in both directions - but this is expected according to my understanding as coexistence of livepatching and ftrace based BPF hooks are mutually exclusive until 6.0 based kernels 
> 
> libbpf: prog 'begin_new_exec_fentry': failed to attach: Device or resource busy
> libbpf: prog 'begin_new_exec_fentry': failed to auto-attach: -16
> 
> 
> Please help me understand this contradiction about kprobes - is this because the KPROBES are FTRACE based  or any other reason ?

Heh, it seems that we have discussed this 10 years ago and I already
forgot most details.

Yes, the conflict is detected when KPROBES are using FTRACE
infrastructure. But it happens only when the KPROBE needs to redirect
the function call, namely when it needs to modify IP address which will be used
when all attached ftrace callbacks are proceed.

It is related to the FTRACE_OPS_FL_IPMODIFY flag.

More details can be found in the discussion at
https://lore.kernel.org/all/20141121102516.11844.27829.stgit@localhost.localdomain/T/#re746846b6b16c49a55c89b4c63b7995fe5972111

I seems that I made some analyze when it worked and it did not work,
see https://lore.kernel.org/all/20141121102516.11844.27829.stgit@localhost.localdomain/T/#mffd8c8bf4325b473d89876f2805f42f1af7c82d7
But I am not 100% sure that it was correct. Also it was before the
BPF-boom.

Also you might look at the selftest in the todays Linus' tree:

  + tools/testing/selftests/livepatch/test-kprobe.sh
  + tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c
  + tools/testing/selftests/livepatch/test_modules/test_klp_livepatch.c

The parallel load fails when the Kprobe is using a post_handler.

Sigh, we should fix the livepatch documentation. The kretprobes
obviously work. register_kretprobe() even explicitely sets:

	rp->kp.post_handler = NULL;

It seems that .post_handler is called after all ftrace handlers.
And it sets IP after the NOPs, see kprobe_ftrace_handler().
I am not sure about the use case.

Best Regards,
Petr

