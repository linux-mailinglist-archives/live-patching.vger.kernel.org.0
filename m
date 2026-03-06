Return-Path: <live-patching+bounces-2147-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDgZCnilqml6UwEAu9opvQ
	(envelope-from <live-patching+bounces-2147-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 10:59:20 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4AA21E553
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 10:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EF72D306CDFE
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 09:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DBAA34F27F;
	Fri,  6 Mar 2026 09:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EOsxzA63"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1649D34F27D
	for <live-patching@vger.kernel.org>; Fri,  6 Mar 2026 09:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772791042; cv=none; b=tog7fVLSxQ4n6UNosXChUt3HumEDv2M/xghYTzPI06gjSKugH6O5IAtTUfGmx0XyVrKnnWyQzeZzulvhrV7+kMBTUHZKKraRrGiQOhlvP16AxOsSGIQbhqpOhUJCRa/8F2/F/56qLYzhc1YbQQnMiSujs5YhtouW0/URWKT9ZiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772791042; c=relaxed/simple;
	bh=pEQzWCAb2iRAqiobf7jxVYCtdRuojtFnQZa3BQ+Dyyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNETXjXwxOTRwyhy0izgf2kQmsgpxx0ZlCoYj6Nw7sF9Z1OmY1vPIjTj069TZCRYo0YB/FQePsaT8OViPdrXrJflfq/HdeCpl1kchPXBVAs5zA7K+DjRmyCEVQF5gz0HXFtJgoisZegMlqnuFjhNSA+Z++cc4Ac8NJ6l0UB6dRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EOsxzA63; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806ce0f97bso79364825e9.0
        for <live-patching@vger.kernel.org>; Fri, 06 Mar 2026 01:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772791035; x=1773395835; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O/K2aprkN4j5Qcb7Uph8KKaqrtRBJnLURcoh9D3mrUw=;
        b=EOsxzA63XzaseIkVZ6IrLdWGyCJaNf3twu9123Mtl4OPI8F4HlgxpeTUDbG8KmhtST
         F2YhOX4N///ZNqP/vH0J+ChwK7apappP2VS6FKF95kdzjFeb3eIg6Dc3uwe9cksVBblo
         Bco2ntcM6lmH0lhej+mRCnQ/12+V4dVodu/YXpS2b0vxwPnRiLFocVbbTu8uGJMvmDPw
         e28vjCtbCp5M9Y8N7t7s+ExpRU7tnImyBX0Mw8Ku3dvzWyypeRbVElXvm0gQ6IhzZrPC
         NTI/wAx+pRjlOUAxYebVAFUUqqu9MijnltA7jcVtyLyJSsPPwt7sL3OFKHrbnVMBghqv
         tO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772791035; x=1773395835;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/K2aprkN4j5Qcb7Uph8KKaqrtRBJnLURcoh9D3mrUw=;
        b=Y5ewP3bSPULUWOB/nCkrJ+A4dOzm7cyUo+Ae60IkGu7bpG1s+KoXeX4AE2SWBYKRcv
         PPX9LqrQ+62n/WbA+sBVsOWm9kfxfIls/lrr1TEblKJFk2oZUt38LuvZ0yBdyuz/oV4O
         UuKnjDybSSG+ysrvEMKX81xKkIALFlZhLt5QhWrNb7sU00Moa94BrjKesc7+6rU1U5cv
         Kuxp4HFIIqM/y3qmzVZjKfDSPh6r6DodSRuLffJu89TAkyBTtkW6UAnPqK0UjKTjPBJZ
         fbd6sZmSL+sVctBLHGN0Z6BdhD2z+bWHtkiyK92U/PV5ZQn6iHaY+cg2SBbkwj63t+p/
         Lygw==
X-Forwarded-Encrypted: i=1; AJvYcCVUiKZzkncU71drk5tx7M2HRTu69t2XVa1RU3UZPKtVzLOA+9oVMqMWzxKwMcSR2gE/yrObg0jZfDyiSXtx@vger.kernel.org
X-Gm-Message-State: AOJu0YwxinBA7JAkHn752Y8tUUK462nu56c30w1OkjqFnE7AtaW/oPw/
	dpQZbv1OjeAvKxhUzJRzTWftzn3og34Zu0Taif/y8Fc/Khed16lUvLaIgMgAZrGw/cM=
X-Gm-Gg: ATEYQzwUrUHuPhrP7Wp9QSXN1Yl9H/VVPaiy6xFAcTmdeQYjjEacM8KRzsADGAWMu/b
	M4q3Wsqq1Qe+g2wdD+g/36Up+CiqXGNOcJfL0hOaHuKEvYobC3hrv4bEkWbFFka6tP6i8qUpWCI
	AHk6BclRm85k8It4NmscHsrulVlIsTzJi5z7MKR/B6srBiXe6rnVmJGPraGPrA3uqg299/+fSRU
	796ihdm03IfnPk1kXW94ABIB3tv4YbraYign3rcT/jpnM3ayid6OHVJBrGAidgOCpAQC71fPhK7
	8wv+f9Y5Dc9Xfa/eOhir89C+kpT8bB6vhYlt6ig8ipAftfCepfRosnQV+dLd4e9lgs+6TlEW60Z
	fLSyCBn/7QBoeNbRG5PWaW8ZuCj+MvLHtKshnM+fx9HUA9WpyiFdrfkhDdqz2uTTKzZ9DTB1Vfc
	+/DsnpMPZvXUzNrnzcjuJiM1IT6g==
X-Received: by 2002:a05:600c:4e89:b0:45d:d97c:236c with SMTP id 5b1f17b1804b1-48526951430mr23896805e9.21.1772791035167;
        Fri, 06 Mar 2026 01:57:15 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485256b1eacsm24251685e9.0.2026.03.06.01.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 01:57:14 -0800 (PST)
Date: Fri, 6 Mar 2026 10:57:12 +0100
From: Petr Mladek <pmladek@suse.com>
To: Song Chen <chensong_2000@189.cn>
Cc: Steven Rostedt <rostedt@goodmis.org>, Miroslav Benes <mbenes@suse.cz>,
	mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
	samitolvanen@google.com, atomlin@atomlin.com, mhiramat@kernel.org,
	mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] kernel/trace/ftrace: introduce ftrace module notifier
