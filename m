Return-Path: <live-patching+bounces-1212-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A46A390D3
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 03:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B28A1892C85
	for <lists+live-patching@lfdr.de>; Tue, 18 Feb 2025 02:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBFDD286A1;
	Tue, 18 Feb 2025 02:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQBcyRSr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4559B749C
	for <live-patching@vger.kernel.org>; Tue, 18 Feb 2025 02:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739845208; cv=none; b=PRfrIemnZ2TNUZB1uJ8ZbkXTMfRyxThw2W8xevmhgkertI06RXyb/YUFw3b1SOyHouSfCxeTBDCl7mM2I7CTkD0Ae4MavWFdl6Ee/M0XUK7dyj+54lq/jueupibCFrvEzhk+UBu+hcf16brCD1SRvhu+Ntbl7Ny3KuvSvwTlphw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739845208; c=relaxed/simple;
	bh=C7ACUrkIhI5wnZ3fEfMxRxkIZa6mJ7QG5w2zHILgTTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a6tX0HWImJLDt0WE9Pu212/Htt5XxvIFrhofxvnoGsxaqYpRDisJ/2YobzzCL6GL+rmOjv7zyOmK7oPTPifVDBWhZs0Qu9ItDC04lbZvnlOK1qjWJQSLqFyv140CJcHwv1Gbqknq6OA5vs6vI6STwrXCzoYMKskXTLcGvtaMP8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VQBcyRSr; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6e17d3e92d9so43380316d6.1
        for <live-patching@vger.kernel.org>; Mon, 17 Feb 2025 18:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739845206; x=1740450006; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jBBI0K35+aw3lHRy5h4n6IEudXSZrBiPvWTU04Slm40=;
        b=VQBcyRSrfwu87/WrFtYjKwAAEnpMwRqQhBE/y0gew3bJb7c9ryaWhUjMc1Xgw2THOy
         4BBkFUbjt1tHY0A8Ajx1n6SSwQ1SVhrxCJs09mmTtS963cjeJKTWBUbihKMWC7pVHCIy
         r9ppmfp1RclJpZGiX7irbM48EsS1UMnIrFox4w5wsi9RYtRzubQVqkaiejRQuZLsYC0r
         8QYMKKKCcpBjbaZfAsfGAeR2NKiXB9szuAlsBtCg8QyZ09ILaY1atjhK8ONHF+wewENg
         SjPeGg+zejPUd/WkSuJVURnJ7JBir+A3X+h9fXFPXz3VDmItL017iuWPRoQV0zD3ygAa
         6HCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739845206; x=1740450006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jBBI0K35+aw3lHRy5h4n6IEudXSZrBiPvWTU04Slm40=;
        b=oKhiItQq/LLIzkop2Ojvr9s6LfID4DzY9fUoB/Z/XYGZT5yhhGZC72YNwBc1lj/lm2
         5y2p4oDm/bYaoqCICI29/YQuOnicOXtiAxeGwUycoBDG4I0swzIVfXbOOB/GyZMleETX
         OV0/zj9/rdPLdAXcCqurXvTfkFWWl7cwsO1W+p6sCR5g4ORG6ysYaBYH/s04UFsNuz/J
         xG59Qo+Vn2PVFdZhhAQnBgx2/J8CWrCL/KY8S5INTlHJ52HSBo9O1ktb8rmPGO8SNzvv
         v82Q6JSJJOXf7JwGljVK4XLJnrrDcecFYrXeJMoFTH6pCHoZ00GULIB8PXc7wKMcKSZY
         VCLA==
X-Forwarded-Encrypted: i=1; AJvYcCVA7CmXS423wLtww6DE5WDfroJ+toIdPUfq0y7Bq9cSaIDfsYaSLEOKujHoU81a6/+mxlMbuF/CtgfiJzn8@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3sPjztqbOgjUaEjNl5ZPWvLiMgkuRKhSQZEEdPC43yjdUk8bU
	k4hSOSsgNkD3MCFucvwPknr9dwfuwQyi5t/gJDqy+275cb/5+Hh7+yaNM1ms+CI8jM9GQBXk3ai
	8yr/cAK3L+fydmHPQMIJ2BW+q0Uc=
X-Gm-Gg: ASbGnct/uV/p0w+sYancRKBaC8cM/KucnpEJD7JiGbVrhxYCCHvDsqVk7t0pv3YGjcE
	gLBm6rJNHm5GwonGff3lj6Rr5odyqgkJfVez2HZ9XAqN0AuGfoNgA/0i2EFRVbeOrFosuVoYk
