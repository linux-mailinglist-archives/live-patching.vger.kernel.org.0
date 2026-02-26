Return-Path: <live-patching+bounces-2093-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +HwPF3mSoGllkwQAu9opvQ
	(envelope-from <live-patching+bounces-2093-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 19:35:37 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F5E1ADC09
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 19:35:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BAECF3332360
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 17:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422E83290C7;
	Thu, 26 Feb 2026 17:29:58 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31CB3290B1;
	Thu, 26 Feb 2026 17:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772126998; cv=none; b=eipaFQDwBeRFaGqPwYDJgHFwFmlUkh7xDzkIJcXwrbnW4YpLJpz/cM0wMSnqNgJlmEi7E/MyG0YWQMp6XeJu0gwClZSOOylX3hJy2boKGcBkl0l9ngX5sfMwkH+y4OISHNf82lge9ia00Bksqbypzu+y7VJX8T9iw4jWue0rVKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772126998; c=relaxed/simple;
	bh=Myr1MgJF1JTxxCD/DbwmKCiYXCoYXn29daRv+/9+xJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3Rey2rFeDS5w/KuXjOkkKm2+U9M5xqhJ8GpmtJGxf+sbOc3Vene4ACvniWiLNqx+u2ZV3HY+XT4Zj1dWA4Gchct2qeTCmQoWA1/9b30dOnA8UBHdNBF+KKZYX3Ie1KnrxLbpQUyB1GcHNWCFIhomIEo2DG5/k3Jumhbrnibg+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C38CF1602DB;
	Thu, 26 Feb 2026 17:29:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id F129E2F;
	Thu, 26 Feb 2026 17:29:51 +0000 (UTC)
Date: Thu, 26 Feb 2026 12:30:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Song Chen <chensong_2000@189.cn>, mcgrof@kernel.org,
 petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
 atomlin@atomlin.com, mhiramat@kernel.org, mark.rutland@arm.com,
 mathieu.desnoyers@efficios.com, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 live-patching@vger.kernel.org
Subject: Re: [PATCH] kernel/trace/ftrace: introduce ftrace module notifier
Message-ID: <20260226123014.2197d9b7@gandalf.local.home>
In-Reply-To: <alpine.LSU.2.21.2602261147150.5739@pobox.suse.cz>
References: <20260225054639.21637-1-chensong_2000@189.cn>
	<20260225192724.48ed165e@fedora>
	<e18ed5f4-3917-46e7-bca9-78063e6e4457@189.cn>
	<alpine.LSU.2.21.2602261147150.5739@pobox.suse.cz>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 15hnzta5zitj3wgczi3cy1ygrsn5xmj4
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19+mxDP6FUS+yLtEo/J2xwBrefbLo6Tx5o=
X-HE-Tag: 1772126991-370274
X-HE-Meta: U2FsdGVkX1/8psOWJJHNRsApMdxdvPCxHHuKBX9HA8oaqHugRrFmAwGb4BvpfGwTA76WY5y1IVZ/le9ItCwt9n7jwy2Rkb6uzLDhmmoYo7PnEU+9DDLk+DHRXDuY5Lulbt3AF2/HxqYHaorQbEfHxSOyh+cv9ZIPj4mdZt2ibzKSD/r97PxsDwIbwEvI9cF9Lz8xnbeQwRhuQtnmz0uJ++h6p5i/y0jWEEUWgkteWXOB2himfptjTsBHyoB/K1hvm2ci4jWkXlSPRO3msm8mTsoJyp47jM2GugI07X6U/vVH8p9NIxSsv2AfO9PDnoPC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[goodmis.org : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[189.cn,kernel.org,suse.com,google.com,atomlin.com,arm.com,efficios.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2093-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rostedt@goodmis.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:email]
X-Rspamd-Queue-Id: 97F5E1ADC09
X-Rspamd-Action: no action

On Thu, 26 Feb 2026 11:51:53 +0100 (CET)
Miroslav Benes <mbenes@suse.cz> wrote:

> > Let me see if there is any way to use notifier and remain below calling
> > sequence:
> > 
> > ftrace_module_enable
> > klp_module_coming
> > blocking_notifier_call_chain_robust(MODULE_STATE_COMING)
> > 
> > blocking_notifier_call_chain(MODULE_STATE_GOING)
> > klp_module_going
> > ftrace_release_mod  
> 
> Both klp and ftrace used module notifiers in the past. We abandoned that 
> and opted for direct calls due to issues with ordering at the time. I do 
> not have the list of problems at hand but I remember it was very fragile.
> 
> See commits 7dcd182bec27 ("ftrace/module: remove ftrace module 
> notifier"), 7e545d6eca20 ("livepatch/module: remove livepatch module 
> notifier") and their surroundings.
> 
> So unless there is a reason for the change (which should be then carefully 
> reviewed and properly tested), I would prefer to keep it as is. What is 
> the motivation? I am failing to find it in the commit log.

Honestly, I do think just decoupling ftrace and live kernel patching from
modules is rationale enough, as it makes the code a bit cleaner. But to do
so, we really need to make sure there is absolutely no regressions.

Thus, to allow such a change, I would ask those that are proposing it, show
a full work flow of how ftrace, live kernel patching, and modules work with
each other and why those functions are currently injected in the module code.

As Miroslav stated, we tried to do it via notifiers in the past and it
failed. I don't want to find out why they failed by just adding them back
to notifiers again. Instead, the reasons must be fully understood and
updates made to make sure they will not fail in the future.

-- Steve

