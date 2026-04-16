Return-Path: <live-patching+bounces-2363-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPQaI5XX4GlymgAAu9opvQ
	(envelope-from <live-patching+bounces-2363-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 14:35:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 456DC40E4A4
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 14:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7AC12301A527
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 12:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D1D3B8BCB;
	Thu, 16 Apr 2026 12:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMyIhcMB"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0703B7B84
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 12:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776342610; cv=none; b=GHk4c7VgiKpu/APjPUe8e6N+JhxEdPnqBYBRZdpVmFLr1mx87uBt1AVaztur48e08V/PWT6FwoqLuLpqnLdKzmfsWTMgsL0soBx+A42MWuLuMj1LDdK/bHl4HPo7d1Jc3jEs6/Rv6t2ieIbtRRg8TEdTynszWyyjEZU368nR5gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776342610; c=relaxed/simple;
	bh=K/4afwQ5p31SSvbXjWdzi0L0oqupXfEEFTghGQ4JcSM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/WT4z7UWPl5Q1qqoJ1FOVmxyg9rkph/NH8oiq3TItpJrVIf5wmqZ3OxN101Gt2HKYr7DyRymAO5n6dOeeV1QQ+PEj6NN21+Iwb5zcsZwrdO9cTDahRRflJ9BX+hIdWpXeWjtv/n05Bq5HRQHmda+Q7ly3TQst+dA63hHt/rV2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SMyIhcMB; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488ba6366a7so95599845e9.0
        for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 05:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776342607; x=1776947407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wD5n29vJmomxS6DITZYPjUM6os1Itf/93DfNIu2KPog=;
        b=SMyIhcMBhud7E9S0oZfY4dPtDZqiIEqLPYjB6s4KMU/0r83YLgF5ZbDmBOKyocj9ZY
         qrYE7AXH6tRIrCBZ2stUl3Qi0p1ekSMzV/bw635qeh1plkYWcNycJtCcJhUXvLmdYZkQ
         ak84/JBnez1KRfcmlMpgZ++CuFvu085GXxYYRhr73LFU4mA8rLyuOYJFvhMOOSuhDheC
         cVlzWB5L4UqeH/Dt9xlmzSUVQmUeJPE5kIcqSfdNeq+fT/ncidGLUeITziIc3LIGoSlb
         mIEymQGy7PCqcWSexrvq+2z77t5rI8LX0YHsKA3o8o949yKU9SPV8ckeT8kyG1heRNFK
         DfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776342607; x=1776947407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wD5n29vJmomxS6DITZYPjUM6os1Itf/93DfNIu2KPog=;
        b=cW0cHqvQIihkDVfc0epSieRmbwUc0y73JAWq0XlTsXEVdU4I3BEhTMtAUe1aMDkx38
         5JEleT99+0vpipOE6ZJtzQc+1m8jSzla8FjLN0QRNHHOHbNaNaUOkvCZc0adVGIACxXD
         Zii3/o/vE4Ir6mQ5SusOh0zWoRmHVPw1TQGopK8EW6UkWgPNdiVikvHim3GdBYOeAUv6
         pRcCd6b4hTuN3Qrxd60jMAUtgl6xofKK/DvR3K6EHqoiYVl52ZE7QaQBXSydtd4o3cJd
         tb4F7rGhdAg18bybAQnut/F6/Zx0D8C8aH/kzoMeE8VwEGGs4iMtt2FjORtIzK1kSq1O
         rmTQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rFUmgKAhrsvzvmJztOBopztB4ZkZOVzOq6Scnuk0G/KTaOVZQiKv1UBoKgwWbMBLojqDnKB63a5J3daXx@vger.kernel.org
X-Gm-Message-State: AOJu0YyURgu61RLF/fXoM2s451SBReklatmd7nA1k9jvEHSVMWaMa5lp
	kvIoV18vXgp4LdufE37jTIM6ap4t503HchDFZbOzhY2pgqBubTxBdNaI
X-Gm-Gg: AeBDiesHRH2FEty9ns0pQOePyETmOPsSvwY5/s8tlJX25psKENDSVJTGFmFOIItwK+5
	MbfvkRgUO6DhhGaCMGeDLjQMmv3nnJQJx1k0t+cronfGIq0KLf/1RlLvOVrzUKhiqAkf+TiQgRv
	olH88lw17jFD1ImdOFSfKISJF2y77o5AQx6b2w27QQW32lI0l1yDNb33wvJ8o8ax8DOoC2xTXNm
	UO0v/lLa+Io21kS0IozJ+cBYSYaBfSjWQ40xKDWHbTI7ocT48Tml5bsIbocaB9LR0PvFxYAvvHZ
	5yhU0HidZrEQ0DZXD7S3VIALiGeL2wFA8yhCEOTj+GRs93IQegPZcxZYriZqXJT8v8NKs8BnkTA
	QpxLPoH8H0ZCXvjhYx9jo2KwV8DRiVv5WSntQIIlUekct8YrgK0lWsmZnZnYhuNyNCX929Z3c0J
	N1U7hju+R5U7b0eOo4Vn2qZ/PV8ZWD84jipd9TjcNiWBAJV0RFYE0liRankG2JWY7r
X-Received: by 2002:a05:600c:45ce:b0:485:3e19:9e01 with SMTP id 5b1f17b1804b1-488d6890c9dmr355637165e9.28.1776342606991;
        Thu, 16 Apr 2026 05:30:06 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f0e9c668sm69981255e9.4.2026.04.16.05.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:30:06 -0700 (PDT)
Date: Thu, 16 Apr 2026 13:30:04 +0100
From: David Laight <david.laight.linux@gmail.com>
To: chensong_2000@189.cn
Cc: rafael@kernel.org, lenb@kernel.org, mturquette@baylibre.com,
 sboyd@kernel.org, viresh.kumar@linaro.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
 song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
 jason.wessel@windriver.com, danielt@kernel.org, dianders@chromium.org,
 horms@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, paulmck@kernel.org,
 frederic@kernel.org, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, atomlin@atomlin.com,
 jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
 live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
 netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list
 with double-linked list for reverse traversal
Message-ID: <20260416133004.07bd2886@pumpkin>
In-Reply-To: <20260415070137.17860-1-chensong_2000@189.cn>
References: <20260415070137.17860-1-chensong_2000@189.cn>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2363-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[189.cn];
	RCPT_COUNT_TWELVE(0.00)[48];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,189.cn:email]
X-Rspamd-Queue-Id: 456DC40E4A4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 15 Apr 2026 15:01:37 +0800
chensong_2000@189.cn wrote:

> From: Song Chen <chensong_2000@189.cn>
> 
> The current notifier chain implementation uses a single-linked list
> (struct notifier_block *next), which only supports forward traversal
> in priority order. This makes it difficult to handle cleanup/teardown
> scenarios that require notifiers to be called in reverse priority order.

If it is only cleanup/teardown then the list can be order-reversed
as part of that process at the same time as the list is deleted.

	David



