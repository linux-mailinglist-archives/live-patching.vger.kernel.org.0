Return-Path: <live-patching+bounces-1432-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0AF6AB67FE
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 11:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 658504A4AA8
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 09:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C17525D8FB;
	Wed, 14 May 2025 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QkKLksqX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D3B253958
	for <live-patching@vger.kernel.org>; Wed, 14 May 2025 09:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747216311; cv=none; b=BmcnNDhwAK+VcS/Uv4WwZeccyMfPX/+8/Jx9t7hrRTuCuA6iflN24OrG+Kh7NnYRVyqzruwsJVL4pzQnMRMqdzumZ8Wxs0cAyp4W5HV7vt7+0Lo8mYy4AE64qQhfTg4iz1p8tlDO9pIZ59g0mE7A+IJSboeGXxKF3DVp505rGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747216311; c=relaxed/simple;
	bh=0UCu58qx5+r5o2FkoxTbEmZMlUiAS0WASZpHPgpTZJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4btbfTA/Wm1FPAuklMrQHIshONj0EaoanhJvpMWypsWPAq7Ywh4KlX6WN99pz96GVkVlig7pRN6HNZj8U64DqipuOvwwWlWzAkRw0Il5tEBUqxklYlOsxQDgWQ4QfkqOaTBHawTcIFp6JxOI5DtPibiO/rvOd57f+lXJHOR0Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QkKLksqX; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad21c5d9db2so884562066b.3
        for <live-patching@vger.kernel.org>; Wed, 14 May 2025 02:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1747216307; x=1747821107; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BVybws1t+U40/vbtZIfwab2hNrCdVfeHjc91VuDwjDg=;
        b=QkKLksqXEpMVIOBhNhrC+QEbTjfiONxRrVZwgNHrIAjEj87rzkusngGuuVit2oQV0n
         mQGMNkgLtJ2KYt+MgC6TyU/N723i4jTxgSE55mgaOJMx6Ee3vc7ufV5IHNVcWSuBDswo
         pEuXoBK84mROqaM5zCZ2O5dA4YNwbHIbxVFpz73NjsZoz90ATvZyexYxSTbtmxYzh8Op
         lisp7QGm3A3XPl+OjJecziEeM6jgVGElBe7xlPvhOyYh9OhOGaabR+Vta9XCLUS/pdej
         mlKQjJARDKunglS1Lvtvfn6yQ5d1CujD/2d8+nyy/3k0/2TcV3yHOk6UwHc5SBCtDy2+
         8AlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747216307; x=1747821107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVybws1t+U40/vbtZIfwab2hNrCdVfeHjc91VuDwjDg=;
        b=JJmKXKWwoA86sFH69tRlrx1jL+V3+9/NVSwkFH2FM3ugAnfWVxQU0RVwsE4yU3Aqrt
         00DnnBznDPcQj13AhbM1VQYkU7pcC/ynJkBLgyXZ3Q+Aj+Jc/uOhi0DWk45hoI80Aub+
         9OGE8WTmFtCZxVpVBKy1rWtIrHp+9jGyBDu0xdwDg1oZ1TiyS6O9MmUu5e9nrdEaS8Rb
         vTUbxNOcSITNJUzaxZjsakSSzbKHO5nJaiaTA8vRzv9nFWvFD8DPNI/tV3ETQPtbnYSF
         q3JrfzpsNSGawEmcGIKkwiI6DDVBh6FyEoYxLkZDk5O6RTR1nCA5MMOKNXlU8pMUlrsn
         Eydg==
X-Forwarded-Encrypted: i=1; AJvYcCWCX3KKFWqtEPJGsKU0QMk+/bY2hUdFBPT319NwyxqIfwQDGajrI+UXWLbROYqv/rwvIbQj5cwZCS6ILk1k@vger.kernel.org
X-Gm-Message-State: AOJu0YyiDl0CUW+K54L1Rf6pUHuB+RluEpt5kAN9olWwvtPJ6xYW82Xc
	Fit22qj3+XMdKqM0C5KnudtedDlX6Ch3g/G8ZgyFFXIf0BPZj7tVuwZvHlxgsCY=
