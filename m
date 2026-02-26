Return-Path: <live-patching+bounces-2089-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNPwDxgnoGlEfwQAu9opvQ
	(envelope-from <live-patching+bounces-2089-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 11:57:28 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 937DB1A4B6C
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 11:57:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3BA73148832
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 10:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC633254BA;
	Thu, 26 Feb 2026 10:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BtdOjjra";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DhqTz4uK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BtdOjjra";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DhqTz4uK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6931931B104
	for <live-patching@vger.kernel.org>; Thu, 26 Feb 2026 10:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772103121; cv=none; b=hwUB3VD7JzBrLvUcE3hvfXvI/oDiZN9UKgQIozGHUgFkSkwNoUk6iTWNANjhSThUA1eqIS6/hDMByBd7AWR3dvu938AyvgVYQT+wcVzdVPsVyC5SkAJ9GEBs7Q3BcBlUHW5ziJmioC0WP4yeS3elNkXljNfeW9yX3PLNzINJY4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772103121; c=relaxed/simple;
	bh=OW9jBrw6UlKYAR5G6puvzpuBw0/LmaOaAW/CKdNUqyM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=h+y/UTjtQbJHYa8pbMgZMaPUMrBckaTS1IBYTdxavF88AVKscxnguFfyygijC4QOyAQ8SBhgHAP4lRmnJW56W89lwNu3O1z3307ydYrxHu9Vm9a23VlzvSPXJLtbm6BXE7DeATdj491H80+6mMNAIRiYcbrbfeBT+2Ubz5NBnQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BtdOjjra; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DhqTz4uK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BtdOjjra; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DhqTz4uK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 520E34D303;
	Thu, 26 Feb 2026 10:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772103113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YRTmkOMlRvhhgDm3Bj6NzrogGPyP1ivHOK1BORzlqgc=;
	b=BtdOjjraadHHE2MfRdYKt5HG/0XCy/7gvF0LZcjL4kHaN1Tt6bKh5irc2RaORfHXboV16u
	xxF+qxKEu5oImnDOksHvYI/FvCVXbWojJkbbl/+NFI7851GtL67QDYfXf4X+iD2F5ImvKN
	lXqgSuewnL7e/dwI2hIZ7kzS5VBQMVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772103113;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YRTmkOMlRvhhgDm3Bj6NzrogGPyP1ivHOK1BORzlqgc=;
	b=DhqTz4uKCAEP3eSHIhOvETTC7rBzH3h8/8JSfz88aECcECfsBsMqfHhsQHtcAfU6K3HJBg
	TKQb5nOTwm9ZGRDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772103113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YRTmkOMlRvhhgDm3Bj6NzrogGPyP1ivHOK1BORzlqgc=;
	b=BtdOjjraadHHE2MfRdYKt5HG/0XCy/7gvF0LZcjL4kHaN1Tt6bKh5irc2RaORfHXboV16u
	xxF+qxKEu5oImnDOksHvYI/FvCVXbWojJkbbl/+NFI7851GtL67QDYfXf4X+iD2F5ImvKN
	lXqgSuewnL7e/dwI2hIZ7kzS5VBQMVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772103113;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YRTmkOMlRvhhgDm3Bj6NzrogGPyP1ivHOK1BORzlqgc=;
	b=DhqTz4uKCAEP3eSHIhOvETTC7rBzH3h8/8JSfz88aECcECfsBsMqfHhsQHtcAfU6K3HJBg
	TKQb5nOTwm9ZGRDw==
Date: Thu, 26 Feb 2026 11:51:53 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Chen <chensong_2000@189.cn>
cc: Steven Rostedt <rostedt@goodmis.org>, mcgrof@kernel.org, 
    petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com, 
    atomlin@atomlin.com, mhiramat@kernel.org, mark.rutland@arm.com, 
    mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
    live-patching@vger.kernel.org
Subject: Re: [PATCH] kernel/trace/ftrace: introduce ftrace module notifier
In-Reply-To: <e18ed5f4-3917-46e7-bca9-78063e6e4457@189.cn>
Message-ID: <alpine.LSU.2.21.2602261147150.5739@pobox.suse.cz>
References: <20260225054639.21637-1-chensong_2000@189.cn> <20260225192724.48ed165e@fedora> <e18ed5f4-3917-46e7-bca9-78063e6e4457@189.cn>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-2146828000-1599428458-1772103001=:5739"
Content-ID: <alpine.LSU.2.21.2602261150450.5739@pobox.suse.cz>
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	CTYPE_MIXED_BOGUS(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[suse.cz];
	FREEMAIL_TO(0.00)[189.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+,1:+];
	TAGGED_FROM(0.00)[bounces-2089-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,189.cn:email]
X-Rspamd-Queue-Id: 937DB1A4B6C
X-Rspamd-Action: no action

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---2146828000-1599428458-1772103001=:5739
Content-Type: text/plain; CHARSET=ISO-2022-JP
Content-ID: <alpine.LSU.2.21.2602261150451.5739@pobox.suse.cz>

Hi,

+ Cc: live-patching@vger.kernel.org

On Thu, 26 Feb 2026, Song Chen wrote:

> Hi,
> 
> 在 2026/2/26 08:27, Steven Rostedt 写道:
> > On Wed, 25 Feb 2026 13:46:39 +0800
> > chensong_2000@189.cn wrote:
> > 
> >> From: Song Chen <chensong_2000@189.cn>
> >>
> >> Like kprobe, fprobe and btf, this patch attempts to introduce
> >> a notifier_block for ftrace to decouple its initialization from
> >> load_module.
> >>
> >> Below is the table of ftrace fucntions calls in different
> >> module state:
> >>
> >>  MODULE_STATE_UNFORMED	ftrace_module_init
> >>  MODULE_STATE_COMING	ftrace_module_enable
> >>  MODULE_STATE_LIVE	ftrace_free_mem
> >>  MODULE_STATE_GOING	ftrace_release_mod
> >>
> >> Unlike others, ftrace module notifier must take care of state
> >> MODULE_STATE_UNFORMED to ensure calling ftrace_module_init
> >> before complete_formation which changes module's text property.
> >>
> >> That pretty much remains same logic with its original design,
> >> the only thing that changes is blocking_notifier_call_chain
> >> (MODULE_STATE_GOING) has to be moved from coming_cleanup to
> >> ddebug_cleanup in function load_module to ensure
> >> ftrace_release_mod is invoked in case complete_formation fails.
> >>
> >> Signed-off-by: Song Chen <chensong_2000@189.cn>
> >> ---
> >>   kernel/module/main.c  | 14 ++++----------
> >>   kernel/trace/ftrace.c | 37 +++++++++++++++++++++++++++++++++++++
> >>   2 files changed, 41 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/kernel/module/main.c b/kernel/module/main.c
> >> index 710ee30b3bea..5dc0a980e9bd 100644
> >> --- a/kernel/module/main.c
> >> +++ b/kernel/module/main.c
> >> @@ -45,7 +45,6 @@
> >>   #include <linux/license.h>
> >>   #include <asm/sections.h>
> >>   #include <linux/tracepoint.h>
> >> -#include <linux/ftrace.h>
> >>   #include <linux/livepatch.h>
> >>   #include <linux/async.h>
> >>   #include <linux/percpu.h>
> >> @@ -836,7 +835,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *,
> >> name_user,
> >>    blocking_notifier_call_chain(&module_notify_list,
> >>    			     MODULE_STATE_GOING, mod);
> >>   	klp_module_going(mod);
> >> -	ftrace_release_mod(mod);
> > 
> > Is the above safe? klp uses ftrace. That means klp_module_going() may
> > need to be called before ftrace_release_mod(). That said, I wonder if
> > klp_module_going() could be moved into ftrace_release_mod()?
> > 
> >>   
> 
> I didn't test with klp, so i'm not sure if it's safe. But i consider klp is
> the other part which should be decoupled after ftrace and klp should introduce
> its own notifier.
> 
> If klp_module_going must be running before ftrace_release_mod, i can try to
> use priority in notifier_block to ensure their order.
> 
> Let me see if there is any way to use notifier and remain below calling
> sequence:
> 
> ftrace_module_enable
> klp_module_coming
> blocking_notifier_call_chain_robust(MODULE_STATE_COMING)
> 
> blocking_notifier_call_chain(MODULE_STATE_GOING)
> klp_module_going
> ftrace_release_mod

Both klp and ftrace used module notifiers in the past. We abandoned that 
and opted for direct calls due to issues with ordering at the time. I do 
not have the list of problems at hand but I remember it was very fragile.

See commits 7dcd182bec27 ("ftrace/module: remove ftrace module 
notifier"), 7e545d6eca20 ("livepatch/module: remove livepatch module 
notifier") and their surroundings.

So unless there is a reason for the change (which should be then carefully 
reviewed and properly tested), I would prefer to keep it as is. What is 
the motivation? I am failing to find it in the commit log.

Regards,
Miroslav
---2146828000-1599428458-1772103001=:5739--

