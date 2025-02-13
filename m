Return-Path: <live-patching+bounces-1178-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C59A33DC1
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 12:21:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAACA7A2DAE
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 11:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1EB24293A;
	Thu, 13 Feb 2025 11:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SKOs4TpE"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5055A24292F
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 11:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739445592; cv=none; b=gHsTHBmDa4unwyiSJ8EWbvWPaHTUNYgH0E/NByjhM/VGAx/xpcZaZ/YpA3vRY7qQNKKfNdUOgyvl0sB1FxOarsTO3GaE0v9/bfl6vTS5mQaTaNhmcgn3G/kK3+FJwgGOKc46di0yKAvdoumgxmGQ8GXto/1FqNMcvdpsch4e+WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739445592; c=relaxed/simple;
	bh=G+77RdMFXgIUzQeSgVdU+fHSM4thrBl1ax5I3lUWc48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RO6TGf5ho8yxaSa0apPscHppyZCYLYPfKV5kV+y1rWrVEYYCsWZLNBx/e64fqrakRmKyqZeMZTIr5g9Ht7RFuRpwQRtuFQWPvz/elV4DdnDeJe8OFXxBbkO838cpUsx0EFWtEFmIei/0nkV+O70klqHt97KD3eG0y8MmUc+nqmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SKOs4TpE; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d9837f201aso3846480a12.0
        for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 03:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739445588; x=1740050388; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M44zOxS3UArNnzdk9TdZsnHKBY9B2Jpnt5zeVE8A1Ew=;
        b=SKOs4TpEzPX3/zew6rcJwHTnCjqMhdi7GS/O0L4/0ZgArJ4tyIbF+AbEUXvvVRTgYj
         4cEwiB0MI4D84LuZJzwt2v8xV4iARLDB6pNpXgE890MJJDahT90rbC6ubt2f3Ww7tDcG
         0GB3MJCqior00AT5K4cOZ54oUacI4jdg+CtuzTZZ3PikcJBu0z3PSF7j8dQ+57AOKQ4E
         IXHvpyGeDgAGeG3wE0XmaoKOgmMme8B2fztuNCtaONepu0X+lfRoH6HMVzQapV56mIYo
         DPzgAJk2T8huqmGNeLUrPNvcYmqxuqStJF8HqkyRFt2DIzymhFOjZATq15ooJxVHHufN
         E8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739445588; x=1740050388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M44zOxS3UArNnzdk9TdZsnHKBY9B2Jpnt5zeVE8A1Ew=;
        b=i1MV6PHEeGCFQLEalQhW0VSeHLQYqD0Jp9CmO++u6O12MCPN2VPGePx3+11u2jCtq7
         GOgcgtDHdfVPhJqujWwMEgTuzXN4qIO1gNwC1P4z72iRDavaCfP1V+ymiDOxIfBiTvIa
         2CcOgJeyHaRKLhQeQ6wsqqy2W9qtUPIAgPpekrHx//YAKAJZB2mZOhjWlv9UII60MwHj
         eOhY5MaKSbRZlUFi+vF7wtaKsBorLRHVqqj1kSJQtlWwBhPkY4+1gqdzcX6116qf6Yd3
         y2hXb17E9GMtbpAR9N65h18h6PIWVua4j0zKAeLpHFMqt/x4pN0dnGQD0ZOrxO0MwbqB
         Kpfg==
X-Forwarded-Encrypted: i=1; AJvYcCUXfy6nKWAu2IfAMzzBGKu3mDxDPFP8lNkFQZoXLclT7AL5uGVPzrGxsDEJj9ijJJS3teQlU6M6tWgiZZAM@vger.kernel.org
X-Gm-Message-State: AOJu0YyJT1Q6kAUtfnzNfyQgBJRP97AF41k3W3BLQAENamHMcLkkRwYG
	twtuzV/TgT26G2wd6o/cQaI4FesDOwRw6gfemGAZGKAx8oQD37qljJbkVevtGhU=
X-Gm-Gg: ASbGncsqXuNdYR5L5EEGD5hmDkrFXbFYO/YV2viNNURNoiIMmgisnQdzpykWSH68TNL
	j4/SO5pzQPh3szbeXOUKC5df/jq/NpF0n/rinUdYZ1uGO6AgDj5qNs+iZk3Sut1C5E7+0qfJ+r/
	IrCv2n6FRatRRlICIcg1PgUUlkbje1G2+/N/8CY9I7855ikcoNP2P2UsgtyZMMwhXiBDsnNh8mK
	P1Id97J/02CJLmACwThMQFHpPh01+qv1glWqRrKSqXohfigt27Er7jhhFnKEClNtS7UBu0nt/RS
	ZX2q3Xw3CI2AczrrzA==