X-Google-Smtp-Source: AGHT+IGCfhxUDTUsTRnf4+HwpdmuK9qum7aCcHW9Wvt3U/8ykbJBUPrDUPMqPlqeynR97B5oz60+LUMWdkZx2rU1LjM=
X-Received: by 2002:a05:6214:c6c:b0:6e1:f40c:b558 with SMTP id
 6a1803df08f44-6e66cf420dfmr145473516d6.44.1739845206142; Mon, 17 Feb 2025
 18:20:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211062437.46811-1-laoar.shao@gmail.com> <20250211062437.46811-3-laoar.shao@gmail.com>
 <Z63VUsiaPsEjS9SR@pathway.suse.cz> <CALOAHbDEcUieW=AcBYHF1BUfQoAi540BNPEP5XR3CApu=3vMNQ@mail.gmail.com>
 <CALOAHbD+JYnC0fR=BaUvD9u0OitHM310ErzN8acPkFZZwH-dJQ@mail.gmail.com>
 <CALOAHbB46k0kqaH8BZk+iyL46bMbz03Z8sk7N+XuYM3kthTsNw@mail.gmail.com>
 <20250214083603.53roteiobbd5s4de@jpoimboe> <Z68q6TfUGpsmkHUD@pathway.suse.cz>
In-Reply-To: <Z68q6TfUGpsmkHUD@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 18 Feb 2025 10:19:30 +0800
X-Gm-Features: AWEUYZkxkCOTw_A_z93adS2IyWmKLnYD_u4PPksUWVxMlSN9ynRjJZs2PWO4ux4
Message-ID: <CALOAHbBeYA=QmDsCsi1mWyvpm0mbztq7MKMMD5ny_86WifeSTw@mail.gmail.com>
Subject: Re: Find root of the stall: was: Re: [PATCH 2/3] livepatch: Avoid
 blocking tasklist_lock too long
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 7:37=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Fri 2025-02-14 00:36:03, Josh Poimboeuf wrote:
> > On Fri, Feb 14, 2025 at 10:44:59AM +0800, Yafang Shao wrote:
> > > The longest duration of klp_try_complete_transition() ranges from 8.5
> > > to 17.2 seconds.
> > >
> > > It appears that the RCU stall is not only driven by num_processes *
> > > average_klp_try_switch_task, but also by contention within
> > > klp_try_complete_transition(), particularly around the tasklist_lock.
> > > Interestingly, even after replacing "read_lock(&tasklist_lock)" with
> > > "rcu_read_lock()", the RCU stall persists. My verification shows that
> > > the only way to prevent the stall is by checking need_resched() durin=
g
> > > each iteration of the loop.
> >
> > I'm confused... rcu_read_lock() shouldn't cause any contention, right?
> > So if klp_try_switch_task() isn't the problem, then what is?
>
> I agree that it does not make much sense.

I'm confused too and trying to understand it better.

>
> > I wonder if those function timings might be misleading.  If
> > klp_try_complete_transition() gets preempted immediately when it
> > releases the lock, it could take a while before it eventually returns.
> > So that funclatency might not be telling the whole story.
>
> The scheduling might be an explanation.
>
> > Though 8.5 - 17.2 seconds is a bit excessive...
>
> If klp_try_complete_transition() scheduled out and we see this delay
> then the system likely had a pretty high load at the moment.
> Is it possible?

It appears to be workload-related. The RCU warning occurred at
specific time periods, likely due to certain workloads running at
those times, though I haven't confirmed it yet.

>
> Yafang, just to be sure. Have you seen these numbers with
> the original klp_try_complete_transition() code and with debug
> messages disabled?

Right. These RCU warnings appeared on our production servers without
any debugging enabled, and klp_try_complete_transition() hasn't
changed either.

>
> Or did you saw them with some extra debugging code or other
> modifications?

No, these are the default production settings as they originally were.

>
> Also just to be sure. Is this on bare metal?

Yes.

>
> Finally, what preemption mode are you using? Which CONFIG_PREEMPT*?

The preemption configuration is as follows:

CONFIG_PREEMPT_BUILD=3Dy
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=3Dy
CONFIG_PREEMPTION=3Dy
CONFIG_PREEMPT_DYNAMIC=3Dy
CONFIG_PREEMPT_RCU=3Dy
CONFIG_HAVE_PREEMPT_DYNAMIC=3Dy
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=3Dy
CONFIG_PREEMPT_NOTIFIERS=3Dy
# CONFIG_DEBUG_PREEMPT is not set
CONFIG_PREEMPTIRQ_TRACEPOINTS=3Dy
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set


> PS: JFYI, I have vacation the following week and won't have
>    access to mails...

Enjoy your holiday

--
Regards



Yafang

