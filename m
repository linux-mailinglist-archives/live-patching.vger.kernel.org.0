Return-Path: <live-patching+bounces-2349-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBpDK2rg3mkOMAAAu9opvQ
	(envelope-from <live-patching+bounces-2349-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 02:48:42 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E6123FF5DD
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 02:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0DE933071700
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2026 00:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A0A283FEA;
	Wed, 15 Apr 2026 00:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyN3Hygk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2961AB6F1;
	Wed, 15 Apr 2026 00:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776214115; cv=none; b=AD8ix5KKYLUQtfWtoYbA4OFyjSk0MsQ09CYIx2G4m6ApTsjo5Lt31oqyGVTa0oahwZU+BtLJ9yz4fW2ylRwyr+LAVkwUZ/V4EB7KNvlKOFEBh7olEQ/Cuouq59HJUCWBNBTqxjXYv4mBrwVw1R/Y9ejeIfdjA1VRm7IBOiaJa/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776214115; c=relaxed/simple;
	bh=mW91gxYwTlvKqUJGoRBY+v2gmJFrE5XfEZD9VwbzElw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=rDny4hAXj4HkQDXrG4GGQrmtsp22wz61uPq8RzwZuGMTxWkStZ04zgj9gLpF/iZuyswejg6wKxwwqDpFF3Ng7UEjlNnGQeVqfNjoE8GXGhh32whPnYQzD80OpWazdoqJyXQoIpmPmJZMHkqKP3yxAZ3/30cR3I6EGqM4MjH6ph8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyN3Hygk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F53C19425;
	Wed, 15 Apr 2026 00:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776214115;
	bh=mW91gxYwTlvKqUJGoRBY+v2gmJFrE5XfEZD9VwbzElw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MyN3HygkKkxkd/IkpE75BE+GrsvxDwO1y/n3zWRajh41BWuHrOFmJZ+IpbFICR0gF
	 9cK6Uv/Aup5KaPKz8817etI4ueOJeDeeaYDjhB7oKlOy3t24+9faZKngJ1hEJDEsz8
	 ahteyawo+JsqIM+JsKrGHknlv8z9J1RmZhK5LgN4gwke2/8yibJI5OAYZb8Vz4XxTe
	 tVMMNrJHs76ntX9dfcUfamBxfHors3YGi3+ydZy50Fh3fUvA78CkSj+zdQmv66EEI4
	 dBZEq3hyWz5yxZVqp/5G6p6iVhwkR076lw9p910xWCtCi0nfGfflXvTH6rYfhCNyV+
	 nlusYRe68f33g==
Date: Wed, 15 Apr 2026 09:48:28 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com, rostedt@goodmis.org,
 mathieu.desnoyers@efficios.com, kpsingh@kernel.org,
 mattbobrowski@google.com, song@kernel.org, jolsa@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com,
 yonghong.song@linux.dev, live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] trace, livepatch: Allow kprobe return
 overriding for livepatched functions
Message-Id: <20260415094828.479ad388ac1eb5cd7ee84535@kernel.org>
In-Reply-To: <CALOAHbAOx=C4b+4xQwRf59xvY0vbMPfOjO5LMDghC4Ryksv++Q@mail.gmail.com>
References: <20260402092607.96430-1-laoar.shao@gmail.com>
	<20260410133844.56ab7964da7628d1c3482acb@kernel.org>
	<CALOAHbAOx=C4b+4xQwRf59xvY0vbMPfOjO5LMDghC4Ryksv++Q@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2349-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mhiramat@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_TWELVE(0.00)[23];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 2E6123FF5DD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, 12 Apr 2026 21:50:31 +0800
Yafang Shao <laoar.shao@gmail.com> wrote:

> On Fri, Apr 10, 2026 at 12:38 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > Hi Yafang,
> >
> > On Thu,  2 Apr 2026 17:26:03 +0800
> > Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > > Livepatching allows for rapid experimentation with new kernel features
> > > without interrupting production workloads. However, static livepatches lack
> > > the flexibility required to tune features based on task-specific attributes,
> > > such as cgroup membership, which is critical in multi-tenant k8s
> > > environments. Furthermore, hardcoding logic into a livepatch prevents
> > > dynamic adjustments based on the runtime environment.
> > >
> > > To address this, we propose a hybrid approach using BPF. Our production use
> > > case involves:
> > >
> > > 1. Deploying a Livepatch function to serve as a stable BPF hook.
> > >
> > > 2. Utilizing bpf_override_return() to dynamically modify the return value
> > >    of that hook based on the current task's context.
> >
> > First of all, I don't like this approach to test a new feature in the
> > kernel, because it sounds like allowing multiple different generations
> > of implementations to coexist simultaneously. The standard kernel code
> > is not designed to withstand such implementations.
> 
> However, this approach is invaluable for rapidly deploying new kernel
> features to production servers without downtime. Upgrading kernels
> across a large fleet remains a significant challenge.

I think that downtime should be accepted as a cost for stability in
general. If your new kernel feature has a bug and causes a crash,
anyway it gets your servers down.

> >
> > For example, if you implement a well-designed framework in a specific
> > subsystem, like Schedext, which allows multiple implementations extended
> > with BPF to coexist, there's no problem (at least it's debatable).
> >
> > But if it is for any function, it is dangerous feature. Bugs that occur
> > in kernels that use this functionality cannot be addressed here. They
> > need to be treated the same way as out-of-tree drivers or forked kernels.
> > I mean, add a tainted flag for this feature. And we don't care of it.
> 
> Agreed. This should be handled as an OOT module rather than part of
> the core kernel.
> 
> >
> > >
> > > A significant challenge arises when atomic-replace is enabled. In this
> > > mode, deploying a new livepatch changes the target function's address,
> > > forcing a re-attachment of the BPF program. This re-attachment latency is
> > > unacceptable in critical paths, such as those handling networking policies.
> > >
> > > To solve this, we introduce a hybrid livepatch mode that allows specific
> > > patches to remain non-replaceable, ensuring the function address remains
> > > stable and the BPF program stays attached.
> >
> > Can you share your actual problem to be solved?
> 
> Here is an example we recently deployed on our production servers:
> 
>   https://lore.kernel.org/bpf/CALOAHbDnNba_w_nWH3-S9GAXw0+VKuLTh1gy5hy9Yqgeo4C0iA@mail.gmail.com/
> 
> In one of our specific clusters, we needed to send BGP traffic out
> through specific NICs based on the destination IP. To achieve this
> without interrupting service, we live-patched
> bond_xmit_3ad_xor_slave_get(), added a new hook called
> bond_get_slave_hook(), and then ran a BPF program attached to that
> hook to select the outgoing NIC from the SKB. This allowed us to
> rapidly deploy the feature with zero downtime.

In this case, you can make specific livepatch or kernel module
to replace the kernel function without using BPF on your server.

The BGP trafic in bonding device seems very specific, so it may not
cause a trouble, but this is very generic change, which allows
user to change more core kernel feature, e.g. memory management
or scheduler etc.

Excessive degrees of freedom introduce uncertainty and instability
into a system. While the functionality is interesting, it would be
a way to generalize schedext in an uncontrolled way.

At a minimum, some form of build time and runtime constraint, along
with a taint flag that clearly indicates in the crash logs that this
feature is being used, would be necessary. (It means this is should
not be used in production environment.)

Thank you,
> 
> [...]
> 
> -- 
> Regards
> Yafang


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

