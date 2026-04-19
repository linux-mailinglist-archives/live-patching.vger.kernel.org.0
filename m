Return-Path: <live-patching+bounces-2396-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJ/qOsNK5GnRTgEAu9opvQ
	(envelope-from <live-patching+bounces-2396-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 19 Apr 2026 05:23:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 451D0422FF7
	for <lists+live-patching@lfdr.de>; Sun, 19 Apr 2026 05:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D030303A6D0
	for <lists+live-patching@lfdr.de>; Sun, 19 Apr 2026 03:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44AA6352C52;
	Sun, 19 Apr 2026 03:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsY7anYm"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB94A346E55
	for <live-patching@vger.kernel.org>; Sun, 19 Apr 2026 03:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568807; cv=pass; b=OlO/BE02hjoeoLr4iIb8wTwsvRu76CNrmDO3A/U42YI9/4PWxYNmcLRiWXijFi91bWgbdip7M4E01iR4rVRo1Z8yrIl1p0t4Z1KsH2tyd7oouiq05pViNaCl/EVg0AHcpOkiriufO6lLvn0Iug1GmK4G3373e3UdYNY6QbyyKBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568807; c=relaxed/simple;
	bh=bXv60AZi+eYA+Dcz4JLl4I1VylDAucQRAfc9LSrqLh0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kVce4V+Gwdf+mgr+qp5fSrVxJOglYfkupgy/86LS86nIhaSPhxqq3fRYOcd/t8bcAvQTVaiDIFWvMJ8caxHi2KQFVC56V8piN5TkmMXqUlPN4iY+JqWYyTUhDHMmX2QvsbGEmV+1v8KdNdBGkyWJrz0KEJeFjkPwDj5uEm+7MVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dsY7anYm; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7982c3b7dfcso16122507b3.0
        for <live-patching@vger.kernel.org>; Sat, 18 Apr 2026 20:19:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776568796; cv=none;
        d=google.com; s=arc-20240605;
        b=WGi0gmUSWnQAqr/YIP1rphrOXyMBjxzDuLqDH2FVpPN8ylEkKwhwB2tzSWW9Ursen6
         cPsieAsbEv4gr0fPzA4LPUcQCXj/PNyxPNOAKxo3fVHiwjUpmQAxBTvVYMTrWyR4UaFq
         wv14Bgm4rr50RuyKdHA6D8LXj4mqnytIQjYK0H5ZFl6Twb0qw5ykKaS4vHOAVgj76tdQ
         FmUb5Zg93/yFFTvGvq6rBi/NWHgq7SFFqRv7wZ2GEh8BuNkR9u/vV2gAJngQagp1APja
         4cjDc+s1ZKw+ofsfQnM9Zp2R1L6EeBbwnXgqJggFS/I11Tld2mNsLHIjcCUC/Rj4Nzgl
         w4NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rbQxZ1tMfv81fJorvpagNLVw+ky3CGe2/To7k2TXzAo=;
        fh=zW4G0gRLcqougYGrhSZ+sl89k+f0be4k+y9QmBJRazk=;
        b=UAsV4pQTfjLJd6ZFFzNUeqbxMj4S4GiAH6kN2jquxpQWAudu+06HIvoKWHDYES9jh2
         Wrb7D6Y4ZRgcjc2Sw2g6u0Dqi12YoqGbA1tnwhYpsbrgvCD33YzV8kR6QDws4pkUdxZ2
         vkSsPRNYiRHqkvLzgxVHbfkKWj4c7SEfrt4VRw3HZzIiWXJHLdShqtO4QVbFY8DCplHv
         J1aqjoyIPCIXjpvOjEVNHAzsvJsZul+8bJaFowGpDThuItI2eQOpwHdk4QsdxtByp77Q
         zWlvBLFT2q0sFO2HZ83zlQf6tRNI1FyncMM50nP4IbLrgIe+Iwu52c/yMlZfPCopnpEq
         ARUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776568796; x=1777173596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rbQxZ1tMfv81fJorvpagNLVw+ky3CGe2/To7k2TXzAo=;
        b=dsY7anYmdfGUCLcCRSTjg4rOEn51eaR3TxDUAV1SKQ2Y3h5JlaZnLjojdPGhsmDdne
         fQhxQDaR0K8MUBf3R8TAaFX6a0yxbDqriXno3IHUuabM6c6bsFkmI64F9Ym8yWoNFYvO
         CBMTrxISl/Z3RfVjqCce0nxwxkTaM7iCJX4TdZnWurm/Sr+Vn5eaEYXz6NO8UWHxNVx0
         KS8TIwswQAOw16Pi4gjfmLkLkw6iIQsR7coMNrNHPLhK10szcs9hXe9cR6GTrw70IS8I
         +ikn7IB5CraCP+++ppdEK/MgHoqhM3rZvTj3G8+Y4iZ4tpTF+jSGXUEjFMciyJtTMnV/
         eXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776568796; x=1777173596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rbQxZ1tMfv81fJorvpagNLVw+ky3CGe2/To7k2TXzAo=;
        b=VnPC+Q/1mnT0nfsxRbID4NHdwY6aA58x8f8TjK8ZUlOxL/yHzQMCeBKz21xBXOtcZx
         uwQvZRoFnWhiJwXRcF6pmTS2Lr67ADKFWJzzpOyosY4hCVutw3fGyWzapANj0GlxuvDq
         NtwSDcIXZYKxeIUoQtYPdR1tlN8r0pDtN/gQm7onAVysj9HksUeG8UYt10gO8MRexEaF
         +Xpb5U1Uyp6Y9v1+bN92ineIaVJ1vjSAtDRT2e/LZBdqcFtQpouknbqeIiAWDOZQVeBx
         3Wr9pH8tGtJAimzBXcgFdXUuEuHrWqgkDTsvWni4ht4dluEOd3Z/b7bUb9BT3WUBJKc7
         KBvQ==
X-Gm-Message-State: AOJu0Yw1fQrgDBUiyHhEBdJ1FkZCb5082X9cqUUuFCSy6ArLMo0Hzpsn
	4GAMFUpRzLwsuO+yo6IA9RQlClNePvy1R4fz9oxsLgaZuVOyQho9ptTx6BdvVImb43OWmrWKDYj
	RqJ5rjG5OdtAU3KaFXjDE/ka4NLb16eo=
X-Gm-Gg: AeBDietilfFdCzlWdX9J89ZYYtGMXY4AIEysRm8O5ISOtz3/l1+WP0OQ0UeosphxgvY
	ErXYSODh17dcrmyYUk22Gr/woNp0Mfm9f9iIDBoVdO6PuAauVvhX16335sAJr1DKEtoyWKHr/HY
	UkaAF2qBuAR0ImVNBybwN3r/ruTTed7pprnkX4VYnb4VX/xfR8nCp4eZ7AHv3skNvxoHtd1LXYi
	GczK9Z8Q35l64+G8jF2567KrhVaYuwSpJ2YPRxqAdFjgiQrVFVJJDjMB3ZlHReYzoKv0gBA5DXi
	nE/rg2Z+7F1M+l1qhCJ99/hdImL8ozdysIZvpCX2/IdVl8i3qMlXo5XKysQ4HQ==
X-Received: by 2002:a05:690c:3482:b0:7ba:ded4:df58 with SMTP id
 00721157ae682-7baded4e83cmr28598817b3.49.1776568796048; Sat, 18 Apr 2026
 20:19:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416001628.2062468-1-song@kernel.org> <CALOAHbDSpofLCQ-LCU2uVtkc9w+zib0PPgBr+6sEv5FD5+Hd=g@mail.gmail.com>
 <CAPhsuW5=oXwQQyOU7Hf6Qf5=tK=-J75Xr+p+dcGiPs2vVEeMFw@mail.gmail.com>
 <aeIzhNyvYaR2Krrq@pathway.suse.cz> <CAPhsuW6Z91qAM7G=iA_APX4Jfa8a0pshnGSTYn0+JXKsUfEVqQ@mail.gmail.com>
In-Reply-To: <CAPhsuW6Z91qAM7G=iA_APX4Jfa8a0pshnGSTYn0+JXKsUfEVqQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 19 Apr 2026 11:19:19 +0800
X-Gm-Features: AQROBzDnIdsK91pu3qJi1T6ahVvY7g8LMtFA09DiQxfXzN2jV-p6Y3k1jv7ft3Q
Message-ID: <CALOAHbCQ_0uuDnLujgEo3mnFucUih_w44B86wjpa61GxpG0NGA@mail.gmail.com>
Subject: Re: [PATCH] samples/livepatch: Add BPF struct_ops integration sample
To: Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2396-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,suse.com:email]
X-Rspamd-Queue-Id: 451D0422FF7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 17, 2026 at 11:52=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Fri, Apr 17, 2026 at 6:20=E2=80=AFAM Petr Mladek <pmladek@suse.com> wr=
ote:
> >
> > On Thu 2026-04-16 09:32:46, Song Liu wrote:
> [...]
> > Let' use the code from this patch:
> >
> > static int __init livepatch_bpf_init(void)
> > {
> >         int ret;
> >
> >         ret =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> >                                         &klp_bpf_kfunc_set);
> >         ret =3D ret ?: register_bpf_struct_ops(&bpf_klp_bpf_cmdline_ops=
,
> >                                              klp_bpf_cmdline_ops);
> >         if (ret)
> >                 return ret;
> >
> > --->    /*
> > --->     * We would need to wait here until the BPF program gets loaded=
.
> > --->     * for the new bpf_struct_ops in this new livepatch.
> > --->     */

