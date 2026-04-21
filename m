Return-Path: <live-patching+bounces-2410-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIPaMTlB52no5QEAu9opvQ
	(envelope-from <live-patching+bounces-2410-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 11:19:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C1806438BDC
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 11:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2ACBB3009380
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 09:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269E1386C39;
	Tue, 21 Apr 2026 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O2t699Tj"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F53A4F34
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 09:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763174; cv=none; b=uzm74v5nnm19OEqsdsCZ/ZcCN20ugK+iOi19WxsHGfLZisKXmBxwS+7DbNgtDANAZ2o3xNgluGx8b0/3n2Vznyc+rgSDcUcZqzwFWq8O1nn9dMn+EZ35xKVSmcDW2DoTrqYTreB8Fgb+21h5r5RLFcMu4aqe8vURbswG5l2mRS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763174; c=relaxed/simple;
	bh=hqjjierdnK8tvLKU75m7iQooxG9Jq1+vcj806CxQ1fY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUGEKet7O5ldTMoz/8cq/2n+bj9uWRYP3IOf3kICpFjM/F7XaVGR17zynnnAB5AOzPafLjsCODjmFmx5QDoHAJ1ywSTEMidXc9A8gm/VJF7w4EBKjyurpyDlDGHA8cyU7Rsmt05K8MbqFEyPyyTaRKkOfXBllw9IOrGpnQTGNhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O2t699Tj; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43cfde3c3f3so4263255f8f.3
        for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 02:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776763171; x=1777367971; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lB/lqGejdq32Wkl/DU7VEtSFz/Euk52yRw6vT31OnNE=;
        b=O2t699Tj9FK7jfkmiFzV9OWp4Y12g4FucSX1Gzj6WSnxhwJz/xqFBN/ocSNwVBoyiD
         GE4D98zVQ9Zx8fXmBx6ibFM4A3Hb2d3e25D92Xcxxch09e+Ii9nMfmT4A9w3YEgdNjpj
         rn4NKt1W6Eo4+VTtTTr/gh706EKbRqz+Nbl5G/j7c9raNLYpNTLI9GWbKgjkxey+RD1W
         bQN2/fKF4EJIri0TMmdFcmxshPbUA/tqFbGccjSfbynTSperHQ/tFLAkBHpcm88eVOxf
         RBOp9f1Dgo3bCHymHtS2EN1jUSJDmFuImUS/t/+SYSK5PKk+dSnoiu2kQAIoLu0k4AWG
         zW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776763171; x=1777367971;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lB/lqGejdq32Wkl/DU7VEtSFz/Euk52yRw6vT31OnNE=;
        b=H29cFLlF+8QuMFP82SNVRcMF9ogfSAdMbyNYOULoTG2g4suSzLOj/mE8StBkuQCfAc
         q9LURhW/BUl90nIDOMJ8YeHsci/duXLQ0x7RMaqoguF3zC5bKE4tfBO92WuFYi7PKteN
         BiOVbb3plgAz9C7LdY7dQvj6SQ8/kow4Sq18J64aQZjn1SGt6iUCYbdULIGwL0n+B+Z0
         ADdSPDRE27omXpcOzXD+gDq/JsZDsLYalLazg0c1VAOtZEFxFTqNVG1rZdmjY+iYVChY
         31p88xRHRgDnsbbSWR56gnEc/NXnQEnWejPTssz3bkAU1qGYoqI/RwaiStlJ0d0j4DQ2
         cwcg==
X-Forwarded-Encrypted: i=1; AFNElJ+RoXcsRJudd+BKIQduo2wCEFz0PcN4gdLE4dy2JxnvindAmENQdWqCIlRp2/aMzKz9Te3gXqCWnUGUsx6p@vger.kernel.org
X-Gm-Message-State: AOJu0YzAnU0iHxjZlqJQraIo6iUG0tLMwVUhvZNZbjQ6HqlEqkjtreKw
	dfMnS6loNXGGExGyVsfqBoV17VSqYtrnWlfX6NrQcEllyRoGw7I6KShV+HLvQB02/XM=
X-Gm-Gg: AeBDievhQwaoqost2zS1RwMvk5BsXkb+2WWgrTaAgd56l8TwWga8WxnclkrCLKw5Au0
	jGTLLNQ01v8hlRPG/yLp/3IC3M7qDnxNd3xh6cMhCOzVtwYtXr/tHqz8NYkyyEmnaM4qbHDoZBl
	tWYCeT6yDRbIF+eI2SuX4UTuD1nfY/d+1j3XcHitsua0TKHQkKQdO9UphZu926lHkJ5ZDZI3UWx
	JOsEv07O32p3n5CqXIml/Ld8lifLgsv+3+2MlHLbbnvONBW83TPT0unRxBd5ekp0SKqOQ3KnO1f
	5IUqe1kAE5lizFuXNX5NirU9m9SWYc9GFyTVB+NLxldyqjCJ/hL4Sj843dGgEsqEYk0Tlm/SxlT
	CDqI1xQCpd1OOwbjM8EJIh3bWxtRu7Gw7u2DJTguXpg9WT98biiX5oFThbVpQyGzWi+VbQP+DbL
	nkoKrvqiGDpM2qLkmYKoAaS6A09gGsYmsLHA27cwulj+tDdjj4qdM=
X-Received: by 2002:a05:6000:24c3:b0:43d:dd:8ca4 with SMTP id ffacd0b85a97d-43fe3dd33d4mr27397358f8f.14.1776763170663;
        Tue, 21 Apr 2026 02:19:30 -0700 (PDT)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cc0d51sm35517843f8f.10.2026.04.21.02.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 02:19:29 -0700 (PDT)
Date: Tue, 21 Apr 2026 11:19:26 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH] samples/livepatch: Add BPF struct_ops integration sample
Message-ID: <aedBHr4F0hTsY5x3@pathway.suse.cz>
References: <20260416001628.2062468-1-song@kernel.org>
 <CALOAHbDSpofLCQ-LCU2uVtkc9w+zib0PPgBr+6sEv5FD5+Hd=g@mail.gmail.com>
 <CAPhsuW5=oXwQQyOU7Hf6Qf5=tK=-J75Xr+p+dcGiPs2vVEeMFw@mail.gmail.com>
 <aeIzhNyvYaR2Krrq@pathway.suse.cz>
 <CAPhsuW6Z91qAM7G=iA_APX4Jfa8a0pshnGSTYn0+JXKsUfEVqQ@mail.gmail.com>
 <CALOAHbCQ_0uuDnLujgEo3mnFucUih_w44B86wjpa61GxpG0NGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbCQ_0uuDnLujgEo3mnFucUih_w44B86wjpa61GxpG0NGA@mail.gmail.com>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2410-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email]
