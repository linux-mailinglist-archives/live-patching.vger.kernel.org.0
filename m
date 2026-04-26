Return-Path: <live-patching+bounces-2555-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eNbMFjR67WlkkAAAu9opvQ
	(envelope-from <live-patching+bounces-2555-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 04:36:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2165468972
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 04:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC16E3015E3C
	for <lists+live-patching@lfdr.de>; Sun, 26 Apr 2026 02:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6CA19E819;
	Sun, 26 Apr 2026 02:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbbBjLcs"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769DE3D544
	for <live-patching@vger.kernel.org>; Sun, 26 Apr 2026 02:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777170992; cv=pass; b=U+51sQI+V7mPXnzZkrXzXJ5B6IjoFwmosPqWz0oJOksFpZFhHHf8zoLBS3fM1f9h1EyRmUZKihPzccx0QizC2UQ2vbepWhQRxdWEGGfpdhv7Ki7i44ja13iJA+aYqgyYOCq2e/u1QQoGEkETsOeTLys2oaJHcAu3zc+ynVClP7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777170992; c=relaxed/simple;
	bh=eji+PZheiTKzmXtx7yg8KW4DGN6RvgVU6ZyU2Ey4bp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fsorHw3h8mvgQcqrAtx2TosNEm+oqkLE/TF/GhfdyVpCJ4sD/Pe3uM8IdqhIZJ/dG2geYHKV8O+cIF7paRmgFKnUqJZXVtZmm247LAvvsG06hVdF9ojfQphmIBgzBk4Hm45nTsE5m1mhOEAnKFZo10PG5CvBG/9E7r+KC1cBNvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbbBjLcs; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7986e538decso91724127b3.1
        for <live-patching@vger.kernel.org>; Sat, 25 Apr 2026 19:36:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777170990; cv=none;
        d=google.com; s=arc-20240605;
        b=XMLtMoVEd8Mm5ftob0zguTAyG1m1685+P3FJXhE9BVThKsXzoK97SemGQ+qbMLclLX
         m5fdasN00caHuprXVip39xPZLNHSATf8Pg2+nGgg1C0sATCp/wQG0njyE02vhyGpY4jA
         Az/eEPrN+yv8QOn+E88B8RwwxK3a9Ckake2qRqFkLEIZixAAWuPalxrSztFbjv5Yefvt
         L43ppoIDIze5bz4fAl3tYUmmFMVUqwTFMb8VXw+tIf6s3RhNox/Dd/cBjBFwbYDnVv5W
         daMgYLWmlkVMeZifNtb8vcYWMih3jDakEo5dK9wDPqw0QtDhrBYtd4ooJ4/wQi8s51Wz
         Q6Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TgGNRIMirfBoLbKid2PCkDbdr5swnsfLNMRgrcmLKLY=;
        fh=ATD4nkVvcalszDto9uRLoDcPzgnwp9OgaJGoP48mxEw=;
        b=G6+zcaNUwD8mrAZ73TnOqCtMH2fThpWoIg90B0FCSWeEC02O0HdG6EvTXvO8BSmB26
         evFQeNQuBMIY8KEm9QTbzoLSoBGWhnGOUG8G683INpN7blJsw1K6mO8FtODT3c7/063V
         7cvNSEf7WyaZZ7de9Kym15SMjJ9e1k8rYxx0j9iMzIxLzgwfPHlZ+lL8NadUrkIxuz+L
         SjdRnVDdh3UxM8sn731HcSc1Wc5Mv4MLmvF0XsSRJviisbQoguxI/4lGIwBuBD5icQmV
         YUsMT+3AdqbBxcc1yGWoXXnxfeItST5DnOastBx5y7HY+Ujam7AjAVPdUuNJ+rWHECic
         uOng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777170990; x=1777775790; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TgGNRIMirfBoLbKid2PCkDbdr5swnsfLNMRgrcmLKLY=;
        b=HbbBjLcsVb9dgD4OtAo0C7PlS1gqGoARA3h/li0cm2xrkRw/flMQuDrqH43zlckthd
         PuA1VR8skQNsU/dH4Fl3OvKUWfvWz3GMLAmp7Zt9bVh9z6YupXyPhEketp990VVw6wXQ
         DDXkUR2DOxTDdfKZVC3XVLCoGbGocnN8Fr64jwSN2hUTwhK9R6NpdL0vKDHJUFjxPyU4
         ulj2LRIMrct14bvQd+svTIpZHUJpnIYkY/xIBk61ismcMPnlYGtfaPj++IpTvdC7JonP
         6+fXtIcxqG37+BMhIxKT/jTJ0hbLWnyXHy6nn1I6bMHHmD8ZRgusE2AyOwjwyGBtgOJk
         3cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777170990; x=1777775790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TgGNRIMirfBoLbKid2PCkDbdr5swnsfLNMRgrcmLKLY=;
        b=V0EJI/aBNTcCiIf4yRtfc6I3ks41GMc/ZxxHDLRC9GYfIfIkcyv2gPDFH//qNs2I5/
         cB+Z2uIJ/k12p1NkIwHFCaf7A59NUizja35ymiDcvUa8fXRpmkkDJCgmRKNBWGZS9HY7
         G9nZ00UwhvK8Ur0CSRLQvVD8WDkYCh/GRhyNpwVF5XHyFwaj1qnP5HZbNS5ZxYG+GO/z
         ElSX4FLtjSvoPUGAK57wi1PvK1XYuJH7QaEBhdWtIA9CPSMSRXtY7RDEP8SMLh4wZuxT
         ANv/R1cWs/nrL527IN22F3wUJ1nivWp5W4bOxsh3XIVYANtcPpTe9j+GSvlCnYN/bSy0
         ywIQ==
X-Forwarded-Encrypted: i=1; AFNElJ+V0HfrGM8xBLFjRE2diezYzWuRjGVZWE9Yg76GSgVZtjTdvNWQ6RXalIBmgFBgSMkwnYDYlR14rIR3fjWS@vger.kernel.org
X-Gm-Message-State: AOJu0YyiuJzIzjNH5wfn7gGdi4Ah3FQ0Zm/AB5x7OpgqEOWZS2iAIbxp
	H36/xOYy/kHRu06zIg+MYNlq+QAD6dLUimw/GQX7UlsDKi5ERAOS9qAaf4v3Hx8yZs+Qlrzy5x1
	/Ao8bIKdA/c4BUM0MqAXXFU4vikm2ckY=
X-Gm-Gg: AeBDieu2wy25mzYKqXdFTvOMVdP+mL2AuWT1IQqlIz7fObViX0aPfanSHxZSM1pxOf+
	dXUftGBmQ7UBMC5c/OJqNhKjeiey4HVcIJrudLQa83YBD745VsEd1EUPGc7xVAnKC0ldr8LFpJx
	A6jhtCim90wHqba7bQmAHumCkGwqhcO2HWm7gNDoBY0l+5vS1aKApQ7PETkleLnW26EcAx2xy/V
	dpoiMvYno7kXRr8MJjXa1vymg7SixjggRccyNPBEOp7vpWhTewH7yHHq+U0dLsk+tVrq1+tx4/Q
	Dw14PNkhZUqM3IjVBwtqpP0GeN5hbq+1pyqdLZntLYbnR19zhuI=
X-Received: by 2002:a05:690c:6387:b0:7b8:bc4e:ac3 with SMTP id
 00721157ae682-7b9ecf85b82mr379193897b3.26.1777170990342; Sat, 25 Apr 2026
 19:36:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416001628.2062468-1-song@kernel.org> <CALOAHbDSpofLCQ-LCU2uVtkc9w+zib0PPgBr+6sEv5FD5+Hd=g@mail.gmail.com>
 <CAPhsuW5=oXwQQyOU7Hf6Qf5=tK=-J75Xr+p+dcGiPs2vVEeMFw@mail.gmail.com>
 <aeIzhNyvYaR2Krrq@pathway.suse.cz> <CAPhsuW6Z91qAM7G=iA_APX4Jfa8a0pshnGSTYn0+JXKsUfEVqQ@mail.gmail.com>
 <CALOAHbCQ_0uuDnLujgEo3mnFucUih_w44B86wjpa61GxpG0NGA@mail.gmail.com> <aedBHr4F0hTsY5x3@pathway.suse.cz>
In-Reply-To: <aedBHr4F0hTsY5x3@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 26 Apr 2026 10:35:54 +0800
X-Gm-Features: AQROBzDvAkYEkNlz6mURhOxeb2qjJmUASrJMQLKgZPwwepz5WRCFRlR0guhZKA4
Message-ID: <CALOAHbBoXmU9FBqCms9AoApwdWUdi-+YkBrHWnutr_Y3RQY65Q@mail.gmail.com>
Subject: Re: [PATCH] samples/livepatch: Add BPF struct_ops integration sample
To: Petr Mladek <pmladek@suse.com>
Cc: Song Liu <song@kernel.org>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org, 
	mbenes@suse.cz, joe.lawrence@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B2165468972
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2555-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email]

