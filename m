Return-Path: <live-patching+bounces-1239-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC6DA47D69
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 13:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F57A7A9ABC
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 12:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30C822ACFB;
	Thu, 27 Feb 2025 12:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ip1Jz9Iu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="C7QCxcA5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ip1Jz9Iu";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="C7QCxcA5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE36022FF37
	for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 12:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740658213; cv=none; b=LQ+k6lMwkyg24ou8HZfqPSceIg6SnCgDpF9DUCo2REW+YOECXK8vaLoNB/DEJZUFS9QmdavsFNsBES9lxNX+/zlsHX9kVvynfO2T5ki4sBOEyxFivHhztFh5/eoCn0um9OpmhmH4fhNsDKeQ3E3gjXc37UZ5ZHl4Yg1QKJbzNXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740658213; c=relaxed/simple;
	bh=akxUv/7DKimh18nab4zYzcVHXlnTJtDLd+AduB8PjYI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ayLi87admEidNLS1KDzGMWoq6r9AsndH1BIvvdfNTv7RfAR/nioMNgmFLPnZoh5bvs+B+eMmkaQwOficemOLElu0UXsIu6OiZVjtaiIBGypRMCNPvmywqZx8g5eSfqFTsKaIeY5SqCWSgJWAlmMEurLiWMAq94CPkncP3Q8M798=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ip1Jz9Iu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=C7QCxcA5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ip1Jz9Iu; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=C7QCxcA5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E94921179;
	Thu, 27 Feb 2025 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740658210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pkh4hhvitVpN0mKPmW0tH5YxKInmBYciLZFphhKj924=;
	b=ip1Jz9IurwcOjzrHThzL3ETYe0y+abQ5eqK8IserEG6735aAbxFFnWlupVdUXOy+68ORds
	64sI995sqxExnQr92i6ZUDtqB82nigpXMfQIXwHXA1XOcwHYwp8b/3LW8oK2d6z2AVSryM
	yidfOTKEG5p8RLIwPbzY/wqQ9sOsHNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740658210;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pkh4hhvitVpN0mKPmW0tH5YxKInmBYciLZFphhKj924=;
	b=C7QCxcA51Gxrg6/yfdUJBm5QkTqTsKbY0IeIvcuSXc+YTJN9EynkZUmYBh5PTjxbe07otZ
	e9owObibSiKc5FBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1740658210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pkh4hhvitVpN0mKPmW0tH5YxKInmBYciLZFphhKj924=;
	b=ip1Jz9IurwcOjzrHThzL3ETYe0y+abQ5eqK8IserEG6735aAbxFFnWlupVdUXOy+68ORds
	64sI995sqxExnQr92i6ZUDtqB82nigpXMfQIXwHXA1XOcwHYwp8b/3LW8oK2d6z2AVSryM
	yidfOTKEG5p8RLIwPbzY/wqQ9sOsHNk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1740658210;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pkh4hhvitVpN0mKPmW0tH5YxKInmBYciLZFphhKj924=;
	b=C7QCxcA51Gxrg6/yfdUJBm5QkTqTsKbY0IeIvcuSXc+YTJN9EynkZUmYBh5PTjxbe07otZ
	e9owObibSiKc5FBw==
Date: Thu, 27 Feb 2025 13:10:10 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Weinan Liu <wnliu@google.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
    Indu Bhagat <indu.bhagat@oracle.com>, 
    Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
    roman.gushchin@linux.dev, Will Deacon <will@kernel.org>, 
    Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
    linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
    joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
    "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>, 
    Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: Re: [PATCH 7/8] arm64: Define TIF_PATCH_PENDING for livepatch
In-Reply-To: <20250127213310.2496133-8-wnliu@google.com>
Message-ID: <alpine.LSU.2.21.2502271308390.25291@pobox.suse.cz>
References: <20250127213310.2496133-1-wnliu@google.com> <20250127213310.2496133-8-wnliu@google.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.950];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[kernel.org,goodmis.org,oracle.com,infradead.org,arm.com,linux.dev,google.com,vger.kernel.org,redhat.com,lists.infradead.org,linux.microsoft.com,gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -4.29
X-Spam-Flag: NO

Hi,

> diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
> index b260ddc4d3e9..b537af333b42 100644
> --- a/arch/arm64/kernel/entry-common.c
> +++ b/arch/arm64/kernel/entry-common.c
> @@ -8,6 +8,7 @@
>  #include <linux/context_tracking.h>
>  #include <linux/kasan.h>
>  #include <linux/linkage.h>
> +#include <linux/livepatch.h>
>  #include <linux/lockdep.h>
>  #include <linux/ptrace.h>
>  #include <linux/resume_user_mode.h>
> @@ -144,6 +145,9 @@ static void do_notify_resume(struct pt_regs *regs, unsigned long thread_flags)
>  				       (void __user *)NULL, current);
>  		}
>  
> +		if (thread_flags & _TIF_PATCH_PENDING)
> +			klp_update_patch_state(current);
> +
>  		if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
>  			do_signal(regs);

Just a remark so that it is recorded. Once arm64 is moved to generic 
entry infra, the hunk will not be needed.

Regards,
Miroslav