X-Rspamd-Queue-Id: C1806438BDC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun 2026-04-19 11:19:19, Yafang Shao wrote:
> On Fri, Apr 17, 2026 at 11:52 PM Song Liu <song@kernel.org> wrote:
> >
> > On Fri, Apr 17, 2026 at 6:20 AM Petr Mladek <pmladek@suse.com> wrote:
> > >
> > > On Thu 2026-04-16 09:32:46, Song Liu wrote:
> > [...]
> > > Let' use the code from this patch:
> > >
> > > static int __init livepatch_bpf_init(void)
> > > {
> > >         int ret;
> > >
> > >         ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> > >                                         &klp_bpf_kfunc_set);
> > >         ret = ret ?: register_bpf_struct_ops(&bpf_klp_bpf_cmdline_ops,
> > >                                              klp_bpf_cmdline_ops);
> > >         if (ret)
> > >                 return ret;
> > >
> > > --->    /*
> > > --->     * We would need to wait here until the BPF program gets loaded.
> > > --->     * for the new bpf_struct_ops in this new livepatch.
> > > --->     */
> 
> No waiting is necessary. If the BPF program is not attached, the
> default logic can be executed instead.

But it means a regression. I guess that you need the BPF program
for a reason. The default logic is not good enough indeed.

> Consider Song's test case: we can handle it as follows.
> 
> static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
> {
>     struct klp_bpf_cmdline_ops *ops = READ_ONCE(active_ops);
> 
>     if (ops && ops->set_cmdline)
>         return ops->set_cmdline(m);
> 
>     // If no BPF program is attached, the default kernel function runs.
>     return cmdline_proc_show(m, v);
> }
> 
> However, as Song explained below, if we want atomic replace to work,
> we may need to wait for the new BPF program here. But that would make
> the combination of livepatch and BPF more complex.
> 
> Currently, on our production servers, we handle this through a user
> script, such as:
> 
>   stop_traffic_relying_on_livepatch_bpf
>   kpatch load new-livepatch-bpf-module.ko
>   reattach_the_bpf_program
>   start_the_traffic_again
> 
> Although this approach requires restarting the affected traffic, other
> services running on the same server remain unaffected.

We put a lot of effort to make livepatching as less disruptive
as possible. The atomic replace is supposed to work without
any disruption.

> > >         return klp_enable_patch(&patch);
> > > }
> >
> > Yes, something in this direction is needed to make atomic replace work.
> > We have no plan to use this in production. I will let Yafang figure out
> > his plan.
> >
> > > Or maybe, the bpf_struct_ops can be _allocated dynamically_ and
> > > the pointer might be _passed via shadow variables_.
> > >
> > > One problem is that shadow variables would add another overhead
> > > and need not be suitable for hot paths.
> > >
> > >
> > > Anyway, I think that I have similar feelings as Miroslav.
> > > The combination of livepatches and BPF programs increases
> > > the complexity for all involved parties: core kernel maintainers,
> > > livepatch and BPF program authors, and system maintainers.
> > >
> > > Do we really want to propagate it?
> > > Is there any significant advantage in combining these two, please?
> > > Is it significantly easier to write BPF program then a livepatch?
> > > Is it significantly easier to update BPF programs then livepatches?
> 
> This is an important feature for avoiding server restarts,
> particularly in a VM host environment. Since only one VM on the host
> may be affected by this feature, we can deploy it rapidly without
> impacting other VMs on the same host.

This does not answer the question why you need the combination
of livepatch + BPF. Why a livepatch is not enough?

Let me repeat the questions:

Is it significantly easier to write BPF program then a livepatch?
Is it significantly easier to install BPF programs then livepatches?

> > > Would the support of different replace tags help?
> > > They would allow to replace only livepatches with the same tag.
> 
> Right, it will help.

Would this make a rapid update of livepatches easy enough so that
you won't need the BPF part?

Best Regards,
Petr