On Tue, Apr 21, 2026 at 5:19=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Sun 2026-04-19 11:19:19, Yafang Shao wrote:
> > On Fri, Apr 17, 2026 at 11:52=E2=80=AFPM Song Liu <song@kernel.org> wro=
te:
> > >
> > > On Fri, Apr 17, 2026 at 6:20=E2=80=AFAM Petr Mladek <pmladek@suse.com=
> wrote:
> > > >
> > > > On Thu 2026-04-16 09:32:46, Song Liu wrote:
> > > [...]
> > > > Let' use the code from this patch:
> > > >
> > > > static int __init livepatch_bpf_init(void)
> > > > {
> > > >         int ret;
> > > >
> > > >         ret =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> > > >                                         &klp_bpf_kfunc_set);
> > > >         ret =3D ret ?: register_bpf_struct_ops(&bpf_klp_bpf_cmdline=
_ops,
> > > >                                              klp_bpf_cmdline_ops);
> > > >         if (ret)
> > > >                 return ret;
> > > >
> > > > --->    /*
> > > > --->     * We would need to wait here until the BPF program gets lo=
aded.
> > > > --->     * for the new bpf_struct_ops in this new livepatch.
> > > > --->     */
> >
> > No waiting is necessary. If the BPF program is not attached, the
> > default logic can be executed instead.
>
> But it means a regression. I guess that you need the BPF program
> for a reason. The default logic is not good enough indeed.
>
> > Consider Song's test case: we can handle it as follows.
> >
> > static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
> > {
> >     struct klp_bpf_cmdline_ops *ops =3D READ_ONCE(active_ops);
> >
> >     if (ops && ops->set_cmdline)
> >         return ops->set_cmdline(m);
> >
> >     // If no BPF program is attached, the default kernel function runs.
> >     return cmdline_proc_show(m, v);
> > }
> >
> > However, as Song explained below, if we want atomic replace to work,
> > we may need to wait for the new BPF program here. But that would make
> > the combination of livepatch and BPF more complex.
> >
> > Currently, on our production servers, we handle this through a user
> > script, such as:
> >
> >   stop_traffic_relying_on_livepatch_bpf
> >   kpatch load new-livepatch-bpf-module.ko
> >   reattach_the_bpf_program
> >   start_the_traffic_again
> >
> > Although this approach requires restarting the affected traffic, other
> > services running on the same server remain unaffected.
>
> We put a lot of effort to make livepatching as less disruptive
> as possible. The atomic replace is supposed to work without
> any disruption.
>
> > > >         return klp_enable_patch(&patch);
> > > > }
> > >
> > > Yes, something in this direction is needed to make atomic replace wor=
k.
> > > We have no plan to use this in production. I will let Yafang figure o=
ut
> > > his plan.
> > >
> > > > Or maybe, the bpf_struct_ops can be _allocated dynamically_ and
> > > > the pointer might be _passed via shadow variables_.
> > > >
> > > > One problem is that shadow variables would add another overhead
> > > > and need not be suitable for hot paths.
> > > >
> > > >
> > > > Anyway, I think that I have similar feelings as Miroslav.
> > > > The combination of livepatches and BPF programs increases
> > > > the complexity for all involved parties: core kernel maintainers,
> > > > livepatch and BPF program authors, and system maintainers.
> > > >
> > > > Do we really want to propagate it?
> > > > Is there any significant advantage in combining these two, please?
> > > > Is it significantly easier to write BPF program then a livepatch?
> > > > Is it significantly easier to update BPF programs then livepatches?
> >
> > This is an important feature for avoiding server restarts,
> > particularly in a VM host environment. Since only one VM on the host
> > may be affected by this feature, we can deploy it rapidly without
> > impacting other VMs on the same host.
>
> This does not answer the question why you need the combination
> of livepatch + BPF. Why a livepatch is not enough?

Consider this recent use case from our production servers:

    https://lore.kernel.org/live-patching/CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLT=
h1gy5hy9Yqgeo4C0iA@mail.gmail.com/

In one of our clusters, we needed to route BGP traffic through
specific NICs based on destination IP addresses. To achieve this
without service interruption, we applied a livepatch to
bond_xmit_3ad_xor_slave_get() to introduce a new hook,
bond_get_slave_hook(). We then attached a BPF program to this hook to
select the outgoing NIC by parsing the SKB. Because the destination
IPs must be adjusted on demand, a static livepatch alone was
insufficient; the BPF integration provided the necessary dynamic
flexibility.

>
> Let me repeat the questions:
>
> Is it significantly easier to write BPF program then a livepatch?
> Is it significantly easier to install BPF programs then livepatches?
>
> > > > Would the support of different replace tags help?
> > > > They would allow to replace only livepatches with the same tag.
> >
> > Right, it will help.
>
> Would this make a rapid update of livepatches easy enough so that
> you won't need the BPF part?

As explained above, we cannot rely solely on livepatching to handle
destination IP changes, as these require real-time updates.

--=20
Regards
Yafang

