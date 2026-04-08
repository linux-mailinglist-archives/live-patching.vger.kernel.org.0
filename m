Return-Path: <live-patching+bounces-2319-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EA4eFCH71Wn4/gcAu9opvQ
	(envelope-from <live-patching+bounces-2319-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 08:52:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E23E73B7C01
	for <lists+live-patching@lfdr.de>; Wed, 08 Apr 2026 08:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CB94F300FB43
	for <lists+live-patching@lfdr.de>; Wed,  8 Apr 2026 06:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1EDB36495E;
	Wed,  8 Apr 2026 06:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jymV2QsF"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA7A35F5E7
	for <live-patching@vger.kernel.org>; Wed,  8 Apr 2026 06:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775631130; cv=none; b=ofapOgzouNNeDx1wyYDszcA0pW4O/+vOz5f/HhiueQ/+rkUk2LXoLEnP1Vok5jNIEa485E/3OBmiDI8lQzcKC07maad3r0+e/cVQRsQNCLso7QNakeBUNvcHHLh5akujrYCGWCQ4PhD/B84bdvuJuMqWsZvmvXhOXqKUvYXLxkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775631130; c=relaxed/simple;
	bh=fVLaWWJM/+DrhOdY/IjJLlsijZLtkkmzv58xVpgX79Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kwNIm9al3ctsvWSQWcB0qorjynjaL76H8IVx11qN14AJMHv7+RaIiax0LntAp4pnbSoPJ3KMIUJ4IDfUAQBMTjQFuPLoeh1/QM4AwIzemxWsURGHnUT73+eba9kv4+NIvdV38gcblFmsdCGaKn+Xq1434x/6mg9gFQyZ1t/h9VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jymV2QsF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4976C4AF09
	for <live-patching@vger.kernel.org>; Wed,  8 Apr 2026 06:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775631130;
	bh=fVLaWWJM/+DrhOdY/IjJLlsijZLtkkmzv58xVpgX79Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jymV2QsF7wM3fzUjlvZ8wxD/dh1uoEt8jxsUvTGWgs2pbCcWhVyXLk/Ll2Sq/xSqj
	 BxuuWvWT7Xgt8LOP/BP4EQzD9VGSKyyWQVp1v0D8xOuAo2fnIQ0Oe4xpojFwWB7ASV
	 EiFImJuaSZKnhnyMfryF6DOhf7NSknL2DaAUbyNcrnMlookJcnJ//SVw8PbJN2mtyR
	 oCjjCo0IN30hSIEZWJJGrBfldeadh1eqV48nzH9hLREIX4SoaIzpN7o8DcRq6IWXxC
	 iECJNvkdEt+4eL/Ienpmxq+35OgvlHHfuvzQ5qoWTFs879dHvjSWWETF6MfHFeR7Ui
	 Lb4PL6XSe83/w==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-899a9f445cbso73452066d6.0
        for <live-patching@vger.kernel.org>; Tue, 07 Apr 2026 23:52:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUHKv+6juvrpFIcD6cc+CgKpMfX2N6R4W+v96+125pR5HX8QolykF53MEvOgjtH7snBxIGy05LVLoR29LGE@vger.kernel.org
X-Gm-Message-State: AOJu0YzlbftS5GqjrMbRbIZJlLhCeg/Y0YeBK0DiH7GxJyf2OetAq2rH
	rHb/DFkhgblPXlHqiLAvFoGgxcohvVypBsZ6bgtfIJF81ek1X+3MT3sZQFdWHyB1AlVSO3D/NaA
	CLs6Aj24lZnAxnWuhNf+q6oQZsUkCetE=
X-Received: by 2002:ad4:5e8e:0:b0:8ab:48a8:9c34 with SMTP id
 6a1803df08f44-8ab48a89c80mr152901466d6.0.1775631129483; Tue, 07 Apr 2026
 23:52:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <CAPhsuW7Y5KksWM49TrGH_Hohaq02XO8qs7G99Y6D8=0usLFSrQ@mail.gmail.com>
 <CALOAHbDG8=eUV53kF+xn=izs2rpydCk=a9RznU-EEOzmkB8mQg@mail.gmail.com>
 <CAPhsuW73qFybHgOnZ=oFC1PvdWkYWDk7gsAoiBXe4xWYagPrmA@mail.gmail.com>
 <CALOAHbC0hqk+yrUZay01EBRNOHgyj1MAavzNK-06XJKK9ARMqQ@mail.gmail.com>
 <CAPhsuW5MN6ikKmxgqby5RJ3_gvjJ4B77X74OvfbTQoFO8iUgzA@mail.gmail.com> <CALOAHbAmTAfamStF9sZtO6efWYJ1sbXJp3PbsVapZf7dba91ig@mail.gmail.com>
In-Reply-To: <CALOAHbAmTAfamStF9sZtO6efWYJ1sbXJp3PbsVapZf7dba91ig@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Tue, 7 Apr 2026 23:51:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6ZnCQQw8A=XzR1T4Vqd-iF9+D_uXS8tfR23pgsDHKEzQ@mail.gmail.com>
X-Gm-Features: AQROBzBx8p57X8T9w4WknOECT-1edMnaV15eNk4cujNUDGJ6oJo3VQ-RDwm4ECM
Message-ID: <CAPhsuW6ZnCQQw8A=XzR1T4Vqd-iF9+D_uXS8tfR23pgsDHKEzQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return overriding
 for livepatched functions
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2319-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: E23E73B7C01
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 6, 2026 at 8:14=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
[...]
> > We can define the struct_ops in an OOT kernel module. Then we
> > can attach BPF programs to the struct_ops. We may need
> > livepatch to connect the new struct_ops to original kernel logic.
> >
> > I think kernel side of this solution is mostly available, but we may
> > need some work on the toolchain side.
> >
> > Does this make sense?
>
> Are there actual benefits to using struct_ops instead of
> bpf_override_return? So far, I=E2=80=99ve only found it adds complexity
> without much gain.

Yes, struct_ops can be more powerful. For example, we can use
something like the following to modify the content of /proc/cmdline
with a bpf program. AFAICT, this is not possible with
bpf_override_return.

Note that this example doesn't require kernel changes. This is
actually a fun example. I will send the full code as a new self test.

Thanks,
Song


=3D=3D=3D=3D=3D=3D=3D key logic of the livepatch module =3D=3D=3D=3D=3D=3D=
=3D

static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
{
        struct klp_bpf_cmdline_ops *ops =3D READ_ONCE(active_ops);

        if (ops && ops->set_cmdline)
                return ops->set_cmdline(m);

        seq_printf(m, "%s: no struct_ops attached\n", THIS_MODULE->name);
        return 0;
}

static struct klp_func funcs[] =3D {
        {
                .old_name =3D "cmdline_proc_show",
                .new_func =3D livepatch_cmdline_proc_show,
        }, { }
};


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D key logic of the bpf program =3D=3D=3D=3D=3D=
=3D=3D=3D=3D

SEC("struct_ops/set_cmdline")
int BPF_PROG(set_cmdline, struct seq_file *m)
{
        char custom[] =3D "klp_bpf: custom cmdline\n";

        bpf_klp_seq_write(m, custom, sizeof(custom) - 1);
        return 0;
}

SEC(".struct_ops.link")
struct klp_bpf_cmdline_ops cmdline_ops =3D {
        .set_cmdline =3D (void *)set_cmdline,
};