X-Google-Smtp-Source: AGHT+IGuwS6IAyPvMIXbStunxckAhW+tZR/PQvg8h8VjCAN/guxTGyPUNsYWTJV0BNoxiyph9gUioA==
X-Received: by 2002:a17:907:7e8e:b0:ab3:61e2:8aaf with SMTP id a640c23a62f3a-aba510de0a8mr256296766b.25.1739445588556;
        Thu, 13 Feb 2025 03:19:48 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba53231f4dsm111990066b.23.2025.02.13.03.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 03:19:48 -0800 (PST)
Date: Thu, 13 Feb 2025 12:19:46 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Find root of the stall: was: Re: [PATCH 2/3] livepatch: Avoid
 blocking tasklist_lock too long
Message-ID: <Z63VUsiaPsEjS9SR@pathway.suse.cz>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211062437.46811-3-laoar.shao@gmail.com>

On Tue 2025-02-11 14:24:36, Yafang Shao wrote:
> I encountered a hard lockup when attempting to reproduce the panic issue
> occurred on our production servers [0]. The hard lockup is as follows,
> 
> [15852778.150191] livepatch: klp_try_switch_task: grpc_executor:421106 is sleeping on function do_exit
> [15852778.169471] livepatch: klp_try_switch_task: grpc_executor:421244 is sleeping on function do_exit
> [15852778.188746] livepatch: klp_try_switch_task: grpc_executor:421457 is sleeping on function do_exit
> [15852778.208021] livepatch: klp_try_switch_task: grpc_executor:422407 is sleeping on function do_exit
> [15852778.227292] livepatch: klp_try_switch_task: grpc_executor:423184 is sleeping on function do_exit
> [15852778.246576] livepatch: klp_try_switch_task: grpc_executor:423582 is sleeping on function do_exit
> [15852778.265863] livepatch: klp_try_switch_task: grpc_executor:423738 is sleeping on function do_exit
> [15852778.285149] livepatch: klp_try_switch_task: grpc_executor:423739 is sleeping on function do_exit
> [15852778.304446] livepatch: klp_try_switch_task: grpc_executor:423833 is sleeping on function do_exit
> [15852778.323738] livepatch: klp_try_switch_task: grpc_executor:423893 is sleeping on function do_exit
> [15852778.343017] livepatch: klp_try_switch_task: grpc_executor:423894 is sleeping on function do_exit
> [15852778.362292] livepatch: klp_try_switch_task: grpc_executor:423976 is sleeping on function do_exit
> [15852778.381565] livepatch: klp_try_switch_task: grpc_executor:423977 is sleeping on function do_exit
> [15852778.400847] livepatch: klp_try_switch_task: grpc_executor:424610 is sleeping on function do_exit

This message does not exist in vanilla kernel. It looks like an extra
debug message. And many extra messages might create stalls on its own.

AFAIK, your reproduced the problem even without these extra messages.
At least, I see the following at
https://lore.kernel.org/r/CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M0zgdXg@mail.gmail.com

<paste>
[20329703.332453] livepatch: enabling patch 'livepatch_61_release6'
[20329703.340417] livepatch: 'livepatch_61_release6': starting
patching transition
[20329715.314215] rcu_tasks_wait_gp: rcu_tasks grace period 1109765 is
10166 jiffies old.
[20329737.126207] rcu_tasks_wait_gp: rcu_tasks grace period 1109769 is
10219 jiffies old.
[20329752.018236] rcu_tasks_wait_gp: rcu_tasks grace period 1109773 is
10199 jiffies old.
[20329754.848036] livepatch: 'livepatch_61_release6': patching complete
</paste>

Could you please confirm that this the original _non-filtered_ log?
I mean that the debug messages were _not_ printed and later filtered?

I would like to know more about the system where RCU reported the
stall. How many processes are running there in average?
A rough number is enough. I wonder if it is about 1000, 10000, or
50000?

Also what is the CONFIG_HZ value, please?

Also we should get some statistics how long klp_try_switch_task()
lasts in average. I have never did it but I guess that
it should be rather easy with perf. Or maybe just by looking
at function_graph trace.

I would like to be more sure that klp_try_complete_transition() really
could block RCU for that long. I would like to confirm that
the following is the reality:

  num_processes * average_klp_try_switch_task > 10second

If it is true than we really need to break the cycle after some
timeout. And rcu_read_lock() is _not_ a solution because it would
block RCU the same way.

Does it make sense, please?

Best Regards,
Petr