X-Gm-Gg: ASbGncvfxKR0vTRpiD0EK5kDRbU/vuMs9RTmPxBiQQVys/iCmCfQ2A5PoW5jc3UdIBn
	6na4iIOTpLRmJWgnYlMBaQ8YY8UM6mANd/ZcmDaBfCHWexj0l/QR4oqUUvfp2zB7G4e+UfvflWA
	JJUBzU9wtYoaXMJKr5NJd+CfbaD9NZE0IxjOuTZXxXMw6qjtdGSGMuE9gIKYLHdiFUih8r1OZjf
	wvRgMdrzk/qqD54zG+ZQNcHnl5g+99YRrI7AyRwDN5hFEHrVyx7XJa2FFxsR73g6YHqJpKBgjNq
	OQBGkr/CVXFvfXmgUTkl2S92rtu7ULuQOEtlsEdHGCTfHPlkvr0k2A==
X-Google-Smtp-Source: AGHT+IGSd1rvJVl8u3DfNMX7dhF6Gp8/xiI2G+noTAd6SIJPTmFef2VtUgYEzSt6Qp8SoVIvBvzS5Q==
X-Received: by 2002:a17:907:9443:b0:ad2:1d1c:1c8e with SMTP id a640c23a62f3a-ad4f750e521mr279713966b.49.1747216307144;
        Wed, 14 May 2025 02:51:47 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad221288a91sm873089766b.15.2025.05.14.02.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 02:51:46 -0700 (PDT)
Date: Wed, 14 May 2025 11:51:44 +0200
From: Petr Mladek <pmladek@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@redhat.com>, mingo@kernel.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org,
	jikos@kernel.org, joe.lawrence@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] sched,livepatch: Untangle cond_resched() and
 live-patching
Message-ID: <aCRnsN-2x4vpjpCx@pathway.suse.cz>
References: <20250509113659.wkP_HJ5z@linutronix.de>
 <alpine.LSU.2.21.2505131529080.19621@pobox.suse.cz>
 <20250513140310.GA25639@noisy.programming.kicks-ass.net>
 <alpine.LSU.2.21.2505131604530.19621@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2505131604530.19621@pobox.suse.cz>

On Tue 2025-05-13 16:05:51, Miroslav Benes wrote:
> On Tue, 13 May 2025, Peter Zijlstra wrote:
> 
> > On Tue, May 13, 2025 at 03:34:50PM +0200, Miroslav Benes wrote:
> > > Hi,
> > > 
> > > thanks for the updated version.
> > > 
> > > On Fri, 9 May 2025, Sebastian Andrzej Siewior wrote:
> > > 
> > > > From: Peter Zijlstra <peterz@infradead.org>
> > > > 
> > > > With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> > > > needs to stop relying on cond_resched() to make forward progress.
> > > > 
> > > > Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> > > > live-patching, the freezer needs to be able to stop tasks in a safe /
> > > > known state.
> > > > 
> > > > Compile tested only.
> > > 
> > > livepatch selftests pass and I also ran some more.
> > >  
> > > > [bigeasy: use likely() in __klp_sched_try_switch() and update comments]
> > > > 
> > > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > > 
> > > Acked-by: Miroslav Benes <mbenes@suse.cz>
> > > 
> > > A nit below if there is an another version, otherwise Petr might fix it 
> > > when merging.
> > 
> > Petr or Peter?
> > 
> > That is, who are we expecting to merge this :-)
> 
> Petr Mladek if it goes through the live patching tree, you if tip. Feel 
> free to pick it up :).

IMHO, it might be easier when it goes via tip. Peter, feel free to
take it.

The patch does not create any conflict with the klp tree.
But I guess that there might be some dependent patches in tip...

That said, I could take it via the livepatch tree if Peter preferred
it from some reasons.

Anyway, the patch looks good and passes the tests. Feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

