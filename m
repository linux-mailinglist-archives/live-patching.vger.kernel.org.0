Return-Path: <live-patching+bounces-1063-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB4B4A1D719
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 14:46:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 459313A447A
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 13:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3A41FF1C5;
	Mon, 27 Jan 2025 13:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OVLLclLL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964131FDA84
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 13:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737985575; cv=none; b=uKhz/pe0iirs4TiLAe2BqDQb6KJqmaUWR9MXQqSMBaBuEwBPYs+hSo+xJAnpQhHXpUeeNKGMwB4H+vSRP1x3FiUfFqMovonXviRh8xdQnd8mluQEpmBApVNE5Wwo80y+HHZnM30Gsf+fNVglXt7xo+8aPOQ/pTI90Hv2oR38n0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737985575; c=relaxed/simple;
	bh=7RsaTiBPJFGfRDsPei14scgSRch6QhNcy9+wrnM/bJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sw1H8UsmXZX2l2lBH1bsaFsGBNSSZTSaWo4bJy3m1ENJ2SYDs0y1AZO3Z7aZUopRQPxsd2L/IUr7qZ6QTgQQ4zB87xW/iehoZC3NyUc1F9ykLWlqO+lO3DRRLaY9KwhSq++AUP83xUl6hFjxr58K73VxvTD4InvWq1NL4wv+IRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OVLLclLL; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ab34a170526so744074466b.0
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 05:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737985572; x=1738590372; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QgA+jhPoaB6UopiA2dnwfV9s+vayrM8epUivPe+KeK8=;
        b=OVLLclLLSAWn03VTBCRKgMzBqtTMgq6VaxpofQUhzNMmFql4cV9VftVffMUhxffGDz
         aD/5NjQhpp/wd09//BxOCwvl7GFQSbsgRuWDNMRaGBEzh6tTNIVHXU9dCq4FBv+izwB8
         QeU5uWIiAtKm4mvjG9Wx0cNbLHvK/XGOg5IF4VBCegFahqA1v8n9tIxS2P6gY/XMgC82
         gPZZ0yxuRVeBkWvnerDF9IY5ix9aKWHYdz3IftiumxkGrLTzK0tRSVyGQyB1syYC1MWc
         aoOd9Omves0KUdBaXbndK0tpuUUxtbpEAbM+7pzb22iPk4FgliB9vYJcUL9sQm4lsM3H
         NbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737985572; x=1738590372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QgA+jhPoaB6UopiA2dnwfV9s+vayrM8epUivPe+KeK8=;
        b=wHboU2g93HBUHUjtIoLs31UxUqApLil52Uy2e4dOzuxuSFM8ecMpJkY0n9tWBVM+94
         W6xfJC5cTg2fAcfx0PDJHsxfxlPebG7UuKv//Mu0pVLa4kFSM/gQ7VY5Sc574C+Sw8UJ
         p90N8PTXM6dVkpOJLa3o9CwVHF2O9C87nllY0yCR+6QuoGItusZYLStoeOOSSro6VpSl
         PNXCjlRqBskjPD+TlanPMTBUib1ksZQbY0DOIwtO1dlps5cXv/hk1E/SYQPdYwx4f4mT
         XHjqe7ytNwh1nEhvuiGqVkCC5P5Ag39KsQ77YNmYM0oXCPpPR+Jw9XX+qPzBFFfEeVbp
         dVew==
X-Forwarded-Encrypted: i=1; AJvYcCVq8ikUbcTAI0+2Q7MSeyOBuFliMhZEYVf3UoFuDtLVSF6rw9gymaGEWDI7zHiRC1r9q2XfK6c3a8qheubE@vger.kernel.org
X-Gm-Message-State: AOJu0YwsLf7zWB7ui1TFyX/VRi65t4BXJpZQyFFgtM9rIwsgAzBMwZ9n
	QheHtnxR73aV04Sjyfd7uUD0oqyXTQgFPmyJgIq6OBuvnqcXopgrHOxtzwlwROE=
X-Gm-Gg: ASbGncvt1w24diyon+puEFI1OFfzzbkEm7DBXz8Zw8v85T5hNaVUYFkq7dNYW3LFftr
	C1w4eTTCQ8Y38gOJw7hTCyeY1PCiLTWNLsgeGYboS03Z8+YHQi3hpMdD0oD10DdjSlz9XjXQnNo
	tGHjk/p2WYSCiSnT+bjsVIDCfKPeemJvnFWvQ1Ln7ALBmTXlf0ddQZOW0vUlBlguT5YEDjoz2Ul
	BR/UgAjxLGD+sxVtRCyRgy5fs0B3m9IKsusEgyzbqDUXiu2ic/ysEWZjuP5cpHDT05OxTsZwrIP
	Jib3BuA=