Message-ID: <aaqk-GrpCTqO36xj@pathway.suse.cz>
References: <20260225054639.21637-1-chensong_2000@189.cn>
 <20260225192724.48ed165e@fedora>
 <e18ed5f4-3917-46e7-bca9-78063e6e4457@189.cn>
 <alpine.LSU.2.21.2602261147150.5739@pobox.suse.cz>
 <20260226123014.2197d9b7@gandalf.local.home>
 <321d4670-27cb-453f-a50d-426c83894074@189.cn>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <321d4670-27cb-453f-a50d-426c83894074@189.cn>
X-Rspamd-Queue-Id: 9C4AA21E553
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2147-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[189.cn];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[15];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Fri 2026-02-27 09:34:59, Song Chen wrote:
> Hi,
> 
> 在 2026/2/27 01:30, Steven Rostedt 写道:
> > On Thu, 26 Feb 2026 11:51:53 +0100 (CET)
> > Miroslav Benes <mbenes@suse.cz> wrote:
> > 
> > > > Let me see if there is any way to use notifier and remain below calling
> > > > sequence:
> > > > 
> > > > ftrace_module_enable
> > > > klp_module_coming
> > > > blocking_notifier_call_chain_robust(MODULE_STATE_COMING)
> > > > 
> > > > blocking_notifier_call_chain(MODULE_STATE_GOING)
> > > > klp_module_going
> > > > ftrace_release_mod
> > > 
> > > Both klp and ftrace used module notifiers in the past. We abandoned that
> > > and opted for direct calls due to issues with ordering at the time. I do
> > > not have the list of problems at hand but I remember it was very fragile.
> > > 
> > > See commits 7dcd182bec27 ("ftrace/module: remove ftrace module
> > > notifier"), 7e545d6eca20 ("livepatch/module: remove livepatch module
> > > notifier") and their surroundings.
> > > 
> > > So unless there is a reason for the change (which should be then carefully
> > > reviewed and properly tested), I would prefer to keep it as is. What is
> > > the motivation? I am failing to find it in the commit log.
> 
> There is no special motivation, i just read btf initialization in module
> loading and found direct calls of ftrace and klp, i thought they were just
> forgotten to use notifier and i even didn't search git log to verify, sorry
> about that.
> 
> > 
> > Honestly, I do think just decoupling ftrace and live kernel patching from
> > modules is rationale enough, as it makes the code a bit cleaner. But to do
> > so, we really need to make sure there is absolutely no regressions.
> > 
> > Thus, to allow such a change, I would ask those that are proposing it, show
> > a full work flow of how ftrace, live kernel patching, and modules work with
> > each other and why those functions are currently injected in the module code.
> > 
> > As Miroslav stated, we tried to do it via notifiers in the past and it
> > failed. I don't want to find out why they failed by just adding them back
> > to notifiers again. Instead, the reasons must be fully understood and
> > updates made to make sure they will not fail in the future.
> 
> Yes, you are right, i read commit msg of 7dcd182bec27, this patch just
> reverses it simply and will introduce order issue back. I will try to find
> out the problem in the past at first.

AFAIK, the root of the problem is that livepatch uses the ftrace
framework. It means that:

   + ftrace must be initialized before livepatch gets enabled
   + livepatch must be disabled before ftrace support gets removed

My understanding is that this can't be achieved by notifiers easily
because they are always proceed in the same order.

An elegant solution would be to introduce  notifier_reverse_call_chain()
which would process the callbacks in the reverse order. But it might
be non-trivial:

  + We would need to make sure that it does not break some
    existing "hidden" dependencies.

  + notifier_call_chain() uses RCU to process the list of registered
    callbacks. I am not sure how complicated would be to make it safe
    in both directions.

Best Regards,
Petr

