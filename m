Return-Path: <live-patching+bounces-2328-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UKhmD99+2GlSeAgAu9opvQ
	(envelope-from <live-patching+bounces-2328-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 10 Apr 2026 06:38:55 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 915703D21BC
	for <lists+live-patching@lfdr.de>; Fri, 10 Apr 2026 06:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B337F3011123
	for <lists+live-patching@lfdr.de>; Fri, 10 Apr 2026 04:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C375A332601;
	Fri, 10 Apr 2026 04:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTUAysVx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB7B284B3B;
	Fri, 10 Apr 2026 04:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775795929; cv=none; b=pmh0cW8ZPeD6J8HYRBQKVOtweuzYDoC4/HRFkiHw/vYzMN39SnqzjIE8E5RyjX/PZhnCISMLm8AxQGQOKrmVTwtuPL7721tDVldHTHLnnW5cVTOR4N59qw+zxQTi6xFiFEaVvoym0vz85OXzrtgS4/iZmTaw7cOt2AbqOee3Dfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775795929; c=relaxed/simple;
	bh=FmXdg4PVg6nOMJQniMxzVUWTu8cQuElt+wDMuGSqKDU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=KPur9Y2KqOKg5GnQ8G7T3ynKJodjLdLrn5APo/2XujnxagOAb+G3nZhhi1E1tev5a/6mLvIawqucq5zln0nbmmGf0PDaF5PrNM5kcExg4xIfW5zqln2aecM0mCHECAttlRxVNmipcYXdijVKqtTCzWnZGqjP+xY4ePpIwZkIMuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mTUAysVx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F04C19421;
	Fri, 10 Apr 2026 04:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775795929;
	bh=FmXdg4PVg6nOMJQniMxzVUWTu8cQuElt+wDMuGSqKDU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mTUAysVxViK0zKzSxW3w8s8hTeWAJZwRuh1I/HuaFJFE69YL1/L629kHZzuzje3O0
	 OYsta+wMcZtVV/xTU2dF1ZLZRwG7tHXCainc244ppQT4L4ZeSdAsFZzobEa1F43jc+
	 5D3DYAcYSdoPjGeCrzcvgQJkOy4cGEnKlvYXrBG05m3PJ87ZYHmxL6mGMiBPn0Cwg4
	 KBg+T2t4sjpQpqIxBxQH5yDRf8eJJjvbBAbQMLn/83/mtXn1hJhcT034/8TDLojYQ2
	 109X2G701SWSKWkHwvO1yrOelNSCLVT+hznf3pcQ4s1tObhC6CvoZnDpaZIHaswT1w
	 zzelgB4x9EfWg==
Date: Fri, 10 Apr 2026 13:38:44 +0900
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
Message-Id: <20260410133844.56ab7964da7628d1c3482acb@kernel.org>
In-Reply-To: <20260402092607.96430-1-laoar.shao@gmail.com>
References: <20260402092607.96430-1-laoar.shao@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2328-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mhiramat@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 915703D21BC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Yafang,

On Thu,  2 Apr 2026 17:26:03 +0800
Yafang Shao <laoar.shao@gmail.com> wrote:

> Livepatching allows for rapid experimentation with new kernel features
> without interrupting production workloads. However, static livepatches lack
> the flexibility required to tune features based on task-specific attributes,
> such as cgroup membership, which is critical in multi-tenant k8s
> environments. Furthermore, hardcoding logic into a livepatch prevents
> dynamic adjustments based on the runtime environment.
> 
> To address this, we propose a hybrid approach using BPF. Our production use
> case involves:
> 
> 1. Deploying a Livepatch function to serve as a stable BPF hook.
> 
> 2. Utilizing bpf_override_return() to dynamically modify the return value
>    of that hook based on the current task's context.

First of all, I don't like this approach to test a new feature in the
kernel, because it sounds like allowing multiple different generations
of implementations to coexist simultaneously. The standard kernel code
is not designed to withstand such implementations.

For example, if you implement a well-designed framework in a specific
subsystem, like Schedext, which allows multiple implementations extended
with BPF to coexist, there's no problem (at least it's debatable).

But if it is for any function, it is dangerous feature. Bugs that occur
in kernels that use this functionality cannot be addressed here. They
need to be treated the same way as out-of-tree drivers or forked kernels.
I mean, add a tainted flag for this feature. And we don't care of it.

> 
> A significant challenge arises when atomic-replace is enabled. In this
> mode, deploying a new livepatch changes the target function's address,
> forcing a re-attachment of the BPF program. This re-attachment latency is
> unacceptable in critical paths, such as those handling networking policies.
> 
> To solve this, we introduce a hybrid livepatch mode that allows specific
> patches to remain non-replaceable, ensuring the function address remains
> stable and the BPF program stays attached.

Can you share your actual problem to be solved? 
If the specific problem and the specific subsystem are clear,
I think there is room to discuss it with the subsystem maintainer.

> 
> Furthermore, this mechanism provides a lower-maintenance alternative to
> out-of-tree BPF hooks. Given the complexities of upstreaming custom BPF
> hooks (e.g., [0], [1]), this hybrid mode allows for the maintenance of
> stable, minimal hook points via livepatching with significantly reduced
> maintenance burden.

Maintenance cost is the same. We need to add out-of-tree BPF hooks on
source code. Maybe deploying cost will be reduced.

Thank you,

> 
> Link: https://lwn.net/Articles/1054030/ [0]
> Link: https://lwn.net/Articles/1043548/ [1]
> 
> Yafang Shao (4):
>   trace: Simplify kprobe overridable function check
>   trace: Allow kprobes to override livepatched functions
>   livepatch: Add "replaceable" attribute to klp_patch
>   livepatch: Implement livepatch hybrid mode
> 
>  include/linux/livepatch.h   |  2 ++
>  kernel/livepatch/core.c     | 50 +++++++++++++++++++++++++++++++
>  kernel/trace/Kconfig        | 14 +++++++++
>  kernel/trace/bpf_trace.c    | 14 ++++++---
>  kernel/trace/trace_kprobe.c | 49 ++++++++++++------------------
>  kernel/trace/trace_probe.h  | 59 +++++++++++++++++++++++++++----------
>  6 files changed, 139 insertions(+), 49 deletions(-)
> 
> -- 
> 2.47.3
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

