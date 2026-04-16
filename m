Return-Path: <live-patching+bounces-2359-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ePqEIUKU4Gn/jwAAu9opvQ
	(envelope-from <live-patching+bounces-2359-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 09:48:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A1C40B2E0
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 09:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BAA023018BDC
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 07:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C49D3890E2;
	Thu, 16 Apr 2026 07:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZxtj9u1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B581C3BB57
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 07:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776325575; cv=pass; b=m9oRWnnyarJIYXXybYa5NeRD7JeoEjcOnt/v5OaA3o2nJaDVdJdv1Ehyeo8HStVTq8vNcfmpPdp/JZAFPvKJA5HZVb5IUFcejV/68I4y9rANWREmJMGYXfTE4wRyS4EKVB+aUuwksbfDeAd1tm/vOGm62gtfPY1aqOdUBr4MWME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776325575; c=relaxed/simple;
	bh=LlzJcoFTuAbhIU58c4DyINiboxlbbwZ3Is4DRu5z8yg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gnNS4HezlzLNuWwO2qrY50Zvlqn2MMLg5xrUxIrmyraNj0Ewa8PQzoa9Yqvf9ctf6defl3dNMLuhhCBdAduTdITaubMOgmgXsU2uvzWUHbkAEiVyELBLsWAlwjyeMZocZ6Vh9SFtAiqyi/3DjlFMFnrgG9yqHpbPEUPCLhVmuCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iZxtj9u1; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7927261a3acso76201017b3.0
        for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 00:46:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776325573; cv=none;
        d=google.com; s=arc-20240605;
        b=RjQgxnyzqb6qa8Hh+TsbZeYpgHAUtIlWXtvr9Xcd2uVgM2KO5TEqAEXrSu5ZBoAFVb
         D0+KS6i3Q62qIGhfPnE8tMvJZ5EvB1BCl++ucS/CJ0blAYKsrCEUOO0Ju5ZINBLWBTip
         ntjqQUuCx/h4jRsqoMxR2Rym1CZf+IZTj5xEqwf/SXcmJRgFZZyk7iZM5reSWRegLEWU
         MzKb6FyAdG8mawtVkbdfPx+K6AqUZybpYoVq/Qarvu+3dlhNaMAfAOSD2sLSqFw2C2Mv
         19gI7fuOWz14mU3BwuMSknHsrU5A8ufqDdi8pPMXMx0QQ8Zh5gIUMoOocar3MaGdHpvm
         fnJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5qvlpeb0+fc9hmYPaaHn8BOdlENlfBpM9I+g5WglWO0=;
        fh=B3j+8dL5MLNsfgRibYaHLhf8C1DPUqdej3r9Zkfkrz4=;
        b=cVppZ/+8WL3oh89ZpPgZaopAnmvwIXMi/prVnq8nCsK0EecBQmVd5eYtL2iPd5T+l8
         UJMXPGqbH5WF2oabGKE7yJnnQ89kn/nhr2CfQlLtoF+wSqN4/Ms6iiCL7qqeKPyqyCUV
         twm9LENtdwIi0TONrTzHxTmRwxC8WMfuUAYBS6laC5BAsuLCiEl/x1ouTY81Tg0yU4bO
         45RQsiPowzyQzXeUBq5cLTXREXWte5cC7pfHXRsbWuAWC9gX2uzvEPHuIxVIQiaXZtYm
         EeotERHV0HPFRAWrXtz0rvO97+7QSochtqyDUzsYEVqO/wud2D9KSsX4RoS/eO69SJMs
         yFTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776325573; x=1776930373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5qvlpeb0+fc9hmYPaaHn8BOdlENlfBpM9I+g5WglWO0=;
        b=iZxtj9u1yEX2UkyAj0DHOrZyIJDkObeIPxilH2Q1Vj8WPziNUoshz6FSpdqFsdUHsZ
         PYABEbn7j1qDPB4bZpR3uExaLZmXER7R+EzLROYx0pUEqzjqSLAWQIZ/WQgfaEGStRXB
         KT0l561CLOCOMspqJ5Mq3mE35wJ96r1WrEO9dxff2B4uMc4ZQ6owFrtodsaJgIFUp89l
         CGsBgfLyTneg9aEezQ3ppcz1WViwhAshU/QrduEjouSJPY9jDs9I31mdIDcaTFWHaMi/
         Ey4msVprWwjxRb4XMWi/E+zrM6aVqYa2KqBHSu40W2rLg//GdS2zGZfvnIJfjq0IwT1J
         Uc2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776325573; x=1776930373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5qvlpeb0+fc9hmYPaaHn8BOdlENlfBpM9I+g5WglWO0=;
        b=muo6FR8k9scOesseSjdNAbREAI5stfVf59nB5UCherBiVgtRW0DVZ7G73x3umkpAgY
         A+5O+47olJEfKsiHJi6OwUICuaWgMExce5DbWyy+8VQLbec4ZGF978NXdnpNvQRAfOq9
         TvOJXc0wtRos4LVPi6THPImeW4d+DtxOtg1x8IgJZYUlmwOyGgOJW6pIyANEvyP/z/+p
         Iczg3CX96848dWOhuJCXHUDn5sbircr8y1RCee+l429y9t7KjCnsJf0TRjxWY3uwzZV1
         4BxdQIHCSD1i6X58e7uReu6Gc7Ru/zlZKJZ69YYZj37gwdppxRqTb0/HdgztYOLANug9
         G04Q==
X-Gm-Message-State: AOJu0YxqIywqGRyznK36YFFFJR8QL6zz+4O4vO8Ru2qgY7HVXUP2ZQcF
	gTBBL6POPYM1wUFofMDD73WEVwQqboqVLKvKSZVEpantqE+f4q7HakUz14FrwVsc3i/pZM6E4oN
	NhuEinlV6jO2sNcu9icwE0jLSH7c+9lw=
X-Gm-Gg: AeBDietWlotFAwj6vTJIYC0yWmR1NOi2bDLHvTyTcVxOV12nyylvTD+mSgmcdRs9iyS
	6XtZ6tXXS5kSMUQ+fMZzLcu7KcoFuk5TSDefOjQMRseF3FuZ5F/SSFcNY1bZbTGNU2T6Bkg2QJ1
	e+z/LFr2udagzA8CaFDb3MJ1ulBFPikCJdhOVg0daKdh8jAUH2sHW7mFr/yWD5P7ib355bTPjT8
	hYW6buJkJ87pg+wQjR4MxRcHfTLrXFizGZybIYGzTayfDB9WmEh0PP3E2JWVZStGBVuKqy/xPri
	3xyKiaCAgvaDf7+ztZj3akUeKQSN8XVCwr+EyXnS
X-Received: by 2002:a05:690c:110:b0:79f:3b8c:a80e with SMTP id
 00721157ae682-7af6f9fe6d2mr279148017b3.17.1776325572750; Thu, 16 Apr 2026
 00:46:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416001628.2062468-1-song@kernel.org>
In-Reply-To: <20260416001628.2062468-1-song@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 16 Apr 2026 15:45:36 +0800
X-Gm-Features: AQROBzCbPCbhFae4PKvu8SGpuc0Jhi_KOZR-8K1Blk7Z_c5bTUe1Sk_NrYllJKc
Message-ID: <CALOAHbDSpofLCQ-LCU2uVtkc9w+zib0PPgBr+6sEv5FD5+Hd=g@mail.gmail.com>
Subject: Re: [PATCH] samples/livepatch: Add BPF struct_ops integration sample
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2359-lists,live-patching=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN_FAIL(0.00)[1.2.3.5.c.f.2.1.0.0.0.0.0.0.0.0.b.d.0.0.1.0.0.e.a.0.c.3.0.0.6.2.asn6.rspamd.com:server fail];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 42A1C40B2E0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 16, 2026 at 8:16=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> Add a sample module that demonstrates how BPF struct_ops can work
> together with kernel livepatch. The module livepatches
> cmdline_proc_show() and delegates the output to a BPF struct_ops
> callback. When no BPF program is attached, a fallback message is
> shown; when a BPF struct_ops program is attached, it controls the
> /proc/cmdline output via the bpf_klp_seq_write kfunc.
>
> This builds on the existing livepatch-sample.c pattern but shows how
> livepatch and BPF struct_ops can be combined to make livepatched
> behavior programmable from userspace.
>
> The module is built when both CONFIG_SAMPLE_LIVEPATCH and
> CONFIG_BPF_JIT are enabled.
>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  samples/livepatch/Makefile        |   3 +
>  samples/livepatch/livepatch-bpf.c | 202 ++++++++++++++++++++++++++++++
>  2 files changed, 205 insertions(+)
>  create mode 100644 samples/livepatch/livepatch-bpf.c
>
> diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
> index 9f853eeb6140..1ab4ecbf1f0f 100644
> --- a/samples/livepatch/Makefile
> +++ b/samples/livepatch/Makefile
> @@ -6,3 +6,6 @@ obj-$(CONFIG_SAMPLE_LIVEPATCH) +=3D livepatch-shadow-fix2=
.o
>  obj-$(CONFIG_SAMPLE_LIVEPATCH) +=3D livepatch-callbacks-demo.o
>  obj-$(CONFIG_SAMPLE_LIVEPATCH) +=3D livepatch-callbacks-mod.o
>  obj-$(CONFIG_SAMPLE_LIVEPATCH) +=3D livepatch-callbacks-busymod.o
> +ifdef CONFIG_BPF_JIT
> +obj-$(CONFIG_SAMPLE_LIVEPATCH) +=3D livepatch-bpf.o
> +endif
> diff --git a/samples/livepatch/livepatch-bpf.c b/samples/livepatch/livepa=
tch-bpf.c
> new file mode 100644
> index 000000000000..4a702a3b4726
> --- /dev/null
> +++ b/samples/livepatch/livepatch-bpf.c
> @@ -0,0 +1,202 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * livepatch-bpf.c - BPF struct_ops + Kernel Live Patching Sample Module
> + *
> + * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
> + *
> + * This sample demonstrates how BPF struct_ops can control kernel
> + * behavior through livepatch. The module livepatches cmdline_proc_show(=
)
> + * and delegates output to a BPF struct_ops callback. A BPF program can
> + * then attach to override /proc/cmdline output via the bpf_klp_seq_writ=
e
> + * kfunc.
> + *
> + * Example:
> + *
> + * $ insmod livepatch-bpf.ko
> + * $ cat /proc/cmdline
> + * livepatch_bpf: no struct_ops attached
> + *
> + * (attach a BPF struct_ops program implementing set_cmdline, e.g.)
> + *
> + * SEC("struct_ops/set_cmdline")
> + * int BPF_PROG(set_cmdline, struct seq_file *m)
> + * {
> + *     char custom[] =3D "klp_bpf: custom cmdline\n";
> + *     bpf_klp_seq_write(m, custom, sizeof(custom) - 1);
> + *     return 0;
> + * }
> + *
> + * $ cat /proc/cmdline
> + * klp_bpf: custom cmdline
> + *
> + * $ echo 0 > /sys/kernel/livepatch/livepatch_bpf/enabled
> + * $ cat /proc/cmdline
> + * <your cmdline>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/livepatch.h>
> +#include <linux/seq_file.h>
> +#include <linux/bpf_verifier.h>
> +
> +struct klp_bpf_cmdline_ops {
> +       int (*set_cmdline)(struct seq_file *m);
> +};
> +
> +static struct klp_bpf_cmdline_ops *active_ops;
> +
> +/* --- kfunc: allow BPF struct_ops programs to write to seq_file --- */
> +
> +__bpf_kfunc_start_defs();
> +
> +__bpf_kfunc void bpf_klp_seq_write(struct seq_file *m,
> +                                   const char *data, u32 data__sz)
> +{
> +       seq_write(m, data, data__sz);
> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(klp_bpf_kfunc_ids)
> +BTF_ID_FLAGS(func, bpf_klp_seq_write)
> +BTF_KFUNCS_END(klp_bpf_kfunc_ids)
> +
> +static const struct btf_kfunc_id_set klp_bpf_kfunc_set =3D {
> +       .owner =3D THIS_MODULE,
> +       .set   =3D &klp_bpf_kfunc_ids,
> +};
> +
> +/* --- Livepatch replacement for cmdline_proc_show --- */
> +
> +static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
> +{
> +       struct klp_bpf_cmdline_ops *ops =3D READ_ONCE(active_ops);
> +
> +       if (ops && ops->set_cmdline)
> +               return ops->set_cmdline(m);
> +
> +       seq_printf(m, "%s: no struct_ops attached\n", THIS_MODULE->name);
> +       return 0;
> +}
> +
> +static struct klp_func funcs[] =3D {
> +       {
> +               .old_name =3D "cmdline_proc_show",
> +               .new_func =3D livepatch_cmdline_proc_show,
> +       }, { }
> +};
> +
> +static struct klp_object objs[] =3D {
> +       {
> +               /* name being NULL means vmlinux */
> +               .funcs =3D funcs,
> +       }, { }
> +};
> +
> +static struct klp_patch patch =3D {
> +       .mod =3D THIS_MODULE,
> +       .objs =3D objs,

  Nit: I suggest enabling the replace flag for this patch to align
with the recommended implementation.

    .replace =3D true,

Other than that, it looks good to me:

  Tested-and-acked-by: Yafang Shao <laoar.shao@gmail.com>

[...]

--=20
Regards
Yafang

