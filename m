Return-Path: <live-patching+bounces-2334-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBQDAVaj22kqEgkAu9opvQ
	(envelope-from <live-patching+bounces-2334-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 15:51:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD523E40E4
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 15:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0757430028FC
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 13:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B09AE2DE702;
	Sun, 12 Apr 2026 13:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9EpLx+G"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5715E2737FC
	for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 13:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776001870; cv=pass; b=BbnlrDis7Q/lw+bZfokg/4o5YtDS/x2xPZNPiZK61mHd/TFpvOVN9wguemPaFPAXfVr2fHbh3UjMvQhPxNCxdcUHUsj8IpHg3DAnnmftTfyGyOvi45ZpnmZO3ZGAojN6o6zbBunir24B3t16eCx99BfPvEATizt5tU9JOAqLktM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776001870; c=relaxed/simple;
	bh=Vm+QvtQZE23sVbgK/tEkRjhUlOBlrvQ/gGRliE28Mbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aUD25kZBCByQDsDkiQRZ1HloTDE8m23RkQMbSDTT/rwrx+v97+gw3ldGGmI8YuW0Ua3fj+Ao1mWncIDHMHz2zbGWD+baZbqAWUBIuTeFYAd95t/R3vijZx0Ny9pa+lAlKQmPGt5dawQEeB6vC4WmXz/9HQGcfcBB5ZogWn3Id48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C9EpLx+G; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7a43424f861so28646747b3.1
        for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 06:51:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776001868; cv=none;
        d=google.com; s=arc-20240605;
        b=f9mRtYvp1IH3zz1L8BaUS50P20O+YSUEeh7T1IVVjyXJ3qYrLH8GsI6a0awhrMgv9E
         7D34Hyb/tNqCEPjTTANYg1oyhNNvLVfSXRJrUmfBGhsTFLsCv+tjxD8uVjfnB36A561x
         nr1yt72UOeocjhsxFA0xKuP3aM2nVDgzQQsHHhQdQpohV8I8mfAzZFhqhpwMgU9Nm8Es
         RTEznbLD+QCXX4xcRZH8nZ8ZUA+a/9qXSMu5a+0KMSCCApDfchhH2f+LAnK7PLyonCgA
         C3jeTryOUCFY3X0BXlvsu/e99ME0T8dAjs3SYSjBypKnCPPrIsnnUQEfO40hmXiNsMC2
         4EiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mdsrFw8g8Bu97byW04CT8KXQ2lpv8OYnpWUOna6h/+A=;
        fh=8X+QOJIPXxZBobtNVzPDfsSxnRlmNrtfZymKUT5Sdc4=;
        b=dr6ywmreym+p72oGtUZuaVK1U8hpS0fEEhe91BfQXUFnMhM/7hEuYAcrPIIh3VlUwN
         8tzjCqsgZqMxBDnFKZFWH727l2GupDgvqXCUgVTZN6gnQv+9auoXS8TMk+Cmpm575r5p
         bWOx77iQrEkD6GeNid13HN45mZcGUAszfKmUvsrD6tfyeHz5+vlqz3BTp6a1z8yh2C/R
         t+uorTjmpgMqiThCXmKxD3dn2hwyR1X3xYuhojf6nVnMCBagfmoMHGxbpgDHC5aXpF97
         4wcMaIHyv0etoFJ5FTY6jSzDrx+rEM38JwiFRT38r9ZDS5tbZGE11a3hVEQS7WDtzEkl
         Tu/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776001868; x=1776606668; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdsrFw8g8Bu97byW04CT8KXQ2lpv8OYnpWUOna6h/+A=;
        b=C9EpLx+G3IANRDKis1pKPomgySzvwrG/DTrjgtOykO1b4WyF3+cMHefL7ElWXKi1FU
         CeYm5P+RLOwAP1N249Neu8WTFkgGtw5FjimXN1muGdRIrzADFh+Uq3Go1DbLWIXT7RjX
         V07TzjpDIxbj7Oc/EFLBW0w7CQ4HHrvyUJ7wHNLEwrDPgS1Yw9gOm8oDkmsOnVwJYd3u
         To0SeMQSipn0oCThDiy4jRix087DHW9zam1PJ/H8bxZ77aBwnIj0uKulpEq4DjCtYRbg
         u6OhiOFwAcxkzhM2L+cbQcodjM+mQfGnKAzlqKb42c8jnt1MikHeiFpTgFWx37F2Doem
         QqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776001868; x=1776606668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mdsrFw8g8Bu97byW04CT8KXQ2lpv8OYnpWUOna6h/+A=;
        b=pwjBoZcdHlOWFWdrAKIOrjzZf1gpQRvnxDwKiJtFe/cfpSCe7g/j4yIzKc+4EbiClh
         BdcMB+2YMRJqjgwJiFII35gmWIaW1e9ar0VGdkeZWdzzVidfMN3/BMIgyGAfOJ6LZLQG
         87pHVS/DuY02vF+NeSEw9YkMimx7gEHgmrOTZ1PRw7nZYscOHGcezXg03/K/oMQpHeFu
         o2D8JobMGUsDEubL5Z4a4oyQODGsEefwkoqqtWjgH5FYDx8E2hihaCJ5CcK9t0m3GCGb
         RAF/n5t8yNiBNTpjQ/NObfy5xNVIwxiPC3d6Gh4i/KtpnIeoFrd1nfmF+uDcaer9qxmw
         M7YQ==
X-Forwarded-Encrypted: i=1; AFNElJ89Zvauw8Znocq/ht1FAPtYYn5SAAKjaiYGeUiVsmXH5+hK9Mv3xT82fIiskgdwxXBlM6vRCi7nmDKi5rfz@vger.kernel.org
X-Gm-Message-State: AOJu0YzNIF/BCcoX8xTt1KcIFprypb4VqRQjN9ml33WLmW0MIO1OHJIM
	Gk+mhSj95t3i6UnnXkeQX/cnYYg0CJsyIHD2HWwJ4DUIUAyzRdDhSNI5/fb60Se/fFnWLNHVn8k
	XoynF9mkDj8x/p+Vh4w5kg2f4ElSfMyo=
X-Gm-Gg: AeBDiesGcsZNpDLV3jb9VhA9UyDvAbavAGDitAD/FatOmH+P62BYjTC4iZwoa1ilw77
	ciXh1CjnkuyBxa6EPwbd0vAtq3lkRTtDZvA4kBYBysVDctRZ4kTVluPn8Z57uyz2/a7zEQH84bN
	FQzC+WLDdXsRd0rSaY9TLKBYanTUkfrTEIsZ3q/HsBGtWYCVkA2ckLHU6eTaN1HkEwV10OJym2p
	YMOtDBEbDfBblCratOwX1ke95RkjsKxpw40gAWsv1F/JLDVJpxFHYJMXWJjIb67lWPX7fWU8+3L
	OjF7pazCptYLMsIm6qNRNnfadUAAnfi7+xjOG8Yd
X-Received: by 2002:a53:d246:0:b0:650:77f5:1410 with SMTP id
 956f58d0204a3-65198b47128mr6848061d50.33.1776001868315; Sun, 12 Apr 2026
 06:51:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260410133844.56ab7964da7628d1c3482acb@kernel.org>
In-Reply-To: <20260410133844.56ab7964da7628d1c3482acb@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 12 Apr 2026 21:50:31 +0800
X-Gm-Features: AQROBzBaWJkKG21AiORGSzFrR-pHHuRCQzMa1l_wXUruYUno8uNhz0WAA12-V04
Message-ID: <CALOAHbAOx=C4b+4xQwRf59xvY0vbMPfOjO5LMDghC4Ryksv++Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding
 for livepatched functions
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, 
	kpsingh@kernel.org, mattbobrowski@google.com, song@kernel.org, 
	jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2334-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EBD523E40E4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 10, 2026 at 12:38=E2=80=AFPM Masami Hiramatsu <mhiramat@kernel.=
org> wrote:
>
> Hi Yafang,
>
> On Thu,  2 Apr 2026 17:26:03 +0800
> Yafang Shao <laoar.shao@gmail.com> wrote:
>
> > Livepatching allows for rapid experimentation with new kernel features
> > without interrupting production workloads. However, static livepatches =
lack
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
> First of all, I don't like this approach to test a new feature in the
> kernel, because it sounds like allowing multiple different generations
> of implementations to coexist simultaneously. The standard kernel code
> is not designed to withstand such implementations.

However, this approach is invaluable for rapidly deploying new kernel
features to production servers without downtime. Upgrading kernels
across a large fleet remains a significant challenge.

>
> For example, if you implement a well-designed framework in a specific
> subsystem, like Schedext, which allows multiple implementations extended
> with BPF to coexist, there's no problem (at least it's debatable).
>
> But if it is for any function, it is dangerous feature. Bugs that occur
> in kernels that use this functionality cannot be addressed here. They
> need to be treated the same way as out-of-tree drivers or forked kernels.
> I mean, add a tainted flag for this feature. And we don't care of it.

Agreed. This should be handled as an OOT module rather than part of
the core kernel.

>
> >
> > A significant challenge arises when atomic-replace is enabled. In this
> > mode, deploying a new livepatch changes the target function's address,
> > forcing a re-attachment of the BPF program. This re-attachment latency =
is
> > unacceptable in critical paths, such as those handling networking polic=
ies.
> >
> > To solve this, we introduce a hybrid livepatch mode that allows specifi=
c
> > patches to remain non-replaceable, ensuring the function address remain=
s
> > stable and the BPF program stays attached.
>
> Can you share your actual problem to be solved?

Here is an example we recently deployed on our production servers:

  https://lore.kernel.org/bpf/CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yqge=
o4C0iA@mail.gmail.com/

In one of our specific clusters, we needed to send BGP traffic out
through specific NICs based on the destination IP. To achieve this
without interrupting service, we live-patched
bond_xmit_3ad_xor_slave_get(), added a new hook called
bond_get_slave_hook(), and then ran a BPF program attached to that
hook to select the outgoing NIC from the SKB. This allowed us to
rapidly deploy the feature with zero downtime.

[...]

--=20
Regards
Yafang

