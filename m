Return-Path: <live-patching+bounces-2294-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sIYuBMeR02mrjAcAu9opvQ
	(envelope-from <live-patching+bounces-2294-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 12:58:15 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB623A2F28
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 12:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 43A713011042
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 10:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3196732F742;
	Mon,  6 Apr 2026 10:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PICvgEH3"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7DD32ED3A
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 10:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473090; cv=pass; b=Ro+EEl9vhUgL9J5pckGouwpI37j7blXxgLWYVf+TFYEIyY6IueEO9DfShRNd9fMIzc7gE1JCkfM9PRZiofGb+7knDZ3bZT5/XPXc/Khz5r0eF8YC6ho8OjB+jtwW43ZZYGpE8mkGmDlTD+gvJbDcv4ZyoeOIVUs78vwN/Fmb2TU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473090; c=relaxed/simple;
	bh=KeMAFzLFrGIxkUSWTmdTJO0MCX9FTfYruj6uWs8QBjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lv8347tyd3JtlDPWEioAect4k/ejcEDoRlKqOYp170UqKDEAdc64eLD9elpm0VBAIqSYn0ZCm/X6irWprRoWDrImpIPyhbQgEevotMiBGO9D1uoxm5e0bUSU0Ddslh33doOH9Bi03b2fypN9Kt4a0wREe0YSXDUYtdcNxRud86M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PICvgEH3; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-65032e9cf01so3454835d50.3
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 03:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775473088; cv=none;
        d=google.com; s=arc-20240605;
        b=GNKpe40npAtaNmp1m/hj5l5vw8BCXwkBwnUdkajLQc6oy/b0g4rfMoL0CMnbGyhWqz
         O58ck2ix2eCcM/iVM51P16s2RzOC2/GFvc5qe0/S1gE2UH/MHGvWbw2wEOj2HJvgyegZ
         rd802efzDVPruSuB2UOUKxQG0n8sYOWBeZQZSWJfzdRnaoYNeeeTx1MFgnihE+DyESZe
         MAyHod48KUab8T6miN45sJXzEje3ENzJNjV/Qfz9lTlyfFgODZj64FnB+y62GOQz40Rv
         U6CdedypqTVqv65QVm6MfNyBtUrTxxpTZkXxeeR8eyg3JdgMfZfsSCxnPnbzKbs9hIsI
         C08Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=23p+wdS60pXtBpNvZkSzHr5OzahO/ZfsvZCv+StoNBA=;
        fh=/mZtw7Le3iFao7FTRl2H0uYbU4qpqX9LaD6tFdhKOKU=;
        b=LdSSdHRnvtETVqKmw2jblnIwmcvMh8iaosEPV/B26cwO9tp0DgKlQyi/Y4kmNROhta
         hKTcTFh/Atok4R6IzQJWer2O5fAjfkjYkZsysnKVqvl1W8248DPdfPeoSjhVtr1V15K2
         jkiWRnP1L1AFlW18hfAUSNHsRAUFx2dhddBDDqE7BSzOl+Sxhu9GxhTaFu9XQaj8lLwn
         f5KGIi76bKd2r0gjocXMHnfyMKVJUBVY9MUNKIQFPBnWmccaYF5I+fftyh0I/lT30hzy
         ZSwgLqvAOclS8DLCrJblAjPp0Sv8yZSYvcLS3HMNvfDfkQaOcWMYd5MK3wa4LKJwg7ea
         GsMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775473088; x=1776077888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23p+wdS60pXtBpNvZkSzHr5OzahO/ZfsvZCv+StoNBA=;
        b=PICvgEH3Aqo4JlF4Yn2MC+MS6TAmKNY9U0p/v0YNLFnBZJuXzixlR8UyzCFgCamAg4
         DZpQreX2d+1R8I1x+RLvHJ+8s12yedFqlomElfPovotJgmilDeaM2cQChJs9nstGPDqu
         uB6w/uGnRcy19lo0V0l8LBZ5hB8kEFqBOEC2s6Bu+tgOHF5BmIPlal1j1xK4b+Xg+jYC
         2wBVY17ffKYfgozT5f+7fEjml/kg31wr0gMH0nh/HkguiqMpfnN1sDO4yOX9OSP75Hss
         1meCr88nV3GNMi5F3e36sDMllzeAo2i0lVmUW42lZQwWkUa9rSJLW+r/XKZ7O91UAsGl
         ueRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775473088; x=1776077888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=23p+wdS60pXtBpNvZkSzHr5OzahO/ZfsvZCv+StoNBA=;
        b=fQ4ohKNtepBJ3awnoiqoBYaV9g1UbstMITrDTuEzqZ3x6ESwgUqzfbS4OtdUPL3QGj
         mVO7irmfml+2JDaeWjLh0mKB+6G5G7QXIrco53zmrxSWTJL3VVJ6AW6iOz+1PZyKrpQ0
         f3UojeF2JACu5Bqzhqw7LN5FIL+J4QqjBwPQ8R0PghY2BawJ3uhOfU2WNZhhkDfMe/jz
         mvnEnsXupgAlbttQz0ZJhiioQadehs775SPJNDnPzhWFtu8cpRN7bEJMDwIV52wsVPKG
         vvhUSW5zfOVXquC/sgZe05vseoyHVMkjQaBkkVNWiRXwNS5VuSdz1+TrY44Ys3YLhXvD
         pXFA==
X-Forwarded-Encrypted: i=1; AJvYcCWwqNTmnhdoOLXmtXpIzz4NPuFkx7UlVoMieLfBwGAI9Ws+Cy+wsK4GF57r2aPcuUNFgsjdqhPm7MDOisT6@vger.kernel.org
X-Gm-Message-State: AOJu0YxFvWijAy3k0bKJaOiaH7zzXr8kKJmLPp63cLN89NSkgYdA47Iz
	eTpUuRoLAhF6miGcM/id39o2WWk0F2EA8bpZadVcmdHuk9pyAlEbcEK1CUYU+mhPb3rgnMDq0un
	dW5IjlcRoEIniDYv4L18I17GDvU1lt1Y=
X-Gm-Gg: AeBDiesjJBYYEGasetjPQCOCqtf2v6xdwc80/NMfQXNqdIc5esKHutTtbPZDkSPT8Po
	OvFXOCZqqQqckm7lnRm5YFUH+uRmYM93RDZSseP2JDJEA1VFUrQwBCCC1vbqTk1PYDAI00p4JnO
	kKlzfqGDbDj2HPb+csi9lWRWmycxJpnXncF+SIE+6BFLckk9BUajfQyAMBTI6JD+InlHJYPQUcs
	LmzlebUqybCDPeotvxoIvljnEpcqNuzhicxQteaJWtFcSvyeM5f1J45BKgvsNSL5LlfPjhDTToe
	mmiJSyY9DnRTbi7zGEOoJ5SDwrGbzAZ5b/WAy9nlBSSJjqvw/A==
X-Received: by 2002:a05:690e:484e:b0:650:3831:5728 with SMTP id
 956f58d0204a3-650487252b7mr8448323d50.27.1775473087931; Mon, 06 Apr 2026
 03:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <adNGXfRI84mZrUSs@infradead.org>
In-Reply-To: <adNGXfRI84mZrUSs@infradead.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 6 Apr 2026 18:57:26 +0800
X-Gm-Features: AQROBzAl0BcDhENrlTb5JpJbwT_YJ16rCE4wk9DxJbKmVNmRtDNxJ6Ti_Yessu4
Message-ID: <CALOAHbBM0YNr3vozKxAwVOyBdZq5S376uwZBpfxNujhzV7cM5Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding
 for livepatched functions
To: Christoph Hellwig <hch@infradead.org>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	song@kernel.org, jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2294-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,infradead.org:email]
X-Rspamd-Queue-Id: 7BB623A2F28
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 6, 2026 at 1:36=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Thu, Apr 02, 2026 at 05:26:03PM +0800, Yafang Shao wrote:
> > Livepatching allows for rapid experimentation with new kernel features
> > without interrupting production workloads.
>
> Myabe it allows, or based on the rest of the mail not quite.  But that
> is certainly not the intent at all, the intent is to fix critical
> bugs without downtime.
>
> > However, static livepatches lack
> > the flexibility required to tune features based on task-specific attrib=
utes,
> > such as cgroup membership, which is critical in multi-tenant k8s
> > environments. Furthermore, hardcoding logic into a livepatch prevents
> > dynamic adjustments based on the runtime environment.
> >
> > To address this, we propose a hybrid approach using BPF. Our production=
 use
> > case involves:
> >
> > 1. Deploying a Livepatch function to serve as a stable BPF hook.
> >
> > 2. Utilizing bpf_override_return() to dynamically modify the return val=
ue
> >    of that hook based on the current task's context.
>
> Whol f**. now.  Is this a delayed April 1st post?

You're already in my spam list. Don't expect any further replies. Feel
free to keep your verbose rubbish to yourself.

--=20
Regards
Yafang

