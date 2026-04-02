Return-Path: <live-patching+bounces-2279-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4B8XB8plzmmXnQYAu9opvQ
	(envelope-from <live-patching+bounces-2279-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 14:49:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D07F3893B2
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 14:49:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0D103301C8F5
	for <lists+live-patching@lfdr.de>; Thu,  2 Apr 2026 12:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C943E1201;
	Thu,  2 Apr 2026 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mdpsL6VZ"
X-Original-To: live-patching@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38623CAE74
	for <live-patching@vger.kernel.org>; Thu,  2 Apr 2026 12:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775134143; cv=none; b=jwYh1I2Tj5ENbtidGkPbvhcDpu2hbCIRkVJrAotl0//Sh3ZtlOVW01pdfg4RKi5dURZ/rvqPImSZfR+qIRPO9KGBx7xIy1GhWepg2BGQ8vZu9K0MjDwBRES8QoKThPI5i34QYepRwpJ5nUqWATr4ii5fXRF4RbA9R+RQit5xVss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775134143; c=relaxed/simple;
	bh=GwzbYHcb1qdCaSphuvTjE9xEXNlvYk0Sd0NL1Y8zGG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0+RZO8qCdZ0QK73NMlw/E18FwJfIfTDwx+GTUQlri7FPjQwEJEkXSX3DhLJ09PQ9bH9ksooxUB1F+/iiav3e96zqFhhgwxXN8KY3Z0PouhPGfyrosVJ4bh08ytksw5t0p+ZCtIVqQeZUFBqG4Gx3VwbVZ3VzrZH9D3XX0iixT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mdpsL6VZ; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775134132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c83JoqeMLXdZmjzNRF6o7KLJNuH8aTVtb6ay845K+fk=;
	b=mdpsL6VZN+fifI1A8+BQtMWCZ0245st3OemBQ8MKxSbtCsaGtZYnFyvxilr/SL9IC1rxUb
	J4AXdSk7SC+7ha4PkKDfCv/7vPR5Jv1EVFa4q5FtLQDiLhO/EBprCD1HfJOf559bW1aTOq
	ZwpkuR7+gnaTCFucQsOE68H34HuAzC4=
From: Menglong Dong <menglong.dong@linux.dev>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com,
 song@kernel.org, jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com,
 yonghong.song@linux.dev, Yafang Shao <laoar.shao@gmail.com>,
 live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject:
 Re: [RFC PATCH 2/4] trace: Allow kprobes to override livepatched functions
Date: Thu, 02 Apr 2026 20:48:21 +0800
Message-ID: <2261072.irdbgypaU6@7950hx>
In-Reply-To: <20260402092607.96430-3-laoar.shao@gmail.com>
References:
 <20260402092607.96430-1-laoar.shao@gmail.com>
 <20260402092607.96430-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Migadu-Flow: FLOW_OUT
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	CTE_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2279-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[menglong.dong@linux.dev,live-patching@vger.kernel.org];
	FREEMAIL_CC(0.00)[kernel.org,suse.cz,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1D07F3893B2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 2026/4/2 17:26, Yafang Shao wrote:
> Introduce the ability for kprobes to override the return values of
> functions that have been livepatched. This functionality is guarded by the
> CONFIG_KPROBE_OVERRIDE_KLP_FUNC configuration option.

Hi, Yafang. This is a interesting idea.

For now, the bpf_override_return() can only be used on the kernel
functions that allow error injection to prevent the BPF program from
crash the kernel. If we use it on the kernel functions that patched
by the KLP, we can crash the kernel easily by return a invalid value
with bpf_override_return(), right? (Of course, we can crash the kernel
easily with KLP too ;)

I haven't figure out the use case yet. Can KLP be used together with
the BPF program that use bpf_override_return()? The KLP will modify
the RIP on the stack, and the bpf_override_return() will modify it too.
AFAIK, there can't be two ftrace_ops that both have the
FTRACE_OPS_FL_IPMODIFY flag. Did I miss something?

It will be helpful for me to understand the use case if a selftests is
offered :)

BTW, if we allow the usage of bpf_override_return() on the KLP patched
function, we should allow the usage of BPF_MODIFY_RETURN on this
case too, right?

Thanks!
Menglong Dong

> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  kernel/trace/Kconfig        | 14 ++++++++++++++
>  kernel/trace/bpf_trace.c    |  3 ++-
>  kernel/trace/trace_kprobe.c | 17 +++++++++++++++++
>  kernel/trace/trace_probe.h  |  5 +++++
>  4 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 49de13cae428..db712c8cb745 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -1279,6 +1279,20 @@ config HIST_TRIGGERS_DEBUG
>  
>            If unsure, say N.
>  
> +config KPROBE_OVERRIDE_KLP_FUNC
> +	bool "Allow kprobes to override livepatched functions"
> +	depends on KPROBES && LIVEPATCH
> +	help
> +	  This option allows BPF programs to use kprobes to override functions
> +	  that have already been patched by Livepatch (KLP).
> +
> +	  Enabling this provides a mechanism to dynamically control execution
> +	  flow without requiring a reboot or a new livepatch module. It
> +	  effectively combines the persistence of livepatching with the
> +	  programmability of BPF.
> +
> +	  If unsure, say N.
> +
>  source "kernel/trace/rv/Kconfig"
>  
>  endif # FTRACE
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index c901ace836cb..08ae2b1a912c 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1935,7 +1935,8 @@ int perf_event_attach_bpf_prog(struct perf_event *event,
>  		if (!tp)
>  			return -EINVAL;
>  		if (!trace_kprobe_on_func_entry(tp) ||
> -		    !trace_kprobe_error_injectable(tp))
> +		    (!trace_kprobe_error_injectable(tp) &&
> +		     !trace_kprobe_klp_func_overridable(tp)))
>  			return -EINVAL;
>  	}
>  
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 768702674a5c..6f05451fbc76 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -213,6 +213,23 @@ bool trace_kprobe_error_injectable(struct trace_kprobe *tp)
>  	return within_error_injection_list(trace_kprobe_address(tp));
>  }
>  
> +bool trace_kprobe_klp_func_overridable(struct trace_kprobe *tp)
> +{
> +	bool overridable = false;
> +#ifdef CONFIG_KPROBE_OVERRIDE_KLP_FUNC
> +	struct module *mod;
> +	unsigned long addr;
> +
> +	addr = trace_kprobe_address(tp);
> +	rcu_read_lock();
> +	mod = __module_address(addr);
> +	if (mod && mod->klp)
> +		overridable = true;
> +	rcu_read_unlock();
> +#endif
> +	return overridable;
> +}
> +
>  static int register_kprobe_event(struct trace_kprobe *tk);
>  static int unregister_kprobe_event(struct trace_kprobe *tk);
>  
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 958eb78a9068..84bd2617db7c 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -271,6 +271,7 @@ struct trace_kprobe {
>  #ifdef CONFIG_KPROBE_EVENTS
>  bool trace_kprobe_on_func_entry(struct trace_kprobe *tp);
>  bool trace_kprobe_error_injectable(struct trace_kprobe *tp);
> +bool trace_kprobe_klp_func_overridable(struct trace_kprobe *tp);
>  #else
>  static inline bool trace_kprobe_on_func_entry(struct trace_kprobe *tp)
>  {
> @@ -281,6 +282,10 @@ static inline bool trace_kprobe_error_injectable(struct trace_kprobe *tp)
>  {
>  	return false;
>  }
> +static inline bool trace_kprobe_klp_func_overridable(struct trace_kprobe *tp)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_KPROBE_EVENTS */
>  
>  static inline unsigned int trace_probe_load_flag(struct trace_probe *tp)
> 





