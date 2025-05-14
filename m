Return-Path: <live-patching+bounces-1433-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A97AAB684A
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 12:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A34C1462040
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 09:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAD825DCE5;
	Wed, 14 May 2025 09:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PoXjZvsq";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="cOMfi0u5"
X-Original-To: live-patching@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E42525DD01;
	Wed, 14 May 2025 09:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747216788; cv=none; b=MhDAQvplJVQpSa9DJ4tJkf2VIdfnGp0RF+9kXLLL8XmQLKTuioefWkmYaY2uS46huLbLWeGqYbrzcZyfETI54ZrvkLSAPtx/vSBbz9wzmuvBc/WqFxPXo5w/FZgBJJruu8U5GDGKaneWyVOBqUF7ney0z7DQe9h9ox+oaaEhmOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747216788; c=relaxed/simple;
	bh=4XRz0KJkKBfN7JeqljSUgq0a9vhHb7LlFLvoSb4uhak=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MK0ZEvs2njMr9RhgdRWRMJCI2mNUWp/FzvvH3g4v7dySftaEA3LGKaXTXyGUb31UNsFzGPl5eQ4P0I1tr4xIbUNFSWargGOac7dHAr4LhOLJ7JF6yRpaNRI4azCR2o2sS+P3f2LvCcyX/F4NTTitG/NXBYkeMU8Wxf8Ox1Nm60M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PoXjZvsq; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=cOMfi0u5; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1747216785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4XRz0KJkKBfN7JeqljSUgq0a9vhHb7LlFLvoSb4uhak=;
	b=PoXjZvsqGsYnnAqMHpmDa3Fil1eJYKpZFSsPCPu/eZN+QlAmJE698JBnYLJopZReIjFqI2
	time4FO8cwIVdWwFWBKzHbFtdu3561ea5+g9i/AnR2ib+ENabD4imawgJe0buy8wKI58RV
	K6W2Z8et79ibqLnBLhDwGfqGG9gAOWF9tMbeyMTs4X8+XIqafybQxSYxyPP4kMpJYLU6Dv
	uVVp26FfryILPnffp9WzFk92rhmGPIfsA3kDa3LO/xQEXXg5ruLEM94RyubsGDxvJB8Uyv
	j7cT61Bq7uDU47rikoWUDWhoPPJez0ETHNvWuFX19uOqU+0nqE3aa6X3U6w2Yw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1747216785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4XRz0KJkKBfN7JeqljSUgq0a9vhHb7LlFLvoSb4uhak=;
	b=cOMfi0u5c2xEeAt9kse+jZb+DW1UksZoGLiD8e2gfQRy8nIQc0qQlGfI9lMSAHB05RKhf/
	bQrf3IH7itTUv+Cw==
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf
 <jpoimboe@redhat.com>, mingo@kernel.com, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com
Subject: Re: [PATCH v2] sched,livepatch: Untangle cond_resched() and
 live-patching
In-Reply-To: <20250509113659.wkP_HJ5z@linutronix.de>
References: <20250509113659.wkP_HJ5z@linutronix.de>
Date: Wed, 14 May 2025 11:59:45 +0200
Message-ID: <87tt5nikby.ffs@tglx>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 09 2025 at 13:36, Sebastian Andrzej Siewior wrote:
> From: Peter Zijlstra <peterz@infradead.org>
>
> With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> needs to stop relying on cond_resched() to make forward progress.
>
> Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> live-patching, the freezer needs to be able to stop tasks in a safe /
> known state.
>
> Compile tested only.
>
> [bigeasy: use likely() in __klp_sched_try_switch() and update comments]
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