No waiting is necessary. If the BPF program is not attached, the
default logic can be executed instead. Consider Song's test case: we
can handle it as follows.

static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
{
    struct klp_bpf_cmdline_ops *ops =3D READ_ONCE(active_ops);

    if (ops && ops->set_cmdline)
        return ops->set_cmdline(m);

    // If no BPF program is attached, the default kernel function runs.
    return cmdline_proc_show(m, v);
}

However, as Song explained below, if we want atomic replace to work,
we may need to wait for the new BPF program here. But that would make
the combination of livepatch and BPF more complex.

Currently, on our production servers, we handle this through a user
script, such as:

  stop_traffic_relying_on_livepatch_bpf
  kpatch load new-livepatch-bpf-module.ko
  reattach_the_bpf_program
  start_the_traffic_again

Although this approach requires restarting the affected traffic, other
services running on the same server remain unaffected.

> >         return klp_enable_patch(&patch);
> > }
>
> Yes, something in this direction is needed to make atomic replace work.
> We have no plan to use this in production. I will let Yafang figure out
> his plan.
>
> > Or maybe, the bpf_struct_ops can be _allocated dynamically_ and
> > the pointer might be _passed via shadow variables_.
> >
> > One problem is that shadow variables would add another overhead
> > and need not be suitable for hot paths.
> >
> >
> > Anyway, I think that I have similar feelings as Miroslav.
> > The combination of livepatches and BPF programs increases
> > the complexity for all involved parties: core kernel maintainers,
> > livepatch and BPF program authors, and system maintainers.
> >
> > Do we really want to propagate it?
> > Is there any significant advantage in combining these two, please?
> > Is it significantly easier to write BPF program then a livepatch?
> > Is it significantly easier to update BPF programs then livepatches?

This is an important feature for avoiding server restarts,
particularly in a VM host environment. Since only one VM on the host
may be affected by this feature, we can deploy it rapidly without
impacting other VMs on the same host.

>
> Some combination like this will probably make sense for Yafang's use
> cases. But I agree maybe we don't want this in the samples, because
> it is indeed complicated and could be more dangerous.
>
> Thanks,
> Song
>
> > IMHO, the livepatches should allow enough flexibility. And it might
> > be easier to update the livepatch when needed.
> >
> > Or do you install more independent livepatches as well?

If we want certain livepatches to be persistent on the server, we will
need to support independent livepatches =E2=80=94 and we do have such use
cases.

> >
> > Would the support of different replace tags help?
> > They would allow to replace only livepatches with the same tag.

Right, it will help.

--=20
Regards
Yafang

