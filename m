Return-Path: <live-patching+bounces-2280-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JVQFiNuzmnxngYAu9opvQ
	(envelope-from <live-patching+bounces-2280-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 15:24:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C50389A4C
	for <lists+live-patching@lfdr.de>; Thu, 02 Apr 2026 15:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EA3D23013896
	for <lists+live-patching@lfdr.de>; Thu,  2 Apr 2026 13:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7084388392;
	Thu,  2 Apr 2026 13:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bujKVQcS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37EE34B661;
	Thu,  2 Apr 2026 13:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775135589; cv=none; b=eb3nDj1A510U3ceL1nApyeE0vtLLhsMoOIZFibwlk0rnghRJf7Zb2Sh6oKRXO/fkO+oJ3qL290qPs4K5M7whESQ07mecntggrlpq+8TDFwc7OQUdAh4F6uKIYcmUQSxd7ErMKjcWe0YrS5QiiwOi90WmvtxYCKkdHeE6AaEk3qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775135589; c=relaxed/simple;
	bh=dtvD+0d6PLGlXTzCklFJtpqXzOFx5lbqIcfTjfd1ONg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=lFvWdcCmm7paprGliA7ZtqOFi3cAmmFzCIBg0KyF2Y/8JYR06tEzm/5ArpJP8Jh2tWwahLmOp7Y5GaiDbQtvEk7xmXOJ+rvVBNzmwK8Mo5A2C5R4MOhHuO6J+qcAidxVkfOmmvwVIeXR1wfIsov34uJtyVDf7OqXUdPFXnDuXaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bujKVQcS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA3EC116C6;
	Thu,  2 Apr 2026 13:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775135589;
	bh=dtvD+0d6PLGlXTzCklFJtpqXzOFx5lbqIcfTjfd1ONg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bujKVQcSbihHaZa/0OJotxjt82t00R1fVbxKclchXEJHRtHL2JMyxcpHueykbhql3
	 NUZJRTRHcgaMkUMiBPukPVpOebbIttbNy2ED+WEI5a82iVlcv1cK60DuaTmqOWlge3
	 JCtmm8rHTbT98T/VTbBWKDPdr3OKSI25lBlys37JBN0r/n9q1i3duOF4N6aOGAwfPm
	 caC6GI5HKNtfF1qGqF35ZS+T5rWhGi1Qc5Tt+VaLp/hw9DvhD0y0bqQzyHoA5zimvZ
	 E4lQxXxfOWriPPcPjubhKlMcquOtIdT/H2kE++RuJvUJMrc560DoL/UwipIrHk33rl
	 qkfBZcK2m26og==
Date: Thu, 2 Apr 2026 22:13:01 +0900
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
Subject: Re: [RFC PATCH 1/4] trace: Simplify kprobe overridable function
 check
Message-Id: <20260402221301.88000892c71eb33c0d4a6f79@kernel.org>
In-Reply-To: <20260402092607.96430-2-laoar.shao@gmail.com>
References: <20260402092607.96430-1-laoar.shao@gmail.com>
	<20260402092607.96430-2-laoar.shao@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2280-lists,live-patching=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.990];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C3C50389A4C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu,  2 Apr 2026 17:26:04 +0800
Yafang Shao <laoar.shao@gmail.com> wrote:

> Simplify the logic for checking overridable kprobe functions by removing
> redundant code.
> 
> No functional change.

NACK.

trace_kprobe must be hidden inside the trace_kprobe.c. It is not
designed to be exposed. 

Thank you,

> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  kernel/trace/bpf_trace.c    | 13 ++++++---
>  kernel/trace/trace_kprobe.c | 40 +++++----------------------
>  kernel/trace/trace_probe.h  | 54 ++++++++++++++++++++++++++-----------
>  3 files changed, 54 insertions(+), 53 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 0b040a417442..c901ace836cb 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1929,10 +1929,15 @@ int perf_event_attach_bpf_prog(struct perf_event *event,
>  	 * Kprobe override only works if they are on the function entry,
>  	 * and only if they are on the opt-in list.
>  	 */
> -	if (prog->kprobe_override &&
> -	    (!trace_kprobe_on_func_entry(event->tp_event) ||
> -	     !trace_kprobe_error_injectable(event->tp_event)))
> -		return -EINVAL;
> +	if (prog->kprobe_override) {
> +		struct trace_kprobe *tp = trace_kprobe_primary_from_call(event->tp_event);
> +
> +		if (!tp)
> +			return -EINVAL;
> +		if (!trace_kprobe_on_func_entry(tp) ||
> +		    !trace_kprobe_error_injectable(tp))
> +			return -EINVAL;
> +	}
>  
>  	mutex_lock(&bpf_event_mutex);
>  
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index a5dbb72528e0..768702674a5c 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -53,17 +53,6 @@ static struct dyn_event_operations trace_kprobe_ops = {
>  	.match = trace_kprobe_match,
>  };
>  
> -/*
> - * Kprobe event core functions
> - */
> -struct trace_kprobe {
> -	struct dyn_event	devent;
> -	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
> -	unsigned long __percpu *nhit;
> -	const char		*symbol;	/* symbol name */
> -	struct trace_probe	tp;
> -};
> -
>  static bool is_trace_kprobe(struct dyn_event *ev)
>  {
>  	return ev->ops == &trace_kprobe_ops;
> @@ -212,33 +201,16 @@ unsigned long trace_kprobe_address(struct trace_kprobe *tk)
>  	return addr;
>  }
>  
> -static nokprobe_inline struct trace_kprobe *
> -trace_kprobe_primary_from_call(struct trace_event_call *call)
> -{
> -	struct trace_probe *tp;
> -
> -	tp = trace_probe_primary_from_call(call);
> -	if (WARN_ON_ONCE(!tp))
> -		return NULL;
> -
> -	return container_of(tp, struct trace_kprobe, tp);
> -}
> -
> -bool trace_kprobe_on_func_entry(struct trace_event_call *call)
> +bool trace_kprobe_on_func_entry(struct trace_kprobe *tp)
>  {
> -	struct trace_kprobe *tk = trace_kprobe_primary_from_call(call);
> -
> -	return tk ? (kprobe_on_func_entry(tk->rp.kp.addr,
> -			tk->rp.kp.addr ? NULL : tk->rp.kp.symbol_name,
> -			tk->rp.kp.addr ? 0 : tk->rp.kp.offset) == 0) : false;
> +	return !kprobe_on_func_entry(tp->rp.kp.addr,
> +			tp->rp.kp.addr ? NULL : tp->rp.kp.symbol_name,
> +			tp->rp.kp.addr ? 0 : tp->rp.kp.offset);
>  }
>  
> -bool trace_kprobe_error_injectable(struct trace_event_call *call)
> +bool trace_kprobe_error_injectable(struct trace_kprobe *tp)
>  {
> -	struct trace_kprobe *tk = trace_kprobe_primary_from_call(call);
> -
> -	return tk ? within_error_injection_list(trace_kprobe_address(tk)) :
> -	       false;
> +	return within_error_injection_list(trace_kprobe_address(tp));
>  }
>  
>  static int register_kprobe_event(struct trace_kprobe *tk);
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 9fc56c937130..958eb78a9068 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -30,6 +30,7 @@
>  
>  #include "trace.h"
>  #include "trace_output.h"
> +#include "trace_dynevent.h"
>  
>  #define MAX_TRACE_ARGS		128
>  #define MAX_ARGSTR_LEN		63
> @@ -210,21 +211,6 @@ DECLARE_BASIC_PRINT_TYPE_FUNC(symbol);
>  #define ASSIGN_FETCH_TYPE_END {}
>  #define MAX_ARRAY_LEN	64
>  
> -#ifdef CONFIG_KPROBE_EVENTS
> -bool trace_kprobe_on_func_entry(struct trace_event_call *call);
> -bool trace_kprobe_error_injectable(struct trace_event_call *call);
> -#else
> -static inline bool trace_kprobe_on_func_entry(struct trace_event_call *call)
> -{
> -	return false;
> -}
> -
> -static inline bool trace_kprobe_error_injectable(struct trace_event_call *call)
> -{
> -	return false;
> -}
> -#endif /* CONFIG_KPROBE_EVENTS */
> -
>  struct probe_arg {
>  	struct fetch_insn	*code;
>  	bool			dynamic;/* Dynamic array (string) is used */
> @@ -271,6 +257,32 @@ struct event_file_link {
>  	struct list_head		list;
>  };
>  
> +/*
> + * Kprobe event core functions
> + */
> +struct trace_kprobe {
> +	struct dyn_event	devent;
> +	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
> +	unsigned long __percpu	*nhit;
> +	const char		*symbol;	/* symbol name */
> +	struct trace_probe	tp;
> +};
> +
> +#ifdef CONFIG_KPROBE_EVENTS
> +bool trace_kprobe_on_func_entry(struct trace_kprobe *tp);
> +bool trace_kprobe_error_injectable(struct trace_kprobe *tp);
> +#else
> +static inline bool trace_kprobe_on_func_entry(struct trace_kprobe *tp)
> +{
> +	return false;
> +}
> +
> +static inline bool trace_kprobe_error_injectable(struct trace_kprobe *tp)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_KPROBE_EVENTS */
> +
>  static inline unsigned int trace_probe_load_flag(struct trace_probe *tp)
>  {
>  	return smp_load_acquire(&tp->event->flags);
> @@ -329,6 +341,18 @@ trace_probe_primary_from_call(struct trace_event_call *call)
>  	return list_first_entry_or_null(&tpe->probes, struct trace_probe, list);
>  }
>  
> +static nokprobe_inline struct trace_kprobe *
> +trace_kprobe_primary_from_call(struct trace_event_call *call)
> +{
> +	struct trace_probe *tp;
> +
> +	tp = trace_probe_primary_from_call(call);
> +	if (WARN_ON_ONCE(!tp))
> +		return NULL;
> +
> +	return container_of(tp, struct trace_kprobe, tp);
> +}
> +
>  static inline struct list_head *trace_probe_probe_list(struct trace_probe *tp)
>  {
>  	return &tp->event->probes;
> -- 
> 2.47.3
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