X-Google-Smtp-Source: AGHT+IFpP+WprrGt8pOi9On434eDQJtnLjlCQXP3IvnT73SfyycRykwTaB4RzGPd3QDd8SmzpifmzA==
X-Received: by 2002:a17:907:930b:b0:aa6:a9fe:46e5 with SMTP id a640c23a62f3a-ab38b3dae38mr4141599166b.53.1737985571826;
        Mon, 27 Jan 2025 05:46:11 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6956a0700sm323965666b.175.2025.01.27.05.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 05:46:11 -0800 (PST)
Date: Mon, 27 Jan 2025 14:46:09 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
Message-ID: <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
References: <20250127063526.76687-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127063526.76687-1-laoar.shao@gmail.com>

On Mon 2025-01-27 14:35:24, Yafang Shao wrote:
> The atomic replace livepatch mechanism was introduced to handle scenarios
> where we want to unload a specific livepatch without unloading others.
> However, its current implementation has significant shortcomings, making
> it less than ideal in practice. Below are the key downsides:
> 
> - It is expensive
> 
>   During testing with frequent replacements of an old livepatch, random RCU
>   warnings were observed:
> 
>   [19578271.779605] rcu_tasks_wait_gp: rcu_tasks grace period 642409 is 10024 jiffies old.
>   [19578390.073790] rcu_tasks_wait_gp: rcu_tasks grace period 642417 is 10185 jiffies old.
>   [19578423.034065] rcu_tasks_wait_gp: rcu_tasks grace period 642421 is 10150 jiffies old.
>   [19578564.144591] rcu_tasks_wait_gp: rcu_tasks grace period 642449 is 10174 jiffies old.
>   [19578601.064614] rcu_tasks_wait_gp: rcu_tasks grace period 642453 is 10168 jiffies old.
>   [19578663.920123] rcu_tasks_wait_gp: rcu_tasks grace period 642469 is 10167 jiffies old.
>   [19578872.990496] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is 10215 jiffies old.
>   [19578903.190292] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is 40415 jiffies old.
>   [19579017.965500] rcu_tasks_wait_gp: rcu_tasks grace period 642577 is 10174 jiffies old.
>   [19579033.981425] rcu_tasks_wait_gp: rcu_tasks grace period 642581 is 10143 jiffies old.
>   [19579153.092599] rcu_tasks_wait_gp: rcu_tasks grace period 642625 is 10188 jiffies old.
>   
>   This indicates that atomic replacement can cause performance issues,
>   particularly with RCU synchronization under frequent use.

Please, provide more details about the test:

  + List of patched functions.

  + What exactly is meant by frequent replacements (busy loop?, once a minute?)

  + Size of the systems (number of CPUs, number of running processes)

  + Were there any extra changes in the livepatch code code,
    e.g. debugging messages?


> - Potential Risks During Replacement 
> 
>   One known issue involves replacing livepatched versions of critical
>   functions such as do_exit(). During the replacement process, a panic
>   might occur, as highlighted in [0].

I would rather prefer to make the atomic replace safe. I mean to
block the transition until all exiting processes are not gone.

Josh made a good point. We should look how this is handled by
RCU, tracing, or another subsystems which might have similar
problems.


> Other potential risks may also arise
>   due to inconsistencies or race conditions during transitions.

What inconsistencies and race conditions you have in mind, please?


> - Temporary Loss of Patching 
> 
>   During the replacement process, the old patch is set to a NOP (no-operation)
>   before the new patch is fully applied. This creates a window where the
>   function temporarily reverts to its original, unpatched state. If the old
>   patch fixed a critical issue (e.g., one that prevented a system panic), the
>   system could become vulnerable to that issue during the transition.

This is not true!

Please, look where klp_patch_object() and klp_unpatch_objects() is
called. Also look at how ops->func_stack is handled in
klp_ftrace_handler().

Also you might want to read Documentation/livepatch/livepatch.rst


> The current atomic replacement approach replaces all old livepatches,
> even when such a sweeping change is unnecessary. This can be improved
> by introducing a hybrid mode, which allows the coexistence of both
> atomic replace and non atomic replace livepatches.
> 
> In the hybrid mode:
> 
> - Specific livepatches can be marked as "non-replaceable" to ensure they
>   remain active and unaffected during replacements.
> 
> - Other livepatches can be marked as "replaceable", allowing targeted
>   replacements of only those patches.

Honestly, I consider this as a workaround for a problem which should
be fixed a proper way.

The main advantage of the atomic replace is simplify the maintenance
and debugging. It reduces the amount of possible combinations. The
hybrid mode brings back the jungle.

Best Regards,
Petr

