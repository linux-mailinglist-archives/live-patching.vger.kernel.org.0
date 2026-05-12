Return-Path: <live-patching+bounces-2741-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wF1LMtuXAmomuwEAu9opvQ
	(envelope-from <live-patching+bounces-2741-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 05:00:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1415191E3
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 05:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C58B530086A0
	for <lists+live-patching@lfdr.de>; Tue, 12 May 2026 03:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC60D3603D8;
	Tue, 12 May 2026 03:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NuLXGOJj"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E87537F014
	for <live-patching@vger.kernel.org>; Tue, 12 May 2026 03:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778554835; cv=pass; b=LLzqo4iJ8b3aX89S6EIkK6uV2ZjdXX+REA4kDeNz9R0MQ3adMFQegiXwLrdoVOPIHvjOCZcYZbhwORXQidt64FcB8htPpNvkzx9HWRb1YGl2jcUh20gFNDBKX+ZrcNf1uS7nStwAG4KqhX7r0DdM48qHr5oxHB9cccWbC0EkQ0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778554835; c=relaxed/simple;
	bh=1FTY/dxK9AVZbEnCfou+I39CttYNwGA/jupYG+sqlos=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rzpNgl8uK0+tkzBSnVMMJ8U6tU5LeZFjxurzYizVHno15GCIOnUJu/7NOk9o1j2ldCfkONDFLv/qcgL9bcuY4NHk6rmT3ircLLbVZRBfzAOv77m00Bkmj4mn1RC6FpoDYKdMiM6pN4x27UnFimhRBxmOhUuAOygNjkZn7Ppywh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NuLXGOJj; arc=pass smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-95d0476492eso1537137241.3
        for <live-patching@vger.kernel.org>; Mon, 11 May 2026 20:00:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778554833; cv=none;
        d=google.com; s=arc-20240605;
        b=azlCN6N0JuQwLFlABS/S/o9IZNxhFlNfOLjVjmxdNqA1OzOb62n6RU1ZELrhuhzWR/
         JBQRSTVCNTYV8A5nagveWIuIoxMtWwL34Ncg1utut1nw3GDM2k/KIOtBMWyoS2p7/nwN
         9NoFfz8qHyS1Y4USF2AIia9XmPu1UDFpempakdufFw9DNU9UYYeyOc//dLL3Wf1Pu553
         Y1OstNXSj7qoKuPiEbf6SXfLRQY975OCwuvQICu89Rv6ID01bI3yMiSI/SZFgt1OLK6c
         Dp1FSqIGKPyAtTA1xHgehNzoTQh6vKTNVy7cN+F2Htym/gu4/dFDOzofP0SWBG7SLAB9
         e1XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YGBgDfJ4AfqTknCN9alQ+NTutahc0Gme/TPQUtzberI=;
        fh=SacAn1r2o6oE0GZjkpclgqwzclgpdHby3aci8abqogQ=;
        b=WQknFBH48SUtuo7L6/c/4W650irT1T414IWyxDwQ+/vKew7BkJU/0NnOI9pkPh/0Wc
         OKirPSrESJMng8U8aIY86e8WaPNuZ1Y+teyBy+uU95eAthl4uCHoCQrhNAOKmNCZS3Vp
         BuZn/AnVqIscM8uYBMR4zd7mO1/4h5JXmlTTyN9thQOGUDNPNvXCEuslI3xj9Xlyxwkq
         4IMypJA9nkSraCI9TW5eeRP0srFJDFJhlKcr5QxTbSREgEW+/9qv6YW65qOd0xJbTklB
         Y9m0shn1DKEpiN8K2e1dj5svd+VcPbVUwoO38IWi4jpvDwNefeFU8bB2layTxdyESyZN
         j4Hg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778554833; x=1779159633; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGBgDfJ4AfqTknCN9alQ+NTutahc0Gme/TPQUtzberI=;
        b=NuLXGOJjLOM5R00p4gUpFXn029OWdn2sTNKQwlPPgPXo1nH5Km3Fmwn85jxOJKanWZ
         8JWua+F4SiAi0QG1iJ9a6ABdlbuPbnmdwAQnLqoo2PhgZ76iPjilzX57LLx2YRe3sz5z
         q/LwMwWYk46gCdKLBlWWSpbVNsGtbLQJYYgkuQLgpEx/aZMltmNDov1zhLEGsqfsCh+Z
         CVYp0wR0eG90xNr7PdbauLsqi3MCeK40avs8/rqN9Fd5rECtkpL/2Y9P7S2PgMCTYBp+
         AHeJBF+L2KBx9lpRMBZYIRpoU7fncjTAgeXbkw7bYpDcAA7LtRjiPCFe5Jw9iY2jXkee
         RnkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778554833; x=1779159633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YGBgDfJ4AfqTknCN9alQ+NTutahc0Gme/TPQUtzberI=;
        b=I4+7m1XIVu4Heua5Lrnx5qTJbT0DJeEns+U63nEoikMEaFdfjh4zFrM8YHSDRATcAL
         tg7QDWmXEbIb5Gu8GPzMwgKUt21P952a4KVhG/WdCxjR/BWVcDzjE+QlZy1RhTBl1Q67
         VAGjycw8gYDNBuCI7JPbwRr+nlmXPLJ/CX0xtLo5g83VPiDSfc9lPT31uf5BQytMJowP
         kSGKckxOtjjkUd1jF30tyIFNT6jjCsGueZMlqD2V8A+Bb5AQxd/YnKEPZmdNTIOHbg4c
         y3MNILMqOMqeueQ6p9AizCsyZZLdPJRAMnKg9a4vgUake6YKziBtOJVbDOhuJZhDCN1S
         0VfQ==
X-Forwarded-Encrypted: i=1; AFNElJ+xlvZMYlGnE3R6egHRbTfcLdrzu1I6+3Xg0eLS3OfrMsquOgJpZi2ac1m9qktjHBg3qfuKaidvW4MLt7yb@vger.kernel.org
X-Gm-Message-State: AOJu0Yxs+GAxtuHQxqj96c2db0e3TMLR8X0SoQdz67ppZANaKlIbAVZz
	6w5gmD3RaNZfIDQYMteORqVtQJ+xPdeLjELa2xz7obxC7PtyEYgnx4ahU4F9PQ7/76PiWM+VrwC
	QzAlGQpsSkUToRx5bQtEBIkFbPCIuCAy+9afvbjv9
X-Gm-Gg: Acq92OGSUXCo6hnWufnrzd4wnQmh60R/rb8QZynXcDmrPEwRTxBTjYR88K3I60QSjtj
	hctBgmZdGQGhm72QjB+F315Tq3/660L9dDzJTggG7y3sZIYhatNGxPrOu0HMT6CTU9/ZTtm5TTB
	YRPy4ZdtMsWi3VwNYr7kPSSq6a3mLtBJoDIyN8NXr0q5bwODkRLU8L7J1ZQ1Ir6uN/HdqGUG/5t
	PdYtSEOX9z62TkHgUVvLVe370OiNNnTNMRkmXtJFPkzbVTsBcqClMfgjHxJOKPY5NgNEnpOh+UK
	V0wIH/0ctSH3mqDknQ==
X-Received: by 2002:a05:6102:4499:b0:632:3bb5:95f1 with SMTP id
 ada2fe7eead31-6323bb5cd8cmr4171542137.27.1778554832592; Mon, 11 May 2026
 20:00:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-9-dylanbhatch@google.com> <afTYzAF_x41pyilu@J2N7QTR9R3>
In-Reply-To: <afTYzAF_x41pyilu@J2N7QTR9R3>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Mon, 11 May 2026 20:00:21 -0700
X-Gm-Features: AVHnY4KILl4VsgMlK7qBJOos5aRlukhM-ZbxId7NyZjs6rIXnB83q0XCoxXRTm0
Message-ID: <CADBMgpx9YxNUO6wLP7mYKxWW8L78Hk9gPwHrMjXUwPyUmGEu9w@mail.gmail.com>
Subject: Re: [PATCH v5 8/8] unwind: arm64: Use sframe to unwind interrupt frames
To: Mark Rutland <mark.rutland@arm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AC1415191E3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2741-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Hi Mark,

Thanks for all the feedback and help on this. I'm planning on getting
your comments addressed in the coming days, but I have some initial
clarifying questions.

On Fri, May 1, 2026 at 9:46=E2=80=AFAM Mark Rutland <mark.rutland@arm.com> =
wrote:
>
> Hi Dylan,
>
> Thanks for putting this together. I think this is looking pretty good.
> However, there are some things that aren't quite right and need some
> work, which I've commented on below.
>
> More generally, there are a few things that aren't addressed by this
> series that we will also need to address. Importantly:
>
> (1) For correctness, we'll need to address a latent issue with unwinding
>     across an fgraph return trampoline, where the return address is
>     transiently unrecoverable.
>
>     Before this series, that doesn't matter for livepatching because the
>     livepatching code isn't called synchronously within the fgraph
>     handler, and unwinds which cross an exception boundary are marked as
>     unreliable.
>
>     After this series, that does matter as we can unwind across an
>     exception boundary, and might happen to interrupt that transient
>     window.
>
>     I think we can solve that with some restructuring of that code,
>     restoring the original address *before* removing that from the
>     fgraph return stack, and ensuring that the unwinder can find it.

If my understanding is correct, the issue arrises in return_to_handler
as the return address is recovered:

mov x0, sp
bl ftrace_return_to_handler // addr =3D ftrace_return_to_hander(fregs);
mov x30, x0 // restore the original return address

Because ftrace_return_to_handler pops the return address from the
return stack before it can be restored into the LR, it cannot be
recovered.

Based on this, I believe you are suggesting to restructure this code
path such that the return address is removed from the return stack
only after it has been restored to LR. But since kernel/trace/fgraph.c
is core kernel code, will this end up requiring either (1) a similar
restructuring of other arches supporting ftrace, or (2) an
arm64-specific implementation of this recovery logic?

It looks to me like there is essentially the same recovery pattern on
other arches; is there a reason this transient unrecoverability isn't
an issue for reliable unwind on other platforms?

>
>     I'm not immediately sure whether kretprobes has a similar issue.
>
> (2) To make unwinding generally possible, we'll need to annotate some
>     assembly functions as unwindable. We'll need to do that for string
>     routines under lib/, and probably some crypto code, but we don't
>     need to do that for most code in head.S, entry.S, etc.
>
>     The vast majority of relevant assembly functions are leaf functions
>     (where the return address is never moved out of the LR), so we can
>     probably get away with a simple annotation for those that avoids the
>     need for open-coded CFI directives everywhere.

Are you suggesting something like a SYM_LEAF_FUNC_(START|END), that
wraps CFI directives for leaf functions?

>
> I've pushed some reliable stacktrace tests to:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git stacktrace=
/tests
>
> That finds the fgraph issue (regardless of this series). When merged
> with this series triggers a warning in kunwind_next_frame_record_meta(),
> where unwind_next_frame_sframe() calls that erroneously as a fallback.

Thanks for the pointer on these tests, they're super useful! I've been
able to reproduce the fgraph failure you mentioned.

Thanks,
Dylan

